import 'dart:io';
import 'dart:math';

// import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
// import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;

class MeetingCallController extends GetxController {
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

  Future<void> disposeAgora() async {
    users.clear();
    // Engine release moved to CallManagerService.endCall()
  }

  Future<void> _endMeetingGlobally() async {
    users.clear();
    
    if (isHost) {
      await meetingCallPresenter.postMeetingCancle(meetingid: meetingId);
    } else {
      await postMeetingLeave(meetingId);
    }
    
    // Explicitly release engine and clear state
    await Get.find<CallManagerService>().endCall();
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
        final members = response.data?.members ?? [];
        cacheCallMembers(members);
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
            users.add(
              AgoraUser(
                uid: connection.localUid ?? 0,
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
                user
                  ..isVideoEnabled = isVideoEnabled
                  ..view = agora.AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: agoraEngine!,
                      canvas: const VideoCanvas(
                          uid: 0, renderMode: RenderModeType.renderModeHidden),
                    ),
                  );
                update();
              }
            }
          },
          onLeaveChannel: (connection, stats) {
            debugPrint('LOG::onLeaveChannel');
            users.clear();
            update();
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (users.any((u) => u.uid == remoteUid)) {
              return;
            }
            final info = 'LOG::userJoined: $remoteUid';
            debugPrint(info);

            String resolvedName = "User";
            String resolvedBanner = "";

            // Direct Lookup in callMembersMap
            callMembersMap.forEach((key, value) {
              if (value['uid'] == remoteUid.toString()) {
                resolvedName = value['name'] ?? "User";
                resolvedBanner = value['image'] ?? "";
              }
            });

            print("[ANTIGRAVITY_DEBUG] Meeting Resolved remote user via UID map: $resolvedName ($remoteUid)");

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
                'LOG::remoteVideoStateChanged: $remoteUid $state $reason';
            debugPrint(info);
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
    await _endMeetingGlobally();

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

  // Screen Sharing Methods
  Future<void> startScreenSharing() async {
    try {
      if (Platform.isAndroid) {
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

        // Update local user's video view to show screen share
        for (AgoraUser user in users) {
          if (user.uid == currentUid) {
            user.view = agora.AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: agoraEngine!,
                canvas: const VideoCanvas(
                  uid: 0,
                  sourceType: VideoSourceType.videoSourceScreen,
                ),
              ),
            );
            break;
          }
        }

        update();
        debugPrint('✅ Screen sharing started');
      } else if (Platform.isIOS) {
        // iOS requires Broadcast Upload Extension
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

        // Update local user's video view to show screen share
        for (AgoraUser user in users) {
          if (user.uid == currentUid) {
            user.view = agora.AgoraVideoView(
              controller: VideoViewController(
                rtcEngine: agoraEngine!,
                canvas: const VideoCanvas(
                  uid: 0,
                  sourceType: VideoSourceType.videoSourceScreen,
                ),
              ),
            );
            break;
          }
        }

        update();
        debugPrint('✅ Screen sharing started (iOS)');
      }
    } catch (e) {
      debugPrint('❌ Error starting screen share: $e');
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
        if (user.uid == currentUid) {
          user.view = agora.AgoraVideoView(
            controller: VideoViewController(
              rtcEngine: agoraEngine!,
              canvas: const VideoCanvas(
                uid: 0,
                renderMode: RenderModeType.renderModeHidden,
              ),
            ),
          );
          break;
        }
      }

      update();
      debugPrint('✅ Screen sharing stopped');
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

  Future<void> postMeetingLeave(meetingId) async {
    var response = await meetingCallPresenter.postMeetingLeave(
      meetingid: meetingId,
      isLoading: true,
    );
    if (response != null) {
      Get.back();
    }
    update();
  }

  Future<void> postKickMember(String memberId) async {
    var response = await meetingCallPresenter.postKickMember(
      callid: meetingId,
      memberid: memberId,
      isLoading: true,
    );
    if (response != null && response.statusCode == 200) {
      print("Successfully kicked member $memberId");
      // UI will be updated by socket event
    } else {
      Utility.showMessage(
          "Failed to remove participant", MessageType.error, () => null, '');
    }
  }
}
