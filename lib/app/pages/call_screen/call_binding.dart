import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class CallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CallController>(
      () => CallController(
        Get.put(
          CallPresenter(
            Get.put(
              CallUsecases(
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
