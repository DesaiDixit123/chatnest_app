import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

SubUserLoginModel subUserLoginModelFromJson(String str) =>
    SubUserLoginModel.fromJson(json.decode(str));

String subUserLoginModelToJson(SubUserLoginModel data) =>
    json.encode(data.toJson());

class SubUserLoginModel {
  String? message;
  SubUserLoginData? data;
  int? status;
  bool? isSuccess;

  SubUserLoginModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory SubUserLoginModel.fromJson(Map<String, dynamic> json) =>
      SubUserLoginModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"] == 0
            ? null
            : SubUserLoginData.fromJson(json["Data"]),
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

class SubUserLoginData {
  String? token;
  String? s3Url;
  Profile? profile;

  SubUserLoginData({
    this.token,
    this.s3Url,
    this.profile,
  });

  factory SubUserLoginData.fromJson(Map<String, dynamic> json) =>
      SubUserLoginData(
        token: json["token"],
        s3Url: json["s3Url"],
        profile:
            json["profile"] == null ? null : Profile.fromJson(json["profile"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "s3Url": s3Url,
        "profile": profile?.toJson(),
      };
}

class Profile {
  String? id;
  String? parentid;
  bool? status;
  String? fullname;
  String? username;
  String? email;
  String? mobile;
  String? countryCode;
  String? password;
  CountryWiseContact? countryWiseContact;
  String? fcmToken;
  String? channelId;
  List<Chat>? chats;
  List<dynamic>? groups;
  int? lastLoginAt;
  int? lastLogoutAt;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  LastLoginDevice? lastLoginDevice;

  Profile({
    this.id,
    this.parentid,
    this.status,
    this.fullname,
    this.username,
    this.email,
    this.mobile,
    this.countryCode,
    this.password,
    this.countryWiseContact,
    this.fcmToken,
    this.channelId,
    this.chats,
    this.groups,
    this.lastLoginAt,
    this.lastLogoutAt,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastLoginDevice,
  });

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        id: json["_id"],
        parentid: json["parentid"],
        status: json["status"],
        fullname: json["fullname"],
        username: json["username"],
        email: json["email"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        password: json["password"],
        countryWiseContact: json["country_wise_contact"] == null
            ? null
            : CountryWiseContact.fromJson(json["country_wise_contact"]),
        fcmToken: json["fcm_token"],
        channelId: json["channelID"],
        chats: json["chats"] == null
            ? []
            : List<Chat>.from(json["chats"]!.map((x) => Chat.fromJson(x))),
        groups: json["groups"] == null
            ? []
            : List<dynamic>.from(json["groups"]!.map((x) => x)),
        lastLoginAt: json["last_login_at"],
        lastLogoutAt: json["last_logout_at"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        lastLoginDevice: json["last_login_device"] == null
            ? null
            : LastLoginDevice.fromJson(json["last_login_device"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "parentid": parentid,
        "status": status,
        "fullname": fullname,
        "username": username,
        "email": email,
        "mobile": mobile,
        "country_code": countryCode,
        "password": password,
        "country_wise_contact": countryWiseContact?.toJson(),
        "fcm_token": fcmToken,
        "channelID": channelId,
        "chats": chats == null
            ? []
            : List<dynamic>.from(chats!.map((x) => x.toJson())),
        "groups":
            groups == null ? [] : List<dynamic>.from(groups!.map((x) => x)),
        "last_login_at": lastLoginAt,
        "last_logout_at": lastLogoutAt,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "last_login_device": lastLoginDevice?.toJson(),
      };
}

class Chat {
  String? friendrequestid;

  Chat({
    this.friendrequestid,
  });

  factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        friendrequestid: json["friendrequestid"],
      );

  Map<String, dynamic> toJson() => {
        "friendrequestid": friendrequestid,
      };
}
