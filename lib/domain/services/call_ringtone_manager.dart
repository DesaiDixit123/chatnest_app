import 'package:chatnest/app/utils/utility.dart';
import 'package:chatnest/domain/services/CallingKitService.dart';

/// Single authoritative manager responsible for call ringtone lifecycle and session deduplication.
/// Guarantees: ONE incoming call session = EXACTLY ONE ringtone instance.
class CallRingtoneManager {
  static final CallRingtoneManager _instance = CallRingtoneManager._internal();
  factory CallRingtoneManager() => _instance;
  CallRingtoneManager._internal();

  static String? _activeRingtoneCallId;
  static String? _activeRingtoneChannel;
  static String? _activeSource;
  static final Set<String> _terminalCallIds = {};
  static final Set<String> _processedCallIds = {};

  static String? get activeCallId => _activeRingtoneCallId;
  static bool get isRinging => _activeRingtoneCallId != null;

  /// Check if a ringtone start request should proceed or be suppressed as a duplicate
  static bool shouldStartRingtone(
    String callId, {
    String? channelKey,
    required String source,
  }) {
    final normalizedCallId = callId.trim();
    final normalizedChannel = (channelKey ?? "").trim();

    print("\n[RING][REQUEST]");
    print("callId=$normalizedCallId source=$source");

    if (normalizedCallId.isEmpty && normalizedChannel.isEmpty) {
      print("[RING][DUPLICATE_IGNORED]");
      print("callId=empty source=$source reason=empty_id\n");
      return false;
    }

    if (_terminalCallIds.contains(normalizedCallId) ||
        (normalizedChannel.isNotEmpty && _terminalCallIds.contains(normalizedChannel))) {
      print("[CALL][STALE_EVENT_IGNORED] callId=$normalizedCallId (terminal session)");
      print("[RING][DUPLICATE_IGNORED]");
      print("callId=$normalizedCallId source=$source reason=terminal_session\n");
      return false;
    }

    if ((_activeRingtoneCallId != null && _activeRingtoneCallId == normalizedCallId) ||
        (normalizedChannel.isNotEmpty && _activeRingtoneChannel == normalizedChannel) ||
        _processedCallIds.contains(normalizedCallId) ||
        (normalizedChannel.isNotEmpty && _processedCallIds.contains(normalizedChannel))) {
      print("[RING][DUPLICATE_IGNORED]");
      print("callId=$normalizedCallId source=$source activeCallId=$_activeRingtoneCallId activeSource=$_activeSource\n");
      return false;
    }

    return true;
  }

  /// Authoritatively mark the ringtone as active for this callId
  static void markRingtoneStarted(
    String callId, {
    String? channelKey,
    required String source,
  }) {
    final normalizedCallId = callId.trim();
    final normalizedChannel = (channelKey ?? "").trim();

    _activeRingtoneCallId = normalizedCallId;
    _activeRingtoneChannel = normalizedChannel.isNotEmpty ? normalizedChannel : normalizedCallId;
    _activeSource = source;

    _processedCallIds.add(normalizedCallId);
    if (normalizedChannel.isNotEmpty) {
      _processedCallIds.add(normalizedChannel);
    }

    print("\n[CALL][INCOMING]");
    print("callId=$normalizedCallId");
    print("[RING][START]");
    print("callId=$normalizedCallId source=$source\n");

    // Auto-prune duplicate cache after timeout to prevent memory leak
    Future.delayed(const Duration(seconds: 35), () {
      _processedCallIds.remove(normalizedCallId);
      if (normalizedChannel.isNotEmpty) {
        _processedCallIds.remove(normalizedChannel);
      }
      if (_activeRingtoneCallId == normalizedCallId) {
        _activeRingtoneCallId = null;
        _activeRingtoneChannel = null;
        _activeSource = null;
      }
    });
  }

  /// Mark call session as terminal (answered, declined, cancelled, ended, missed)
  static void markCallTerminal(String callId) {
    final normalized = callId.trim();
    if (normalized.isNotEmpty) {
      _terminalCallIds.add(normalized);
      if (_terminalCallIds.length > 50) {
        _terminalCallIds.remove(_terminalCallIds.first);
      }
    }
  }

  /// Stop ringtone and release all resources for this call session
  static Future<void> stopRingtone({String? callId, String reason = "normal"}) async {
    final targetCallId = (callId != null && callId.trim().isNotEmpty)
        ? callId.trim()
        : (_activeRingtoneCallId ?? "unknown");

    if (targetCallId != "unknown") {
      markCallTerminal(targetCallId);
    }

    print("\n[RING][STOP]");
    print("callId=$targetCallId reason=$reason");

    _activeRingtoneCallId = null;
    _activeRingtoneChannel = null;
    _activeSource = null;

    try {
      Utility.audioPlayer.stop();
    } catch (_) {}

    try {
      await CallingKitService.endAllCalls();
    } catch (_) {}

    print("[RING][CLEANUP]");
    print("callId=$targetCallId\n");
  }
}
