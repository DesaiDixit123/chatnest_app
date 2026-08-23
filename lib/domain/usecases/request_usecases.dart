import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class RequestUseCases {
  RequestUseCases(this.repository);

  final Repository repository;

  Future<SentFirendsListModel?> sentRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.sentRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel?> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await repository.cancelSentRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
      );

  Future<BlockedUserListModel?> blockedUserList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.blockedUserList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ReceiveRequestModel?> receivedrRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.receivedrRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

 
  Future<ResponseModel?> unblockUser({
    bool isLoading = false,
    required String blockeduserid,
  }) async =>
      await repository.unblockUser(
        isLoading: isLoading,
        blockeduserid: blockeduserid,
      );
}
