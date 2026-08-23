import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class MeetingCallUsecases {
  MeetingCallUsecases(this.repository);

  Repository repository;

    Future<GetOneMeetingModel?> postMeetingLeave({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await repository.postMeetingLeave(
        meetingid: meetingid,
        isLoading: isLoading,
      );
  Future<ResponseModel?> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await repository.postMeetingCancle(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<GetOneMeetingModel?> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await repository.postMeetingGetOne(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postKickMember({
    bool isLoading = false,
    required String callid,
    required String memberid,
  }) async =>
      await repository.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
}
