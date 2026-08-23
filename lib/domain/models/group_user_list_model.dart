import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

GroupUserListModel groupUserListModelFromJson(String str) =>
    GroupUserListModel.fromJson(json.decode(str));

class GroupUserListModel {
  String message;
  GroupUserListData? data;
  int status;
  bool isSuccess;

  GroupUserListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory GroupUserListModel.fromJson(Map<String, dynamic> json) =>
      GroupUserListModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"] == null
            ? null
            : GroupUserListData.fromJson(json["Data"]),
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

class GroupUserListData {
  int? totalunreadgroups;
  List<GroupChatDatum>? list;

  GroupUserListData({
    this.totalunreadgroups,
    this.list,
  });

  factory GroupUserListData.fromJson(Map<String, dynamic> json) =>
      GroupUserListData(
        totalunreadgroups: json["totalunreadgroups"],
        list: json["list"] == null
            ? []
            : List<GroupChatDatum>.from(
                json["list"]!.map((x) => GroupChatDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "totalunreadgroups": totalunreadgroups,
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
      };
}

class GroupChatDatum {
  String? id;
  bool? status;
  String? profileimage;
  String? name;
  String? description;
  List<GroupChatMember>? members;
  GroupLastchatmessage? lastchatmessage;
  GroupChatCreatedBy? createdBy;
  GroupChatCreatedBy? updatedBy;
  String? createdAt;
  String? updatedAt;
  int? v;
  bool? pinned;
  int unreadmessageCount;
  bool isUserSelect;
  List<Archivefor>? archivefor;
  bool? isgroupmarkedunread;

  GroupChatDatum({
    this.id,
    this.status,
    this.profileimage,
    this.name,
    this.description,
    this.members,
    this.lastchatmessage,
    this.createdBy,
    this.updatedBy,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.pinned,
    this.unreadmessageCount = 0,
    this.isUserSelect = false,
    this.archivefor,
    this.isgroupmarkedunread,
  });

  factory GroupChatDatum.fromJson(Map<String, dynamic> json) => GroupChatDatum(
        id: json["_id"] ?? "",
        status: json["status"] ?? false,
        profileimage: json["profileimage"] ?? "",
        name: json["name"] ?? "",
        description: json["description"] ?? "",
        members: json["members"] == null
            ? []
            : List<GroupChatMember>.from(
                json["members"].map((x) => GroupChatMember.fromJson(x))),
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : GroupLastchatmessage.fromJson(json["lastchatmessage"]),
        createdBy: json["createdBy"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["updatedBy"]),
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"] ?? 0,
        pinned: json["pinned"] ?? false,
        unreadmessageCount: json["unreadmessage_count"] ?? 0,
        archivefor: json["archivefor"] == null
            ? []
            : List<Archivefor>.from(
                json["archivefor"]!.map((x) => Archivefor.fromJson(x))),
        isgroupmarkedunread: json["isgroupmarkedunread"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "status": status,
        "profileimage": profileimage,
        "name": name,
        "description": description,
        "members": List<dynamic>.from(members!.map((x) => x.toJson())),
        "lastchatmessage": lastchatmessage!.toJson(),
        "createdBy": createdBy!.toJson(),
        "updatedBy": updatedBy!.toJson(),
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "pinned": pinned,
        "unreadmessage_count": unreadmessageCount,
        "archivefor": archivefor == null
            ? []
            : List<dynamic>.from(archivefor!.map((x) => x.toJson())),
        "isgroupmarkedunread": isgroupmarkedunread,
      };
}

class Archivefor {
  String? userid;
  int? timestamp;

  Archivefor({
    this.userid,
    this.timestamp,
  });

  factory Archivefor.fromJson(Map<String, dynamic> json) => Archivefor(
        userid: json["userid"],
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "timestamp": timestamp,
      };
}

class GroupLastchatmessage {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  List<Status>? statuses;
  ChatListsDoc? context;
  String? contentType;
  ChatGroupListsContent? content;
  dynamic callid;
  bool? isforwarded;
  List<dynamic>? favorites;
  List<dynamic>? bookmarks;
  List<dynamic>? reactions;
  List<dynamic>? deletedfor;
  int? timestamp;
  bool? isedited;
  String? createdAt;
  String? updatedAt;
  int? v;

  GroupLastchatmessage({
    this.id,
    this.from,
    this.to,
    this.statuses,
    this.context,
    this.contentType,
    this.content,
    this.callid,
    this.isforwarded,
    this.favorites,
    this.bookmarks,
    this.reactions,
    this.deletedfor,
    this.timestamp,
    this.isedited,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory GroupLastchatmessage.fromJson(Map<String, dynamic> json) =>
      GroupLastchatmessage(
        id: json["_id"] ?? "",
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatListsFrom.fromJson(json["to"]),
        // from: json["from"] ?? "",
        // to: json["to"] ?? "",
        statuses: json["statuses"] == null
            ? []
            : List<Status>.from(
                json["statuses"]!.map((x) => Status.fromJson(x))),
        context: json["context"] == null
            ? null
            : ChatListsDoc.fromJson(json["context"]),
        contentType: json["contentType"] ?? "",
        content: json["content"] == null
            ? null
            : ChatGroupListsContent.fromJson(json["content"]),
        callid: json["callid"],
        isforwarded: json["isforwarded"] ?? false,
        favorites: json["favorites"] == null
            ? []
            : List<dynamic>.from(json["favorites"].map((x) => x)),
        bookmarks: json["bookmarks"] == null
            ? []
            : List<dynamic>.from(json["bookmarks"].map((x) => x)),
        reactions: json["reactions"] == null
            ? []
            : List<dynamic>.from(json["reactions"].map((x) => x)),
        deletedfor: json["deletedfor"] == null
            ? []
            : List<dynamic>.from(json["deletedfor"].map((x) => x)),
        timestamp: json["timestamp"] ?? 0,
        isedited: json["isedited"],
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        // "from": from?.toJson(),
        // "to": to?.toJson(),
        "from": from,
        "to": to,
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toJson())),
        "context": context,
        "contentType": contentType,
        "content": content?.toJson(),
        "callid": callid,
        "isforwarded": isforwarded,
        "favorites": favorites == null
            ? []
            : List<dynamic>.from(favorites!.map((x) => x)),
        "bookmarks": bookmarks == null
            ? []
            : List<dynamic>.from(bookmarks!.map((x) => x)),
        "reactions": reactions == null
            ? []
            : List<dynamic>.from(reactions!.map((x) => x)),
        "deletedfor": deletedfor == null
            ? []
            : List<dynamic>.from(deletedfor!.map((x) => x)),
        "timestamp": timestamp,
        "isedited": isedited,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}

class Status {
  ChatListsFrom? userid;
  String? status;

  Status({
    this.userid,
    this.status,
  });

  factory Status.fromJson(Map<String, dynamic> json) => Status(
        userid: json["userid"] != null
            ? ChatListsFrom.fromJson(json['userid'])
            : null,
        status: json["status"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid,
        "status": status,
      };
}

class GroupChatCreatedBy {
  String id;
  String mobile;
  String countryCode;
  String profileimage;
  String fullname;
  String nickname;
  String email;
  String? hashtag;
  String aboutme;
  String? isfriend;
  String? friendrequestid;

  GroupChatCreatedBy(
      {required this.id,
      required this.mobile,
      required this.countryCode,
      required this.profileimage,
      required this.fullname,
      required this.nickname,
      required this.email,
      this.hashtag,
      required this.aboutme,
      this.isfriend,
      this.friendrequestid});

  factory GroupChatCreatedBy.fromJson(Map<String, dynamic> json) =>
      GroupChatCreatedBy(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
        hashtag: json["hashtag"]??"",
        aboutme: json["aboutme"],
        isfriend: json["isfriend"] ?? "",
        friendrequestid: json["friendrequestid"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
        "hashtag": hashtag,
        "aboutme": aboutme,
        if (isfriend != null) "isfriend": isfriend,
        if (friendrequestid != null) "friendrequestid": friendrequestid,
      };
}

class GroupChatMember {
  GroupChatCreatedBy? userid;
  GroupChatCreatedBy? addedBy;
  GroupChatPermissions? permissions;

  GroupChatMember({
    this.userid,
    this.addedBy,
    this.permissions,
  });

  factory GroupChatMember.fromJson(Map<String, dynamic> json) =>
      GroupChatMember(
        userid: json["userid"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["userid"]),
        addedBy: json["addedBy"] == null
            ? null
            : GroupChatCreatedBy.fromJson(json["addedBy"]),
        permissions: json["permissions"] == null
            ? null
            : GroupChatPermissions.fromJson(json["permissions"]),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid!.toJson(),
        "addedBy": addedBy!.toJson(),
        "permissions": permissions!.toJson(),
      };
}

class GroupChatPermissions {
  bool fullname;
  bool mobile;
  bool email;
  bool socialmedia;
  bool ismute;
  bool isadmin;
  bool ismanager;

  GroupChatPermissions({
    required this.fullname,
    required this.mobile,
    required this.email,
    required this.socialmedia,
    required this.ismute,
    required this.isadmin,
    required this.ismanager,
  });

  factory GroupChatPermissions.fromJson(Map<String, dynamic> json) =>
      GroupChatPermissions(
        fullname: json["fullname"],
        mobile: json["mobile"],
        email: json["email"],
        socialmedia: json["socialmedia"],
        ismute: json["ismute"],
        isadmin: json["isadmin"],
        ismanager: json["ismanager"],
      );

  Map<String, dynamic> toJson() => {
        "fullname": fullname,
        "mobile": mobile,
        "email": email,
        "socialmedia": socialmedia,
        "ismute": ismute,
        "isadmin": isadmin,
        "ismanager": ismanager,
      };
}

class ChatGroupListsContent {
  ChatListsText text;
  ChatListsMedia media;
  ChatListsProduct product;
  ChatListsLocation location;
  List<ContactContent> contact;
  ChatGroupListsPoll poll;

  ChatGroupListsContent({
    required this.text,
    required this.media,
    required this.product,
    required this.location,
    required this.contact,
    required this.poll,
  });

  factory ChatGroupListsContent.fromJson(Map<String, dynamic> json) =>
      ChatGroupListsContent(
        text: ChatListsText.fromJson(json["text"]),
        media: ChatListsMedia.fromJson(json["media"]),
        product: ChatListsProduct.fromJson(json["product"]),
        location: ChatListsLocation.fromJson(json["location"]),
        contact: json["contact"] == null
            ? []
            : List<ContactContent>.from(
                json["contact"].map((x) => ContactContent.fromJson(x))),
        poll: ChatGroupListsPoll.fromJson(json["poll"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "media": media.toJson(),
        "product": product.toJson(),
        "location": location.toJson(),
        "contact": List<dynamic>.from(contact.map((x) => x)),
        "poll": poll.toJson(),
      };
}

class ChatGroupListsPoll {
  Pollid? pollid;

  ChatGroupListsPoll({
    this.pollid,
  });

  factory ChatGroupListsPoll.fromJson(Map<String, dynamic> json) =>
      ChatGroupListsPoll(
        pollid: json["pollid"] == null ? null : Pollid.fromJson(json["pollid"]),
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid?.toJson(),
      };
}
