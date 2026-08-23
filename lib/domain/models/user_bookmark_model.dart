// To parse this JSON data, do
//
//     final userBookmarkModel = userBookmarkModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

UserBookmarkModel userBookmarkModelFromJson(String str) =>
    UserBookmarkModel.fromJson(json.decode(str));

String userBookmarkModelToJson(UserBookmarkModel data) =>
    json.encode(data.toJson());

class UserBookmarkModel {
  String? message;
  UserBookmarkData? data;
  int? status;
  bool? isSuccess;

  UserBookmarkModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory UserBookmarkModel.fromJson(Map<String, dynamic> json) =>
      UserBookmarkModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : UserBookmarkData.fromJson(json["Data"]),
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

class UserBookmarkData {
  List<ChatListsDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  UserBookmarkData({
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

  factory UserBookmarkData.fromJson(Map<String, dynamic> json) =>
      UserBookmarkData(
        docs: json["docs"] == null
            ? []
            : List<ChatListsDoc>.from(
                json["docs"]!.map((x) => ChatListsDoc.fromJson(x))),
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
