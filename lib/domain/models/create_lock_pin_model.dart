// To parse this JSON data, do
//
//     final createLockPinModel = createLockPinModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

CreateLockPinModel createLockPinModelFromJson(String str) =>
    CreateLockPinModel.fromJson(json.decode(str));

String createLockPinModelToJson(CreateLockPinModel data) =>
    json.encode(data.toJson());

class CreateLockPinModel {
  String? message;
  CreateLockPinData? data;
  int? status;
  bool? isSuccess;

  CreateLockPinModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory CreateLockPinModel.fromJson(Map<String, dynamic> json) =>
      CreateLockPinModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : CreateLockPinData.fromJson(json["Data"]),
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

class CreateLockPinData {
  String? token;
  Userdata? userdata;

  CreateLockPinData({
    this.token,
    this.userdata,
  });

  factory CreateLockPinData.fromJson(Map<String, dynamic> json) =>
      CreateLockPinData(
        token: json["token"],
        userdata: json["userdata"] == null
            ? null
            : Userdata.fromJson(json["userdata"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token,
        "userdata": userdata?.toJson(),
      };
}

class Userdata {
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
  String? channelId;
  String? recoveryEmail;
  bool? ischatnotificationallowed;
  bool? isgroupchatnotificationallowed;
  String? chatlockpin;
  String? chathidepin;
  bool? accountStatus;
  String? otpVerifyKey;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? lastloginAt;
  AddressLocation? location;
  String? isfriend;

  Userdata({
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
    this.channelId,
    this.recoveryEmail,
    this.ischatnotificationallowed,
    this.isgroupchatnotificationallowed,
    this.chatlockpin,
    this.chathidepin,
    this.accountStatus,
    this.otpVerifyKey,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.lastloginAt,
    this.location,
    this.isfriend,
  });

  factory Userdata.fromJson(Map<String, dynamic> json) => Userdata(
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
        channelId: json["channelID"],
        recoveryEmail: json["recovery_email"],
        ischatnotificationallowed: json["ischatnotificationallowed"],
        isgroupchatnotificationallowed: json["isgroupchatnotificationallowed"],
        chatlockpin: json["chatlockpin"],
        chathidepin: json["chathidepin"],
        accountStatus: json["account_status"],
        otpVerifyKey: json["otpVerifyKey"],
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        lastloginAt: json["lastloginAt"],
        location: json["location"] == null
            ? null
            : AddressLocation.fromJson(json["location"]),
        isfriend: json["isfriend"],
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
        "channelID": channelId,
        "recovery_email": recoveryEmail,
        "ischatnotificationallowed": ischatnotificationallowed,
        "isgroupchatnotificationallowed": isgroupchatnotificationallowed,
        "chatlockpin": chatlockpin,
        "chathidepin": chathidepin,
        "account_status": accountStatus,
        "otpVerifyKey": otpVerifyKey,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "lastloginAt": lastloginAt,
        "location": location?.toJson(),
        "isfriend": isfriend,
      };
}
