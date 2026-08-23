import 'package:chatnest/domain/domain.dart';

class FindFriendPresenter {
  FindFriendPresenter(this.findFriendUseCases, this.commonUsecases);

  final FindFriendUseCases findFriendUseCases;
  final CommonUsecases commonUsecases;

  Future<FindFirendsLocationModel?> postFindFriendsLocation({
    bool isLoading = false,
    required double latitude,
    required double longitude,
  }) async =>
      await findFriendUseCases.postFindFriendsLocation(
        isLoading: isLoading,
        latitude: latitude,
        longitude: longitude,
      );

  Future<FindFirendsListModel?> postFindFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await findFriendUseCases.postFindFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<SendRequestModel?> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await commonUsecases.sendNewFriendRequest(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await commonUsecases.cancelSentRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
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
}
