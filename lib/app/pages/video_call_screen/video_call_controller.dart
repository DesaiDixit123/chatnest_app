import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class VideoCallController extends GetxController {
  VideoCallController(this.videoCallPresenter, {required this.api});

  final VideoCallPresenter videoCallPresenter;

  /// backend userId -> user info
  final Map<String, Map<String, String>> callMembersMap = {};
  final Map<String, AgoraUser> queuedRemoteMembersById = {};
  final List<String> queuedRemoteMemberOrder = [];
  String callId = "";

  @override
  void onInit() {
    final args = Get.arguments;

    if (args is List) {
      callId = args.length > 2 ? args[2] ?? "" : "";
      userImage = args.length > 4 ? args[4] ?? "" : "";
      isSelfCall = args.length > 6 ? args[6] ?? false : false;
    }

    if (isSelfCall ?? false) {
      Utility.audioPlayer
          .play(AssetSource('images/instagram_outgoing_cal.mp3'));
    }

    super.onInit();
  }

  int counter = 30;
  Timer? timer;
  Timer? callDurationTimer;
  bool isCall = false;
  bool isCallConnected = false;
  bool _isAutoEndingCall = false;
  Duration callDuration = Duration.zero;

  String? userImage;
  bool? isSelfCall;

  void startTimer() {
    const oneSec = Duration(seconds: 30);
    timer = Timer(
      oneSec,
      () async {
        postChatMissedCall(Get.arguments[2]);
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
  List<String> imgList = [];

  final ApiWrapper api;
  late double viewAspectRatio;

  int? currentUid;
  bool isMicEnabled = false;
  bool isVideoEnabled = false;

  String appId = "";
  String token = "";
  String channelName = "";
  bool isMic = true;
  bool isVideo = true;

  String _preferredName(dynamic fullname, dynamic nickname) {
    final full = (fullname ?? "").toString().trim();
    if (full.isNotEmpty) {
      return full.split(RegExp(r'\s+')).first;
    }
    final nick = (nickname ?? "").toString().trim();
    return nick.isEmpty ? "User" : nick;
  }

  int _generateNumericUid(String str) {
    if (str.trim().isEmpty) return 0;
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      int char = str.codeUnitAt(i);
      // Replicate JS hashing
      hash = (((hash << 5) - hash) + char).toSigned(32);
    }
    return hash.abs();
  }

  Future<void> disposeAgora() async {
    Utility.audioPlayer.pause();
    timer?.cancel();
    _stopCallDurationTimer(reset: true);
    users.clear();
    queuedRemoteMembersById.clear();
    queuedRemoteMemberOrder.clear();
    // Engine release moved to CallManagerService.endCall()
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

  void showAddParticipantSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, scrollController) => Container(
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
                      controller: scrollController,
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
                            onPressed: () {
                              addParticipants([friend.userid ?? ""]);
                            },
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

  Future<void> addParticipants(List<String> userIds) async {
    if (callId.isEmpty) {
      debugPrint("❌ callId is empty, cannot add participants");
      return;
    }

    final body = {
      "callid": callId,
      "members": userIds,
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

      cacheCallMembers(json["Data"]["members"]);

      Get.back();

      Utility.showMessage(
        "Participants added successfully",
        MessageType.success,
        () {},
        "OK",
      );
    }
  }

  Future<void> initialize() async {
    print("[ANTIGRAVITY_DEBUG] initialize() called");
    print("[ANTIGRAVITY_DEBUG] Token: $token");
    print("[ANTIGRAVITY_DEBUG] Channel: $channelName");

    // 🔴 ANTIGRAVITY FIX: Fetch token if missing
    if (token.isEmpty || token == "null") {
      print(
          "[ANTIGRAVITY_DEBUG] Token is empty! Attempting to fetch via API...");
      if (callId.isNotEmpty) {
        try {
          // Call the API
          var response = await videoCallPresenter.postChatJoinCall(
            callid: callId,
            isLoading: false,
          );

          if (response != null && response.statusCode == 200) {
            print(
                "[ANTIGRAVITY_DEBUG] API Response for Join Call: ${response.data}");
            // Parse the response
            var jsonData = jsonDecode(response.data);
            // Note: Adjust the path based on actual API response structure.
            // Common structure: { "Data": { "agorameta": { "token": "...", "channelName": "..." } } }
            if (jsonData['Data'] != null) {
              // Try nested agorameta first (as seen in logs)
              var agoraMeta = jsonData['Data']['agorameta'];
              String? extractedToken;
              String? extractedChannel;

              if (agoraMeta != null) {
                extractedToken = agoraMeta['token'];
                extractedChannel = agoraMeta['channelName'];
              } else {
                // Fallback to flat structure just in case
                extractedToken = jsonData['Data']['agoratoken'];
                extractedChannel = jsonData['Data']['agorachannelName'];
              }

              if (extractedToken != null &&
                  extractedToken.toString().isNotEmpty) {
                token = extractedToken.toString();
                print(
                    "[ANTIGRAVITY_DEBUG] ✅ SUCCESS: Fetched Token from API: $token");
              }

              if (extractedChannel != null &&
                  extractedChannel.toString().isNotEmpty) {
                // Always overwrite channel name to ensure it matches the token
                channelName = extractedChannel.toString();
                print(
                    "[ANTIGRAVITY_DEBUG] ✅ Fetched Channel from API: $channelName");
              }
              // Cache all members if available
              if (jsonData['Data'] != null &&
                  jsonData['Data']['members'] != null) {
                cacheCallMembers(jsonData['Data']['members']);
              }
            }
          } else {
            print(
                "[ANTIGRAVITY_DEBUG] ❌ Failed to fetch token. Status: ${response?.statusCode} Error: ${response?.data}");
          }
        } catch (e) {
          print("[ANTIGRAVITY_DEBUG] ❌ Exception fetching token: $e");
        }
      } else {
        print("[ANTIGRAVITY_DEBUG] ❌ Cannot fetch token, callId is empty!");
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
    // Initialize microphone and camera

    isMicEnabled = isMic;
    isVideoEnabled = isVideo;
    update();
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    final callManager = Get.find<CallManagerService>();
    bool wasAlreadyActive = callManager.isCallActive &&
        callManager.activeChannelName.value == channelName;

    if (!wasAlreadyActive) {
      // Explicitly start preview for local video
      print("[ANTIGRAVITY_DEBUG] Starting preview...");
      await agoraEngine?.startPreview();

      print("[ANTIGRAVITY_DEBUG] Joining Channel...");
      await agoraEngine?.joinChannel(
        token: token,
        channelId: channelName,
        uid: _generateNumericUid(Utility.profileData?.id ?? "0"),
        options: const ChannelMediaOptions(
          clientRoleType: ClientRoleType.clientRoleBroadcaster,
          channelProfile: ChannelProfileType.channelProfileCommunication,
          publishMicrophoneTrack: true,
          publishCameraTrack: true,
          autoSubscribeAudio: true,
          autoSubscribeVideo: true,
        ),
      );
    } else {
      print("[ANTIGRAVITY_DEBUG] Re-attaching to existing video call session");
      currentUid = _generateNumericUid(Utility.profileData?.id ?? "0");
      // Preview might already be running, but we ensure it's on for the new screen
      await agoraEngine?.startPreview();
    }

    // Register with CallManagerService
    String fallbackName = "User";
    if (Get.arguments is List && (Get.arguments as List).length > 5) {
      fallbackName = ((Get.arguments as List)[5] ?? "User").toString();
    }

    Get.find<CallManagerService>();
    callManager.registerCall(
      type: CallType.video,
      channelName: channelName,
      callId: callId,
      token: token,
      isHost: isSelfCall ?? false,
      userName: fallbackName,
      userImage: userImage ?? "",
    );

    // If already connected in background, restore the timer immediately
    if (callManager.connectedAt.value != null) {
      _startCallDurationTimer();
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
        if (!queuedRemoteMemberOrder.contains(userId)) {
          queuedRemoteMemberOrder.add(userId);
        }
        queuedRemoteMembersById[userId] = AgoraUser(
          uid: uid,
          name: _preferredName(user["fullname"], user["nickname"]),
          bannerImg: (user["profileimage"] ?? "").toString(),
          isAudioEnabled: false,
          isVideoEnabled: false,
        );
      } else {
        queuedRemoteMembersById.remove(userId);
        queuedRemoteMemberOrder.remove(userId);
      }
    }
    update();
  }

  Future<void> _initAgoraRtcEngine() async {
    print("[ANTIGRAVITY_DEBUG] _initAgoraRtcEngine() called");
    final callManager = Get.find<CallManagerService>();
    if (callManager.agoraEngine != null) {
      agoraEngine = callManager.agoraEngine;
      return;
    }

    // 🔥 CREATE engine first
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine!.initialize(const RtcEngineContext(
      appId: "0bacf816c87b4b4799c3e59f09f415c2", // Consider moving to config
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));

    // Force H.264 for cross-platform compatibility
    await agoraEngine!.setVideoEncoderConfiguration(
      const VideoEncoderConfiguration(
        codecType: VideoCodecType.videoCodecH264,
        dimensions: VideoDimensions(width: 640, height: 360),
        frameRate: 15,
        bitrate: 0,
      ),
    );

    await agoraEngine!.enableAudio();
    await agoraEngine!.enableVideo();

    await agoraEngine!.setClientRole(
      role: ClientRoleType.clientRoleBroadcaster,
    );

    // Unmute locally based on initial state
    print(
        "[ANTIGRAVITY_DEBUG] Setting initial state: Mic=$isMic, Video=$isVideo");
    await agoraEngine!.muteLocalAudioStream(!isMic);
    await agoraEngine!.muteLocalVideoStream(!isVideo);

    callManager.agoraEngine = agoraEngine;
  }

  void _addAgoraEventHandlers() => agoraEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onError: (err, msg) {
            final info = 'LOG::onError: $err';
            debugPrint(info);
            print("[ANTIGRAVITY_DEBUG] onError: $err - $msg");
          },
          onJoinChannelSuccess: (connection, elapsed) {
            print(
                "[ANTIGRAVITY_DEBUG] onJoinChannelSuccess: uid=${connection.localUid}");
            currentUid = connection.localUid;

            users.add(
              AgoraUser(
                uid: connection.localUid!,
                name: _preferredName(
                  Utility.profileData?.fullname,
                  Utility.profileData?.nickname,
                ),
                bannerImg: Utility.profileData?.profileimage,
                isAudioEnabled: isMicEnabled,
                isVideoEnabled: isVideoEnabled,
                view: agora.AgoraVideoView(
                  controller: VideoViewController(
                    rtcEngine: agoraEngine!,
                    canvas: const VideoCanvas(uid: 0),
                  ),
                ),
              ),
            );

            update();
          },
          onFirstLocalAudioFramePublished: (connection, elapsed) {
            final info = 'LOG::firstLocalAudio: $elapsed';
            debugPrint(info);
            print("[ANTIGRAVITY_DEBUG] onFirstLocalAudioFramePublished");
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user.isAudioEnabled = isMicEnabled;
                update();
              }
            }
          },
          onFirstLocalVideoFrame: (connection, width, height, elapsed) {
            print(
                "[ANTIGRAVITY_DEBUG] onFirstLocalVideoFrame $width x $height");
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user
                  ..isVideoEnabled = true
                  ..view = agora.AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraEngine!,
                      canvas: const VideoCanvas(
                        uid: 0,
                        renderMode: RenderModeType.renderModeHidden,
                      ),
                    ),
                  );
              }
            }
            update();
          },
          onLeaveChannel: (connection, stats) {
            debugPrint('LOG::onLeaveChannel');
            print("[ANTIGRAVITY_DEBUG] onLeaveChannel");
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
            callMembersMap.forEach((key, value) {
              if (value['uid'] == remoteUid.toString()) {
                resolvedName = value['name'] ?? "User";
                resolvedBanner = value['image'] ?? "";
              }
            });

            if (resolvedName == "User" &&
                Get.arguments is List &&
                (Get.arguments as List).length > 5) {
              // Fallback for initial 1-on-1 call if cache missed
              resolvedName = ((Get.arguments as List)[5] ?? "User").toString();
              resolvedBanner = ((Get.arguments as List).length > 4)
                  ? (((Get.arguments as List)[4] ?? "").toString())
                  : "";
            }

            print(
                "[ANTIGRAVITY_DEBUG] Video Resolved remote user via UID map: $resolvedName ($remoteUid)");

            users.add(
              AgoraUser(
                uid: remoteUid,
                name: resolvedName,
                bannerImg: resolvedBanner,
                view: agora.AgoraVideoView(
                  controller: VideoViewController.remote(
                    rtcEngine: agoraEngine!,
                    canvas: VideoCanvas(uid: remoteUid),
                    connection: RtcConnection(channelId: connection.channelId),
                  ),
                ),
              ),
            );
            if (remoteParticipantsCount > 0) {
              _startCallDurationTimer();
            }
            update();
          },
          onUserOffline: (connection, remoteUid, reason) {
            final info = 'LOG::userOffline: ${remoteUid}';
            debugPrint(info);
            print("[ANTIGRAVITY_DEBUG] onUserOffline: $remoteUid");
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
            final info = 'LOG::firstRemoteAudio: ${remoteUid}';
            debugPrint(info);
            print("[ANTIGRAVITY_DEBUG] onFirstRemoteAudioFrame: $remoteUid");
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isAudioEnabled = true;
                update();
              }
            }
          },
          onFirstRemoteVideoFrame:
              (connection, remoteUid, width, height, elapsed) {
            final info =
                'LOG::firstRemoteVideo: ${remoteUid} ${width}x $height';
            debugPrint(info);
            print("[ANTIGRAVITY_DEBUG] onFirstRemoteVideoFrame: $remoteUid");
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user
                  ..isVideoEnabled = true
                  ..view = agora.AgoraVideoView(
                    controller: VideoViewController.remote(
                      rtcEngine: agoraEngine!,
                      canvas: VideoCanvas(uid: remoteUid),
                      connection:
                          RtcConnection(channelId: connection.channelId),
                    ),
                  );
                update();
              }
            }
          },
          onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
            final info =
                'LOG::remoteVideoStateChanged: ${remoteUid} $state $reason';
            debugPrint(info);
            print(
                "[ANTIGRAVITY_DEBUG] onRemoteVideoStateChanged: $remoteUid, state: $state");
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isVideoEnabled =
                    state != RemoteVideoState.remoteVideoStateStopped;
                update();
              }
            }
          },
          onRemoteAudioStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
            final info =
                'LOG::remoteAudioStateChanged: ${remoteUid} $state $reason';
            debugPrint(info);
            print(
                "[ANTIGRAVITY_DEBUG] onRemoteAudioStateChanged: $remoteUid, state: $state");
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
      BuildContext context, VideoCallController controller) async {
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
    update();

    agoraEngine?.muteLocalAudioStream(!isMicEnabled);
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
    var response = await videoCallPresenter.postChatMissedCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Get.back();
    }
    update();
  }

  Future<void> postChatLeaveCall(callId) async {
    var response = await videoCallPresenter.postChatLeaveCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Utility.audioPlayer.pause();
      await CallingKitService.endAllCalls();
      Get.back();
    }
    update();
  }

  Future<void> postChatJoinCall(callId) async {
    Utility.audioPlayer.pause();
    update();

    var response = await videoCallPresenter.postChatJoinCall(
      callid: callId,
      isLoading: true,
    );
    if (response!.statusCode == 200) {}
    update();
  }

  Future<void> postKickMember(String memberId) async {
    var response = await videoCallPresenter.postKickMember(
      callid: callId,
      memberid: memberId,
      isLoading: true,
    );
    if (response != null && response.statusCode == 200) {
      // The socket event onuserleavethecall should handle removing the user from the UI
      print("Successfully kicked member $memberId");
    } else {
      Utility.showMessage(
          "Failed to remove participant", MessageType.error, () => null, '');
    }
  }
}
