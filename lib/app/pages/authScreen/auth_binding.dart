import 'package:chatnest/app/pages/authScreen/auth_pages.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

// coverage:ignore-file
/// A list of bindings which will be used in the route of [SplashView].
class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginController>(
      () => LoginController(
        Get.put(
          LoginPresenter(
            Get.put(
              AuthUseCases(
                Get.find(),
              ),
              permanent: true,
            ),
          ),
        ),
      ),
      fenix: true,
    );
  }
}
