import 'dart:convert';
import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GroupChatController extends GetxController {
  GroupChatController(this.groupChatPresenter);

  final GroupChatPresenter groupChatPresenter;

  String? groupId = "";

  @override
  void onInit() {
    postArchiveGroupChatList();
    super.onInit();
  }

  ///============================================== GroupChatListScreen -============================================///

  TextEditingController groupSearchController = TextEditingController();

  PagingController<int, GroupChatDatum> groupListPagingController =
      PagingController(firstPageKey: 1);

  List<GroupChatDatum> groupLists = [];
  List<GroupChatDatum> forwardSelectedGroupList = [];

  int totalReadGroups = 0;

  Future<void> groupsUserChatList(pageKey) async {
    var response = await groupChatPresenter.groupsUserChatList(
      page: pageKey,
      limit: 10,
      search: groupSearchController.text,
      isunreadmessagefilteronoff: isUnreadMessage,
      isLoading: false,
    );
    print('groupsUserChatList - parsed response data: ${response?.data}');
    if (response?.data != null) {
      if (pageKey == 1) {
        groupLists.clear();
      }
      groupLists = response?.data?.list ?? [];

      final isLastPage = groupLists.length < 10;
      if (isLastPage) {
        groupListPagingController.appendLastPage(groupLists);
      } else {
        var nextPageKey = pageKey + 1;
        groupListPagingController.appendPage(groupLists, nextPageKey);
      }
      totalReadGroups = response?.data?.totalunreadgroups ?? 0;
    } else {
      groupLists = [];
      groupListPagingController.appendLastPage(groupLists);
    }
    Get.forceAppUpdate();
    update();
  }

  bool isUnread = false;
  bool isContectList = true;
  bool isFefildFriend = true;
  bool isReceveFriend = true;
  bool isSendFriend = true;

  List<MyFriendDatum> myForwardFriendsLists = [];
  List<MyFriendDatum> forwardSelectedMemberList = [];

  Future<void> myForwardFriendsList() async {
    var response = await groupChatPresenter.myFriendsWithoutPaginationList(
      search: "",
      unreadMessages: isUnread,
      contactFriend: isContectList,
      fefieldFriend: isFefildFriend,
      receiverFriend: isReceveFriend,
      senderFriend: isSendFriend,
      isLoading: false,
    );
    myForwardFriendsLists.clear();
    if (response != null) {
      myForwardFriendsLists.addAll(response.data?.list ?? []);
      update();
    }
  }

  ///============================================== CreateGroupScreen -============================================///
  bool isUnreadMessage = false;

  TextEditingController createGroupSearchController = TextEditingController();

  List<MyFriendDatum> groupSelectedMemberList = [];
  List<MyFriendDatum> groupMemberList = [];

  bool isAddMember = false;

  PagingController<int, MyFriendDatum> myFirendsPagingController =
      PagingController(firstPageKey: 1);

  List<MyFriendDatum> myFriendsLists = [];

  Future<void> myGroupFriendsList() async {
    var response = await groupChatPresenter.myFriendsWithoutPaginationList(
      search: createGroupSearchController.text,
      unreadMessages: false,
      contactFriend: true,
      fefieldFriend: true,
      receiverFriend: true,
      senderFriend: true,
      isLoading: false,
    );
    groupMemberList.clear();
    if (response?.data != null) {
      if (getOneGroupData?.members?.isNotEmpty ?? false) {
        for (var item in response?.data?.list ?? <MyFriendDatum>[]) {
          var index = getOneGroupData?.members
              ?.indexWhere((element) => element.userid?.id == item.userid);
          if (index?.isNegative ?? false) {
            groupMemberList.add(item);
          }
        }
      } else {
        groupMemberList.addAll(response?.data?.list ?? []);
      }
      update();
    }
  }

  Future<void> postChatForward(messageid) async {
    var response = await groupChatPresenter.postChatForward(
      messageid: messageid,
      forwardto: forwardSelectedMemberList.map((e) => e.userid ?? "").toList(),
    );
    if (response != null) {
      Get.back();
      groupListPagingController.refresh();
      update();
    }
  }

  ///======================================= CreateGroupTitleScreen ==========================================///

  GlobalKey<FormState> groupkey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool fullnameValue = true;
  bool mobileValue = true;
  bool emailValue = true;
  bool mediaValue = true;
  bool isMute = true;

  Future<void> createGroupApi(isEdit) async {
    var response = await groupChatPresenter.createGroupApi(
      groupid: isEdit ? groupId ?? "" : "",
      profileimage: uploadGroupPic ?? "",
      name: titleController.text,
      description: descriptionController.text,
      members: groupSelectedMemberList.map((e) => e.userid ?? "").toList(),
      authorizedPermissions: AuthorizedPermissions(
        fullname: fullnameValue,
        mobile: mobileValue,
        email: emailValue,
        socialmedia: mediaValue,
      ),
    );
    if (response != null) {
      Get.back();
      Get.back();
      Get.back();
      Get.find<GroupChatController>().groupListPagingController.refresh();
    }
    update();
  }

  Future<bool> imagePermissionCheack(BuildContext context) async {
    return Utility.imagePermissionCheack(context);
  }

  final pickerProfile = ImagePicker();
  File? imageFile;
  var uploadGroupPic;

  Future uploadGroupProfile(ImageSource camera) async {
    final pickedFile = await pickerProfile.pickImage(
      source: camera,
    );

    if (pickedFile != null) {
      if (Utility.getImageSizeMB(pickedFile.path) <= 16) {
        imageFile = File(pickedFile.path);
        uploadGroupPic = await groupChatPresenter.uploadGroupProfile(
          filePath: imageFile?.path ?? "",
        );
      } else {
        Utility.errorMessage("max_16_mb_img".tr);
      }
    }
    update();
  }

  ///======================================================== GroupChatListScreen ============================================///

  bool isShowAll = false;

  GetOneGroupData? getOneGroupData = GetOneGroupData();
  int index = 0;

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

  List<UserMediaModel> businessMediaList = [];

  Future<void> getOneGroup(groupId) async {
    var response = await groupChatPresenter.getOneGroup(
      groupid: groupId ?? "",
    );
    businessMediaList.clear();
    getOneGroupData = null;
    if (response != null) {
      getOneGroupData = response.data;

      for (var data
          in getOneGroupData?.latestmedias ?? <ChatListsMediaData>[]) {
        if (data.content?.media.path.isNotEmpty ?? false) {
          businessMediaList.add(
            UserMediaModel(
              url: data.content?.media.path,
              isVideo: data.content?.media.type == "IMG" ? false : true,
              timestemp: data.senttimestamp,
            ),
          );
        } else {
          data.content?.multimedias
              ?.map(
                (e) => businessMediaList.add(
                  UserMediaModel(
                    url: e.path,
                    isVideo: e.type == "IMG" ? false : true,
                    timestemp: data.senttimestamp,
                  ),
                ),
              )
              .toList();
        }
      }
    }
    update();
  }

  Future<void> addMemberGroup() async {
    var response = await groupChatPresenter.addMemberGroup(
      groupid: groupId ?? "",
      membersList: groupSelectedMemberList
          .map((element) => element.userid ?? "")
          .toList(),
    );
    if (response != null) {
      Get.back();
      getOneGroup(groupId);
    }
    update();
  }

  Future<void> removeMemberGroup(String membersId) async {
    var response = await groupChatPresenter.removeMemberGroup(
      groupid: groupId ?? "",
      membersList: [membersId],
    );
    if (response != null) {
      Get.back();
      getOneGroup(groupId);
      Get.find<ChatController>().getGroupChatLists(1);
    }

    update();
  }

  Future<void> groupSetManager(String userId, int index) async {
    var response = await groupChatPresenter.groupSetManager(
      groupid: groupId ?? "",
      userid: userId,
    );
    if (response != null) {
      getOneGroupData?.members?[index].permissions?.ismanager = true;
      Get.back();
    }
    update();
  }

  Future<void> groupUnSetManager(String userId, int index) async {
    var response = await groupChatPresenter.groupUnSetManager(
      groupid: groupId ?? "",
      userid: userId,
    );
    if (response != null) {
      getOneGroupData?.members?[index].permissions?.ismanager = false;
      Get.back();
    }
    update();
  }

  Future<void> leaveGroup() async {
    var response = await groupChatPresenter.leaveGroup(
      groupid: groupId ?? "",
    );
    if (response != null) {
      Get.back();
      Get.back();
      Get.find<GroupChatController>().groupListPagingController.refresh();
    }
    update();
  }

  GlobalKey<FormState> sendRequestKey = GlobalKey<FormState>();
  TextEditingController messageController = TextEditingController();

  sentRequestDialog(GroupChatMember? item, int index) async {
    return Get.dialog(SentRequestDialog(
      formKey: sendRequestKey,
      title: item?.userid?.nickname ?? "",
      textEditingController: messageController,
      onTap: () {
        if (sendRequestKey.currentState!.validate()) {
          sendNewFriendRequest(item, index);
          messageController.clear();
          Get.back();
        }
      },
    ));
  }

  Future<void> sendNewFriendRequest(GroupChatMember? item, int index) async {
    var response = await groupChatPresenter.sendNewFriendRequest(
      receiverid: item?.userid?.id ?? "",
      message: messageController.text,
      product: "",
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response?.data != null) {
      getOneGroupData?.members?[index].userid?.isfriend = 'sent';
      getOneGroupData?.members?[index].userid?.friendrequestid =
          response?.data?.id ?? "";
      Utility.snacBarTextMainColor(
          'Friend Request sent sucessfully....!', ColorsValue.white);
    }
    update();
  }

  Future<void> respondFriendsRequest(
      String friendrequestid, status, int index) async {
    var response = await groupChatPresenter.respondFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      if (status == "blocked") {
        getOneGroupData?.members?[index].userid?.isfriend = 'sent';
      } else if (status == "rejected") {
        getOneGroupData?.members?[index].userid?.isfriend = '';
      } else {
        getOneGroupData?.members?[index].userid?.isfriend = 'yes';
      }
    }

    update();
  }

  Future<void> updateFriendsRequest(
      String friendrequestid, status, int index) async {
    var response = await groupChatPresenter.updateFriendsRequest(
      friendrequestid: friendrequestid,
      status: status,
      authorizedPermissions: authorizedPermissions,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      getOneGroupData?.members?[index].userid?.isfriend = 'yes';
      var res = jsonDecode(response.data);
      Utility.snacBarTextMainColor(res['Message'], ColorsValue.white);
    }
    update();
  }

  Future<void> cancelSentRequest(String friendrequestid, int index) async {
    var response = await groupChatPresenter.cancelSentRequest(
      friendrequestid: friendrequestid,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      getOneGroupData?.members?[index].userid?.isfriend = 'no';
      getOneGroupData?.members?[index].userid?.friendrequestid = "";
      var res = jsonDecode(response.data);
      Utility.snacBarTextMainColor(res['Message'], ColorsValue.white);
    }
    update();
  }

  permissionDialog() async {
    return Get.dialog(
      StatefulBuilder(builder: (context, setState) {
        return Padding(
          padding: Dimens.edgeInsets20_0_20_0,
          child: Material(
            child: Container(
              padding: Dimens.edgeInsets20,
              decoration: BoxDecoration(
                color: ColorsValue.white,
                borderRadius: BorderRadius.circular(Dimens.fifteen),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'access_permission'.tr,
                        style: Styles.black70016,
                      ),
                      SizedBox(
                        height: Dimens.fifteen,
                        width: Dimens.fifteen,
                        child: InkWell(
                          onTap: () {
                            Get.back();
                            groupSetPermission();
                          },
                          child: SvgPicture.asset(
                            AssetConstants.cancleicon,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Dimens.boxHeight10,
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    title: Text(
                      'fullname'.tr,
                      style: Styles.black50014,
                    ),
                    leading: SvgPicture.asset(AssetConstants.fullnameicon),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: groupPermission.fullname ?? false,
                        activeColor: ColorsValue.maincolor1,
                        onChanged: (value) {
                          groupPermission.fullname = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    title: Text(
                      'phone_number'.tr,
                      style: Styles.black50014,
                    ),
                    leading: SvgPicture.asset(AssetConstants.callicon),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: groupPermission.mobile ?? false,
                        activeColor: ColorsValue.maincolor1,
                        onChanged: (value) {
                          groupPermission.mobile = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    title: Text(
                      'email'.tr,
                      style: Styles.black50014,
                    ),
                    leading: SvgPicture.asset(AssetConstants.smsicon),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: groupPermission.email ?? false,
                        activeColor: ColorsValue.maincolor1,
                        onChanged: (value) {
                          groupPermission.email = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    title: Text(
                      'social_media'.tr,
                      style: Styles.black50014,
                    ),
                    leading: SvgPicture.asset(AssetConstants.socialmediaicon),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: groupPermission.socialmedia ?? false,
                        activeColor: ColorsValue.maincolor1,
                        onChanged: (value) {
                          groupPermission.socialmedia = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    title: Text(
                      'mute_notification'.tr,
                      style: Styles.black50014,
                    ),
                    leading: SvgPicture.asset(AssetConstants.ic_mute_noti),
                    trailing: Transform.scale(
                      scale: 0.8,
                      child: CupertinoSwitch(
                        value: groupPermission.ismute ?? false,
                        activeColor: ColorsValue.maincolor1,
                        onChanged: (value) {
                          groupPermission.ismute = value;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Dimens.boxHeight10,
                ],
              ),
            ),
          ),
        );
      }),
    );
  }

  AuthorizedPermissions groupPermission = AuthorizedPermissions(
    fullname: true,
    mobile: true,
    email: true,
    socialmedia: true,
    ismute: true,
  );

  Future<void> groupSetPermission() async {
    var response = await groupChatPresenter.groupSetPermission(
      groupid: getOneGroupData?.id ?? "",
      authorizedPermissions: groupPermission,
      isLoading: true,
    );
    if (response!.statusCode == 200) {
      var res = jsonDecode(response.data);
      Utility.snacBarTextMainColor(res['Message'], ColorsValue.white);
    }
    update();
  }

  Future<void> postGroupChatPinUnPin(groupId, bool pinned) async {
    var response = await groupChatPresenter.postGroupChatPinUnPin(
      groupid: groupId,
      isPinned: pinned ? false : true,
    );
    if (response?.statusCode == 200) {
      groupListPagingController.refresh();
      Get.forceAppUpdate();
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
  }

  Future<void> postClearGroupChats(String groupId) async {
    var response = await groupChatPresenter.postClearGroupChats(
      groupid: groupId,
      isLoading: false,
    );
    if (response?.statusCode == 200) {
      Get.back();
      Get.back();
      groupListPagingController.refresh();
      Utility.snacBar(
          "Your account messages are cleared for specified group successfully...!",
          ColorsValue.appColor);
    } else {
      Utility.errorMessage(
          jsonDecode(response?.data.toString() ?? "")['Message']);
    }
    update();
  }

  ///============================================== GroupChatScreen ==============================================///

  Future<void> postArchiveGroupChat(String? friendrequestids) async {
    var response = await groupChatPresenter.postArchiveGroupChat(
      isLoading: false,
      groupids: [friendrequestids ?? ""],
    );
    if (response?.statusCode == 200) {
      groupListPagingController.refresh();
      postArchiveGroupChatList();
      update();
    }
  }

  List<GroupChatDatum> myArchiveFriendsLists = [];

  Future<void> postArchiveGroupChatList() async {
    var response = await groupChatPresenter.postArchiveGroupChatList(
      search: groupSearchController.text,
      isunreadmessagefilteronoff: false,
      isLoading: false,
    );
    myArchiveFriendsLists.clear();
    if (response?.data != null) {
      myArchiveFriendsLists.addAll(response?.data ?? []);
      update();
    }
  }

  Future<void> postArchiveGroupChatRemove(String? groupIds) async {
    var response = await groupChatPresenter.postArchiveGroupChatRemove(
      isLoading: false,
      groupids: [
        groupIds ?? "",
      ],
    );
    if (response?.statusCode == 200) {
      postArchiveGroupChatList();
      groupListPagingController.refresh();
      update();
    }
  }

  Future<void> postReadGroupChat(String? groupIds) async {
    var response = await groupChatPresenter.postReadGroupChat(
      isLoading: false,
      groupids: [
        groupIds ?? "",
      ],
    );
    if (response != null) {
      postArchiveGroupChatList();
      groupListPagingController.refresh();
      update();
    }
  }

  Future<void> postUnReadGroupChat(String? groupIds) async {
    var response = await groupChatPresenter.postUnReadGroupChat(
      isLoading: false,
      groupids: [
        groupIds ?? "",
      ],
    );
    if (response != null) {
      postArchiveGroupChatList();
      groupListPagingController.refresh();
      update();
    }
  }

  Future<void> postGroupChatLock(GroupChatDatum itemData) async {
    var response = await groupChatPresenter.postGroupChatLock(
      groupids: [itemData.id ?? ""],
      isLoading: false,
    );
    Get.closeAllSnackbars();
    if (response != null) {
      groupListPagingController.itemList!.remove(itemData);
      Utility.snacBar(
          jsonDecode(response.data)['Message'], ColorsValue.appColor);
    }
    update();
  }

  ////=============================================== ReportUserScreen =================================================///

  GlobalKey<FormState> reportKey = GlobalKey<FormState>();
  TextEditingController reasonController = TextEditingController();

  Future<void> postGroupChatReport(String groupid) async {
    var response = await groupChatPresenter.postGroupChatReport(
      reportid: "",
      groupid: groupid,
      reason: reasonController.text,
      isLoading: true,
    );
    if (response?.statusCode == 200) {
      Get.back();
      reasonController.clear();
      Utility.snacBar(jsonDecode(response?.data.toString() ?? "")['Message'],
          ColorsValue.appColor);
    }
    update();
  }
}
