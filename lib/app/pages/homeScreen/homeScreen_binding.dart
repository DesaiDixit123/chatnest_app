import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/domain/usecases/usecases.dart';
import 'package:get/get.dart';

class HomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<HomeScreenController>(
      HomeScreenController(
        Get.put(
          HomeScreenPresenter(
            Get.put(
              HomeScreenUseCases(
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
          permanent: true,
        ),
      ),
    );
    Get.put<FindFriendController>(
      FindFriendController(
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
    Get.put<ChatController>(
      ChatController(
        Get.put(
          ChatPresenter(
            Get.put(
              ChatUsecases(
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
    Get.put<GroupChatController>(
      GroupChatController(
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
    Get.put<CallController>(
      CallController(
        Get.put(
          CallPresenter(
            Get.put(
              CallUsecases(
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
    Get.put<ProfileController>(
      ProfileController(
        Get.put(
          ProfilePresenter(
            Get.put(
              ProfileUseCases(
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
