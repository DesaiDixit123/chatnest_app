import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

FindFirendsLocationModel findFirendsLocationModelFromJson(String str) =>
    FindFirendsLocationModel.fromJson(json.decode(str));

class FindFirendsLocationModel {
  String message;
  List<FindFirendsDatum> data;
  int status;
  bool isSuccess;

  FindFirendsLocationModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory FindFirendsLocationModel.fromJson(Map<String, dynamic> json) =>
      FindFirendsLocationModel(
        message: json["Message"],
        data: List<FindFirendsDatum>.from(
            json["Data"].map((x) => FindFirendsDatum.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class FindFirendsDatum {
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
  String? isfriend;

  FindFirendsDatum({
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
    this.isfriend,
  });

  factory FindFirendsDatum.fromJson(Map<String, dynamic> json) =>
      FindFirendsDatum(
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
        isfriend: json["isfriend"] ?? "",
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
        if (isfriend != null) "isfriend": isfriend,
      };
}
