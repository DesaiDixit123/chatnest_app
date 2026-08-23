import 'package:chatnest/domain/domain.dart';

class MeetingCallPresenter {
  MeetingCallPresenter(this.meetingCallUsecases);

  MeetingCallUsecases meetingCallUsecases;

  Future<GetOneMeetingModel?> postMeetingLeave({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingCallUsecases.postMeetingLeave(
        meetingid: meetingid,
        isLoading: isLoading,
      );
  Future<ResponseModel?> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingCallUsecases.postMeetingCancle(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<GetOneMeetingModel?> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingCallUsecases.postMeetingGetOne(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postKickMember({
    bool isLoading = false,
    required String callid,
    required String memberid,
  }) async =>
      await meetingCallUsecases.postKickMember(
        callid: callid,
        memberid: memberid,
        isLoading: isLoading,
      );
}
