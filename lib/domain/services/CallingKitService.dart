// ignore_for_file: file_names
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class CallingKitService {
  static final CallingKitService instance = CallingKitService.internal();

  factory CallingKitService() {
    return instance;
  }

  CallingKitService.internal();

  static String get deviceRegionCode {
    final localeCandidates = <String?>[
      PlatformDispatcher.instance.locale.countryCode,
      ...PlatformDispatcher.instance.locales.map((locale) => locale.countryCode),
    ];

    for (final candidate in localeCandidates) {
      final normalized = candidate?.trim().toUpperCase() ?? "";
      if (normalized.isNotEmpty) {
        return normalized;
      }
    }

    return "";
  }

  static bool get isChinaRegion => deviceRegionCode == "CN";

  static bool get isIncomingCallUiAllowed {
    if (kIsWeb) {
      return false;
    }
    if (!Platform.isIOS && !Platform.isAndroid) {
      return false;
    }
    if (Platform.isIOS && isChinaRegion) {
      return false;
    }
    return true;
  }

  static bool get shouldObserveEvents => isIncomingCallUiAllowed;

  static Future<void> showIncomingCall(CallKitParams params) async {
    if (!isIncomingCallUiAllowed) {
      log(
        "Skipping CallKit incoming UI for region=$deviceRegionCode on iOS to comply with China App Store requirements.",
      );
      return;
    }

    await FlutterCallkitIncoming.showCallkitIncoming(params);
  }

  static Future<void> endAllCalls() async {
    if (!isIncomingCallUiAllowed) {
      return;
    }

    await FlutterCallkitIncoming.endAllCalls();
  }
}
