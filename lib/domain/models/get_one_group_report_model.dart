// To parse this JSON data, do
//
//     final getOneGroupReportModel = getOneGroupReportModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

GetOneGroupReportModel getOneGroupReportModelFromJson(String str) =>
    GetOneGroupReportModel.fromJson(json.decode(str));

String getOneGroupReportModelToJson(GetOneGroupReportModel data) =>
    json.encode(data.toJson());

class GetOneGroupReportModel {
  String? message;
  GroupReportDoc? data;
  int? status;
  bool? isSuccess;

  GetOneGroupReportModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetOneGroupReportModel.fromJson(Map<String, dynamic> json) =>
      GetOneGroupReportModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : GroupReportDoc.fromJson(json["Data"]),
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
