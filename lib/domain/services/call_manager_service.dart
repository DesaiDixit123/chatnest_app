import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:chatnest/app/pages/audio_call_screen/audio_call_controller.dart';
import 'package:chatnest/app/pages/video_call_screen/video_call_controller.dart';
import 'package:get/get.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';

enum CallType { audio, video, meeting }

class CallManagerService extends GetxService {
  final Rx<CallType?> activeCallType = Rx<CallType?>(null);
  final RxString activeChannelName = "".obs;
  final RxString activeCallId = "".obs;
  final RxString activeToken = "".obs;
  final RxBool isActiveHost = false.obs;
  final RxBool isMinimized = false.obs;
  final RxString activeUserName = "".obs;
  final RxString activeUserImage = "".obs;
  final RxList<String> activeParticipantNames = <String>[].obs;
  final Rx<DateTime?> connectedAt = Rx<DateTime?>(null);

  RtcEngine? agoraEngine;

  bool get isCallActive => activeCallType.value != null && activeCallId.isNotEmpty;

  bool isCallIdActive(String? callId) {
    if (callId == null || callId.isEmpty) return false;
    return isCallActive && activeCallId.value == callId;
  }

  void registerCall({
    required CallType type,
    required String channelName,
    required String callId,
    required String token,
    required bool isHost,
    String userName = "",
    String userImage = "",
    List<String>? participantNames,
  }) {
    activeCallType.value = type;
    activeChannelName.value = channelName;
    activeCallId.value = callId;
    activeToken.value = token;
    isActiveHost.value = isHost;
    activeUserName.value = userName;
    activeUserImage.value = userImage;
    if (participantNames != null && participantNames.isNotEmpty) {
      activeParticipantNames.assignAll(participantNames);
    }
    isMinimized.value = false;
  }

  void updateParticipants(List<String> names) {
    if (names.isNotEmpty) {
      activeParticipantNames.assignAll(names);
    }
  }

  Future<void> endCall() async {
    if (agoraEngine != null) {
      try {
        await agoraEngine!.leaveChannel();
        await agoraEngine!.release();
      } catch (e) {
        print("[ANTIGRAVITY_DEBUG] Error leaving agora channel: $e");
      }
      agoraEngine = null;
    }
    activeCallType.value = null;
    activeChannelName.value = "";
    activeCallId.value = "";
    activeToken.value = "";
    isActiveHost.value = false;
    isMinimized.value = false;
    activeUserName.value = "";
    activeUserImage.value = "";
    activeParticipantNames.clear();
    connectedAt.value = null;

    if (Get.isRegistered<AudioCallController>()) {
      Get.delete<AudioCallController>(force: true);
    }
    if (Get.isRegistered<VideoCallController>()) {
      Get.delete<VideoCallController>(force: true);
    }
  }

  void minimizeCall() {
    if (isCallActive) {
      isMinimized.value = true;
    }
  }

  void returnToCall() {
    if (!isCallActive) return;

    isMinimized.value = false;
    switch (activeCallType.value) {
      case CallType.audio:
        RouteManagement.goToAudioCallScreen(
          activeChannelName.value,
          activeToken.value,
          activeCallId.value,
          true,
          activeUserImage.value,
          activeUserName.value,
          isActiveHost.value,
        );
        break;
      case CallType.video:
        RouteManagement.goToVideoCallScreen(
          activeChannelName.value,
          activeToken.value,
          activeCallId.value,
          true,
          activeUserImage.value,
          activeUserName.value,
          isActiveHost.value,
        );
        break;
      case CallType.meeting:
        RouteManagement.goToMeetingCallScreen(
          activeChannelName.value,
          activeToken.value,
          activeCallId.value,
          true,
          isActiveHost.value,
        );
        break;
      default:
        break;
    }
  }
}
