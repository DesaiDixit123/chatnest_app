import 'dart:convert';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class HideChatController extends GetxController
    with GetSingleTickerProviderStateMixin {
  HideChatController(this.hideChatScreenPresenter);

  final HideChatScreenPresenter hideChatScreenPresenter;

  late TabController hidechattabController;

  @override
  void onInit() {
    hidechattabController = TabController(vsync: this, length: 2);
    hidechattabController.addListener(update);
    super.onInit();
  }

  List<int> selectedChat = [];
  TextEditingController hideChatSearchController = TextEditingController();
  GlobalKey<FormState> createKey = GlobalKey<FormState>();
  TextEditingController createPinController = TextEditingController();

  bool isEnterPin = false;

  String createPin = "";

  Future<void> postCreatePinHide() async {
    var response = await hideChatScreenPresenter.postCreatePinHide(
      pin: createPinController.text,
      isLoading: true,
    );
    if (response != null) {
      isEnterPin = true;
      RouteManagement.goToHideChatVerifyPinScreen();
    }
    update();
  }

  GlobalKey<FormState> verfiyHideKey = GlobalKey<FormState>();
  TextEditingController verfiyHidePinController = TextEditingController();

  Future<void> postVerifyPinHide() async {
    var response = await hideChatScreenPresenter.postVerifyPinHide(
      pin: verfiyHidePinController.text,
      isLoading: false,
    );
    if (response?.status == 200) {
      verfiyHidePinController.clear();
      RouteManagement.goToHideChatScreen();
    } else {
      Utility.errorMessage(response?.message ?? "");
    }
    update();
  }

  Future<void> postForgotPinHide() async {
    var response = await hideChatScreenPresenter.postForgotPinHide(
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      RouteManagement.goToChangeHideForgotPinScreen();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  GlobalKey<FormState> changeLockKey = GlobalKey<FormState>();
  TextEditingController changeOldPinController = TextEditingController();
  TextEditingController changeNewPinController = TextEditingController();
  TextEditingController changeConfirmPinController = TextEditingController();

  Future<void> postChangePinLock() async {
    var response = await hideChatScreenPresenter.postChangePinHide(
      oldpin: changeOldPinController.text,
      newpin: changeNewPinController.text,
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  bool isUnread = false;
  bool isContectList = true;
  bool isFefildFriend = true;
  bool isReceveFriend = true;
  bool isSendFriend = true;

  FocusNode messageFocusNode = FocusNode();

  TextEditingController serchChatHideController = TextEditingController();

  PagingController<int, FriendsListDatum> chatHidePagingController =
      PagingController(firstPageKey: 1);

  List<FriendsListDatum> chatHideFriendList = [];

  int chatLockLimit = 10;

  Future<void> postChatHideFriends(pageKey) async {
    var response = await hideChatScreenPresenter.postChatHideFriends(
      page: pageKey,
      limit: chatLockLimit,
      search: serchChatHideController.text,
      unreadMessages: isUnread,
      contactFriend: isContectList,
      fefieldFriend: isFefildFriend,
      receiverFriend: isReceveFriend,
      senderFriend: isSendFriend,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        chatHideFriendList.clear();
      }
      chatHideFriendList = response.data;
      for (var data in chatHideFriendList) {
        data.isOnline = Utility.onlineOfflineUserList
            .any((element) => element == data.channelID);
      }
      final isLastPage = chatHideFriendList.length < chatLockLimit;
      if (isLastPage) {
        chatHidePagingController.appendLastPage(chatHideFriendList);
      } else {
        var nextPageKey = pageKey + 1;
        chatHidePagingController.appendPage(chatHideFriendList, nextPageKey);
      }
      update();
    }
  }

  TextEditingController grouphideSearchController = TextEditingController();

  PagingController<int, GroupFriendData> groupHidePagingController =
      PagingController(firstPageKey: 1);

  List<GroupFriendData> groupHideLists = [];

  bool isUnreadMessage = false;

  Future<void> postGroupChatHideList(pageKey) async {
    var response = await hideChatScreenPresenter.postGroupChatHideList(
      page: pageKey,
      limit: 10,
      search: grouphideSearchController.text,
      isunreadmessagefilteronoff: isUnreadMessage,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        groupHideLists.clear();
      }
      groupHideLists = response.data;

      final isLastPage = groupHideLists.length < 10;
      if (isLastPage) {
        groupHidePagingController.appendLastPage(groupHideLists);
      } else {
        var nextPageKey = pageKey + 1;
        groupHidePagingController.appendPage(groupHideLists, nextPageKey);
      }
      update();
    }
  }

  Future<void> postUnLockChat(FriendsListDatum itemData) async {
    var response = await hideChatScreenPresenter.postUnLockChat(
      friendrequestids: [itemData.friendrequestid ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      chatHidePagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postMoveHideToLock(FriendsListDatum itemData) async {
    var response = await hideChatScreenPresenter.postMoveHideToLock(
      friendrequestids: [itemData.friendrequestid ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      chatHidePagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postMoveHideToLockGroup(GroupFriendData itemData) async {
    var response = await hideChatScreenPresenter.postMoveHideToLockGroup(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      groupHidePagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  Future<void> postUnLockGroup(GroupFriendData itemData) async {
    var response = await hideChatScreenPresenter.postUnLockGroup(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      groupHidePagingController.itemList!.remove(itemData);
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  GlobalKey<FormState> forgotLockKey = GlobalKey<FormState>();
  TextEditingController forgotOtpPinController = TextEditingController();
  TextEditingController forgotNewPinController = TextEditingController();
  TextEditingController forgotConfirmPinController = TextEditingController();

  Future<void> postChatHideVerifyOtp() async {
    var response = await hideChatScreenPresenter.postChatHideVerifyOtp(
      otp: int.parse(forgotOtpPinController.text),
      pin: int.parse(forgotNewPinController.text),
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
      Get.back();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
    update();
  }

  showdilog() async {
    return Get.dialog(
      Padding(
        padding: Dimens.edgeInsetsTop20,
        child: Material(
          color: ColorsValue.transparent,
          child: Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: Dimens.edgeInsets20_0_20_0,
                  child: Container(
                    decoration: BoxDecoration(
                      color: ColorsValue.white,
                      borderRadius: BorderRadius.circular(Dimens.five),
                    ),
                    child: Padding(
                      padding: Dimens.edgeInsets25_30_25_30,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: InkWell(
                                onTap: () {
                                  Get.back();
                                },
                                child: SvgPicture.asset(
                                  AssetConstants.cancleicon,
                                )),
                          ),
                          SvgPicture.asset(
                            AssetConstants.unhidepopupicon,
                          ),
                          Dimens.boxHeight18,
                          Text(
                            "areyou_sure_hideChat".tr,
                            style: Styles.black70020,
                          ),
                          Dimens.boxHeight18,
                          CustomBottomButton(
                              firstbtnText: "cancle".tr.toUpperCase(),
                              secondbtnTxt: "yes".tr.toUpperCase(),
                              firstStyle: Styles.greyColor888850014,
                              secondStyle: Styles.white50014,
                              bordercolor: ColorsValue.greyColor8888,
                              firstOnPressed: () {
                                Get.back();
                              },
                              secondOnPressed: () {})
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
