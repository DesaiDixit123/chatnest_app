// To parse this JSON data, do
//
//     final getProductListModel = getProductListModelFromJson(jsonString);

import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetProductListModel getProductListModelFromJson(String str) =>
    GetProductListModel.fromJson(json.decode(str));

String getProductListModelToJson(GetProductListModel data) =>
    json.encode(data.toJson());

class GetProductListModel {
  String message;
  GetProductListData data;
  int status;
  bool isSuccess;

  GetProductListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetProductListModel.fromJson(Map<String, dynamic> json) =>
      GetProductListModel(
        message: json["Message"],
        data: GetProductListData.fromJson(json["Data"]),
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

class GetProductListData {
  List<GetProductListDoc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  GetProductListData({
    required this.docs,
    required this.totalDocs,
    required this.limit,
    required this.totalPages,
    required this.page,
    required this.pagingCounter,
    required this.hasPrevPage,
    required this.hasNextPage,
    required this.prevPage,
    required this.nextPage,
  });

  factory GetProductListData.fromJson(Map<String, dynamic> json) =>
      GetProductListData(
        docs: List<GetProductListDoc>.from(
            json["docs"].map((x) => GetProductListDoc.fromJson(x))),
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
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
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

class GetProductListDoc {
  String id;
  String userid;
  GetProductListBusinessid businessid;
  String name;
  List<GetParentChildCatagoryModel> categories;
  String description;
  int price;
  int offer;
  String offerType;
  String code;
  String image;
  List<String> images;
  List<dynamic> videos;
  bool status;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  String docId;

  GetProductListDoc({
    required this.id,
    required this.userid,
    required this.businessid,
    required this.name,
    required this.categories,
    required this.description,
    required this.price,
    required this.offer,
    required this.offerType,
    required this.code,
    required this.image,
    required this.images,
    required this.videos,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.docId,
  });

  factory GetProductListDoc.fromJson(Map<String, dynamic> json) =>
      GetProductListDoc(
        id: json["_id"],
        userid: json["userid"],
        businessid: GetProductListBusinessid.fromJson(json["businessid"]),
        name: json["name"],
        categories: List<GetParentChildCatagoryModel>.from(json["categories"]
            .map((x) => GetParentChildCatagoryModel.fromJson(x))),
        description: json["description"],
        price: json["price"],
        offer: json["offer"],
        offerType: json["offer_type"],
        code: json["code"],
        image: json["image"],
        images: List<String>.from(json["images"].map((x) => x)),
        videos: List<dynamic>.from(json["videos"].map((x) => x)),
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
        docId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userid": userid,
        "businessid": businessid.toJson(),
        "name": name,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "description": description,
        "price": price,
        "offer": offer,
        "offer_type": offerType,
        "code": code,
        "image": image,
        "images": List<dynamic>.from(images.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
        "id": docId,
      };
}

class GetProductListBusinessid {
  String id;
  String profileimage;
  String name;
  String about;

  GetProductListBusinessid({
    required this.id,
    required this.profileimage,
    required this.name,
    required this.about,
  });

  factory GetProductListBusinessid.fromJson(Map<String, dynamic> json) =>
      GetProductListBusinessid(
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

class GetProductListParentCategory {
  String id;
  String name;
  String description;
  bool status;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  GetProductListParentCategory({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory GetProductListParentCategory.fromJson(Map<String, dynamic> json) =>
      GetProductListParentCategory(
        id: json["_id"],
        name: json["name"] ?? json["categoryname"],
        description: json["description"],
        status: json["status"],
        createdBy: json["createdBy"],
        updatedBy: json["updatedBy"],
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}
