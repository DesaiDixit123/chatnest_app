import 'dart:convert';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';

import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class RequestController extends GetxController {
  RequestController(this.requestPresenter);

  final RequestPresenter requestPresenter;

  AuthorizedPermissions authorizedPermissions = AuthorizedPermissions(
    fullname: true,
    mobile: true,
    email: true,
    dob: true,
    gender: true,
    socialmedia: true,
    videocall: true,
    audiocall: true,
    ismute: true,
  );

  PagingController<int, SentFirendsDoc> pagingController =
      PagingController(firstPageKey: 1);

  List<SentFirendsDoc> sentRequestList = [];
  int limit = 10;

  Future<void> sentRequestListApi(int pageKey) async {
    var response = await requestPresenter.sentRequestList(
      page: pageKey,
      limit: limit,
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response == null) {
    } else {
      if (pageKey == 1) {
        sentRequestList.clear();
      }
      sentRequestList = response.data.docs;

      final isLastPage = sentRequestList.length < limit;
      if (isLastPage) {
        pagingController.appendLastPage(sentRequestList);
      } else {
        var nextPageKey = pageKey + 1;
        pagingController.appendPage(sentRequestList, nextPageKey);
      }
      update();
    }
  }

  Future<void> cancelSentRequest(String friendrequestid) async {
    var response = await requestPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response!.statusCode == 200) {
      pagingController.refresh();
      Utility.snacBar(
          jsonDecode(response.data)['Message'], ColorsValue.maincolor1);
    }
    update();
  }

  PagingController<int, BlockedUserDoc> blockUserPagingController =
      PagingController(firstPageKey: 1);

  List<BlockedUserDoc> blockedUserList = [];
  int blockUserlimit = 10;

  Future<void> blockedUserListApi(int pageKey) async {
    var response = await requestPresenter.blockedUserList(
      page: pageKey,
      limit: blockUserlimit,
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response == null) {
    } else {
      if (pageKey == 1) {
        blockedUserList.clear();
      }
      blockedUserList = response.data.docs;

      final isLastPage = blockedUserList.length < blockUserlimit;
      if (isLastPage) {
        blockUserPagingController.appendLastPage(blockedUserList);
      } else {
        var nextPageKey = pageKey + 1;
        blockUserPagingController.appendPage(blockedUserList, nextPageKey);
      }
      update();
    }
  }

  PagingController<int, ReceiveRequestDoc> receivedPagingController =
      PagingController(firstPageKey: 1);

  List<ReceiveRequestDoc> receivedrRequestLists = [];
  int recivelimit = 10;

  Future<void> receivedrRequestList(int pageKey) async {
    var response = await requestPresenter.receivedrRequestList(
      page: pageKey,
      limit: recivelimit,
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response == null) {
    } else {
      if (pageKey == 1) {
        receivedrRequestLists.clear();
      }
      receivedrRequestLists = response.data.docs;

      final isLastPage = receivedrRequestLists.length < limit;
      if (isLastPage) {
        receivedPagingController.appendLastPage(receivedrRequestLists);
      } else {
        var nextPageKey = pageKey + 1;
        receivedPagingController.appendPage(receivedrRequestLists, nextPageKey);
      }
      update();
    }
  }

  Future<void> respondFriendsRequest(String friendrequestid, status) async {
    var response = await requestPresenter.respondFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response!.statusCode == 200) {
      receivedPagingController.refresh();
      Get.find<ChatController>().chatPagingController.refresh();
      Utility.snacBar(
          jsonDecode(response.data)['Message'], ColorsValue.maincolor1);
    }
    update();
  }

  Future<void> updateFriendsRequest(String friendrequestid, status) async {
    var response = await requestPresenter.updateFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response!.statusCode == 200) {
      blockUserPagingController.refresh();
      Get.find<ChatController>().chatPagingController.refresh();
    }
    update();
  }

  /// Unblocks a user using the dedicated /friends/unblock endpoint.
  /// This properly removes the record from the userblocks collection.
  Future<void> unblockUser(String blockedUserId) async {
    var response = await requestPresenter.unblockUser(
      blockeduserid: blockedUserId,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response != null && response.statusCode == 200) {
      blockUserPagingController.refresh();
      Get.find<ChatController>().chatPagingController.refresh();
    }
    update();
  }
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
}
