import 'package:chatnest/domain/domain.dart';

class InvoicesPresenter {
  InvoicesPresenter(this.planUsecases);

  final PlanUsecases planUsecases;

  Future<ResponseModel?> getMyInvoices({
    bool isLoading = false,
  }) async =>
      await planUsecases.getMyInvoices(
        isLoading: isLoading,
      );
}
