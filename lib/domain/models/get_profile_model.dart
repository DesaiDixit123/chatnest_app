import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

GetProfileModel getProfileModelFromJson(String str) =>
    GetProfileModel.fromJson(json.decode(str));

String getProfileModelToJson(GetProfileModel data) =>
    json.encode(data.toJson());

class GetProfileModel {
  String? message;
  ProfileData? data;
  int? status;
  bool? isSuccess;

  GetProfileModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetProfileModel.fromJson(Map<String, dynamic> json) =>
      GetProfileModel(
        message: json["Message"] ?? "",
        data: json["Data"] == null ? null : ProfileData.fromJson(json["Data"]),
        status: json["Status"] ?? 0,
        isSuccess: json["IsSuccess"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data!.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class ProfileData {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? dob;
  // String? hashtag;
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
  GetProfileCountryWiseContact? countryWiseContact;
  int? lastloginAt;
  CoordinatesLocationModel? location;
  int? lastlogoutAt;
  bool? accountStatus;
  String? recoveryEmail;
  bool? ischatnotificationallowed;
  bool? isgroupchatnotificationallowed;
  String? chatlockpin;
  String? chathidepin;
  String? s3Url;
  bool? isprofilecompleted;
  bool? readreceiptsstatus;
  bool? lastseenonlineofflinestatus;

  ProfileData({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.email,
    this.dob,
    // this.hashtag,
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
    this.countryWiseContact,
    this.lastloginAt,
    this.location,
    this.lastlogoutAt,
    this.accountStatus,
    this.recoveryEmail,
    this.ischatnotificationallowed,
    this.isgroupchatnotificationallowed,
    this.chatlockpin,
    this.chathidepin,
    this.s3Url,
    this.isprofilecompleted,
    this.readreceiptsstatus,
    this.lastseenonlineofflinestatus,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
        id: json["_id"] ?? "",
        mobile: json["mobile"] ?? "",
        countryCode: json["country_code"] ?? "",
        profileimage: json["profileimage"] ?? "",
        fullname: json["fullname"] ?? "",
        nickname: json["nickname"] ?? "",
        email: json["email"] ?? "",
        dob: json["dob"] ?? "",
        // hashtag: json["hashtag"] ?? "",
        gender: json["gender"],
        aboutme: json["aboutme"] ?? "",
        hobbies: json["hobbies"] == null
            ? []
            : List<String>.from(json["hobbies"].map((x) => x)),
        interestedin: json["interestedin"] ?? "",
        interestedagerangemin: json["interestedagerangemin"] ?? 0,
        interestedagerangemax: json["interestedagerangemax"] ?? 0,
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<Socialmedialink>.from(json["socialmedialinks"]
                .map((x) => Socialmedialink.fromJson(x))),
        fCoins: json["f_coins"] ?? 0,
        fcmToken: json["fcm_token"] ?? "",
        otpVerifyKey: json["otpVerifyKey"] ?? "",
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
        channelId: json["channelID"] ?? "",
        countryWiseContact: json["country_wise_contact"] == null
            ? null
            : GetProfileCountryWiseContact.fromJson(
                json["country_wise_contact"]),
        lastloginAt: json["lastloginAt"] ?? 0,
        location: json["location"] == null
            ? null
            : CoordinatesLocationModel.fromJson(json["location"]),
        lastlogoutAt: json["lastlogoutAt"],
        accountStatus: json["account_status"],
        recoveryEmail: json["recovery_email"],
        ischatnotificationallowed: json["ischatnotificationallowed"],
        isgroupchatnotificationallowed: json["isgroupchatnotificationallowed"],
        chatlockpin: json["chatlockpin"] ?? "",
        chathidepin: json["chathidepin"] ?? "",
        s3Url: json["s3Url"] ?? "",
        isprofilecompleted: json["isprofilecompleted"] ?? false,
        readreceiptsstatus: json["readreceiptsstatus"],
        lastseenonlineofflinestatus: json["lastseenonlineofflinestatus"],
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
        // "hashtag": hashtag,
        "gender": gender,
        "aboutme": aboutme,
        "hobbies": List<dynamic>.from(hobbies!.map((x) => x)),
        "interestedin": interestedin,
        "interestedagerangemin": interestedagerangemin,
        "interestedagerangemax": interestedagerangemax,
        "socialmedialinks":
            List<dynamic>.from(socialmedialinks!.map((x) => x.toJson())),
        "f_coins": fCoins,
        "fcm_token": fcmToken,
        "otpVerifyKey": otpVerifyKey,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "channelID": channelId,
        "country_wise_contact": countryWiseContact!.toJson(),
        "lastloginAt": lastloginAt,
        "location": location!.toJson(),
        "lastlogoutAt": lastlogoutAt,
        "account_status": accountStatus,
        "recovery_email": recoveryEmail,
        "ischatnotificationallowed": ischatnotificationallowed,
        "isgroupchatnotificationallowed": isgroupchatnotificationallowed,
        "chatlockpin": chatlockpin,
        "chathidepin": chathidepin,
        "s3Url": s3Url,
        "isprofilecompleted": isprofilecompleted,
        "readreceiptsstatus": readreceiptsstatus,
        "lastseenonlineofflinestatus": lastseenonlineofflinestatus,
      };

  asMap() {}
}

class GetProfileCountryWiseContact {
  String? number;
  String? internationalNumber;
  String? nationalNumber;
  String? e164Number;
  String? countryCode;
  String? dialCode;

  GetProfileCountryWiseContact({
    required this.number,
    required this.internationalNumber,
    required this.nationalNumber,
    required this.e164Number,
    required this.countryCode,
    required this.dialCode,
  });

  factory GetProfileCountryWiseContact.fromJson(Map<String, dynamic> json) =>
      GetProfileCountryWiseContact(
        number: json["number"] ?? "",
        internationalNumber: json["internationalNumber"] ?? "",
        nationalNumber: json["nationalNumber"] ?? "",
        e164Number: json["e164Number"] ?? "",
        countryCode: json["countryCode"] ?? "",
        dialCode: json["dialCode"] ?? "",
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

class CoordinatesLocationModel {
  String type;
  List<double> coordinates;

  CoordinatesLocationModel({
    required this.type,
    required this.coordinates,
  });

  factory CoordinatesLocationModel.fromJson(Map<String, dynamic> json) =>
      // Handle missing/null location data gracefully
      CoordinatesLocationModel(
        type: json["type"] ?? "",
        coordinates: json["coordinates"] == null
            ? <double>[]
            : List<double>.from((json["coordinates"] as List)
                .where((x) => x != null)
                .map((x) {
                if (x is num) return x.toDouble();
                return double.tryParse(x.toString()) ?? 0.0;
              })),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class ProfileSocialmedialink {
  String platform;
  String url;

  ProfileSocialmedialink({
    required this.platform,
    required this.url,
  });

  factory ProfileSocialmedialink.fromJson(Map<String, dynamic> json) =>
      ProfileSocialmedialink(
        platform: json["platform"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "url": url,
      };
}
