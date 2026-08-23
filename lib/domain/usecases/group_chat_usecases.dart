import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class GroupChatUsecases {
  GroupChatUsecases(this.repository);

  final Repository repository;

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

  Future<ResponseModel?> createGroupApi({
    bool isLoading = false,
    required String groupid,
    required String profileimage,
    required String name,
    required String description,
    required List<String> members,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await repository.createGroupApi(
        isLoading: isLoading,
        groupid: groupid,
        profileimage: profileimage,
        name: name,
        description: description,
        members: members,
        authorizedPermissions: authorizedPermissions,
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

  Future<ResponseModel?> groupSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      await repository.groupSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> groupUnSetManager({
    bool isLoading = false,
    required String groupid,
    required String userid,
  }) async =>
      await repository.groupUnSetManager(
        groupid: groupid,
        userid: userid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> leaveGroup({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await repository.leaveGroup(
        groupid: groupid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> addMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      await repository.addMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );

  Future<ResponseModel?> removeMemberGroup({
    bool isLoading = false,
    required String groupid,
    required List<String> membersList,
  }) async =>
      await repository.removeMemberGroup(
        isLoading: isLoading,
        groupid: groupid,
        membersList: membersList,
      );

  Future<ResponseModel?> groupSetPermission({
    bool isLoading = false,
    required String groupid,
    required AuthorizedPermissions authorizedPermissions,
  }) async =>
      await repository.groupSetPermission(
        groupid: groupid,
        authorizedPermissions: authorizedPermissions,
        isLoading: isLoading,
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

  Future<ResponseModel?> postClearGroupChats({
    bool isLoading = false,
    required String groupid,
  }) async =>
      await repository.postClearGroupChats(
        groupid: groupid,
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

  Future<ArchiveGroupListModel?> postArchiveGroupChatList({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await repository.postArchiveGroupChatList(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postArchiveGroupChatRemove({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postArchiveGroupChatRemove(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postUnReadGroupChat({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await repository.postUnReadGroupChat(
        groupids: groupids,
        isLoading: isLoading,
      );

 
}
