import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GetOneFriendsModel getOneFriendsModelFromJson(String str) =>
    GetOneFriendsModel.fromJson(json.decode(str));

class GetOneFriendsModel {
  String message;
  GetOneFriendsData data;
  int status;
  bool isSuccess;

  GetOneFriendsModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GetOneFriendsModel.fromJson(Map<String, dynamic> json) =>
      GetOneFriendsModel(
        message: json["Message"] ?? json["message"] ?? "",
        data: GetOneFriendsData.fromJson(json["Data"] ?? json["data"] ?? {}),
        status: json["Status"] ?? json["status"] ?? 0,
        isSuccess: json["IsSuccess"] ?? json["isSuccess"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class GetOneFriendsData {
  String? friendrequestid;
  String? userid;
  String? profileimage;
  String? nickname;
  String? hashtag;
  String? aboutme;
  List<String>? hobbies;
  CoordinatesLocationModel? location;
  bool? isPinned;
  ReceiveRequestMessage? lastchatmessage;
  Permissions? usersPermissions;
  Permissions? yourPermissions;
  List<GetBusinessDatum>? businessprofiles;
  int? unreadmessageCount;
  String? channelID;
  String? fullname;
  String? mobile;
  String? countryCode;
  String? email;
  String? dob;
  String? gender;
  List<Socialmedialink>? socialmedialinks;
  bool isOnline;
  List<ChatListsMediaData>? latestmedias;
  bool? isBlocked;
  String? blockedBy;

  GetOneFriendsData({
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
    this.unreadmessageCount,
    this.channelID,
    this.fullname,
    this.mobile,
    this.countryCode,
    this.email,
    this.dob,
    this.gender,
    this.socialmedialinks,
    this.isOnline = false,
    this.latestmedias,
    this.isBlocked,
    this.blockedBy,
  });

  factory GetOneFriendsData.fromJson(Map<String, dynamic> json) =>
      GetOneFriendsData(
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
            : ReceiveRequestMessage.fromJson(json["lastchatmessage"]),
        usersPermissions: json["users_permissions"] == null
            ? null
            : Permissions.fromJson(json["users_permissions"]),
        yourPermissions: json["your_permissions"] == null
            ? null
            : Permissions.fromJson(json["your_permissions"]),
        businessprofiles: json["businessprofiles"] == null
            ? []
            : List<GetBusinessDatum>.from(json["businessprofiles"]
                .map((x) => GetBusinessDatum.fromJson(x))),
        unreadmessageCount: json["unreadmessage_count"] ?? 0,
        channelID: json["channelID"] ?? "",
        fullname: json["fullname"] ?? "",
        mobile: json["mobile"] ?? "",
        countryCode: json["country_code"] ?? "",
        email: json["email"] ?? "",
        dob: json["dob"] ?? "",
        gender: json["gender"] ?? "",
        socialmedialinks: json["socialmedialinks"] == null
            ? []
            : List<Socialmedialink>.from(json["socialmedialinks"]
                .map((x) => Socialmedialink.fromJson(x))),
        latestmedias: json["latestmedias"] == null
            ? []
            : List<ChatListsMediaData>.from(json["latestmedias"]!
                .map((x) => ChatListsMediaData.fromJson(x))),
        isBlocked: json["isBlocked"] ?? false,
        blockedBy: json["blockedBy"],
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
        "users_permissions": usersPermissions!.toJson(),
        "your_permissions": yourPermissions!.toJson(),
        "businessprofiles":
            List<dynamic>.from(businessprofiles!.map((x) => x.toJson())),
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
        "latestmedias": latestmedias == null
            ? []
            : List<dynamic>.from(latestmedias!.map((x) => x.toJson())),
        "isBlocked": isBlocked,
        "blockedBy": blockedBy,
      };
}

class ChatListsMediaData {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  String? status;
  dynamic context;
  String? contentType;
  ChatListsContent? content;
  ChatListsCallid? callid;
  bool? isforwarded;
  List<ChatListDeletedfor>? favorites;
  List<ChatListDeletedfor>? bookmarks;
  List<ChatReaction>? reactions;
  List<ChatListDeletedfor>? deletedfor;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  bool? isedited;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? docId;
  List<GroypChatListStatus>? statuses;
  int? timestamp;
  bool? isGroupMessage;
  String? groupId;
  String? tomessage;
  String? type;
  List<Member>? members;
  bool? isbroadcasted;
  String? chatDate;

  ChatListsMediaData({
    this.id,
    this.from,
    this.to,
    this.status,
    this.context,
    this.contentType,
    this.content,
    this.callid,
    this.isforwarded,
    this.favorites,
    this.bookmarks,
    this.reactions,
    this.deletedfor,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
    this.isedited,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
    this.groupId,
    this.isGroupMessage,
    this.statuses,
    this.timestamp,
    this.tomessage,
    this.type,
    this.members,
    this.isbroadcasted,
    this.chatDate = "",
  });

  factory ChatListsMediaData.fromJson(Map<String, dynamic> json) =>
      ChatListsMediaData(
        id: json["_id"] ?? "",
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatListsFrom.fromJson(json["to"]),
        status: json["status"] ?? "",
        context: json["context"] ?? "",
        contentType: json["contentType"] ?? "",
        content: json["content"] == null
            ? null
            : ChatListsContent.fromJson(json["content"]),
        callid: json["callid"] is Map<String, dynamic>
            ? ChatListsCallid.fromJson(json["callid"])
            : null,
        isforwarded: json["isforwarded"] ?? false,
        favorites: json["favorites"] == null
            ? []
            : List<ChatListDeletedfor>.from(
                json["favorites"]!.map((x) => ChatListDeletedfor.fromJson(x))),
        bookmarks: json["bookmarks"] == null
            ? []
            : List<ChatListDeletedfor>.from(
                json["bookmarks"]!.map((x) => ChatListDeletedfor.fromJson(x))),
        reactions: json["reactions"] == null
            ? []
            : List<ChatReaction>.from(
                json["reactions"]!.map((x) => ChatReaction.fromJson(x))),
        deletedfor: json["deletedfor"] == null
            ? []
            : List<ChatListDeletedfor>.from(
                json["deletedfor"]!.map((x) => ChatListDeletedfor.fromJson(x))),
        senttimestamp: json["senttimestamp"] ?? 0,
        deliveredtimestamp: json["deliveredtimestamp"] ?? 0,
        seentimestamp: json["seentimestamp"] ?? 0,
        isedited: json["isedited"] ?? false,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"],
        docId: json["id"],
        statuses: json["statuses"] == null
            ? []
            : List<GroypChatListStatus>.from(
                json["statuses"]!.map((x) => GroypChatListStatus.fromJson(x))),
        timestamp: json["timestamp"] ?? 0,
        isGroupMessage: json["isGroupMessage"],
        groupId: json["groupId"] ?? "",
        tomessage: json["tomessage"] ?? "",
        type: json["type"] ?? "",
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        isbroadcasted: json["isbroadcasted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from!.toJson(),
        "to": to!.toJson(),
        "status": status,
        "context": context,
        "contentType": contentType,
        "content": content!.toJson(),
        "callid": callid?.toJson(),
        "isforwarded": isforwarded,
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x.toJson())),
        "bookmarks": bookmarks == null
            ? []
            : List<dynamic>.from(bookmarks!.map((x) => x.toJson())),
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x.toJson())),
        "deletedfor": deletedfor == null
            ? []
            : List<dynamic>.from(deletedfor!.map((x) => x.toJson())),
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
        "isedited": isedited,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "id": docId,
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "isbroadcasted": isbroadcasted,
      };
}
