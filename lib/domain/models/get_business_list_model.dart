import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetBusinessListModel getBusinessListModelFromJson(String str) =>
    GetBusinessListModel.fromJson(json.decode(str));

class GetBusinessListModel {
  String message;
  List<GetBusinessDatum> data;
  int status;
  bool isSuccess;

  GetBusinessListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetBusinessListModel.fromJson(Map<String, dynamic> json) =>
      GetBusinessListModel(
        message: json["Message"],
        data: List<GetBusinessDatum>.from(
            json["Data"].map((x) => GetBusinessDatum.fromJson(x))),
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

class GetBusinessDatum {
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
  List<dynamic>? videos;
  GetBusinessAddress? address;
  List<GetBusinesshour>? businesshours;
  List<GetBusinessSocialmedialink>? socialmedialinks;
  CoordinatesLocationModel? location;
  bool? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GetBusinessDatum({
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
  });

  factory GetBusinessDatum.fromJson(Map<String, dynamic> json) =>
      GetBusinessDatum(
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
            : List<dynamic>.from(json["videos"].map((x) => x)),
        address: json["address"] == null
            ? null
            : GetBusinessAddress.fromJson(json["address"]),
        businesshours: json["businesshours"] == null
            ? []
            : List<GetBusinesshour>.from(
                json["businesshours"].map((x) => GetBusinesshour.fromJson(x))),
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<GetBusinessSocialmedialink>.from(json["socialmedialinks"]
                .map((x) => GetBusinessSocialmedialink.fromJson(x))),
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
      };
}

class GetBusinessAddress {
  String flatno;
  String street;
  String area;
  String city;
  String state;
  String pincode;

  GetBusinessAddress({
    required this.flatno,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory GetBusinessAddress.fromJson(Map<String, dynamic> json) =>
      GetBusinessAddress(
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

class GetBusinesshour {
  String day;
  bool open;
  List<GetBusinessTime> time;

  GetBusinesshour({
    required this.day,
    required this.open,
    required this.time,
  });

  factory GetBusinesshour.fromJson(Map<String, dynamic> json) =>
      GetBusinesshour(
        day: json["day"],
        open: json["open"],
        time: List<GetBusinessTime>.from(
            json["time"].map((x) => GetBusinessTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "open": open,
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class GetBusinessTime {
  String starttime;
  String endtime;

  GetBusinessTime({
    required this.starttime,
    required this.endtime,
  });

  factory GetBusinessTime.fromJson(Map<String, dynamic> json) =>
      GetBusinessTime(
        starttime: json["starttime"],
        endtime: json["endtime"],
      );

  Map<String, dynamic> toJson() => {
        "starttime": starttime,
        "endtime": endtime,
      };
}

class GetParentChildCatagoryModel {
  GetBusinessParentCategory parentCategory;
  List<GetBusinessParentCategory> childCategories;

  GetParentChildCatagoryModel({
    required this.parentCategory,
    required this.childCategories,
  });

  factory GetParentChildCatagoryModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json["child_categories"];

    List<GetBusinessParentCategory> parsedChildren = [];

    if (rawChildren is List) {
      for (var item in rawChildren) {
        // ✅ If API sends full object
        if (item is Map<String, dynamic>) {
          parsedChildren.add(GetBusinessParentCategory.fromJson(item));
        }

        // ✅ If API sends only ID string (current case)
        else if (item is String) {
          parsedChildren.add(
            GetBusinessParentCategory(
              id: item,
              name: "", // fallback
              description: "",
              status: false,
              createdBy: "",
              updatedBy: "",
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
              v: 0,
            ),
          );
        }
      }
    }

    return GetParentChildCatagoryModel(
      parentCategory:
          GetBusinessParentCategory.fromJson(json["parent_category"]),
      childCategories: parsedChildren,
    );
  }

  Map<String, dynamic> toJson() => {
        "parent_category": parentCategory.toJson(),
        "child_categories": childCategories.map((x) => x.toJson()).toList(),
      };
}

class GetBusinessParentCategory {
  String? id;
  String? name;
  String? description;
  bool? status;
  String? createdBy;
  String? updatedBy;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;

  GetBusinessParentCategory({
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

  String? get categoryname => name;

  factory GetBusinessParentCategory.fromJson(Map<String, dynamic> json) =>
      GetBusinessParentCategory(
        id: json["_id"] ?? "",
        name: json["name"] ?? json["categoryname"] ?? "",
        description: json["description"] ?? "",
        status: json["status"] ?? false,
        createdBy: json["createdBy"] ?? "",
        updatedBy: json["updatedBy"] ?? "",
        createdAt: json["createdAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["createdAt"]),
        updatedAt: json["updatedAt"] == null
            ? DateTime.now()
            : DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "status": status,
        "createdBy": createdBy,
        "updatedBy": updatedBy,
        "createdAt": createdAt!.toIso8601String(),
        "updatedAt": updatedAt!.toIso8601String(),
        "__v": v,
      };
}

class GetBusinessSocialmedialink {
  String platform;
  String url;

  GetBusinessSocialmedialink({
    required this.platform,
    required this.url,
  });

  factory GetBusinessSocialmedialink.fromJson(Map<String, dynamic> json) =>
      GetBusinessSocialmedialink(
        platform: json["platform"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "url": url,
      };
}
