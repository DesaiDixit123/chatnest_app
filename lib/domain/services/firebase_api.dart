import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/device/repositories/device_repositories.dart';
import 'package:chatnest/domain/services/call_manager_service.dart';
import 'package:chatnest/domain/repositories/local_storage_keys.dart';
import 'package:chatnest/domain/services/CallingKitService.dart';
import 'package:chatnest/domain/usecases/video_call_usecases.dart';
import '../repositories/repository.dart';
import '../models/models.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  static final Set<String> _acceptedCallIds = <String>{};

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

  static bool _isAcceptingCall = false;

  static Future<void> ensureServicesInitialized() async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      if (Firebase.apps.isEmpty) {
        if (Platform.isAndroid) {
          await Firebase.initializeApp(
            options: const FirebaseOptions(
              apiKey: "AIzaSyCvW3Ud64vIqYcsjf7LiZHY3-SFmbfrIys",
              appId: "1:852697551916:android:e4b80eb56f19b84ff22d89",
              messagingSenderId: "852697551916",
              projectId: "co-chat-36393",
              storageBucket: "co-chat-36393.firebasestorage.app",
            ),
          );
        } else {
          await Firebase.initializeApp();
        }
      }
    } catch (_) {}

    try {
      await Hive.initFlutter();
      if (!Hive.isBoxOpen(StringConstants.appName)) {
        await Hive.openBox<dynamic>(StringConstants.appName);
      }
    } catch (e) {
      print("[ANTIGRAVITY_DEBUG] Hive init error in background: $e");
    }

    if (!Get.isRegistered<ApiWrapper>()) {
      Get.put<ApiWrapper>(ApiWrapper(), permanent: true);
    }
    if (!Get.isRegistered<DeviceRepository>()) {
      Get.put<DeviceRepository>(DeviceRepository(), permanent: true);
    }
    if (!Get.isRegistered<ConnectHelper>()) {
      Get.put<ConnectHelper>(ConnectHelper(), permanent: true);
    }
    if (!Get.isRegistered<DataRepository>()) {
      Get.put<DataRepository>(
        DataRepository(Get.find<ConnectHelper>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<Repository>()) {
      Get.put<Repository>(
        Repository(Get.find<DeviceRepository>(), Get.find<DataRepository>()),
        permanent: true,
      );
    }
    if (!Get.isRegistered<CallManagerService>()) {
      Get.put<CallManagerService>(CallManagerService(), permanent: true);
    }
  }

  static Future<void> handleAcceptedCallData(Map<dynamic, dynamic> callData) async {
    if (_isAcceptingCall) return;
    _isAcceptingCall = true;

    try {
      print("[ANTIGRAVITY_DEBUG] handleAcceptedCallData: $callData");
      await ensureServicesInitialized();

      final String agorachannelName = (callData['agorachannelName'] ?? "").toString();
      final String agoratoken = (callData['agoratoken'] ?? "").toString();
      final String callId = (callData['callId'] ?? callData['callid'] ?? "").toString();
      final String rawCallType = (callData['callType'] ?? "").toString().toLowerCase();
      final String rawIsVideo = (callData['isvideocall'] ?? "").toString().toLowerCase();
      final String banner = (callData['banner'] ?? "").toString();
      final String fromusername = (callData['fromusername'] ?? callData['fromUserName'] ?? "User").toString();

      final bool isMeetingCall = rawCallType == "meeting";
      final bool isVideoCall = rawIsVideo == "yes" ||
          rawIsVideo == "true" ||
          rawCallType == "yes" ||
          rawCallType == "video" ||
          rawCallType == "1" ||
          rawCallType == "true";

      // Stop any ringtones and end CallKit notification
      Utility.audioPlayer.stop();
      await CallingKitService.endAllCalls();

      if (callId.isEmpty) {
        print("[ANTIGRAVITY_DEBUG] Cannot navigate to call: callId is empty");
        return;
      }

      // Check if call screen already open
      if (Get.isRegistered<AudioCallController>() && Get.find<AudioCallController>().callId == callId) {
        print("[ANTIGRAVITY_DEBUG] AudioCallController already open for callId=$callId");
        return;
      }
      if (Get.isRegistered<VideoCallController>() && Get.find<VideoCallController>().callId == callId) {
        print("[ANTIGRAVITY_DEBUG] VideoCallController already open for callId=$callId");
        return;
      }

      if (isMeetingCall) {
        print("[ANTIGRAVITY_DEBUG] Navigating to Meeting Call Screen for callId=$callId");
        await RouteManagement.goToMeetingCallScreen(
          agorachannelName,
          agoratoken,
          callId,
          true,
          false,
        );
      } else if (isVideoCall) {
        print("[ANTIGRAVITY_DEBUG] Navigating to Video Call Screen for callId=$callId");
        await RouteManagement.goToVideoCallScreen(
          agorachannelName,
          agoratoken,
          callId,
          false,
          banner,
          fromusername,
          false,
        );
      } else {
        print("[ANTIGRAVITY_DEBUG] Navigating to Audio Call Screen for callId=$callId");
        await RouteManagement.goToAudioCallScreen(
          agorachannelName,
          agoratoken,
          callId,
          false,
          banner,
          fromusername,
          false,
        );
      }
    } finally {
      Future.delayed(const Duration(milliseconds: 1200), () {
        _isAcceptingCall = false;
      });
    }
  }

  static Future<void> checkAndHandlePendingAcceptedCall() async {
    try {
      const helloChannel = MethodChannel('HelloWorld');
      final dynamic initialAcceptedCall =
          await helloChannel.invokeMethod('getInitialAcceptedCall');
      if (initialAcceptedCall != null && initialAcceptedCall is Map && initialAcceptedCall.isNotEmpty) {
        print("[ANTIGRAVITY_DEBUG] Found initial accepted call from native intent: $initialAcceptedCall");
        await handleAcceptedCallData(initialAcceptedCall);
        return;
      }

      final calls = await FlutterCallkitIncoming.activeCalls();
      if (calls is List && calls.isNotEmpty) {
        for (final call in calls) {
          if (call is Map) {
            final isAccepted = call['isAccepted'] == true;
            final extra = call['extra'];
            if (isAccepted && extra is Map && extra.isNotEmpty) {
              print("[ANTIGRAVITY_DEBUG] Found active accepted CallKit call: $extra");
              await handleAcceptedCallData(extra);
              return;
            }
          }
        }
      }
    } catch (e) {
      print("[ANTIGRAVITY_DEBUG] Error checking pending accepted call: $e");
    }
  }

  static bool _isActiveCallOpen(String callId) {
    if (callId.isEmpty) return false;
    if (Get.isRegistered<AudioCallController>() && Get.find<AudioCallController>().callId == callId) {
      return true;
    }
    if (Get.isRegistered<VideoCallController>() && Get.find<VideoCallController>().callId == callId) {
      return true;
    }
    return false;
  }

  static final Set<String> _processedCallIds = {};

  static Future<void> showCallkitIncoming(
    String uuid,
    agorachannelName,
    agoratoken,
    callid,
    callType,
    banner,
    userName, {
    String? fromid,
  }) async {
    final String currentCallId = (callid != null && callid.toString().trim().isNotEmpty)
        ? callid.toString().trim()
        : (agorachannelName != null && agorachannelName.toString().trim().isNotEmpty)
            ? agorachannelName.toString().trim()
            : uuid;
    final String channelKey = (agorachannelName != null && agorachannelName.toString().trim().isNotEmpty)
        ? agorachannelName.toString().trim()
        : currentCallId;

    // Strict deduplication by both callId and channel to guarantee NO double ring from Socket and FCM
    if (_processedCallIds.contains(currentCallId) ||
        _processedCallIds.contains(channelKey) ||
        _isActiveCallOpen(currentCallId) ||
        _isActiveCallOpen(channelKey)) {
      print(
        "[ANTIGRAVITY_DEBUG] Ignoring duplicate incoming call for callId: $currentCallId, channel: $channelKey",
      );
      return;
    }
    _processedCallIds.add(currentCallId);
    _processedCallIds.add(channelKey);
    Future.delayed(const Duration(seconds: 15), () {
      _processedCallIds.remove(currentCallId);
      _processedCallIds.remove(channelKey);
    });

    _latestIncomingCallId = currentCallId;
    final isVideoCall = callType.toString().toLowerCase() == "yes" || callType.toString().toLowerCase() == "video";
    final isMeetingCall = callType.toString().toLowerCase() == "meeting";
    String callerName = (userName ?? "").toString().trim();

    // 0. Ensure device contacts map is populated if empty
    if (Utility.deviceContactsMap.isEmpty) {
      try {
        await Utility.loadDeviceContacts();
      } catch (_) {}
    }

    // 1. Resolve contact name from device contacts phonebook
    final nameFromPhone = Utility.getContactNameForPhone(callerName);
    if (nameFromPhone != null && nameFromPhone.trim().isNotEmpty) {
      callerName = nameFromPhone.trim();
    }

    // 2. If callerName is empty, "user", or a numeric phone number (e.g. 6354871861), look up real name in friends / contacts
    final bool isRawNumber = RegExp(r'^[+0-9\s-]+$').hasMatch(callerName);
    if (callerName.isEmpty || callerName.toLowerCase() == "user" || isRawNumber) {
      final logName = (Utility.callLogsData['fromusername'] ?? Utility.callLogsData['fromUserName'] ?? Utility.callLogsData['name'] ?? "").toString().trim();
      if (logName.isNotEmpty && logName.toLowerCase() != "user" && !RegExp(r'^[+0-9\s-]+$').hasMatch(logName)) {
        callerName = logName;
      }

      if (Get.isRegistered<ChatController>()) {
        final normInput = Utility.normalizePhoneNumber(userName);
        final chatController = Get.find<ChatController>();
        final List<MyFriendDatum> combinedList = [
          ...chatController.allFriends,
          ...(chatController.chatPagingController.itemList ?? <MyFriendDatum>[]),
        ];
        final friend = combinedList.firstWhereOrNull((f) =>
            (fromid != null && fromid.isNotEmpty && f.userid == fromid) ||
            (currentCallId.isNotEmpty && f.friendrequestid == currentCallId) ||
            (f.mobile != null && Utility.normalizePhoneNumber(f.mobile) == normInput) ||
            f.channelID == (agorachannelName ?? "").toString());
        if (friend != null) {
          final fName = (friend.fullname?.trim().isNotEmpty == true
              ? friend.fullname
              : friend.nickname)?.trim() ?? "";
          if (fName.isNotEmpty) {
            callerName = fName;
          }
        }
      }

      if (Get.isRegistered<CallController>() && (callerName.isEmpty || callerName.toLowerCase() == "user" || RegExp(r'^[+0-9\s-]+$').hasMatch(callerName))) {
        final normInput = Utility.normalizePhoneNumber(userName);
        final callContact = Get.find<CallController>().contactsList.firstWhereOrNull((c) =>
            (fromid != null && fromid.isNotEmpty && (c.userid == fromid || c.chatNestUser?.id == fromid)) ||
            (c.mobile != null && Utility.normalizePhoneNumber(c.mobile) == normInput));
        if (callContact != null) {
          final cName = (callContact.name?.trim().isNotEmpty == true
              ? callContact.name
              : callContact.chatNestUser?.username)?.trim() ?? "";
          if (cName.isNotEmpty) {
            callerName = cName;
          }
        }
      }
    }
    if (callerName.isEmpty) {
      callerName = "User";
    }

    final avatarUrl = (banner != null && banner.toString().trim().isNotEmpty)
        ? (banner.toString().startsWith("http") ? banner.toString() : ApiWrapper.imageUrl + banner.toString())
        : "";

    final handleText = isMeetingCall
        ? "ChatNest Meeting"
        : (isVideoCall ? "ChatNest Video Call" : "ChatNest Audio Call");

    final params = CallKitParams(
      id: currentCallId,
      nameCaller: callerName,
      appName: 'ChatNest',
      avatar: avatarUrl,
      handle: handleText,
      type: isVideoCall ? 1 : 0,
      duration: 35000,
      textAccept: 'Accept',
      textDecline: 'Decline',
      missedCallNotification: const NotificationParams(
        showNotification: true,
        isShowCallback: true,
        subtitle: 'Missed call',
        callbackText: 'Call back',
      ),
      extra: <String, dynamic>{
        'agorachannelName': agorachannelName?.toString() ?? "",
        'agoratoken': agoratoken?.toString() ?? "",
        'callId': currentCallId,
        'callType': callType?.toString() ?? "",
        'isvideocall': isVideoCall ? 'yes' : 'no',
        'isaudiocall': (!isMeetingCall && !isVideoCall).toString(),
        'banner': banner?.toString() ?? "",
        'fromusername': callerName,
      },
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: false,
        ringtonePath: "ringtone_default",
        backgroundColor: '#075E54',
        actionColor: '#25D366',
        textColor: '#ffffff',
        isShowFullLockedScreen: true,
        incomingCallNotificationChannelName: "Incoming Calls",
        missedCallNotificationChannelName: "Missed Calls",
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
      await _showFallbackIncomingCallNotificationIfNeeded(
        title: isMeetingCall ? "Incoming session" : "Incoming call",
        body: "$callerName is calling",
        payload: <String, dynamic>{
          'type': isMeetingCall ? 'onincomingmeetingcall' : 'incomingcall',
          'agorachannelName': agorachannelName?.toString() ?? "",
          'agoratoken': agoratoken?.toString() ?? "",
          'callid': currentCallId,
          'callType': callType?.toString() ?? "",
          'isvideocall': isVideoCall.toString(),
          'isaudiocall': (!isMeetingCall && !isVideoCall).toString(),
          'banner': banner?.toString() ?? "",
          'fromusername': callerName,
        },
      );
      return;
    }

    print("[ANTIGRAVITY_DEBUG] Showing CallKit incoming for caller=$callerName, callId=$currentCallId");
    await CallingKitService.showIncomingCall(params);
    print("[ANTIGRAVITY_DEBUG] CallingKitService.showIncomingCall finished.");
  }

  static Future<void> syncFcmTokenWithBackend([String? token]) async {
    try {
      await ensureServicesInitialized();
      final currentToken = token ?? await FirebaseMessaging.instance.getToken();
      if (currentToken != null && currentToken.isNotEmpty) {
        print("[ANTIGRAVITY_DEBUG] Syncing FCM token with backend: $currentToken");
        if (Get.isRegistered<Repository>()) {
          final authToken = Get.find<Repository>().getStringValue(LocalKeys.authToken);
          if (authToken.isNotEmpty) {
            await Get.find<Repository>().updateFcmToken(fcmToken: currentToken);
            print("[ANTIGRAVITY_DEBUG] FCM token successfully updated on backend.");
          }
        }
      }
    } catch (e) {
      print("[ANTIGRAVITY_DEBUG] Error syncing FCM token: $e");
    }
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

    // Sync current FCM token with backend
    syncFcmTokenWithBackend();
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      syncFcmTokenWithBackend(newToken);
    });

    // MethodChannel listener for MainActivity ACTION_CALL_ACCEPT intents
    const MethodChannel('HelloWorld').setMethodCallHandler((call) async {
      if (call.method == 'CALL_ACCEPTED_INTENT') {
        final data = call.arguments;
        if (data != null && data is Map) {
          print("[ANTIGRAVITY_DEBUG] Received CALL_ACCEPTED_INTENT from native: $data");
          final acceptedCallId = (data['callId'] ?? data['callid'] ?? "").toString();
          if (acceptedCallId.isNotEmpty) {
            _acceptedCallIds.add(acceptedCallId);
          }
          await handleAcceptedCallData(data);
        }
      }
    });

    if (CallingKitService.shouldObserveEvents) {
      FlutterCallkitIncoming.onEvent.listen((CallEvent? event) async {
        print("[ANTIGRAVITY_DEBUG] CallEvent Received: ${event?.event}");
        print("[ANTIGRAVITY_DEBUG] CallEvent Body: ${event?.body}");

        if (event?.body['extra'] != null) {
          Utility.callLogsData = Map<String, dynamic>.from(
            event?.body['extra'],
          );
        }

        switch (event?.event) {
          case Event.actionCallIncoming:
            final incomingCallId = _extractEventCallId(event);
            if (incomingCallId.isNotEmpty) {
              _latestIncomingCallId = incomingCallId;
            }
            break;
          case Event.actionCallAccept:
            final extraData = event?.body['extra'] != null
                ? Map<String, dynamic>.from(event!.body['extra'])
                : Utility.callLogsData;
            final acceptedCallId = (extraData['callId'] ?? extraData['callid'] ?? "").toString();
            if (acceptedCallId.isNotEmpty) {
              _acceptedCallIds.add(acceptedCallId);
            }
            await handleAcceptedCallData(extraData);
            if (acceptedCallId.isNotEmpty && acceptedCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallEnded:
            print("[ANTIGRAVITY_DEBUG] Call Ended Event from CallKit");
            final eventCallId = _extractEventCallId(event);
            if ((eventCallId.isNotEmpty && _acceptedCallIds.contains(eventCallId)) ||
                _isActiveCallOpen(eventCallId) ||
                (Get.isRegistered<CallManagerService>() && Get.find<CallManagerService>().isCallActive)) {
              print("[ANTIGRAVITY_DEBUG] CallKit activity ended after ACCEPT/ACTIVE for callId: $eventCallId. Preserving in-app call session!");
              break;
            }
            await CallingKitService.endAllCalls();
            if (_shouldHandleEndOrDecline(eventCallId)) {
              await _leaveCallById(eventCallId);
            }
            if (eventCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallDecline:
            print("[ANTIGRAVITY_DEBUG] Call Declined Event from CallKit");
            final eventCallId = _extractEventCallId(event);
            await CallingKitService.endAllCalls();
            if (_shouldHandleEndOrDecline(eventCallId)) {
              await _leaveCallById(eventCallId);
            }
            if (eventCallId == _latestIncomingCallId) {
              _latestIncomingCallId = null;
            }
            break;
          case Event.actionCallTimeout:
            print("[ANTIGRAVITY_DEBUG] Call Timeout Event");
            final timeoutCallId = _extractEventCallId(event);
            await CallingKitService.endAllCalls();
            if (_shouldHandleEndOrDecline(timeoutCallId)) {
              await _leaveCallById(timeoutCallId);
            }
            break;
          default:
            break;
        }
      });
    }

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('📩 ===== FOREGROUND MESSAGE RECEIVED =====');
      print('📩 Message Type: ${message.data['type']}');
      print('📩 Full Data: ${message.data}');
      print('📩 =========================================');

      final data = _normalizeMessageData(message.data);
      final String type = (data['type'] ?? data['event'] ?? "")
          .toString()
          .toLowerCase()
          .trim();

      final callDataMap = _toMap(data['calldata']);
      final bool isVideoCall =
          toBool(data['isvideocall']) ||
          toBool(data['isvideo']) ||
          toBool(callDataMap['isvideocall']) ||
          toBool(callDataMap['isvideo']);

      final callTypeForKit = isVideoCall ? "yes" : "no";

      if (_isIncomingCallType(type)) {
        final Map<String, dynamic> nestedData = _toMap(data['calldata']);
        final Map<String, dynamic> meetingData = _toMap(data['meetingdata']);
        final Map<String, dynamic> agoraMeta = _toMap(nestedData['agorameta']);
        final Map<String, dynamic> meetingAgoraMeta = _toMap(
          meetingData['agorameta'],
        );
        final Map<String, dynamic> hostData = _toMap(meetingData['hostby']);

        String agorachannelName = (data['agorachannelName'] ??
                nestedData['agorachannelName'] ??
                agoraMeta['channelName'] ??
                meetingData['agorachannelName'] ??
                meetingAgoraMeta['channelName'] ??
                nestedData['_id'] ??
                meetingData['_id'] ??
                "").toString();
        String agoratoken = (data['agoratoken'] ??
                nestedData['agoratoken'] ??
                agoraMeta['token'] ??
                meetingData['agoratoken'] ??
                meetingAgoraMeta['token'] ??
                "").toString();
        String callid = (data['callid'] ??
                nestedData['callid'] ??
                data['callId'] ??
                nestedData['_id'] ??
                data['meetingid'] ??
                meetingData['_id'] ??
                "").toString();
        String banner = (data['banner'] ?? nestedData['banner'] ?? meetingData['banner'] ?? "").toString();
        String fromid = (data['fromid'] ?? nestedData['from'] ?? "").toString();
        String fromusername = (data['fromusername'] ??
                data['fromUserName'] ??
                nestedData['fromusername'] ??
                meetingData['fromusername'] ??
                hostData['fullname'] ??
                hostData['nickname'] ??
                "").toString();

        // If the call screen is already open via socket, don't show duplicate CallKit UI
        if (!_isActiveCallOpen(callid)) {
          final callUuid = const Uuid().v4();
          currentUuid = callUuid;
          if (type == 'onincomingmeetingcall') {
            showCallkitIncoming(
              callUuid,
              agorachannelName,
              agoratoken,
              callid,
              "meeting",
              banner,
              fromusername.isEmpty ? "Meeting" : fromusername,
              fromid: fromid,
            );
          } else {
            showCallkitIncoming(
              callUuid,
              agorachannelName,
              agoratoken,
              callid,
              callTypeForKit,
              banner,
              fromusername,
              fromid: fromid,
            );
          }
        }
      } else if (type == "oncallendedbyhost" ||
          type == "oncallcancelled" ||
          type == "oncallrejected" ||
          type == "oncallended") {
        print("📩 Call ended/rejected/cancelled FCM received: $type");
        Utility.audioPlayer.stop();
        await CallingKitService.endAllCalls();
        final String reason = type == "oncallrejected"
            ? "Call declined"
            : (type == "oncallcancelled" ? "Call cancelled" : "Call ended");
        if (Get.isRegistered<VideoCallController>()) {
          Get.find<VideoCallController>().handleRemoteCallTermination(reason: reason);
        }
        if (Get.isRegistered<AudioCallController>()) {
          Get.find<AudioCallController>().handleRemoteCallTermination(reason: reason);
        }
      } else if (type == "onuserleavethecall") {
        final callId = (data['callid'] ?? data['callId'] ?? "").toString();
        final hasActiveCall = _isActiveControllerCall(callId);
        if (!hasActiveCall && (isVideoCall || !isVideoCall)) {
          await CallingKitService.endAllCalls();
        }
      } else if (type == "onuserjointhecall") {
        print("📩 Ignored onuserjointhecall in foreground");
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

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Check for pending accepted call after cold start
    Future.delayed(const Duration(milliseconds: 700), () async {
      await checkAndHandlePendingAcceptedCall();
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
          channelName: 'Chat Notifications',
          channelDescription: 'Chat and message notifications',
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
      debug: false,
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
    );

    await AwesomeNotifications().isNotificationAllowed().then((
      isAllowed,
    ) async {
      if (!isAllowed) {
        await AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }
}

@pragma('vm:entry-point')
Future<void> onActionReceivedMethod(ReceivedAction receivedAction) async {
  await FirebaseApi.ensureServicesInitialized();

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
  await FirebaseApi.ensureServicesInitialized();
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

  final callTypeForKit = isVideoCall ? "yes" : "no";

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
    String fromid =
        (data['fromid'] ?? nestedData['from'] ?? "").toString();
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

    final callUuid = const Uuid().v4();
    FirebaseApi.currentUuid = callUuid;

    await FirebaseApi.showCallkitIncoming(
      callUuid,
      agorachannelName,
      agoratoken,
      callid,
      type == 'onincomingmeetingcall' ? "meeting" : callTypeForKit,
      banner,
      fromusername.isEmpty ? "User" : fromusername,
      fromid: fromid,
    );
  } else if (type == "oncallendedbyhost" ||
      type == "oncallcancelled" ||
      type == "oncallrejected" ||
      type == "oncallended" ||
      type == "onuserleavethecall") {
    print("📩 Background call termination received: $type");
    await CallingKitService.endAllCalls();
  } else if (type == "onuserjointhecall") {
    print("📩 Ignored onuserjointhecall in background");
  }
}
