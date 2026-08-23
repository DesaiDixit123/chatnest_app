import 'package:chatnest/domain/domain.dart';

class SettingPresenter {
  SettingPresenter(this.settingUsecases, this.commonUsecases);

  final SettingUsecases settingUsecases;
  final CommonUsecases commonUsecases;

  Future<ResponseModel?> postLogout({
    bool isLoading = false,
  }) async =>
      await commonUsecases.postLogout(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postDisableAccount({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postDisableAccount(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postDeleteAccount({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postDeleteAccount(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postNotificationStatusforChat({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postNotificationStatusforChat(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postNotificationStatusforGroup({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postNotificationStatusforGroup(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postRecoveryEmail({
    bool isLoading = false,
    required String email,
  }) async =>
      await settingUsecases.postRecoveryEmail(
          isLoading: isLoading, email: email);

  Future<StorageModel?> postStorageInfo({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postStorageInfo(
        isLoading: isLoading,
      );

  Future<GetProfileModel?> getProfile({
    bool isLoading = false,
  }) async =>
      await commonUsecases.getProfile(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postSaveSubUser({
    bool isLoading = false,
    required String subuserid,
    required String fullname,
    required String username,
    required String email,
    required String mobile,
    required String country_code,
    // required String country_wise_contact,
    required String password,
    required List<String?> chats,
    required List<String?> groups,
  }) async =>
      await settingUsecases.postSaveSubUser(
        subuserid: subuserid,
        fullname: fullname,
        username: username,
        email: email,
        mobile: mobile,
        country_code: country_code,
        // country_wise_contact: country_wise_contact,
        password: password,
        chats: chats,
        groups: groups,
        isLoading: isLoading,
      );

  Future<MyFriendsModel?> myFriendsList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool unreadMessages,
    required bool contactFriend,
    required bool fefieldFriend,
    required bool receiverFriend,
    required bool senderFriend,
  }) async =>
      await commonUsecases.myFriendsList(
        isLoading: isLoading,
        page: page,
        limit: limit,
        search: search,
        unreadMessages: unreadMessages,
        contactFriend: contactFriend,
        fefieldFriend: fefieldFriend,
        receiverFriend: receiverFriend,
        senderFriend: senderFriend,
      );

  Future<GroupUserListModel?> groupsUserChatList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await commonUsecases.groupsUserChatList(
        page: page,
        limit: limit,
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );

  Future<MultiUserAccountModel?> postSubUserList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await settingUsecases.postSubUserList(
        page: page,
        limit: limit,
        search: search,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChangePassword({
    bool isLoading = false,
    required String subuserid,
    required String password,
  }) async =>
      await settingUsecases.postChangePassword(
        subuserid: subuserid,
        password: password,
        isLoading: isLoading,
      );

  Future<MultiUserAccountUpdateModel?> postUpdateSubUser({
    bool isLoading = false,
    required String subuserid,
  }) async =>
      await settingUsecases.postUpdateSubUser(
        subuserid: subuserid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postClearChats({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postClearChats(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postReadReceiptsstatus({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postReadReceiptsstatus(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postLastSeenOnlineOfflineStatus({
    bool isLoading = false,
  }) async =>
      await settingUsecases.postLastSeenOnlineOfflineStatus(
        isLoading: isLoading,
      );

  Future<SendOtpModel?> postChangeNumber({
    bool isLoading = false,
    required String oldmobile,
    required String oldcountry_code,
    required String newmobile,
    required String newcountry_code,
  }) async =>
      await settingUsecases.postChangeNumber(
        isLoading: isLoading,
        oldmobile: oldmobile,
        oldcountry_code: oldcountry_code,
        newmobile: newmobile,
        newcountry_code: newcountry_code,
      );

  Future<ReportListModel?> postChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await settingUsecases.postChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<GetOneReportModel?> postChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      await settingUsecases.postChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );

  Future<GroupReportModel?> postGroupChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await settingUsecases.postGroupChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<GetOneGroupReportModel?> postGroupChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      await settingUsecases.postGroupChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postChatReport({
    bool isLoading = false,
    required String reportid,
    required String userid,
    required String reason,
  }) async =>
      await commonUsecases.postChatReport(
        reportid: reportid,
        userid: userid,
        reason: reason,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postGroupChatReport({
    bool isLoading = false,
    required String reportid,
    required String groupid,
    required String reason,
  }) async =>
      await commonUsecases.postGroupChatReport(
        reportid: reportid,
        groupid: groupid,
        reason: reason,
        isLoading: isLoading,
      );

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

  Future<GroupUserListModel?> postGroupListWithoutPaging({
    bool isLoading = false,
    required String search,
    required bool isunreadmessagefilteronoff,
  }) async =>
      await commonUsecases.postGroupListWithoutPaging(
        search: search,
        isunreadmessagefilteronoff: isunreadmessagefilteronoff,
        isLoading: isLoading,
      );
}
