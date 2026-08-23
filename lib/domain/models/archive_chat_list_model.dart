import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

ArchiveChatListModel archiveChatListModelFromJson(String str) =>
    ArchiveChatListModel.fromJson(json.decode(str));

String archiveChatListModelToJson(ArchiveChatListModel data) =>
    json.encode(data.toJson());

class ArchiveChatListModel {
  String? message;
  List<MyFriendDatum>? data;
  int? status;
  bool? isSuccess;

  ArchiveChatListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory ArchiveChatListModel.fromJson(Map<String, dynamic> json) =>
      ArchiveChatListModel(
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<MyFriendDatum>.from(
                json["Data"]!.map((x) => MyFriendDatum.fromJson(x))),
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
