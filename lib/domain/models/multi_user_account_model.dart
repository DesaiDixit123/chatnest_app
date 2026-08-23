import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

MultiUserAccountModel multiUserAccountModelFromJson(String str) =>
    MultiUserAccountModel.fromJson(json.decode(str));

class MultiUserAccountModel {
  String? message;
  MultiUserData? data;
  int? status;
  bool? isSuccess;

  MultiUserAccountModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory MultiUserAccountModel.fromJson(Map<String, dynamic> json) =>
      MultiUserAccountModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : MultiUserData.fromJson(json["Data"]),
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

class MultiUserData {
  List<MultiUserDoc>? docs;
  int? totalDocs;
  int? limit;
  int? totalPages;
  int? page;
  int? pagingCounter;
  bool? hasPrevPage;
  bool? hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  MultiUserData({
    this.docs,
    this.totalDocs,
    this.limit,
    this.totalPages,
    this.page,
    this.pagingCounter,
    this.hasPrevPage,
    this.hasNextPage,
    this.prevPage,
    this.nextPage,
  });

  factory MultiUserData.fromJson(Map<String, dynamic> json) => MultiUserData(
        docs: json["docs"] == null
            ? []
            : List<MultiUserDoc>.from(
                json["docs"]!.map((x) => MultiUserDoc.fromJson(x))),
        totalDocs: json["totalDocs"],
        limit: json["limit"],
        totalPages: json["totalPages"],
        page: json["page"],
        pagingCounter: json["pagingCounter"],
        hasPrevPage: json["hasPrevPage"],
        hasNextPage: json["hasNextPage"],
        prevPage: json["prevPage"],
        nextPage: json["nextPage"],
      );

  Map<String, dynamic> toJson() => {
        "docs": docs == null
            ? []
            : List<dynamic>.from(docs!.map((x) => x.toJson())),
        "totalDocs": totalDocs,
        "limit": limit,
        "totalPages": totalPages,
        "page": page,
        "pagingCounter": pagingCounter,
        "hasPrevPage": hasPrevPage,
        "hasNextPage": hasNextPage,
        "prevPage": prevPage,
        "nextPage": nextPage,
      };
}

MultiUserDoc multiUserDocModelFromJson(String str) =>
    MultiUserDoc.fromJson(json.decode(str));

class MultiUserDoc {
  String? id;
  MultiUserCreatedBy? parentid;
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
  String? docId;

  MultiUserDoc({
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
    this.docId,
  });

  factory MultiUserDoc.fromJson(Map<String, dynamic> json) => MultiUserDoc(
        id: json["_id"],
        parentid: json["parentid"] == null
            ? null
            : MultiUserCreatedBy.fromJson(json["parentid"]),
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
        docId: json["id"],
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
        "id": docId,
      };
}


class MultiUserCreatedBy {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? aboutme;

  MultiUserCreatedBy({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.aboutme,
  });

  factory MultiUserCreatedBy.fromJson(Map<String, dynamic> json) =>
      MultiUserCreatedBy(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        aboutme: json["aboutme"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "aboutme": aboutme,
      };
}

class Group {
  Groupid? groupid;

  Group({
    this.groupid,
  });

  factory Group.fromJson(Map<String, dynamic> json) => Group(
        groupid:
            json["groupid"] == null ? null : Groupid.fromJson(json["groupid"]),
      );

  Map<String, dynamic> toJson() => {
        "groupid": groupid?.toJson(),
      };
}

class Groupid {
  String? id;
  bool? status;
  String? profileimage;
  String? name;
  String? description;

  Groupid({
    this.id,
    this.status,
    this.profileimage,
    this.name,
    this.description,
  });

  factory Groupid.fromJson(Map<String, dynamic> json) => Groupid(
        id: json["_id"],
        status: json["status"],
        profileimage: json["profileimage"],
        name: json["name"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "profileimage": profileimage,
        "name": name,
        "description": description,
      };
}

class LastLoginDevice {
  String? ipaddress;
  String? useragent;
  Browser? browser;
  Engine? engine;
  Engine? os;
  Device? device;

  LastLoginDevice({
    this.ipaddress,
    this.useragent,
    this.browser,
    this.engine,
    this.os,
    this.device,
  });

  factory LastLoginDevice.fromJson(Map<String, dynamic> json) =>
      LastLoginDevice(
        ipaddress: json["ipaddress"],
        useragent: json["useragent"],
        browser:
            json["browser"] == null ? null : Browser.fromJson(json["browser"]),
        engine: json["engine"] == null ? null : Engine.fromJson(json["engine"]),
        os: json["os"] == null ? null : Engine.fromJson(json["os"]),
        device: json["device"] == null ? null : Device.fromJson(json["device"]),
      );

  Map<String, dynamic> toJson() => {
        "ipaddress": ipaddress,
        "useragent": useragent,
        "browser": browser?.toJson(),
        "engine": engine?.toJson(),
        "os": os?.toJson(),
        "device": device?.toJson(),
      };
}

class Browser {
  dynamic name;
  dynamic version;
  dynamic major;

  Browser({
    this.name,
    this.version,
    this.major,
  });

  factory Browser.fromJson(Map<String, dynamic> json) => Browser(
        name: json["name"],
        version: json["version"],
        major: json["major"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
        "major": major,
      };
}

class Device {
  dynamic vendor;
  dynamic model;
  dynamic type;

  Device({
    this.vendor,
    this.model,
    this.type,
  });

  factory Device.fromJson(Map<String, dynamic> json) => Device(
        vendor: json["vendor"],
        model: json["model"],
        type: json["type"],
      );

  Map<String, dynamic> toJson() => {
        "vendor": vendor,
        "model": model,
        "type": type,
      };
}

class Engine {
  dynamic name;
  dynamic version;

  Engine({
    this.name,
    this.version,
  });

  factory Engine.fromJson(Map<String, dynamic> json) => Engine(
        name: json["name"],
        version: json["version"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "version": version,
      };
}
