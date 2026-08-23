import 'dart:convert';
import 'package:chatnest/domain/models/status_model.dart';

GetUserStatusModel getUserStatusModelFromJson(String str) =>
    GetUserStatusModel.fromJson(json.decode(str));

class GetUserStatusModel {
  String message;
  GetUserStatusData data;
  int status;
  bool isSuccess;

  GetUserStatusModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetUserStatusModel.fromJson(Map<String, dynamic> json) =>
      GetUserStatusModel(
        message: json["Message"] ?? '',
        data: GetUserStatusData.fromJson(json["Data"] ?? {}),
        status: json["Status"] ?? 0,
        isSuccess: json["IsSuccess"] ?? false,
      );
}

class GetUserStatusData {
  String userid;
  String name;
  String nickname;
  String profileimage;
  List<StatusModel> statuses;

  GetUserStatusData({
    required this.userid,
    required this.name,
    required this.nickname,
    required this.profileimage,
    required this.statuses,
  });

  factory GetUserStatusData.fromJson(Map<String, dynamic> json) =>
      GetUserStatusData(
        userid: json["userid"] ?? '',
        name: json["name"] ?? '',
        nickname: json["nickname"] ?? '',
        profileimage: json["profileimage"] ?? '',
        statuses: json["statuses"] == null
            ? []
            : List<StatusModel>.from(
                json["statuses"].map((x) => StatusModel.fromJson(x))),
      );
}
