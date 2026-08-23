import 'package:chatnest/app/pages/request_screen/request_page.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

// coverage:ignore-file
/// A list of bindings which will be used in the route of [SplashView].
class RequestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RequestController>(
      () => RequestController(
        Get.put(
          RequestPresenter(
            Get.put(
              RequestUseCases(
                Get.find(),
              ),
              permanent: true,
            ),
            Get.put(
              CommonUsecases(
                Get.find(),
              ),
              permanent: true,
            ),
          ),
        ),
      ),
    );
  }
}
