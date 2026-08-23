import 'package:chatnest/domain/domain.dart';

class HideChatScreenPresenter {
  HideChatScreenPresenter(this.hideChatUseCases, this.commonUsecases);

  final HideChatUseCases hideChatUseCases;
  final CommonUsecases commonUsecases;

  Future<CreateLockPinModel?> postCreatePinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      await hideChatUseCases.postCreatePinHide(
        isLoading: isLoading,
        pin: pin,
      );

  Future<VerifyChatLockModel?> postVerifyPinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      await hideChatUseCases.postVerifyPinHide(
        isLoading: isLoading,
        pin: pin,
      );

  Future<ResponseModel?> postChangePinHide({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      await hideChatUseCases.postChangePinHide(
        isLoading: isLoading,
        oldpin: oldpin,
        newpin: newpin,
      );

  Future<ResponseModel?> postForgotPinHide({
    bool isLoading = false,
  }) async =>
      await hideChatUseCases.postForgotPinHide(
        isLoading: isLoading,
      );

  Future<FriendsListModel?> postChatHideFriends({
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
      await hideChatUseCases.postChatHideFriends(
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

  Future<GroupFriendListModel?> postGroupChatHideList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await hideChatUseCases.postGroupChatHideList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
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

  Future<ResponseModel?> postUnLockChat({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await commonUsecases.postUnLockChat(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postMoveHideToLock({
    bool isLoading = false,
    required List<String> friendrequestids,
  }) async =>
      await commonUsecases.postMoveHideToLock(
        friendrequestids: friendrequestids,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postMoveHideToLockGroup({
    bool isLoading = false,
    required List<String> groupids,
  }) async =>
      await commonUsecases.postMoveHideToLockGroup(
        groupids: groupids,
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

  Future<ResponseModel?> postChatHideVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      await hideChatUseCases.postChatHideVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );
}
