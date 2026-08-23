import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == "true" || normalized == "yes" || normalized == "1";
  }
  return false;
}

CallHistoryByUserModel callHistoryByUserModelFromJson(String str) =>
    CallHistoryByUserModel.fromJson(json.decode(str));

class CallHistoryByUserModel {
  String? message;
  List<CallHistoryByUserData>? data;
  int? status;
  bool? isSuccess;

  CallHistoryByUserModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory CallHistoryByUserModel.fromJson(Map<String, dynamic> json) =>
      CallHistoryByUserModel(
        message: json["Message"],
        data: json["Data"] is List
            ? List<CallHistoryByUserData>.from(
                (json["Data"] as List).map(
                  (x) => CallHistoryByUserData.fromJson(
                    (x as Map).cast<String, dynamic>(),
                  ),
                ),
              )
            : [],
        status: json["Status"],
        isSuccess: _parseBool(json["IsSuccess"]),
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class CallHistoryByUserData {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? touser;
  Togroup? togroup;
  bool? isvideocall;
  bool? isaudiocall;
  bool? isgroupcall;
  String? status;
  ChatListsFrom? initiatedby;
  List<CallHistoryMember>? members;
  CallHistoryAgorameta? agorameta;
  int? timestamp;
  String? callingfrom;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  CallHistoryByUserData({
    this.id,
    this.from,
    this.touser,
    this.togroup,
    this.isvideocall,
    this.isaudiocall,
    this.isgroupcall,
    this.status,
    this.initiatedby,
    this.members,
    this.agorameta,
    this.timestamp,
    this.callingfrom,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory CallHistoryByUserData.fromJson(Map<String, dynamic> json) =>
      CallHistoryByUserData(
        id: json["_id"],
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        touser: json["touser"] == null
            ? null
            : ChatListsFrom.fromJson(json["touser"]),
        togroup:
            json["togroup"] == null ? null : Togroup.fromJson(json["togroup"]),
        isvideocall: _parseBool(json["isvideocall"]),
        isaudiocall: _parseBool(json["isaudiocall"]),
        isgroupcall: _parseBool(json["isgroupcall"]),
        status: json["status"],
        initiatedby: json["initiatedby"] == null
            ? null
            : ChatListsFrom.fromJson(json["initiatedby"]),
        members: json["members"] == null
            ? []
            : List<CallHistoryMember>.from(
                json["members"]!.map((x) => CallHistoryMember.fromJson(x))),
        agorameta: json["agorameta"] == null
            ? null
            : CallHistoryAgorameta.fromJson(json["agorameta"]),
        timestamp: json["timestamp"],
        callingfrom: json["callingfrom"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from?.toJson(),
        "touser": touser?.toJson(),
        "togroup": togroup?.toJson(),
        "isvideocall": isvideocall,
        "isaudiocall": isaudiocall,
        "isgroupcall": isgroupcall,
        "status": status,
        "initiatedby": initiatedby?.toJson(),
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "agorameta": agorameta?.toJson(),
        "timestamp": timestamp,
        "callingfrom": callingfrom,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
