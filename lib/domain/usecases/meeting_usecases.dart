import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';

class MeetingUsecases {
  MeetingUsecases(this.repository);

  final Repository repository;

  Future<GetOneMeetingModel?> postMeetingGetOne({
    required String meetingid,
    bool isLoading = false,
  }) async =>
      await repository.postMeetingGetOne(
        isLoading: isLoading,
        meetingid: meetingid,
      );

  Future<HostMeetingListModel?> postMeetingHostingList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.postMeetingHostingList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<HostMeetingListModel?> postMeetingJoinList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.postMeetingJoinList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<HostMeetingListModel?> postMeetingPastList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.postMeetingPastList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<GetOneMeetingModel?> postHostMeetingStart({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await repository.postHostMeetingStart(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<GetOneMeetingModel?> postMeetingJoin({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await repository.postMeetingJoin(
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
}
