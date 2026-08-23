// To parse this JSON data, do
//
//     final settingNotificationModel = settingNotificationModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

SettingNotificationModel settingNotificationModelFromJson(String str) =>
    SettingNotificationModel.fromJson(json.decode(str));

String settingNotificationModelToJson(SettingNotificationModel data) =>
    json.encode(data.toJson());

class SettingNotificationModel {
  String? message;
  SettingNotificationData? data;
  int? status;
  bool? isSuccess;

  SettingNotificationModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory SettingNotificationModel.fromJson(Map<String, dynamic> json) =>
      SettingNotificationModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : SettingNotificationData.fromJson(json["Data"]),
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

class SettingNotificationData {
  String? id;
  String? mobile;
  String? countryCode;
  CountryWiseContact? countryWiseContact;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? dob;
  String? hashtag;
  String? gender;
  String? aboutme;
  List<String>? hobbies;
  String? interestedin;
  int? interestedagerangemin;
  int? interestedagerangemax;
  List<Socialmedialink>? socialmedialinks;
  int? fCoins;
  String? fcmToken;
  String? otpVerifyKey;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  String? channelId;
  int? lastloginAt;
  AddressLocation? location;
  int? lastlogoutAt;
  bool? accountStatus;
  String? recoveryEmail;
  bool? ischatnotificationallowed;
  bool? isgroupchatnotificationallowed;
  bool? readreceiptsstatus;
  bool? lastseenonlineofflinestatus;

  SettingNotificationData({
    this.id,
    this.mobile,
    this.countryCode,
    this.countryWiseContact,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.email,
    this.dob,
    this.hashtag,
    this.gender,
    this.aboutme,
    this.hobbies,
    this.interestedin,
    this.interestedagerangemin,
    this.interestedagerangemax,
    this.socialmedialinks,
    this.fCoins,
    this.fcmToken,
    this.otpVerifyKey,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.channelId,
    this.lastloginAt,
    this.location,
    this.lastlogoutAt,
    this.accountStatus,
    this.recoveryEmail,
    this.ischatnotificationallowed,
    this.isgroupchatnotificationallowed,
    this.readreceiptsstatus,
    this.lastseenonlineofflinestatus,
  });

  factory SettingNotificationData.fromJson(Map<String, dynamic> json) =>
      SettingNotificationData(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        countryWiseContact: json["country_wise_contact"] == null
            ? null
            : CountryWiseContact.fromJson(json["country_wise_contact"]),
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        dob: json["dob"],
        hashtag: json["hashtag"],
        gender: json["gender"],
        aboutme: json["aboutme"],
        hobbies: json["hobbies"] == null
            ? []
            : List<String>.from(json["hobbies"]!.map((x) => x)),
        interestedin: json["interestedin"],
        interestedagerangemin: json["interestedagerangemin"],
        interestedagerangemax: json["interestedagerangemax"],
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<Socialmedialink>.from(json["socialmedialinks"]!
                .map((x) => Socialmedialink.fromJson(x))),
        fCoins: json["f_coins"],
        fcmToken: json["fcm_token"],
        otpVerifyKey: json["otpVerifyKey"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        channelId: json["channelID"],
        lastloginAt: json["lastloginAt"],
        location: json["location"] == null
            ? null
            : AddressLocation.fromJson(json["location"]),
        lastlogoutAt: json["lastlogoutAt"],
        accountStatus: json["account_status"],
        recoveryEmail: json["recovery_email"],
        ischatnotificationallowed: json["ischatnotificationallowed"],
        isgroupchatnotificationallowed: json["isgroupchatnotificationallowed"],
        readreceiptsstatus: json["readreceiptsstatus"],
        lastseenonlineofflinestatus: json["lastseenonlineofflinestatus"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "country_wise_contact": countryWiseContact?.toJson(),
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "dob": dob,
        "hashtag": hashtag,
        "gender": gender,
        "aboutme": aboutme,
        "hobbies":
            hobbies == null ? [] : List<dynamic>.from(hobbies!.map((x) => x)),
        "interestedin": interestedin,
        "interestedagerangemin": interestedagerangemin,
        "interestedagerangemax": interestedagerangemax,
        "socialmedialinks": socialmedialinks == null
            ? []
            : List<dynamic>.from(socialmedialinks!.map((x) => x.toJson())),
        "f_coins": fCoins,
        "fcm_token": fcmToken,
        "otpVerifyKey": otpVerifyKey,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "channelID": channelId,
        "lastloginAt": lastloginAt,
        "location": location?.toJson(),
        "lastlogoutAt": lastlogoutAt,
        "account_status": accountStatus,
        "recovery_email": recoveryEmail,
        "ischatnotificationallowed": ischatnotificationallowed,
        "isgroupchatnotificationallowed": isgroupchatnotificationallowed,
        "readreceiptsstatus": readreceiptsstatus,
        "lastseenonlineofflinestatus": lastseenonlineofflinestatus,
      };
}

class CountryWiseContact {
  String? number;
  String? internationalNumber;
  String? nationalNumber;
  String? e164Number;
  String? countryCode;
  String? dialCode;

  CountryWiseContact({
    this.number,
    this.internationalNumber,
    this.nationalNumber,
    this.e164Number,
    this.countryCode,
    this.dialCode,
  });

  factory CountryWiseContact.fromJson(Map<String, dynamic> json) =>
      CountryWiseContact(
        number: json["number"],
        internationalNumber: json["internationalNumber"],
        nationalNumber: json["nationalNumber"],
        e164Number: json["e164Number"],
        countryCode: json["countryCode"],
        dialCode: json["dialCode"],
      );

  Map<String, dynamic> toJson() => {
        "number": number,
        "internationalNumber": internationalNumber,
        "nationalNumber": nationalNumber,
        "e164Number": e164Number,
        "countryCode": countryCode,
        "dialCode": dialCode,
      };
}

// class Location {
//     String? type;
//     List<double>? coordinates;

//     Location({
//         this.type,
//         this.coordinates,
//     });

//     factory Location.fromJson(Map<String, dynamic> json) => Location(
//         type: json["type"],
//         coordinates: json["coordinates"] == null ? [] : List<double>.from(json["coordinates"]!.map((x) => x?.toDouble())),
//     );

//     Map<String, dynamic> toJson() => {
//         "type": type,
//         "coordinates": coordinates == null ? [] : List<dynamic>.from(coordinates!.map((x) => x)),
//     };
// }

// class Socialmedialink {
//     String? platform;
//     String? url;

//     Socialmedialink({
//         this.platform,
//         this.url,
//     });

//     factory Socialmedialink.fromJson(Map<String, dynamic> json) => Socialmedialink(
//         platform: json["platform"],
//         url: json["url"],
//     );

//     Map<String, dynamic> toJson() => {
//         "platform": platform,
//         "url": url,
//     };
// }
