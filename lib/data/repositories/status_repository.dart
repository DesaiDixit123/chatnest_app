import 'dart:convert';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/entities/enums.dart';
import 'package:chatnest/domain/models/response_model.dart';
import 'package:chatnest/domain/models/status_model.dart';
import 'package:http_parser/http_parser.dart';

class StatusRepository {
  final ApiWrapper api;
  StatusRepository(this.api);

  /// 📞 add member to ongoing call (1-to-1 → conference)
  Future<ResponseModel?> addMembersToCall({
    required String callId,
    required String userId,
    bool isLoading = true,
  }) async {
    final body = {
      "callid": callId,
      "userid": userId,
    };

    final response = await api.makeRequest(
      "call/addmembers",
      Request.post,
      body,
      isLoading,
      api.defaultHeaders,
    );

    return response;
  }

  /// 🔼 upload image / video
  Future<String?> uploadStatusMedia({
    required String filePath,
    required bool isVideo,
  }) async {
    final response = await api.makeRequest(
      isVideo ? "status/video" : "status/photo",
      Request.awsUpload,
      filePath,
      true,
      api.defaultHeaders,
      mediaType:
          isVideo ? MediaType("video", "webm") : MediaType("image", "jpeg"),
    );

    if (response.hasError) return null;

    final json = jsonDecode(response.data);
    final fullUrl = json['Data']['url'];

    return fullUrl.replaceFirst(ApiWrapper.imageUrl, "");
  }

  /// 💾 save status
  Future<bool> saveStatus({
    required String contentType,
    required String? mediaPath,
    required String text,
    String? color,
    String visibility = "friendsonly",
    int duration = 24,
  }) async {
    final body = {
      "contenttype": contentType,
      "content": {
        if (mediaPath != null) "media": mediaPath,
        "text": text,
        if (color != null) "color": color,
      },
      "visibility": visibility,
      "duration": duration,
    };

    final response = await api.makeRequest(
      "status/save",
      Request.post,
      body,
      true,
      api.defaultHeaders,
    );

    return response.statusCode == 200;
  }

  /// 📥 my status
  Future<List<StatusModel>> getMyStatus() async {
    final response = await api.makeRequest(
      "status/my",
      Request.get,
      null,
      false,
      api.defaultHeaders,
    );

    if (response.hasError) return [];

    final json = jsonDecode(response.data);
    final data = json['Data'];
    final List list = data is Map<String, dynamic>
        ? (data['statuses'] as List? ?? [])
        : (data is List ? data : []);

    return list.map((e) => StatusModel.fromJson(e)).toList();
  }

  /// 👥 friends status (NEW)
  Future<List<Map<String, dynamic>>> getFriendsStatus() async {
    final response = await api.makeRequest(
      "status/friends",
      Request.get,
      null,
      false,
      api.defaultHeaders,
    );

    if (response.hasError) return [];

    final json = jsonDecode(response.data);
    final data = json['Data'];
    if (data is List) {
      return List<Map<String, dynamic>>.from(data);
    }
    return [];
  }

  /// 💬 reply to status / post comment
  Future<Map<String, dynamic>?> replyToStatus({
    required String statusId,
    required String message,
  }) async {
    final body = {
      "statusid": statusId,
      "message": message,
    };

    final response = await api.makeRequest(
      "status/comment",
      Request.post,
      body,
      true,
      api.defaultHeaders,
    );

    if (response.hasError) return null;

    final json = jsonDecode(response.data);
    return json['Data'] as Map<String, dynamic>;
  }

  /// 🗑️ delete status
  Future<bool> deleteStatus({
    required String statusId,
  }) async {
    final response = await api.makeRequest(
      "status/delete",
      Request.post,
      {"statusid": statusId},
      true,
      api.defaultHeaders,
    );

    return !response.hasError && response.statusCode == 200;
  }

  /// ✏️ update status text/caption/color/media
  Future<StatusModel?> updateStatus({
    required String statusId,
    String? text,
    String? color,
    String? mediaPath,
  }) async {
    final content = <String, dynamic>{};
    if (text != null) content['text'] = text;
    if (color != null) content['color'] = color;
    if (mediaPath != null) content['media'] = mediaPath;

    if (content.isEmpty) return null;

    final response = await api.makeRequest(
      "status/update",
      Request.post,
      {
        "statusid": statusId,
        "content": content,
      },
      true,
      api.defaultHeaders,
    );

    if (response.hasError) return null;
    final json = jsonDecode(response.data);
    final data = json['Data'];
    if (data is! Map<String, dynamic>) return null;
    return StatusModel.fromJson(data);
  }

  /// 👁️ get one status details (owner gets userInteractions)
  Future<Map<String, dynamic>?> getOneStatus({
    required String statusId,
  }) async {
    final response = await api.makeRequest(
      "status/getone",
      Request.post,
      {"statusid": statusId},
      false,
      api.defaultHeaders,
    );

    if (response.hasError) return null;
    final json = jsonDecode(response.data);
    final data = json['Data'];
    if (data is! Map<String, dynamic>) return null;
    return data;
  }

  /// 👁️ mark status as viewed
  Future<bool> markStatusAsViewed({
    required String statusId,
  }) async {
    final response = await api.makeRequest(
      "status/getone",
      Request.post,
      {"statusid": statusId},
      false,
      api.defaultHeaders,
    );

    return !response.hasError && response.statusCode == 200;
  }
}
