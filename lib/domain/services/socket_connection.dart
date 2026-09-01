import 'dart:convert';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/domain/services/call_ringtone_manager.dart';
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

  static String _currentListeningChannelId = '';
  static String _lastProcessedKickedCallId = '';
  static DateTime? _lastProcessedKickedTime;

  static void registerUserChannel([String? specificChannelId]) {
    final channelId = (specificChannelId != null && specificChannelId.trim().isNotEmpty)
        ? specificChannelId.trim()
        : (Get.isRegistered<Repository>()
            ? Get.find<Repository>().getStringValue(LocalKeys.chanelId).trim()
            : '');

    if (channelId.isEmpty) return;

    print("[ANTIGRAVITY_SOCKET] Registering user channel: $channelId");

    if (socket != null && socket!.connected) {
      socket!.emit('init', {'channelID': channelId});
    }

    if (_currentListeningChannelId != channelId) {
      if (_currentListeningChannelId.isNotEmpty) {
        socket?.off(_currentListeningChannelId);
      }
      _currentListeningChannelId = channelId;
      socket?.off(channelId);
      socket?.on(channelId, _handleChannelData);
      print("[ANTIGRAVITY_SOCKET] Attached listener to channel: $channelId");
    }
  }

  static initSocket() {
    if (socket != null && socket!.connected) {
      registerUserChannel();
      return;
    }

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
      print("✅ [ANTIGRAVITY_SOCKET] Connected to socket server");
      registerUserChannel();
    });

    socket!.onReconnect((_) {
      print("✅ [ANTIGRAVITY_SOCKET] Reconnected to socket server");
      registerUserChannel();
    });

    registerUserChannel();

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
    socket!.onReconnect((_) {
      print("✅ RECONNECTED");
      if (Get.isRegistered<AudioCallController>()) {
        final ctrl = Get.find<AudioCallController>();
        if (ctrl.callId.isNotEmpty) {
          socket?.emit("join-call-room", {"callId": ctrl.callId});
        }
      }
      if (Get.isRegistered<VideoCallController>()) {
        final ctrl = Get.find<VideoCallController>();
        if (ctrl.callId.isNotEmpty) {
          socket?.emit("join-call-room", {"callId": ctrl.callId});
        }
      }
    });

    socket?.on("call-rejected", (data) async {
      final id = (data is Map ? (data['callId'] ?? data['callid'] ?? data['data']?['callid'] ?? data['data']?['callId']) : data).toString();
      print("\n[CALL][REMOTE_DECLINE_RECEIVED]");
      print("callId=$id data=$data\n");
      await CallRingtoneManager.stopRingtone(callId: id, reason: "declined");

      final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
      final currentUserId = Get.isRegistered<Repository>() ? Get.find<Repository>().getStringValue(LocalKeys.userIds) : "";

      if (Get.isRegistered<AudioCallController>()) {
        final ctrl = Get.find<AudioCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            print("[CALL] Multi-party conference active: handling participant left: $fromUserId");
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            print("[CALL][REMOTE_DECLINE_MATCHED]");
            print("callId=${ctrl.callId}\n");
            ctrl.handleRemoteCallTermination(reason: "Call declined");
          }
        }
      }
      if (Get.isRegistered<VideoCallController>()) {
        final ctrl = Get.find<VideoCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            print("[CALL] Multi-party conference active: handling participant left: $fromUserId");
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            print("[CALL][REMOTE_DECLINE_MATCHED]");
            print("callId=${ctrl.callId}\n");
            ctrl.handleRemoteCallTermination(reason: "Call declined");
          }
        }
      }
    });

    socket?.on("call-cancelled", (data) async {
      final id = (data is Map ? (data['callId'] ?? data['callid'] ?? data['data']?['callid']) : data).toString();
      print("\n[CALL][REMOTE_CANCEL_RECEIVED]");
      print("callId=$id data=$data\n");
      await CallRingtoneManager.stopRingtone(callId: id, reason: "cancelled");

      final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
      final currentUserId = Get.isRegistered<Repository>() ? Get.find<Repository>().getStringValue(LocalKeys.userIds) : "";

      if (Get.isRegistered<AudioCallController>()) {
        final ctrl = Get.find<AudioCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            ctrl.handleRemoteCallTermination(reason: "Call cancelled");
          }
        }
      }
      if (Get.isRegistered<VideoCallController>()) {
        final ctrl = Get.find<VideoCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            ctrl.handleRemoteCallTermination(reason: "Call cancelled");
          }
        }
      }
    });

    socket?.on("call-ended", (data) async {
      final id = (data is Map ? (data['callId'] ?? data['callid'] ?? data['data']?['callid']) : data).toString();
      print("\n[CALL][REMOTE_END_RECEIVED]");
      print("callId=$id data=$data\n");
      await CallRingtoneManager.stopRingtone(callId: id, reason: "ended");

      final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
      final currentUserId = Get.isRegistered<Repository>() ? Get.find<Repository>().getStringValue(LocalKeys.userIds) : "";

      if (Get.isRegistered<AudioCallController>()) {
        final ctrl = Get.find<AudioCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            ctrl.handleRemoteCallTermination(reason: "Call ended");
          }
        }
      }
      if (Get.isRegistered<VideoCallController>()) {
        final ctrl = Get.find<VideoCallController>();
        if (id.isEmpty || ctrl.callId == id) {
          if (ctrl.isMultiPartyConference) {
            if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
              ctrl.handleParticipantLeft(fromUserId, callId: id);
            }
          } else {
            ctrl.handleRemoteCallTermination(reason: "Call ended");
          }
        }
      }
    });

    socket?.on("user-left", (data) async {
      print("[ANTIGRAVITY_DEBUG] Top-level user-left socket event: $data");
      final callId = (data is Map ? (data['callId'] ?? data['callid']) : "").toString();
      final leftUserId = (data is Map ? (data['leftUserId'] ?? data['fromUserId']) : "").toString();
      if (Get.isRegistered<AudioCallController>()) {
        Get.find<AudioCallController>().handleParticipantLeft(leftUserId, callId: callId);
      }
      if (Get.isRegistered<VideoCallController>()) {
        Get.find<VideoCallController>().handleParticipantLeft(leftUserId, callId: callId);
      }
    });

    socket?.on("stop-ringtone", (data) async {
      final id = (data is Map ? (data['callId'] ?? data['callid']) : data)?.toString();
      await CallRingtoneManager.stopRingtone(callId: id, reason: "stop-ringtone");
    });

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

    socket!.onDisconnect((_) => print('Connection Disconnection'));
    socket!.onConnectError((err) => print("Connection Error: $err"));
    socket!.onError((err) => print("Socket Error: $err"));
  }

  static void _handleChannelData(dynamic data) async {
    print("channel data: $data");
      if (data != null && (data['event'] == 'forcelogout' || data['event'] == 'userlogout')) {
        if (!ApiWrapper.isHandlingUnauthorized) {
          ApiWrapper.isHandlingUnauthorized = true;
          socketDisconnect();
          Get.find<Repository>().deleteAllSecuredValues();
          RouteManagement.goToLoginView();
          Utility.showMessage(
            "Session expired or logged in from another device".tr,
            MessageType.error,
            () => null,
            '',
          );
          Future.delayed(const Duration(seconds: 4), () {
            ApiWrapper.isHandlingUnauthorized = false;
          });
        }
        return;
      }
      if (data['event'] == 'onnewindividualchatmessage') {
        var chatListsDoc = ChatListsDoc.fromJson(data['data']['messagedata']);
        final fromId = (data['data']['fromid'] ?? "").toString();

        if (Get.isRegistered<ChatController>()) {
          var chatController = Get.find<ChatController>();

          if (fromId.isNotEmpty && Utility.currentChatPageId == fromId) {
            final existingMsgIndex = chatController.chatMessageList
                .indexWhere((e) => e.id == chatListsDoc.id);
            if (existingMsgIndex == -1) {
              chatController.chatMessageList.insert(0, chatListsDoc);
            } else {
              chatController.chatMessageList[existingMsgIndex] = chatListsDoc;
            }
            ChatController.userChatCache[fromId] =
                List.from(chatController.chatMessageList);

            await chatController.postSeenMessage(data['data']['messageid']);
            chatController.update();
          } else {
            await chatController.postDeliveredMessage(data['data']['messageid']);
          }

          if (fromId.isNotEmpty) {
            var friendIndex = chatController.allFriends
                .indexWhere((element) => element.userid == fromId);
            if (friendIndex != -1) {
              var friendData = chatController.allFriends.removeAt(friendIndex);
              friendData.lastchatmessage = chatListsDoc;
              if (Utility.currentChatPageId == fromId) {
                friendData.unreadmessageCount = 0;
              } else {
                friendData.unreadmessageCount =
                    (friendData.unreadmessageCount ?? 0) + 1;
              }
              chatController.allFriends.insert(0, friendData);
            } else {
              final senderName = (data['data']['fromusername'] ?? "").toString();
              final profileImage = (data['data']['banner'] ?? "").toString();
              final fromMobile = (chatListsDoc.from?.mobile ?? "").toString();
              final fromCountryCode =
                  (chatListsDoc.from?.countryCode ?? "").toString();

              var newFriend = MyFriendDatum(
                userid: fromId,
                fullname: senderName.isNotEmpty
                    ? senderName
                    : (fromMobile.isNotEmpty ? fromMobile : "User"),
                nickname: senderName,
                profileimage: profileImage,
                mobile: fromMobile,
                countryCode: fromCountryCode,
                lastchatmessage: chatListsDoc,
                unreadmessageCount: Utility.currentChatPageId == fromId ? 0 : 1,
              );
              chatController.allFriends.insert(0, newFriend);
            }

            chatController.applyLocalFilter();
            chatController.update();
          }
        }
      } else if (data['event'] == "ongroupmemberadded") {
        if (data['data']['groupdata'] != null) {
          var chatListsDoc = GroupChatDatum.fromJson(data['data']['groupdata']);
          if (Get.isRegistered<GroupChatController>()) {
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
          }
        } else {
          if (Utility.currentChatPageId == data['data']['groupid']) {
            var chatGroupListsDoc =
                ChatListsDoc.fromJson(data['data']['messagedata']);
            if (Get.isRegistered<ChatController>()) {
              Get.find<ChatController>()
                  .chatGroupMessageList
                  .insert(0, chatGroupListsDoc);
            }
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
      } else if (data['event'] == "onuserjointhecall") {
        print("[ANTIGRAVITY_DEBUG] User joined the call socket event received: $data");
        Utility.audioPlayer.stop();

        final rawData = data['data'] ?? data;
        final calldata = rawData is Map ? (rawData['calldata'] ?? rawData['callData']) : null;
        final members = calldata is Map ? calldata['members'] : null;

        if (members != null && members is List && members.isNotEmpty) {
          if (Get.isRegistered<AudioCallController>()) {
            Get.find<AudioCallController>().cacheCallMembers(members);
          }
          if (Get.isRegistered<VideoCallController>()) {
            Get.find<VideoCallController>().cacheCallMembers(members);
          }
        }

        if (Get.isRegistered<AudioCallController>()) {
          Get.find<AudioCallController>().handleRemoteUserJoined();
        }
        if (Get.isRegistered<VideoCallController>()) {
          Get.find<VideoCallController>().handleRemoteUserJoined();
        }
      } else if (data['event'] == "onuserleavethecall") {
        final eventCallId = (data['data']?['calldata']?['id'] ?? data['data']?['calldata']?['_id'] ?? data['data']?['callid'] ?? data['data']?['callId'] ?? "").toString();
        Utility.audioPlayer.stop();

        String leftUserId = "";
        try {
          final fromIdRaw = data['data']?['fromid'];
          if (fromIdRaw is Map) {
            leftUserId = (fromIdRaw['userid'] ?? fromIdRaw['_id'] ?? fromIdRaw['id'] ?? "").toString();
          } else if (fromIdRaw is String && fromIdRaw.startsWith("{")) {
            final parsed = jsonDecode(fromIdRaw);
            leftUserId = (parsed['userid'] ?? parsed['_id'] ?? parsed['id'] ?? "").toString();
          }
        } catch (_) {}
        if (leftUserId.isEmpty) {
          leftUserId = (data['data']?['kickeduserid'] ?? data['data']?['fromUserId'] ?? "").toString();
        }

        print("[ANTIGRAVITY_DEBUG] onuserleavethecall received for leftUserId=$leftUserId in callId=$eventCallId");

        if (Get.isRegistered<VideoCallController>()) {
          final ctrl = Get.find<VideoCallController>();
          if (eventCallId.isEmpty || ctrl.callId == eventCallId) {
            ctrl.handleParticipantLeft(leftUserId, callId: eventCallId);
          }
        }
        if (Get.isRegistered<AudioCallController>()) {
          final ctrl = Get.find<AudioCallController>();
          if (eventCallId.isEmpty || ctrl.callId == eventCallId) {
            ctrl.handleParticipantLeft(leftUserId, callId: eventCallId);
          }
        }
      } else if (data['event'] == "oncallendedbyhost" ||
          data['event'] == "oncallcancelled" ||
          data['event'] == "oncallrejected" ||
          data['event'] == "oncallended") {
        print("[ANTIGRAVITY_DEBUG] Call ended/rejected/cancelled event received: ${data['event']}");
        final eventCallId = (data['data']?['calldata']?['id'] ?? data['data']?['calldata']?['_id'] ?? data['data']?['callid'] ?? data['data']?['callId'] ?? data['data']?['id'] ?? "").toString();

        String fromUserId = "";
        try {
          final fromIdRaw = data['data']?['fromid'];
          if (fromIdRaw is Map) {
            fromUserId = (fromIdRaw['userid'] ?? fromIdRaw['_id'] ?? fromIdRaw['id'] ?? "").toString();
          } else if (fromIdRaw is String && fromIdRaw.startsWith("{")) {
            final parsed = jsonDecode(fromIdRaw);
            fromUserId = (parsed['userid'] ?? parsed['_id'] ?? parsed['id'] ?? "").toString();
          }
        } catch (_) {}

        final String reason = data['event'] == "oncallrejected"
            ? "Call declined"
            : (data['event'] == "oncallcancelled" ? "Call cancelled" : "Call ended");

        if (Get.isRegistered<VideoCallController>()) {
          final ctrl = Get.find<VideoCallController>();
          if (eventCallId.isEmpty || ctrl.callId == eventCallId) {
            if (ctrl.isMultiPartyConference) {
              if (fromUserId.isNotEmpty) {
                ctrl.handleParticipantLeft(fromUserId, callId: eventCallId);
              }
            } else {
              Utility.audioPlayer.stop();
              CallingKitService.endAllCalls();
              ctrl.handleRemoteCallTermination(reason: reason);
            }
          }
        }
        if (Get.isRegistered<AudioCallController>()) {
          final ctrl = Get.find<AudioCallController>();
          if (eventCallId.isEmpty || ctrl.callId == eventCallId) {
            if (ctrl.isMultiPartyConference) {
              if (fromUserId.isNotEmpty) {
                ctrl.handleParticipantLeft(fromUserId, callId: eventCallId);
              }
            } else {
              Utility.audioPlayer.stop();
              CallingKitService.endAllCalls();
              ctrl.handleRemoteCallTermination(reason: reason);
            }
          }
        }
        if (Get.isRegistered<MeetingCallController>()) {
          Get.find<MeetingCallController>().disposeAgora();
          if (Get.currentRoute == Routes.meetingCallScreen) {
            Get.back();
          }
        }
      } else if (data['event'] == "onuserkicked") {
        final rawData = data['data'] ?? {};
        final kickedUserId = (rawData['kickeduserid'] ?? rawData['participantId'] ?? "").toString();
        final callId = (rawData['callId'] ?? rawData['callid'] ?? rawData['conferenceId'] ?? (rawData['calldata'] != null ? (rawData['calldata']['id'] ?? rawData['calldata']['_id']) : "") ?? "").toString();
        final currentUserId = Get.isRegistered<Repository>()
            ? Get.find<Repository>().getStringValue(LocalKeys.userIds)
            : "";
        
        if (kickedUserId == currentUserId && currentUserId.isNotEmpty) {
          final now = DateTime.now();
          if (_lastProcessedKickedCallId == callId &&
              _lastProcessedKickedTime != null &&
              now.difference(_lastProcessedKickedTime!).inSeconds < 5) {
            print("[CONFERENCE DEBUG] Ignoring duplicate HOST_REMOVED for callId = $callId");
            return;
          }
          _lastProcessedKickedCallId = callId;
          _lastProcessedKickedTime = now;

          print("\n[CONFERENCE DEBUG]");
          print("HOST_REMOVED RECEIVED");
          print("callId = $callId");
          print("conferenceId = $callId");
          print("participantId = $kickedUserId\n");

          print("[CONFERENCE DEBUG]");
          print("CLEAR ACTIVE CALL STATE\n");

          print("[CONFERENCE DEBUG]");
          print("STOP MEDIA\n");
          Utility.audioPlayer.stop();

          print("[CONFERENCE DEBUG]");
          print("CLEAR RETURN-TO-CALL STATE\n");

          print("[CONFERENCE DEBUG]");
          print("REMOVE CALL NOTIFICATION\n");
          await CallingKitService.endAllCalls();

          if (Get.isRegistered<VideoCallController>()) {
            final videoCtrl = Get.find<VideoCallController>();
            videoCtrl.isCallEnded = true;
            await videoCtrl.disposeAgora();
          }
          if (Get.isRegistered<AudioCallController>()) {
            final audioCtrl = Get.find<AudioCallController>();
            audioCtrl.isCallEnded = true;
            await audioCtrl.disposeAgora();
          }
          if (Get.isRegistered<MeetingCallController>()) {
            final meetingCtrl = Get.find<MeetingCallController>();
            meetingCtrl.isCallEnded = true;
            await meetingCtrl.disposeAgora();
          }

          if (Get.isRegistered<CallManagerService>()) {
            await Get.find<CallManagerService>().endCall();
          }

          print("[CONFERENCE DEBUG]");
          print("NAVIGATE OUT OF CALL\n");
          if (Get.currentRoute == Routes.videoCallScreen ||
              Get.currentRoute == Routes.audioCallScreen ||
              Get.currentRoute == Routes.meetingCallScreen) {
            Get.back();
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
          source: "socket_meeting",
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

        var callDataRoot = data['data'] ?? {};
        var callDataNested = callDataRoot['calldata'] ?? {};
        var callAgoraMeta = (callDataNested['agorameta'] is Map ? callDataNested['agorameta'] : null) ??
            (callDataRoot['agorameta'] is Map ? callDataRoot['agorameta'] : null) ?? {};
        final bool isVideoCall = _toBool(callDataRoot['isvideocall']) ||
            _toBool(callDataNested['isvideocall']);
        final bool isAudioCall = _toBool(callDataRoot['isaudiocall']) ||
            _toBool(callDataNested['isaudiocall']);
        final String callTypeForKit = isVideoCall ? "yes" : "no";

        FirebaseApi.isVideo = isVideoCall;
        Get.forceAppUpdate();
        FirebaseApi.currentUuid = const Uuid().v4();

        // Standardize canonical callId and channel name
        String callid = (callDataRoot['callid'] ??
            callDataNested['callid'] ??
            callDataNested['_id'] ??
            callDataRoot['_id'] ??
            "").toString().trim();
        String agorachannelName = (callDataRoot['agorachannelName'] ??
            callDataNested['agorachannelName'] ??
            callAgoraMeta['channelName'] ??
            callid).toString().trim();
        String agoratoken = (callDataRoot['agoratoken'] ??
            callDataNested['agoratoken'] ??
            callAgoraMeta['token'] ??
            "").toString().trim();
        String fromid = (callDataRoot['fromid'] ??
            callDataNested['from'] ??
            callDataRoot['from'] ??
            "").toString();
        String banner = callDataRoot['banner'] ?? "";
        String fromusername = callDataRoot['fromusername'] ?? "";

        print("\n[CALL]");
        print("CALL RECEIVED callId = $callid\n");

        print(
            "[ANTIGRAVITY_DEBUG] Extracted: channel=$agorachannelName, token=$agoratoken, id=$callid, fromid=$fromid");

        if (isVideoCall) {
          FirebaseApi.showCallkitIncoming(
            FirebaseApi.currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
            fromid: fromid,
            source: "socket_video",
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
            fromid: fromid,
            source: "socket_audio",
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
            source: "socket_group_video",
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
            source: "socket_group_audio",
          );
        }
      }
  }
}
