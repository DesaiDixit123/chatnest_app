import 'package:chatnest/app/pages/meeting_screen/meeting_page.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class MeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MeetingController>(
      () => MeetingController(
        Get.put(
          MeetingPresenter(
            Get.put(
              MeetingUsecases(
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
