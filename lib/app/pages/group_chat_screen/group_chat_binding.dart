import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class GroupChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GroupChatController>(
      () => GroupChatController(
        Get.put(
          GroupChatPresenter(
            Get.put(
              GroupChatUsecases(
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
