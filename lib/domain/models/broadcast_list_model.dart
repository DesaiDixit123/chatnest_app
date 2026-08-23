import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

BroadcastListModel broadcastListModelFromJson(String str) =>
    BroadcastListModel.fromJson(json.decode(str));

class BroadcastListModel {
  String? message;
  BroadcastData? data;
  int? status;
  bool? isSuccess;

  BroadcastListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory BroadcastListModel.fromJson(Map<String, dynamic> json) =>
      BroadcastListModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : BroadcastData.fromJson(json["Data"]),
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

class BroadcastData {
  List<BroadcastDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  BroadcastData({
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

  factory BroadcastData.fromJson(Map<String, dynamic> json) => BroadcastData(
        docs: json["docs"] == null
            ? []
            : List<BroadcastDoc>.from(
                json["docs"]!.map((x) => BroadcastDoc.fromJson(x))),
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

class BroadcastDoc {
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
  String? docId;

  BroadcastDoc({
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
    this.docId,
  });

  factory BroadcastDoc.fromJson(Map<String, dynamic> json) => BroadcastDoc(
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
        docId: json["id"],
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
        "id": docId,
      };
}

class BroadcastLastchatmessage {
  ChatListsDoc? message;
  int timestamp;

  BroadcastLastchatmessage({
    required this.message,
    required this.timestamp,
  });

  factory BroadcastLastchatmessage.fromJson(Map<String, dynamic> json) =>
      BroadcastLastchatmessage(
        message: json["message"] == null
            ? null
            : ChatListsDoc.fromJson(json["message"]),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "timestamp": timestamp,
      };
}

class BroadcastMessage {
  String? id;
  BroadcastCreatedBy? from;
  BroadcastCreatedBy? to;
  List<Member>? members;
  dynamic context;
  String? contentType;
  Content? content;
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

  BroadcastMessage({
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

  factory BroadcastMessage.fromJson(Map<String, dynamic> json) =>
      BroadcastMessage(
        id: json["_id"],
        from: json["from"] == null
            ? null
            : BroadcastCreatedBy.fromJson(json["from"]),
        to: json["to"] == null ? null : BroadcastCreatedBy.fromJson(json["to"]),
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        context: json["context"],
        contentType: json["contentType"],
        content:
            json["content"] == null ? null : Content.fromJson(json["content"]),
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
        "from": from?.toJson(),
        "to": to?.toJson(),
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

class BroadcastCreatedBy {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? hashtag;
  String? aboutme;

  BroadcastCreatedBy({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.email,
    this.hashtag,
    this.aboutme,
  });

  factory BroadcastCreatedBy.fromJson(Map<String, dynamic> json) =>
      BroadcastCreatedBy(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        hashtag: json["hashtag"],
        aboutme: json["aboutme"],
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
      };
}

class Member {
  BroadcastCreatedBy? userid;
  Messageid? messageid;

  Member({
    this.userid,
    this.messageid,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        userid: json["userid"] == null
            ? null
            : BroadcastCreatedBy.fromJson(json["userid"]),
        messageid: json["messageid"] == null
            ? null
            : Messageid.fromJson(json["messageid"]),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
        "messageid": messageid?.toJson(),
      };
}

class Messageid {
  String? id;
  String? status;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  bool? isbroadcasted;

  Messageid({
    this.id,
    this.status,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
    this.isbroadcasted,
  });

  factory Messageid.fromJson(Map<String, dynamic> json) => Messageid(
        id: json["_id"],
        status: json["status"],
        senttimestamp: json["senttimestamp"],
        deliveredtimestamp: json["deliveredtimestamp"],
        seentimestamp: json["seentimestamp"],
        isbroadcasted: json["isbroadcasted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
        "isbroadcasted": isbroadcasted,
      };
}
