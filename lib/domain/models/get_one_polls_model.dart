import 'dart:convert';

import 'package:chatnest/domain/models/chat_lists_model.dart';

GetOnePollsModel getOnePollsModelFromJson(String str) =>
    GetOnePollsModel.fromJson(json.decode(str));

class GetOnePollsModel {
  String message;
  GetOnePollsData data;
  int status;
  bool isSuccess;

  GetOnePollsModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetOnePollsModel.fromJson(Map<String, dynamic> json) =>
      GetOnePollsModel(
        message: json["Message"],
        data: GetOnePollsData.fromJson(json["Data"]),
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

class GetOnePollsData {
  String? id;
  String? polltitle;
  bool? status;
  List<ChatListsOption>? options;
  bool? allowmultipleans;
  ChatListsFrom? createdBy;
  ChatListsFrom? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;

  GetOnePollsData({
    this.id,
    this.polltitle,
    this.status,
    this.options,
    this.allowmultipleans,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GetOnePollsData.fromJson(Map<String, dynamic> json) =>
      GetOnePollsData(
        id: json["_id"] ?? "",
        polltitle: json["polltitle"] ?? "",
        status: json["status"] ?? false,
        options: json["options"] == null
            ? []
            : List<ChatListsOption>.from(
                json["options"].map((x) => ChatListsOption.fromJson(x))),
        allowmultipleans: json["allowmultipleans"] ?? false,
        createdBy: json["createdBy"] == null
            ? null
            : ChatListsFrom.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : ChatListsFrom.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "polltitle": polltitle,
        "status": status,
        "options": List<dynamic>.from(options!.map((x) => x.toJson())),
        "allowmultipleans": allowmultipleans,
        "createdBy": createdBy!.toJson(),
        "updatedBy": updatedBy!.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
