import 'package:flutter/foundation.dart';
import 'package:chatnest/domain/domain.dart';

class ChatPresenter {
  ChatPresenter(this.chatUsecases, this.commonUsecases);

  final ChatUsecases chatUsecases;
  final CommonUsecases commonUsecases;

  Future<MyFriendsModel?> myFriendsList({
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
      await commonUsecases.myFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<GetOneFriendsModel?> getOneFriends({
    bool isLoading = false,
    required String userid,
  }) async {
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ChatPresenter.getOneFriends called for userid: $userid");
    var result = await chatUsecases.getOneFriends(
      isLoading: isLoading,
      userid: userid,
    );
    debugPrint(
        "[ANTIGRAVITY_DEBUG] ChatPresenter.getOneFriends result: ${result != null}");
    return result;
  }

  Future<GetUserStatusModel?> getOneUserStatus({
    bool isLoading = false,
    required String userid,
  }) async =>
      await chatUsecases.getOneUserStatus(
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
      await chatUsecases.getChatLists(
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
      await chatUsecases.createPolls(
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
      await chatUsecases.getOnePoll(
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
      await chatUsecases.sendMessage(
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
      await chatUsecases.postChatSendBulkMessage(
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
      await chatUsecases.postGroupChatSendBulkMessage(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        context: context,
        mediaFileList: mediaFileList,
      );

  Future<MyFriendsModel?> myFriendsWithoutPaginationList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      await commonUsecases.myFriendsWithoutPaginationList(
        isLoading: isLoading,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<ResponseModel?> postDeliveredMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  /////////////////////
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
      await chatUsecases.sendGroupMessage(
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
      await chatUsecases.getGroupChatLists(
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
      await chatUsecases.postGroupDeliveredMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postGroupSeenMessage({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postGroupSeenMessage(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<GetOneGroupModel?> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await commonUsecases.getOneGroup(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<FriendProductModel?> postfriendsproducts({
    bool isLoading = false,
    required String search,
    required String userid,
    required String business,
    required List<String> parentcategory,
    required List<String> childcategory,
  }) async =>
      await commonUsecases.postfriendsproducts(
        search: search,
        userid: userid,
        business: business,
        parentcategory: parentcategory,
        childcategory: childcategory,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );

  Future<ResponseModel?> postChatMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );

  Future<ReactionChatModel?> postChatBookmarkAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatBookmarkAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatFavoriteAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatFavoriteAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
  Future<ReactionChatModel?> postChatMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postChatGroupDeleteMessage({
    required String messageid,
    required String deletefor,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupDeleteMessage(
        isLoading: isLoading,
        messageid: messageid,
        deletefor: deletefor,
      );

  Future<ResponseModel?> postChatGroupMessageEdit({
    required String messageid,
    required String message,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupMessageEdit(
        isLoading: isLoading,
        messageid: messageid,
        message: message,
      );

  Future<ReactionChatModel?> postChatGroupBookmarkAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupBookmarkAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatGroupFavoriteAndRemove({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupFavoriteAndRemove(
        isLoading: isLoading,
        messageid: messageid,
      );
  Future<ReactionChatModel?> postChatGroupMessageReaction({
    required String messageid,
    required String reaction,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupMessageReaction(
        isLoading: isLoading,
        messageid: messageid,
        reaction: reaction,
      );
  Future<ReactionChatModel?> postChatGroupMessageUnReaction({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatGroupMessageUnReaction(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ResponseModel?> postChatPinUnPin({
    required String userid,
    required bool isPinned,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatPinUnPin(
        isLoading: isLoading,
        userid: userid,
        isPinned: isPinned,
      );

  Future<ResponseModel?> postChatForward({
    required String messageid,
    required List<String> forwardto,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatForward(
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
      await chatUsecases.postCallInitaite(
        isLoading: isLoading,
        isAudioCall: isAudioCall,
        isGroupCall: isGroupCall,
        isVideoCall: isVideoCall,
        receiverId: receiverId,
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

  Future<GetOneBroadcastModel?> getOneBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.getOneBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ChatListsModel?> postChatListBroadcast({
    required int page,
    required int limit,
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postChatListBroadcast(
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
      await chatUsecases.postListBroadcast(
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
      await chatUsecases.postSendMessageBroadcast(
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
      await chatUsecases.postSendMultiMediaBroadcast(
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
      await chatUsecases.postSendFcmApi(
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
      await chatUsecases.postPhotoVideo(
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
      await chatUsecases.postAudios(
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
      await chatUsecases.postDocs(
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
      await chatUsecases.postLinks(
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
      await chatUsecases.listFavoriteMessage(
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
      await chatUsecases.listGroupFavoriteMessage(
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
      await chatUsecases.listChatBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> listGroupBookmarkMessage({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await chatUsecases.listGroupBookmarkMessage(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postPollVote({
    bool isLoading = false,
    required String pollid,
    required String optionid,
  }) async =>
      await chatUsecases.postPollVote(
        pollid: pollid,
        optionid: optionid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postBrodcastDeleteMeg({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postBrodcastDeleteMeg(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<ReactionChatModel?> postBrodcastFavorite({
    required String messageid,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postBrodcastFavorite(
        isLoading: isLoading,
        messageid: messageid,
      );

  Future<BookmarkListModel?> postBookmarksList({
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postBookmarksList(
        isLoading: isLoading,
        page: page,
        limit: limit,
      );

  Future<ChatListsModel?> postListFavoriteMessages({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postListFavoriteMessages(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
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

  Future<ChatListsModel?> postBrodcastPhoto({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await chatUsecases.postBrodcastPhoto(
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
      await chatUsecases.postBrodcastAudio(
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
      await chatUsecases.postBrodcastDoc(
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
      await chatUsecases.postBrodcastLink(
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
      await chatUsecases.postGroupPhoto(
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
      await chatUsecases.postGroupAudio(
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
      await chatUsecases.postGroupDoc(
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
      await chatUsecases.postGroupLink(
        isLoading: isLoading,
        groupid: groupid,
        page: page,
        limit: limit,
      );

  Future<ResponseModel?> postChatHide({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await commonUsecases.postChatHide(
        isLoading: isLoading,
        friendrequestids: friendrequestids,
      );

  Future<ResponseModel?> postGroupChatHide({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await commonUsecases.postGroupChatHide(
        isLoading: isLoading,
        groupids: groupids,
      );

  Future<CreateLockPinModel?> postCreatePinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      await commonUsecases.postCreatePinLock(
        isLoading: isLoading,
        pin: pin,
      );

  Future<VerifyChatLockModel?> postVerifyPinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      await commonUsecases.postVerifyPinLock(
        isLoading: isLoading,
        pin: pin,
      );

  Future<ResponseModel?> postChangePinLock({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      await commonUsecases.postChangePinLock(
        isLoading: isLoading,
        oldpin: oldpin,
        newpin: newpin,
      );

  Future<ResponseModel?> postForgotPinLock({
    bool isLoading = false,
  }) async =>
      await commonUsecases.postForgotPinLock(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await commonUsecases.postChatLock(
        isLoading: isLoading,
        friendrequestids: friendrequestids,
      );

  Future<ResponseModel?> postGroupChatLock({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await commonUsecases.postGroupChatLock(
        isLoading: isLoading,
        groupids: groupids,
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
      await chatUsecases.postChatLockFriends(
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
      await chatUsecases.groupsUserChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnLockChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await commonUsecases.postUnLockChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await commonUsecases.postUnLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatLockVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      await chatUsecases.postChatLockVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postClearIndividualChats({
    bool isLoading = false,
    required String userid,
  }) async =>
      await chatUsecases.postClearIndividualChats(
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await chatUsecases.postArchiveChat(
        friendrequestids: friendrequestids,
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
      await chatUsecases.postArchiveChatList(
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
      await chatUsecases.postArchiveChatRemove(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await chatUsecases.postReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );
  Future<ResponseModel?> postUnReadChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await chatUsecases.postUnReadChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<NotificationModel?> postNotificationList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await chatUsecases.postNotificationList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postDeleteNotification({
    bool isLoading = false,
    String? notificationId,
  }) async =>
      await chatUsecases.postDeleteNotification(
        notificationId: notificationId,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnFriend({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await chatUsecases.postUnFriend(
        friendrequestid: friendrequestid,
        isLoading: isLoading,
      );

  Future<UserBookmarkModel?> postIndiviualBookmark({
    bool isLoading = false,
    required String userid,
    required int page,
    required int limit,
  }) async =>
      await chatUsecases.postIndiviualBookmark(
        userid: userid,
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async =>
      await commonUsecases.postChatReport(
        reportid: reportid,
        userid: userid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<GetOneFriendProductModel?> postFriendProductGetOne({
    required String productid,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postFriendProductGetOne(
        isLoading: isLoading,
        productid: productid,
      );
}
