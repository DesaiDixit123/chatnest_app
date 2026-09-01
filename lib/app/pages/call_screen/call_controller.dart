import 'dart:convert';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:permission_handler/permission_handler.dart';

class CallController extends GetxController {
  CallController(this.callPresenter);

  final CallPresenter callPresenter;

  TextEditingController searchCallController = TextEditingController();
  bool isPermissionGrantedState = Get.find<Repository>().getBoolValue(LocalKeys.isContactsSyncConsented);

  @override
  void onInit() {
    super.onInit();

    chatHsitoryPagingController.addPageRequestListener((pageKey) async {
      await postCallHistory(pageKey, "");
    });

    checkAndLoadContacts();
  }

  Future<void> checkAndLoadContacts() async {
    final consent = Get.find<Repository>().getBoolValue(LocalKeys.isContactsSyncConsented);
    final hasPermission = await Permission.contacts.isGranted;
    isPermissionGrantedState = hasPermission;
    update();
    debugPrint('📞 CallController: checkAndLoadContacts() -> consent = $consent, hasPermission = $hasPermission');
    if (consent && hasPermission) {
      debugPrint('📞 CallController: checkAndLoadContacts() -> Executing fetchContacts() and postSyncContacts()');
      await fetchContacts();
      await postSyncContacts();
    } else {
      debugPrint('📞 CallController: checkAndLoadContacts() -> Skipped auto-sync (consent=$consent, hasPermission=$hasPermission)');
    }
  }

  List<Contact> contactsData = [];

  Future fetchContacts() async {
    try {
      final hasPermission = await Permission.contacts.isGranted;
      debugPrint('📞 CallController: fetchContacts hasPermission = $hasPermission');
      if (hasPermission) {
        final contacts = await FlutterContacts.getContacts(
          withProperties: true,
        );
        contactsData = contacts;
        for (var contact in contacts) {
          final name = contact.displayName.trim();
          if (name.isNotEmpty) {
            for (var phone in contact.phones) {
              final norm = Utility.normalizePhoneNumber(phone.number);
              if (norm.isNotEmpty) {
                Utility.deviceContactsMap[norm] = name;
              }
            }
          }
        }
        if (Get.isRegistered<ChatController>()) {
          Get.find<ChatController>().applyLocalFilter();
          Get.find<ChatController>().update();
        }
        debugPrint('📞 CallController: fetchContacts loaded ${contacts.length} raw contacts');
      }
    } catch (e) {
      debugPrint('❌ CallController: fetchContacts error: $e');
    }
    update();
  }

  Future<void> handleContactSyncRequest(BuildContext context) async {
    final status = await Permission.contacts.status;
    isPermissionGrantedState = status.isGranted;
    final previouslyRequested = Get.find<Repository>().getBoolValue('contactsPermissionRequested');

    debugPrint('📞 CallController: handleContactSyncRequest -> status=$status, isPermissionGrantedState=$isPermissionGrantedState, previouslyRequested=$previouslyRequested');

    if (status.isGranted) {
      Get.find<Repository>().saveValue(LocalKeys.isContactsSyncConsented, true);
      await fetchContacts();
      await postSyncContacts();
      return;
    }

    if (status.isPermanentlyDenied || (status.isDenied && previouslyRequested)) {
      await showContactsSettingsDialog(context);
      return;
    }

    Get.find<Repository>().saveValue('contactsPermissionRequested', true);
    final reqStatus = await Permission.contacts.request();
    debugPrint('📞 CallController: Permission request returned status = $reqStatus');
    if (reqStatus.isGranted) {
      Get.find<Repository>().saveValue(LocalKeys.isContactsSyncConsented, true);
      isPermissionGrantedState = true;
      update();
      await fetchContacts();
      await postSyncContacts();
    } else {
      Get.find<Repository>().saveValue(LocalKeys.isContactsSyncConsented, false);
      isPermissionGrantedState = false;
      update();
      debugPrint('📞 CallController: Contact permission denied.');
    }
  }

  Future<void> showContactsSettingsDialog(BuildContext context) async {
    await Get.dialog(
      Material(
        color: ColorsValue.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: Dimens.edgeInsets40_0_40_0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(
                    Radius.circular(Dimens.sixteen),
                  ),
                  color: ColorsValue.white,
                ),
                width: Get.width,
                child: Padding(
                  padding: Dimens.edgeInsets25_30_25_30,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Icon(
                        Icons.settings_suggest_rounded,
                        size: Dimens.fourty,
                        color: ColorsValue.maincolor1,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        "contacts_access_disabled".tr,
                        style: Styles.black70020,
                        textAlign: TextAlign.center,
                      ),
                      Dimens.boxHeight15,
                      Text(
                        "contacts_access_message".tr,
                        style: Styles.greyColor888840014,
                        textAlign: TextAlign.center,
                      ),
                      Dimens.boxHeight25,
                      CustomBottomButton(
                        firstbtnText: "cancel".tr.toUpperCase(),
                        secondbtnTxt: "open_settings".tr.toUpperCase(),
                        firstStyle: Styles.greyColor888850014,
                        secondStyle: Styles.white50014,
                        bordercolor: ColorsValue.greyColor8888,
                        buttoncolor: ColorsValue.maincolor1,
                        firstOnPressed: () {
                          Get.back();
                        },
                        secondOnPressed: () async {
                          Get.back();
                          await openAppSettings();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  PagingController<int, CallHistoryDoc> chatHsitoryPagingController =
      PagingController(firstPageKey: 1);

  List<CallHistoryDoc> chatHistoryList = [];
  int limit = 10;

  Future<void> postCallHistory(int pageKey, search) async {
    var response = await callPresenter.postCallHistory(
      page: pageKey,
      limit: limit,
      calltype: 'All',
      isLoading: false,
    );
    if (response != null) {
      if (pageKey == 1) {
        chatHistoryList.clear();
      }
      chatHistoryList = response.data?.docs ?? [];

      final isLastPage = chatHistoryList.length < limit;
      if (isLastPage) {
        chatHsitoryPagingController.appendLastPage(chatHistoryList);
      } else {
        var nextPageKey = pageKey + 1;
        chatHsitoryPagingController.appendPage(chatHistoryList, nextPageKey);
      }
      update();
    }
  }

  List<CallHistoryByUserData> callHistoryByUserList = [];
  bool isCallHistoryLoading = false;
  String callHistoryErrorMessage = "";

  Future<void> postHistoryByUser(userid) async {
    isCallHistoryLoading = true;
    callHistoryErrorMessage = "";
    callHistoryByUserList.clear();
    update();

    var response = await callPresenter.postHistoryByUser(
      userid: userid,
      isLoading: false,
    );

    isCallHistoryLoading = false;
    if (response != null && response.status == 200) {
      callHistoryByUserList.addAll(response.data ?? []);
    } else if (response != null) {
      callHistoryErrorMessage = (response.message ?? "").trim();
    } else {
      callHistoryErrorMessage = "Unable to load call history";
    }
    update();
  }

  Future<void> postHistoryByGroup(userid) async {
    isCallHistoryLoading = true;
    callHistoryErrorMessage = "";
    callHistoryByUserList.clear();
    update();

    var response = await callPresenter.postHistoryByGroup(
      groupid: userid,
      isLoading: false,
    );

    isCallHistoryLoading = false;
    if (response != null && response.status == 200) {
      callHistoryByUserList.addAll(response.data ?? []);
    } else if (response != null) {
      callHistoryErrorMessage = (response.message ?? "").trim();
    } else {
      callHistoryErrorMessage = "Unable to load call history";
    }
    update();
  }

  Future<void> postHistoryByCall(String callId) async {
    isCallHistoryLoading = true;
    callHistoryErrorMessage = "";
    callHistoryByUserList.clear();
    update();

    debugPrint('📞 CallController: postHistoryByCall(callId=$callId)');
    var response = await callPresenter.postHistoryByCall(
      callid: callId,
      isLoading: false,
    );

    isCallHistoryLoading = false;
    if (response != null && response.status == 200) {
      callHistoryByUserList.addAll(response.data ?? []);
      debugPrint('📞 CallController: postHistoryByCall loaded ${callHistoryByUserList.length} items');
    } else if (response != null) {
      callHistoryErrorMessage = (response.message ?? "").trim();
      debugPrint('❌ CallController: postHistoryByCall error: $callHistoryErrorMessage');
    } else {
      callHistoryErrorMessage = "Unable to load call history";
      debugPrint('❌ CallController: postHistoryByCall response was null');
    }
    update();
  }

  List<ContactListData> contactsList = [];
  List<ContactListData> searchContactsList = [];
  bool isContactsSyncLoading = false;

  Future<void> postSyncContacts() async {
    final consent = Get.find<Repository>().getBoolValue(LocalKeys.isContactsSyncConsented);
    debugPrint('📞 CallController: Entering postSyncContacts(). Consent = $consent');
    if (!consent) {
      debugPrint('📞 CallController: postSyncContacts aborted because consent was not given.');
      return;
    }
    isContactsSyncLoading = true;
    update();
    try {
      final payload = contactsData
          .map(
            (e) => {
              "name": e.displayName,
              "mobile": e.phones.isNotEmpty ? e.phones[0].number : "",
            },
          )
          .toList();
      debugPrint('📞 CallController: Starting postSyncContacts API. Fetching contacts from device count = ${contactsData.length}');
      debugPrint('📞 CallController: API request payload = ${jsonEncode(payload)}');
      
      var response = await callPresenter.postSyncContacts(
        contactLists: payload,
        isLoading: false,
      );
      
      debugPrint('📞 CallController: API response received. Success? ${response != null}');
      if (response != null) {
        debugPrint('📞 CallController: API response code = ${response.status}, message = ${response.message}');
        debugPrint('📞 CallController: API response matched contacts count = ${response.data?.length ?? 0}');
      }
      
      contactsList.clear();
      if (response != null) {
        contactsList.addAll(response.data ?? []);
        contactsList.sort((a, b) {
          if (a.isChatNestUser == true && b.isChatNestUser != true) return -1;
          if (a.isChatNestUser != true && b.isChatNestUser == true) return 1;
          return (a.name ?? "")
              .toLowerCase()
              .compareTo((b.name ?? "").toLowerCase());
        });
        debugPrint('📞 CallController: Final sorted contacts count = ${contactsList.length}');
        for (var c in contactsList) {
          debugPrint('📞 CallController: Contact: Name = ${c.name}, Mobile = ${c.mobile}, isChatNestUser = ${c.isChatNestUser}, isFriend = ${c.isfriend}');
        }
      } else {
        debugPrint('📞 CallController: Response was null');
      }
    } catch (e) {
      debugPrint('❌ CallController: postSyncContacts error: $e');
    } finally {
      isContactsSyncLoading = false;
      update();
      debugPrint('📞 CallController: postSyncContacts finished. isContactsSyncLoading = $isContactsSyncLoading');
    }
  }

  GlobalKey<FormState> sendRequestKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();

  AuthorizedPermissions authorizedPermissions = AuthorizedPermissions(
    fullname: true,
    mobile: true,
    email: true,
    dob: true,
    gender: true,
    socialmedia: true,
    videocall: true,
    audiocall: true,
    ismute: false,
  );

  Future<void> sendNewFriendRequest(
      String receiverid, String message, int index) async {
    var response = await callPresenter.sendNewFriendRequest(
      receiverid: receiverid,
      message: message,
      product: "",
      authorizedPermissions: authorizedPermissions,
    );
    Get.closeAllSnackbars();

    if (response?.data != null) {
      contactsList[index].isfriend = "sent";
      messageController.clear();
      update();

      var res = jsonDecode(response!.data.toString());
      Utility.snacBar(res['Message'], ColorsValue.maincolor1);
    } else {
      messageController.clear();
      var res = jsonDecode(response!.data.toString());
      Utility.errorMessage(res['Message']);
      update();
    }
  }

  Future<void> cancelSentRequest(String friendrequestid) async {
    var response = await callPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    Get.closeAllSnackbars();

    if (response!.statusCode == 200) {
      postSyncContacts();
      Utility.snacBar(
          "Friend request cancle successfully...", ColorsValue.maincolor1);
    }
    update();
  }

  Future<void> respondFriendsRequest(String friendrequestid, status) async {
    var response = await callPresenter.respondFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: AuthorizedPermissions(
        fullname: true,
        mobile: true,
        email: true,
        dob: true,
        gender: true,
        socialmedia: true,
        videocall: true,
        audiocall: true,
        ismute: true,
      ),
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      postSyncContacts();
    }
    update();
  }

  Future<void> updateFriendsRequest(String friendrequestid, status) async {
    var response = await callPresenter.updateFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      postSyncContacts();
    }
    update();
  }

  Future<void> postDeleteCall(String callid, index) async {
    var response = await callPresenter.postDeleteCall(
      callid: callid,
      isLoading: false,
    );

    if (response!.statusCode == 200) {
      chatHsitoryPagingController.itemList?.removeAt(index);
    }
    update();
  }

  // Get contacts who are ChatNestUsers (on the platform) but not yet friends
  List<ContactListData> get appUsers {
    return contactsList.where((e) => e.isChatNestUser == true).toList();
  }

  // Get contacts who are NOT on the platform (for invite)
  List<ContactListData> get nonAppUsers {
    return contactsList.where((e) => e.isChatNestUser == false).toList();
  }
}
