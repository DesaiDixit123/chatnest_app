import 'package:chatnest/domain/models/response_model.dart';
import 'package:chatnest/domain/repositories/repository.dart';

class VideoCallUsecases {
  VideoCallUsecases(this.repository);

  final Repository repository;

  Future<ResponseModel?> postChatLeaveCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await repository.postChatLeaveCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatMissedCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await repository.postChatMissedCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatJoinCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await repository.postChatJoinCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postKickMember({
    required String callid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      await repository.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
}
