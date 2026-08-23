import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

HostMeetingListModel hostMeetingListModelFromJson(String str) =>
    HostMeetingListModel.fromJson(json.decode(str));

class HostMeetingListModel {
  String? message;
  HostMeetingData? data;
  int? status;
  bool? isSuccess;

  HostMeetingListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory HostMeetingListModel.fromJson(Map<String, dynamic> json) =>
      HostMeetingListModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"] == 0 
            ? null
            : HostMeetingData.fromJson(json["Data"]),
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

class HostMeetingData {
  List<HostMeetingDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  HostMeetingData({
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

  factory HostMeetingData.fromJson(Map<String, dynamic> json) =>
      HostMeetingData(
        docs: json["docs"] == null
            ? []
            : List<HostMeetingDoc>.from(
                json["docs"]!.map((x) => HostMeetingDoc.fromJson(x))),
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

class HostMeetingDoc {
  String? id;
  String? title;
  String? description;
  String? meetingstartdate;
  String? meetingstarttime;
  int? starttimestamp;
  String? meetingenddate;
  String? meetingendtime;
  int? endtimestamp;
  List<Member>? members;
  String? status;
  CreatedBy? hostby;
  Agorameta? agorameta;
  CreatedBy? createdBy;
  CreatedBy? updatedBy;
  List<dynamic>? attendees;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? docId;

  HostMeetingDoc({
    this.id,
    this.title,
    this.description,
    this.meetingstartdate,
    this.meetingstarttime,
    this.starttimestamp,
    this.meetingenddate,
    this.meetingendtime,
    this.endtimestamp,
    this.members,
    this.status,
    this.hostby,
    this.agorameta,
    this.createdBy,
    this.updatedBy,
    this.attendees,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
  });

  factory HostMeetingDoc.fromJson(Map<String, dynamic> json) => HostMeetingDoc(
        id: json["_id"],
        title: json["title"],
        description: json["description"],
        meetingstartdate: json["meetingstartdate"],
        meetingstarttime: json["meetingstarttime"],
        starttimestamp: json["starttimestamp"],
        meetingenddate: json["meetingenddate"],
        meetingendtime: json["meetingendtime"],
        endtimestamp: json["endtimestamp"],
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        status: json["status"],
        hostby:
            json["hostby"] == null ? null : CreatedBy.fromJson(json["hostby"]),
        agorameta: json["agorameta"] == null
            ? null
            : Agorameta.fromJson(json["agorameta"]),
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : CreatedBy.fromJson(json["updatedBy"]),
        attendees: json["attendees"] == null
            ? []
            : List<dynamic>.from(json["attendees"]!.map((x) => x)),
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
        "title": title,
        "description": description,
        "meetingstartdate": meetingstartdate,
        "meetingstarttime": meetingstarttime,
        "starttimestamp": starttimestamp,
        "meetingenddate": meetingenddate,
        "meetingendtime": meetingendtime,
        "endtimestamp": endtimestamp,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "status": status,
        "hostby": hostby?.toJson(),
        "agorameta": agorameta?.toJson(),
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "attendees": attendees == null
            ? []
            : List<dynamic>.from(attendees!.map((x) => x)),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "id": docId,
      };
}

class Agorameta {
  String? token;
  String? channelName;
  String? uid;
  String? role;
  int? expirationTimeInSeconds;
  int? privilegeExpiredTs;

  Agorameta({
    this.token,
    this.channelName,
    this.uid,
    this.role,
    this.expirationTimeInSeconds,
    this.privilegeExpiredTs,
  });

  factory Agorameta.fromJson(Map<String, dynamic> json) => Agorameta(
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

class CreatedBy {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? hashtag;
  String? aboutme;

  CreatedBy({
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

  factory CreatedBy.fromJson(Map<String, dynamic> json) => CreatedBy(
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
