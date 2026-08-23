import 'package:chatnest/app/pages/hidechateScreen/hidechat_page.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class HidechatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HideChatController>(
      () => HideChatController(
        Get.put(
          HideChatScreenPresenter(
            Get.put(
              HideChatUseCases(
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
