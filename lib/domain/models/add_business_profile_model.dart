import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

AddBusinessProfileModel addBusinessProfileModelFromJson(String str) =>
    AddBusinessProfileModel.fromJson(json.decode(str));

class AddBusinessProfileModel {
  String businessid;
  String profileimage;
  String name;
  List<AddBusinessCategory> categories;
  String about;
  String mobile;
  String mobileCountryCode;
  AddBusinessMobileCountryWiseContact? mobileCountryWiseContact;
  String wamobile;
  String wamobileCountryCode;
  AddBusinessMobileCountryWiseContact? wamobileCountryWiseContact;
  String email;
  String website;
  List<AddBusinessCategory> interestedCategories;
  List<String> brochures;
  List<String> photos;
  List<String> videos;
  AddBusinessAddress address;
  double latitude;
  double longitude;
  List<AddBusinessBusinesshour> businesshours;
  List<Socialmedialink> socialmedialinks;

  AddBusinessProfileModel({
    required this.businessid,
    required this.profileimage,
    required this.name,
    required this.categories,
    required this.about,
    required this.mobile,
    required this.mobileCountryCode,
    this.mobileCountryWiseContact,
    required this.wamobile,
    required this.wamobileCountryCode,
    this.wamobileCountryWiseContact,
    required this.email,
    required this.website,
    required this.interestedCategories,
    required this.brochures,
    required this.photos,
    required this.videos,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.businesshours,
    required this.socialmedialinks,
  });

  factory AddBusinessProfileModel.fromJson(Map<String, dynamic> json) =>
      AddBusinessProfileModel(
        businessid: json["businessid"],
        profileimage: json["profileimage"],
        name: json["name"],
        categories: List<AddBusinessCategory>.from(
            json["categories"].map((x) => AddBusinessCategory.fromJson(x))),
        about: json["about"],
        mobile: json["mobile"],
        mobileCountryCode: json["mobile_country_code"],
        mobileCountryWiseContact: json["mobile_country_wise_contact"] == null
            ? null
            : AddBusinessMobileCountryWiseContact.fromJson(
                json["mobile_country_wise_contact"]),
        wamobile: json["wamobile"],
        wamobileCountryCode: json["wamobile_country_code"],
        wamobileCountryWiseContact:
            json["wamobile_country_wise_contact"] == null
                ? null
                : AddBusinessMobileCountryWiseContact.fromJson(
                    json["wamobile_country_wise_contact"]),
        email: json["email"],
        website: json["website"],
        interestedCategories: List<AddBusinessCategory>.from(
            json["interested_categories"]
                .map((x) => AddBusinessCategory.fromJson(x))),
        brochures: List<String>.from(json["brochures"].map((x) => x)),
        photos: List<String>.from(json["photos"].map((x) => x)),
        videos: List<String>.from(json["videos"].map((x) => x)),
        address: AddBusinessAddress.fromJson(json["address"]),
        latitude: json["latitude"]?.toDouble(),
        longitude: json["longitude"]?.toDouble(),
        businesshours: List<AddBusinessBusinesshour>.from(json["businesshours"]
            .map((x) => AddBusinessBusinesshour.fromJson(x))),
        socialmedialinks: List<Socialmedialink>.from(
            json["socialmedialinks"].map((x) => Socialmedialink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "businessid": businessid,
        "profileimage": profileimage,
        "name": name,
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "about": about,
        "mobile": mobile,
        "mobile_country_code": mobileCountryCode,
        "mobile_country_wise_contact": mobileCountryWiseContact!.toJson(),
        "wamobile": wamobile,
        "wamobile_country_code": wamobileCountryCode,
        "wamobile_country_wise_contact": wamobileCountryWiseContact!.toJson(),
        "email": email,
        "website": website,
        "interested_categories":
            List<dynamic>.from(interestedCategories.map((x) => x.toJson())),
        "brochures": List<dynamic>.from(brochures.map((x) => x)),
        "photos": List<dynamic>.from(photos.map((x) => x)),
        "videos": List<dynamic>.from(videos.map((x) => x)),
        "address": address.toJson(),
        "latitude": latitude,
        "longitude": longitude,
        "businesshours":
            List<dynamic>.from(businesshours.map((x) => x.toJson())),
        "socialmedialinks":
            List<dynamic>.from(socialmedialinks.map((x) => x.toJson())),
      };
}

class AddBusinessAddress {
  String flatno;
  String street;
  String area;
  String city;
  String state;
  String pincode;

  AddBusinessAddress({
    required this.flatno,
    required this.street,
    required this.area,
    required this.city,
    required this.state,
    required this.pincode,
  });

  factory AddBusinessAddress.fromJson(Map<String, dynamic> json) =>
      AddBusinessAddress(
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

class AddBusinessBusinesshour {
  String day;
  bool open;
  List<AddBusinessTime> time;

  AddBusinessBusinesshour({
    required this.day,
    required this.open,
    required this.time,
  });

  factory AddBusinessBusinesshour.fromJson(Map<String, dynamic> json) =>
      AddBusinessBusinesshour(
        day: json["day"],
        open: json["open"],
        time: List<AddBusinessTime>.from(
            json["time"].map((x) => AddBusinessTime.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "open": open,
        "time": List<dynamic>.from(time.map((x) => x.toJson())),
      };
}

class AddBusinessTime {
  String starttime;
  String endtime;

  AddBusinessTime({
    required this.starttime,
    required this.endtime,
  });

  factory AddBusinessTime.fromJson(Map<String, dynamic> json) =>
      AddBusinessTime(
        starttime: json["starttime"],
        endtime: json["endtime"],
      );

  Map<String, dynamic> toJson() => {
        "starttime": starttime,
        "endtime": endtime,
      };
}

class AddBusinessCategory {
  String parentCategory;
  List<String> childCategories;

  AddBusinessCategory({
    required this.parentCategory,
    required this.childCategories,
  });

  factory AddBusinessCategory.fromJson(Map<String, dynamic> json) =>
      AddBusinessCategory(
        parentCategory: json["parent_category"],
        childCategories:
            List<String>.from(json["child_categories"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "parent_category": parentCategory,
        "child_categories": List<dynamic>.from(childCategories.map((x) => x)),
      };
}

class AddBusinessMobileCountryWiseContact {
  String? number;
  String? internationalNumber;
  String? nationalNumber;
  String? e164Number;
  String? countryCode;
  String? dialCode;

  AddBusinessMobileCountryWiseContact({
    this.number,
    this.internationalNumber,
    this.nationalNumber,
    this.e164Number,
    this.countryCode,
    this.dialCode,
  });

  factory AddBusinessMobileCountryWiseContact.fromJson(
          Map<String, dynamic> json) =>
      AddBusinessMobileCountryWiseContact(
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
