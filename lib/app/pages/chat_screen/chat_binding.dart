import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';

import 'package:get/get.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChatController>(
      () => ChatController(
        Get.put(ChatPresenter(
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
        )),
      ),
    );

    Get.put<RequestController>(
      RequestController(
        Get.put(
          RequestPresenter(
            Get.put(
              RequestUseCases(
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
