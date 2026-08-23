// ignore: file_names
import 'package:chatnest/domain/domain.dart';

class BroadCastPresenter {
  BroadCastPresenter(this.broadCastUseCases, this.commonUsecases);

  final BroadCastUseCases broadCastUseCases;
  final CommonUsecases commonUsecases;

  Future<BroadcastListModel?> postListBroadcast({
    required int page,
    required int limit,
    required String search,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<GetOneBroadcastModel?> getOneBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.getOneBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ResponseModel?> postAddBroadcast({
    required String broadcastid,
    required String broadcasttitle,
    required List<String> membersList,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postAddBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
        broadcasttitle: broadcasttitle,
        membersList: membersList,
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

  Future<ResponseModel?> postPinUnPinBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postPinUnPinBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ResponseModel?> postDeleteBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postDeleteBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ChatListsModel?> postChatListBroadcast({
    required int page,
    required int limit,
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postChatListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        broadcastid: broadcastid,
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

  Future<ResponseModel?> postChatForward({
    required String messageid,
    required List<String> forwardto,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postChatForward(
        isLoading: isLoading,
        messageid: messageid,
        forwardto: forwardto,
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
      await broadCastUseCases.postSendMessageBroadcast(
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

  Future<ResponseModel?> postBrodcastMemberRemove({
    required String broadcastid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      await broadCastUseCases.postBrodcastMemberRemove(
        isLoading: isLoading,
        broadcastid: broadcastid,
        memberid: memberid,
      );
}
