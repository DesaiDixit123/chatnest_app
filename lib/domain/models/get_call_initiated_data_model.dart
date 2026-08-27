import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetCallInitiatedDataModel getCallInitiatedDataModelFromJson(String str) =>
    GetCallInitiatedDataModel.fromJson(json.decode(str));

class GetCallInitiatedDataModel {
  final String message;
  final CallInitiatedData data;
  final int status;
  final bool isSuccess;

  GetCallInitiatedDataModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetCallInitiatedDataModel.fromJson(Map<String, dynamic> json) =>
      GetCallInitiatedDataModel(
        message: json["Message"],
        data: CallInitiatedData.fromJson(json["Data"]),
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

class CallInitiatedData {
  final String title;
  final String message;
  final String banner;
  final String fromid;
  final String toid;
  final String fromusername;
  final Calldata calldata;
  String? isvideocall;
  String? isaudiocall;
  String? isgroupcall;
  String? timestamp;
  List<String>? fcmTokens;

  CallInitiatedData({
    required this.title,
    required this.message,
    required this.banner,
    required this.fromid,
    required this.toid,
    required this.fromusername,
    required this.calldata,
    this.isvideocall,
    this.isaudiocall,
    this.isgroupcall,
    this.timestamp,
    this.fcmTokens,
  });

  factory CallInitiatedData.fromJson(Map<String, dynamic> json) =>
      CallInitiatedData(
        title: json["title"],
        message: json["message"],
        banner: json["banner"],
        fromid: json["fromid"],
        toid: json["toid"],
        fromusername: json["fromusername"],
        calldata: Calldata.fromJson(json["calldata"]),
        isvideocall: json["isvideocall"],
        isaudiocall: json["isaudiocall"],
        isgroupcall: json["isgroupcall"],
        timestamp: json["timestamp"],
        fcmTokens: json["fcm_tokens"] == null
            ? []
            : List<String>.from(json["fcm_tokens"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        "message": message,
        "banner": banner,
        "fromid": fromid,
        "toid": toid,
        "fromusername": fromusername,
        "calldata": calldata.toJson(),
        "isvideocall": isvideocall,
        "isaudiocall": isaudiocall,
        "isgroupcall": isgroupcall,
        "timestamp": timestamp,
        "fcm_tokens": fcmTokens == null
            ? []
            : List<dynamic>.from(fcmTokens!.map((x) => x)),
      };
}

class Calldata {
  final String? id;
  final ChatListsFrom? from;
  final ChatListsFrom? touser;
  final Togroup? togroup;
  final bool? isvideocall;
  final bool? isaudiocall;
  final bool? isgroupcall;
  final String? status;
  final ChatListsFrom? initiatedby;
  final AgorametaDataModel? agorameta;
  final int? timestamp;
  final String? callingfrom;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int? v;

  Calldata({
    this.id,
    this.from,
    this.touser,
    this.togroup,
    this.isvideocall,
    this.isaudiocall,
    this.isgroupcall,
    this.status,
    this.initiatedby,
    this.agorameta,
    this.timestamp,
    this.callingfrom,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Calldata.fromJson(Map<String, dynamic> json) => Calldata(
        id: (json["_id"] ?? "").toString(),
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        touser: json["touser"] == null
            ? null
            : ChatListsFrom.fromJson(json["touser"]),
        togroup:
            json["togroup"] == null ? null : Togroup.fromJson(json["togroup"]),
        isvideocall: json["isvideocall"] == true || json["isvideocall"] == "true" || json["isvideocall"] == "yes",
        isaudiocall: json["isaudiocall"] == true || json["isaudiocall"] == "true" || json["isaudiocall"] == "yes",
        isgroupcall: json["isgroupcall"] == true || json["isgroupcall"] == "true" || json["isgroupcall"] == "yes",
        status: (json["status"] ?? "").toString(),
        initiatedby: json["initiatedby"] == null
            ? null
            : ChatListsFrom.fromJson(json["initiatedby"]),
        agorameta: json["agorameta"] == null
            ? null
            : AgorametaDataModel.fromJson(json["agorameta"]),
        timestamp: int.tryParse(json["timestamp"]?.toString() ?? "0") ?? 0,
        callingfrom: (json["callingfrom"] ?? "").toString(),
        createdAt: json["createdAt"] != null
            ? DateTime.tryParse(json["createdAt"].toString())
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.tryParse(json["updatedAt"].toString())
            : null,
        v: int.tryParse(json["__v"]?.toString() ?? "0") ?? 0,
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
        "agorameta": agorameta?.toJson(),
        "timestamp": timestamp,
        "callingfrom": callingfrom,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class AgorametaDataModel {
  final String token;
  final String channelName;
  final String uid;
  final String role;
  final int expirationTimeInSeconds;
  final int privilegeExpiredTs;

  AgorametaDataModel({
    required this.token,
    required this.channelName,
    required this.uid,
    required this.role,
    required this.expirationTimeInSeconds,
    required this.privilegeExpiredTs,
  });

  factory AgorametaDataModel.fromJson(Map<String, dynamic> json) =>
      AgorametaDataModel(
        token: (json["token"] ?? "").toString(),
        channelName: (json["channelName"] ?? "").toString(),
        uid: (json["uid"] ?? "").toString(),
        role: (json["role"] ?? "").toString(),
        expirationTimeInSeconds: int.tryParse(json["expirationTimeInSeconds"]?.toString() ?? "0") ?? 0,
        privilegeExpiredTs: int.tryParse(json["privilegeExpiredTs"]?.toString() ?? "0") ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "channelName": channelName,
        "uid": uid,
        "role": role,
        "expirationTimeInSeconds": expirationTimeInSeconds,
        "privilegeExpiredTs": privilegeExpiredTs,
      };
}

class Togroup {
  String? id;
  bool? status;
  String? profileimage;
  String? name;
  String? description;

  Togroup({
    this.id,
    this.status,
    this.profileimage,
    this.name,
    this.description,
  });

  factory Togroup.fromJson(Map<String, dynamic> json) => Togroup(
        id: json["_id"],
        status: json["status"],
        profileimage: json["profileimage"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "profileimage": profileimage,
        "name": name,
        "description": description,
      };
}
