import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  SplashController(this.splashPresenter);

  final SplashPresenter splashPresenter;

  @override
  void onInit() {
    super.onInit();
    // Wait for the splash animation (3 s), then navigate based on auth state
    Future.delayed(const Duration(seconds: 3)).then((_) {
      final isCallActive = Get.isRegistered<CallManagerService>() &&
          Get.find<CallManagerService>().isCallActive;
      final isAudioOpen = Get.isRegistered<AudioCallController>();
      final isVideoOpen = Get.isRegistered<VideoCallController>();

      if (isCallActive || isAudioOpen || isVideoOpen) {
        print("[ANTIGRAVITY_DEBUG] SplashController: Call is already active/open. Skipping offAllNamed!");
        return;
      }

      final isLoggedIn = Get.find<Repository>()
          .getStringValue(LocalKeys.authToken)
          .isNotEmpty;
      if (isLoggedIn) {
        FirebaseApi.syncFcmTokenWithBackend();
        SocketConnection.initSocket();
        RouteManagement.goToHomeScreenView();
      } else {
        RouteManagement.goToLoginView();
      }
    });
  }
}
