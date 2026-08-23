// To parse this JSON data, do
//
//     final getOneFriendProductModel = getOneFriendProductModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneFriendProductModel getOneFriendProductModelFromJson(String str) =>
    GetOneFriendProductModel.fromJson(json.decode(str));

String getOneFriendProductModelToJson(GetOneFriendProductModel data) =>
    json.encode(data.toJson());

class GetOneFriendProductModel {
  String? message;
  GetOneFriendProductData? data;
  int? status;
  bool? isSuccess;

  GetOneFriendProductModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetOneFriendProductModel.fromJson(Map<String, dynamic> json) =>
      GetOneFriendProductModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : GetOneFriendProductData.fromJson(json["Data"]),
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

class GetOneFriendProductData {
  FriendProductData? productdata;
  List<FriendProductData>? otherproductdata;
  Userdata? userdata;

  GetOneFriendProductData({
    this.productdata,
    this.otherproductdata,
    this.userdata,
  });

  factory GetOneFriendProductData.fromJson(Map<String, dynamic> json) =>
      GetOneFriendProductData(
        productdata: json["productdata"] == null
            ? null
            : FriendProductData.fromJson(json["productdata"]),
        otherproductdata: json["otherproductdata"] == null
            ? []
            : List<FriendProductData>.from(json["otherproductdata"]!
                .map((x) => FriendProductData.fromJson(x))),
        userdata: json["userdata"] == null
            ? null
            : Userdata.fromJson(json["userdata"]),
      );

  Map<String, dynamic> toJson() => {
        "productdata": productdata?.toJson(),
        "otherproductdata": otherproductdata == null
            ? []
            : List<dynamic>.from(otherproductdata!.map((x) => x.toJson())),
        "userdata": userdata?.toJson(),
      };
}

// class GetOneFriendData {
//   String? id;
//   Userid? userid;
//   Businessid? businessid;
//   String? name;
//   List<Category>? categories;
//   String? description;
//   int? price;
//   int? offer;
//   String? offerType;
//   String? code;
//   String? image;
//   List<String>? images;
//   List<String>? videos;
//   bool? status;
//   String? createdBy;
//   String? updatedBy;
//   DateTime? createdAt;
//   DateTime? updatedAt;
//   int? v;

//   GetOneFriendData({
//     this.id,
//     this.userid,
//     this.businessid,
//     this.name,
//     this.categories,
//     this.description,
//     this.price,
//     this.offer,
//     this.offerType,
//     this.code,
//     this.image,
//     this.images,
//     this.videos,
//     this.status,
//     this.createdBy,
//     this.updatedBy,
//     this.createdAt,
//     this.updatedAt,
//     this.v,
//   });

//   factory GetOneFriendData.fromJson(Map<String, dynamic> json) =>
//       GetOneFriendData(
//         id: json["_id"],
//         userid: json["userid"] == null ? null : Userid.fromJson(json["userid"]),
//         businessid: json["businessid"] == null
//             ? null
//             : Businessid.fromJson(json["businessid"]),
//         name: json["name"],
//         categories: json["categories"] == null
//             ? []
//             : List<Category>.from(
//                 json["categories"]!.map((x) => Category.fromJson(x))),
//         description: json["description"],
//         price: json["price"],
//         offer: json["offer"],
//         offerType: json["offer_type"],
//         code: json["code"],
//         image: json["image"],
//         images: json["images"] == null
//             ? []
//             : List<String>.from(json["images"]!.map((x) => x)),
//         videos: json["videos"] == null
//             ? []
//             : List<String>.from(json["videos"]!.map((x) => x)),
//         status: json["status"],
//         createdBy: json["createdBy"],
//         updatedBy: json["updatedBy"],
//         createdAt: json["createdAt"] == null
//             ? null
//             : DateTime.parse(json["createdAt"]),
//         updatedAt: json["updatedAt"] == null
//             ? null
//             : DateTime.parse(json["updatedAt"]),
//         v: json["__v"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "userid": userid?.toJson(),
//         "businessid": businessid?.toJson(),
//         "name": name,
//         "categories": categories == null
//             ? []
//             : List<dynamic>.from(categories!.map((x) => x.toJson())),
//         "description": description,
//         "price": price,
//         "offer": offer,
//         "offer_type": offerType,
//         "code": code,
//         "image": image,
//         "images":
//             images == null ? [] : List<dynamic>.from(images!.map((x) => x)),
//         "videos":
//             videos == null ? [] : List<dynamic>.from(videos!.map((x) => x)),
//         "status": status,
//         "createdBy": createdBy,
//         "updatedBy": updatedBy,
//         "createdAt": createdAt?.toIso8601String(),
//         "updatedAt": updatedAt?.toIso8601String(),
//         "__v": v,
//       };
// }

// class Businessid {
//   String? id;
//   String? profileimage;
//   String? name;
//   String? about;

//   Businessid({
//     this.id,
//     this.profileimage,
//     this.name,
//     this.about,
//   });

//   factory Businessid.fromJson(Map<String, dynamic> json) => Businessid(
//         id: json["_id"],
//         profileimage: json["profileimage"],
//         name: json["name"],
//         about: json["about"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "profileimage": profileimage,
//         "name": name,
//         "about": about,
//       };
// }

class Category {
  ParentCategoryElement? parentCategory;
  List<ParentCategoryElement>? childCategories;

  Category({
    this.parentCategory,
    this.childCategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        parentCategory: json["parent_category"] == null
            ? null
            : ParentCategoryElement.fromJson(json["parent_category"]),
        childCategories: json["child_categories"] == null
            ? []
            : List<ParentCategoryElement>.from(json["child_categories"]!
                .map((x) => ParentCategoryElement.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "parent_category": parentCategory?.toJson(),
        "child_categories": childCategories == null
            ? []
            : List<dynamic>.from(childCategories!.map((x) => x.toJson())),
      };
}

class ParentCategoryElement {
  String? id;
  String? name;
  String? categoryid;
  String? description;
  bool? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  ParentCategoryElement({
    this.id,
    this.name,
    this.categoryid,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ParentCategoryElement.fromJson(Map<String, dynamic> json) =>
      ParentCategoryElement(
        id: json["_id"],
        name: json["name"] ?? json["categoryname"],
        categoryid: json["categoryid"],
        description: json["description"],
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
        "name": name,
        "categoryid": categoryid,
        "description": description,
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
      };
}

// class Userid {
//   String? id;
//   String? mobile;
//   String? countryCode;
//   String? profileimage;
//   String? fullname;
//   String? nickname;
//   String? email;
//   String? hashtag;
//   String? aboutme;

//   Userid({
//     this.id,
//     this.mobile,
//     this.countryCode,
//     this.profileimage,
//     this.fullname,
//     this.nickname,
//     this.email,
//     this.hashtag,
//     this.aboutme,
//   });

//   factory Userid.fromJson(Map<String, dynamic> json) => Userid(
//         id: json["_id"],
//         mobile: json["mobile"],
//         countryCode: json["country_code"],
//         profileimage: json["profileimage"],
//         fullname: json["fullname"],
//         nickname: json["nickname"],
//         email: json["email"],
//         hashtag: json["hashtag"],
//         aboutme: json["aboutme"],
//       );

//   Map<String, dynamic> toJson() => {
//         "_id": id,
//         "mobile": mobile,
//         "country_code": countryCode,
//         "profileimage": profileimage,
//         "fullname": fullname,
//         "nickname": nickname,
//         "email": email,
//         "hashtag": hashtag,
//         "aboutme": aboutme,
//       };
// }
