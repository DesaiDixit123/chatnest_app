import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:audioplayers/audioplayers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallController extends GetxController {
  AudioCallController(this.audioCallPresenter, {required this.api});

  final AudioCallPresenter audioCallPresenter;
  /// backend userId -> user info waiting for Agora uid assignment
  final Map<String, AgoraUser> queuedRemoteMembersById = {};
  final List<String> queuedRemoteMemberOrder = [];
  final List<PendingInvitee> pendingInvitees = [];

  /// backend userId -> user info (used for mapping Agora UID to backend user ID)
  final Map<String, Map<String, String>> callMembersMap = {};
  
  bool? isSelfCall;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is List) {
      userImage = args.length > 4 ? args[4] ?? "" : "";
      userName = args.length > 5 ? args[5] ?? "User" : "User";
      isCall = args.length > 6 ? args[6] ?? false : false;
      callId = args.length > 2 ? args[2] ?? "" : "";
      isSelfCall = args.length > 6 ? args[6] ?? false : false;
    } else {
      userImage = "";
      userName = "User";
      isCall = false;
      isSelfCall = false;
    }

    if (isCall) {
      Utility.audioPlayer
          .play(AssetSource('images/instagram_outgoing_cal.mp3'));
    }

    super.onInit();
  }

  String? userImage;
  int counter = 30;
  Timer? timer;
  Timer? callDurationTimer;
  bool isCall = false;
  bool isCallConnected = false;
  bool _isAutoEndingCall = false;
  String userName = "User";
  Duration callDuration = Duration.zero;

  String callId = "";

  String _preferredName(dynamic fullname, dynamic nickname) {
    final full = (fullname ?? "").toString().trim();
    if (full.isNotEmpty) {
      return full.split(RegExp(r'\s+')).first;
    }
    final nick = (nickname ?? "").toString().trim();
    return nick.isEmpty ? "User" : nick;
  }

  void startTimer() {
    const oneSec = Duration(seconds: 30);
    timer = Timer(
      oneSec,
      () async {
        postChatMissedCall(callId);
        await disposeAgora();
      },
    );
  }

  int get remoteParticipantsCount =>
      users.where((u) => u.uid != currentUid).length;

  String get callStatusText {
    if (!isCallConnected) {
      return "Ringing...";
    }
    final minutes =
        callDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        callDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _startCallDurationTimer() {
    if (isCallConnected) {
      return;
    }
    isCallConnected = true;
    
    final callManager = Get.find<CallManagerService>();
    if (callManager.connectedAt.value == null) {
      callManager.connectedAt.value = DateTime.now();
      callDuration = Duration.zero;
    } else {
      callDuration = DateTime.now().difference(callManager.connectedAt.value!);
    }

    callDurationTimer?.cancel();
    callDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration += const Duration(seconds: 1);
      update();
    });
    update();
  }

  void _stopCallDurationTimer({bool reset = false}) {
    callDurationTimer?.cancel();
    callDurationTimer = null;
    isCallConnected = false;
    if (reset) {
      callDuration = Duration.zero;
    }
    update();
  }

  RtcEngine? agoraEngine;
  final users = <AgoraUser>{};
  late double viewAspectRatio;
  int? currentUid;
  bool isMicEnabled = false;
  bool isVideoEnabled = false;
  bool isSpeaker = true;

  String appId = "";
  String token = "";
  String channelName = "";
  bool isMic = true;
  bool isVideo = true;

  Future<void> disposeAgora() async {
    Utility.audioPlayer.pause();
    timer?.cancel();
    _stopCallDurationTimer(reset: true);
    users.clear();
    pendingInvitees.clear();
    queuedRemoteMembersById.clear();
    queuedRemoteMemberOrder.clear();
    // We do NOT release the engine here anymore, it stays in CallManagerService
  }

  Future<void> _endCallGlobally() async {
    Utility.audioPlayer.pause();
    timer?.cancel();
    _stopCallDurationTimer(reset: true);
    users.clear();
    
    if (callId.isNotEmpty) {
      await postChatLeaveCall(callId);
    }
    
    // Explicitly release engine and clear state
    await Get.find<CallManagerService>().endCall();
  }

  Future<void> _autoLeaveIfAlone() async {
    if (_isAutoEndingCall) {
      return;
    }
    _isAutoEndingCall = true;
    try {
      if (callId.isNotEmpty) {
        await postChatLeaveCall(callId);
      }
      await Get.find<CallManagerService>().endCall();
    } finally {
      _isAutoEndingCall = false;
    }
  }

  void cacheCallMembers(List members) {
    for (final m in members) {
      final user = m["memberid"];
      if (user == null) {
        continue;
      }
      final userId = (user["_id"] ?? "").toString();
      if (userId.isEmpty) {
        continue;
      }
      
      final uid = _generateNumericUid(userId);
      callMembersMap[userId] = {
        "name": _preferredName(user["fullname"], user["nickname"]),
        "image": (user["profileimage"] ?? "").toString(),
        "uid": uid.toString(),
      };

      final status = (m["status"] ?? "").toString().toLowerCase();
      if (status == "ringing") {
        pendingInvitees.add(
          PendingInvitee(
            userId: userId,
            name: _displayFirstName(user["fullname"] ?? user["nickname"]),
            status: "Ringing",
            uid: uid,
          ),
        );
      } else {
        pendingInvitees.removeWhere((element) => element.userId == userId);
      }
    }
    update();
  }

  String _displayFirstName(String? name) {
    final cleaned = (name ?? "").trim();
    if (cleaned.isEmpty) {
      return "User";
    }
    return cleaned.split(RegExp(r'\s+')).first;
  }

  void _addPendingInvitee(String userId, String name) {
    final exists = pendingInvitees.any((e) => e.userId == userId);
    if (exists) {
      return;
    }
    pendingInvitees.add(
      PendingInvitee(
        userId: userId,
        name: _displayFirstName(name),
        status: "Ringing",
      ),
    );
    update();
  }

  void _removePendingInviteeByUserId(String? userId) {
    if (userId != null && userId.trim().isNotEmpty) {
      pendingInvitees.removeWhere((e) => e.userId == userId);
    } else if (pendingInvitees.isNotEmpty) {
      pendingInvitees.removeAt(0);
    }
    update();
  }

  Future<void> initialize() async {
    print("[ANTIGRAVITY_DEBUG] AudioController initialize()");
    print("[ANTIGRAVITY_DEBUG] Token: $token");
    print("[ANTIGRAVITY_DEBUG] Channel: $channelName");

    // 🔴 ANTIGRAVITY FIX: Fetch token if missing
    // ALWAYS Fetch member info to populate names/images/hashes
    if (callId.isNotEmpty) {
      try {
        var response = await audioCallPresenter.postChatJoinCall(
          callid: callId,
          isLoading: false,
        );

        if (response != null && response.statusCode == 200) {
          print("[ANTIGRAVITY_DEBUG] ✅ Successfully fetched call details for resolution");
          var jsonData = jsonDecode(response.data);

          if (jsonData['Data'] != null) {
            final callData = jsonData['Data'];
            
            // Cache all members for name/image resolution
            if (callData['members'] != null) {
              cacheCallMembers(callData['members']);
            }

            // Fallback for token/channel if missing from arguments
            var agoraMeta = callData['agorameta'];
            String? extractedToken;
            String? extractedChannel;

            if (agoraMeta != null) {
              extractedToken = agoraMeta['token'];
              extractedChannel = agoraMeta['channelName'];
            } else {
              extractedToken = callData['agoratoken'];
              extractedChannel = callData['agorachannelName'];
            }

            if (token.isEmpty || token == "null") {
              if (extractedToken != null && extractedToken.toString().isNotEmpty) {
                token = extractedToken.toString();
              }
            }

            if (channelName.isEmpty || channelName == "null") {
              if (extractedChannel != null && extractedChannel.toString().isNotEmpty) {
                channelName = extractedChannel.toString();
              }
            }

            // Sync legacy userName/userImage for UI fallbacks
            final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
            final from = callData['from'];
            final toUser = callData['touser'];
            final fromId = (from?['_id'] ?? "").toString();
            final isCurrentFrom = currentUserId.isNotEmpty && fromId.isNotEmpty && currentUserId == fromId;
            final remoteUser = isCurrentFrom ? toUser : from;
            if (remoteUser != null) {
              userName = _preferredName(remoteUser['fullname'], remoteUser['nickname']);
              userImage = (remoteUser['profileimage'] ?? "").toString();
            }
          }
        }
      } catch (e) {
        print("[ANTIGRAVITY_DEBUG] ❌ Exception fetching members: $e");
      }
    }

    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      viewAspectRatio = 2 / 3;
    } else {
      viewAspectRatio = 3 / 2;
    }

    isMicEnabled = isMic;
    isVideoEnabled = isVideo;
    update();
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    final callManager = Get.find<CallManagerService>();
    bool wasAlreadyActive = callManager.isCallActive && callManager.activeChannelName.value == channelName;

    if (!wasAlreadyActive) {
      await agoraEngine?.joinChannel(
        token: token,
        channelId: channelName,
        uid: _generateNumericUid(Utility.profileData?.id ?? "0"),
        options: ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
          publishMicrophoneTrack: isMicEnabled,
          publishCameraTrack: isVideoEnabled,
        ),
      );
    } else {
      print("[ANTIGRAVITY_DEBUG] Re-attaching to existing call session");
      // Even if already active, we want to ensure the currentUid is set for the new screen
      currentUid = _generateNumericUid(Utility.profileData?.id ?? "0");
      // If we are re-attaching, we might already have users.
      // CallManager doesn't store users list, but the Agora event handlers will re-populate it as data flows.
    }

    // Register with CallManagerService
    callManager.registerCall(
      type: CallType.audio,
      channelName: channelName,
      callId: callId,
      token: token,
      isHost: isSelfCall ?? false,
      userName: userName,
      userImage: userImage ?? "",
    );

    // If already connected in background, restore the timer immediately
    if (callManager.connectedAt.value != null) {
      _startCallDurationTimer();
    }
  }

  int _generateNumericUid(String str) {
    if (str.trim().isEmpty) return 0;
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      int char = str.codeUnitAt(i);
      // Precise 32-bit signed wrap, then unsigned 32-bit conversion to match JS (hash >>> 0)
      hash = (31 * hash + char).toSigned(32);
    }
    return hash & 0xFFFFFFFF;
  }

  Future<void> _initAgoraRtcEngine() async {
    final callManager = Get.find<CallManagerService>();
    if (callManager.agoraEngine != null) {
      agoraEngine = callManager.agoraEngine;
      return;
    }

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine?.initialize(const RtcEngineContext(
      appId: '0bacf816c87b4b4799c3e59f09f415c2',
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));
    await agoraEngine?.enableAudio();
    await agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    
    callManager.agoraEngine = agoraEngine;
  }

  void _addAgoraEventHandlers() => agoraEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onError: (err, msg) {
            final info = 'LOG::onError: $err';
            debugPrint(info);
          },
          onJoinChannelSuccess: (connection, elapsed) {
            currentUid = connection.localUid;

            users.add(
              AgoraUser(
                uid: connection.localUid ?? 0,
                name: _preferredName(
                  Utility.profileData?.fullname,
                  Utility.profileData?.nickname,
                ),
                bannerImg: Utility.profileData?.profileimage,
                isAudioEnabled: isMicEnabled,
              ),
            );
            Future.delayed(const Duration(milliseconds: 200), () async {
              try {
                await agoraEngine?.setEnableSpeakerphone(true);
                isSpeaker = true;
                update();
              } catch (e) {
                debugPrint("Speaker init safe skip: $e");
              }
            });

            update();
          },
          onFirstLocalAudioFramePublished: (connection, elapsed) {
            final info = 'LOG::firstLocalAudio: $elapsed';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user.isAudioEnabled = isMicEnabled;
                update();
              }
            }
          },
          onFirstLocalVideoFrame: (connection, width, height, elapsed) {
            debugPrint('LOG::firstLocalVideo');
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user.isVideoEnabled = isVideoEnabled;
                update();
              }
            }
          },
          onLeaveChannel: (connection, stats) {
            debugPrint('LOG::onLeaveChannel');
            _stopCallDurationTimer(reset: true);
            users.clear();
            update();
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (users.any((u) => u.uid == remoteUid)) {
              return;
            }
            timer?.cancel();
            Utility.audioPlayer.stop();

            String resolvedName = "User";
            String resolvedBanner = "";

            // Direct Lookup in callMembersMap
            String? foundUserId;
            callMembersMap.forEach((key, value) {
              if (value['uid'] == remoteUid.toString()) {
                foundUserId = key;
                resolvedName = value['name'] ?? "User";
                resolvedBanner = value['image'] ?? "";
              }
            });

            if (foundUserId != null) {
              print("[ANTIGRAVITY_DEBUG] Resolved remote user via UID map: $resolvedName ($remoteUid)");
              _removePendingInviteeByUserId(foundUserId);
            } else {
              print("[ANTIGRAVITY_DEBUG] Could not resolve remote user via UID map for $remoteUid. Using fallback.");
              // Fallback for 1-to-1 calls where members list might be sparse or if joining logic is old
              final existingRemoteCount = users.where((u) => u.uid != currentUid).length;
              if (existingRemoteCount == 0) {
                resolvedName = userName.trim().isEmpty ? "User" : userName.trim();
                resolvedBanner = userImage ?? "";
              }
            }

            users.add(
              AgoraUser(
                uid: remoteUid,
                name: resolvedName,
                bannerImg: resolvedBanner,
                isAudioEnabled: true,
              ),
            );

            if (remoteParticipantsCount > 0) {
              _startCallDurationTimer();
            }
            update();
          },
          onUserOffline: (connection, remoteUid, reason) {
            final info = 'LOG::userOffline: $remoteUid';
            debugPrint(info);
            AgoraUser? userToRemove;
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                userToRemove = user;
              }
            }
            users.remove(userToRemove);
            if (remoteParticipantsCount == 0) {
              _stopCallDurationTimer();
              _autoLeaveIfAlone();
            }
            update();
          },
          onFirstRemoteAudioFrame: (connection, remoteUid, elapsed) {
            final info = 'LOG::firstRemoteAudio: $remoteUid';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isAudioEnabled = true;
                update();
              }
            }
          },
          onRemoteAudioStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
            final info =
                'LOG::remoteAudioStateChanged: $remoteUid $state $reason';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isAudioEnabled =
                    state != RemoteAudioState.remoteAudioStateStopped;
                update();
              }
            }
          },
        ),
      );

  Future<void> onCallEnd(
      BuildContext context, AudioCallController controller) async {
    if ((isSelfCall ?? false) && callId.isNotEmpty) {
      SocketConnection.socket?.emit("call-cancelled", {"callId": callId});
    }
    
    await _endCallGlobally();

    if (context.mounted) {
      Get.back();
    }
  }

  void onToggleAudio() {
    isMicEnabled = !isMicEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid) {
        user.isAudioEnabled = isMicEnabled;
      }
    }
    agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    update();
  }

  void switchSpeakerphone() async {
    try {
      isSpeaker = !isSpeaker;
      await agoraEngine?.setEnableSpeakerphone(isSpeaker);
      update();
    } catch (err) {
      debugPrint("enableSpeakerphone error: $err");
    }
  }

  void onToggleCamera() {
    isVideoEnabled = !isVideoEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid) {
        user.isVideoEnabled = isVideoEnabled;
        update();
      }
    }
    update();

    agoraEngine?.muteLocalVideoStream(!isVideoEnabled);
  }

  void onSwitchCamera() => agoraEngine?.switchCamera();

  List<int> createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }

    return layout;
  }

  Future<void> postChatMissedCall(callId) async {
    var response = await audioCallPresenter.postChatMissedCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Get.back();
    }
    update();
  }

  Future<void> postChatLeaveCall(callId) async {
    var response = await audioCallPresenter.postChatLeaveCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Utility.audioPlayer.pause();
      Get.back();
    }
    update();
  }

  Future<void> postChatJoinCall(callId) async {
    Utility.audioPlayer.pause();
    update();
    var response = await audioCallPresenter.postChatJoinCall(
      callid: callId,
      isLoading: true,
    );
    if (response!.statusCode == 200) {}
    update();
  }

  final ApiWrapper api;
  Future<void> addParticipant(String userId, String displayName) async {
    final body = {
      "callid": callId,
      "members": [userId],
    };

    final response = await api.makeRequest(
      "call/addmembers",
      Request.post,
      body,
      true,
      api.defaultHeaders,
    );

    if (response.statusCode == 200 && !response.hasError) {
      final json = jsonDecode(response.data);

      // 🔥 CACHE ALL MEMBERS FROM BACKEND
      cacheCallMembers(json["Data"]["members"]);
      _addPendingInvitee(userId, displayName);

      Get.back();

      Utility.showMessage(
        "Participant added successfully",
        MessageType.success,
        () {},
        "OK",
      );
    }
  }

  void showAddParticipantSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Add Participant",
                  style: Styles.black70018,
                ),
              ),
              Expanded(
                child: GetBuilder<ChatController>(
                  builder: (chatController) {
                    if (chatController.allFriends.isEmpty) {
                      chatController.myFriendsList(1);
                    }
                    return ListView.builder(
                      controller: controller,
                      itemCount: chatController.allFriends.length,
                      itemBuilder: (context, index) {
                        final friend = chatController.allFriends[index];
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              "${ApiWrapper.imageUrl}${friend.profileimage ?? ""}",
                            ),
                          ),
                          title: Text(friend.fullname ?? "Unknown"),
                          subtitle: Text(friend.nickname ?? ""),
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () => addParticipant(
                              friend.userid ?? "",
                              friend.fullname?.trim().isNotEmpty ?? false
                                  ? friend.fullname!
                                  : (friend.nickname ?? "User"),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postKickMember(String memberId) async {
    var response = await audioCallPresenter.postKickMember(
      callid: callId,
      memberid: memberId,
      isLoading: true,
    );
    if (response != null && response.statusCode == 200) {
      print("Successfully kicked member $memberId");
    } else {
      Utility.showMessage("Failed to remove participant", MessageType.error, () => null, '');
    }
  }
}

class PendingInvitee {
  final String userId;
  final String name;
  final String status;
  final int? uid;

  PendingInvitee({
    required this.userId,
    required this.name,
    required this.status,
    this.uid,
  });
}
