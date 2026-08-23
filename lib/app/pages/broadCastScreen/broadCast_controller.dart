import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BroadCastController extends GetxController {
  BroadCastController(this.broadCastPresenter);

  final BroadCastPresenter broadCastPresenter;

  GlobalKey<FormState> titleKey = GlobalKey<FormState>();
  TextEditingController searchController = TextEditingController();
  TextEditingController createGroupSearchController = TextEditingController();
  TextEditingController titleController = TextEditingController();

  List<MyFriendDatum> myFriendsLists = [];
  List<MyFriendDatum> brodcastSelectedMemberList = [];

  Future<void> friendsWithoutPaginationList() async {
    var response = await broadCastPresenter.myFriendsWithoutPaginationList(
      search: createGroupSearchController.text,
      unreadMessages: false,
      contactFriend: true,
      fefieldFriend: true,
      receiverFriend: true,
      senderFriend: true,
      isLoading: false,
    );
    myFriendsLists.clear();
    if (response != null) {
      if (getOneBroadcastData?.members?.isNotEmpty ?? false) {
        for (var item in response.data?.list ?? <MyFriendDatum>[]) {
          var index = getOneBroadcastData?.members
              ?.indexWhere((element) => element.userid?.id == item.userid);
          if (index?.isNegative ?? false) {
            myFriendsLists.add(item);
          }
        }
      } else {
        myFriendsLists.addAll(response.data?.list ?? []);
      }
      update();
    }
  }

  Future<void> postAddBroadcast(isEdit) async {
    var response = await broadCastPresenter.postAddBroadcast(
      broadcastid: isEdit ? getOneBroadcastData?.id ?? "" : "",
      broadcasttitle: titleController.text,
      membersList:
          brodcastSelectedMemberList.map((e) => e.userid ?? "").toList(),
    );
    if (response != null) {
      if (isEdit) {
        getOneBroadcast(getOneBroadcastData?.id);
        Get.find<ChatController>().getOneBroadcast(getOneBroadcastData?.id);
      }
      Get.find<ChatController>().broadcastPagingController.refresh();
      Get.back();
      Get.back();
      update();
    }
  }

  GetOneBroadcastData? getOneBroadcastData = GetOneBroadcastData();
  Future<void> getOneBroadcast(broadcastid) async {
    var response = await broadCastPresenter.getOneBroadcast(
      broadcastid: broadcastid ?? "",
      isLoading: true,
    );
    if (response != null) {
      getOneBroadcastData = response.data;
      brodcastSelectedMemberList.clear();
      for (var data in getOneBroadcastData?.members ?? <Member>[]) {
        var index =
            myFriendsLists.indexWhere((e) => e.userid == data.userid?.id);
        print(myFriendsLists[0].fullname);
        if (index.isNegative == false) {
          brodcastSelectedMemberList.add(myFriendsLists[index]);
        }
      }
    }
    update();
  }

  Future<void> postPinUnPinBroadcast(broadcastid) async {
    var response = await broadCastPresenter.postPinUnPinBroadcast(
      broadcastid: broadcastid ?? "",
      isLoading: true,
    );
    if (response != null) {
      Get.find<ChatController>().broadcastPagingController.refresh();
    }
    update();
  }

  bool showMemberList = false;

  Future<void> postDeleteBroadcast(broadcastid) async {
    var response = await broadCastPresenter.postDeleteBroadcast(
      broadcastid: broadcastid ?? "",
      isLoading: true,
    );
    if (response != null) {
      Get.find<ChatController>().broadcastPagingController.refresh();
      Get.back();
      Get.back();
    }
    update();
  }

  final ScrollController scrollBrodcastController = ScrollController();

  List<ChatListsDoc> brodcastFavoriteList = [];

  ChatListsDoc? chatBrodcastListsDoc = ChatListsDoc();

  int pageBrodcastCount = 1;

  bool isBrodcastLastPage = false;
  bool isBrodcastLoading = false;
  bool isReplyChat = false;

  String? broadcastid = "";

  Future<void> postListFavoriteMessages(pageKey) async {
    var response = await broadCastPresenter.postListFavoriteMessages(
      broadcastid: broadcastid ?? "",
      page: 1,
      limit: 10,
      isLoading: true,
    );
    if (response != null) {
      if (pageKey == 1) {
        isBrodcastLastPage = false;
        brodcastFavoriteList.clear();
      }
      if ((response.data.docs?.length ?? 0) < 10) {
        isBrodcastLastPage = true;
        brodcastFavoriteList.addAll(response.data.docs ?? []);
      } else {
        pageBrodcastCount++;
        brodcastFavoriteList.addAll(response.data.docs ?? []);
      }
      if (pageKey == 1) {
        if (scrollBrodcastController.positions.isNotEmpty) {
          scrollBrodcastController.jumpTo(0);
        }
      }
    }
    update();
  }

  DateTime returnDateAndTimeFormat(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));
    return DateTime(dt.year, dt.month, dt.day);
  }

  String groupMessageDateAndTime(String time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(int.parse(time.toString()));

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
  }

  Future<void> postBrodcastMemberRemove(
      GetOneBroadcastData getOneBroadcastData, index) async {
    var response = await broadCastPresenter.postBrodcastMemberRemove(
      broadcastid: getOneBroadcastData.id ?? "",
      memberid: getOneBroadcastData.members?[index].userid?.id ?? "",
      isLoading: true,
    );
    if (response != null) {
      getOneBroadcastData.members?.removeAt(index);
    }
    update();
  }
}
