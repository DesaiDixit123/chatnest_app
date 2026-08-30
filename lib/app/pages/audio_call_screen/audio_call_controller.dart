import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart' as agora;
import 'package:audioplayers/audioplayers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/app_pages.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AudioCallController extends GetxController {
  AudioCallController(this.audioCallPresenter, {required this.api});

  final AudioCallPresenter audioCallPresenter;
  /// backend userId -> user info waiting for Agora uid assignment
  final Map<String, AgoraUser> queuedRemoteMembersById = {};
  final List<String> queuedRemoteMemberOrder = [];
  final List<PendingInvitee> pendingInvitees = [];

  /// backend userId -> user info (used for mapping Agora UID to backend user ID)
  final Map<String, Map<String, String>> callMembersMap = {};
  
  bool? isSelfCall;

  @override
  void onInit() {
    final args = Get.arguments;
    if (args is List) {
      userImage = args.length > 4 ? (args[4] ?? "").toString() : "";
      userName = args.length > 5 ? (args[5] ?? "User").toString() : "User";
      isCall = args.length > 6 ? args[6] ?? false : false;
      callId = args.length > 2 ? (args[2] ?? "").toString() : "";
      isSelfCall = args.length > 6 ? args[6] ?? false : false;
    } else {
      userImage = "";
      userName = "User";
      isCall = false;
      isSelfCall = false;
    }
 
    final resolved = Utility.resolveUserDisplay(
      fullname: (userName == "User" || userName.trim().isEmpty) ? null : userName,
      profileimage: userImage,
      mobile: Utility.callLogsData['mobile'] ??
          Utility.callLogsData['mobile_number'] ??
          (args is List && args.length > 5 ? args[5] : null),
    );
    userName = resolved['name'] ?? "User";
    if (userImage == null || userImage!.isEmpty) {
      userImage = resolved['image'];
    }

    _registerSocketListeners();

    if (isCall) {
      Utility.audioPlayer
          .play(AssetSource('images/instagram_outgoing_cal.mp3'));
    }

    super.onInit();
  }

  @override
  void onClose() {
    _unregisterSocketListeners();
    Utility.audioPlayer.stop();
    timer?.cancel();
    callDurationTimer?.cancel();
    super.onClose();
  }

  String? userImage;
  int counter = 30;
  Timer? timer;
  Timer? callDurationTimer;
  bool isCall = false;
  bool isCallConnected = false;
  bool isInitialized = false;
  bool _isAutoEndingCall = false;
  bool _isEnding = false;
  String? endReasonText;
  String userName = "User";
  Duration callDuration = Duration.zero;

  String callId = "";

  void _updateCallManagerParticipantNames() {
    try {
      final names = <String>[];
      for (var u in users) {
        final n = (u.name ?? "").trim();
        if (n.isNotEmpty && n != "User" && !names.contains(n)) {
          names.add(n);
        }
      }
      if (names.isNotEmpty && Get.isRegistered<CallManagerService>()) {
        Get.find<CallManagerService>().updateParticipants(names);
      }
    } catch (_) {}
  }

  void _registerSocketListeners() {
    if (callId.isNotEmpty) {
      SocketConnection.socket?.emit("join-call-room", {"callId": callId});
    }

    SocketConnection.socket?.off("call-rejected", _onCallRejected);
    SocketConnection.socket?.on("call-rejected", _onCallRejected);

    SocketConnection.socket?.off("call-cancelled", _onCallCancelled);
    SocketConnection.socket?.on("call-cancelled", _onCallCancelled);

    SocketConnection.socket?.off("call-ended", _onCallEnded);
    SocketConnection.socket?.on("call-ended", _onCallEnded);

    SocketConnection.socket?.off("stop-ringtone", _onStopRingtone);
    SocketConnection.socket?.on("stop-ringtone", _onStopRingtone);

    SocketConnection.socket?.off("call-accepted", _onCallAccepted);
    SocketConnection.socket?.on("call-accepted", _onCallAccepted);
  }

  void _unregisterSocketListeners() {
    SocketConnection.socket?.off("call-rejected", _onCallRejected);
    SocketConnection.socket?.off("call-cancelled", _onCallCancelled);
    SocketConnection.socket?.off("call-ended", _onCallEnded);
    SocketConnection.socket?.off("stop-ringtone", _onStopRingtone);
    SocketConnection.socket?.off("call-accepted", _onCallAccepted);
  }

  void _onCallRejected(dynamic data) {
    final id = (data is Map ? (data['callId'] ?? data['callid']) : data).toString();
    if (id.isNotEmpty && id != callId) return;
    print("[ANTIGRAVITY_DEBUG] AudioCallController: Remote call rejected received");
    final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);

    if (users.length > 2 || remoteParticipantsCount > 1 || callMembersMap.length > 1) {
      print("[ANTIGRAVITY_DEBUG] Multi-party conference active: ignoring call-rejected and handling participant left: $fromUserId");
      if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
        handleParticipantLeft(fromUserId, callId: id);
      }
      return;
    }
    handleRemoteCallTermination(reason: "Call declined");
  }

  void _onCallCancelled(dynamic data) {
    final id = (data is Map ? (data['callId'] ?? data['callid']) : data).toString();
    if (id.isNotEmpty && id != callId) return;
    print("[ANTIGRAVITY_DEBUG] AudioCallController: Remote call cancelled received");
    final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);

    if (users.length > 2 || remoteParticipantsCount > 1 || callMembersMap.length > 1) {
      print("[ANTIGRAVITY_DEBUG] Multi-party conference active: ignoring call-cancelled and handling participant left: $fromUserId");
      if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
        handleParticipantLeft(fromUserId, callId: id);
      }
      return;
    }
    handleRemoteCallTermination(reason: "Call cancelled");
  }

  void _onCallEnded(dynamic data) {
    final id = (data is Map ? (data['callId'] ?? data['callid']) : data).toString();
    if (id.isNotEmpty && id != callId) return;
    print("[ANTIGRAVITY_DEBUG] AudioCallController: Remote call ended received");
    final fromUserId = (data is Map ? (data['fromUserId'] ?? data['fromid'] ?? data['leftUserId']) : "").toString();
    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);

    if (users.length > 2 || remoteParticipantsCount > 1 || callMembersMap.length > 1) {
      print("[ANTIGRAVITY_DEBUG] Multi-party conference active: treating call-ended as participant left: $fromUserId");
      if (fromUserId.isNotEmpty && fromUserId != currentUserId) {
        handleParticipantLeft(fromUserId, callId: id);
      }
      return;
    }
    handleRemoteCallTermination(reason: "Call ended");
  }

  void _onStopRingtone(dynamic data) {
    Utility.audioPlayer.stop();
  }

  void _onCallAccepted(dynamic data) {
    final id = (data is Map ? (data['callId'] ?? data['callid']) : data).toString();
    if (id.isNotEmpty && id != callId) return;
    handleRemoteUserJoined();
  }

  void handleRemoteUserJoined() {
    print("[ANTIGRAVITY_DEBUG] AudioCallController: handleRemoteUserJoined");
    Utility.audioPlayer.stop();
    timer?.cancel();
    if (!isCallConnected) {
      _startCallDurationTimer();
    }
  }

  Future<void> handleRemoteCallTermination({required String reason}) async {
    if (_isEnding) return;
    _isEnding = true;

    print("[ANTIGRAVITY_DEBUG] AudioCallController: handleRemoteCallTermination reason=$reason");

    Utility.audioPlayer.stop();
    timer?.cancel();
    _stopCallDurationTimer();

    endReasonText = reason;
    update();

    await CallingKitService.endAllCalls();
    await disposeAgora();
    await Get.find<CallManagerService>().endCall();

    Future.delayed(const Duration(milliseconds: 600), () {
      _safeNavigateBack();
    });
  }

  void handleParticipantLeft(String leftUserId, {String? callId}) {
    if (callId != null && callId.isNotEmpty && this.callId.isNotEmpty && this.callId != callId) {
      return;
    }
    print("[ANTIGRAVITY_DEBUG] AudioCallController handleParticipantLeft: userId=$leftUserId");
    if (leftUserId.isEmpty) return;

    int? targetUid;
    if (callMembersMap.containsKey(leftUserId)) {
      final uidStr = callMembersMap[leftUserId]?['uid'] ?? "";
      targetUid = int.tryParse(uidStr);
      callMembersMap.remove(leftUserId);
    }
    final numericUid = _generateNumericUid(leftUserId);

    users.removeWhere((u) => (targetUid != null && u.uid == targetUid) || u.uid == numericUid);
    _updateCallManagerParticipantNames();
    update();

    if (remoteParticipantsCount == 0 && isCallConnected) {
      _stopCallDurationTimer();
      _autoLeaveIfAlone();
    }
  }

  void _safeNavigateBack() {
    print("[ANTIGRAVITY_DEBUG] AudioCallController: _safeNavigateBack popping route");
    try {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
    } catch (_) {}

    try {
      final nav = Get.key.currentState;
      if (nav != null && nav.canPop()) {
        nav.pop();
        return;
      }
    } catch (_) {}

    try {
      if (Get.context != null && Navigator.canPop(Get.context!)) {
        Navigator.pop(Get.context!);
        return;
      }
    } catch (_) {}

    try {
      Get.back();
    } catch (_) {}
  }

  String _preferredName(dynamic fullname, dynamic nickname, {dynamic mobile, String? userId}) {
    final resolved = Utility.resolveUserDisplay(
      userId: userId,
      fullname: fullname,
      nickname: nickname,
      mobile: mobile,
    );
    return resolved['name'] ?? "User";
  }

  void startTimer() {
    timer?.cancel();
    const oneSec = Duration(seconds: 30);
    timer = Timer(
      oneSec,
      () async {
        if (!isCallConnected && !_isEnding && callId.isNotEmpty) {
          await postChatMissedCall(callId);
          await handleRemoteCallTermination(reason: "No answer");
        }
      },
    );
  }

  int get remoteParticipantsCount =>
      users.where((u) => u.uid != currentUid).length;

  String get callStatusText {
    if (endReasonText != null && endReasonText!.isNotEmpty) {
      return endReasonText!;
    }
    if (!isCallConnected) {
      return "Ringing...";
    }
    final minutes =
        callDuration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        callDuration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  void _startCallDurationTimer() {
    if (isCallConnected) {
      return;
    }
    isCallConnected = true;
    
    final callManager = Get.find<CallManagerService>();
    if (callManager.connectedAt.value == null) {
      callManager.connectedAt.value = DateTime.now();
      callDuration = Duration.zero;
    } else {
      callDuration = DateTime.now().difference(callManager.connectedAt.value!);
    }

    callDurationTimer?.cancel();
    callDurationTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      callDuration += const Duration(seconds: 1);
      update();
    });
    update();
  }

  void _stopCallDurationTimer({bool reset = false}) {
    callDurationTimer?.cancel();
    callDurationTimer = null;
    isCallConnected = false;
    if (reset) {
      callDuration = Duration.zero;
    }
    update();
  }

  RtcEngine? agoraEngine;
  final users = <AgoraUser>{};
  late double viewAspectRatio;
  int? currentUid;
  bool isMicEnabled = false;
  bool isVideoEnabled = false;
  bool isSpeaker = true;

  String appId = "";
  String token = "";
  String channelName = "";
  bool isMic = true;
  bool isVideo = true;

  Future<void> disposeAgora() async {
    Utility.audioPlayer.stop();
    timer?.cancel();
    _stopCallDurationTimer(reset: true);
    users.clear();
    pendingInvitees.clear();
    queuedRemoteMembersById.clear();
    queuedRemoteMemberOrder.clear();
  }

  Future<void> _endCallGlobally() async {
    Utility.audioPlayer.stop();
    timer?.cancel();
    _stopCallDurationTimer(reset: true);
    users.clear();
    
    if (callId.isNotEmpty) {
      await postChatLeaveCall(callId);
    }
    
    await Get.find<CallManagerService>().endCall();
  }

  Future<void> _autoLeaveIfAlone() async {
    if (_isAutoEndingCall) {
      return;
    }
    _isAutoEndingCall = true;
    try {
      if (callId.isNotEmpty) {
        await postChatLeaveCall(callId);
      }
      CallingKitService.endAllCalls();
      _safeNavigateBack();
      await Get.find<CallManagerService>().endCall();
    } finally {
      _isAutoEndingCall = false;
    }
  }

  void onGlobalProfileFetched(String userId, Map<String, String> profile) {
    final name = (profile['name'] ?? "").trim();
    final img = (profile['image'] ?? "").trim();
    final mob = (profile['mobile'] ?? "").trim();
    final uid = _generateNumericUid(userId);

    final resolvedName = (name.isNotEmpty && name != "User") ? name : (mob.isNotEmpty ? mob : "User");

    callMembersMap[userId] = {
      "name": resolvedName,
      "image": img,
      "uid": uid.toString(),
      "mobile": mob,
    };

    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
    if (userId != currentUserId) {
      if (userName == "User" || userName.trim().isEmpty || RegExp(r'^[+0-9\s-]+$').hasMatch(userName)) {
        if (resolvedName != "User") {
          userName = resolvedName;
        }
      }
      if (userImage == null || userImage!.isEmpty) {
        if (img.isNotEmpty) {
          userImage = img;
        }
      }
    }

    for (AgoraUser u in users) {
      if (u.uid == uid || (u.uid != currentUid && (u.name == "User" || u.name == null || u.name!.isEmpty || u.name == mob))) {
        if (resolvedName != "User") {
          u.name = resolvedName;
        }
        if (img.isNotEmpty) {
          u.bannerImg = img;
        }
      }
    }

    _syncUsersWithCallMembers();
    update();
  }

  void cacheCallMembers(List members) {
    for (final m in members) {
      dynamic user = m is Map ? (m["memberid"] ?? m) : m;
      String userId = "";
      String rawFullname = "";
      String rawNickname = "";
      String rawMobile = "";
      String rawImage = "";

      if (user is Map) {
        userId = (user["_id"] ?? user["userid"] ?? user["id"] ?? "").toString();
        rawFullname = (user["fullname"] ?? "").toString();
        rawNickname = (user["nickname"] ?? "").toString();
        rawMobile = (user["mobile"] ?? user["mobile_number"] ?? "").toString();
        rawImage = (user["profileimage"] ?? "").toString();
      } else if (user is String && user.isNotEmpty) {
        userId = user;
      }

      if (userId.isEmpty) {
        continue;
      }
      
      final uid = _generateNumericUid(userId);
      final resolved = Utility.resolveUserDisplay(
        userId: userId,
        fullname: rawFullname,
        nickname: rawNickname,
        mobile: rawMobile,
        profileimage: rawImage,
      );
      final memberName = (resolved['name']?.isNotEmpty == true && resolved['name'] != "User")
          ? resolved['name']!
          : (resolved['mobile']?.isNotEmpty == true ? resolved['mobile']! : "User");
      final memberImage = resolved['image'] ?? rawImage;

      callMembersMap[userId] = {
        "name": memberName,
        "image": memberImage,
        "uid": uid.toString(),
        "mobile": resolved['mobile'] ?? rawMobile,
      };

      if (userId.length >= 12 && (memberName == "User" || memberImage.isEmpty)) {
        Utility.fetchAndCacheUserProfile(userId);
      }

      final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
      if (userId != currentUserId) {
        if (userName == "User" || userName.trim().isEmpty || RegExp(r'^[+0-9\s-]+$').hasMatch(userName)) {
          if (memberName.isNotEmpty && memberName != "User") {
            userName = memberName;
          }
        }
        if (userImage == null || userImage!.isEmpty) {
          if (memberImage.isNotEmpty) {
            userImage = memberImage;
          }
        }
      }

      final status = (m is Map ? (m["status"] ?? "") : "").toString().toLowerCase();
      if (status == "ringing") {
        pendingInvitees.removeWhere((element) => element.userId == userId);
        pendingInvitees.add(
          PendingInvitee(
            userId: userId,
            name: memberName,
            status: "Ringing",
            uid: uid,
          ),
        );
      } else {
        pendingInvitees.removeWhere((element) => element.userId == userId);
      }
    }
    _syncUsersWithCallMembers();
    update();
  }

  void _syncUsersWithCallMembers() {
    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);

    // 1. Match by exact UID
    for (AgoraUser u in users) {
      if (u.uid != currentUid) {
        callMembersMap.forEach((key, val) {
          if (val['uid'] == u.uid.toString()) {
            final name = (val['name'] ?? val['mobile'] ?? "").toString().trim();
            if (name.isNotEmpty && name != "User") {
              u.name = name;
            }
            final img = (val['image'] ?? "").toString().trim();
            if (img.isNotEmpty) {
              u.bannerImg = img;
            }
          }
        });
      }
    }

    // 2. For any remote user who still has name == "User" or empty, match with unclaimed member
    for (AgoraUser u in users) {
      if (u.uid != currentUid && (u.name == null || u.name!.isEmpty || u.name == "User")) {
        for (var entry in callMembersMap.entries) {
          if (entry.key != currentUserId) {
            final memberName = (entry.value['name'] ?? entry.value['mobile'] ?? "").toString().trim();
            final isAlreadyAssigned = users.any((other) => other != u && other.name == memberName && memberName.isNotEmpty && memberName != "User");
            if (!isAlreadyAssigned && memberName.isNotEmpty && memberName != "User") {
              u.name = memberName;
              u.bannerImg = (entry.value['image'] ?? "").toString().trim();
              entry.value['uid'] = u.uid.toString();
              break;
            }
          }
        }
      }
    }

    // 3. Fallback to pendingInvitees if still User
    for (AgoraUser u in users) {
      if (u.uid != currentUid && (u.name == null || u.name!.isEmpty || u.name == "User")) {
        for (var p in pendingInvitees) {
          final isAlreadyAssigned = users.any((other) => other != u && other.name == p.name);
          if (!isAlreadyAssigned && p.name.isNotEmpty && p.name != "User") {
            u.name = p.name;
            break;
          }
        }
      }
    }
    _updateCallManagerParticipantNames();
  }

  String _displayFirstName(String? name) {
    final cleaned = (name ?? "").trim();
    if (cleaned.isEmpty || cleaned == "User") {
      return "User";
    }
    return cleaned;
  }

  void _addPendingInvitee(String userId, String name) {
    final exists = pendingInvitees.any((e) => e.userId == userId);
    if (exists) {
      return;
    }
    pendingInvitees.add(
      PendingInvitee(
        userId: userId,
        name: _displayFirstName(name),
        status: "Ringing",
      ),
    );
    update();
  }

  void _removePendingInviteeByUserId(String? userId) {
    if (userId != null && userId.trim().isNotEmpty) {
      pendingInvitees.removeWhere((e) => e.userId == userId);
    } else if (pendingInvitees.isNotEmpty) {
      pendingInvitees.removeAt(0);
    }
    update();
  }

  Future<void> initialize() async {
    print("[ANTIGRAVITY_DEBUG] AudioController initialize()");
    print("[ANTIGRAVITY_DEBUG] Token: $token");
    print("[ANTIGRAVITY_DEBUG] Channel: $channelName");

    // 🔴 ANTIGRAVITY FIX: Fetch token if missing
    // ALWAYS Fetch member info to populate names/images/hashes
    if (callId.isNotEmpty) {
      try {
        var response = await audioCallPresenter.postChatJoinCall(
          callid: callId,
          isLoading: false,
        );

        if (response != null && response.statusCode == 200) {
          print("[ANTIGRAVITY_DEBUG] ✅ Successfully fetched call details for resolution");
          var jsonData = jsonDecode(response.data);

          if (jsonData['Data'] != null) {
            final callData = jsonData['Data'];
            
            // Cache all members for name/image resolution
            if (callData['members'] != null) {
              cacheCallMembers(callData['members']);
            }

            // Fallback for token/channel if missing from arguments
            var agoraMeta = callData['agorameta'];
            String? extractedToken;
            String? extractedChannel;

            if (agoraMeta != null) {
              extractedToken = agoraMeta['token'];
              extractedChannel = agoraMeta['channelName'];
            } else {
              extractedToken = callData['agoratoken'];
              extractedChannel = callData['agorachannelName'];
            }

            if (token.isEmpty || token == "null") {
              if (extractedToken != null && extractedToken.toString().isNotEmpty) {
                token = extractedToken.toString();
              }
            }

            if (channelName.isEmpty || channelName == "null") {
              if (extractedChannel != null && extractedChannel.toString().isNotEmpty) {
                channelName = extractedChannel.toString();
              }
            }

            // Sync legacy userName/userImage for UI fallbacks
            final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
            final from = callData['from'];
            final toUser = callData['touser'];
            final fromId = (from?['_id'] ?? "").toString();
            final isCurrentFrom = currentUserId.isNotEmpty && fromId.isNotEmpty && currentUserId == fromId;
            final remoteUser = isCurrentFrom ? toUser : from;
            if (remoteUser != null) {
              userName = _preferredName(remoteUser['fullname'], remoteUser['nickname']);
              userImage = (remoteUser['profileimage'] ?? "").toString();
            }
          }
        }
      } catch (e) {
        print("[ANTIGRAVITY_DEBUG] ❌ Exception fetching members: $e");
      }
    }

    // Set aspect ratio for video according to platform
    if (kIsWeb) {
      viewAspectRatio = 3 / 2;
    } else if (Platform.isAndroid || Platform.isIOS) {
      viewAspectRatio = 2 / 3;
    } else {
      viewAspectRatio = 3 / 2;
    }

    isMicEnabled = isMic;
    isVideoEnabled = isVideo;
    update();
    await _initAgoraRtcEngine();
    _addAgoraEventHandlers();

    final callManager = Get.find<CallManagerService>();
    bool wasAlreadyActive = callManager.isCallActive &&
        callManager.activeCallId.value == callId &&
        isInitialized;

    if (wasAlreadyActive) {
      print("[ANTIGRAVITY_DEBUG] Re-attaching to existing active audio call session");
      _syncUsersWithCallMembers();
      _updateCallManagerParticipantNames();
      update();
      return;
    }

    isInitialized = true;

    await agoraEngine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: _generateNumericUid(Utility.profileData?.id ?? "0"),
      options: ChannelMediaOptions(
        clientRoleType: ClientRoleType.clientRoleBroadcaster,
        channelProfile: ChannelProfileType.channelProfileCommunication,
        publishMicrophoneTrack: isMicEnabled,
        publishCameraTrack: isVideoEnabled,
      ),
    );

    // Register with CallManagerService
    callManager.registerCall(
      type: CallType.audio,
      channelName: channelName,
      callId: callId,
      token: token,
      isHost: isSelfCall ?? false,
      userName: userName,
      userImage: userImage ?? "",
    );

    // If caller, reset connectedAt so Ringing... is shown only on initial dial
    if (isSelfCall == true) {
      callManager.connectedAt.value = null;
      isCallConnected = false;
      callDuration = Duration.zero;
    } else if (callManager.connectedAt.value != null) {
      _startCallDurationTimer();
    }
    _updateCallManagerParticipantNames();
  }

  int _generateNumericUid(String str) {
    if (str.trim().isEmpty) return 0;
    int hash = 0;
    for (int i = 0; i < str.length; i++) {
      int char = str.codeUnitAt(i);
      // Precise 32-bit signed wrap, then unsigned 32-bit conversion to match JS (hash >>> 0)
      hash = (31 * hash + char).toSigned(32);
    }
    return hash & 0xFFFFFFFF;
  }

  Future<void> _initAgoraRtcEngine() async {
    final callManager = Get.find<CallManagerService>();
    if (callManager.agoraEngine != null) {
      agoraEngine = callManager.agoraEngine;
      return;
    }

    agoraEngine = createAgoraRtcEngine();
    await agoraEngine?.initialize(const RtcEngineContext(
      appId: '0bacf816c87b4b4799c3e59f09f415c2',
      channelProfile: ChannelProfileType.channelProfileCommunication,
    ));
    await agoraEngine?.enableAudio();
    await agoraEngine?.setClientRole(
        role: ClientRoleType.clientRoleBroadcaster);
    await agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    
    callManager.agoraEngine = agoraEngine;
  }

  void _addAgoraEventHandlers() => agoraEngine?.registerEventHandler(
        RtcEngineEventHandler(
          onError: (err, msg) {
            final info = 'LOG::onError: $err';
            debugPrint(info);
          },
          onJoinChannelSuccess: (connection, elapsed) {
            currentUid = connection.localUid;

            users.add(
              AgoraUser(
                uid: connection.localUid ?? 0,
                name: _preferredName(
                  Utility.profileData?.fullname,
                  Utility.profileData?.nickname,
                ),
                bannerImg: Utility.profileData?.profileimage,
                isAudioEnabled: isMicEnabled,
              ),
            );
            Future.delayed(const Duration(milliseconds: 200), () async {
              try {
                await agoraEngine?.setEnableSpeakerphone(true);
                isSpeaker = true;
                update();
              } catch (e) {
                debugPrint("Speaker init safe skip: $e");
              }
            });

            update();
          },
          onFirstLocalAudioFramePublished: (connection, elapsed) {
            final info = 'LOG::firstLocalAudio: $elapsed';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user.isAudioEnabled = isMicEnabled;
                update();
              }
            }
          },
          onFirstLocalVideoFrame: (connection, width, height, elapsed) {
            debugPrint('LOG::firstLocalVideo');
            for (AgoraUser user in users) {
              if (user.uid == currentUid) {
                user.isVideoEnabled = isVideoEnabled;
                update();
              }
            }
          },
          onLeaveChannel: (connection, stats) {
            debugPrint('LOG::onLeaveChannel');
            _stopCallDurationTimer(reset: true);
            users.clear();
            update();
          },
          onUserJoined: (connection, remoteUid, elapsed) {
            if (users.any((u) => u.uid == remoteUid)) {
              return;
            }
            timer?.cancel();
            Utility.audioPlayer.stop();

            String resolvedName = "User";
            String resolvedBanner = "";

            // 1. Direct Lookup in callMembersMap
            String? foundUserId;
            callMembersMap.forEach((key, value) {
              if (value['uid'] == remoteUid.toString()) {
                foundUserId = key;
                resolvedName = value['name'] ?? "User";
                resolvedBanner = value['image'] ?? "";
              }
            });

            // 2. If not matched by exact UID, match first unclaimed remote member from callMembersMap
            if (foundUserId == null || resolvedName == "User") {
              final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
              for (var entry in callMembersMap.entries) {
                if (entry.key != currentUserId) {
                  final alreadyUsed = users.any((u) => u.name == entry.value['name'] && (entry.value['name'] != null && entry.value['name'] != "User"));
                  if (!alreadyUsed) {
                    foundUserId = entry.key;
                    final candName = (entry.value['name']?.isNotEmpty == true && entry.value['name'] != "User")
                        ? entry.value['name']!
                        : (entry.value['mobile']?.isNotEmpty == true ? entry.value['mobile']! : "User");
                    if (candName != "User") {
                      resolvedName = candName;
                      resolvedBanner = entry.value['image'] ?? "";
                      entry.value['uid'] = remoteUid.toString();
                      break;
                    }
                  }
                }
              }
            }

            // 3. If still User, check pendingInvitees
            if (resolvedName == "User" && pendingInvitees.isNotEmpty) {
              for (var p in pendingInvitees) {
                if (!users.any((u) => u.name == p.name)) {
                  resolvedName = p.name;
                  foundUserId = p.userId;
                  break;
                }
              }
            }

            if (foundUserId != null) {
              print("[ANTIGRAVITY_DEBUG] Resolved remote user via UID map: $resolvedName ($remoteUid)");
              _removePendingInviteeByUserId(foundUserId);
              if (foundUserId!.length >= 12 && (resolvedName == "User" || resolvedBanner.isEmpty)) {
                Utility.fetchAndCacheUserProfile(foundUserId!);
              }
            } else {
              print("[ANTIGRAVITY_DEBUG] Could not resolve remote user via UID map for $remoteUid. Using fallback.");
              final existingRemoteCount = users.where((u) => u.uid != currentUid).length;
              if (existingRemoteCount == 0) {
                final res = Utility.resolveUserDisplay(
                  fullname: userName,
                  profileimage: userImage,
                );
                resolvedName = res['name'] ?? (userName.trim().isEmpty ? "User" : userName.trim());
                resolvedBanner = res['image'] ?? (userImage ?? "");
              }
            }

            if (resolvedName == "User" || resolvedName.isEmpty) {
              final res = Utility.resolveUserDisplay(
                userId: foundUserId,
                profileimage: resolvedBanner,
              );
              if (res['name'] != null && res['name']!.isNotEmpty && res['name'] != "User") {
                resolvedName = res['name']!;
              }
              if (resolvedBanner.isEmpty && res['image'] != null && res['image']!.isNotEmpty) {
                resolvedBanner = res['image']!;
              }
            }

            users.add(
              AgoraUser(
                uid: remoteUid,
                name: resolvedName,
                bannerImg: resolvedBanner,
                isAudioEnabled: true,
              ),
            );

            _syncUsersWithCallMembers();

            if (remoteParticipantsCount > 0) {
              _startCallDurationTimer();
            }
            update();
          },
          onUserOffline: (connection, remoteUid, reason) {
            final info = 'LOG::userOffline: $remoteUid';
            debugPrint(info);
            AgoraUser? userToRemove;
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                userToRemove = user;
              }
            }
            users.remove(userToRemove);
            if (remoteParticipantsCount == 0) {
              _stopCallDurationTimer();
              _autoLeaveIfAlone();
            }
            update();
          },
          onFirstRemoteAudioFrame: (connection, remoteUid, elapsed) {
            final info = 'LOG::firstRemoteAudio: $remoteUid';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isAudioEnabled = true;
                update();
              }
            }
          },
          onRemoteAudioStateChanged:
              (connection, remoteUid, state, reason, elapsed) {
            final info =
                'LOG::remoteAudioStateChanged: $remoteUid $state $reason';
            debugPrint(info);
            for (AgoraUser user in users) {
              if (user.uid == remoteUid) {
                user.isAudioEnabled =
                    state != RemoteAudioState.remoteAudioStateStopped;
                update();
              }
            }
          },
        ),
      );

  Future<void> onCallEnd(
      BuildContext context, AudioCallController controller) async {
    if (_isEnding) return;
    _isEnding = true;

    final wasConnected = isCallConnected || remoteParticipantsCount > 0 || users.where((u) => u.uid != currentUid).isNotEmpty;

    Utility.audioPlayer.stop();
    timer?.cancel();
    _stopCallDurationTimer();

    final currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
    final isHost = isSelfCall ?? false;

    if (callId.isNotEmpty) {
      if (!wasConnected) {
        if (isHost) {
          endReasonText = "Call cancelled";
          final payload = {
            "callId": callId,
            "fromUserId": currentUserId,
            "reason": "cancelled",
          };
          SocketConnection.socket?.emit("call-cancelled", payload);
        } else {
          endReasonText = "Call declined";
          final payload = {
            "callId": callId,
            "fromUserId": currentUserId,
            "reason": "rejected",
          };
          SocketConnection.socket?.emit("call-rejected", payload);
        }
      } else {
        endReasonText = "Left call";
        final payload = {
          "callId": callId,
          "fromUserId": currentUserId,
          "leftUserId": currentUserId,
          "reason": "left",
        };
        SocketConnection.socket?.emit("user-left", payload);
      }
    }

    CallingKitService.endAllCalls();
    _safeNavigateBack();
    _endCallGlobally();
  }

  void onToggleAudio() {
    isMicEnabled = !isMicEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid) {
        user.isAudioEnabled = isMicEnabled;
      }
    }
    agoraEngine?.muteLocalAudioStream(!isMicEnabled);
    update();
  }

  void switchSpeakerphone() async {
    try {
      isSpeaker = !isSpeaker;
      await agoraEngine?.setEnableSpeakerphone(isSpeaker);
      update();
    } catch (err) {
      debugPrint("enableSpeakerphone error: $err");
    }
  }

  void onToggleCamera() {
    isVideoEnabled = !isVideoEnabled;
    for (AgoraUser user in users) {
      if (user.uid == currentUid) {
        user.isVideoEnabled = isVideoEnabled;
        update();
      }
    }
    update();

    agoraEngine?.muteLocalVideoStream(!isVideoEnabled);
  }

  void onSwitchCamera() => agoraEngine?.switchCamera();

  List<int> createLayout(int n) {
    int rows = (sqrt(n).ceil());
    int columns = (n / rows).ceil();

    List<int> layout = List<int>.filled(rows, columns);
    int remainingScreens = rows * columns - n;

    for (int i = 0; i < remainingScreens; i++) {
      layout[layout.length - 1 - i] -= 1;
    }

    return layout;
  }

  Future<void> postChatMissedCall(callId) async {
    var response = await audioCallPresenter.postChatMissedCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Get.back();
    }
    update();
  }

  Future<void> postChatLeaveCall(callId) async {
    var response = await audioCallPresenter.postChatLeaveCall(
      callid: callId,
      isLoading: false,
    );
    if (response!.statusCode == 200) {
      Utility.audioPlayer.pause();
      Get.back();
    }
    update();
  }

  Future<void> postChatJoinCall(callId) async {
    Utility.audioPlayer.pause();
    update();
    var response = await audioCallPresenter.postChatJoinCall(
      callid: callId,
      isLoading: true,
    );
    if (response!.statusCode == 200) {}
    update();
  }

  final ApiWrapper api;
  bool isAddingParticipant = false;

  Future<void> addParticipant(String userId, String displayName) async {
    if (isAddingParticipant) return;
    isAddingParticipant = true;

    try {
      final body = {
        "callid": callId,
        "members": [userId],
      };

      final response = await api.makeRequest(
        "call/addmembers",
        Request.post,
        body,
        true,
        api.defaultHeaders,
      );

      if (response.statusCode == 200 && !response.hasError) {
        final json = jsonDecode(response.data);

        // 🔥 CACHE ALL MEMBERS FROM BACKEND
        cacheCallMembers(json["Data"]["members"]);
        _addPendingInvitee(userId, displayName);

        Get.back();

        Utility.showMessage(
          "Participant added successfully",
          MessageType.success,
          () {},
          "OK",
        );
      }
    } finally {
      isAddingParticipant = false;
    }
  }

  void showAddParticipantSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (_, controller) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  "Add Participant",
                  style: Styles.black70018,
                ),
              ),
              Expanded(
                child: GetBuilder<ChatController>(
                  builder: (chatController) {
                    if (chatController.allFriends.isEmpty) {
                      chatController.myFriendsList(1);
                    }
                    return ListView.builder(
                      controller: controller,
                      itemCount: chatController.allFriends.length,
                      itemBuilder: (context, index) {
                        final friend = chatController.allFriends[index];
                        final resolved = Utility.resolveUserDisplay(
                          userId: friend.userid,
                          fullname: friend.fullname,
                          nickname: friend.nickname,
                          mobile: friend.mobile,
                          profileimage: friend.profileimage,
                        );
                        final displayName = resolved['name'] ?? "User";
                        final displayImage = resolved['image'] ?? "";
                        final subtitleText = (friend.nickname?.trim().isNotEmpty == true && friend.nickname != displayName)
                            ? friend.nickname!.trim()
                            : (friend.mobile?.trim().isNotEmpty == true ? friend.mobile!.trim() : "");

                        return ListTile(
                          leading: SizedBox(
                            height: 44,
                            width: 44,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(22),
                              child: displayImage.isNotEmpty
                                  ? CachedNetworkImage(
                                      height: 44,
                                      width: 44,
                                      imageUrl: displayImage.startsWith("http")
                                          ? displayImage
                                          : ApiWrapper.imageUrl + displayImage,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) => Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      AssetConstants.usera,
                                      fit: BoxFit.cover,
                                    ),
                            ),
                          ),
                          title: Text(displayName, style: Styles.black70014),
                          subtitle: subtitleText.isNotEmpty
                              ? Text(subtitleText, style: Styles.greyColor888840012)
                              : null,
                          trailing: IconButton(
                            icon: const Icon(Icons.person_add),
                            onPressed: () => addParticipant(
                              friend.userid ?? "",
                              displayName,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> postKickMember(String memberId) async {
    var response = await audioCallPresenter.postKickMember(
      callid: callId,
      memberid: memberId,
      isLoading: true,
    );
    if (response != null && response.statusCode == 200) {
      print("Successfully kicked member $memberId");
    } else {
      Utility.showMessage("Failed to remove participant", MessageType.error, () => null, '');
    }
  }
}

class PendingInvitee {
  final String userId;
  final String name;
  final String status;
  final int? uid;

  PendingInvitee({
    required this.userId,
    required this.name,
    required this.status,
    this.uid,
  });
}
