class StatusModel {
  final String id;
  final String contentType;
  final String text;
  final String media;
  final String color;
  final List<StatusViewer> viewers;
  final String userId;
  final DateTime? createdAt;

  StatusModel({
    required this.id,
    required this.contentType,
    required this.text,
    required this.media,
    required this.color,
    this.viewers = const [],
    this.userId = "",
    this.createdAt,
  });

  factory StatusModel.fromJson(Map<String, dynamic> json) {
    final userid = json["userid"];
    final userIdValue = userid is Map<String, dynamic>
        ? (userid["_id"] ?? "")
        : (userid ?? "");
    final interactions = json["userInteractions"];
    final rawViewers = json["viewers"];

    return StatusModel(
      id: json["_id"] ?? "", // ✅ THIS IS THE KEY FIX
      contentType: json["contenttype"] ?? "",
      text: json["content"]?["text"] ?? "",
      media: json["content"]?["media"] ?? "",
      color: json["content"]?["color"] ?? "",
      viewers: interactions is List
          ? interactions
              .map((v) => StatusViewer.fromJson(v))
              .toList()
          : rawViewers is List
              ? rawViewers.map((v) => StatusViewer.fromJson(v)).toList()
          : [],
      userId: userIdValue.toString(),
      createdAt: json["createdAt"] != null
          ? DateTime.parse(json["createdAt"])
          : null,
    );
  }
}

class StatusViewer {
  final String userId;
  final String userName;
  final String? profileImage;
  final DateTime? viewedAt;

  StatusViewer({
    required this.userId,
    required this.userName,
    this.profileImage,
    this.viewedAt,
  });

  factory StatusViewer.fromJson(Map<String, dynamic> json) {
    final user = json["user"];
    final userMap = user is Map<String, dynamic> ? user : null;
    final userIdValue =
        userMap?["_id"] ?? json["userid"] ?? "";
    final nameValue =
        userMap?["fullname"] ?? userMap?["nickname"] ?? json["username"] ?? "User";
    final profileValue =
        userMap?["profileimage"] ?? json["profileimage"];

    DateTime? viewedAtValue;
    final viewedTimestamp = json["viewedtimestamp"];
    final viewedAtString = json["viewedat"];

    if (viewedTimestamp is int) {
      viewedAtValue = DateTime.fromMillisecondsSinceEpoch(viewedTimestamp);
    } else if (viewedTimestamp is String) {
      final intValue = int.tryParse(viewedTimestamp);
      viewedAtValue = intValue != null
          ? DateTime.fromMillisecondsSinceEpoch(intValue)
          : DateTime.tryParse(viewedTimestamp);
    } else if (viewedAtString is String) {
      viewedAtValue = DateTime.tryParse(viewedAtString);
    }

    return StatusViewer(
      userId: userIdValue.toString(),
      userName: nameValue.toString(),
      profileImage: profileValue?.toString(),
      viewedAt: viewedAtValue,
    );
  }
}

class StatusContent {
  final String? media;
  final String? text;
  final String? color;

  StatusContent({this.media, this.text, this.color});

  factory StatusContent.fromJson(Map<String, dynamic> json) {
    return StatusContent(
      media: json['media'],
      text: json['text'],
      color: json['color'],
    );
  }
}
