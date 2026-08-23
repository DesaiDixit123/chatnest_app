import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneBroadcastModel getOneBroadcastModelFromJson(String str) =>
    GetOneBroadcastModel.fromJson(json.decode(str));

String getOneBroadcastModelToJson(GetOneBroadcastModel data) =>
    json.encode(data.toJson());

class GetOneBroadcastModel {
  String? message;
  GetOneBroadcastData? data;
  int? status;
  bool? isSuccess;

  GetOneBroadcastModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetOneBroadcastModel.fromJson(Map<String, dynamic> json) =>
      GetOneBroadcastModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : GetOneBroadcastData.fromJson(json["Data"]),
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

class GetOneBroadcastData {
  String? id;
  bool? status;
  String? broadcasttitle;
  List<Member>? members;
  BroadcastLastchatmessage? lastchatmessage;
  bool? ispinned;
  BroadcastCreatedBy? createdBy;
  BroadcastCreatedBy? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<Latestmedia>? latestmedias;

  GetOneBroadcastData({
    this.id,
    this.status,
    this.broadcasttitle,
    this.members,
    this.lastchatmessage,
    this.ispinned,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.latestmedias,
  });

  factory GetOneBroadcastData.fromJson(Map<String, dynamic> json) =>
      GetOneBroadcastData(
        id: json["_id"],
        status: json["status"],
        broadcasttitle: json["broadcasttitle"],
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : BroadcastLastchatmessage.fromJson(json["lastchatmessage"]),
        ispinned: json["ispinned"],
        createdBy: json["createdBy"] == null
            ? null
            : BroadcastCreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : BroadcastCreatedBy.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        latestmedias: json["latestmedias"] == null
            ? []
            : List<Latestmedia>.from(
                json["latestmedias"]!.map((x) => Latestmedia.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "broadcasttitle": broadcasttitle,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "lastchatmessage": lastchatmessage?.toJson(),
        "ispinned": ispinned,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "latestmedias": latestmedias == null
            ? []
            : List<dynamic>.from(latestmedias!.map((x) => x.toJson())),
      };
}

class Latestmedia {
  String? id;
  String? from;
  String? to;
  List<LatestmediaMember>? members;
  dynamic context;
  String? contentType;
  ChatListsContent? content;
  dynamic callid;
  bool? isforwarded;
  List<dynamic>? favorites;
  List<dynamic>? bookmarks;
  List<dynamic>? reactions;
  List<dynamic>? deletedfor;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  bool? isedited;
  bool? isbroadcasted;
  String? status;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  Latestmedia({
    this.id,
    this.from,
    this.to,
    this.members,
    this.context,
    this.contentType,
    this.content,
    this.callid,
    this.isforwarded,
    this.favorites,
    this.bookmarks,
    this.reactions,
    this.deletedfor,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
    this.isedited,
    this.isbroadcasted,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory Latestmedia.fromJson(Map<String, dynamic> json) => Latestmedia(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        members: json["members"] == null
            ? []
            : List<LatestmediaMember>.from(
                json["members"]!.map((x) => LatestmediaMember.fromJson(x))),
        context: json["context"],
        contentType: json["contentType"],
        content: json["content"] == null
            ? null
            : ChatListsContent.fromJson(json["content"]),
        callid: json["callid"],
        isforwarded: json["isforwarded"],
        favorites: json["favorites"] == null
            ? []
            : List<dynamic>.from(json["favorites"]!.map((x) => x)),
        bookmarks: json["bookmarks"] == null
            ? []
            : List<dynamic>.from(json["bookmarks"]!.map((x) => x)),
        reactions: json["reactions"] == null
            ? []
            : List<dynamic>.from(json["reactions"]!.map((x) => x)),
        deletedfor: json["deletedfor"] == null
            ? []
            : List<dynamic>.from(json["deletedfor"]!.map((x) => x)),
        senttimestamp: json["senttimestamp"],
        deliveredtimestamp: json["deliveredtimestamp"],
        seentimestamp: json["seentimestamp"],
        isedited: json["isedited"],
        isbroadcasted: json["isbroadcasted"],
        status: json["status"],
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
        "from": from,
        "to": to,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "context": context,
        "contentType": contentType,
        "content": content?.toJson(),
        "callid": callid,
        "isforwarded": isforwarded,
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x)),
        "bookmarks": bookmarks == null
            ? []
            : List<dynamic>.from(bookmarks!.map((x) => x)),
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x)),
        "deletedfor": deletedfor == null
            ? []
            : List<dynamic>.from(deletedfor!.map((x) => x)),
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
        "isedited": isedited,
        "isbroadcasted": isbroadcasted,
        "status": status,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class LatestmediaMember {
  String? userid;
  String? messageid;

  LatestmediaMember({
    this.userid,
    this.messageid,
  });

  factory LatestmediaMember.fromJson(Map<String, dynamic> json) =>
      LatestmediaMember(
        userid: json["userid"],
        messageid: json["messageid"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "messageid": messageid,
      };
}

class DataMember {
  BroadcastCreatedBy? userid;

  DataMember({
    this.userid,
  });

  factory DataMember.fromJson(Map<String, dynamic> json) => DataMember(
        userid: json["userid"] == null
            ? null
            : BroadcastCreatedBy.fromJson(json["userid"]),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
      };
}
