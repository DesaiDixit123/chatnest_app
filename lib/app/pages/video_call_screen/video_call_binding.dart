import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class VideoCallBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final targetCallId = (args is List && args.length > 2) ? (args[2] ?? "").toString() : "";
    if (Get.isRegistered<VideoCallController>()) {
      final existing = Get.find<VideoCallController>();
      if (existing.isCallEnded || (existing.callId.isNotEmpty && targetCallId.isNotEmpty && existing.callId != targetCallId)) {
        existing.disposeAgora();
        Get.delete<VideoCallController>(force: true);
      }
    }
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
