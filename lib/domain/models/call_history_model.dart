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

CallHistoryModel callHistoryModelFromJson(String str) =>
    CallHistoryModel.fromJson(json.decode(str));

class CallHistoryModel {
  String? message;
  CallHistoryData? data;
  int? status;
  bool? isSuccess;

  CallHistoryModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory CallHistoryModel.fromJson(Map<String, dynamic> json) =>
      CallHistoryModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : CallHistoryData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data?.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class CallHistoryData {
  List<CallHistoryDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  CallHistoryData({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory CallHistoryData.fromJson(Map<String, dynamic> json) =>
      CallHistoryData(
        docs: json["docs"] == null
            ? []
            : List<CallHistoryDoc>.from(
                json["docs"]!.map((x) => CallHistoryDoc.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? []
            : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

class CallHistoryDoc {
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
  String? docId;
  int? duration;
  int? startTime;
  int? endedAt;
  int? callStartedAt;

  CallHistoryDoc({
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
    this.docId,
    this.duration,
    this.startTime,
    this.endedAt,
    this.callStartedAt,
  });

  factory CallHistoryDoc.fromJson(Map<String, dynamic> json) => CallHistoryDoc(
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
        docId: json["id"],
        duration: json["duration"] is num
            ? (json["duration"] as num).toInt()
            : int.tryParse(json["duration"]?.toString() ?? ""),
        startTime: json["startTime"] is num
            ? (json["startTime"] as num).toInt()
            : int.tryParse(json["startTime"]?.toString() ?? ""),
        endedAt: json["endedAt"] is num
            ? (json["endedAt"] as num).toInt()
            : int.tryParse(json["endedAt"]?.toString() ?? ""),
        callStartedAt: json["callStartedAt"] is num
            ? (json["callStartedAt"] as num).toInt()
            : int.tryParse(json["callStartedAt"]?.toString() ?? ""),
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
        "id": docId,
        "duration": duration,
        "startTime": startTime,
        "endedAt": endedAt,
        "callStartedAt": callStartedAt,
      };
}

class CallHistoryAgorameta {
  String? token;
  String? channelName;
  String? uid;
  String? role;
  int? expirationTimeInSeconds;
  int? privilegeExpiredTs;

  CallHistoryAgorameta({
    this.token,
    this.channelName,
    this.uid,
    this.role,
    this.expirationTimeInSeconds,
    this.privilegeExpiredTs,
  });

  factory CallHistoryAgorameta.fromJson(Map<String, dynamic> json) =>
      CallHistoryAgorameta(
        token: json["token"],
        channelName: json["channelName"],
        uid: json["uid"],
        role: json["role"],
        expirationTimeInSeconds: json["expirationTimeInSeconds"],
        privilegeExpiredTs: json["privilegeExpiredTs"],
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

class CallHistoryMember {
  ChatListsFrom? memberid;
  String? status;
  int? calledAt;
  int? receivedAt;
  int? startedAt;
  int? endedAt;

  CallHistoryMember({
    this.memberid,
    this.status,
    this.calledAt,
    this.receivedAt,
    this.startedAt,
    this.endedAt,
  });

  factory CallHistoryMember.fromJson(Map<String, dynamic> json) =>
      CallHistoryMember(
        memberid: json["memberid"] == null
            ? null
            : ChatListsFrom.fromJson(json["memberid"]),
        status: json["status"],
        calledAt: json["calledAt"],
        receivedAt: json["receivedAt"],
        startedAt: json["startedAt"],
        endedAt: json["endedAt"],
      );

  Map<String, dynamic> toJson() => {
        "memberid": memberid?.toJson(),
        "status": status,
        "calledAt": calledAt,
        "receivedAt": receivedAt,
        "startedAt": startedAt,
        "endedAt": endedAt,
      };
}
