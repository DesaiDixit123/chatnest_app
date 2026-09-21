// coverage:ignore-file

import 'package:chatnest/domain/domain.dart';

/// LocalKeys used to manage local strings
abstract class LocalKeys {
  static const authToken = 'authToken';
  static const chatWallpaper = 'chatWallpaper';
  static const ringtones = 'ringtones';
  static const ringSelect = 'ringSelect';
  static const authorizationhidepin = 'authorizationhidepin';
  static const authorizationlockpin = 'authorizationlockpin';
  static const locale = 'locale';
  static const isProfileCompleted = 'isProfileCompleted';
  static const productId = 'productId';
  static const userIds = 'userIds';
  static const chanelId = 'chanelId';
  static const profileImg = 'profileImg';
  static const fullName = 'fullName';
  static const isSubUser = 'isSubUser';
  static const parentUserId = 'parentUserId';
  static const notificationToken = 'notificationToken';
  static const fcmToken = 'fcmToken';
  static const isContactsSyncConsented = 'isContactsSyncConsented';
  static const lastActiveMeetingId = 'last_active_meeting_id';
  static const lastActiveMeetingTitle = 'last_active_meeting_title';
  static const lastActiveMeetingChannel = 'last_active_meeting_channel';
  static const lastActiveMeetingToken = 'last_active_meeting_token';
  static const lastActiveMeetingIsHost = 'last_active_meeting_is_host';
  static const hasSeenSubscriptionPopup = 'hasSeenSubscriptionPopup';
  static const userSubscription = 'userSubscription';
  static const userInvoices = 'userInvoices';
  static const adminGstPercentage = 'adminGstPercentage';
  static const adminGstLabel = 'adminGstLabel';
}

class Global {
  static ProfileData? getProfileData;
}
