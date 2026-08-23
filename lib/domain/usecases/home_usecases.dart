import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

/// Use case for getting the data from the API
class HomeScreenUseCases {
  HomeScreenUseCases(this.repository);

  final Repository repository;

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await repository.getProfile(
        isLoading: isLoading,
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

  Future<ResponseModel?> postOnlineOffline({
    required bool isonline,
    bool isLoading = false,
  }) async =>
      await repository.postOnlineOffline(
        isLoading: isLoading,
        isonline: isonline,
      );

      
}
