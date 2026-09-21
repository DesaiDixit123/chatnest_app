import 'package:chatnest/domain/domain.dart';

class MembershipPlansPresenter {
  MembershipPlansPresenter(this.planUsecases);

  final PlanUsecases planUsecases;

  Future<PlanListResponseModel?> getPlansList({
    bool isLoading = false,
  }) async =>
      await planUsecases.getPlansList(
        isLoading: isLoading,
      );

  Future<ResponseModel?> subscribePlan({
    bool isLoading = true,
    required String planId,
    required int durationDays,
    required String durationLabel,
    required double price,
    String? paymentId,
    String? orderId,
    String? paymentMethod,
  }) async =>
      await planUsecases.subscribePlan(
        isLoading: isLoading,
        planId: planId,
        durationDays: durationDays,
        durationLabel: durationLabel,
        price: price,
        paymentId: paymentId,
        orderId: orderId,
        paymentMethod: paymentMethod,
      );

  Future<ResponseModel?> createPaymentOrder({
    bool isLoading = true,
    required String planId,
    required int durationDays,
    required String durationLabel,
    required double price,
  }) async =>
      await planUsecases.createPaymentOrder(
        isLoading: isLoading,
        planId: planId,
        durationDays: durationDays,
        durationLabel: durationLabel,
        price: price,
      );

  Future<ResponseModel?> verifyPlanPayment({
    bool isLoading = true,
    required String planId,
    required int durationDays,
    required String durationLabel,
    required double price,
    required String paymentId,
    String? orderId,
    String? signature,
  }) async =>
      await planUsecases.verifyPlanPayment(
        isLoading: isLoading,
        planId: planId,
        durationDays: durationDays,
        durationLabel: durationLabel,
        price: price,
        paymentId: paymentId,
        orderId: orderId,
        signature: signature,
      );

  Future<ResponseModel?> getMySubscription({
    bool isLoading = false,
  }) async =>
      await planUsecases.getMySubscription(
        isLoading: isLoading,
      );

  Future<GstModel?> getGst({
    bool isLoading = false,
  }) async =>
      await planUsecases.getGst(
        isLoading: isLoading,
      );
}
