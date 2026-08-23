import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class CommonUsecases {
  CommonUsecases(this.repository);

  final Repository repository;

  Future<ResponseModel?> postLogout({
    bool isLoading = false,
  }) async =>
      await repository.postLogout(
        isLoading: isLoading,
      );

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
      await repository.myFriendsList(
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

  Future<SendRequestModel?> sendNewFriendRequest({
    bool isLoading = false,
    required String receiverid,
    required String message,
    required String product,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await repository.sendNewFriendRequest(
        isLoading: isLoading,
        receiverid: receiverid,
        message: message,
        product: product,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await repository.respondFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> updateFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await repository.updateFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
        authorizedPermissions: authorizedPermissions,
      );

  Future<ResponseModel?> cancelSentRequest({
    bool isLoading = false,
    required String friendrequestid,
  }) async =>
      await repository.cancelSentRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
      );

  Future<String?> uploadGroupProfile({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await repository.uploadGroupProfile(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<ResponseModel?> removeGroupProfile({
    bool isLoading = false,
    required String filekey,
  }) async =>
      await repository.removeGroupProfile(
        isLoading: isLoading,
        filekey: filekey,
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
      await repository.myFriendsWithoutPaginationList(
        isLoading: isLoading,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<GetOneGroupModel?> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await repository.getOneGroup(
        groupid: groupid,
        isLoading: isLoading,
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

  Future<ResponseModel?> postSaveMetting({
    required String meetingId,
    required String title,
    required String description,
    required String meetingstartdate,
    required String meetingstarttime,
    required String meetingenddate,
    required String meetingendtime,
    required List<String> memberList,
    bool isLoading = false,
  }) async =>
      await repository.postSaveMetting(
        meetingId: meetingId,
        title: title,
        description: description,
        meetingstartdate: meetingstartdate,
        meetingstarttime: meetingstarttime,
        meetingenddate: meetingenddate,
        meetingendtime: meetingendtime,
        memberList: memberList,
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
      await repository.postfriendsproducts(
        search: search,
        userid: userid,
        business: business,
        parentcategory: parentcategory,
        childcategory: childcategory,
        isLoading: isLoading,
      );

  Future<ChatListsModel?> postListFavoriteMessages({
    required String broadcastid,
    required int page,
    required int limit,
    bool isLoading = false,
  }) async =>
      await repository.postListFavoriteMessages(
        isLoading: isLoading,
        broadcastid: broadcastid,
        page: page,
        limit: limit,
      );

  Future<ResponseModel?> postChatHide({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postChatHide(
        isLoading: isLoading,
        friendrequestids: friendrequestids,
      );

  Future<ResponseModel?> postGroupChatHide({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postGroupChatHide(
        isLoading: isLoading,
        groupids: groupids,
      );

  Future<ResponseModel?> postChatLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postChatLock(
        isLoading: isLoading,
        friendrequestids: friendrequestids,
      );

  Future<ResponseModel?> postGroupChatLock({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postGroupChatLock(
        isLoading: isLoading,
        groupids: groupids,
      );

  Future<CreateLockPinModel?> postCreatePinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      await repository.postCreatePinLock(
        isLoading: isLoading,
        pin: pin,
      );

  Future<VerifyChatLockModel?> postVerifyPinLock({
    bool isLoading = false,
    required String pin,
  }) async =>
      await repository.postVerifyPinLock(
        isLoading: isLoading,
        pin: pin,
      );

  Future<ResponseModel?> postChangePinLock({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      await repository.postChangePinLock(
        isLoading: isLoading,
        oldpin: oldpin,
        newpin: newpin,
      );

  Future<ResponseModel?> postForgotPinLock({
    bool isLoading = false,
  }) async =>
      await repository.postForgotPinLock(
        isLoading: isLoading,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await repository.getProfile(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnLockChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postUnLockChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postMoveHideToLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await repository.postMoveHideToLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postMoveHideToLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postMoveHideToLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postUnLockGroup(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<GroupUserListModel?> groupsUserChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await repository.groupsChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<GroupUserListModel?> postGroupListWithoutPaging({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await repository.postGroupListWithoutPaging(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async =>
      await repository.postChatReport(
        reportid: reportid,
        userid: userid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async =>
      await repository.postGroupChatReport(
        reportid: reportid,
        groupid: groupid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<GetOneFriendProductModel?> postFriendProductGetOne({
    required String productid,
    bool isLoading = false,
  }) async =>
      await repository.postFriendProductGetOne(
        isLoading: isLoading,
        productid: productid,
      );
}
