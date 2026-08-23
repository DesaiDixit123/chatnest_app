import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class AudioCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AudioCallController>(
      () => AudioCallController(
        Get.put(
          AudioCallPresenter(
            Get.put(
              AudioCallUsecases(
                Get.find(),
              ),
              permanent: true,
            ),
          ),
        ),
        api: Get.find<ApiWrapper>(), // ✅ REQUIRED
      ),
    );
  }
}
