import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GroupFriendListModel groupFriendListModelFromJson(String str) =>
    GroupFriendListModel.fromJson(json.decode(str));

class GroupFriendListModel {
  String message;
  List<GroupFriendData> data;
  int status;
  bool isSuccess;

  GroupFriendListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GroupFriendListModel.fromJson(Map<String, dynamic> json) =>
      GroupFriendListModel(
        message: json["Message"],
        data: List<GroupFriendData>.from(
            json["Data"].map((x) => GroupFriendData.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GroupFriendData {
  String? id;
  bool? status;
  String? profileimage;
  String? name;
  String? description;
  List<GroupChatMember>? members;
  GroupLastchatmessage? lastchatmessage;
  GroupChatCreatedBy? createdBy;
  GroupChatCreatedBy? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? pinned;
  int unreadmessageCount;
  bool isUserSelect;
  List<Archivefor>? archivefor;

  GroupFriendData({
    this.id,
    this.status,
    this.profileimage,
    this.name,
    this.description,
    this.members,
    this.lastchatmessage,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.pinned,
    this.unreadmessageCount = 0,
    this.isUserSelect = false,
    this.archivefor,
  });

  factory GroupFriendData.fromJson(Map<String, dynamic> json) =>
      GroupFriendData(
        id: json["_id"] ?? "",
        status: json["status"] ?? false,
        profileimage: json["profileimage"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        members: json["members"] == null
            ? []
            : List<GroupChatMember>.from(
                json["members"].map((x) => GroupChatMember.fromJson(x))),
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : GroupLastchatmessage.fromJson(json["lastchatmessage"]),
        createdBy: json["createdBy"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"] ?? 0,
        pinned: json["pinned"] ?? false,
        unreadmessageCount: json["unreadmessage_count"] ?? 0,
        archivefor: json["archivefor"] == null
            ? []
            : List<Archivefor>.from(
                json["archivefor"]!.map((x) => Archivefor.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "profileimage": profileimage,
        "name": name,
        "description": description,
        "members": List<dynamic>.from(members!.map((x) => x.toJson())),
        "lastchatmessage": lastchatmessage!.toJson(),
        "createdBy": createdBy!.toJson(),
        "updatedBy": updatedBy!.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "pinned": pinned,
        "unreadmessage_count": unreadmessageCount,
        "archivefor": archivefor == null
            ? []
            : List<dynamic>.from(archivefor!.map((x) => x.toJson())),
      };
}