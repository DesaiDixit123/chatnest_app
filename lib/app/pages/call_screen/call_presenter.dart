import 'package:chatnest/domain/domain.dart';

class CallPresenter {
  CallPresenter(this.callUsecases, this.commonUsecases);

  final CallUsecases callUsecases;
  final CommonUsecases commonUsecases;

  Future<CallHistoryModel?> postCallHistory({
    bool isLoading = false,
    required int page,
    required int limit,
    required String calltype,
  }) async =>
      await callUsecases.postCallHistory(
        page: page,
        limit: limit,
        calltype: calltype,
        isLoading: isLoading,
      );

  Future<CallHistoryByUserModel?> postHistoryByUser({
    required String userid,
    bool isLoading = false,
  }) async =>
      await callUsecases.postHistoryByUser(
        isLoading: isLoading,
        userid: userid,
      );

  Future<CallHistoryByUserModel?> postHistoryByGroup({
    required String groupid,
    bool isLoading = false,
  }) async =>
      await callUsecases.postHistoryByGroup(
        isLoading: isLoading,
        groupid: groupid,
      );

  Future<CallHistoryByUserModel?> postHistoryByCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await callUsecases.postHistoryByCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ContactListModel?> postSyncContacts({
    required List<Map<String, dynamic>> contactLists,
    bool isLoading = false,
  }) async =>
      await callUsecases.postSyncContacts(
        isLoading: isLoading,
        contactLists: contactLists,
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

  Future<ResponseModel?> postDeleteCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await callUsecases.postDeleteCall(
        isLoading: isLoading,
        callid: callid,
      );
}
