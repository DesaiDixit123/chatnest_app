import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class MeetingCallBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<MeetingCallController>(
      MeetingCallController(
        Get.put(
          MeetingCallPresenter(
            Get.put(
              MeetingCallUsecases(
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
