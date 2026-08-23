import 'package:chatnest/app/pages/setting_screen/setting_controller.dart';
import 'package:chatnest/app/pages/setting_screen/setting_presenter.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

class SettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SettingController>(
      () => SettingController(
        Get.put(
          SettingPresenter(
            Get.put(
              SettingUsecases(
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
