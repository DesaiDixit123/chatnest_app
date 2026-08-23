import 'dart:convert';

import 'package:chatnest/domain/models/group_user_list_model.dart';
import 'package:chatnest/domain/models/models.dart';

GetOneGroupModel getOneGroupModelFromJson(String str) =>
    GetOneGroupModel.fromJson(json.decode(str));

String getOneGroupModelToJson(GetOneGroupModel data) =>
    json.encode(data.toJson());

class GetOneGroupModel {
  String message;
  GetOneGroupData data;
  int status;
  bool isSuccess;

  GetOneGroupModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetOneGroupModel.fromJson(Map<String, dynamic> json) =>
      GetOneGroupModel(
        message: json["Message"],
        data: GetOneGroupData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GetOneGroupData {
  String? id;
  bool? status;
  String? profileimage;
  String? name;
  String? description;
  List<GroupChatMember>? members;
  GetOneGroupLastchatmessage? lastchatmessage;
  String? createdBy;
  String? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  List<ChatListsMediaData>? latestmedias;

  GetOneGroupData({
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
    this.latestmedias,
  });

  factory GetOneGroupData.fromJson(Map<String, dynamic> json) =>
      GetOneGroupData(
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
            : GetOneGroupLastchatmessage.fromJson(json["lastchatmessage"]),
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"],
        latestmedias: json["latestmedias"] == null
            ? []
            : List<ChatListsMediaData>.from(json["latestmedias"]!
                .map((x) => ChatListsMediaData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "profileimage": profileimage,
        "name": name,
        "description": description,
        "members": List<dynamic>.from(members!.map((x) => x.toJson())),
        "lastchatmessage": lastchatmessage?.toJson(),
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "latestmedias": latestmedias == null
            ? []
            : List<dynamic>.from(latestmedias!.map((x) => x.toJson())),
      };
}

class GetOneGroupLastchatmessage {
  String? message;
  int? timestamp;

  GetOneGroupLastchatmessage({
    this.message,
    this.timestamp,
  });

  factory GetOneGroupLastchatmessage.fromJson(Map<String, dynamic> json) =>
      GetOneGroupLastchatmessage(
        message: json["message"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "timestamp": timestamp,
      };
}
