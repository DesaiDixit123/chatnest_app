import 'package:chatnest/domain/domain.dart';
import 'package:chatnest/domain/usecases/meeting_usecases.dart';

class MeetingPresenter {
  MeetingPresenter(this.meetingUsecases, this.commonUsecases);

  final MeetingUsecases meetingUsecases;

  final CommonUsecases commonUsecases;

  Future<MyFriendsModel?> myFriendsWithoutPaginationList({
    bool isLoading = false,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      await commonUsecases.myFriendsWithoutPaginationList(
        isLoading: isLoading,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<ResponseModel?> postSaveMetting({
    required String meetingId,
    required String title,
    required String description,
    required String meetingstartdate,
    required String meetingstarttime,
    required String meetingenddate,
    required String meetingendtime,
    required List<String> memberList,
    bool isLoading = false,
  }) async =>
      await commonUsecases.postSaveMetting(
        meetingId: meetingId,
        title: title,
        description: description,
        meetingstartdate: meetingstartdate,
        meetingstarttime: meetingstarttime,
        meetingenddate: meetingenddate,
        meetingendtime: meetingendtime,
        memberList: memberList,
        isLoading: isLoading,
      );

  Future<GetOneMeetingModel?> postMeetingGetOne({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingUsecases.postMeetingGetOne(
        isLoading: isLoading,
        meetingid: meetingid,
      );

  Future<HostMeetingListModel?> postMeetingHostingList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await meetingUsecases.postMeetingHostingList(
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
      await meetingUsecases.postMeetingJoinList(
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
      await meetingUsecases.postMeetingPastList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
      );

  Future<GetOneMeetingModel?> postHostMeetingStart({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingUsecases.postHostMeetingStart(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<GetOneMeetingModel?> postMeetingJoin({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingUsecases.postMeetingJoin(
        meetingid: meetingid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postMeetingCancle({
    bool isLoading = false,
    required String meetingid,
  }) async =>
      await meetingUsecases.postMeetingCancle(
        meetingid: meetingid,
        isLoading: isLoading,
      );
}
