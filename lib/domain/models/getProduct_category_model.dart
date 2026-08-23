import 'dart:convert';

ProductCategoryModel productCategoryModelFromJson(String str) =>
    ProductCategoryModel.fromJson(json.decode(str));

class ProductCategoryModel {
  String message;
  List<ProductCategoryDatum> data;
  int status;
  bool isSuccess;

  ProductCategoryModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory ProductCategoryModel.fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        message: json["Message"],
        data: List<ProductCategoryDatum>.from(
            json["Data"].map((x) => ProductCategoryDatum.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": List<dynamic>.from(data.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class ProductCategoryDatum {
  String? id;
  String? name;
  String? description;
  bool? status;
  ProductCreatedBy? createdBy;
  ProductCreatedBy? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  List<ProductCategoryDatum>? subcategories;
  String? categoryid;

  ProductCategoryDatum({
    this.id,
    this.name,
    this.description,
    this.status,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.subcategories,
    this.categoryid,
  });

  String? get categoryname => name;

  factory ProductCategoryDatum.fromJson(Map<String, dynamic> json) =>
      ProductCategoryDatum(
        id: json["_id"] ?? '',
        name: json["name"] ?? json["categoryname"] ?? '',
        description: json["description"] ?? '',
        status: json["status"] ?? false,
        createdBy: json["createdBy"] != null
            ? ProductCreatedBy.fromJson(json["createdBy"])
            : null,
        updatedBy: json["updatedBy"] != null
            ? ProductCreatedBy.fromJson(json["updatedBy"])
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime.now(),
        v: json["__v"] ?? 0,
        subcategories: json["subcategories"] == null
            ? []
            : List<ProductCategoryDatum>.from(json["subcategories"]!
                .map((x) => ProductCategoryDatum.fromJson(x))),
        categoryid: json["categoryid"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "status": status,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
        "subcategories": subcategories == null
            ? []
            : List<dynamic>.from(subcategories!.map((x) => x.toJson())),
        "categoryid": categoryid,
      };
}

class ProductCreatedBy {
  String? id;
  String? name;
  String? mobile;
  String? email;

  ProductCreatedBy({
    this.id,
    this.name,
    this.mobile,
    this.email,
  });

  factory ProductCreatedBy.fromJson(Map<String, dynamic> json) =>
      ProductCreatedBy(
        id: json["_id"],
        name: json["name"],
        mobile: json["mobile"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "mobile": mobile,
        "email": email,
      };
}
