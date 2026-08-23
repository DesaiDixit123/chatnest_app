import 'package:get/get.dart';
import 'package:chatnest/data/repositories/status_repository.dart';
import 'package:chatnest/domain/models/status_model.dart';

class StatusController extends GetxController {
  final StatusRepository repo;
  StatusController(this.repo);

  List<StatusModel> myStatuses = [];
  List<Map<String, dynamic>> friendsStatuses = [];

  bool isLoading = false;
  bool isCommentLoading = false;
  bool isStatusActionLoading = false;
  bool isUploadingStatus = false;

  @override
  void onInit() {
    super.onInit();
    loadAll();
    super.onReady();
  }

  /// 🔄 load my + friends status
  Future<void> loadAll() async {
    try {
      isLoading = true;
      update();

      myStatuses = await repo.getMyStatus();
      friendsStatuses = await repo.getFriendsStatus();
    } catch (e) {
    } finally {
      isLoading = false;
      update();
    }
  }

  /// 📝 TEXT STATUS
  Future<bool> uploadTextStatus({
    required String text,
    required String color,
    int duration = 24,
  }) async {
    try {
      if (text.trim().isEmpty) {
        throw "Status text cannot be empty";
      }

      isUploadingStatus = true;
      update();

      final success = await repo.saveStatus(
        contentType: "text",
        mediaPath: null,
        text: text,
        color: color,
        duration: duration,
      );

      if (!success) {
        throw "Failed to upload text status";
      }

      await loadAll();
      return true;
    } catch (e) {
      return false;
    } finally {
      isUploadingStatus = false;
      update();
    }
  }

  /// 🖼 IMAGE STATUS
  Future<bool> uploadImageStatus({
    required String imagePath,
    required String caption,
    int duration = 24,
  }) async {
    try {
      isUploadingStatus = true;
      update();

      final mediaPath = await repo.uploadStatusMedia(
        filePath: imagePath,
        isVideo: false,
      );

      if (mediaPath == null) {
        throw "Image upload failed";
      }

      final success = await repo.saveStatus(
        contentType: "image",
        mediaPath: mediaPath,
        text: caption,
        duration: duration,
      );

      print("Status Saved $success");
      if (!success) {
        throw "Failed to save image status";
      }

      await loadAll();
      return true;
    } catch (e) {
      return false;
    } finally {
      isUploadingStatus = false;
      update();
    }
  }

  /// 🎥 VIDEO STATUS
  Future<bool> uploadVideoStatus({
    required String videoPath,
    required String caption,
    int duration = 24,
  }) async {
    try {
      isUploadingStatus = true;
      update();

      final mediaPath = await repo.uploadStatusMedia(
        filePath: videoPath,
        isVideo: true,
      );

      if (mediaPath == null) {
        throw "Video upload failed";
      }

      final success = await repo.saveStatus(
        contentType: "video",
        mediaPath: mediaPath,
        text: caption,
        duration: duration,
      );

      if (!success) {
        throw "Failed to save video status";
      }

      await loadAll();
      return true;
    } catch (e) {
      return false;
    } finally {
      isUploadingStatus = false;
      update();
    }
  }

  /// 💬 REPLY TO STATUS
  Future<bool> replyToStatus({
    required String statusId,
    required String message,
  }) async {
    try {
      if (message.trim().isEmpty) {
        throw "Comment cannot be empty";
      }

      isCommentLoading = true;
      update();

      final result = await repo.replyToStatus(
        statusId: statusId,
        message: message,
      );

      if (result == null) {
        throw "Failed to post comment";
      }

      return true;
    } catch (e) {
      return false;
    } finally {
      isCommentLoading = false;
      update();
    }
  }

  /// ✏️ update own status text/caption/color
  Future<StatusModel?> updateStatus({
    required String statusId,
    String? text,
    String? color,
    String? mediaPath,
  }) async {
    try {
      isStatusActionLoading = true;
      update();

      final updated = await repo.updateStatus(
        statusId: statusId,
        text: text,
        color: color,
        mediaPath: mediaPath,
      );

      if (updated == null) return null;

      final myIndex = myStatuses.indexWhere((e) => e.id == statusId);
      if (myIndex != -1) {
        myStatuses[myIndex] = updated;
      }

      return updated;
    } catch (e) {
      return null;
    } finally {
      isStatusActionLoading = false;
      update();
    }
  }

  /// 🗑️ delete own status
  Future<bool> deleteStatus({
    required String statusId,
  }) async {
    try {
      isStatusActionLoading = true;
      update();

      final success = await repo.deleteStatus(statusId: statusId);
      if (!success) return false;

      myStatuses.removeWhere((s) => s.id == statusId);
      return true;
    } catch (e) {
      return false;
    } finally {
      isStatusActionLoading = false;
      update();
    }
  }

  /// 👁️ owner-only details for viewers/reactions/comments
  Future<List<Map<String, dynamic>>> getStatusInteractions({
    required String statusId,
  }) async {
    final data = await repo.getOneStatus(statusId: statusId);
    if (data == null) return [];

    final interactions = data['userInteractions'];
    if (interactions is! List) return [];
    return interactions
        .whereType<Map>()
        .map((e) => Map<String, dynamic>.from(e))
        .toList();
  }

  /// 👁️ mark status as viewed
  Future<bool> markStatusViewed({
    required String statusId,
  }) async {
    try {
      return await repo.markStatusAsViewed(statusId: statusId);
    } catch (e) {
      return false;
    }
  }
}
