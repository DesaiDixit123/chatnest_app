import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CallUsecases {
  CallUsecases(this.repository);

  final Repository repository;

  Future<CallHistoryModel?> postCallHistory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String calltype,
  }) async =>
      await repository.postCallHistory(
        page: page,
        limit: limit,
        calltype: calltype,
        isLoading: isLoading,
      );

  Future<CallHistoryByUserModel?> postHistoryByUser({
    required String userid,
    bool isLoading = false,
  }) async =>
      await repository.postHistoryByUser(
        isLoading: isLoading,
        userid: userid,
      );

  Future<CallHistoryByUserModel?> postHistoryByGroup({
    required String groupid,
    bool isLoading = false,
  }) async =>
      await repository.postHistoryByGroup(
        isLoading: isLoading,
        groupid: groupid,
      );

  Future<CallHistoryByUserModel?> postHistoryByCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await repository.postHistoryByCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ContactListModel?> postSyncContacts({
    required List<Map<String, dynamic>> contactLists,
    bool isLoading = false,
  }) async {
    try {
      final response = await repository.postSyncContacts(
        isLoading: isLoading,
        contactLists: contactLists,
      );

      debugPrint('🔍 UseCase: response = $response');
      debugPrint(
          '🔍 UseCase: response?.data length = ${response?.data?.length ?? 0}');

      if (response != null) {
        debugPrint(
            '🔍 UseCase: Successfully got ContactListModel with ${response.data?.length ?? 0} contacts');
        return response;
      }
      debugPrint('🔍 UseCase: response is null');
      return null;
    } catch (e, stackTrace) {
      debugPrint('❌ UseCase: Error: $e');
      debugPrint('❌ UseCase: StackTrace: $stackTrace');
      return null;
    }
  }

  Future<ResponseModel?> postDeleteCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await repository.postDeleteCall(
        isLoading: isLoading,
        callid: callid,
      );
}
