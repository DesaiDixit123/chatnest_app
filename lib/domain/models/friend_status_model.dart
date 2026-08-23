import 'package:chatnest/domain/models/status_model.dart';

class FriendStatusModel {
  final String userId;
  final String name;
  final String profilePic;
  final DateTime latestTimestamp;
  final List<StatusModel> statuses;

  FriendStatusModel({
    required this.userId,
    required this.name,
    required this.profilePic,
    required this.latestTimestamp,
    required this.statuses,
  });

  factory FriendStatusModel.fromJson(Map<String, dynamic> json) {
    return FriendStatusModel(
      userId: json['userid'],
      name: json['name'],
      profilePic: json['profilepic'] ?? "",
      latestTimestamp: DateTime.parse(json['latestTimestamp']),
      statuses: (json['statuses'] as List)
          .map((e) => StatusModel.fromJson(e))
          .toList(),
    );
  }
}
