import '../repositories/repositories.dart';
import '../models/models.dart';
import 'package:chatnest/domain/repositories/repository.dart';

class PlanUsecases {
  PlanUsecases(this.repository);

  final Repository repository;

  Future<PlanListResponseModel?> getPlansList({
    bool isLoading = false,
  }) async =>
      await repository.getPlansList(
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
      await repository.subscribePlan(
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
      await repository.createPaymentOrder(
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
      await repository.verifyPlanPayment(
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
      await repository.getMySubscription(
        isLoading: isLoading,
      );

  Future<GstModel?> getGst({
    bool isLoading = false,
  }) async =>
      await repository.getGst(
        isLoading: isLoading,
      );

  Future<ResponseModel?> getMyInvoices({
    bool isLoading = false,
  }) async =>
      await repository.getMyInvoices(
        isLoading: isLoading,
      );
}
