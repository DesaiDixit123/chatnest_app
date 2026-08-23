import 'package:chatnest/domain/domain.dart';

class GroupChatPresenter {
  GroupChatPresenter(this.groupChatUsecases, this.commonUsecases);

  final GroupChatUsecases groupChatUsecases;
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

  Future<ResponseModel?> createGroupApi({
    bool isLoading = false,
    required String groupid,
    required String profileimage,
    required String name,
    required String description,
    required List<String> members,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await groupChatUsecases.createGroupApi(
        isLoading: isLoading,
        groupid: groupid,
        profileimage: profileimage,
        name: name,
        description: description,
        members: members,
        authorizedPermissions: authorizedPermissions,
      );

  Future<String?> uploadGroupProfile({
    bool isLoading = false,
    required String filePath,
  }) async =>
      await commonUsecases.uploadGroupProfile(
        isLoading: isLoading,
        filePath: filePath,
      );

  Future<GroupUserListModel?> groupsUserChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await groupChatUsecases.groupsUserChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
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

  Future<GetOneGroupModel?> getOneGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await commonUsecases.getOneGroup(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> groupSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      await groupChatUsecases.groupSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> groupUnSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      await groupChatUsecases.groupUnSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> leaveGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await groupChatUsecases.leaveGroup(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> addMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      await groupChatUsecases.addMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );

  Future<ResponseModel?> removeMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      await groupChatUsecases.removeMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
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

  Future<ResponseModel?> respondFriendsRequest({
    bool isLoading = false,
    required String friendrequestid,
    required String status,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await commonUsecases.respondFriendsRequest(
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
      await commonUsecases.updateFriendsRequest(
        isLoading: isLoading,
        friendrequestid: friendrequestid,
        status: status,
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

  Future<ResponseModel?> groupSetPermission({
    bool isLoading = false,
    required String groupid,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await groupChatUsecases.groupSetPermission(
        groupid: groupid,
        authorizedPermissions: authorizedPermissions,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatForward({
    required String messageid,
    required List<String> forwardto,
    bool isLoading = false,
  }) async =>
      await groupChatUsecases.postChatForward(
        isLoading: isLoading,
        messageid: messageid,
        forwardto: forwardto,
      );
  Future<ResponseModel?> postGroupChatPinUnPin({
    required String groupid,
    required bool isPinned,
    bool isLoading = false,
  }) async =>
      await groupChatUsecases.postGroupChatPinUnPin(
        isLoading: isLoading,
        groupid: groupid,
        isPinned: isPinned,
      );

  Future<ResponseModel?> postClearGroupChats({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await groupChatUsecases.postClearGroupChats(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await groupChatUsecases.postArchiveGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ArchiveGroupListModel?> postArchiveGroupChatList({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await groupChatUsecases.postArchiveGroupChatList(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveGroupChatRemove({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await groupChatUsecases.postArchiveGroupChatRemove(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await groupChatUsecases.postReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await groupChatUsecases.postUnReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postGroupChatLock({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await commonUsecases.postGroupChatLock(
        isLoading: isLoading,
        groupids: groupids,
      );

  Future<ResponseModel?> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async =>
      await commonUsecases.postGroupChatReport(
        reportid: reportid,
        groupid: groupid,
        reason: reason,
        isLoading: isLoading,
      );
}
