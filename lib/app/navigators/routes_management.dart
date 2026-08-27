// coverage:ignore-file

import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:chatnest/app/utils/utility.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:get/get.dart';

/// A chunk of routes taken in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class RouteManagement {
  static void goToLoginView() => Get.offAllNamed<void>(Routes.logingScreen);
  static void goToOtpView(String key, bool isChange, String mobile) =>
      Get.toNamed<void>(Routes.otpScreen, arguments: [key, isChange, mobile]);
  static void goToHomeScreenView() {
    final isCallActive = Get.isRegistered<CallManagerService>() &&
        Get.find<CallManagerService>().isCallActive;
    final isAudioOpen = Get.isRegistered<AudioCallController>();
    final isVideoOpen = Get.isRegistered<VideoCallController>();

    if (isCallActive || isAudioOpen || isVideoOpen) {
      print("[ANTIGRAVITY_DEBUG] RouteManagement: Call active during goToHomeScreenView. Skipping offAllNamed!");
      return;
    }
    Get.offAllNamed<void>(Routes.homeScreen);
  }
  static void goTochangeBusinessHoursView() =>
      Get.toNamed<void>(Routes.changeBusinessHoursScreen);
  static void goTocreateProfileView() =>
      Get.toNamed<void>(Routes.createProfileScreen);
  static void goToBusinessProfileScreen(String businessId) =>
      Get.toNamed<void>(Routes.businessProfileScreen, arguments: businessId);
  static void goTofindFriendScreen() => Get.toNamed<void>(Routes.findFriend);
  static void goTofindFriendrequasthistoryScreen() =>
      Get.toNamed<void>(Routes.findFriendrequasthistory);
  static void goToProductDetailFilterScreen() =>
      Get.toNamed<void>(Routes.productDetailFilterScreen);
  static void goTogroupcheatScreen() =>
      Get.toNamed<void>(Routes.Groupcheatscreen);
  static void goTopasswordforHidechatScreen() =>
      Get.toNamed<void>(Routes.passwordforHidechat);
  static void goToShowFullScareenImage(String url, String type) =>
      Get.toNamed<void>(Routes.showFullImageVideo, arguments: [url, type]);
  static void goToSingleFullScreenImageVideo(String url, String type) =>
      Get.toNamed<void>(Routes.showFullScreenImageVideo,
          arguments: [url, type]);
  static void goToPdfViewWidget(String url, String type) =>
      Get.toNamed<void>(Routes.pdfViewWidgets, arguments: [url, type]);
  static void goToCallInfoScreen(String userId, bool isGroup) =>
      Get.toNamed<void>(Routes.callInfoScreen, arguments: [userId, isGroup]);
  static void goToContactListScreen() =>
      Get.toNamed<void>(Routes.contactListScreen);
  static void goToBookmarkScreen() => Get.toNamed<void>(Routes.bookmarkScreen);
  static void goToProductScreen() => Get.toNamed<void>(Routes.productScreen);
  static void goToCreatePinChatScreen() =>
      Get.toNamed<void>(Routes.createpinChatlock);
  static void goToProductDetailsScreen(String id) =>
      Get.toNamed<void>(Routes.productDetailsScreen, arguments: id);
  static void goToRequestScreen(int tabIndex) =>
      Get.toNamed<void>(Routes.requestScreen, arguments: tabIndex);
  static Future<void> goToLocationScreen() async {
    return await Get.toNamed(Routes.locationScreen);
  }

  static void goToProfileScreen() =>
      Get.toNamed<void>(Routes.userProfileScreen);
  static void goTobusinessProductScreen(String businessId) =>
      Get.toNamed<void>(Routes.businessProductScreen, arguments: businessId);
  static void goToaddbusinessProductScreen(String id) =>
      Get.toNamed<void>(Routes.addbusinessProductScreen, arguments: id);
  static void goTobusinessProductdetailScreen(String? productId) =>
      Get.toNamed<void>(Routes.businessProductDetailScreen,
          arguments: productId);
  static void goToSettingScreen() => Get.toNamed<void>(Routes.settingScreen);
  static void goToCreateGroupScreen(bool isAddMember) =>
      Get.toNamed<void>(Routes.createGroupScreen, arguments: isAddMember);
  static void goToCreateGroupTitleScreen(bool isAddMember) =>
      Get.toNamed<void>(Routes.createGroupTitleScreen, arguments: isAddMember);
  static void goToBroadcastListScreen() =>
      Get.toNamed<void>(Routes.broadCastListScreen);
  static void goToaddBroadcastTitleScreen(bool isEdit) =>
      Get.toNamed<void>(Routes.addBordCastTitleScreen, arguments: isEdit);
  static void goToAddBroadcastScreen(bool isEdit) =>
      Get.toNamed<void>(Routes.addBordCastScreen, arguments: isEdit);
  static void goToBroadCastChatViewScreen(String brodcastId) =>
      Get.toNamed<void>(Routes.BroadCastchat, arguments: brodcastId);
  static void goToGroupChatScreen(String groupId) =>
      Get.toNamed<void>(Routes.groupChatScreen, arguments: groupId);
  static void goOffAndToNamedGroupChatScreen(String groupId) =>
      Get.offNamed<void>(Routes.groupChatScreen,
          arguments: groupId, preventDuplicates: false);
  static void goToGroupProfileDetailsScreen(String groupId) =>
      Get.toNamed<void>(Routes.groupProfileDetailsScreen, arguments: groupId);
  static void goToBroadCastProfileScreen(String brodcastId) =>
      Get.toNamed<void>(Routes.broadCastProfileScreen, arguments: brodcastId);
  static void goToMeetingScreen() => Get.toNamed<void>(Routes.meetingScreen);
  static void goToAddMeetingScreen(bool isEdit) =>
      Get.toNamed<void>(Routes.addMeetingScreen, arguments: isEdit);
  static void goToHostMeetingDetailScreen(String meetingId, String subTitle) =>
      Get.toNamed<void>(Routes.hostMeetingDetailScreen,
          arguments: [meetingId, subTitle]);
  static void goTojoinMeetingDetailScreen(String meetingId) =>
      Get.toNamed<void>(Routes.joinMeetingDetail, arguments: meetingId);
  static void goToAddMeetingMemberScreen(bool isEdit) =>
      Get.toNamed<void>(Routes.addMeetingMemberScreen, arguments: isEdit);
  static void goToEditGroupDetailsScreen() =>
      Get.toNamed<void>(Routes.editGroupDetailsScreen);
  static void goToChatScreen(String useerId, bool productInquiry) =>
      Get.toNamed<void>(Routes.chatScreen,
          arguments: [useerId, productInquiry]);
  static void gooffAndToNamedChatScreen(String useerId, bool productInquiry) =>
      Get.offAndToNamed<void>(Routes.chatScreen,
          arguments: [useerId, productInquiry]);
  static void goToChatUserProfileScreen(String useerId) =>
      Get.toNamed<void>(Routes.chatUserProfileScreen, arguments: useerId);
  static void goToShareLocationScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.shareLocationScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToCreatePollScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.createPollScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToAudioScreen() => Get.toNamed<void>(Routes.audioCallScreen);
  static void goToViewPollVoteScreen(String pollId) =>
      Get.toNamed<void>(Routes.viewPollVoteScreen, arguments: pollId);
  static void goToShareContactScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.shareContactScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToViewAllSelectContactScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.viewAllSelectContactScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToMultipalSendImageScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.multipalSendImageScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToViewAllContact(List<ContactContent> contactList) =>
      Get.toNamed<void>(Routes.ViewAllContact, arguments: contactList);
  static void goToChatProductScreen(bool isProfile) =>
      Get.toNamed<void>(Routes.chatProductScreen, arguments: isProfile);
  static void goToMessageInfoScreen(ChatListsDoc chatListsDocData) =>
      Get.toNamed<void>(Routes.messageInfoScreen, arguments: chatListsDocData);
  static void goToGroupMessageInfoScreen(ChatListsDoc groupMessageInfoScreen) =>
      Get.toNamed<void>(Routes.groupMessageInfoScreen,
          arguments: groupMessageInfoScreen);
  static void goToForwardMessageScreen(String messgaeId) =>
      Get.toNamed<void>(Routes.forwardMessageScreen, arguments: messgaeId);
  static void goToForwardMessageGroupScreen(String messgaeId) =>
      Get.toNamed<void>(Routes.forwardMessageGroupScreen, arguments: messgaeId);
  static void goToViewAllImages(List<ChatListMultiMedia>? multiMediaList) =>
      Get.toNamed<void>(Routes.viewAllImages, arguments: multiMediaList);
  static Future<void> goToVideoCallScreen(
    String agorachannelName,
    String agoraToken,
    String callId,
    bool isJoinCall,
    String banner,
    String userName,
    bool isCall,
  ) async =>
      await Get.toNamed<void>(
        Routes.videoCallScreen,
        arguments: [
          agorachannelName,
          agoraToken,
          callId,
          isJoinCall,
          banner,
          userName,
          isCall,
        ],
      );
  static Future<void> goToAudioCallScreen(
    String agorachannelName,
    String agoraToken,
    String hostMeetingId, // ✅ BACKEND MEETING ID
    bool isJoinCall,
    String banner,
    String userName,
    bool isHost, // ✅ HOST FLAG
  ) async {
    return await Get.toNamed<void>(
      Routes.audioCallScreen,
      arguments: [
        agorachannelName, // 0
        agoraToken, // 1
        hostMeetingId, // 2 ✅ IMPORTANT
        isJoinCall, // 3
        banner, // 4
        userName, // 5
        isHost, // 6 ✅ IMPORTANT
      ],
    );
  }

  static void goToSharedMediascreen(
          String userid, bool isBrodcast, String title, bool isGroup) =>
      Get.toNamed<void>(Routes.sharedMediascreen,
          arguments: [userid, isBrodcast, title, isGroup]);
  static void goToFavoriteMessageScreen() =>
      Get.toNamed<void>(Routes.favoriteMessageScreen);
  static void goToGroupFavoriteMessageScreen() =>
      Get.toNamed<void>(Routes.groupFavoriteMessageScreen);
  static void goToBrodcastFavoriteListScreen(String broadcastId) =>
      Get.toNamed<void>(Routes.brodcastFavoriteListScreen,
          arguments: broadcastId);
  static Future<void> goToMeetingCallScreen(String agorachannelName,
          String agoraToken, String callId, bool isJoinCall, bool isHost) async =>
      await Get.toNamed<void>(Routes.meetingCallScreen,
          arguments: [agorachannelName, agoraToken, callId, isJoinCall, isHost]);
  static void goToShowAllProductScreen(int index) =>
      Get.toNamed<void>(Routes.showAllProductScreen, arguments: index);
  static void goToLoginSubUserScreen() =>
      Get.toNamed<void>(Routes.loginSubUserScreen);
  static void goToMyAccountScreen() =>
      Get.toNamed<void>(Routes.myAccountScreen);
  static void goToChangeNumberScreen() =>
      Get.toNamed<void>(Routes.changeNumberScreen);
  static void goToCreateMultiUserScreen(String id) =>
      Get.toNamed<void>(Routes.createMultiUserScreen, arguments: id);
  static void goToMultiUserScreen() =>
      Get.toNamed<void>(Routes.multiUserScreen);
  static void goToAssignUserScreen() =>
      Get.toNamed<void>(Routes.assignUserScreen);
  static void goToNotificationScreen() =>
      Get.toNamed<void>(Routes.notificationScreen);
  static void goToAllNotificationScreen() =>
      Get.toNamed<void>(Routes.allNotificationScreen);
  static void goToStorageScreen() => Get.toNamed<void>(Routes.storageScreen);
  static void goToPrivacySecurityScreen() =>
      Get.toNamed<void>(Routes.privacySecurityScreen);
  static void goToPrivacyPolicyScreen() =>
      Utility.launchLinkURL("https://cochat.click/privacy-policy");
  static void goToTermConditionScreen() =>
      Get.toNamed<void>(Routes.termConditionScreen);
  static void goToHelpScreen() => Get.toNamed<void>(Routes.helpScreen);
  static void goToRecoveryEmailScreen(String isLock) =>
      Get.toNamed<void>(Routes.recoveryEmailScreen, arguments: isLock);
  static void goToChatSettingScreen() =>
      Get.toNamed<void>(Routes.chatSettingScreen);
  static void goToChatWallpaperScreen() =>
      Get.toNamed<void>(Routes.chatWallpaperScreen);
  static void goToChatWallpaperPreviewScreen() =>
      Get.toNamed<void>(Routes.chatWallpaperPreviewScreen);
  static void goToRingtoneScreen() => Get.toNamed<void>(Routes.ringtoneScreen);
  static void goToChangePinHideChatScreen() =>
      Get.toNamed<void>(Routes.changeHideChatScreen);
  static void goToForgotHideChatScreen() =>
      Get.toNamed<void>(Routes.forgotHideChatScreen);
  static void goToCreatChatLockPinScreen() =>
      Get.toNamed<void>(Routes.creatChatLockPinScreen);
  static void goToHideChatVerifyPinScreen() =>
      Get.toNamed<void>(Routes.hideChatVerifyPinScreen);
  static void goToCreateHideChatPinScreen() =>
      Get.toNamed<void>(Routes.createHideChatPinScreen);
  static void goToHideChatScreen() => Get.toNamed<void>(Routes.hideChatScreen);
  static void goToChatLockVerifyScreen() =>
      Get.toNamed<void>(Routes.chatLockVerifyScreen);
  static void goToChatLockScreen() => Get.toNamed<void>(Routes.chatLockScreen);
  static void goToForgotLockChatScreen() =>
      Get.toNamed<void>(Routes.forgotLockChatScreen);
  static void goToChangeLockChatScreen() =>
      Get.toNamed<void>(Routes.changeLockChatScreen);
  static void goToSubUserChangePasswordScreen(String subUserId) =>
      Get.toNamed<void>(Routes.subUserChangePasswordScreen,
          arguments: subUserId);
  static void goToChangeLockForgotPinScreen() =>
      Get.toNamed<void>(Routes.changeLockForgotPinScreen);
  static void goToChangeHideForgotPinScreen() =>
      Get.toNamed<void>(Routes.changeHideForgotPinScreen);
  static void goToArchiveScreen() => Get.toNamed<void>(Routes.archiveScreen);
  static void goToArchiveGroupScreen() =>
      Get.toNamed<void>(Routes.archiveGroupScreen);
  static void goToNotificationListScreen() =>
      Get.toNamed<void>(Routes.notificationListScreen);
  static void goToChatUserBookmarkScreen(String userId) =>
      Get.toNamed<void>(Routes.chatUserBookmarkScreen, arguments: userId);
  static void goToShareUserContactScreen(bool isGroup, bool isBrodcast) =>
      Get.toNamed<void>(Routes.shareUserContactScreen,
          arguments: [isGroup, isBrodcast]);
  static void goToReportUserScreen(String userId) =>
      Get.toNamed<void>(Routes.reportUserScreen, arguments: userId);
  static void goToReportGroupScreen(String groupId) =>
      Get.toNamed<void>(Routes.reportGroupScreen, arguments: groupId);
  static void goToReportUserGroupListScreen() =>
      Get.toNamed<void>(Routes.reportUserGroupListScreen);
  static void goToGetOneReportScreen(String reportId, bool isChat) =>
      Get.toNamed<void>(Routes.getOneReportScreen,
          arguments: [reportId, isChat]);
  static void goToChatProductDetailsScreen(String productId) =>
      Get.toNamed<void>(Routes.chatProductDetailsScreen, arguments: productId);
  static void goToScreenDemo() => Get.toNamed<void>(Routes.screenDemo);
  static void goToClearChatSelectScreen() => Get.toNamed<void>(Routes.clearChatSelectScreen);
}
