import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/repositories/local_storage_keys.dart';
import 'package:chatnest/domain/services/CallingKitService.dart';
import 'package:chatnest/domain/usecases/video_call_usecases.dart';
import '../repositories/repository.dart';
import '../models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/entities.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/adapters.dart';
// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;
  static String? currentUuid;
  static bool isVideo = false;
  static String? _latestIncomingCallId;

  static bool toBool(dynamic value) {
    if (value is bool) {
      return value;
    }
    final normalized = (value ?? "").toString().trim().toLowerCase();
    return normalized == "yes" || normalized == "true" || normalized == "1";
  }

  static Map<String, dynamic> _toMap(dynamic value) {
    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }
    if (value is Map) {
      return value.map((key, val) => MapEntry(key.toString(), val));
    }
    if (value is String) {
      final parsed = Utility.tryParseJson(value);
      if (parsed != null) {
        return parsed;
      }
    }
    return <String, dynamic>{};
  }

  static Map<String, dynamic> _normalizeMessageData(
    Map<String, dynamic> rawData,
  ) {
    final normalized = Map<String, dynamic>.from(rawData);

    final nestedCandidates = <dynamic>[
      rawData['data'],
      rawData['payload'],
      rawData['message'],
    ];

    for (final candidate in nestedCandidates) {
      final nestedMap = _toMap(candidate);
      if (nestedMap.isNotEmpty) {
        normalized.addAll(nestedMap);
      }
    }

    return normalized;
  }

  static bool _isIncomingCallType(String type) {
    final normalized = type.toLowerCase().trim();
    return normalized == 'onincomingindividualcall' ||
        normalized == 'onincominggroupcall' ||
        normalized == 'onincomingmeetingcall' ||
        normalized == 'onincomingcall' ||
        normalized == 'incomingcall' ||
        (normalized.contains('incoming') && normalized.contains('call'));
  }

  static Map<String, String> _stringifyPayload(Map<String, dynamic> data) {
    return data.map(
      (key, value) => MapEntry(key.toString(), value?.toString() ?? ""),
    );
  }

  static Future<void> _showLocalCallNotification({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    if (!Platform.isAndroid) {
      return;
    }
    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: UniqueKey().hashCode,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          payload: _stringifyPayload(payload),
        ),
      );
    } catch (e) {
      print('⚠️ Failed to create local call notification: $e');
    }
  }

  static Future<void> _showFallbackIncomingCallNotificationIfNeeded({
    required String title,
    required String body,
    required Map<String, dynamic> payload,
  }) async {
    if (!Platform.isIOS || CallingKitService.isIncomingCallUiAllowed) {
      return;
    }

    final appLifecycleState = WidgetsBinding.instance.lifecycleState;
    if (appLifecycleState != AppLifecycleState.resumed) {
      return;
    }

    try {
      await AwesomeNotifications().createNotification(
        content: NotificationContent(
          id: UniqueKey().hashCode,
          channelKey: 'high_importance_channel',
          title: title,
          body: body,
          payload: _stringifyPayload(payload),
        ),
      );
    } catch (e) {
      print('⚠️ Failed to create fallback iOS call notification: $e');
    }
  }

  static Future<bool> _handleIncomingCallNavigationFromData(
    Map<String, dynamic> rawData,
  ) async {
    final data = _normalizeMessageData(rawData);
    final type = (data['type'] ?? data['event'] ?? "")
        .toString()
        .toLowerCase()
        .trim();
    if (!_isIncomingCallType(type)) {
      return false;
    }

    final Map<String, dynamic> nestedData = _toMap(data['calldata']);
    final Map<String, dynamic> meetingData = _toMap(data['meetingdata']);
    final Map<String, dynamic> agoraMeta = _toMap(nestedData['agorameta']);
    final Map<String, dynamic> meetingAgoraMeta = _toMap(
      meetingData['agorameta'],
    );
    final Map<String, dynamic> hostData = _toMap(meetingData['hostby']);

    final bool isVideoCall =
        toBool(data['isvideocall']) ||
        toBool(data['isvideo']) ||
        toBool(nestedData['isvideocall']) ||
        toBool(nestedData['isvideo']) ||
        toBool(data['callType']);
    final bool isAudioCall =
        toBool(data['isaudiocall']) ||
        toBool(data['isaudio']) ||
        toBool(nestedData['isaudiocall']) ||
        toBool(nestedData['isaudio']);

    final String agorachannelName =
        (data['agorachannelName'] ??
                nestedData['agorachannelName'] ??
                agoraMeta['channelName'] ??
                meetingData['agorachannelName'] ??
                meetingAgoraMeta['channelName'] ??
                nestedData['_id'] ??
                meetingData['_id'] ??
                "")
            .toString();
    final String agoratoken =
        (data['agoratoken'] ??
                nestedData['agoratoken'] ??
                agoraMeta['token'] ??
                meetingData['agoratoken'] ??
                meetingAgoraMeta['token'] ??
                "")
            .toString();
    final String callid =
        (data['callid'] ??
                nestedData['callid'] ??
                data['callId'] ??
                nestedData['_id'] ??
                data['meetingid'] ??
                meetingData['_id'] ??
                "")
            .toString();
    final String banner =
        (data['banner'] ?? nestedData['banner'] ?? meetingData['banner'] ?? "")
            .toString();
    final String fromusername =
        (data['fromusername'] ??
                data['fromUserName'] ??
                nestedData['fromusername'] ??
                meetingData['fromusername'] ??
                hostData['fullname'] ??
                hostData['nickname'] ??
                "User")
            .toString();

    if (callid.isEmpty) {
      return true;
    }

    if (type == 'onincomingmeetingcall') {
      await RouteManagement.goToMeetingCallScreen(
        agorachannelName,
        agoratoken,
        callid,
        true,
        false,
      );
    } else if (isVideoCall || !isAudioCall) {
      await RouteManagement.goToVideoCallScreen(
        agorachannelName,
        agoratoken,
        callid,
        false,
        banner,
        fromusername,
        false,
      );
    } else {
      await RouteManagement.goToAudioCallScreen(
        agorachannelName,
        agoratoken,
        callid,
        false,
        banner,
        fromusername,
        false,
      );
    }

    return true;
  }

  static String _extractEventCallId(CallEvent? event) {
    final extra = event?.body['extra'];
    if (extra is Map) {
      final id = (extra['callId'] ?? "").toString();
      if (id.isNotEmpty) {
        return id;
      }
    }
    return (Utility.callLogsData['callId'] ?? "").toString();
  }

  static bool _hasActiveCallController() {
    return Get.isRegistered<AudioCallController>() ||
        Get.isRegistered<VideoCallController>();
  }

  static bool _isActiveControllerCall(String callId) {
    if (callId.isEmpty) {
      return false;
    }
    if (Get.isRegistered<AudioCallController>()) {
      final audioId = Get.find<AudioCallController>().callId;
      if (audioId.isNotEmpty && audioId == callId) {
        return true;
      }
    }
    if (Get.isRegistered<VideoCallController>()) {
      final videoId = Get.find<VideoCallController>().callId;
      if (videoId.isNotEmpty && videoId == callId) {
        return true;
      }
    }
    return false;
  }

  static bool _shouldHandleEndOrDecline(String callId) {
    if (!_hasActiveCallController()) {
      // When no active controller exists, only handle end/decline
      // for the most recently shown incoming call.
      return callId.isNotEmpty && callId == _latestIncomingCallId;
    }
    return _isActiveControllerCall(callId);
  }

  static Future<void> _leaveCallById(String callId) async {
    if (callId.isEmpty) {
      return;
    }
    if (Get.isRegistered<AudioCallController>()) {
      final audioController = Get.find<AudioCallController>();
      if (audioController.callId == callId) {
        await audioController.postChatLeaveCall(callId);
        return;
      }
    }
    if (Get.isRegistered<VideoCallController>()) {
      final videoController = Get.find<VideoCallController>();
      if (videoController.callId == callId) {
        await videoController.postChatLeaveCall(callId);
        return;
      }
    }

    await Get.put<VideoCallController>(
      VideoCallController(
        Get.put(
          VideoCallPresenter(
            Get.put(VideoCallUsecases(Get.find()), permanent: true),
          ),
          permanent: true,
        ),
        api: ApiWrapper(),
      ),
    ).postChatLeaveCall(callId);
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: true,
      provisional: true,
      sound: true,
    );

    print('🔔 Firebase Notification Listener Initialized');

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📩 ===== FOREGROUND MESSAGE RECEIVED =====');
      print('📩 Message Type: ${message.data['type']}');
      print('📩 Full Data: ${message.data}');
      print('📩 Notification Title: ${message.notification?.title}');
      print('📩 Notification Body: ${message.notification?.body}');
      print('📩 =========================================');

      final data = _normalizeMessageData(message.data);
      final String type = (data['type'] ?? data['event'] ?? "")
          .toString()
          .toLowerCase()
          .trim();

      print('📩 Message Type (normalized): $type');

      // Robust extraction similar to socket_connection.dart
      final callDataMap = _toMap(data['calldata']);
      final bool isVideoCall =
          toBool(data['isvideocall']) ||
          toBool(data['isvideo']) ||
          toBool(callDataMap['isvideocall']) ||
          toBool(callDataMap['isvideo']);
      final bool isAudioCall =
          toBool(data['isaudiocall']) ||
          toBool(data['isaudio']) ||
          toBool(callDataMap['isaudiocall']) ||
          toBool(callDataMap['isaudio']);

      final callTypeForKit = isVideoCall ? "yes" : "no";
      isVideo = isVideoCall;
      Get.forceAppUpdate();
      currentUuid = const Uuid().v4();

      if (_isIncomingCallType(type)) {
        final Map<String, dynamic> nestedData = _toMap(data['calldata']);
        final Map<String, dynamic> meetingData = _toMap(data['meetingdata']);
        final Map<String, dynamic> agoraMeta = _toMap(nestedData['agorameta']);
        final Map<String, dynamic> meetingAgoraMeta = _toMap(
          meetingData['agorameta'],
        );
        final Map<String, dynamic> hostData = _toMap(meetingData['hostby']);

        String agorachannelName =
            (data['agorachannelName'] ??
                    nestedData['agorachannelName'] ??
                    agoraMeta['channelName'] ??
                    meetingData['agorachannelName'] ??
                    meetingAgoraMeta['channelName'] ??
                    nestedData['_id'] ??
                    meetingData['_id'] ??
                    "")
                .toString();
        String agoratoken =
            (data['agoratoken'] ??
                    nestedData['agoratoken'] ??
                    agoraMeta['token'] ??
                    meetingData['agoratoken'] ??
                    meetingAgoraMeta['token'] ??
                    "")
                .toString();
        String callid =
            (data['callid'] ??
                    nestedData['callid'] ??
                    data['callId'] ??
                    nestedData['_id'] ??
                    data['meetingid'] ??
                    meetingData['_id'] ??
                    "")
                .toString();
        String banner =
            (data['banner'] ??
                    nestedData['banner'] ??
                    meetingData['banner'] ??
                    "")
                .toString();
        String fromusername =
            (data['fromusername'] ??
                    data['fromUserName'] ??
                    nestedData['fromusername'] ??
                    meetingData['fromusername'] ??
                    hostData['fullname'] ??
                    hostData['nickname'] ??
                    "")
                .toString();

        await _showLocalCallNotification(
          title: (data['title'] ?? "Incoming call").toString(),
          body:
              (data['body'] ??
                      (fromusername.isEmpty
                          ? "Someone is calling"
                          : "$fromusername is calling"))
                  .toString(),
          payload: data,
        );

        if (type == 'onincomingmeetingcall') {
          // Identify as meeting
          showCallkitIncoming(
            currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            "meeting",
            banner,
            fromusername.isEmpty ? "Meeting" : fromusername,
          );
        } else {
          showCallkitIncoming(
            currentUuid ?? '',
            agorachannelName,
            agoratoken,
            callid,
            callTypeForKit,
            banner,
            fromusername,
          );
        }

        if (isVideoCall) {
          try {
            Get.find<Repository>().saveSecureValue("Data", "123");
          } catch (_) {}
        }
      } else if (type == "onuserleavethecall") {
        final callId = (data['callid'] ?? data['callId'] ?? "").toString();
        final hasActiveCall = _isActiveControllerCall(callId);
        if (!hasActiveCall && (isVideoCall || isAudioCall)) {
          await CallingKitService.endAllCalls();
          final fromusername =
              (data['fromusername'] ?? data['fromUserName'] ?? "User")
                  .toString();
          print("📩 Showing missed-call notification for callId=$callId");
          await _showLocalCallNotification(
            title: "Missed call",
            body: "Missed call from $fromusername",
            payload: data,
          );
        }
      } else if (type == "onuserjointhecall") {
        try {
          Get.find<VideoCallController>().timer?.cancel();
          Get.forceAppUpdate();
        } catch (_) {}
      } else {
        if (Platform.isAndroid) {
          AwesomeNotifications().createNotification(
            content: NotificationContent(
              id: UniqueKey().hashCode,
              channelKey: 'high_importance_channel',
              title: message.notification?.title ?? data['title'] ?? '',
              body: message.notification?.body ?? data['body'] ?? '',
              payload: data.map(
                (key, value) => MapEntry(key, value.toString()),
              ),
            ),
          );
        }
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      await handleNavigationOnNotificationBackground(message);
    });
  }

  static void onAppTerminateMode() {
    FirebaseMessaging.instance.getInitialMessage().then((
      RemoteMessage? message,
    ) {
      if (message != null) {
        Future.delayed(const Duration(milliseconds: 1200), () async {
          await handleNavigationOnNotification(message);
        });
      }
    });
  }

  void onDidReceiveNotificationResponse(
    ReceivedNotification notificationResponse,
  ) async {
    if (notificationResponse.payload != null) {
      var message = notificationResponse.payload;
      if (message != null) {
        await handleNavigationOnNotification(RemoteMessage.fromMap(message));
      }
    }
  }

  static Future<void> handleNavigationOnNotification(
    RemoteMessage message,
  ) async {
    print(message);
    final data = _normalizeMessageData(message.data);

    if (await _handleIncomingCallNavigationFromData(data)) {
      return;
    }

    if (data['type'] == 'onnewgroupchatmessage') {
      if (Utility.currentChatPageId != data['toid']) {
        RouteManagement.goOffAndToNamedGroupChatScreen(data['toid'] ?? "");
      }
    } else if (data['type'] == 'onnewindividualchatmessage') {
      if (Utility.currentChatPageId.isEmpty) {
        RouteManagement.goToChatScreen(data['fromid'] ?? "", false);
      } else if (Utility.currentChatPageId != data['fromid']) {
        RouteManagement.gooffAndToNamedChatScreen(data['fromid'] ?? "", false);
      }
    } else if (data['type'] == 'onnewfriendrequest') {
      if (Get.isRegistered<RequestController>()) {
        Get.find<RequestController>().receivedPagingController.refresh();
      } else {
        RouteManagement.goToRequestScreen(0);
      }
    } else if (data['type'] == 'onfriendrequestaccepted' ||
        data['type'] == 'onfriendrequestrejected' ||
        data['type'] == 'onfriendrequestblocked' ||
        data['type'] == 'onfriendrequestunblocked') {
      if (Get.isRegistered<RequestController>()) {
        Get.find<RequestController>().pagingController.refresh();
      } else {
        RouteManagement.goToRequestScreen(1);
      }
    }
  }

  static Future<void> handleNavigationOnNotificationBackground(
    RemoteMessage message,
  ) async {
    print(message);
    final data = _normalizeMessageData(message.data);

    if (await _handleIncomingCallNavigationFromData(data)) {
      return;
    }

    if (data['type'] == 'newmessagetogroup') {
      if (Utility.currentChatPageId != data['toid']) {
        RouteManagement.goOffAndToNamedGroupChatScreen(data['toid'] ?? "");
      }
    } else if (data['type'] == 'onnewindividualchatmessage') {
      if (Utility.currentChatPageId.isEmpty) {
        RouteManagement.goToChatScreen(data['fromid'] ?? "", false);
      } else if (Utility.currentChatPageId != data['fromid']) {
        RouteManagement.gooffAndToNamedChatScreen(data['fromid'] ?? "", false);
      }
    } else if (data['type'] == 'onnewfriendrequest') {
      if (Get.isRegistered<RequestController>()) {
        Get.find<RequestController>().receivedPagingController.refresh();
      } else {
        RouteManagement.goToRequestScreen(0);
      }
    } else if (data['type'] == 'onfriendrequestaccepted' ||
        data['type'] == 'onfriendrequestrejected' ||
        data['type'] == 'onfriendrequestblocked' ||
        data['type'] == 'onfriendrequestunblocked') {
      if (Get.isRegistered<RequestController>()) {
        Get.find<RequestController>().pagingController.refresh();
      } else {
        RouteManagement.goToRequestScreen(1);
      }
    }
  }

  static Future<void> initilizeNotification() async {
    await AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
          channelGroupKey: 'high_importance_channel',
          channelKey: 'high_importance_channel',
          channelName: 'its demo Notification',
          channelDescription: 'Demo Noteification ',
          ledColor: Colors.blue,
          importance: NotificationImportance.High,
          channelShowBadge: true,
          onlyAlertOnce: true,
          playSound: true,
          criticalAlerts: true,
        ),
      ],
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'high_importance_channel',
          channelGroupName: 'Group 1',
        ),
      ],
      debug: true,
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    // AwesomeNotifications().actionStream.listen((notification) {
    //   if (notification.channelKey == 'high_importance_channel') {
    //     handleNavigationOnNotification(
    //         RemoteMessage(data: notification.payload!));
    //   }
    // });
    await AwesomeNotifications().isNotificationAllowed().then((
      isAllowed,
    ) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    if (CallingKitService.shouldObserveEvents) {
      FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
        print("[ANTIGRAVITY_DEBUG] CallEvent Received: ${event?.event}");
        print("[ANTIGRAVITY_DEBUG] CallEvent Body: ${event?.body}");

        if (event?.body['extra'] != null) {
          Utility.callLogsData = Map<String, dynamic>.from(
            event?.body['extra'],
          );
        }
        print(
          "[ANTIGRAVITY_DEBUG] Utility.callLogsData: ${Utility.callLogsData}",
        );

        switch (event?.event) {
          case Event.actionCallIncoming:
            final incomingCallId = _extractEventCallId(event);
            if (incomingCallId.isNotEmpty) {
              _latestIncomingCallId = incomingCallId;
            }
            break;
          case Event.actionCallAccept:
            await Future.delayed(const Duration(seconds: 1));

            // Determine call type from event payload only (avoid stale global fallback).
            final rawCallType = (Utility.callLogsData['callType'] ?? "")
                .toString()
                .toLowerCase();
            final rawIsVideo = (Utility.callLogsData['isvideocall'] ?? "")
                .toString()
                .toLowerCase();
            final isMeetingCall = rawCallType == "meeting";
            final isVideoCall =
                rawIsVideo == "yes" ||
                rawCallType == "yes" ||
                rawCallType == "video" ||
                rawCallType == "1" ||
                rawCallType == "true";

            print(
              "[ANTIGRAVITY_DEBUG] Accepting Call. type=$rawCallType, isvideocall=$rawIsVideo, isMeeting: $isMeetingCall, isVideo: $isVideoCall",
            );

            if (isMeetingCall) {
              print("[ANTIGRAVITY_DEBUG] Navigating to Meeting Call Screen");
              await RouteManagement.goToMeetingCallScreen(
                (Utility.callLogsData['agorachannelName'] ?? "").toString(),
                (Utility.callLogsData['agoratoken'] ?? "").toString(),
                (Utility.callLogsData['callId'] ?? "").toString(),
                true,
                false,
              );
            } else if (isVideoCall) {
              print("[ANTIGRAVITY_DEBUG] Navigating to Video Call Screen");
              await RouteManagement.goToVideoCallScreen(
                (Utility.callLogsData['agorachannelName'] ?? "").toString(),
                (Utility.callLogsData['agoratoken'] ?? "").toString(),
                (Utility.callLogsData['callId'] ?? "").toString(),
                false,
                (Utility.callLogsData['banner'] ?? "").toString(),
                (Utility.callLogsData['fromusername'] ?? "").toString(),
                false,
              );
            } else {
              print("[ANTIGRAVITY_DEBUG] Navigating to Audio Call Screen");
              await RouteManagement.goToAudioCallScreen(
                (Utility.callLogsData['agorachannelName'] ?? "").toString(),
                (Utility.callLogsData['agoratoken'] ?? "").toString(),
                (Utility.callLogsData['callId'] ?? "").toString(),
                false,
                (Utility.callLogsData['banner'] ?? "").toString(),
                (Utility.callLogsData['fromusername'] ?? "").toString(),
                false,
              );
            }
            final acceptedCallId = (Utility.callLogsData['callId'] ?? "")
                .toString();
            if (acceptedCallId.isNotEmpty &&
                acceptedCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallEnded:
            print("[ANTIGRAVITY_DEBUG] Call Ended Event");
            final eventCallId = _extractEventCallId(event);
            if (!_shouldHandleEndOrDecline(eventCallId)) {
              print(
                "[ANTIGRAVITY_DEBUG] Ignoring stale end event for callId=$eventCallId",
              );
              break;
            }
            await _leaveCallById(eventCallId);
            if (eventCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallDecline:
            print("[ANTIGRAVITY_DEBUG] Call Declined Event");
            final eventCallId = _extractEventCallId(event);
            if (!_shouldHandleEndOrDecline(eventCallId)) {
              print(
                "[ANTIGRAVITY_DEBUG] Ignoring stale decline event for callId=$eventCallId",
              );
              break;
            }
            await _leaveCallById(eventCallId);
            if (eventCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallStart:
            print("[ANTIGRAVITY_DEBUG] Call Start Event");
            break;
          case Event.actionCallTimeout:
            print("[ANTIGRAVITY_DEBUG] Call Timeout Event");
            Get.back();
            break;
          default:
            break;
        }
      });
    }
  }

  static final Set<String> _processedCallIds = {};

  static Future<void> showCallkitIncoming(
    String uuid,
    agorachannelName,
    agoratoken,
    callid,
    callType,
    banner,
    userName,
  ) async {
    final String currentCallId = (callid ?? "").toString();

    // Deduplicate incoming calls to prevent double notification from Socket and FCM
    if (currentCallId.isNotEmpty) {
      if (_processedCallIds.contains(currentCallId)) {
        print(
          "[ANTIGRAVITY_DEBUG] Ignoring duplicate incoming call for callId: $currentCallId",
        );
        return;
      }
      _processedCallIds.add(currentCallId);
      // Remove from set after 10 seconds to allow legitimate future calls with same ID (if any)
      Future.delayed(const Duration(seconds: 10), () {
        _processedCallIds.remove(currentCallId);
      });
    }

    Utility.callLogsData = {};
    _latestIncomingCallId = (callid ?? "").toString();
    // Try to safely load ringtone from Hive if possible
    var ringtones = "system_ringtone_default";
    try {
      if (!Hive.isAdapterRegistered(0)) {
        await Hive.initFlutter();
      }
      if (!Hive.isBoxOpen(StringConstants.appName)) {
        await Hive.openBox<dynamic>(StringConstants.appName);
      }
      Box<dynamic> box = Hive.box<dynamic>(StringConstants.appName);
      var savedRingtone = box.get(LocalKeys.ringtones);
      if (savedRingtone != null) {
        ringtones = savedRingtone.toString();
      }
    } catch (e) {
      print("[ANTIGRAVITY_DEBUG] Hive failed to load in background: $e");
    }

    // print(box.get(LocalKeys.ringtones));
    // var ringtones = Get.find<Repository>().getStringValue(LocalKeys.ringtones);
    // var ringtones = "system_ringtone_default";
    final params = CallKitParams(
      id: uuid,
      nameCaller: userName,
      appName: 'Callkit',
      avatar: ApiWrapper.imageUrl + banner,
      handle: '0123456789',
      type: 0,
      duration: 30000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: <String, dynamic>{
        'agorachannelName': agorachannelName,
        'agoratoken': agoratoken,
        'callId': callid,
        'callType': callType,
        'banner': banner,
        'fromusername': userName,
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: ringtones == "Urban Groove"
            ? 'raw/incoming_call'
            : ringtones == "Marimba Soft"
            ? 'raw/marimba_soft'
            : ringtones == "Sunny Strum"
            ? 'raw/ringtone_call_phones'
            : ringtones == "Blissfull Chimes"
            ? 'ringtone_call_phone'
            : ringtones == "Seraphine"
            ? 'seraphine_new_horizons'
            : ringtones == "Seraphine"
            ? 'seraphine_new_horizons'
            : "system_ringtone_default",
        backgroundColor: '#ffffff',
        actionColor: '#4CAF50',
        textColor: '#000000',
        isShowFullLockedScreen: true,
        incomingCallNotificationChannelName: agorachannelName,
      ),
      ios: const IOSParams(
        iconName: 'CallKitLogo',
        handleType: '',
        supportsVideo: true,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: "system_ringtone_default",
      ),
    );
    if (!CallingKitService.isIncomingCallUiAllowed) {
      final isMeetingCall = callType.toString().toLowerCase() == "meeting";
      final isVideoCall = callType.toString().toLowerCase() == "yes";
      await _showFallbackIncomingCallNotificationIfNeeded(
        title: isMeetingCall ? "Incoming session" : "Incoming call",
        body: userName.toString().trim().isEmpty
            ? "Someone is calling"
            : "${userName.toString().trim()} is calling",
        payload: <String, dynamic>{
          'type': isMeetingCall ? 'onincomingmeetingcall' : 'incomingcall',
          'agorachannelName': agorachannelName?.toString() ?? "",
          'agoratoken': agoratoken?.toString() ?? "",
          'callid': currentCallId,
          'callType': callType?.toString() ?? "",
          'isvideocall': isVideoCall.toString(),
          'isaudiocall': (!isMeetingCall && !isVideoCall).toString(),
          'banner': banner?.toString() ?? "",
          'fromusername': userName?.toString() ?? "",
        },
      );
      return;
    }

    await CallingKitService.showIncomingCall(params);
  }
}

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp();
  } catch (_) {}

  final payload = receivedAction.payload;
  if (payload == null || payload.isEmpty) {
    return;
  }

  await FirebaseApi.handleNavigationOnNotification(
    RemoteMessage(data: Map<String, dynamic>.from(payload)),
  );
}

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  print('📩 ===== BACKGROUND MESSAGE RECEIVED =====');
  final data = FirebaseApi._normalizeMessageData(message.data);
  final String type = (data['type'] ?? data['event'] ?? "")
      .toString()
      .toLowerCase()
      .trim();
  print('📩 Message Type (normalized): $type');
  print('📩 Full Data: $data');
  print('📩 =========================================');

  final callDataMap = FirebaseApi._toMap(data['calldata']);
  final bool isVideoCall =
      FirebaseApi.toBool(data['isvideocall']) ||
      FirebaseApi.toBool(data['isvideo']) ||
      FirebaseApi.toBool(callDataMap['isvideocall']) ||
      FirebaseApi.toBool(callDataMap['isvideo']);
  final bool isAudioCall =
      FirebaseApi.toBool(data['isaudiocall']) ||
      FirebaseApi.toBool(data['isaudio']) ||
      FirebaseApi.toBool(callDataMap['isaudiocall']) ||
      FirebaseApi.toBool(callDataMap['isaudio']);

  final callTypeForKit = isVideoCall ? "yes" : "no";

  try {
    FirebaseApi.isVideo = isVideoCall;
    if (Get.isRegistered<GetMaterialController>()) {
      Get.forceAppUpdate();
    }
  } catch (e) {
    print('Background Get exception: $e');
  }

  FirebaseApi.currentUuid = const Uuid().v4();

  if (FirebaseApi._isIncomingCallType(type)) {
    final Map<String, dynamic> nestedData = FirebaseApi._toMap(
      data['calldata'],
    );
    final Map<String, dynamic> meetingData = FirebaseApi._toMap(
      data['meetingdata'],
    );
    final Map<String, dynamic> agoraMeta = FirebaseApi._toMap(
      nestedData['agorameta'],
    );
    final Map<String, dynamic> meetingAgoraMeta = FirebaseApi._toMap(
      meetingData['agorameta'],
    );
    final Map<String, dynamic> hostData = FirebaseApi._toMap(
      meetingData['hostby'],
    );

    String agorachannelName =
        (data['agorachannelName'] ??
                nestedData['agorachannelName'] ??
                agoraMeta['channelName'] ??
                meetingData['agorachannelName'] ??
                meetingAgoraMeta['channelName'] ??
                nestedData['_id'] ??
                meetingData['_id'] ??
                "")
            .toString();
    String agoratoken =
        (data['agoratoken'] ??
                nestedData['agoratoken'] ??
                agoraMeta['token'] ??
                meetingData['agoratoken'] ??
                meetingAgoraMeta['token'] ??
                "")
            .toString();
    String callid =
        (data['callid'] ??
                nestedData['callid'] ??
                data['callId'] ??
                nestedData['_id'] ??
                data['meetingid'] ??
                meetingData['_id'] ??
                "")
            .toString();
    String banner =
        (data['banner'] ?? nestedData['banner'] ?? meetingData['banner'] ?? "")
            .toString();
    String fromusername =
        (data['fromusername'] ??
                data['fromUserName'] ??
                nestedData['fromusername'] ??
                meetingData['fromusername'] ??
                hostData['fullname'] ??
                hostData['nickname'] ??
                "")
            .toString();

    await FirebaseApi._showLocalCallNotification(
      title: (data['title'] ?? "Incoming call").toString(),
      body:
          (data['body'] ??
                  (fromusername.isEmpty
                      ? "Someone is calling"
                      : "$fromusername is calling"))
              .toString(),
      payload: data,
    );

    if (type == 'onincomingmeetingcall') {
      await FirebaseApi.showCallkitIncoming(
        FirebaseApi.currentUuid ?? '',
        agorachannelName,
        agoratoken,
        callid,
        "meeting",
        banner,
        fromusername.isEmpty ? "Meeting" : fromusername,
      );
    } else {
      await FirebaseApi.showCallkitIncoming(
        FirebaseApi.currentUuid ?? '',
        agorachannelName,
        agoratoken,
        callid,
        callTypeForKit,
        banner,
        fromusername,
      );
    }
    if (isVideoCall) {
      try {
        if (Get.isRegistered<Repository>()) {
          Get.find<Repository>().saveSecureValue("Data", "123");
        }
      } catch (_) {}
    }
  } else if (type == "onuserleavethecall") {
    try {
      final callId = (data['callid'] ?? data['callId'] ?? "").toString();
      final hasActiveCall = FirebaseApi._isActiveControllerCall(callId);
      if (!hasActiveCall && (isVideoCall || isAudioCall)) {
        await CallingKitService.endAllCalls();
        final fromusername =
            (data['fromusername'] ?? data['fromUserName'] ?? "User").toString();
        print("📩 Showing missed-call notification for callId=$callId");
        await FirebaseApi._showLocalCallNotification(
          title: "Missed call",
          body: "Missed call from $fromusername",
          payload: data,
        );
      }
    } catch (_) {
      await CallingKitService.endAllCalls();
    }
  } else if (type == "onuserjointhecall") {
    try {
      if (Get.isRegistered<VideoCallController>()) {
        Get.find<VideoCallController>().timer?.cancel();
      }
      if (Get.isRegistered<GetMaterialController>()) {
        Get.forceAppUpdate();
      }
    } catch (_) {}
  }
}
