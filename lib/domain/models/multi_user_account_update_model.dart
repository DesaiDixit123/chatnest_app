import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

MultiUserAccountUpdateModel multiUserAccountUpdateModelFromJson(String str) =>
    MultiUserAccountUpdateModel.fromJson(json.decode(str));

String multiUserAccountUpdateModelToJson(MultiUserAccountUpdateModel data) =>
    json.encode(data.toJson());

class MultiUserAccountUpdateModel {
  String? message;
  MultiUserAccountUpdateData? data;
  int? status;
  bool? isSuccess;

  MultiUserAccountUpdateModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory MultiUserAccountUpdateModel.fromJson(Map<String, dynamic> json) =>
      MultiUserAccountUpdateModel(
        message: json["Message"],
        data: json["Data"] == null ? null : MultiUserAccountUpdateData.fromJson(json["Data"]),
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

class MultiUserAccountUpdateData {
  String? id;
  CreatedBy? parentid;
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
  List<Group>? groups;
  int? lastLoginAt;
  int? lastLogoutAt;
  LastLoginDevice? lastLoginDevice;
  CreatedBy? createdBy;
  CreatedBy? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  MultiUserAccountUpdateData({
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
    this.lastLoginDevice,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory MultiUserAccountUpdateData.fromJson(Map<String, dynamic> json) => MultiUserAccountUpdateData(
        id: json["_id"],
        parentid: json["parentid"] == null
            ? null
            : CreatedBy.fromJson(json["parentid"]),
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
            : List<Group>.from(json["groups"]!.map((x) => Group.fromJson(x))),
        lastLoginAt: json["last_login_at"],
        lastLogoutAt: json["last_logout_at"],
        lastLoginDevice: json["last_login_device"] == null
            ? null
            : LastLoginDevice.fromJson(json["last_login_device"]),
        createdBy: json["createdBy"] == null
            ? null
            : CreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : CreatedBy.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "parentid": parentid?.toJson(),
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
        "groups": groups == null
            ? []
            : List<dynamic>.from(groups!.map((x) => x.toJson())),
        "last_login_at": lastLoginAt,
        "last_logout_at": lastLogoutAt,
        "last_login_device": lastLoginDevice?.toJson(),
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}
