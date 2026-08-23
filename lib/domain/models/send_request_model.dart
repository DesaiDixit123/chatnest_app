import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

SendRequestModel sendRequestModelFromJson(String str) =>
    SendRequestModel.fromJson(json.decode(str));

class SendRequestModel {
  String? message;
  SendRequestData? data;
  int? status;
  bool? isSuccess;

  SendRequestModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory SendRequestModel.fromJson(Map<String, dynamic> json) =>
      SendRequestModel(
        message: json["Message"] ?? "",
        data: json["Data"] == null || json["Data"] == 0
            ? null
            : SendRequestData.fromJson(json["Data"]),
        status: json["Status"] ?? 0,
        isSuccess: json["IsSuccess"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data?.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class SendRequestData {
  Erid? senderid;
  Erid? receiverid;
  Permissions sendersScope;
  Permissions receiversScope;
  dynamic blockedBy;
  dynamic unblockedBy;
  String status;
  GroupLastchatmessage lastchatmessage;
  List<dynamic> pins;
  String id;
  int timestamp;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  SendRequestData({
    required this.senderid,
    required this.receiverid,
    required this.sendersScope,
    required this.receiversScope,
    required this.blockedBy,
    required this.unblockedBy,
    required this.status,
    required this.lastchatmessage,
    required this.pins,
    required this.id,
    required this.timestamp,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SendRequestData.fromJson(Map<String, dynamic> json) =>
      SendRequestData(
        senderid:
            json["senderid"] == null ? null : Erid.fromJson(json["senderid"]),
        receiverid: json["receiverid"] == null
            ? null
            : Erid.fromJson(json["receiverid"]),
        sendersScope: Permissions.fromJson(json["senders_scope"]),
        receiversScope: Permissions.fromJson(json["receivers_scope"]),
        blockedBy: json["blockedBy"],
        unblockedBy: json["unblockedBy"],
        status: json["status"],
        lastchatmessage: GroupLastchatmessage.fromJson(json["lastchatmessage"]),
        pins: List<dynamic>.from(json["pins"].map((x) => x)),
        id: json["_id"],
        timestamp: json["timestamp"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "senderid": senderid?.toJson(),
        "receiverid": receiverid?.toJson(),
        "senders_scope": sendersScope.toJson(),
        "receivers_scope": receiversScope.toJson(),
        "blockedBy": blockedBy,
        "unblockedBy": unblockedBy,
        "status": status,
        "lastchatmessage": lastchatmessage.toJson(),
        "pins": List<dynamic>.from(pins.map((x) => x)),
        "_id": id,
        "timestamp": timestamp,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Erid {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? hashtag;
  String? aboutme;
  String? channelId;

  Erid({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.email,
    this.hashtag,
    this.aboutme,
    this.channelId,
  });

  factory Erid.fromJson(Map<String, dynamic> json) => Erid(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        hashtag: json["hashtag"],
        aboutme: json["aboutme"],
        channelId: json["channelID"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "hashtag": hashtag,
        "aboutme": aboutme,
        "channelID": channelId,
      };
}
