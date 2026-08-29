// coverage:ignore-file
import 'dart:async';
import 'dart:convert';
import 'dart:io' show Directory, File, FileMode, Platform;
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:dio/dio.dart' as dio;
import 'package:email_validator/email_validator.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
// import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

abstract class Utility {
  static const String _downloadFolderName = 'Fanzly';

  static Map<String, dynamic> callLogsData = {};

  static List<String> onlineOfflineUserList = [];
  static ProfileData? profileData;
  static AudioPlayer audioPlayer = AudioPlayer();

  static Map<String, String> deviceContactsMap = {};

  static String normalizePhoneNumber(String? phone) {
    if (phone == null) return "";
    final digits = phone.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length > 10) {
      return digits.substring(digits.length - 10);
    }
    return digits;
  }

  static String? getContactNameForPhone(String? phone) {
    if (phone == null || phone.trim().isEmpty) return null;
    final normalized = normalizePhoneNumber(phone);
    if (normalized.isEmpty) return null;
    return deviceContactsMap[normalized];
  }

  static Future<void> loadDeviceContacts() async {
    try {
      final hasPermission = await Permission.contacts.isGranted;
      if (hasPermission) {
        final contacts = await FlutterContacts.getContacts(withProperties: true);
        for (var contact in contacts) {
          final name = contact.displayName.trim();
          if (name.isNotEmpty) {
            for (var phone in contact.phones) {
              final norm = normalizePhoneNumber(phone.number);
              if (norm.isNotEmpty) {
                deviceContactsMap[norm] = name;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error loading device contacts into map: $e");
    }
  }

  static Map<String, String> resolveUserDisplay({
    String? userId,
    dynamic fullname,
    dynamic nickname,
    dynamic mobile,
    dynamic profileimage,
  }) {
    String name = "";
    String image = (profileimage ?? "").toString().trim();
    String phone = (mobile ?? "").toString().trim();

    // 1. Check direct fullname or nickname
    final full = (fullname ?? "").toString().trim();
    final nick = (nickname ?? "").toString().trim();
    if (full.isNotEmpty && full.toLowerCase() != "user") {
      name = full;
    } else if (nick.isNotEmpty && nick.toLowerCase() != "user") {
      name = nick;
    }

    // 2. Check if name passed is already a contact number or contains digits
    if (name.isNotEmpty && RegExp(r'^[+0-9\s-]+$').hasMatch(name) && phone.isEmpty) {
      phone = name;
    }

    // 3. Try resolving from device phonebook if phone is present
    if (phone.isNotEmpty) {
      final contactName = getContactNameForPhone(phone);
      if (contactName != null && contactName.trim().isNotEmpty) {
        name = contactName.trim();
      }
    }

    // 4. Look up in ChatController allFriends or chatPagingController
    if (name.isEmpty || name.toLowerCase() == "user" || image.isEmpty) {
      if (Get.isRegistered<ChatController>()) {
        final chatCtrl = Get.find<ChatController>();
        final List<MyFriendDatum> list = [
          ...chatCtrl.allFriends,
          ...(chatCtrl.chatPagingController.itemList ?? <MyFriendDatum>[]),
        ];
        final normPhone = normalizePhoneNumber(phone);
        final friend = list.firstWhereOrNull((f) =>
            (userId != null && userId.isNotEmpty && f.userid == userId) ||
            (normPhone.isNotEmpty && f.mobile != null && normalizePhoneNumber(f.mobile) == normPhone));
        if (friend != null) {
          if (name.isEmpty || name.toLowerCase() == "user") {
            final fName = (friend.fullname?.trim().isNotEmpty == true
                ? friend.fullname
                : friend.nickname)?.trim() ?? "";
            if (fName.isNotEmpty && fName.toLowerCase() != "user") {
              name = fName;
            }
          }
          if (image.isEmpty && friend.profileimage != null && friend.profileimage!.isNotEmpty) {
            image = friend.profileimage!;
          }
          if (phone.isEmpty && friend.mobile != null && friend.mobile!.isNotEmpty) {
            phone = friend.mobile!;
          }
        }
      }
    }

    // 5. Look up in CallController contactsList
    if (name.isEmpty || name.toLowerCase() == "user" || image.isEmpty) {
      if (Get.isRegistered<CallController>()) {
        final callCtrl = Get.find<CallController>();
        final normPhone = normalizePhoneNumber(phone);
        final callContact = callCtrl.contactsList.firstWhereOrNull((c) =>
            (userId != null && userId.isNotEmpty && (c.userid == userId || c.chatNestUser?.id == userId)) ||
            (normPhone.isNotEmpty && c.mobile != null && normalizePhoneNumber(c.mobile) == normPhone));
        if (callContact != null) {
          if (name.isEmpty || name.toLowerCase() == "user") {
            final cName = (callContact.name?.trim().isNotEmpty == true
                ? callContact.name
                : callContact.chatNestUser?.username)?.trim() ?? "";
            if (cName.isNotEmpty && cName.toLowerCase() != "user") {
              name = cName;
            }
          }
          if (image.isEmpty && callContact.chatNestUser?.profileImage != null && callContact.chatNestUser!.profileImage!.isNotEmpty) {
            image = callContact.chatNestUser!.profileImage!;
          }
          if (phone.isEmpty && callContact.mobile != null && callContact.mobile!.isNotEmpty) {
            phone = callContact.mobile!;
          }
        }
      }
    }

    // 6. If name is STILL empty or "User", show the contact number!
    if (name.isEmpty || name.toLowerCase() == "user") {
      if (phone.isNotEmpty) {
        name = phone;
      } else {
        name = "User";
      }
    }

    return {
      "name": name,
      "image": image,
      "mobile": phone,
    };
  }

  static Map<String, dynamic>? tryParseJson(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value;
    }
    if (value is String) {
      try {
        return jsonDecode(value) as Map<String, dynamic>;
      } catch (_) {
        return null;
      }
    }
    return null;
  }

  /// common header for All api
  static Map<String, String> commonHeader({
    Map<String, String>? otherHeader,
    bool isDefaultAuthorizationKeyAdd = true,
    bool isMultipalToken = false,
    bool isLock = false,
  }) {
    // var token = await _authRepository.getRefreshToken(isLoading: false);
    var header = <String, String>{
      'Content-Type': 'application/json',
    };

    if (isDefaultAuthorizationKeyAdd) {
      if (isMultipalToken) {
        header.addAll({
          'authorization':
              'Token ${Get.find<Repository>().getStringValue(LocalKeys.authToken)}',
          isLock ? 'authorizationlockpin' : "authorizationhidepin":
              'Token ${Get.find<Repository>().getStringValue(isLock ? LocalKeys.authorizationlockpin : LocalKeys.authorizationhidepin)}',
        });
      } else {
        header.addAll({
          'authorization':
              'Token ${Get.find<Repository>().getStringValue(LocalKeys.authToken)}',
        });
      }
    }

    if (otherHeader != null) {
      header.addAll(otherHeader);
    }
    return header;
  }

  // coverage:ignore-start
  static void printDLog(String message) {
    Logger().d('${StringConstants.appName}: $message');
  }

  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printILog(dynamic message) {
    Logger().i('${StringConstants.appName}: $message');
  }

  /// Print info log.
  ///
  /// [message] : The message which needed to be print.
  static void printLog(dynamic message) {
    Logger().log(Level.info, message);
  }

  /// Get First word of a name.
  ///
  static String? getNameInitials(String? firstName, String? lastName) =>
      '${firstName![0]}${lastName![0]}'.toUpperCase();

  /// Print error log.
  ///
  /// [message] : The message which needed to be print.
  static void printELog(String message) {
    Logger().e('${StringConstants.appName}: $message');
  }

  /// Returns a error String by validating password.
  ///
  /// for at least one upper case, at least one digit,
  /// at least one special character and and at least 6 characters long
  /// return [List<bool>] for each case.
  /// Validation logic
  /// r'^
  ///   (?=.*[A-Z])             // should contain at least one upper case
  ///   (?=.*?[0-9])            // should contain at least one digit
  ///  (?=.*?[!@#\$&*~]).{8,}   // should contain at least one Special character
  /// $
  static String? validatePassword(String value) {
    if (value.trim().isNotEmpty) {
      // if (value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      if (value.contains(RegExp(r'[A-Z]'))) {
        if (value.contains(RegExp(r'[0-9]'))) {
          if (value.length < 6) {
            return 'shouldBe6Characters'.tr;
          } else {
            return null;
          }
        } else {
          return 'shouldHaveOneDigit'.tr;
        }
      } else {
        return 'shouldHaveOneUppercaseLetter'.tr;
      }
      // } else {
      //   return 'shouldHaveOneSpecialCharacter'.tr;
      // }
    } else {
      return 'passwordRequired'.tr;
    }
  }

  /// Returns true if email is Valid
  static bool emailValidator(String email) => EmailValidator.validate(email);

  /// current chat page id
  static String currentChatPageId = '';
  static bool isJoinBtnVisible = false;

  /// Check if URL is valid
  static bool isURl(String url) {
    return RegExp(
            r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)')
        .hasMatch(url);
  }

  /// Returns true if the internet connection is available.
  static Future<bool> isNetworkAvailable() async =>
      await InternetConnectionChecker.instance.hasConnection;

  /// Print the details of the [response].
  static void printResponseDetails(Response? response) {
    if (response != null) {
      var isOkay = response.isOk;
      var statusCode = response.statusCode;
      var statusText = response.statusText;
      var method = response.request?.method ?? '';
      var path = response.request?.url.path ?? '';
      var query = response.request?.url.queryParameters ?? '';
      if (isOkay) {
        printILog(
            'Path: $path, Method: $method, Status Text: $statusText, Status Code: $statusCode, Query $query');
      } else {
        printELog(
            'Path: $path, Method: $method, Status Text: $statusText, Status Code: $statusCode, Query $query');
      }
    }
  }

  /// returns the date time in particular given formate
  static String getWeekDayMonthNumYear(DateTime dateTime) =>
      DateFormat.yMMMMEEEEd().format(dateTime);

  /// get formated [DateTime] eg. 12-01-2021
  static String getDayMonthYear(DateTime dateTime) =>
      '${getOnlyDate(dateTime)}-${DateFormat('MM').format(dateTime)}-${DateFormat.y().format(dateTime)}';

  /// get formated [DateTime] eg. 12
  static String getOnlyDate(DateTime dateTime) =>
      DateFormat('dd').format(dateTime);

  /// get formated [DateTime] eg. 12 Sep
  static String getDateAndMonth(DateTime dateTime) =>
      DateFormat('dd MMM').format(dateTime);

  /// get formated [DateTime]
  static String getWeekDay(DateTime dateTime) =>
      DateFormat.EEEE().format(dateTime);

  /// Calculates number of weeks for a given year as per https://en.wikipedia.org/wiki/ISO_week_date#Weeks_per_year
  static int _numOfWeeks(int year) {
    var dec28 = DateTime(year, 12, 28);
    var dayOfDec28 = int.parse(DateFormat('D').format(dec28));
    return ((dayOfDec28 - dec28.weekday + 10) / 7).floor();
  }

  // Calculates week number from a date as per https://en.wikipedia.org/wiki/ISO_week_date#Calculation
  static int weekNumber(DateTime date) {
    var dayOfYear = int.parse(DateFormat('D').format(date));
    var woy = ((dayOfYear - date.weekday + 10) / 7).floor();
    if (woy < 1) {
      woy = _numOfWeeks(date.year - 1);
    } else if (woy > _numOfWeeks(date.year)) {
      woy = 1;
    }
    return woy;
  }

  /// Show loader
  static void showLoader() {
    try {
      if (Get.overlayContext == null) return;
      if (Get.isDialogOpen == true) return;

      if (Get.overlayContext == null || Get.isDialogOpen == true) return;

      Get.dialog(
        const Center(
          child: CircularProgressIndicator(),
        ),
        barrierDismissible: false,
      );
    } catch (e) {
      debugPrint("Error showing loader: $e");
    }
  }

  static Widget loaderWidget() => const Center(
        child: CircularProgressIndicator(),
      );

  /// Close loader
  static void closeLoader() {
    if (Get.isDialogOpen == true) {
      Get.back();
    }
  }

  /// URL Launcher
  static void launchLinkURL(String url) async {
    await launchUrl(Uri.parse(url)).onError(
      (error, stackTrace) {
        print("Url is not valid!");
        return false;
      },
    );
  }

  /// Show info dialog
  static void showDialog(
    String message, {
    Function()? onPress,
    bool barrierDismissible = true,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        title: Text('info'.tr),
        content: Text(
          message,
        ),
        actions: [
          CupertinoButton(
            onPressed: onPress ?? Get.back,
            child: Text(
              'okay'.tr,
              style: TextStyle(color: Theme.of(Get.context!).primaryColor),
            ),
          ),
        ],
      ),
      barrierDismissible: barrierDismissible,
    );
  }

  static void showMessage(String? message, MessageType messageType,
      Function()? onTap, String actionName) {
    if (message == null || message.isEmpty) return;
    closeSnackbar();
    var backgroundColor = Colors.black;
    switch (messageType) {
      case MessageType.error:
        backgroundColor = Colors.red;
        break;
      case MessageType.information:
        backgroundColor = Colors.black.withOpacity(0.3);
        break;
      case MessageType.success:
        backgroundColor = Colors.green;
        break;
      default:
        backgroundColor = Colors.black;
        break;
    }
    Future.delayed(
      const Duration(seconds: 0),
      () {
        Get.rawSnackbar(
          snackPosition: SnackPosition.TOP,
          messageText: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          mainButton: TextButton(
            onPressed: onTap ?? Get.back,
            child: Text(
              actionName,
              style: const TextStyle(color: Colors.white),
            ),
          ),
          backgroundColor: backgroundColor,
          margin: const EdgeInsets.all(15.0),
          borderRadius: 15,
          snackStyle: SnackStyle.FLOATING,
        );
      },
    );
  }

  /// Show alert dialog
  static void showAlertDialog({
    String? message,
    String? title,
    Function()? onPress,
  }) async {
    await Get.dialog<void>(
      CupertinoAlertDialog(
        title: Text('$title'),
        content: Text('$message'),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: onPress,
            child: Text('yes'.tr),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: closeDialog,
            child: Text('no'.tr),
          )
        ],
      ),
    );
  }

  /// Close any open dialog.
  static void closeDialog() {
    if (Get.isDialogOpen == true) {
      Get.back<void>();
    }
  }

  /// Close any open snackbar
  static void closeSnackbar() {
    if (Get.isSnackbarOpen) {
      Get.back<void>();
    }
  }

  static void showNoInternet() {
    if (Get.isDialogOpen == true) return;

    Get.dialog(
      AlertDialog(
        title: Text("no_internet".tr),
        content: Text("check_connection".tr),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text("ok".tr),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  /// Show no internet dialog if there is no
  /// internet available.
  // static Future<void> showNoInternetDialog() async {
  //   await Get.dialog<void>(
  //     const NoInternetWidget(),
  //     barrierDismissible: false,
  //   );
  // }

  /// Show a message to the user.
  ///
  /// [message] : Message you need to show to the user.
  // ignore: comment_references
  /// [messageType] : Type of the message for different background color.
  // ignore: comment_references
  /// [onTap] : An event for onTap.
  // ignore: comment_references
  /// [actionName] : The name for the action.
  // static void showMessage(String? message, MessageType messageType,
  //     Function()? onTap, String actionName) {
  //   if (message == null || message.isEmpty) return;
  //   closeDialog();
  //   closeSnackbar();
  //   var backgroundColor = Colors.black;
  //   switch (messageType) {
  //     case MessageType.error:
  //       backgroundColor = Colors.red;
  //       break;
  //     case MessageType.information:
  //       backgroundColor = Colors.black.withOpacity(0.3);
  //       break;
  //     case MessageType.success:
  //       backgroundColor = Colors.green;
  //       break;
  //     default:
  //       backgroundColor = Colors.black;
  //       break;
  //   }
  //   Future.delayed(
  //     const Duration(seconds: 0),
  //     () {
  //       Get.rawSnackbar(
  //         messageText: Text(
  //           '${jsonDecode(message)['message']}',
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //         mainButton: TextButton(
  //           onPressed: onTap ?? Get.back,
  //           child: Text(
  //             actionName,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         backgroundColor: backgroundColor,
  //         margin: const EdgeInsets.all(15.0),
  //         borderRadius: 15,
  //         snackStyle: SnackStyle.FLOATING,
  //       );
  //     },
  //   );
  // }

  /// Returns Platform type
  static String platFormType() {
    var value = kIsWeb
        ? 3
        : GetPlatform.isAndroid
            ? 1
            : 2;
    return value.toString();
  }

  /// Random number generator
  static int getRandomNumer() {
    var random = Random();
    return random.nextInt(100);
  }

  /// Return file size
  static String getFileSize(int size) {
    if (size == 0) {
      return '0 KB';
    } else {
      var val = size / pow(1024, (log(size) / log(1024)).floor());
      if (size < 1024) {
        return '$val KB';
      } else {
        return '${val.toStringAsFixed(1)} MB';
      }
    }
  }

  static String getFormatedDate(String date) {
    var date = DateTime.parse('2018-04-10T04:00:00.000Z');
    return Utility.getDayMonthYear(date);
  }

  static String getFormatedTime(String date) {
    var date = DateTime.parse('2018-04-10T04:00:00.000Z');
    var format = DateFormat('HH:MM');
    return format.format(date);
  }

  static String formatTimeOfDay(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm'); //"6:00 AM"
    return format.format(dt);
  }

  static String formatTimeOfDayHHMMA(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('HH:mm a'); //"6:00 AM"
    return format.format(dt);
  }

  static String formatTimeOfDayhhMMA(TimeOfDay tod) {
    final now = new DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    final format = DateFormat('hh:mm a'); //"6:00 AM"
    return format.format(dt);
  }

  static String getTimeStempToDate(tod) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(tod);
    final format = DateFormat.jm();
    return format.format(dateTime);
  }

  static String parseTimeStamp(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('dd MMMM yyyy, hh:mm a').format(date);
    return d12;
  }

  static String parseTimeStamptoDDMMMMYY(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('dd, MMMM yyyy').format(date);
    return d12;
  }

  static String parseTimeStamptoDDMMYY(int value) {
    var date = DateTime.fromMillisecondsSinceEpoch(value);
    var d12 = DateFormat('dd/MM/yy').format(date);
    return d12;
  }

  /// WhatsApp-style chat list timestamp formatter:
  /// - Today: 12-hour format with AM/PM (e.g., 08:55 AM, 03:20 PM, 12:05 AM, 12:00 PM)
  /// - Yesterday: "Yesterday"
  /// - Older: DD/MM/YYYY (e.g., 25/08/2026)
  /// Correctly handles local timezone conversions.
  static String formatChatListDate(dynamic timestamp) {
    if (timestamp == null) return "";
    DateTime? date;
    if (timestamp is DateTime) {
      date = timestamp.toLocal();
    } else if (timestamp is int) {
      if (timestamp <= 0) return "";
      if (timestamp < 10000000000) {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000).toLocal();
      } else {
        date = DateTime.fromMillisecondsSinceEpoch(timestamp).toLocal();
      }
    } else if (timestamp is String) {
      if (timestamp.trim().isEmpty || timestamp == "0") return "";
      final intVal = int.tryParse(timestamp);
      if (intVal != null) {
        if (intVal < 10000000000) {
          date = DateTime.fromMillisecondsSinceEpoch(intVal * 1000).toLocal();
        } else {
          date = DateTime.fromMillisecondsSinceEpoch(intVal).toLocal();
        }
      } else {
        try {
          date = DateTime.parse(timestamp).toLocal();
        } catch (_) {
          return "";
        }
      }
    }

    if (date == null) return "";

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final msgDate = DateTime(date.year, date.month, date.day);

    if (msgDate == today) {
      return DateFormat('hh:mm a').format(date);
    } else if (msgDate == yesterday) {
      return 'Yesterday';
    } else {
      return DateFormat('dd/MM/yyyy').format(date);
    }
  }

  static String getTimeStempToTime(dynamic tod) {
    return formatChatListDate(tod);
  }

  static String getTimeStempToTimeHHMMAA(tod) {
    if (tod == null) return "";
    DateTime? dateTime;
    if (tod is DateTime) {
      dateTime = tod.toLocal();
    } else if (tod is int) {
      if (tod <= 0) return "";
      if (tod < 10000000000) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(tod * 1000).toLocal();
      } else {
        dateTime = DateTime.fromMillisecondsSinceEpoch(tod).toLocal();
      }
    } else if (tod is String) {
      final intVal = int.tryParse(tod);
      if (intVal != null) {
        dateTime = DateTime.fromMillisecondsSinceEpoch(
            intVal < 10000000000 ? intVal * 1000 : intVal).toLocal();
      } else {
        try {
          dateTime = DateTime.parse(tod).toLocal();
        } catch (_) {
          return "";
        }
      }
    }
    if (dateTime == null) return "";
    String formattedTime = DateFormat('hh:mm a').format(dateTime);
    return formattedTime;
  }

  static String timeStringConvertTime(String tod) {
    var inputFormat = DateFormat('hh:mm');
    var date = inputFormat.parse(tod);
    var formattedTime = DateFormat('hh:mm a');
    return formattedTime.format(date);
  }

  static String timeStringConvertTimeHH(String tod) {
    var inputFormat = DateFormat('HH:mm');
    var date = inputFormat.parse(tod);
    var formattedTime = DateFormat('HH:mm a');
    return formattedTime.format(date);
  }

  static String timeStringConvertTimeAA(String tod) {
    var inputFormat = DateFormat('HH:mm');
    var date = inputFormat.parse(tod);
    return inputFormat.format(date);
  }

  static String timeStringConvertTimeHHMM(String tod) {
    var inputFormat = DateFormat('HH:mm a');
    var date = inputFormat.parse(tod);
    return inputFormat.format(date);
  }

  static String dateStringConvertTimeHHMM(String tod) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date = inputFormat.parse(tod);
    return inputFormat.format(date);
  }

  static String dateStringConvertDate(String tod) {
    var inputFormat = DateFormat('dd-MM-yyyy');
    var date = inputFormat.parse(tod);
    var formattedTime = DateFormat('dd/MM/yyyy');
    return formattedTime.format(date);
  }

  /// Show error dialog from response model
  static void showInfoDialog(ResponseModel data,
      [bool isSuccess = false]) async {
    await Get.dialog<dynamic>(
      CupertinoAlertDialog(
        title: Text(isSuccess ? 'SUCCESS' : 'ERROR'),
        content: Text(
          jsonDecode(data.data)['Message'] as String,
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: Get.back,
            isDefaultAction: true,
            child: Text(
              'okay'.tr,
            ),
          ),
        ],
      ),
    );
  }

  /// Bottomsheet to show only alerts to user.
  static void showInfoBottomSheet({
    required String icon,
    required String title,
    required String coloredTitle,
    String? description,
    double? titleSize,
    String? subTitle,
    double? subTitleSize,
    Widget? actions,
    Function()? onPress,
    bool isdismissible = true,
    Axis direction = Axis.vertical,
    double? fontSize,
    bool defaultSpaceBetweenColoredText = false,
  }) =>
      Get.bottomSheet<void>(
        Container(
          padding: Dimens.edgeInsets16,
          decoration: BoxDecoration(
            color: Theme.of(Get.context!).canvasColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(
                Dimens.fourteen,
              ),
              topRight: Radius.circular(
                Dimens.fourteen,
              ),
            ),
          ),
          child: Container(
            margin: Dimens.edgeInsets0_20_0_0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (subTitle != null)
                  Text(
                    subTitle,
                    style: Styles.blackBold16,
                  ),
                if (description != null)
                  Text(
                    description,
                    style: Styles.black12.copyWith(
                      color: Theme.of(Get.context!).hintColor,
                    ),
                  ),
                if (actions == null) Dimens.boxHeight40,
                if (actions != null) actions,
                if (actions == null)
                  // CustomMaterialButton(
                  //   text: 'ok'.tr,
                  //   onTap: onPress,
                  // ),
                  // else
                  //   actions,
                  Dimens.boxHeight10,
              ],
            ),
          ),
        ),
        isScrollControlled: true,
        backgroundColor: Theme.of(Get.context!).canvasColor,
        isDismissible: isdismissible,
        enableDrag: isdismissible,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.0),
        ),
      );

  static String imageOptimization({
    required String bucket,
    required String url,
    required int width,
    required int height,
    required int quality,
    bool progressive = true,
    bool mozjpeg = true,
    required int blur,
  }) {
    var map = '';
    if (blur == 0) {
      map =
          '{"bucket": "$bucket","key": "$url","edits": {"resize": {"width": $width},"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg}}}';
    } else {
      map =
          '{"bucket": "$bucket","key": "$url","edits": {"resize": {"width": $width},"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg},"blur": $blur}}';
    }
    var data = base64Encode(utf8.encode(map));
    return data;
  }

  static Future<void> downloadAndSavePDF(
      String url, String folderName, int invoiceNo) async {
    late AwesomeNotifications awesomeNotifications = AwesomeNotifications();
    String fileName = url.split('/').last;

    final response = await http.get(Uri.parse(ApiWrapper.imageUrl + url));
    if (response.statusCode == 200) {
      final appDocumentsDirectory = await _getDownloadBaseDirectory();
      String folderPath = '${appDocumentsDirectory.path}/$folderName';
      await Directory(folderPath).create(recursive: true);

      String filePath = '$folderPath/$fileName';
      File pdfFile = File(filePath);
      await pdfFile.writeAsBytes(Uint8List.fromList(response.bodyBytes));

      awesomeNotifications.createNotification(
        content: NotificationContent(
            id: invoiceNo,
            channelKey: "high_importance_channel",
            title: fileName.split(".").first,
            icon: "",
            payload: {
              "pdf_url": url,
            },
            body: "$fileName successfully downloaded."),
      );

      AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) async {
          await OpenFile.open(filePath);
        },
        onNotificationDisplayedMethod: (receivedNotification) async {
          // print("Display:--- $receivedNotification");
          if (Platform.isIOS) {
            await OpenFile.open(filePath);
          }
        },
      );
    } else {
      if (kDebugMode) {
        print('Failed to download PDF. Status code: ${response.statusCode}');
      }
    }
  }

  static String imageOptimizationWithoutSize({
    required String bucket,
    required String key,
    required int quality,
    required bool progressive,
    required bool mozjpeg,
    required int blur,
  }) {
    var map = '';
    if (blur == 0) {
      map =
          '{"bucket": "$bucket","key": "$key","edits": {"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg}}}';
    } else {
      map =
          '{"bucket": "$bucket","key": "$key","edits": {"jpeg": {"quality": $quality,"progressive": $progressive,"mozjpeg": $mozjpeg},"blur": $blur}}';
    }
    var data = base64Encode(utf8.encode(map));
    return data;
  }

  static Future<String> createFolder() async {
    final baseDirectory = await _getDownloadBaseDirectory();
    final downloadDirectory =
        Directory('${baseDirectory.path}/$_downloadFolderName');

    if (await downloadDirectory.exists()) {
      return downloadDirectory.path;
    }

    await downloadDirectory.create(recursive: true);
    return downloadDirectory.path;
  }

  static Future<Directory> _getDownloadBaseDirectory() async {
    if (GetPlatform.isAndroid) {
      final androidDirectory = await getExternalStorageDirectory();
      if (androidDirectory != null) {
        return androidDirectory;
      }
    }

    return getApplicationDocumentsDirectory();
  }

  /// Download file into private folder
  static Future<void> downloadFile(String? url, String? name) async {
    Get.back<dynamic>();
    Utility.showLoader();
    final appStorage = await createFolder();
    final extension = ".${url!.split('.').last}";
    final file = File('$appStorage/${name!}');

    printILog(extension);
    printDLog(file.path);
    printDLog(url);

    try {
      var progress = '';
      final response = await dio.Dio().get<dynamic>(
        url,
        options: dio.Options(
          responseType: dio.ResponseType.bytes,
          followRedirects: false,
          // receiveTimeout: 0
        ),
        onReceiveProgress: (rec, total) {
          progress = '${((rec / total) * 100).round()}%';
          debugPrint(progress);
        },
      );

      if (GetPlatform.isIOS) {
        // dynamic result = await ImageGallerySaver.saveImage(
        //     Uint8List.fromList(response.data as List<int>),
        //     quality: 60,
        //     name: name);
        // printILog(result);
      } else {
        final d = response.data as List<int>;

        final ref = file.openSync(mode: FileMode.write);

        ref.writeFromSync(d);
        await ref.close();
      }

      Utility.closeDialog();
    } on Exception {
      Utility.closeDialog();
      printELog('Download Error');
      return;
    }
  }

  static void getReadMoreSheet({String? title, String? text}) {
    Get.bottomSheet<dynamic>(
      SafeArea(
        child: Container(
          height: Dimens.twoHundredEighty,
          constraints: const BoxConstraints(maxHeight: double.infinity),
          width: double.infinity,
          color: ColorsValue.greyColor,
          child: Padding(
            padding: Dimens.edgeInsets15_20_15_0,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title!,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          style: Styles.white23,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.back<void>();
                        },
                        child: const Icon(
                          Icons.cancel,
                        ),
                      ),
                    ],
                  ),
                  Dimens.boxHeight30,
                  Text(
                    text!,
                    style: Styles.white14,
                  ),
                  Dimens.boxHeight10,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // static bool isThemeDarkMode() {
  //   var repository = Get.find<Repository>();
  //   var themeMode = repository.getStoredValue(LocalKeys.isThemeDarkMode);
  //   return themeMode;
  // }

  // static String getStyledHtml(String content) {
  //   if (content.contains('rgb')) {
  //     debugPrint('contains======== true');
  //     var repository = Get.find<Repository>();
  //     var themeMode = repository.getStoredValue(LocalKeys.isThemeDarkMode);
  //     if (themeMode) {
  //       return content.replaceAll('<span style=\"color: rgb(44, 53, 60);\">',
  //           '<span style=\"color: rgb(255, 255, 255);\">');
  //     } else {
  //       return content;
  //     }
  //   } else {
  //     debugPrint('contains========== false');
  //     return content;
  //   }
  // }

  /// Compare password & confirm password.
  ///
  static bool comparePasswords(String password, String confirmPassword) {
    if (password == confirmPassword) {
      return true;
    }
    return false;
  }

  /// Show Error bottomsheet.
  ///
  static void showErrorBottomSheet({
    required String? message,
    Function()? onPress,
    bool isDismissible = true,
    bool autoDismiss = true,
  }) async {
    await Get.bottomSheet<void>(
      Container(
        padding: Dimens.edgeInsets30,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$message',
              style: Styles.blackBold16.copyWith(
                color: const Color.fromRGBO(235, 87, 87, 1),
              ),
            ),
            Dimens.boxHeight10,
            // CustomButton(
            //   width: Get.width - Dimens.sixty,
            //   onPress: onPress ?? Get.back,
            //   height: 50,
            //   title: 'ok'.tr,
            //   color: const Color.fromRGBO(235, 87, 87, 1),
            // ),
            // Dimens.boxHeight10,
          ],
        ),
      ),
      backgroundColor: const Color.fromRGBO(255, 206, 206, 1),
      isScrollControlled: true,
      isDismissible: isDismissible,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.0),
      ),
    ).timeout(const Duration(seconds: 4), onTimeout: () {
      if (autoDismiss) {
        if (Get.isBottomSheetOpen!) {
          Get.back<void>();
        }
      }
    });
  }

  /// Method For Get Floated Snack Bar
  static void getRawSnackBar(
    String message,
    Color backgroundColor,
  ) async {
    if (message.trim().isEmpty) return;

    Get.rawSnackbar(
      message: message,
      mainButton: TextButton(
        onPressed: Get.back,
        child: Text(
          'okay'.tr,
          style: const TextStyle(color: Colors.white),
        ),
      ),
      backgroundColor: backgroundColor,
      margin: const EdgeInsets.all(15.0),
      borderRadius: 15,
      snackStyle: SnackStyle.FLOATING,
    );
  }

  static void snacBar(
    String message,
    Color backgroundColor,
  ) async {
    if (message.trim().isEmpty) return;

    Get.rawSnackbar(
        message: message,
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(15.0),
        borderRadius: 15,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP);
  }

  static void snacBarTextMainColor(
    String message,
    Color backgroundColor,
  ) async {
    Get.rawSnackbar(
        messageText: Text(
          message,
          style: Styles.main50014,
        ),
        backgroundColor: backgroundColor,
        margin: const EdgeInsets.all(15.0),
        borderRadius: 15,
        snackStyle: SnackStyle.FLOATING,
        snackPosition: SnackPosition.TOP);
  }

  static copyText(text) {
    Clipboard.setData(
      ClipboardData(
        text: text,
      ),
    );
    snacBar("Copied to clipboard.", ColorsValue.maincolor1);
  }

  static errorMessage(String message) async {
    if (message.trim().isEmpty) return null;

    return Get.rawSnackbar(
      title: "Error",
      message: message,
      backgroundColor: Colors.red.shade400,
      snackPosition: SnackPosition.TOP,
      icon: const Icon(
        Icons.error,
        color: Colors.white70,
      ),
      shouldIconPulse: true,
      instantInit: true,
    );
  }

  // static String findResult(List<AddressComponent> results, key) {
  //   for (int i = 0; i < results.length; i++) {
  //     for (int j = 0; j < results[i].types!.length; j++) {
  //       if (results[i].types![j] == key) {
  //         return results[i].longName!;
  //       }
  //     }
  //   }
  //   return "";
  // }

  /// Document Type List For Every Platform
  static List<String> docsTypeList = [
    'zip',
    'txt',
    'rar',
    'pdf',
    'csv',
    'doc',
    'xls',
    'ppt',
    'tar',
    'tar.gz',
    'odp',
    'ods',
    'odt',
    'docx',
    'pptx',
    'xlsx',
    '7z',
  ];

  /// Video Type List For Every Platform
  static List<String> videoTypeList = [
    'MOV',
    'mov',
    'avi',
    'mp4',
    'webm',
    '3gp',
    '3gp2',
  ];

  /// Image Type List For Every Platform
  static List<String> imageTypeList = [
    'webp',
    'png',
    'jpg',
    'jpeg',
    'gif',
    'bmp',
    'ico',
    'tiff',
    'svg',
  ];

  /// Method For Convert URL to local path and save in local
  static Future<File> imageURLToFile({required String imageUrl}) async {
    // generate random number.
    var rng = Random();
    // get temporary directory of device.
    var tempDir = await getTemporaryDirectory();
    // get temporary path from temporary directory.
    var tempPath = tempDir.path;
    // create a new file in temporary path with random file name.
    var file = File('$tempPath${rng.nextInt(100)}.png');
    // call http.get method and pass imageUrl into it to get response.
    var response = await http.get(Uri.parse(imageUrl));
    // write bodyBytes received in response to file.
    await file.writeAsBytes(response.bodyBytes);
    // now return the file which is created with random name in
    // temporary directory and image bytes from response is written to // that file.
    return file;
  }

  /// Method For Get URL to Bytes
  static Future<Uint8List> urlToBytes({required String imageURL}) async {
    final data = await NetworkAssetBundle(Uri.parse(imageURL)).load(imageURL);
    final bytes = data.buffer.asUint8List();
    return bytes;
  }

  static Future<FilePickerResult?> pickPhotoVideo() async =>
      await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowMultiple: false,
        allowedExtensions: List.from(imageTypeList)..addAll(videoTypeList),
      );

  /// Method For Convert Duration To String
  static String durationToString({required Duration duration}) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    var twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    var twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    var hour = num.parse(twoDigits(duration.inHours));
    if (hour > 0) {
      return '${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds';
    } else {
      return '$twoDigitMinutes:$twoDigitSeconds';
    }
  }

  /// Age Calculator Method
  static int calculateAge(DateTime birthDate) {
    var currentDate = DateTime.now();
    var age = currentDate.year - birthDate.year;
    var month1 = currentDate.month;
    var month2 = birthDate.month;
    if (month2 > month1) {
      age--;
    } else if (month1 == month2) {
      var day1 = currentDate.day;
      var day2 = birthDate.day;
      if (day2 > day1) {
        age--;
      }
    }
    return age;
  }

  // static void showMessage(String? message, MessageType messageType,
  //     Function()? onTap, String actionName) {
  //   if (message == null || message.isEmpty) return;
  //   closeSnackbar();
  //   var backgroundColor = Colors.black;
  //   switch (messageType) {
  //     case MessageType.error:
  //       backgroundColor = Colors.red;
  //       break;
  //     case MessageType.information:
  //       backgroundColor = Colors.black.withOpacity(0.3);
  //       break;
  //     case MessageType.success:
  //       backgroundColor = Colors.green;
  //       break;
  //     default:
  //       backgroundColor = Colors.black;
  //       break;
  //   }
  //   Future.delayed(
  //     const Duration(seconds: 0),
  //     () {
  //       Get.rawSnackbar(
  //         snackPosition: SnackPosition.TOP,
  //         messageText: Text(
  //           message,
  //           style: const TextStyle(color: Colors.white),
  //         ),
  //         mainButton: TextButton(
  //           onPressed: onTap ?? Get.back,
  //           child: Text(
  //             actionName,
  //             style: const TextStyle(color: Colors.white),
  //           ),
  //         ),
  //         backgroundColor: backgroundColor,
  //         margin: const EdgeInsets.all(15.0),
  //         borderRadius: 15,
  //         snackStyle: SnackStyle.FLOATING,
  //       );
  //     },
  //   );
  // }

  static AndroidDeviceInfo? androidInfo;

  static Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  // static Future<bool> saveFile(String url, String fileName) async {
  //   try {
  //     if (await _requestPermission(int.parse(androidInfo == null
  //                 ? "12"
  //                 : androidInfo!.version.release.toString()) >
  //             12
  //         ? Permission.photos
  //         : Permission.storage)) {
  //       Directory? directory;
  //       // directory = await getExternalStorageDirectory();
  //       // String newPath = "";
  //       // List<String> paths = directory!.path.split("/");
  //       // for (int x = 1; x < paths.length; x++) {
  //       //   String folder = paths[x];
  //       //   if (folder != "Android") {
  //       //     newPath += "/" + folder;
  //       //   } else {
  //       //     break;
  //       //   }
  //       // }
  //       // newPath = newPath + "/EventoPackage";
  //       // directory = Directory(newPath);

  //       try {
  //         if (Platform.isIOS) {
  //           var dir = await getLibraryDirectory();
  //           directory = Directory(dir.path + '/FestumEvento');
  //         } else {
  //           directory = Directory('/storage/emulated/0/Download/FestumEvento');
  //           // Put file in global download folder, if for an unknown reason it didn't exist, we fallback
  //           // ignore: avoid_slow_async_io
  //           // if (!await directory.exists()) directory = await getExternalStorageDirectory();
  //         }
  //       } catch (err) {
  //         print("Cannot get download folder path");
  //       }
  //       var myPath = directory?.path;
  //       File saveFile = File(myPath! + "/$fileName");
  //       if (kDebugMode) {
  //         print(saveFile.path);
  //       }
  //       if (!await directory!.exists()) {
  //         await directory.create(recursive: true);
  //       }
  //       if (await directory.exists()) {
  //         Utility.showLoader();

  //         await dio.Dio()
  //             .download(
  //           url,
  //           saveFile.path,
  //         )
  //             .then((value) {
  //           Utility.closeLoader();
  //           Get.to(() => PdfViewerPage(saveFile.path));
  //         });
  //       }
  //     }
  //     return true;
  //   } catch (e) {
  //     //commonHelper.errorMessage(e);
  //     errorMessage(e.toString());
  //     return false;
  //   }
  // }

  static String getFileExtension(String fileName) {
    try {
      return ".${fileName.split('.').last}";
    } catch (e) {
      return "";
    }
  }

  static String dateTimeTodayWithDate(timeDate) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(timeDate);

    final DateTime dtToday = DateTime.now();
    final DateTime dtYesterday =
        DateTime.now().subtract(const Duration(days: 1));
    final DateFormat formatter = DateFormat("dd-MM-yyyy");
    final DateFormat formatterDateTime = DateFormat("dd,MMMM yyyy hh:mm a");
    final DateFormat timeFormat = DateFormat("hh:mm a");

    return formatter.format(dateTime) == formatter.format(dtToday)
        ? "Today ${timeFormat.format(dateTime)}"
        : formatter.format(dateTime) == formatter.format(dtYesterday)
            ? "Yesterday ${timeFormat.format(dateTime)}"
            : "${formatterDateTime.format(dateTime)}";
  }

  static bool timeToNext(sendTime) {
    DateTime dateTime = DateTime.fromMillisecondsSinceEpoch(sendTime);

    String timeApi = DateFormat('hh-mm').format(dateTime);
    DateTime currentTime = DateTime.now();

    DateTime targetTime = DateTime(
      currentTime.year,
      currentTime.month,
      currentTime.day,
      int.parse(timeApi.split('-').first),
      int.parse(timeApi.split('-').last),
    );

    bool within10Minutes =
        currentTime.isAfter(targetTime.subtract(Duration(minutes: 10))) &&
            currentTime.isBefore(targetTime.add(Duration(minutes: 10)));

    // Display the result
    print(within10Minutes);
    return within10Minutes;
  }

  static String timeAgo(timeDate) {
    var date = DateTime.fromMillisecondsSinceEpoch(timeDate);
    Duration diff = DateTime.now().difference(date);
    if (diff.inDays > 365) {
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
    }
    if (diff.inDays > 30) {
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
    }
    if (diff.inDays > 7) {
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
    }
    if (diff.inDays > 0) {
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
    }
    if (diff.inHours > 0) {
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
    }
    if (diff.inMinutes > 0) {
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
    }
    return "just now";
  }

  static String timestempToTime(int time) {
    var dt = DateTime.fromMillisecondsSinceEpoch(time);

    final todayDate = DateTime.now();

    final today = DateTime(todayDate.year, todayDate.month, todayDate.day);
    final yesterday =
        DateTime(todayDate.year, todayDate.month, todayDate.day - 1);
    String difference = '';
    final aDate = DateTime(dt.year, dt.month, dt.day);

    if (aDate == today) {
      difference = "Today";
    } else if (aDate == yesterday) {
      difference = "Yesterday";
    } else {
      difference = DateFormat.yMMMd().format(dt).toString();
    }

    return difference;
  }

  static Future<bool> imagePermissionCheack(BuildContext context) async {
    if (Platform.isAndroid) {
      return true;
    }
    var status = await Permission.photos.status;
    if (status.isGranted || status.isLimited) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.photos.request();
      if (requestStatus.isGranted || requestStatus.isLimited) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Photos Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Photos access is currently disabled. To use this feature, you can enable Photos access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static Future<bool> cameraPermissionCheack(BuildContext context) async {
    var status = await Permission.camera.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.camera.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Camera Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Camera access is currently disabled. To use this feature, you can enable Camera access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static Future<bool> audioPermissionCheack(BuildContext context) async {
    final Permission permission;
    if (Platform.isAndroid) {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      if (androidInfo.version.sdkInt < 33) {
        permission = Permission.storage;
      } else {
        permission = Permission.audio;
      }
    } else {
      permission = Permission.microphone;
    }

    var status = await permission.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await permission.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Audio Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Audio access is currently disabled. To use this feature, you can enable Audio access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static Future<bool> microphonePermissionCheack(BuildContext context) async {
    var status = await Permission.microphone.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.microphone.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Microphone Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Microphone access is currently disabled. To use this feature, you can enable Microphone access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static String headers() {
    return "Bearer ${Get.find<Repository>().getStringValue(LocalKeys.authToken)}";
  }

  static Future<bool> filePickPermissionCheack() async {
    if (Platform.isAndroid) {
      return true;
    }
    var status = await Permission.storage.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.storage.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Files Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Storage access is currently disabled. To use this feature, you can enable Storage access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static Future<bool> showLocationDisclosureDialog() async {
    bool userAgreed = false;
    await Get.dialog(
      Material(
        color: ColorsValue.transparent,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: Dimens.edgeInsets40_0_40_0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.all(Radius.circular(Dimens.sixteen)),
                  color: ColorsValue.whiteColor,
                ),
                width: Get.width,
                child: Padding(
                  padding: Dimens.edgeInsets40_20_40_20,
                  child: Column(
                    children: [
                      Text("location_disclosure_title".tr,
                          style: Styles.black70018,
                          textAlign: TextAlign.center),
                      Dimens.boxHeight10,
                      Text(
                        "location_disclosure_message".tr,
                        textAlign: TextAlign.center,
                        style: Styles.black40016,
                      ),
                      Dimens.boxHeight20,
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userAgreed = false;
                                Get.back();
                              },
                              child: Container(
                                height: Dimens.fourtyEight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.eight)),
                                  border:
                                      Border.all(color: ColorsValue.appColor),
                                ),
                                child: Center(
                                  child: Text("not_now".tr,
                                      style: Styles.main70016),
                                ),
                              ),
                            ),
                          ),
                          Dimens.boxWidth10,
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                userAgreed = true;
                                Get.back();
                              },
                              child: Container(
                                height: Dimens.fourtyEight,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(Dimens.eight)),
                                  color: ColorsValue.appColor,
                                ),
                                child: Center(
                                  child: Text("continue_btn".tr,
                                      style: Styles.white50016),
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
    return userAgreed;
  }

  static Future<bool> locationPermissionCheack() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      bool userAgreed = await showLocationDisclosureDialog();
      if (!userAgreed) {
        return false;
      }
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.sixteen)),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      children: [
                        Text("location_permission".tr,
                            style: Styles.black70018),
                        Dimens.boxHeight10,
                        Text(
                          "location_permission_message".tr,
                          textAlign: TextAlign.center,
                          style: Styles.black40016,
                        ),
                        Dimens.boxHeight20,
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () => Get.back(),
                                child: Container(
                                  height: Dimens.fourtyEight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.eight)),
                                    border:
                                        Border.all(color: ColorsValue.appColor),
                                  ),
                                  child: Center(
                                    child: Text("cancel".tr,
                                        style: Styles.main70016),
                                  ),
                                ),
                              ),
                            ),
                            Dimens.boxWidth10,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  Geolocator.openAppSettings();
                                  Get.back();
                                },
                                child: Container(
                                  height: Dimens.fourtyEight,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.eight)),
                                    color: ColorsValue.appColor,
                                  ),
                                  child: Center(
                                    child: Text("settings".tr,
                                        style: Styles.white50016),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
      return false;
    }
    return true;
  }

  static Future<bool> contactPermissionCheack() async {
    var status = await Permission.contacts.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.contacts.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "contacts_access_disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "contacts_access_message".tr,
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "open_settings".tr,
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "cancel".tr,
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static Future<bool> notificationPermissionCheack() async {
    var status = await Permission.notification.status;
    if (status.isGranted) {
      return true;
    }

    if (status.isDenied) {
      final requestStatus = await Permission.notification.request();
      if (requestStatus.isGranted) {
        return true;
      }
      return false;
    }

    if (status.isPermanentlyDenied) {
      await Get.dialog(
        Material(
          color: ColorsValue.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets40_0_40_0,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(Dimens.sixteen),
                    ),
                    color: ColorsValue.whiteColor,
                  ),
                  width: Get.width,
                  child: Padding(
                    padding: Dimens.edgeInsets40_20_40_20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Notification Access Disabled".tr,
                          style: Styles.black50020,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "Notification access is currently disabled. To use this feature, you can enable Notification access from the Settings app.",
                          style: Styles.hinttext40014,
                          textAlign: TextAlign.center,
                        ),
                        Dimens.boxHeight20,
                        InkWell(
                          onTap: () async {
                            Get.back();
                            await openAppSettings();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            decoration: BoxDecoration(
                              color: ColorsValue.appColor,
                              borderRadius: BorderRadius.circular(
                                Dimens.thirty,
                              ),
                            ),
                            child: Text(
                              "Open Settings",
                              style: Styles.white50018,
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        InkWell(
                          onTap: () {
                            Get.back();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            width: double.maxFinite,
                            height: Dimens.fifty,
                            child: Text(
                              "Cancel",
                              style: Styles.main50018,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      );
      return false;
    }
    return false;
  }

  static double getImageSizeMB(String filePath) {
    var file = File(filePath);
    final bytes = file.readAsBytesSync().lengthInBytes;
    final kb = bytes / 1024;
    final mb = kb / 1024;
    return mb;
  }
}

// ignore: non_constant_identifier_names
Widget Loader() {
  return Center(
      child: Lottie.asset(
    AssetConstants.loader,
    height: 100,
    width: 100,
  ));
}

class Debouncer {
  final int milliseconds;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    _timer?.cancel();
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}

class ProfileDetail {
  String? title, subtitle;
  SvgPicture? icon;

  ProfileDetail({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  factory ProfileDetail.fromJson(Map<String, dynamic> json) => ProfileDetail(
        icon: json['icon'],
        title: json['title'],
        subtitle: json['subtitle'],
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
      };
}

class ChatModel {
  bool isSend;
  bool? isSeen;
  String message;
  String? messageType;

  ChatModel({
    required this.isSend,
    required this.message,
    this.isSeen,
    this.messageType,
  });
}

class MapsLauncher {
  static String createQueryUrl(String query) {
    var uri;

    if (kIsWeb) {
      uri = Uri.https(
          'www.google.com', '/maps/search/', {'api': '1', 'query': query});
    } else if (Platform.isAndroid) {
      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      uri = Uri.https('maps.apple.com', '/', {'q': query});
    } else {
      uri = Uri.https(
          'www.google.com', '/maps/search/', {'api': '1', 'query': query});
    }

    return uri.toString();
  }

  static String createCoordinatesUrl(double latitude, double longitude,
      [String? label]) {
    var uri;

    if (kIsWeb) {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    } else if (Platform.isAndroid) {
      var query = '$latitude,$longitude';

      // if (label != null) query += '($label)';

      uri = Uri(scheme: 'geo', host: '0,0', queryParameters: {'q': query});
    } else if (Platform.isIOS) {
      var params = {'ll': '$latitude,$longitude'};

      // if (label != null) params['q'] = label;

      uri = Uri.https('maps.apple.com', '/', params);
    } else {
      uri = Uri.https('www.google.com', '/maps/search/',
          {'api': '1', 'query': '$latitude,$longitude'});
    }

    return uri.toString();
  }

  static Future<bool> launchQuery(String query) {
    return launch(createQueryUrl(query));
  }

  static Future<bool> launchCoordinates(
    double latitude,
    double longitude,
  ) {
    return launch(createCoordinatesUrl(latitude, longitude));
  }
}
