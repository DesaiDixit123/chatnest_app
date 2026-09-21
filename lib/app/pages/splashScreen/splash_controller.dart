import 'dart:convert';
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
      final currentRoute = Get.currentRoute;
      final isCallRoute = currentRoute == Routes.audioCallScreen ||
          currentRoute == Routes.videoCallScreen ||
          currentRoute == Routes.meetingCallScreen;
      final isCallActive = (Get.isRegistered<CallManagerService>() &&
              Get.find<CallManagerService>().isCallActive) ||
          FirebaseApi.isAcceptingCall ||
          isCallRoute;
      final isAudioOpen = Get.isRegistered<AudioCallController>();
      final isVideoOpen = Get.isRegistered<VideoCallController>();

      if (isCallActive || isAudioOpen || isVideoOpen || isCallRoute) {
        print("[ANTIGRAVITY_DEBUG] SplashController: Call is already active/open. Skipping offAllNamed!");
        return;
      }

      final isLoggedIn = Get.find<Repository>()
          .getStringValue(LocalKeys.authToken)
          .isNotEmpty;
      if (isLoggedIn) {
        FirebaseApi.syncFcmTokenWithBackend();
        SocketConnection.initSocket();
        checkSubscriptionAndNavigate();
      } else {
        RouteManagement.goToLoginView();
      }
    });
  }

  Future<void> checkSubscriptionAndNavigate() async {
    try {
      final res = await Get.find<Repository>().getMySubscription(isLoading: false);
      if (res != null && !res.hasError && res.data.isNotEmpty) {
        final decoded = jsonDecode(res.data);
        if (decoded is Map && decoded['Data'] != null) {
          final sub = UserSubscriptionModel.fromJson(decoded['Data']);
          final isActive = sub.status == 'active' &&
              !(sub.isExpired ?? false) &&
              (sub.remainingDays ?? 0) > 0;
          if (isActive) {
            RouteManagement.goToHomeScreenView();
            return;
          }
        }
        // Valid user in DB, but has no active plan: go to Membership Plans!
        RouteManagement.goToMembershipPlansScreen();
        return;
      }
    } catch (_) {}
    // If token invalid, user deleted, or error: clear old data and go to Login screen!
    try {
      Get.find<Repository>().clearAllUserData();
    } catch (_) {}
    RouteManagement.goToLoginView();
  }
}
