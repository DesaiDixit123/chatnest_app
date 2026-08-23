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
}

class Global {
  static ProfileData? getProfileData;
}
