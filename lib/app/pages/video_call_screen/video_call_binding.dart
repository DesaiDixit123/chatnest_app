import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<VideoCallController>()) {
      Get.put<VideoCallController>(
        VideoCallController(
          Get.put(
            VideoCallPresenter(
              Get.put(
                VideoCallUsecases(
                  Get.find(),
                ),
                permanent: true,
              ),
            ),
            permanent: true,
          ),
          api: Get.find<ApiWrapper>(), // ✅ REQUIRED FIX
        ),
        permanent: true,
      );
    }
  }
}
