import 'package:chatnest/app/pages/broadCastScreen/broadcast_page.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

// coverage:ignore-file
/// A list of bindings which will be used in the route of [SplashView].
class BroadCastBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BroadCastController>(
      () => BroadCastController(
        Get.put(
          BroadCastPresenter(
            Get.put(
              BroadCastUseCases(
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
