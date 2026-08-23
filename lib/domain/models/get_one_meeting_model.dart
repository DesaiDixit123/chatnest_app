
import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

GetOneMeetingModel getOneMeetingModelFromJson(String str) =>
    GetOneMeetingModel.fromJson(json.decode(str));

class GetOneMeetingModel {
  String? message;
  HostMeetingDoc? data;
  int? status;
  bool? isSuccess;

  GetOneMeetingModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetOneMeetingModel.fromJson(Map<String, dynamic> json) =>
      GetOneMeetingModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : HostMeetingDoc.fromJson(json["Data"]),
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
