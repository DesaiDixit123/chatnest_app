// To parse this JSON data, do
//
//     final getOneBusinessModel = getOneBusinessModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneBusinessModel getOneBusinessModelFromJson(String str) =>
    GetOneBusinessModel.fromJson(json.decode(str));

String getOneBusinessModelToJson(GetOneBusinessModel data) =>
    json.encode(data.toJson());

class GetOneBusinessModel {
  String message;
  GetOneBusinessData data;
  int status;
  bool isSuccess;

  GetOneBusinessModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetOneBusinessModel.fromJson(Map<String, dynamic> json) =>
      GetOneBusinessModel(
        message: json["Message"],
        data: GetOneBusinessData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GetOneBusinessData {
  String? id;
  String? userid;
  String? profileimage;
  String? name;
  List<GetParentChildCatagoryModel>? categories;
  String? about;
  String? mobile;
  String? mobileCountryCode;
  String? wamobile;
  String? wamobileCountryCode;
  String? email;
  String? website;
  List<GetParentChildCatagoryModel>? interestedCategories;
  List<String>? brochures;
  List<String>? photos;
  List<String>? videos;
  GetOneBusinessAddress? address;
  List<AddBusinessBusinesshour>? businesshours;
  List<Socialmedialink>? socialmedialinks;
  CoordinatesLocationModel? location;
  bool? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  AddBusinessMobileCountryWiseContact? mobileCountryWiseContact;
  AddBusinessMobileCountryWiseContact? wamobileCountryWiseContact;

  GetOneBusinessData({
    this.id,
    this.userid,
    this.profileimage,
    this.name,
    this.categories,
    this.about,
    this.mobile,
    this.mobileCountryCode,
    this.wamobile,
    this.wamobileCountryCode,
    this.email,
    this.website,
    this.interestedCategories,
    this.brochures,
    this.photos,
    this.videos,
    this.address,
    this.businesshours,
    this.socialmedialinks,
    this.location,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.mobileCountryWiseContact,
    this.wamobileCountryWiseContact,
  });

  factory GetOneBusinessData.fromJson(Map<String, dynamic> json) =>
      GetOneBusinessData(
        id: json["_id"] ?? "" ?? "",
        userid: json["userid"] ?? "",
        profileimage: json["profileimage"] ?? "",
        name: json["name"] ?? "",
        categories: json["categories"] == null
            ? []
            : List<GetParentChildCatagoryModel>.from(json["categories"]
                .where((x) => x != null && x["parent_category"] != null)
                .map((x) => GetParentChildCatagoryModel.fromJson(x))),
        about: json["about"] ?? "",
        mobile: json["mobile"] ?? "",
        mobileCountryCode: json["mobile_country_code"] ?? "",
        wamobile: json["wamobile"] ?? "",
        wamobileCountryCode: json["wamobile_country_code"] ?? "",
        email: json["email"] ?? "",
        website: json["website"] ?? "",
        interestedCategories: json["interested_categories"] != null
            ? List<GetParentChildCatagoryModel>.from(
                json["interested_categories"]
                    .where((x) => x != null && x["parent_category"] != null)
                    .map((x) => GetParentChildCatagoryModel.fromJson(x)))
            : [],
        brochures: json["brochures"] == null
            ? []
            : List<String>.from(json["brochures"].map((x) => x)),
        photos: json["photos"] == null
            ? []
            : List<String>.from(json["photos"].map((x) => x)),
        videos: json["videos"] == null
            ? []
            : List<String>.from(json["videos"].map((x) => x)),
        address: json["address"] == null
            ? null
            : GetOneBusinessAddress.fromJson(json["address"]),
        businesshours: json["businesshours"] == null
            ? []
            : List<AddBusinessBusinesshour>.from(json["businesshours"]
                .map((x) => AddBusinessBusinesshour.fromJson(x))),
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<Socialmedialink>.from(json["socialmedialinks"]
                .map((x) => Socialmedialink.fromJson(x))),
        location: json["location"] == null
            ? null
            : CoordinatesLocationModel.fromJson(json["location"]),
        status: json["status"] ?? false,
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"] ?? 0,
        mobileCountryWiseContact: json["mobile_country_wise_contact"] == null
            ? null
            : AddBusinessMobileCountryWiseContact.fromJson(
                json["mobile_country_wise_contact"]),
        wamobileCountryWiseContact:
            json["wamobile_country_wise_contact"] == null
                ? null
                : AddBusinessMobileCountryWiseContact.fromJson(
                    json["wamobile_country_wise_contact"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userid": userid,
        "profileimage": profileimage,
        "name": name,
        "categories": List<dynamic>.from(categories!.map((x) => x.toJson())),
        "about": about,
        "mobile": mobile,
        "mobile_country_code": mobileCountryCode,
        "wamobile": wamobile,
        "wamobile_country_code": wamobileCountryCode,
        "email": email,
        "website": website,
        "interested_categories":
            List<dynamic>.from(interestedCategories!.map((x) => x.toJson())),
        "brochures": List<dynamic>.from(brochures!.map((x) => x)),
        "photos": List<dynamic>.from(photos!.map((x) => x)),
        "videos": List<dynamic>.from(videos!.map((x) => x)),
        "address": address!.toJson(),
        "businesshours":
            List<dynamic>.from(businesshours!.map((x) => x.toJson())),
        "socialmedialinks":
            List<dynamic>.from(socialmedialinks!.map((x) => x.toJson())),
        "location": location!.toJson(),
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "mobile_country_wise_contact": mobileCountryWiseContact?.toJson(),
        "wamobile_country_wise_contact": wamobileCountryWiseContact?.toJson(),
      };
}

class GetOneBusinessAddress {
  String flatno;
  String street;
  String area;
  String city;
  String state;
  String pincode;

  GetOneBusinessAddress({
    required this.flatno,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory GetOneBusinessAddress.fromJson(Map<String, dynamic> json) =>
      GetOneBusinessAddress(
        flatno: json["flatno"],
        street: json["street"],
        area: json["area"],
        city: json["city"],
        state: json["state"],
        pincode: json["pincode"],
      );

  Map<String, dynamic> toJson() => {
        "flatno": flatno,
        "street": street,
        "area": area,
        "city": city,
        "state": state,
        "pincode": pincode,
      };
}

class GetOneBusinesshour {
  String day;
  bool open;
  List<GetOneBusinessTime> time;

  GetOneBusinesshour({
    required this.day,
    required this.open,
    required this.time,
  });

  factory GetOneBusinesshour.fromJson(Map<String, dynamic> json) =>
      GetOneBusinesshour(
        day: json["day"],
        open: json["open"],
        time: List<GetOneBusinessTime>.from(
            json["time"].map((x) => GetOneBusinessTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "open": open,
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class GetOneBusinessTime {
  String starttime;
  String endtime;

  GetOneBusinessTime({
    required this.starttime,
    required this.endtime,
  });

  factory GetOneBusinessTime.fromJson(Map<String, dynamic> json) =>
      GetOneBusinessTime(
        starttime: json["starttime"],
        endtime: json["endtime"],
      );

  Map<String, dynamic> toJson() => {
        "starttime": starttime,
        "endtime": endtime,
      };
}

class GetOneBusinessSocialmedialink {
  String platform;
  String url;

  GetOneBusinessSocialmedialink({
    required this.platform,
    required this.url,
  });

  factory GetOneBusinessSocialmedialink.fromJson(Map<String, dynamic> json) =>
      GetOneBusinessSocialmedialink(
        platform: json["platform"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "url": url,
      };
}
