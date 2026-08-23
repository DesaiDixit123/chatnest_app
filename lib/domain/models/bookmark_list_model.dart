import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

BookmarkListModel bookmarkListModelFromJson(String str) =>
    BookmarkListModel.fromJson(json.decode(str));

String bookmarkListModelToJson(BookmarkListModel data) =>
    json.encode(data.toJson());

class BookmarkListModel {
  String? message;
  List<ChatListsDoc>? data;
  int? status;
  bool? isSuccess;

  BookmarkListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory BookmarkListModel.fromJson(Map<String, dynamic> json) =>
      BookmarkListModel(
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<ChatListsDoc>.from(
                json["Data"]!.map((x) => ChatListsDoc.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
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
