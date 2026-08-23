// To parse this JSON data, do
//
//     final archiveGroupListModel = archiveGroupListModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

ArchiveGroupListModel archiveGroupListModelFromJson(String str) =>
    ArchiveGroupListModel.fromJson(json.decode(str));

String archiveGroupListModelToJson(ArchiveGroupListModel data) =>
    json.encode(data.toJson());

class ArchiveGroupListModel {
  String? message;
  List<GroupChatDatum>? data;
  int? status;
  bool? isSuccess;

  ArchiveGroupListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory ArchiveGroupListModel.fromJson(Map<String, dynamic> json) =>
      ArchiveGroupListModel(
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<GroupChatDatum>.from(
                json["Data"]!.map((x) => GroupChatDatum.fromJson(x))),
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
