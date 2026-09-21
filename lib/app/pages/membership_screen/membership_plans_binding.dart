import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';
import 'membership_plans_controller.dart';
import 'membership_plans_presenter.dart';

class MembershipPlansBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MembershipPlansController>(
      () => MembershipPlansController(
        Get.put(
          MembershipPlansPresenter(
            Get.put(
              PlanUsecases(
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
