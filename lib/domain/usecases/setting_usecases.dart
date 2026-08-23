import '../repositories/repositories.dart';
import '../models/models.dart';
import '../entities/entities.dart';
import 'package:chatnest/domain/repositories/repository.dart';

class SettingUsecases {
  SettingUsecases(this.repository);

  final Repository repository;

  Future<ResponseModel?> postDisableAccount({
    bool isLoading = false,
  }) async =>
      await repository.postDisableAccount(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postDeleteAccount({
    bool isLoading = false,
  }) async =>
      await repository.postDeleteAccount(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postNotificationStatusforChat({
    bool isLoading = false,
  }) async =>
      await repository.postNotificationStatusforChat(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postNotificationStatusforGroup({
    bool isLoading = false,
  }) async =>
      await repository.postNotificationStatusforGroup(
        isLoading: isLoading,
      );

  Future<ResponseModel?> postRecoveryEmail({
    bool isLoading = false,
    required String email,
  }) async =>
      await repository.postRecoveryEmail(isLoading: isLoading, email: email);

  Future<StorageModel?> postStorageInfo({
    bool isLoading = false,
  }) async =>
      await repository.postStorageInfo(
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
      await repository.postSaveSubUser(
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

  Future<MultiUserAccountModel?> postSubUserList({
    bool isLoading = false,
    required int page,
    required int limit,
    required String search,
  }) async =>
      await repository.postSubUserList(
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
      await repository.postChangePassword(
        subuserid: subuserid,
        password: password,
        isLoading: isLoading,
      );

  Future<MultiUserAccountUpdateModel?> postUpdateSubUser({
    bool isLoading = false,
    required String subuserid,
  }) async =>
      await repository.postUpdateSubUser(
        subuserid: subuserid,
        isLoading: isLoading,
      );

  Future<ResponseModel?> postClearChats({
    bool isLoading = false,
  }) async =>
      await repository.postClearChats(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postReadReceiptsstatus({
    bool isLoading = false,
  }) async =>
      await repository.postReadReceiptsstatus(
        isLoading: isLoading,
      );

  Future<SettingNotificationModel?> postLastSeenOnlineOfflineStatus({
    bool isLoading = false,
  }) async =>
      await repository.postLastSeenOnlineOfflineStatus(
        isLoading: isLoading,
      );

  Future<SendOtpModel?> postChangeNumber({
    bool isLoading = false,
    required String oldmobile,
    required String oldcountry_code,
    required String newmobile,
    required String newcountry_code,
  }) async =>
      await repository.postChangeNumber(
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
      await repository.postChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<GetOneReportModel?> postChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      await repository.postChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );

  Future<GroupReportModel?> postGroupChatReportList({
    bool isLoading = false,
    required int page,
    required int limit,
  }) async =>
      await repository.postGroupChatReportList(
        page: page,
        limit: limit,
        isLoading: isLoading,
      );

  Future<GetOneGroupReportModel?> postGroupChatReportGetOne({
    bool isLoading = false,
    required String reportid,
  }) async =>
      await repository.postGroupChatReportGetOne(
        reportid: reportid,
        isLoading: isLoading,
      );
      
}
