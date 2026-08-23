import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneReportModel getOneReportModelFromJson(String str) =>
    GetOneReportModel.fromJson(json.decode(str));

String getOneReportModelToJson(GetOneReportModel data) =>
    json.encode(data.toJson());

class GetOneReportModel {
  String? message;
  ReportListDoc? data;
  int? status;
  bool? isSuccess;

  GetOneReportModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetOneReportModel.fromJson(Map<String, dynamic> json) =>
      GetOneReportModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : ReportListDoc.fromJson(json["Data"]),
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
