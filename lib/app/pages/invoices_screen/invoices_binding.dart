import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';
import 'invoices_controller.dart';
import 'invoices_presenter.dart';

class InvoicesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<InvoicesController>(
      () => InvoicesController(
        Get.put(
          InvoicesPresenter(
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
