import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class BroadCastUseCases {
  BroadCastUseCases(this.repository);

  final Repository repository;

  Future<BroadcastListModel?> postListBroadcast({
    required int page,
    required int limit,
    required String search,
    bool isLoading = false,
  }) async =>
      await repository.postListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<GetOneBroadcastModel?> getOneBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.getOneBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ResponseModel?> postAddBroadcast({
    required String broadcastid,
    required String broadcasttitle,
    required List<String> membersList,
    bool isLoading = false,
  }) async =>
      await repository.postAddBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
        broadcasttitle: broadcasttitle,
        membersList: membersList,
      );

  Future<ResponseModel?> postPinUnPinBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.postPinUnPinBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ResponseModel?> postDeleteBroadcast({
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.postDeleteBroadcast(
        isLoading: isLoading,
        broadcastid: broadcastid,
      );

  Future<ChatListsModel?> postChatListBroadcast({
    required int page,
    required int limit,
    required String broadcastid,
    bool isLoading = false,
  }) async =>
      await repository.postChatListBroadcast(
        isLoading: isLoading,
        page: page,
        limit: limit,
        broadcastid: broadcastid,
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
      await repository.postSendMessageBroadcast(
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

  Future<ResponseModel?> postBrodcastMemberRemove({
    required String broadcastid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      await repository.postBrodcastMemberRemove(
        isLoading: isLoading,
        broadcastid: broadcastid,
        memberid: memberid,
      );
}
