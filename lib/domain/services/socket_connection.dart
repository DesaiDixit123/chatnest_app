import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'firebase_api.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:uuid/uuid.dart';

abstract class SocketConnection {
  static IO.Socket? socket;

  static bool _toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final normalized = (value ?? "").toString().trim().toLowerCase();
    return normalized == "yes" || normalized == "true" || normalized == "1";
  }

  static socketDisconnect() {
    socket?.disconnect();
  }

  static initSocket() {
    socket = IO.io(
      ApiWrapper.baseUrl,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableAutoConnect()
          .enableReconnection() // 🔥 REQUIRED
          .setReconnectionAttempts(9999)
          .setReconnectionDelay(1000)
          .setTimeout(20000)
          .build(),
    );
    socket!.onConnect((_) {
      final channelId =
          Get.find<Repository>().getStringValue(LocalKeys.chanelId);
      socket!.emit('init', {'channelID': channelId});
    });

    // socket!.onConnect((_) {
    //   print("Conttecty SuseesFully...");
    //   print(Get.find<Repository>().getStringValue(LocalKeys.chanelId));
    //   socket!.emit('init', {
    //     'channelID': Get.find<Repository>().getStringValue(LocalKeys.chanelId),
    //   });
    // });
    socket!.onReconnect((_) {
      final channelId =
          Get.find<Repository>().getStringValue(LocalKeys.chanelId);
      socket!.emit('init', {'channelID': channelId});
    });

    socket?.on("userbecomeonline", (data) async {
      print(data);
      Utility.onlineOfflineUserList.clear();
      for (var datas in data["allonlinusers"].keys) {
        Utility.onlineOfflineUserList.add(datas);
      }

      if (Get.isRegistered<ChatController>()) {
        var chatController = Get.find<ChatController>();
        if (chatController.chatPagingController.itemList != null) {
          for (var item in chatController.chatPagingController.itemList!) {
            item.isOnline = Utility.onlineOfflineUserList.any((element) =>
                element.toLowerCase() == (item.channelID ?? "").toLowerCase());
          }
        }

        if (chatController.getOneFriendsData != null) {
          chatController.getOneFriendsData!.isOnline =
              Utility.onlineOfflineUserList.any((element) =>
                  element.toLowerCase() ==
                  (chatController.getOneFriendsData!.channelID ?? "")
                      .toLowerCase());
        }
        chatController.update();
      }
      Get.forceAppUpdate();
    });

    socket?.on("userConnected", (data) async {
      Utility.onlineOfflineUserList.clear();
      if (data["onlineUsers"] != null) {
        for (var datas in data["onlineUsers"].keys) {
          Utility.onlineOfflineUserList.add(datas);
        }
      }

      if (Get.isRegistered<ChatController>()) {
        var chatController = Get.find<ChatController>();
        if (chatController.chatPagingController.itemList != null) {
          for (var item in chatController.chatPagingController.itemList!) {
            item.isOnline = Utility.onlineOfflineUserList.any((element) =>
                element.toLowerCase() == (item.channelID ?? "").toLowerCase());
          }
        }

        if (chatController.getOneFriendsData != null) {
          chatController.getOneFriendsData!.isOnline =
              Utility.onlineOfflineUserList.any((element) =>
                  element.toLowerCase() ==
                  (chatController.getOneFriendsData!.channelID ?? "")
                      .toLowerCase());
        }
        chatController.update();
      }
      Get.forceAppUpdate();
    });

    socket!.onDisconnect((_) => print("❌ DISCONNECTED"));
    socket!.onReconnect((_) => print("✅ RECONNECTED"));

    socket?.on("userbecomeoffline", (data) async {
      Utility.onlineOfflineUserList.clear();
      for (var datas in data["allonlinusers"].keys) {
        Utility.onlineOfflineUserList.add(datas);
      }

      if (Get.isRegistered<ChatController>()) {
        var chatController = Get.find<ChatController>();
        if (chatController.chatPagingController.itemList != null) {
          for (var item in chatController.chatPagingController.itemList!) {
            item.isOnline = Utility.onlineOfflineUserList.any((element) =>
                element.toLowerCase() == (item.channelID ?? "").toLowerCase());
          }
        }

        if (chatController.getOneFriendsData != null) {
          chatController.getOneFriendsData!.isOnline =
              Utility.onlineOfflineUserList.any((element) =>
                  element.toLowerCase() ==
                  (chatController.getOneFriendsData!.channelID ?? "")
                      .toLowerCase());
        }
        chatController.update();
      }
      Get.forceAppUpdate();
    });

    socket!.on(Get.find<Repository>().getStringValue(LocalKeys.chanelId),
        (data) async {
      print("channel data: $data");
      if (data['event'] == 'onnewindividualchatmessage') {
        var chatListsDoc = ChatListsDoc.fromJson(data['data']['messagedata']);
        var chatController = Get.find<ChatController>();

        if (Utility.currentChatPageId == data['data']['fromid']) {
          chatController.chatMessageList.insert(0, chatListsDoc);

          await chatController.postSeenMessage(data['data']['messageid']);
          // Ensure the chat UI updates immediately for the open conversation
          chatController.update();
        } else {
          await chatController.postDeliveredMessage(data['data']['messageid']);
        }

        // Update allFriends to keep the source of truth in sync
        var friendIndex = chatController.allFriends
            .indexWhere((element) => element.userid == data['data']['fromid']);
        if (friendIndex != -1) {
          var friendData = chatController.allFriends.removeAt(friendIndex);
          friendData.lastchatmessage = chatListsDoc;
          if (Utility.currentChatPageId == data['data']['fromid']) {
            friendData.unreadmessageCount = 0;
          } else {
            friendData.unreadmessageCount += 1;
          }
          chatController.allFriends.insert(0, friendData);
        }

        var index = chatController.chatPagingController.itemList
            ?.indexWhere((element) => element.userid == data['data']['fromid']);
        if (index?.isNegative == false) {
          int idx = index!;
          chatController.chatPagingController.itemList?[idx].lastchatmessage =
              null;
          chatController.chatPagingController.itemList?[idx].lastchatmessage =
              chatListsDoc;
          if (Utility.currentChatPageId == data['data']['fromid']) {
            chatController
                .chatPagingController.itemList?[idx].unreadmessageCount = 0;
          } else {
            chatController
                .chatPagingController.itemList?[idx].unreadmessageCount += 1;
          }
          var tempData = chatController.chatPagingController.itemList?[idx];
          if (tempData != null) {
            chatController.chatPagingController.itemList?.removeAt(idx);
            chatController.chatPagingController.itemList?.insert(0, tempData);
          }
          chatController.update();
        } else {
          chatController.chatPagingController.refresh();
        }
      } else if (data['event'] == "ongroupmemberadded") {
        if (data['data']['groupdata'] != null) {
          var chatListsDoc = GroupChatDatum.fromJson(data['data']['groupdata']);
          var index = Get.find<GroupChatController>()
              .groupListPagingController
              .itemList
              ?.indexWhere((element) => element.id == chatListsDoc.id);
          if (index?.isNegative ?? false) {
            Get.find<GroupChatController>()
                .groupListPagingController
                .itemList
                ?.insert(0, chatListsDoc);
          }
        } else {
          if (Utility.currentChatPageId == data['data']['groupid']) {
            var chatGroupListsDoc =
                ChatListsDoc.fromJson(data['data']['messagedata']);
            Get.find<ChatController>()
                .chatGroupMessageList
                .insert(0, chatGroupListsDoc);
            await Get.find<ChatController>()
                .postGroupSeenMessage(data['data']['messageid']);
          }
          Get.find<GroupChatController>().getOneGroup(data['data']['groupid']);
        }

        Get.forceAppUpdate();
      } else if (data['event'] == "onnewgroupchatmessage") {
        if (Utility.currentChatPageId == data['data']['toid']) {
          var chatGroupListsDoc =
              ChatListsDoc.fromJson(data['data']['messagedata']);
          var chatController = Get.find<ChatController>();
          chatController.chatGroupMessageList.insert(0, chatGroupListsDoc);
          await chatController.postGroupSeenMessage(data['data']['messageid']);
          // Ensure the group chat UI updates immediately for the open group
          chatController.update();
        } else {
          await Get.find<ChatController>()
              .postGroupDeliveredMessage(data['data']['messageid']);
        }
        var index = Get.find<GroupChatController>()
            .groupListPagingController
            .itemList
            ?.indexWhere((element) => element.id == data['data']['toid']);
        if (index?.isNegative == false) {
          Get.find<GroupChatController>()
              .groupListPagingController
              .itemList?[index!]
              .lastchatmessage = null;
          Get.find<GroupChatController>()
                  .groupListPagingController
                  .itemList?[index!]
                  .lastchatmessage =
              GroupLastchatmessage.fromJson(data['data']['messagedata']);
          if (Utility.currentChatPageId == data['data']['toid']) {
            Get.find<GroupChatController>()
                .groupListPagingController
                .itemList![index!]
                .unreadmessageCount = 0;
          } else {
            Get.find<GroupChatController>()
                .groupListPagingController
                .itemList![index!]
                .unreadmessageCount += 1;
          }
          var tempData = Get.find<GroupChatController>()
              .groupListPagingController
              .itemList![index];
          Get.find<GroupChatController>()
              .groupListPagingController
              .itemList
              ?.removeAt(index);
          Get.find<GroupChatController>()
              .groupListPagingController
              .itemList
              ?.insert(0, tempData);
        } else {
          Get.find<GroupChatController>().groupListPagingController.refresh();
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "ongroupmemberleave") {
        Get.find<GroupChatController>().groupListPagingController.refresh();
        Get.find<GroupChatController>().getOneGroup(data['data']['groupid']);
        Get.forceAppUpdate();
      } else if (data['event'] == "onmembersetasmanager") {
        if (Utility.currentChatPageId == data['data']['groupid']) {
          var chatGroupListsDoc =
              ChatListsDoc.fromJson(data['data']['messagedata']);
          Get.find<ChatController>()
              .chatGroupMessageList
              .insert(0, chatGroupListsDoc);
          await Get.find<ChatController>()
              .postGroupSeenMessage(data['data']['messageid']);
        } else {
          await Get.find<ChatController>()
              .postGroupDeliveredMessage(data['data']['messageid']);
        }
        Get.find<GroupChatController>().getOneGroup(data['data']['groupid']);
        Get.forceAppUpdate();
      } else if (data['event'] == "onmemberunsetasmanager") {
        // Get.find<GroupChatController>().groupListPagingController.refresh();
        if (Utility.currentChatPageId == data['data']['groupid']) {
          var chatGroupListsDoc =
              ChatListsDoc.fromJson(data['data']['messagedata']);
          Get.find<ChatController>()
              .chatGroupMessageList
              .insert(0, chatGroupListsDoc);
          await Get.find<ChatController>()
              .postGroupSeenMessage(data['data']['messageid']);
        } else {
          await Get.find<ChatController>()
              .postGroupDeliveredMessage(data['data']['messageid']);
        }
        Get.find<GroupChatController>().getOneGroup(data['data']['groupid']);
        Get.forceAppUpdate();
      } else if (data['event'] == "ongroupmemberremoved") {
        if (Utility.currentChatPageId == data['data']['groupid']) {
          var chatGroupListsDoc =
              ChatListsDoc.fromJson(data['data']['messagedata']);
          Get.find<ChatController>()
              .chatGroupMessageList
              .insert(0, chatGroupListsDoc);
          await Get.find<ChatController>()
              .postGroupSeenMessage(data['data']['messageid']);
        }
        Get.find<GroupChatController>().groupListPagingController.refresh();
        Get.find<GroupChatController>().getOneGroup(data['data']['groupid']);
        Get.forceAppUpdate();
      } else if (data['event'] == "onmessagedelivered") {
        if (Utility.currentChatPageId == data['data']['fromid']) {
          for (var i in Get.find<ChatController>().chatMessageList) {
            if (i.status == 'sent') {
              i.status = "delivered";
            }
          }
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "onmessageseen") {
        if (Utility.currentChatPageId == data['data']['fromid']) {
          for (var i in Get.find<ChatController>().chatMessageList) {
            if (i.status != 'seen') {
              i.status = "seen";
            }
          }
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "ongroupmessagedelivered") {
        if (Get.find<ChatController>()
            .chatGroupMessageList
            .any((element) => element.id == data['data']['messageid'])) {
          for (var i in Get.find<ChatController>().chatGroupMessageList) {
            var index = i.statuses?.indexWhere(
                (element) => element.userid?.id == data['data']['fromid']);
            if (index?.isNegative == false) {
              if (i.statuses?[index!].status == 'sent') {
                i.statuses?[index!].status = "delivered";
              }
            }
          }
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "ongroupmessageseen") {
        if (Get.find<ChatController>()
            .chatGroupMessageList
            .any((element) => element.id == data['data']['messageid'])) {
          for (var i in Get.find<ChatController>().chatGroupMessageList) {
            var index = i.statuses?.indexWhere(
                (element) => element.userid?.id == data['data']['fromid']);
            if (index?.isNegative == false) {
              if (i.statuses?[index!].status != 'seen') {
                i.statuses?[index!].status = "seen";
              }
            }
          }
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "onnewfriendrequest") {
        if (Get.isRegistered<RequestController>()) {
          Get.find<RequestController>().receivedPagingController.refresh();
        }
        if (Get.isRegistered<FindFriendController>()) {
          Get.find<FindFriendController>().pagingController.refresh();
        }
      } else if (data['event'] == "onfriendrequestaccepted" ||
          data['event'] == "onfriendrequestunblocked") {
        if (Get.isRegistered<RequestController>()) {
          Get.find<RequestController>().pagingController.refresh();
          Get.find<ChatController>().chatPagingController.refresh();
        }
        Get.find<ChatController>().chatPagingController.refresh();
      } else if (data['event'] == "onfriendrequestblocked") {
        Get.find<ChatController>().chatPagingController.refresh();
        if (Get.isRegistered<RequestController>()) {
          Get.find<RequestController>().pagingController.refresh();
          Get.find<RequestController>().blockUserPagingController.refresh();
        }
      } else if (data['event'] == "onfriendrequestrejected") {
        if (Get.isRegistered<RequestController>()) {
          var index = Get.find<RequestController>()
              .pagingController
              .itemList
              ?.indexWhere(
                  (element) => element.senderid?.id == data['data']['toid']);
          if (index?.isNegative == false) {
            Get.find<RequestController>()
                .pagingController
                .itemList![index!]
                .status = 'rejected';
            Get.find<RequestController>().update();
          }
        }
      } else if (data['event'] == "onindividualchatmessagedeleted" ||
          data['event'] == "onindividualchatmessageedited" ||
          data['event'] == "onreactionaddedtoindividualchatmessage" ||
          data['event'] == "onreactionremovedfromindividualchatmessage") {
        if (Utility.currentChatPageId == data['data']['fromid']) {
          var chatListsDoc = ChatListsDoc.fromJson(data['data']['messagedata']);

          var index = Get.find<ChatController>()
              .chatMessageList
              .indexWhere((element) => element.id == data['data']['messageid']);
          if (index.isNegative == false) {
            Get.find<ChatController>().chatMessageList[index] = chatListsDoc;
            Get.forceAppUpdate();
          }
        }
      } else if (data['event'] == "ongroupchatmessagedeleted" ||
          data['event'] == "ongroupchatmessageedited" ||
          data['event'] == "onreactionaddedtogroupchatmessage" ||
          data['event'] == "onreactionremovedfromgroupchatmessage") {
        if (Utility.currentChatPageId == data['data']['groupid']) {
          var chatListsDoc = ChatListsDoc.fromJson(data['data']['messagedata']);

          var index = Get.find<ChatController>()
              .chatGroupMessageList
              .indexWhere((element) => element.id == data['data']['messageid']);
          if (index.isNegative == false) {
            Get.find<ChatController>().chatGroupMessageList[index] =
                chatListsDoc;
            Get.forceAppUpdate();
          }
        }
      } else if (data['event'] == "onuserleavethecall") {
        Utility.audioPlayer.pause();
        // Do not force-close active call screens when a participant leaves.
        // Agora onUserOffline handles in-call participant removal.
        if (Get.isRegistered<VideoCallController>() ||
            Get.isRegistered<AudioCallController>()) {
          // keep ongoing call UI open
        } else if (data['data']['calldata']['isvideocall'] == true ||
            data['data']['calldata']['isaudiocall'] == true) {
          await CallingKitService.endAllCalls();
        }
      } else if (data['event'] == "oncallendedbyhost" || data['event'] == "oncallcancelled") {
        print("[ANTIGRAVITY_DEBUG] Call ended by host event received");
        Utility.audioPlayer.pause();
        await CallingKitService.endAllCalls();
        if (Get.isRegistered<VideoCallController>()) {
          Get.find<VideoCallController>().disposeAgora();
          if (Get.currentRoute == Routes.videoCallScreen) {
            Get.back();
          }
        }
        if (Get.isRegistered<AudioCallController>()) {
          Get.find<AudioCallController>().disposeAgora();
          if (Get.currentRoute == Routes.audioCallScreen) {
            Get.back();
          }
        }
        if (Get.isRegistered<MeetingCallController>()) {
          Get.find<MeetingCallController>().disposeAgora();
          if (Get.currentRoute == Routes.meetingCallScreen) {
            Get.back();
          }
        }
      } else if (data['event'] == "onuserkicked") {
        print("[ANTIGRAVITY_DEBUG] User kicked event received: $data");
        final kickedUserId = data['data']['kickeduserid'].toString();
        final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
        
        if (kickedUserId == currentUserId) {
          Utility.audioPlayer.pause();
          await CallingKitService.endAllCalls();
          if (Get.isRegistered<VideoCallController>()) {
            Get.find<VideoCallController>().disposeAgora();
            if (Get.currentRoute == Routes.videoCallScreen) {
              Get.back();
            }
          }
          if (Get.isRegistered<AudioCallController>()) {
            Get.find<AudioCallController>().disposeAgora();
            if (Get.currentRoute == Routes.audioCallScreen) {
              Get.back();
            }
          }
          if (Get.isRegistered<MeetingCallController>()) {
            Get.find<MeetingCallController>().disposeAgora();
            if (Get.currentRoute == Routes.meetingCallScreen) {
              Get.back();
            }
          }
          Utility.showMessage("You have been removed from the call", MessageType.information, () => null, "OK");
        }
      } else if (data['event'] == "onincomingmeetingcall") {
        var meetingdata = HostMeetingDoc.fromJson(data['data']['meetingdata']);

        if (Get.isRegistered<MeetingController>()) {
          Get.find<MeetingController>().hostMeetingDoc = meetingdata;

          Get.find<MeetingController>().joinPagingController.refresh();
        }

        // Trigger CallKit UI for Meeting
        FirebaseApi.currentUuid = const Uuid().v4();
        FirebaseApi.showCallkitIncoming(
          FirebaseApi.currentUuid ?? '',
          meetingdata.agorameta?.channelName ?? "",
          meetingdata.agorameta?.token ?? "",
          meetingdata.id ?? "",
          "meeting", // Identify this as a meeting call
          data['data']['banner'] ?? "",
          data['data']['fromusername'] ?? "Meeting",
        );

        Get.forceAppUpdate();
      } else if (data['event'] == "onmeetingcallleave") {
        if (Get.isRegistered<MeetingController>()) {
          var meetingdata =
              HostMeetingDoc.fromJson(data['data']['meetingdata']);
          Get.find<MeetingController>().hostMeetingDoc = meetingdata;
        }
        Get.forceAppUpdate();
      } else if (data['event'] == "onincomingindividualcall") {
        print("[ANTIGRAVITY_DEBUG] Incoming Call Data: $data");

        var callDataRoot = data['data'];
        var callDataNested = callDataRoot['calldata'] ?? {};
        var callAgoraMeta = callDataNested['agorameta'] ?? {};
        final bool isVideoCall = _toBool(callDataRoot['isvideocall']) ||
            _toBool(callDataNested['isvideocall']);
        final bool isAudioCall = _toBool(callDataRoot['isaudiocall']) ||
            _toBool(callDataNested['isaudiocall']);
        final String callTypeForKit = isVideoCall ? "yes" : "no";

        FirebaseApi.isVideo = isVideoCall;
        Get.forceAppUpdate();
        FirebaseApi.currentUuid = const Uuid().v4();

        // Extract credentials with fallback to nested calldata
        String agorachannelName = callDataRoot['agorachannelName'] ??
            callDataNested['agorachannelName'] ??
            callAgoraMeta['channelName'] ??
            callDataNested['_id'] ??
            "";
        String agoratoken = callDataRoot['agoratoken'] ??
            callDataNested['agoratoken'] ??
            callAgoraMeta['token'] ??
            "";
        String callid = callDataRoot['callid'] ??
            callDataNested['callid'] ??
            callDataNested['_id'] ??
            "";
        String banner = callDataRoot['banner'] ?? "";
        String fromusername = callDataRoot['fromusername'] ?? "";

        print(
            "[ANTIGRAVITY_DEBUG] Extracted: channel=$agorachannelName, token=$agoratoken, id=$callid");

        if (isVideoCall) {
          FirebaseApi.showCallkitIncoming(
            FirebaseApi.currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
          );
          Get.find<Repository>().saveSecureValue("Data", "123");
        } else if (isAudioCall) {
          FirebaseApi.showCallkitIncoming(
            FirebaseApi.currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
          );
        }
      } else if (data['event'] == "onincominggroupcall") {
        print("[ANTIGRAVITY_DEBUG] Incoming Group Call Data: $data");

        var callDataRoot = data['data'];
        var callDataNested = callDataRoot['calldata'] ?? {};
        var callAgoraMeta = callDataNested['agorameta'] ?? {};
        final bool isVideoCall = _toBool(callDataRoot['isvideocall']) ||
            _toBool(callDataNested['isvideocall']);
        final bool isAudioCall = _toBool(callDataRoot['isaudiocall']) ||
            _toBool(callDataNested['isaudiocall']);
        final String callTypeForKit = isVideoCall ? "yes" : "no";

        FirebaseApi.isVideo = isVideoCall;
        Get.forceAppUpdate();
        FirebaseApi.currentUuid = const Uuid().v4();

        // Extract credentials with fallback
        String agorachannelName = callDataRoot['agorachannelName'] ??
            callDataNested['agorachannelName'] ??
            callAgoraMeta['channelName'] ??
            callDataNested['_id'] ??
            "";
        String agoratoken = callDataRoot['agoratoken'] ??
            callDataNested['agoratoken'] ??
            callAgoraMeta['token'] ??
            "";
        String callid = callDataRoot['callid'] ??
            callDataNested['callid'] ??
            callDataNested['_id'] ??
            "";
        String banner = callDataRoot['banner'] ?? "";
        String fromusername = callDataRoot['fromusername'] ?? "";

        if (isVideoCall) {
          FirebaseApi.showCallkitIncoming(
            FirebaseApi.currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
          );
          Get.find<Repository>().saveSecureValue("Data", "123");
        } else if (isAudioCall) {
          FirebaseApi.showCallkitIncoming(
            FirebaseApi.currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
          );
        }
      }
    });
    socket!.onDisconnect((_) => print('Connection Disconnection'));
    socket!.onConnectError((err) => print("Connection Error: $err"));
    socket!.onError((err) => print("Socket Error: $err"));
  }
}
