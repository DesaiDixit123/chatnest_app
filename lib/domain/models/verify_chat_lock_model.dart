// To parse this JSON data, do
//
//     final verifyChatLockModel = verifyChatLockModelFromJson(jsonString);

import 'dart:convert';

VerifyChatLockModel verifyChatLockModelFromJson(String str) =>
    VerifyChatLockModel.fromJson(json.decode(str));

String verifyChatLockModelToJson(VerifyChatLockModel data) =>
    json.encode(data.toJson());

class VerifyChatLockModel {
  String? message;
  VerifyChatLockData? data;
  int? status;
  bool? isSuccess;

  VerifyChatLockModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory VerifyChatLockModel.fromJson(Map<String, dynamic> json) =>
      VerifyChatLockModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"] == 0
            ? null
            : VerifyChatLockData.fromJson(json["Data"]),
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

class VerifyChatLockData {
  String? token;

  VerifyChatLockData({
    this.token,
  });

  factory VerifyChatLockData.fromJson(Map<String, dynamic> json) =>
      VerifyChatLockData(
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "token": token,
      };
}
