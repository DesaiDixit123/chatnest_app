import 'package:chatnest/domain/domain.dart';

class HomeScreenPresenter {
  HomeScreenPresenter(this.homeScreenUseCases,this.commonUsecases);

  final HomeScreenUseCases homeScreenUseCases;
  final CommonUsecases commonUsecases;

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await homeScreenUseCases.getProfile(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatPinUnPin({
    required String userid,
    required bool isPinned,
    bool isLoading = false,
  }) async =>
      await homeScreenUseCases.postChatPinUnPin(
        isLoading: isLoading,
        userid: userid,
        isPinned: isPinned,
      );

  Future<ResponseModel?> postOnlineOffline({
    required bool isonline,
    bool isLoading = false,
  }) async =>
      await homeScreenUseCases.postOnlineOffline(
        isLoading: isLoading,
        isonline: isonline,
      );

  Future<ResponseModel?> postLogout({
    bool isLoading = false,
  }) async =>
      await commonUsecases.postLogout(
        isLoading: isLoading,
      );
}
