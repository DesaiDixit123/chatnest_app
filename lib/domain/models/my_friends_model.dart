import 'dart:convert';

import 'package:chatnest/domain/models/models.dart';

MyFriendsModel myFriendsModelFromJson(String str) =>
    MyFriendsModel.fromJson(json.decode(str));

String myFriendsModelToJson(MyFriendsModel data) => json.encode(data.toJson());

class MyFriendsModel {
  String? message;
  MyFriendsData? data;
  int? status;
  bool? isSuccess;

  MyFriendsModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory MyFriendsModel.fromJson(Map<String, dynamic> json) => MyFriendsModel(
        message: json["Message"],
        data:
            json["Data"] == null ? null : MyFriendsData.fromJson(json["Data"]),
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

class MyFriendsData {
  int? totalmarkedasunreaduser;
  List<MyFriendDatum>? list;

  MyFriendsData({
    this.totalmarkedasunreaduser,
    this.list,
  });

  factory MyFriendsData.fromJson(Map<String, dynamic> json) => MyFriendsData(
        totalmarkedasunreaduser: json["totalmarkedasunreaduser"],
        list: json["list"] == null
            ? []
            : List<MyFriendDatum>.from(
                json["list"]!.map((x) => MyFriendDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalmarkedasunreaduser": totalmarkedasunreaduser,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class MyFriendDatum {
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
  bool? ismarkedasunread;
  bool? isBlocked;
  String? blockedBy;

  MyFriendDatum({
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
    this.ismarkedasunread,
    this.isBlocked,
    this.blockedBy,
  });

  factory MyFriendDatum.fromJson(Map<String, dynamic> json) => MyFriendDatum(
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
        channelID: json["channelID"]?.toString() ?? "",
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
        ismarkedasunread: json["ismarkedasunread"],
        isBlocked: json["isBlocked"] ?? false,
        blockedBy: json["blockedBy"] ?? "",
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
        "ismarkedasunread": ismarkedasunread,
        "isBlocked": isBlocked,
        "blockedBy": blockedBy,
      };
}

class Permissions {
  bool fullname;
  bool mobile;
  bool email;
  bool dob;
  bool gender;
  bool socialmedia;
  bool videocall;
  bool audiocall;
  bool ismute;

  Permissions({
    required this.fullname,
    required this.mobile,
    required this.email,
    required this.dob,
    required this.gender,
    required this.socialmedia,
    required this.videocall,
    required this.audiocall,
    required this.ismute,
  });

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.toLowerCase() == "true" || value == "1";
    return false;
  }

  factory Permissions.fromJson(Map<String, dynamic> json) => Permissions(
        fullname: _toBool(json["fullname"]),
        mobile: _toBool(json["mobile"]),
        email: _toBool(json["email"]),
        dob: _toBool(json["dob"]),
        gender: _toBool(json["gender"]),
        socialmedia: _toBool(json["socialmedia"]),
        videocall:
            json.containsKey("videocall") ? _toBool(json["videocall"]) : true,
        audiocall:
            json.containsKey("audiocall") ? _toBool(json["audiocall"]) : true,
        ismute: json.containsKey("ismute") ? _toBool(json["ismute"]) : true,
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "mobile": mobile,
        "email": email,
        "dob": dob,
        "gender": gender,
        "socialmedia": socialmedia,
        "videocall": videocall,
        "audiocall": audiocall,
        "ismute": ismute,
      };
}
