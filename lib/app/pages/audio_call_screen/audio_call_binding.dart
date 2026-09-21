import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class AudioCallBinding extends Bindings {
  @override
  void dependencies() {
    final args = Get.arguments;
    final targetCallId = (args is List && args.length > 2) ? (args[2] ?? "").toString() : "";
    if (Get.isRegistered<AudioCallController>()) {
      final existing = Get.find<AudioCallController>();
      if (existing.isCallEnded || (existing.callId.isNotEmpty && targetCallId.isNotEmpty && existing.callId != targetCallId)) {
        existing.disposeAgora();
        Get.delete<AudioCallController>(force: true);
      }
    }
    if (!Get.isRegistered<AudioCallController>()) {
      Get.put<AudioCallController>(
        AudioCallController(
          Get.put(
            AudioCallPresenter(
              Get.put(
                AudioCallUsecases(
                  Get.find(),
                ),
                permanent: true,
              ),
            ),
            permanent: true,
          ),
          api: Get.find<ApiWrapper>(),
        ),
        permanent: true,
      );
    }
  }
}
