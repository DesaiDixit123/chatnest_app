import 'package:hive/hive.dart';
import '../api/user_safety_api.dart';

class UserSafetyService {
  final Box _box;
  final UserSafetyApi _api = UserSafetyApi();

  UserSafetyService(this._box);

  // EULA handling
  Future<void> acceptEula() async {
    await _box.put('eulaAccepted', true);
  }

  bool hasAcceptedEula() {
    return _box.get('eulaAccepted', defaultValue: false) as bool;
  }

  /// Clears the stored EULA acceptance flag – useful for testing after reinstall.
  Future<void> resetEula() async {
    await _box.delete('eulaAccepted');
  }

  // Report objectionable content
  Future<void> reportContent({required String contentId, required String reason}) async {
    try {
      await _api.reportContent(contentId: contentId, reason: reason);
    } catch (e) {
      rethrow;
    }
  }

  // Block a user
  Future<void> blockUser({required String userId}) async {
    try {
      await _api.blockUser(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  // Unblock a user
  Future<void> unblockUser({required String userId}) async {
    try {
      await _api.unblockUser(userId: userId);
    } catch (e) {
      rethrow;
    }
  }

  // Check block status
  Future<bool> checkBlockStatus({required String userId}) async {
    try {
      return await _api.checkBlockStatus(userId: userId);
    } catch (e) {
      return false;
    }
  }

  // Get EULA terms from API
  Future<String> getTerms() async {
    try {
      return await _api.getTerms();
    } catch (e) {
      rethrow;
    }
  }
}
