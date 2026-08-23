// To parse this JSON data, do
//
//     final friendProductModel = friendProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

FriendProductModel friendProductModelFromJson(String str) =>
    FriendProductModel.fromJson(json.decode(str));

String friendProductModelToJson(FriendProductModel data) =>
    json.encode(data.toJson());

class FriendProductModel {
  String? message;
  List<FriendProductData>? data;
  int? status;
  bool? isSuccess;

  FriendProductModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory FriendProductModel.fromJson(Map<String, dynamic> json) =>
      FriendProductModel(
        message: json["Message"],
        data: json["Data"] == null
            ? []
            : List<FriendProductData>.from(
                json["Data"]!.map((x) => FriendProductData.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class FriendProductData {
  String? id;
  FriendProductUserid? userid;
  FriendProductBusinessid? businessid;
  String? name;
  List<Category>? categories;
  String? description;
  int? price;
  int? offer;
  String? offerType;
  String? code;
  String? image;
  List<String>? images;
  List<String>? videos;
  bool? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  FriendProductData({
    this.id,
    this.userid,
    this.businessid,
    this.name,
    this.categories,
    this.description,
    this.price,
    this.offer,
    this.offerType,
    this.code,
    this.image,
    this.images,
    this.videos,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory FriendProductData.fromJson(Map<String, dynamic> json) =>
      FriendProductData(
        id: json["_id"],
        userid: json["userid"] == null
            ? null
            : FriendProductUserid.fromJson(json["userid"]),
        businessid: json["businessid"] == null
            ? null
            : FriendProductBusinessid.fromJson(json["businessid"]),
        name: json["name"],
        categories: json["categories"] == null
            ? []
            : List<Category>.from(
                json["categories"]!.map((x) => Category.fromJson(x))),
        description: json["description"],
        price: json["price"],
        offer: json["offer"],
        offerType: json["offer_type"],
        code: json["code"],
        image: json["image"],
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"]!.map((x) => x)),
        videos: json["videos"] == null
            ? []
            : List<String>.from(json["videos"]!.map((x) => x)),
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
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
        "userid": userid?.toJson(),
        "businessid": businessid?.toJson(),
        "name": name,
        "categories": categories == null
            ? []
            : List<dynamic>.from(categories!.map((x) => x.toJson())),
        "description": description,
        "price": price,
        "offer": offer,
        "offer_type": offerType,
        "code": code,
        "image": image,
        "images":
            images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
        "videos":
            videos == null ? [] : List<dynamic>.from(videos!.map((x) => x)),
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

class FriendProductBusinessid {
  String? id;
  String? profileimage;
  String? name;
  String? about;

  FriendProductBusinessid({
    this.id,
    this.profileimage,
    this.name,
    this.about,
  });

  factory FriendProductBusinessid.fromJson(Map<String, dynamic> json) =>
      FriendProductBusinessid(
        id: json["_id"],
        profileimage: json["profileimage"],
        name: json["name"],
        about: json["about"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "profileimage": profileimage,
        "name": name,
        "about": about,
      };
}

class FriendProductUserid {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? email;
  String? hashtag;
  String? aboutme;

  FriendProductUserid({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.email,
    this.hashtag,
    this.aboutme,
  });

  factory FriendProductUserid.fromJson(Map<String, dynamic> json) =>
      FriendProductUserid(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        hashtag: json["hashtag"],
        aboutme: json["aboutme"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "hashtag": hashtag,
        "aboutme": aboutme,
      };
}
