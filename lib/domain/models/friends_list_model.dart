import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

FriendsListModel friendsListModelFromJson(String str) =>
    FriendsListModel.fromJson(json.decode(str));

class FriendsListModel {
  String message;
  List<FriendsListDatum> data;
  int status;
  bool isSuccess;

  FriendsListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory FriendsListModel.fromJson(Map<String, dynamic> json) =>
      FriendsListModel(
        message: json["Message"],
        data: List<FriendsListDatum>.from(
            json["Data"].map((x) => FriendsListDatum.fromJson(x))),
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

class FriendsListDatum {
  String? friendrequestid;
  String? userid;
  String? profileimage;
  String? nickname;
  String? hashtag;
  String? aboutme;
  List<String>? hobbies;
  CoordinatesLocationModel? location;
  bool? isPinned;
  ChatListsDoc? lastchatmessage;
  Permissions? usersPermissions;
  Permissions? yourPermissions;
  List<GetOneBusinessData>? businessprofiles;
  int unreadmessageCount;
  String? channelID;
  int? lastseen;
  String? fullname;
  String? mobile;
  String? countryCode;
  String? email;
  String? dob;
  String? gender;
  List<ProfileSocialmedialink>? socialmedialinks;
  bool? isSelect;
  bool? isUserSelect;
  bool? isOnline;

  FriendsListDatum({
    this.friendrequestid,
    this.userid,
    this.profileimage,
    this.nickname,
    this.hashtag,
    this.aboutme,
    this.hobbies,
    this.location,
    this.isPinned,
    this.lastchatmessage,
    this.usersPermissions,
    this.yourPermissions,
    this.businessprofiles,
    this.unreadmessageCount = 0,
    this.channelID,
    this.fullname,
    this.mobile,
    this.countryCode,
    this.email,
    this.dob,
    this.gender,
    this.socialmedialinks,
    this.isSelect = true,
    this.isUserSelect = false,
    this.isOnline = false,
    this.lastseen,
  });

  factory FriendsListDatum.fromJson(Map<String, dynamic> json) =>
      FriendsListDatum(
        friendrequestid: json["friendrequestid"] ?? "",
        userid: json["userid"] ?? "",
        profileimage: json["profileimage"] ?? "",
        nickname: json["nickname"] ?? "",
        hashtag: json["hashtag"] ?? "",
        aboutme: json["aboutme"] ?? "",
        hobbies: json["hobbies"] == null
            ? []
            : List<String>.from(json["hobbies"].map((x) => x)),
        location: json["location"] == null
            ? null
            : CoordinatesLocationModel.fromJson(json["location"]),
        isPinned: json["is_pinned"] ?? false,
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : ChatListsDoc.fromJson(json["lastchatmessage"]),
        usersPermissions: json["users_permissions"] != null
            ? Permissions.fromJson(json["users_permissions"])
            : null,
        yourPermissions: json["your_permissions"] == null
            ? null
            : Permissions.fromJson(json["your_permissions"]),
        businessprofiles: json["businessprofiles"] != null
            ? List<GetOneBusinessData>.from(json["businessprofiles"]
                .map((x) => GetOneBusinessData.fromJson(x)))
            : [],
        unreadmessageCount: json["unreadmessage_count"] ?? 0,
        channelID: json["channelID"] ?? 0,
        fullname: json["fullname"] ?? "",
        mobile: json["mobile"] ?? "",
        countryCode: json["country_code"] ?? "",
        email: json["email"] ?? "",
        dob: json["dob"] ?? "",
        gender: json["gender"] ?? "",
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<ProfileSocialmedialink>.from(
                json["socialmedialinks"]
                    .map((x) => ProfileSocialmedialink.fromJson(x)),
              ),
        lastseen: json["lastseen"],
      );

  Map<String, dynamic> toJson() => {
        "friendrequestid": friendrequestid,
        "userid": userid,
        "profileimage": profileimage,
        "nickname": nickname,
        "hashtag": hashtag,
        "aboutme": aboutme,
        "hobbies": List<dynamic>.from(hobbies!.map((x) => x)),
        "location": location!.toJson(),
        "is_pinned": isPinned,
        "lastchatmessage": lastchatmessage!.toJson(),
        "users_permissions": usersPermissions?.toJson(),
        "your_permissions": yourPermissions?.toJson(),
        "businessprofiles": List<dynamic>.from(businessprofiles!.map((x) => x)),
        "unreadmessage_count": unreadmessageCount,
        "channelID": channelID,
        "fullname": fullname,
        "mobile": mobile,
        "country_code": countryCode,
        "email": email,
        "dob": dob,
        "gender": gender,
        "socialmedialinks":
            List<dynamic>.from(socialmedialinks!.map((x) => x.toJson())),
        "lastseen": lastseen,
      };
}