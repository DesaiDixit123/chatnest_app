import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class MeetingCallController extends GetxController with WidgetsBindingObserver {
  MeetingCallController(this.meetingCallPresenter);

  MeetingCallPresenter meetingCallPresenter;

  RtcEngine? agoraEngine;
  final users = <AgoraUser>{};

  /// backend userId -> user info
  final Map<String, Map<String, String>> callMembersMap = {};
  final Map<String, AgoraUser> queuedRemoteMembersById = {};
  final List<String> queuedRemoteMemberOrder = [];

  late double viewAspectRatio;
  String meetingId = "";
  String meetingTitle = "Session";

  int? currentUid;
  bool isMicEnabled = false;
  bool isVideoEnabled = false;
  bool isScreenSharing = false;
  bool isFullScreen = false;
  AgoraUser? fullScreenUser;

  String appId = "";
  String token = "";
  String channelName = "";
  bool isMic = true;
  bool isVideo = true;
  bool isCallEnded = false;
  bool isFrontCamera = true;
  bool isLocalMirrored = true;
  bool get isMirrored => isLocalMirrored;
  set isMirrored(bool val) => isLocalMirrored = val;

  final Map<int, bool> individualMirrorToggles = {};

  bool isUserMirrored(int uid) {
    final isMe = (uid == currentUid || uid == 0);
    if (individualMirrorToggles.containsKey(uid)) {
      return individualMirrorToggles[uid]!;
    }
    if (isMe) {
      return isFrontCamera && isLocalMirrored;
    }
    // Remote participants and screen sharing must NEVER be mirrored by default!
    return false;
  }

  void toggleUserMirror(int uid) {
    individualMirrorToggles[uid] = !isUserMirrored(uid);
    _refreshSingleUserVideoView(uid);
    update();
  }

  void _refreshSingleUserVideoView(int uid) {
    final isMe = (uid == currentUid || uid == 0);
    for (AgoraUser user in users) {
      if ((isMe && (user.uid == currentUid || user.uid == 0)) || (!isMe && user.uid == uid)) {
        user.view = buildVideoView(user.uid);
        break;
      }
    }
  }

  Widget buildVideoView(int uid) {
    final isMe = (uid == currentUid || uid == 0);
    final mirrored = isUserMirrored(uid);

    if (isMe) {
      return agora.AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: agoraEngine!,
          canvas: VideoCanvas(
            uid: 0,
            renderMode: RenderModeType.renderModeHidden,
            mirrorMode: (isFrontCamera && mirrored)
                ? VideoMirrorModeType.videoMirrorModeEnabled
                : VideoMirrorModeType.videoMirrorModeDisabled,
          ),
        ),
      );
    } else {
      return agora.AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: agoraEngine!,
          canvas: VideoCanvas(
            uid: uid,
            renderMode: RenderModeType.renderModeHidden,
            mirrorMode: mirrored
                ? VideoMirrorModeType.videoMirrorModeEnabled
                : VideoMirrorModeType.videoMirrorModeDisabled,
          ),
          connection: RtcConnection(channelId: channelName),
        ),
      );
    }
  }

  void refreshAllVideoViews() {
    for (AgoraUser user in users) {
      user.view = buildVideoView(user.uid);
    }
    update();
  }

  void toggleMirror() {
    isLocalMirrored = !isLocalMirrored;
    individualMirrorToggles.remove(currentUid ?? 0);
    individualMirrorToggles.remove(0);
    _refreshSingleUserVideoView(currentUid ?? 0);
    _refreshSingleUserVideoView(0);
    update();
  }

  Timer? _durationTimer;
  Duration callDuration = Duration.zero;

  void _startDurationTimer() {
    _durationTimer?.cancel();
    callDuration = Duration.zero;
    _durationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration += const Duration(seconds: 1);
      update();
    });
  }

  void _stopDurationTimer() {
    _durationTimer?.cancel();
    _durationTimer = null;
  }

  String get formattedDuration {
    final minutes = callDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = callDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final hours = callDuration.inHours;
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:$minutes:$seconds';
    }
    return '$minutes:$seconds';
  }

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopDurationTimer();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.detached) {
      // User swiped away or closed the app!
      // Must leave the Agora channel and inform backend
      try {
        agoraEngine?.leaveChannel();
        meetingCallPresenter.postMeetingLeave(
          meetingid: meetingId,
          isLoading: false,
        );
      } catch (e) {
        debugPrint("Error on app detached: $e");
      }
    }
  }

  void _persistActiveMeetingSession() {
    try {
      if (meetingId.isEmpty) return;
      final repo = Get.find<Repository>();
      repo.saveValue(LocalKeys.lastActiveMeetingId, meetingId);
      repo.saveValue(LocalKeys.lastActiveMeetingTitle, meetingTitle.isNotEmpty ? meetingTitle : "Session");
      repo.saveValue(LocalKeys.lastActiveMeetingChannel, channelName);
      repo.saveValue(LocalKeys.lastActiveMeetingToken, token);
      repo.saveValue(LocalKeys.lastActiveMeetingIsHost, isHost.toString());
    } catch (e) {
      debugPrint("Error persisting meeting session: $e");
    }
  }

  void _clearActiveMeetingSession() {
    try {
      final repo = Get.find<Repository>();
      repo.clearData(LocalKeys.lastActiveMeetingId);
      repo.clearData(LocalKeys.lastActiveMeetingTitle);
      repo.clearData(LocalKeys.lastActiveMeetingChannel);
      repo.clearData(LocalKeys.lastActiveMeetingToken);
      repo.clearData(LocalKeys.lastActiveMeetingIsHost);
    } catch (e) {
      debugPrint("Error clearing meeting session: $e");
    }
  }

  Future<void> disposeAgora() async {
    isCallEnded = true;
    _stopDurationTimer();
    users.clear();
    callMembersMap.clear();
    // Engine release moved to CallManagerService.endCall()
  }

  Future<void> _endMeetingGlobally({bool endForAll = false}) async {
    isCallEnded = true;
    _stopDurationTimer();
    users.clear();
    callMembersMap.clear();

    if (endForAll) {
      _clearActiveMeetingSession();
    }

    try {
      if (endForAll && isHost) {
        await meetingCallPresenter.postMeetingCancle(
          meetingid: meetingId,
          isLoading: false,
        );
      } else {
        await meetingCallPresenter.postMeetingLeave(
          meetingid: meetingId,
          isLoading: false,
        );
      }
    } catch (e) {
      debugPrint("Meeting end API call error: $e");
    }

    try {
      // Explicitly release engine and clear state
      await Get.find<CallManagerService>().endCall();
    } catch (e) {
      debugPrint("CallManagerService endCall error: $e");
    }
  }

  Future<void> initialize() async {
    try {
      debugPrint('🚀 Meeting Call: Starting initialization...');
      
      // Fetch meeting details to get members
      final response = await meetingCallPresenter.postMeetingGetOne(
        meetingid: meetingId,
        isLoading: false,
      );
      if (response != null && response.data != null) {
        if (response.data?.title != null && response.data!.title!.trim().isNotEmpty) {
          meetingTitle = response.data!.title!.trim();
        }
        final host = response.data?.hostby;
        if (host != null && host.id != null && host.id!.isNotEmpty) {
          final uid = _generateNumericUid(host.id!);
          callMembersMap[host.id!] = {
            "name": _preferredName(host.fullname, host.nickname),
            "image": (host.profileimage ?? "").toString(),
            "uid": uid.toString(),
            "role": "Host",
          };
        }
        final members = response.data?.members ?? [];
        cacheCallMembers(members);
      }

      final myId = Utility.profileData?.id ?? "";
      if (myId.isNotEmpty) {
        callMembersMap[myId] = {
          "name": "${_preferredName(Utility.profileData?.fullname, Utility.profileData?.nickname)} (You)",
          "image": (Utility.profileData?.profileimage ?? "").toString(),
          "uid": _generateNumericUid(myId).toString(),
          "role": isHost ? "Host" : "Participant",
        };
      }

      final safeToken = token.trim();
      final safeChannelName = channelName.trim();
      if (safeToken.isEmpty || safeChannelName.isEmpty) {
        Utility.showDialog(
          "Meeting not started yet. Please wait for host to start the meeting.",
          onPress: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            if (Get.currentRoute == Routes.meetingCallScreen) {
              Get.back();
            }
          },
        );
        return;
      }
      token = safeToken;
      channelName = safeChannelName;
      _persistActiveMeetingSession();

      // Set aspect ratio for video according to platform
      if (kIsWeb) {
        viewAspectRatio = 3 / 2;
      } else if (Platform.isAndroid || Platform.isIOS) {
        viewAspectRatio = 9 / 16;
      } else {
        viewAspectRatio = 3 / 2;
      }
      // Initialize microphone and camera

      isMicEnabled = isMic;
      isVideoEnabled = isVideo;
      update();

      debugPrint('🚀 Meeting Call: Initializing Agora engine...');
      await _initAgoraRtcEngine();

      debugPrint('🚀 Meeting Call: Adding event handlers...');
      _addAgoraEventHandlers();

      final callManager = Get.find<CallManagerService>();
      bool wasAlreadyActive = callManager.isCallActive && callManager.activeChannelName.value == channelName;

      if (!wasAlreadyActive) {
        debugPrint('🚀 Meeting Call: Joining channel: $channelName');
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
        debugPrint('🚀 Meeting Call: Re-attaching to existing meeting session');
        currentUid = _generateNumericUid(Utility.profileData?.id ?? "0");
        _startDurationTimer();
        if (!users.any((u) => u.uid == currentUid || u.uid == 0)) {
          users.add(
            AgoraUser(
              uid: currentUid ?? 0,
              name: "You",
              isAudioEnabled: isMicEnabled,
              isVideoEnabled: isVideoEnabled,
              view: buildVideoView(currentUid ?? 0),
            ),
          );
        }
      }
      debugPrint('✅ Meeting Call: Successfully processed channel joining');

      // Register with CallManagerService
      Get.find<CallManagerService>().registerCall(
        type: CallType.meeting,
        channelName: channelName,
        callId: meetingId,
        token: token,
        isHost: isHost,
      );
    } catch (e, stackTrace) {
      debugPrint('❌ Meeting Call: Error during initialization: $e');
      debugPrint('Stack trace: $stackTrace');
      if (e is AgoraRtcException && e.code == -102) {
        Utility.showDialog(
          "Meeting not started yet. Please wait for host to start the meeting.",
          onPress: () {
            if (Get.isDialogOpen == true) {
              Get.back();
            }
            if (Get.currentRoute == Routes.meetingCallScreen) {
              Get.back();
            }
          },
        );
      }
    }
  }

  int _generateNumericUid(String str) {
    if (str.trim().isEmpty) return 0;
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      int char = str.codeUnitAt(i);
      // Replicate JS: hash = ((hash << 5) - hash) + char; hash = hash & hash;
      hash = (((hash << 5) - hash) + char).toSigned(32);
    }
    // Replicate JS: return Math.abs(hash);
    return hash.abs();
  }

  void cacheCallMembers(List members) {
    for (final m in members) {
      // For meetings, members might be in a different structure
      final user = m is Member ? m.userid : m["memberid"];
      if (user == null) continue;

      final userId = (user is BroadcastCreatedBy ? user.id : user["_id"] ?? "").toString();
      if (userId.isEmpty) continue;

      final uid = _generateNumericUid(userId);
      callMembersMap[userId] = {
        "name": (user is BroadcastCreatedBy ? _preferredName(user.fullname, user.nickname) : user["fullname"] ?? "User").toString(),
        "image": (user is BroadcastCreatedBy ? user.profileimage : user["profileimage"] ?? "").toString(),
        "uid": uid.toString(),
      };
    }
    update();
  }

  String _preferredName(dynamic fullname, dynamic nickname) {
    final full = (fullname ?? "").toString().trim();
    if (full.isNotEmpty) {
      return full.split(RegExp(r'\s+')).first;
    }
    final nick = (nickname ?? "").toString().trim();
    return nick.isEmpty ? "User" : nick;
  }

  Future<void> _initAgoraRtcEngine() async {
    final callManager = Get.find<CallManagerService>();
    if (callManager.agoraEngine != null) {
      agoraEngine = callManager.agoraEngine;
      return;
    }

    // 🔥 CREATE engine first
    agoraEngine = createAgoraRtcEngine();

    await agoraEngine!.initialize(const RtcEngineContext(
      appId: '0bacf816c87b4b4799c3e59f09f415c2',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    VideoEncoderConfiguration configuration = const VideoEncoderConfiguration(
      codecType: VideoCodecType.videoCodecH264,
      dimensions: VideoDimensions(width: 640, height: 360),
      frameRate: 15,
      bitrate: 0,
    );
    // configuration.orientationMode = VideoOutputOrientationMode.Adaptative;
    await agoraEngine?.setVideoEncoderConfiguration(configuration);
    await agoraEngine?.enableAudio();
    await agoraEngine?.enableVideo();
    await agoraEngine
        ?.setChannelProfile(ChannelProfileType.channelProfileCommunication);
    // await agoraEngine?.setChannelProfile(ChannelProfile.LiveBroadcasting);
    // await agoraEngine?.setClientRole(ClientRole.Broadcaster);
    await agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    await agoraEngine?.muteLocalVideoStream(!isVideoEnabled);
    if (isVideoEnabled) {
      await agoraEngine?.startPreview();
    }

    callManager.agoraEngine = agoraEngine;
  }

  void _addAgoraEventHandlers() => agoraEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onError: (err, msg) {
            final info = 'LOG::onError: $err';
            debugPrint(info);
          },
          onJoinChannelSuccess: (connection, elapsed) {
            final info =
                'LOG::onJoinChannel: ${connection.channelId}, uid: ${connection.localUid}';
            debugPrint(info);
            currentUid = connection.localUid;
            _startDurationTimer();

            users.removeWhere((u) => u.uid == 0 || u.uid == connection.localUid);
            users.add(
              AgoraUser(
                uid: connection.localUid ?? 0,
                name: "You",
                isAudioEnabled: isMicEnabled,
                isVideoEnabled: isVideoEnabled,
                view: buildVideoView(connection.localUid ?? 0),
              ),
            );
            update();
          },
          onFirstLocalAudioFramePublished: (connection, elapsed) {
            final info = 'LOG::firstLocalAudio: $elapsed';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == currentUid || user.uid == 0) {
                user.isAudioEnabled = isMicEnabled;
                update();
              }
            }
          },
          onFirstLocalVideoFrame: (connection, width, height, elapsed) {
            debugPrint('LOG::firstLocalVideo');
            for (AgoraUser user in users) {
              if (user.uid == currentUid || user.uid == 0) {
                user
                  ..isVideoEnabled = isVideoEnabled
                  ..view = buildVideoView(user.uid);
                update();
              }
            }
          },
          onLeaveChannel: (connection, stats) {
            debugPrint('LOG::onLeaveChannel');
            users.clear();
            _stopDurationTimer();
            update();
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (users.any((u) => u.uid == remoteUid)) {
              return;
            }
            final info = 'LOG::userJoined: $remoteUid';
            debugPrint(info);

            String resolvedName = "Participant";
            String resolvedBanner = "";

            // Lookup in callMembersMap
            callMembersMap.forEach((key, value) {
              if (value['uid'] == remoteUid.toString()) {
                resolvedName = value['name'] ?? "Participant";
                resolvedBanner = value['image'] ?? "";
              }
            });

            users.add(
              AgoraUser(
                uid: remoteUid,
                name: resolvedName,
                bannerImg: resolvedBanner,
                isAudioEnabled: true,
                isVideoEnabled: true,
                view: buildVideoView(remoteUid),
              ),
            );
            update();
          },
          onUserOffline: (connection, remoteUid, reason) {
            final info = 'LOG::userOffline: $remoteUid';
            debugPrint(info);
            users.removeWhere((user) => user.uid == remoteUid);
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
          onFirstRemoteVideoFrame:
              (connection, remoteUid, width, height, elapsed) {
            final info = 'LOG::firstRemoteVideo: $remoteUid ${width}x $height';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user
                  ..isVideoEnabled = true
                  ..view = buildVideoView(remoteUid);
                update();
              }
            }
          },
          onRemoteVideoStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
            final info =
                'LOG::remoteVideoStateChanged: $remoteUid $state $reason';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                if (state == RemoteVideoState.remoteVideoStateDecoding ||
                    state == RemoteVideoState.remoteVideoStateStarting) {
                  user.isVideoEnabled = true;
                  user.view = buildVideoView(remoteUid);
                } else if (state == RemoteVideoState.remoteVideoStateStopped) {
                  user.isVideoEnabled = false;
                }
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

  bool isHost = false;

  Future<void> onCallEnd(
      BuildContext context, MeetingCallController controller) async {
    if (isHost) {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Leave or End Session",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You are the host. Would you like to end the session for all participants or simply leave it?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              // Option 1: End Session for All
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsValue.redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Get.back(); // close bottom sheet
                    await _performEndCall(endForAll: true);
                  },
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 20),
                  label: const Text(
                    "End Session for All",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Option 2: Leave Session (Host leaves, meeting continues for others)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2C2C),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Get.back(); // close bottom sheet
                    await _performEndCall(endForAll: false);
                  },
                  icon: const Icon(Icons.exit_to_app, color: Colors.orangeAccent, size: 20),
                  label: const Text(
                    "Leave Session",
                    style: TextStyle(
                      color: Colors.orangeAccent,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              // Option 3: Cancel
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back(); // close bottom sheet
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      Get.bottomSheet(
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: const BoxDecoration(
            color: Color(0xFF1E1E1E),
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Leave Session",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to leave this session?",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorsValue.redColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    Get.back();
                    await _performEndCall(endForAll: false);
                  },
                  icon: const Icon(Icons.call_end, color: Colors.white, size: 20),
                  label: const Text(
                    "Leave Session",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text(
                    "Cancel",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Future<void> _performEndCall({required bool endForAll}) async {
    if (endForAll) {
      _clearActiveMeetingSession();
    }
    await _endMeetingGlobally(endForAll: endForAll);
    if (Get.currentRoute == Routes.meetingCallScreen) {
      Get.back();
    }
  }

  void onToggleAudio() {
    isMicEnabled = !isMicEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid || user.uid == 0) {
        user.isAudioEnabled = isMicEnabled;
      }
    }
    agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    update();
  }

  void onToggleCamera() {
    isVideoEnabled = !isVideoEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid || user.uid == 0) {
        user.isVideoEnabled = isVideoEnabled;
      }
    }
    agoraEngine?.muteLocalVideoStream(!isVideoEnabled);
    if (isVideoEnabled) {
      agoraEngine?.startPreview();
    } else {
      agoraEngine?.stopPreview();
    }
    update();
  }

  Future<void> onSwitchCamera() async {
    try {
      await agoraEngine?.switchCamera();
      isFrontCamera = !isFrontCamera;
      refreshAllVideoViews();
    } catch (e) {
      debugPrint("Switch camera error: $e");
    }
  }

  // Screen Sharing Methods
  Future<void> startScreenSharing() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        // Start screen capture
        await agoraEngine?.startScreenCapture(
          const ScreenCaptureParameters2(
            captureAudio: true,
            captureVideo: true,
          ),
        );

        // Update channel to publish screen share instead of camera
        await agoraEngine?.updateChannelMediaOptions(
          ChannelMediaOptions(
            publishCameraTrack: false,
            publishScreenCaptureVideo: true,
            publishScreenCaptureAudio: true,
            publishMicrophoneTrack: isMicEnabled,
          ),
        );

        isScreenSharing = true;
        update();
        Utility.showMessage("Screen sharing started", MessageType.information, () => null, '');
      }
    } catch (e) {
      debugPrint('❌ Error starting screen share: $e');
      Utility.showMessage(
        "Screen share could not be started.",
        MessageType.error,
        () => null,
        '',
      );
    }
  }

  Future<void> stopScreenSharing() async {
    try {
      await agoraEngine?.stopScreenCapture();

      // Update channel to publish camera instead of screen share
      await agoraEngine?.updateChannelMediaOptions(
        ChannelMediaOptions(
          publishCameraTrack: isVideoEnabled,
          publishScreenCaptureVideo: false,
          publishScreenCaptureAudio: false,
          publishMicrophoneTrack: isMicEnabled,
        ),
      );

      isScreenSharing = false;

      // Update local user's video view back to camera
      for (AgoraUser user in users) {
        if (user.uid == currentUid || user.uid == 0) {
          user.view = buildVideoView(user.uid);
          break;
        }
      }

      if (isVideoEnabled) {
        await agoraEngine?.startPreview();
      }

      update();
      Utility.showMessage("Screen sharing stopped", MessageType.information, () => null, '');
    } catch (e) {
      debugPrint('❌ Error stopping screen share: $e');
    }
  }

  void onToggleScreenShare() {
    if (isScreenSharing) {
      stopScreenSharing();
    } else {
      startScreenSharing();
    }
  }

  // Full Screen Methods
  void enterFullScreen(AgoraUser user) {
    fullScreenUser = user;
    isFullScreen = true;
    update();
    debugPrint('✅ Entered full screen for user: ${user.uid}');
  }

  void exitFullScreen() {
    fullScreenUser = null;
    isFullScreen = false;
    update();
    debugPrint('✅ Exited full screen');
  }

  void toggleFullScreen(AgoraUser user) {
    if (isFullScreen && fullScreenUser?.uid == user.uid) {
      exitFullScreen();
    } else {
      enterFullScreen(user);
    }
  }

  void showParticipantsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return GetBuilder<MeetingCallController>(
          builder: (controller) {
            final participants = <Map<String, dynamic>>[];

            // Local user (You)
            participants.add({
              "name": "${Utility.profileData?.fullname ?? 'You'} (You)",
              "image": Utility.profileData?.profileimage ?? "",
              "isHost": controller.isHost,
              "isMicEnabled": controller.isMicEnabled,
              "isVideoEnabled": controller.isVideoEnabled,
              "isMe": true,
              "userId": Utility.profileData?.id ?? "",
            });

            // Remote users
            for (final user in controller.users) {
              if (user.uid == controller.currentUid || user.uid == 0) continue;

              String resolvedName = user.name ?? "Participant";
              String resolvedImage = user.bannerImg ?? "";
              String remoteUserId = "";

              controller.callMembersMap.forEach((k, v) {
                if (v['uid'] == user.uid.toString()) {
                  remoteUserId = k;
                  if (v['name'] != null && v['name']!.isNotEmpty) {
                    resolvedName = v['name']!;
                  }
                  if (v['image'] != null && v['image']!.isNotEmpty) {
                    resolvedImage = v['image']!;
                  }
                }
              });

              participants.add({
                "name": resolvedName,
                "image": resolvedImage,
                "isHost": false,
                "isMicEnabled": user.isAudioEnabled ?? true,
                "isVideoEnabled": user.isVideoEnabled ?? true,
                "isMe": false,
                "userId": remoteUserId,
                "uid": user.uid,
              });
            }

            return SafeArea(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Participants (${participants.length})",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            final meetingLink = "https://cochat.click/meeting/join/${controller.meetingId}";
                            Clipboard.setData(ClipboardData(text: meetingLink));
                            Utility.errorMessage("Session link copied");
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white12,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.copy, color: Colors.white70, size: 14),
                                SizedBox(width: 4),
                                Text(
                                  "Share Link",
                                  style: TextStyle(color: Colors.white70, fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Flexible(
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemCount: participants.length,
                        separatorBuilder: (_, __) => const Divider(color: Colors.white12, height: 1),
                        itemBuilder: (context, index) {
                          final p = participants[index];
                          final bool isMe = p['isMe'] == true;
                          final String image = (p['image'] ?? "").toString();
                          final bool hasImage = image.isNotEmpty;

                          return ListTile(
                            contentPadding: const EdgeInsets.symmetric(vertical: 2),
                            leading: CircleAvatar(
                              radius: 18,
                              backgroundColor: Colors.white12,
                              backgroundImage: hasImage
                                  ? NetworkImage("${ApiWrapper.imageUrl}$image")
                                  : null,
                              child: !hasImage
                                  ? const Icon(Icons.person, color: Colors.white70, size: 20)
                                  : null,
                            ),
                            title: Text(
                              p['name'] ?? "",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            subtitle: p['isHost'] == true
                                ? const Text(
                                    "Host",
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 11,
                                    ),
                                  )
                                : null,
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  p['isMicEnabled'] == true ? Icons.mic : Icons.mic_off,
                                  color: p['isMicEnabled'] == true ? Colors.white70 : Colors.redAccent,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Icon(
                                  p['isVideoEnabled'] == true ? Icons.videocam : Icons.videocam_off,
                                  color: p['isVideoEnabled'] == true ? Colors.white70 : Colors.redAccent,
                                  size: 18,
                                ),
                                if (controller.isHost && !isMe) ...[
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(Icons.person_remove, color: Colors.redAccent, size: 18),
                                    onPressed: () {
                                      Get.back();
                                      if (p['userId'] != null && (p['userId'] as String).isNotEmpty) {
                                        controller.postKickMember(p['userId']);
                                      }
                                    },
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> postKickMember(String memberId) async {
    var response = await meetingCallPresenter.postKickMember(
      callid: meetingId,
      memberid: memberId,
      isLoading: false,
    );
    if (response != null && response.statusCode == 200) {
      debugPrint("Successfully kicked member $memberId");
    } else {
      Utility.showMessage(
          "Failed to remove participant", MessageType.error, () => null, '');
    }
  }
}
