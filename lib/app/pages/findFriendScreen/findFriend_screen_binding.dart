import 'package:chatnest/app/pages/findFriendScreen/findFriend_screen_page.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

// coverage:ignore-file
/// A list of bindings which will be used in the route of [SplashView].
class FindFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FindFriendController>(
      () => FindFriendController(
        Get.put(
          FindFriendPresenter(
            Get.put(
              FindFriendUseCases(
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
