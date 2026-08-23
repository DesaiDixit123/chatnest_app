import 'dart:convert';
import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/device/device.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class SettingController extends GetxController
    with GetTickerProviderStateMixin {
  SettingController(this.settingPresenter);

  final SettingPresenter settingPresenter;

  late TabController tabController;
  late TabController reportTabController;

  int? ringRadio;

  @override
  onInit() {
    tabController = TabController(vsync: this, length: 2);
    tabController.addListener(update);

    reportTabController = TabController(vsync: this, length: 2);
    reportTabController.addListener(update);
    getProfile();
    imagePath = Get.find<Repository>().getStringValue(LocalKeys.chatWallpaper);
    ringRadio = Get.find<Repository>().getIntValue(LocalKeys.ringSelect);
    super.onInit();
  }

  GlobalKey<FormState> numKey = GlobalKey<FormState>();
  TextEditingController oldMobileController = TextEditingController();
  TextEditingController newMobileController = TextEditingController();

  bool isOldValid = false;
  var dailOldCode = '+91';

  bool isNewValid = false;
  var dailNewCode = '+91';

  bool isDarkMode = false;
  bool isNotification = false;

  Future<void> postChangeNumber() async {
    var response = await settingPresenter.postChangeNumber(
      oldmobile: oldMobileController.text,
      oldcountry_code: dailOldCode,
      newmobile: newMobileController.text,
      newcountry_code: dailNewCode,
    );
    if (response?.status == 200) {
      Get.back();
      RouteManagement.goToOtpView(
          response?.data?.key ?? "", true, newMobileController.text);
    } else {
      Utility.errorMessage(response!.message);
    }
    update();
  }

  Future<void> postLogout() async {
    try {
      await settingPresenter.postLogout(
        isLoading: false,
      );
    } catch (_) {}
    SocketConnection.socketDisconnect();
    Get.find<DeviceRepository>().deleteBox();
    RouteManagement.goToLoginView();
  }

  ProfileData profileData = ProfileData();

  Future<void> getProfile() async {
    var response = await settingPresenter.getProfile(
      isLoading: false,
    );
    if (response != null) {
      Utility.profileData = response.data!;
      profileData = response.data!;
      isMessage = response.data?.ischatnotificationallowed ?? false;
      isGroup = response.data?.isgroupchatnotificationallowed ?? false;
      isReceipts = response.data?.readreceiptsstatus ?? false;
      isSeenOnline = response.data?.lastseenonlineofflinestatus ?? false;
      recoveryEmailController.text = response.data?.recoveryEmail ?? "";
    }
    update();
  }

  ////=============================================== MyAccount =================================================///

  Future<void> postDisableAccount() async {
    try {
      await settingPresenter.postDisableAccount(
        isLoading: true,
      );
    } catch (_) {}
    SocketConnection.socketDisconnect();
    Get.find<DeviceRepository>().deleteBox();
    RouteManagement.goToLoginView();
    update();
  }

  Future<void> postDeleteAccount() async {
    try {
      await settingPresenter.postDeleteAccount(
        isLoading: true,
      );
    } catch (_) {}
    SocketConnection.socketDisconnect();
    Get.find<DeviceRepository>().deleteBox();
    RouteManagement.goToLoginView();
    update();
  }

  GlobalKey<FormState> emailKey = GlobalKey<FormState>();

  TextEditingController recoveryEmailController = TextEditingController();

  String isLock = "";

  Future<void> postRecoveryEmail() async {
    var response = await settingPresenter.postRecoveryEmail(
      email: recoveryEmailController.text,
      isLoading: true,
    );
    if (response?.statusCode == 200) {
      getProfile();
      if (isLock == "Lock") {
        RouteManagement.goToCreatChatLockPinScreen();
      } else if (isLock == "Hide") {
        RouteManagement.goToCreateHideChatPinScreen();
      } else {
        Get.back();
      }
    }
    update();
  }

  ////////////////////////////////////////////////////// MultiUser =========================

  GlobalKey<FormState> userKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController serchChatController = TextEditingController();
  TextEditingController serchGroupController = TextEditingController();

  bool isValid = false;
  var dailCode = '+91';

  bool isShow = true;
  bool isConfirmShow = true;
  bool isOldShow = false;

  List<String> chatUserList = [];
  List<String> groupChatUserList = [];

  Future<void> postSaveSubUser() async {
    print(myFriendsLists);
    var response = await settingPresenter.postSaveSubUser(
      subuserid: ids.isNotEmpty ? ids : "",
      fullname: nameController.text,
      username: userNameController.text,
      email: emailController.text,
      mobile: mobileController.text,
      country_code: dailCode,
      // country_wise_contact: "",
      password: passwordController.text,
      chats: myFriendsLists.isNotEmpty
          ? myFriendsLists.map((e) {
              if (e.isUserSelect == true) {
                return e.friendrequestid ?? "";
              }
            }).toList()
          : [],
      groups: groupLists.isNotEmpty
          ? groupLists.map((e) {
              if (e.isUserSelect == true) {
                return e.id ?? "";
              }
            }).toList()
          : [],
      isLoading: true,
    );
    if (response?.statusCode == 200) {
      multiUserPagingController.refresh();
      Get.back();
      Get.back();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  PagingController<int, MyFriendDatum> chatPagingController =
      PagingController(firstPageKey: 1);

  List<MyFriendDatum> myFriendsLists = [];

  int blockUserlimit = 10;

  Future<void> myFriendsWithoutPaginationList() async {
    var response = await settingPresenter.myFriendsWithoutPaginationList(
      search: serchChatController.text,
      unreadMessages: false,
      contactFriend: true,
      fefieldFriend: true,
      receiverFriend: true,
      senderFriend: true,
      isLoading: false,
    );
    myFriendsLists.clear();
    if (response?.data != null) {
      if (ids.isNotEmpty) {
        for (var items in response?.data?.list ?? <MyFriendDatum>[]) {
          var index = chatsList.indexWhere((element) {
            return element.friendrequestid == items.friendrequestid;
          });
          if (index.isNegative) {
            items.isUserSelect = false;
            myFriendsLists.add(items);
          } else {
            items.isUserSelect = true;
            myFriendsLists.add(items);
          }
        }
      } else {
        myFriendsLists.addAll(response?.data?.list ?? []);
      }
      update();
    }
  }

  PagingController<int, GroupChatDatum> groupListPagingController =
      PagingController(firstPageKey: 1);

  List<GroupChatDatum> groupLists = [];

  Future<void> postGroupListWithoutPaging() async {
    var response = await settingPresenter.postGroupListWithoutPaging(
      search: serchGroupController.text,
      isunreadmessagefilteronoff: false,
      isLoading: false,
    );
    groupLists.clear();
    if (response?.data != null) {
      if (ids.isNotEmpty) {
        for (var items in response?.data?.list ?? <GroupChatDatum>[]) {
          var index = groupChatList.indexWhere((element) {
            return element.groupid?.id == items.id;
          });
          if (index.isNegative) {
            items.isUserSelect = false;
            groupLists.add(items);
          } else {
            items.isUserSelect = true;
            groupLists.add(items);
          }
        }
      } else {
        groupLists.addAll(response?.data?.list ?? []);
      }
      update();
    }
  }

  PagingController<int, MultiUserDoc> multiUserPagingController =
      PagingController(firstPageKey: 1);

  List<MultiUserDoc> multiUserList = [];
  List<Chat> chatsList = [];
  List<Group> groupChatList = [];

  Future<void> postSubUserList(pageKey) async {
    var response = await settingPresenter.postSubUserList(
      page: pageKey,
      limit: 10,
      search: '',
      isLoading: false,
    );
    chatsList.clear();
    groupChatList.clear();
    if (response?.data != null) {
      if (pageKey == 1) {
        multiUserList.clear();
      }
      multiUserList = response?.data?.docs ?? [];
      for (var item in multiUserList) {
        chatsList.addAll(item.chats ?? []);
        groupChatList.addAll(item.groups ?? []);
      }

      final isLastPage = multiUserList.length < 10;
      if (isLastPage) {
        multiUserPagingController.appendLastPage(multiUserList);
      } else {
        var nextPageKey = pageKey + 1;
        multiUserPagingController.appendPage(multiUserList, nextPageKey);
      }
      update();
    }
  }

  String ids = "";

  Future<void> postUpdateSubUser(subuserid) async {
    var response = await settingPresenter.postUpdateSubUser(
      subuserid: subuserid,
      isLoading: false,
    );
    if (response?.status == 200) {
      for (var datas
          in multiUserPagingController.itemList ?? <MultiUserDoc>[]) {
        if (datas.id?.contains(subuserid) ?? false) {
          datas.status = response?.data?.status ?? false;
        }
      }
    }
    update();
  }

  ////=============================================== NotificationScreen =================================================///

  bool isMessage = false;
  bool isGroup = false;

  Future<void> postNotificationStatusforChat() async {
    isMessage = !isMessage;
    update();
    var response = await settingPresenter.postNotificationStatusforChat(
      isLoading: false,
    );
    if (response?.status == 200) {
      isMessage = response?.data?.ischatnotificationallowed ?? false;
    } else {
      isMessage = !isMessage; // Revert on failure
    }
    update();
  }

  Future<void> postNotificationStatusforGroup() async {
    isGroup = !isGroup;
    update();
    var response = await settingPresenter.postNotificationStatusforGroup(
      isLoading: false,
    );
    if (response?.status == 200) {
      isGroup = response?.data?.isgroupchatnotificationallowed ?? false;
    } else {
      isGroup = !isGroup; // Revert on failure
    }
    update();
  }

  Future<void> toggleMuteAll(bool mute) async {
    // If mute is true, we want to turn OFF both (Allowed = false)
    // If mute is false, we want to turn ON both (Allowed = true)

    if (mute) {
      if (isMessage || isGroup) {
        if (isMessage) {
          isMessage = false;
        }
        if (isGroup) {
          isGroup = false;
        }
        update();
        
        if (Utility.profileData?.ischatnotificationallowed ?? true) {
          await settingPresenter.postNotificationStatusforChat(isLoading: false);
        }
        if (Utility.profileData?.isgroupchatnotificationallowed ?? true) {
          await settingPresenter.postNotificationStatusforGroup(isLoading: false);
        }
        await getProfile(); // Refresh to ensure sync
      }
    } else {
      if (!isMessage || !isGroup) {
        if (!isMessage) {
          isMessage = true;
        }
        if (!isGroup) {
          isGroup = true;
        }
        update();
        
        if (!(Utility.profileData?.ischatnotificationallowed ?? true)) {
          await settingPresenter.postNotificationStatusforChat(isLoading: false);
        }
        if (!(Utility.profileData?.isgroupchatnotificationallowed ?? true)) {
          await settingPresenter.postNotificationStatusforGroup(isLoading: false);
        }
        await getProfile(); // Refresh to ensure sync
      }
    }
  }

  ////=============================================== StorageScreen =================================================///
  Map<String, double> dataMap = {};

  StorageData storageData = StorageData();

  Future<void> postStorageInfo() async {
    var response = await settingPresenter.postStorageInfo(
      isLoading: false,
    );
    if (response != null) {
      storageData = response.data!;
      dataMap = {
        "Total Available ${05}GB": 5000,
        "Used ${double.parse(response.data?.foldersizeingb ?? "0.00")}GB":
            double.parse(response.data?.foldersizeinmb ?? "0.00"),
      };
      print(dataMap);
    }
    update();
  }

  ////=============================================== PrivacySecutiryScreen =================================================///

  bool isReceipts = false;
  bool isSeenOnline = false;

  int seen = 0;
  int notSeen = 0;

  Future<void> postReadReceiptsstatus() async {
    var response = await settingPresenter.postReadReceiptsstatus(
      isLoading: false,
    );
    if (response?.status == 200) {
      isReceipts = response?.data?.readreceiptsstatus ?? false;
    }
    update();
  }

  Future<void> postLastSeenOnlineOfflineStatus() async {
    var response = await settingPresenter.postLastSeenOnlineOfflineStatus(
      isLoading: false,
    );
    if (response?.status == 200) {
      isSeenOnline = response?.data?.lastseenonlineofflinestatus ?? false;
    }
    update();
  }

  ////=============================================== ChatWallpaperScreen =================================================///
  final pickerProfile = ImagePicker();
  File? imageFile;
  String imagePath = "";
  Future selectWallpaper() async {
    final pickedFile =
        await pickerProfile.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        imagePath = pickedFile.path;
        imageFile = File(pickedFile.path);
        RouteManagement.goToChatWallpaperPreviewScreen();
        // profileImage = await profilePresenter.setProfilePic(
        //     filePath: imageFile?.path ?? "");
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  Future<void> postClearChats() async {
    var response = await settingPresenter.postClearChats(
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Utility.snacBar(
          jsonDecode(response?.data ?? "")['Message'], ColorsValue.appColor);
    }
    update();
  }

  List<MyFriendDatum> clearChatFriendList = [];
  List<GroupChatDatum> clearChatGroupList = [];
  bool isSelectAll = false;
  bool isClearChatLoading = false;

  Future<void> fetchClearChatProfiles() async {
    isClearChatLoading = true;
    update();
    try {
      var response = await settingPresenter.myFriendsWithoutPaginationList(
        search: "",
        unreadMessages: false,
        contactFriend: true,
        fefieldFriend: true,
        receiverFriend: true,
        senderFriend: true,
      );

      var groupResponse = await settingPresenter.postGroupListWithoutPaging(
        search: "",
        isunreadmessagefilteronoff: false,
      );

      clearChatFriendList.clear();
      clearChatGroupList.clear();
      isSelectAll = false;

      if (response?.data != null) {
        clearChatFriendList.addAll(response?.data?.list ?? []);
        for (var element in clearChatFriendList) {
          element.isUserSelect = false;
        }
      }

      if (groupResponse?.data != null) {
        clearChatGroupList.addAll(groupResponse?.data?.list ?? []);
        for (var element in clearChatGroupList) {
          element.isUserSelect = false;
        }
      }
    } catch (e) {
      print("fetchClearChatProfiles error: $e");
    } finally {
      isClearChatLoading = false;
      update();
    }
  }


  void toggleClearChatUser(int index, bool isGroup) {
    if (isGroup) {
      clearChatGroupList[index].isUserSelect =
          !(clearChatGroupList[index].isUserSelect ?? false);
    } else {
      clearChatFriendList[index].isUserSelect =
          !(clearChatFriendList[index].isUserSelect ?? false);
    }
    _checkSelectAll();
    update();
  }

  void _checkSelectAll() {
    bool allFriendsSelected = clearChatFriendList.isEmpty ||
        clearChatFriendList.every((element) => element.isUserSelect == true);
    bool allGroupsSelected = clearChatGroupList.isEmpty ||
        clearChatGroupList.every((element) => element.isUserSelect == true);
    isSelectAll = allFriendsSelected && allGroupsSelected;
    if (clearChatFriendList.isEmpty && clearChatGroupList.isEmpty) {
      isSelectAll = false;
    }
  }

  void toggleSelectAllClearChat(bool value) {
    isSelectAll = value;
    for (var element in clearChatFriendList) {
      element.isUserSelect = value;
    }
    for (var element in clearChatGroupList) {
      element.isUserSelect = value;
    }
    update();
  }

  Future<void> postClearSelectedChats() async {
    isClearChatLoading = true;
    update();
    for (var user in clearChatFriendList.where((e) => e.isUserSelect == true)) {
      await Get.find<Repository>().postClearIndividualChats(userid: user.userid ?? "");
    }
    for (var group in clearChatGroupList.where((e) => e.isUserSelect == true)) {
      await Get.find<Repository>().postClearGroupChats(groupid: group.id ?? "");
    }
    isClearChatLoading = false;
    update();
    
    await Get.dialog(
      Material(
        color: ColorsValue.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: Dimens.edgeInsets30_30_30_20,
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor),
                width: Get.width,
                child: Padding(
                  padding: Dimens.edgeInsets20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.check_circle_outline,
                        color: ColorsValue.maincolor1,
                        size: Dimens.sixtyFour,
                      ),
                      Dimens.boxHeight20,
                      Text(
                        "success".tr,
                        textAlign: TextAlign.center,
                        style: Styles.black70020,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        "Chats cleared successfully".tr,
                        style: Styles.hinttext40014,
                        textAlign: TextAlign.center,
                      ),
                      Dimens.boxHeight20,
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(double.infinity, Dimens.fourtyFive),
                          backgroundColor: ColorsValue.maincolor1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimens.six),
                          ),
                        ),
                        onPressed: () {
                          Get.back(); // Close dialog
                          Get.back(); // Go back to settings screen
                        },
                        child: Text(
                          "okay".tr,
                          textAlign: TextAlign.center,
                          style: Styles.white50014,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



  ////=============================================== ChatWallpaperScreen =================================================///
  List<RingtoneModel> ringtoneList = [];

  getRingtone() {
    ringtoneList = [
      RingtoneModel(
        name: 'None',
        isSelect: 0,
      ),
      RingtoneModel(
        name: 'Urban Groove',
        isSelect: 1,
      ),
      RingtoneModel(
        name: 'Marimba Soft',
        isSelect: 2,
      ),
      RingtoneModel(
        name: 'Sunny Strum',
        isSelect: 3,
      ),
      RingtoneModel(
        name: 'Blissfull Chimes',
        isSelect: 4,
      ),
      RingtoneModel(
        name: 'Seraphine',
        isSelect: 5,
      ),
    ];

    var ringtones = Get.find<Repository>().getStringValue(LocalKeys.ringtones);

    ringtoneList.forEach((element) {
      if (element.name == ringtones) {
        ringtoneValue = ringRadio!;
      }
    });
  }

  int ringtoneValue = 0;

  // Future<void> selectRingtone() async {
  //   FilePickerResult? result = await FilePicker.platform.pickFiles(
  //     type: FileType.audio,
  //     allowMultiple: false,
  //   );
  //   if (result != null) {
  //     if (Utility.getImageSizeMB(result.files.first.path ?? "") <= 56) {
  //       print(result.files.first.path);

  //       File audioFile = File(result.files.single.path!);

  //       final directory = await getApplicationDocumentsDirectory();
  //       final path = '${directory.path}/${result.files.single.name}';
  //       await audioFile.copy(path);
  //       // sentImageMsgLists.add(
  //       //   MediaModel(url: result.files.first.path ?? "", isVideo: false),
  //       // );
  //       // if (sentImageMsgLists.isNotEmpty) {
  //       //   if (isGroup) {
  //       //     sendGroupMessage("", false);
  //       //   } else if (isBrodcast) {
  //       //     postSendMessageBroadcast("", false);
  //       //   } else {
  //       //     sendMessage("", false);
  //       //   }
  //       // }
  //     } else {
  //       Utility.errorMessage("max_56_mb_aud".tr);
  //     }

  //     update();
  //   }
  // }

  /////////////////////////////////////////////// ChangePassword ///////////////////////////////////////////////////

  GlobalKey<FormState> passKey = GlobalKey<FormState>();
  TextEditingController newController = TextEditingController();
  TextEditingController changeConfirmController = TextEditingController();

  String subUserId = "";

  Future<void> postChangePassword() async {
    var response = await settingPresenter.postChangePassword(
      subuserid: subUserId,
      password: newController.text,
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
    } else {
      Utility.errorMessage(jsonDecode(response!.data)['Message']);
    }
    update();
  }

  ////=============================================== ChatWallpaperScreen =================================================///

  PagingController<int, ReportListDoc> reportChatPagingController =
      PagingController(firstPageKey: 1);

  List<ReportListDoc> reportChatListDocList = [];

  Future<void> postChatReportList(pageKey) async {
    var response = await settingPresenter.postChatReportList(
      page: pageKey,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        reportChatListDocList.clear();
      }
      reportChatListDocList = response.data?.docs ?? [];

      final isLastPage = reportChatListDocList.length < 10;
      if (isLastPage) {
        reportChatPagingController.appendLastPage(reportChatListDocList);
      } else {
        var nextPageKey = pageKey + 1;
        reportChatPagingController.appendPage(
            reportChatListDocList, nextPageKey);
      }
      update();
    }
  }

  PagingController<int, GroupReportDoc> reportGroupChatPagingController =
      PagingController(firstPageKey: 1);

  List<GroupReportDoc> reportGroupChatListDocList = [];

  Future<void> postGroupChatReportList(pageKey) async {
    var response = await settingPresenter.postGroupChatReportList(
      page: pageKey,
      limit: 10,
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        reportGroupChatListDocList.clear();
      }
      reportGroupChatListDocList = response.data?.docs ?? [];

      final isLastPage = reportGroupChatListDocList.length < 10;
      if (isLastPage) {
        reportGroupChatPagingController
            .appendLastPage(reportGroupChatListDocList);
      } else {
        var nextPageKey = pageKey + 1;
        reportGroupChatPagingController.appendPage(
            reportGroupChatListDocList, nextPageKey);
      }
      update();
    }
  }

  ReportListDoc? reportListDoc = ReportListDoc();

  Future<void> postChatReportGetOne(reportid) async {
    var response = await settingPresenter.postChatReportGetOne(
      reportid: reportid,
      isLoading: false,
    );
    reportListDoc = null;
    if (response?.data != null) {
      reportListDoc = response?.data;
      reasonChatController.text = reportListDoc?.reason ?? "";
      update();
    }
  }

  GroupReportDoc? groupReportDoc = GroupReportDoc();

  Future<void> postGroupChatReportGetOne(reportid) async {
    var response = await settingPresenter.postGroupChatReportGetOne(
      reportid: reportid,
      isLoading: false,
    );
    groupReportDoc = null;
    if (response?.data != null) {
      groupReportDoc = response?.data;
      reasonChatController.text = groupReportDoc?.reason ?? "";

      update();
    }
  }

  GlobalKey<FormState> reportChatKey = GlobalKey<FormState>();
  TextEditingController reasonChatController = TextEditingController();

  String? reportUser;

  Future<void> postChatReport(String userid) async {
    var response = await settingPresenter.postChatReport(
      reportid: reportListDoc?.id ?? "",
      userid: reportListDoc?.userid?.id ?? "",
      reason: reasonChatController.text,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response?.statusCode == 200) {
      Get.back();
      reasonChatController.clear();
      reportChatPagingController.refresh();
      Utility.snacBar(jsonDecode(response?.data.toString() ?? "")['Message'],
          ColorsValue.appColor);
    }
    update();
  }

  Future<void> postGroupChatReport(String userid) async {
    var response = await settingPresenter.postGroupChatReport(
      reportid: groupReportDoc?.id ?? "",
      groupid: groupReportDoc?.groupid?.id ?? "",
      reason: reasonChatController.text,
      isLoading: true,
    );
    Get.closeAllSnackbars();
    if (response?.statusCode == 200) {
      Get.back();
      reasonChatController.clear();
      reportGroupChatPagingController.refresh();
      Utility.snacBar(jsonDecode(response?.data.toString() ?? "")['Message'],
          ColorsValue.appColor);
    }
    update();
  }
}
