import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

/// Use case for getting the data from the API
class FindFriendUseCases {
  FindFriendUseCases(this.repository);

  final Repository repository;

  Future<FindFirendsLocationModel?> postFindFriendsLocation({
    bool isLoading = false,
    required double latitude,
    required double longitude,
  }) async =>
      await repository.postFindFriendsLocation(
        isLoading: isLoading,
        latitude: latitude,
        longitude: longitude,
      );

  Future<FindFirendsListModel?> postFindFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.postFindFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );
}
