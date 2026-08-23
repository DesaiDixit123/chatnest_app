import 'package:chatnest/app/navigators/routes_management.dart';
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
  final Rx<DateTime?> connectedAt = Rx<DateTime?>(null);

  RtcEngine? agoraEngine;

  bool get isCallActive => activeCallType.value != null;

  void registerCall({
    required CallType type,
    required String channelName,
    required String callId,
    required String token,
    required bool isHost,
    String userName = "",
    String userImage = "",
  }) {
    activeCallType.value = type;
    activeChannelName.value = channelName;
    activeCallId.value = callId;
    activeToken.value = token;
    isActiveHost.value = isHost;
    activeUserName.value = userName;
    activeUserImage.value = userImage;
    isMinimized.value = false;
  }

  Future<void> endCall() async {
    if (agoraEngine != null) {
      await agoraEngine!.leaveChannel();
      await agoraEngine!.release();
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
    connectedAt.value = null;
  }

  void minimizeCall() {
    isMinimized.value = true;
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
