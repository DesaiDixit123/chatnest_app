import 'package:flutter/foundation.dart';
import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class ChatUsecases {
  ChatUsecases(this.repository);

  final Repository repository;

  Future<GetOneFriendsModel?> getOneFriends({
    bool isLoading = false,
    required String userid,
  }) async {
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ChatUsecases.getOneFriends called for userid: $userid");
    var result = await repository.getOneFriends(
      isLoading: isLoading,
      userid: userid,
    );
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ChatUsecases.getOneFriends result: ${result != null}");
    return result;
  }

  Future<GetUserStatusModel?> getOneUserStatus({
    bool isLoading = false,
    required String userid,
  }) async =>
      await repository.getOneUserStatus(
        isLoading: isLoading,
        userid: userid,
      );

  Future<ChatListsModel?> getChatLists({
    bool isLoading = false,
    required String userid,
    required String search,
    required int page,
    required int limit,
  }) async =>
      await repository.getChatLists(
        isLoading: isLoading,
        userid: userid,
        page: page,
        limit: limit,
        search: search,
      );

  Future<GetOnePollsModel?> createPolls({
    bool isLoading = false,
    required String pollid,
    required String polltitle,
    required List<String> optionsList,
    required bool allowmultipleans,
  }) async =>
      await repository.createPolls(
        isLoading: isLoading,
        pollid: pollid,
        polltitle: polltitle,
        optionsList: optionsList,
        allowmultipleans: allowmultipleans,
      );

  Future<GetOnePollsModel?> getOnePoll({
    bool isLoading = false,
    required String pollid,
  }) async =>
      await repository.getOnePoll(
        isLoading: isLoading,
        pollid: pollid,
      );

  Future<ChatListsDoc?> sendMessage({
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    PhoneContact? phonecontactData,
    bool isLoading = false,
  }) async =>
      await repository.sendMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        pollid: pollid,
        context: context,
        usersList: usersList,
        mediaFileList: mediaFileList,
        phonecontactData: phonecontactData,
      );

  Future<ChatListsDoc?> postChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      await repository.postChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<ChatListsDoc?> postGroupChatSendBulkMessage({
    required String receiverid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      await repository.postGroupChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<ResponseModel?> postDeliveredMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  ///////////////////////////////////////////////////
  ///
  ///
  ///
  Future<ResponseModel?> sendGroupMessage({
    bool isLoading = false,
    required String receiverid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    PhoneContact? phonecontactData,
  }) async =>
      await repository.sendGroupMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        pollid: pollid,
        context: context,
        usersList: usersList,
        mediaFileList: mediaFileList,
        phonecontactData: phonecontactData,
      );

  Future<ChatListsModel?> getGroupChatLists({
    bool isLoading = false,
    required String groupid,
    required String search,
    required int page,
    required int limit,
  }) async =>
      await repository.getGroupChatLists(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
        search: search,
      );

  Future<ResponseModel?> postGroupDeliveredMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postGroupDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postGroupSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postGroupSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postChatDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async =>
      await repository.postChatDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );

  Future<ResponseModel?> postChatMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async =>
      await repository.postChatMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );

  Future<ReactionChatModel?> postChatBookmarkAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatBookmarkAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatFavoriteAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatFavoriteAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async =>
      await repository.postChatMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
  Future<ReactionChatModel?> postChatMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postChatGroupDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );

  Future<ResponseModel?> postChatGroupMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );

  Future<ReactionChatModel?> postChatGroupBookmarkAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupBookmarkRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatGroupFavoriteAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupFavoriteRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatGroupMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
  Future<ReactionChatModel?> postChatGroupMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postChatGroupMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ResponseModel?> postChatPinUnPin({
    required String userid,
    required bool isPinned,
    bool isLoading = false,
  }) async =>
      await repository.postChatPinUnPin(
        isLoading: isLoading,
        userid: userid,
        isPinned: isPinned,
      );
  Future<ResponseModel?> postGroupChatPinUnPin({
    required String groupid,
    required bool isPinned,
    bool isLoading = false,
  }) async =>
      await repository.postGroupChatPinUnPin(
        isLoading: isLoading,
        groupid: groupid,
        isPinned: isPinned,
      );

  Future<ResponseModel?> postChatForward({
    required String messageid,
    required List<String> forwardto,
    bool isLoading = false,
  }) async =>
      await repository.postChatForward(
        isLoading: isLoading,
        messageid: messageid,
        forwardto: forwardto,
      );

  // post call initiate api
  Future<GetCallInitiatedDataModel?> postCallInitaite({
    bool isLoading = false,
    required String receiverId,
    required bool isVideoCall,
    required bool isAudioCall,
    required bool isGroupCall,
  }) async =>
      await repository.postCallInitaite(
        isLoading: isLoading,
        isAudioCall: isAudioCall,
        isGroupCall: isGroupCall,
        isVideoCall: isVideoCall,
        receiverId: receiverId,
      );

  Future<GetOneBroadcastModel?> getOneBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.getOneBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ChatListsModel?> postChatListBroadcast({
    required int page,
    required int limit,
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.postChatListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        broadcastid: broadcastid,
      );

  Future<BroadcastListModel?> postListBroadcast({
    required int page,
    required int limit,
    required String search,
    bool isLoading = false,
  }) async =>
      await repository.postListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<ChatListsDoc?> postSendMessageBroadcast({
    required String broadcastid,
    String? message,
    String? product,
    String? latitude,
    String? longitude,
    String? pollid,
    String? context,
    List<String>? usersList,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      await repository.postSendMessageBroadcast(
        broadcastid: broadcastid,
        message: message,
        product: product,
        latitude: latitude,
        longitude: longitude,
        usersList: usersList,
        pollid: pollid,
        context: context,
        mediaFileList: mediaFileList,
        isLoading: isLoading,
      );

  Future<ChatListsDoc?> postSendMultiMediaBroadcast({
    required String broadcastid,
    String? message,
    String? context,
    List<ImageFormData>? mediaFileList,
    bool isLoading = false,
  }) async =>
      await repository.postSendMultiMediaBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<ResponseModel?> postSendFcmApi({
    required String registrationToken,
    required String userName,
    required String callid,
    required String agoratoken,
    required String type,
    required String banner,
    required String fromid,
    required String toid,
    required String agorachannelName,
    required String isaudiocall,
    required String isgroupcall,
    required String isvideocall,
    required String authToken,
    bool isLoading = false,
  }) async =>
      await repository.postSendFcmApi(
        registrationToken: registrationToken,
        userName: userName,
        callid: callid,
        agoratoken: agoratoken,
        type: type,
        banner: banner,
        fromid: fromid,
        toid: toid,
        agorachannelName: agorachannelName,
        isaudiocall: isaudiocall,
        isgroupcall: isgroupcall,
        isvideocall: isvideocall,
        authToken: authToken,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> postPhotoVideo({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.postPhotoVideo(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> postAudios({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.postAudios(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> postDocs({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.postDocs(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> postLinks({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.postLinks(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> listFavoriteMessage({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.listFavoriteMessage(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> listGroupFavoriteMessage({
    bool isLoading = false,
    required String groupid,
    required int page,
    required int limit,
  }) async =>
      await repository.listGroupFavoriteMessage(
        groupid: groupid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> listChatBookmarkMessage({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.listChatBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> listGroupBookmarkMessage({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.listGroupBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postPollVote({
    bool isLoading = false,
    required String pollid,
    required String optionid,
  }) async =>
      await repository.postPollVote(
        pollid: pollid,
        optionid: optionid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postBrodcastDeleteMeg({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastDeleteMeg(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ReactionChatModel?> postBrodcastFavorite({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastFavorite(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<BookmarkListModel?> postBookmarksList({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postBookmarksList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postBrodcastPhoto({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastPhoto(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postBrodcastAudio({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastAudio(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postBrodcastDoc({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastDoc(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postBrodcastLink({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastLink(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postGroupPhoto({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postGroupPhoto(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postGroupAudio({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postGroupAudio(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postGroupDoc({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postGroupDoc(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postGroupLink({
    required String groupid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postGroupLink(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
      );

  Future<FriendsListModel?> postChatLockFriends({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      await repository.postChatLockFriends(
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );

  Future<GroupFriendListModel?> groupsUserChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await repository.postGroupChatLockList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatLockVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      await repository.postChatLockVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postClearIndividualChats({
    bool isLoading = false,
    required String userid,
  }) async =>
      await repository.postClearIndividualChats(
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postArchiveChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postArchiveGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ArchiveChatListModel?> postArchiveChatList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      await repository.postArchiveChatList(
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveChatRemove({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postArchiveChatRemove(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
  Future<ResponseModel?> postReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
  Future<ResponseModel?> postUnReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postUnReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<NotificationModel?> postNotificationList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.postNotificationList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postDeleteNotification({
    bool isLoading = false,
    String? notificationId,
  }) async =>
      await repository.postDeleteNotification(
        notificationId: notificationId,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnFriend({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await repository.postUnFriend(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );

  Future<UserBookmarkModel?> postIndiviualBookmark({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await repository.postIndiviualBookmark(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );
}
