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
      final isLoggedIn = Get.find<Repository>()
          .getStringValue(LocalKeys.authToken)
          .isNotEmpty;
      if (isLoggedIn) {
        RouteManagement.goToHomeScreenView();
      } else {
        RouteManagement.goToLoginView();
      }
    });
  }
}
