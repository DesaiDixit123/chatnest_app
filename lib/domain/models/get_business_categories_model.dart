import 'dart:convert';

GetBusinessCategoriesModel getBusinessCategoriesModelFromJson(String str) =>
    GetBusinessCategoriesModel.fromJson(json.decode(str));

class GetBusinessCategoriesModel {
  String? message;
  List<CategoriesData>? data;
  int? status;
  bool? isSuccess;

  GetBusinessCategoriesModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory GetBusinessCategoriesModel.fromJson(Map<String, dynamic> json) =>
      GetBusinessCategoriesModel(
        message: json["Message"],
        data: List<CategoriesData>.from(
            json["Data"].map((x) => CategoriesData.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": List<dynamic>.from(data!.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class CategoriesData {
  String id;
  String name;
  String description;
  bool status;
  String createdBy;
  String updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  List<CategoriesData>? subcategories;
  String? categoryid;

  CategoriesData({
    required this.id,
    required this.name,
    required this.description,
    required this.status,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    this.subcategories,
    this.categoryid,
  });

  String get categoryname => name;

  factory CategoriesData.fromJson(Map<String, dynamic> json) => CategoriesData(
        id: json["_id"] ?? "",
        name: json["name"] ?? json["categoryname"] ?? "",
        description: json["description"] ?? "",
        status: json["status"] ?? false,
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime.now(),
        v: json["__v"] ?? 0,
        subcategories: json["subcategories"] == null
            ? []
            : List<CategoriesData>.from(
                json["subcategories"]!.map((x) => CategoriesData.fromJson(x))),
        categoryid: json["categoryid"],
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
        "subcategories": subcategories == null
            ? []
            : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
        "categoryid": categoryid,
      };
}
