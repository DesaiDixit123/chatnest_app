import 'package:chatnest/domain/domain.dart';

class AudioCallPresenter {
  AudioCallPresenter(this.audioCallUsecases);

  final AudioCallUsecases audioCallUsecases;

  Future<ResponseModel?> postChatLeaveCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await audioCallUsecases.postChatLeaveCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatMissedCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await audioCallUsecases.postChatMissedCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatJoinCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await audioCallUsecases.postChatJoinCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postOutgoingCallAddMember({
    required String userid,
    required String meetingid,
    bool isLoading = false,
  }) async =>
      await audioCallUsecases.postOutgoingCallAddMember(
        userid: userid,
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postKickMember({
    required String callid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      await audioCallUsecases.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
}
