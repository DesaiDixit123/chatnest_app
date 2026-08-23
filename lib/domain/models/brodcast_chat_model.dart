import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

BroadcastChatModel broadcastChatModelFromJson(String str) =>
    BroadcastChatModel.fromJson(json.decode(str));

class BroadcastChatModel {
  String message;
  BroadcastChatData data;
  int status;
  bool isSuccess;

  BroadcastChatModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory BroadcastChatModel.fromJson(Map<String, dynamic> json) =>
      BroadcastChatModel(
        message: json["Message"] ?? '',
        data: BroadcastChatData.fromJson(json["Data"]),
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

class BroadcastChatData {
  List<BroadcastChatDoc>? docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  BroadcastChatData({
    this.docs,
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

  factory BroadcastChatData.fromJson(Map<String, dynamic> json) => BroadcastChatData(
        docs: json["docs"] == null
            ? []
            : List<BroadcastChatDoc>.from(
                json["docs"].map((x) => BroadcastChatDoc.fromJson(x))),
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
        "docs": List<dynamic>.from(docs!.map((x) => x.toJson())),
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

class BroadcastChatDoc {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  List<Member>? members;
  BroadcastChatDoc? context;
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
  bool? isbroadcasted;
  String? status;
  String? createdAt;
  String? updatedAt;
  int? v;
  String? docId;

  BroadcastChatDoc({
    this.id,
    this.from,
    this.to,
    this.members,
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
    this.isbroadcasted,
    this.status,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.docId,
  });

  factory BroadcastChatDoc.fromJson(Map<String, dynamic> json) => BroadcastChatDoc(
        id: json["_id"] ?? "",
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatListsFrom.fromJson(json["to"]),
        members: json["members"] == null
            ? []
            : List<Member>.from(
                json["members"]!.map((x) => Member.fromJson(x))),
        context: json["context"] == null
            ? null
            : BroadcastChatDoc.fromJson(json["context"]),
        contentType: json["contentType"] ?? "",
        content: json["content"] == null
            ? null
            : ChatListsContent.fromJson(json["content"]),
        callid: json["callid"] == null
            ? null
            : ChatListsCallid.fromJson(json["callid"]),
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
        isbroadcasted: json["isbroadcasted"],
        status: json["status"] ?? "",
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"],
        docId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from!.toJson(),
        "to": to!.toJson(),
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "context": context!.toJson(),
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
        "isbroadcasted": isbroadcasted,
        "status": status,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
        "id": docId,
      };
}
