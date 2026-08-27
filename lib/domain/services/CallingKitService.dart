// ignore_for_file: file_names
import 'dart:developer';
import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
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
    try {
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
    } catch (_) {}

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
    try {
      if (!isIncomingCallUiAllowed) {
        log(
          "Skipping CallKit incoming UI for region=$deviceRegionCode on iOS to comply with China App Store requirements.",
        );
        return;
      }

      // Check if this exact call or any call with same ID is already ringing in native Android CallKit
      try {
        final activeCalls = await FlutterCallkitIncoming.activeCalls();
        if (activeCalls is List && activeCalls.isNotEmpty) {
          final targetId = params.id;
          final targetCallId = params.extra?['callId']?.toString();
          final bool isAlreadyRinging = activeCalls.any((c) {
            if (c is! Map) return false;
            final id = c['id']?.toString();
            final extraMap = c['extra'] is Map ? (c['extra'] as Map) : null;
            final callId = extraMap?['callId']?.toString();
            return (targetId != null && targetId.isNotEmpty && id == targetId) ||
                   (targetCallId != null && targetCallId.isNotEmpty && callId == targetCallId);
          });
          if (isAlreadyRinging) {
            log("[ANTIGRAVITY_DEBUG] Call $targetId / $targetCallId is already active in CallKit. Suppressing duplicate.");
            return;
          }
        }
      } catch (e) {
        log("Error checking activeCalls in CallingKitService: $e");
      }

      await FlutterCallkitIncoming.showCallkitIncoming(params);
    } catch (e, st) {
      log("Error in showIncomingCall: $e\n$st");
    }
  }

  static Future<void> endAllCalls() async {
    try {
      try {
        await AwesomeNotifications().cancelAll();
      } catch (_) {}

      if (!isIncomingCallUiAllowed) {
        return;
      }

      await FlutterCallkitIncoming.endAllCalls();
    } catch (e) {
      log("Error in endAllCalls: $e");
    }
  }
}
