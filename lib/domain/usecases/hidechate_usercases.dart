import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class HideChatUseCases {
  HideChatUseCases(this.repository);

  final Repository repository;

  Future<CreateLockPinModel?> postCreatePinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      await repository.postCreatePinHide(
        isLoading: isLoading,
        pin: pin,
      );

  Future<VerifyChatLockModel?> postVerifyPinHide({
    bool isLoading = false,
    required String pin,
  }) async =>
      await repository.postVerifyPinHide(
        isLoading: isLoading,
        pin: pin,
      );

  Future<ResponseModel?> postChangePinHide({
    bool isLoading = false,
    required String oldpin,
    required String newpin,
  }) async =>
      await repository.postChangePinHide(
        isLoading: isLoading,
        oldpin: oldpin,
        newpin: newpin,
      );

  Future<ResponseModel?> postForgotPinHide({
    bool isLoading = false,
  }) async =>
      await repository.postForgotPinHide(
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
      await repository.postChatHideFriends(
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
      await repository.postGroupChatHideList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatHideVerifyOtp({
    bool isLoading = false,
    required int otp,
    required int pin,
  }) async =>
      await repository.postChatHideVerifyOtp(
        otp: otp,
        pin: pin,
        isLoading: isLoading,
      );
}
