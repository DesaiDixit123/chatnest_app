// To parse this JSON data, do
//
//     final findFirendsListModel = findFirendsListModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

FindFirendsListModel findFirendsListModelFromJson(String str) =>
    FindFirendsListModel.fromJson(json.decode(str));

String findFirendsListModelToJson(FindFirendsListModel data) =>
    json.encode(data.toJson());

class FindFirendsListModel {
  String message;
  FindFirendsListData data;
  int status;
  bool isSuccess;

  FindFirendsListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory FindFirendsListModel.fromJson(Map<String, dynamic> json) =>
      FindFirendsListModel(
        message: json["Message"],
        data: FindFirendsListData.fromJson(json["Data"]),
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

class FindFirendsListData {
  List<FindFirendsListDoc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  FindFirendsListData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory FindFirendsListData.fromJson(Map<String, dynamic> json) =>
      FindFirendsListData(
        docs: List<FindFirendsListDoc>.from(
            json["docs"].map((x) => FindFirendsListDoc.fromJson(x))),
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
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
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

class FindFirendsListDoc {
  String id;
  String mobile;
  String countryCode;
  String profileimage;
  String fullname;
  String nickname;
  String email;
  String dob;
  String? hashtag;
  String gender;
  String aboutme;
  List<String> hobbies;
  CoordinatesLocationModel location;
  String docId;
  String isfriend;
  String? friendrequestid;

  FindFirendsListDoc({
    required this.id,
    required this.mobile,
    required this.countryCode,
    required this.profileimage,
    required this.fullname,
    required this.nickname,
    required this.email,
    required this.dob,
    this.hashtag,
    required this.gender,
    required this.aboutme,
    required this.hobbies,
    required this.location,
    required this.docId,
    required this.isfriend,
    this.friendrequestid = "",
  });

  factory FindFirendsListDoc.fromJson(Map<String, dynamic> json) =>
      FindFirendsListDoc(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        dob: json["dob"],
        hashtag: json["hashtag"]??"",
        gender: json["gender"],
        aboutme: json["aboutme"],
        hobbies: List<String>.from(json["hobbies"].map((x) => x)),
        location: CoordinatesLocationModel.fromJson(json["location"]),
        docId: json["id"],
        isfriend: json["isfriend"],
        friendrequestid: json["friendrequestid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "dob": dob,
        "hashtag": hashtag,
        "gender": gender,
        "aboutme": aboutme,
        "hobbies": List<dynamic>.from(hobbies.map((x) => x)),
        "location": location.toJson(),
        "id": docId,
        "isfriend": isfriend,
        "friendrequestid": friendrequestid,
      };
}
