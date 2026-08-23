import 'package:chatnest/domain/domain.dart';

class RequestPresenter {
  RequestPresenter(this.requestUseCases, this.commonUsecases);

  final RequestUseCases requestUseCases;
  final CommonUsecases commonUsecases;

  Future<SentFirendsListModel?> sentRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await requestUseCases.sentRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel?> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await requestUseCases.cancelSentRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
      );

  Future<BlockedUserListModel?> blockedUserList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await requestUseCases.blockedUserList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ReceiveRequestModel?> receivedrRequestList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await requestUseCases.receivedrRequestList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ResponseModel?> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await commonUsecases.respondFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> updateFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await commonUsecases.updateFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> unblockUser({
    bool isLoading = false,
    required String blockeduserid,
  }) async =>
      await requestUseCases.unblockUser(
        isLoading: isLoading,
        blockeduserid: blockeduserid,
      );

}
