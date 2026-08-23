// To parse this JSON data, do
//
//     final getOneProductModel = getOneProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneProductModel getOneProductModelFromJson(String str) =>
    GetOneProductModel.fromJson(json.decode(str));

String getOneProductModelToJson(GetOneProductModel data) =>
    json.encode(data.toJson());

class GetOneProductModel {
  String message;
  GetOneProductData? data;
  int status;
  bool isSuccess;

  GetOneProductModel({
    required this.message,
    this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetOneProductModel.fromJson(Map<String, dynamic> json) =>
      GetOneProductModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : GetOneProductData.fromJson(json["Data"]),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data!.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GetOneProductData {
  String? id;
  String? userid;
  GetOneProductBusinessid? businessid;
  String? name;
  List<GetParentChildCatagoryModel>? categories;
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

  GetOneProductData({
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

  factory GetOneProductData.fromJson(Map<String, dynamic> json) =>
      GetOneProductData(
        id: json["_id"] ?? '',
        userid: json["userid"] ?? '',
        businessid: json["businessid"] != null
            ? GetOneProductBusinessid.fromJson(json["businessid"])
            : null,
        name: json["name"] ?? '',
        categories: json["categories"] == null
            ? []
            : List<GetParentChildCatagoryModel>.from(json["categories"]
                .map((x) => GetParentChildCatagoryModel.fromJson(x))),
        description: json["description"] ?? '',
        price: json["price"] ?? 0,
        offer: json["offer"] ?? 0,
        offerType: json["offer_type"] ?? '',
        code: json["code"] ?? '',
        image: json["image"] ?? '',
        images: json["images"] != null
            ? List<String>.from(json["images"].map((x) => x))
            : [],
        videos: json["videos"] != null
            ? List<String>.from(json["videos"].map((x) => x))
            : [],
        status: json["status"] ?? false,
        createdBy: json["createdBy"] ?? '',
        updatedBy: json["updatedBy"] ?? '',
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime.now(),
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userid": userid,
        "businessid": businessid!.toJson(),
        "name": name,
        "categories": List<dynamic>.from(categories!.map((x) => x)),
        "description": description,
        "price": price,
        "offer": offer,
        "offer_type": offerType,
        "code": code,
        "image": image,
        "images": List<dynamic>.from(images!.map((x) => x)),
        "videos": List<dynamic>.from(videos!.map((x) => x)),
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class GetOneProductBusinessid {
  String id;
  String profileimage;
  String name;
  String about;

  GetOneProductBusinessid({
    required this.id,
    required this.profileimage,
    required this.name,
    required this.about,
  });

  factory GetOneProductBusinessid.fromJson(Map<String, dynamic> json) =>
      GetOneProductBusinessid(
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
