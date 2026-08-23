import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class AudioCallUsecases {
  AudioCallUsecases(this.repository);

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

  Future<ResponseModel?> postOutgoingCallAddMember({
    required String userid,
    required String meetingid,
    bool isLoading = false,
  }) async =>
      await repository.postOutgoingCallAddMember(
        userid: userid,
        meetingid: meetingid,
        isLoading: isLoading,
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
