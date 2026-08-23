// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

   notificationModelFromJson(String str) =>
    NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) =>
    json.encode(data.toJson());

class NotificationModel {
  String? message;
  NotificationData? data;
  int? status;
  bool? isSuccess;

  NotificationModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      NotificationModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : NotificationData.fromJson(json["Data"]),
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

class NotificationData {
  List<NotificationDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  NotificationData({
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

  factory NotificationData.fromJson(Map<String, dynamic> json) =>
      NotificationData(
        docs: json["docs"] == null
            ? []
            : List<NotificationDoc>.from(
                json["docs"]!.map((x) => NotificationDoc.fromJson(x))),
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

class NotificationDoc {
  String? id;
  Fromid? userid;
  String? title;
  String? body;
  String? banner;
  Fromid? fromid;
  Fromid? toid;
  String? type;
  String? entity;
  String? status;
  String? timestamp;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? docId;

  NotificationDoc({
    this.id,
    this.userid,
    this.title,
    this.body,
    this.banner,
    this.fromid,
    this.toid,
    this.type,
    this.entity,
    this.status,
    this.timestamp,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
  });

  factory NotificationDoc.fromJson(Map<String, dynamic> json) =>
      NotificationDoc(
        id: json["_id"],
        userid: json["userid"] == null ? null : Fromid.fromJson(json["userid"]),
        title: json["title"],
        body: json["body"],
        banner: json["banner"],
        fromid: json["fromid"] == null ? null : Fromid.fromJson(json["fromid"]),
        toid: json["toid"] == null ? null : Fromid.fromJson(json["toid"]),
        type: json["type"],
        entity: json["entity"],
        status: json["status"],
        timestamp: json["timestamp"],
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
        "userid": userid?.toJson(),
        "title": title,
        "body": body,
        "banner": banner,
        "fromid": fromid?.toJson(),
        "toid": toid?.toJson(),
        "type": type,
        "entity": entity,
        "status": status,
        "timestamp": timestamp,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "id": docId,
      };
}

class Fromid {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? aboutme;

  Fromid({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.aboutme,
  });

  factory Fromid.fromJson(Map<String, dynamic> json) => Fromid(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        aboutme: json["aboutme"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "aboutme": aboutme,
      };
}
