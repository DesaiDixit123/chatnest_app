import 'package:chatnest/domain/domain.dart';

class VideoCallPresenter {
  VideoCallPresenter(this.videoCallUsecases);

  final VideoCallUsecases videoCallUsecases;

  Future<ResponseModel?> postChatLeaveCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await videoCallUsecases.postChatLeaveCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatMissedCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await videoCallUsecases.postChatMissedCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postChatJoinCall({
    required String callid,
    bool isLoading = false,
  }) async =>
      await videoCallUsecases.postChatJoinCall(
        isLoading: isLoading,
        callid: callid,
      );

  Future<ResponseModel?> postKickMember({
    required String callid,
    required String memberid,
    bool isLoading = false,
  }) async =>
      await videoCallUsecases.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
}
