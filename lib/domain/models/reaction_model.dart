import 'dart:convert';

import 'package:chatnest/domain/domain.dart';

ReactionChatModel reactionChatModelFromJson(String str) =>
    ReactionChatModel.fromJson(json.decode(str));

class ReactionChatModel {
  String? message;
  ReactionChatData? data;
  int? status;
  bool? isSuccess;

  ReactionChatModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory ReactionChatModel.fromJson(Map<String, dynamic> json) =>
      ReactionChatModel(
        message: json["Message"],
        data: json["Data"] == null
            ? null
            : ReactionChatData.fromJson(json["Data"]),
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

class ReactionChatData {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  List<Status>? statuses;
  String? status;
  ChatListsDoc? context;
  String? contentType;
  ChatListsContent? content;
  dynamic callid;
  bool? isforwarded;
  List<ChatListDeletedfor>? favorites;
  List<ChatListDeletedfor>? bookmarks;
  List<ChatReaction>? reactions;
  List<ChatListDeletedfor>? deletedfor;
  int? timestamp;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  bool? isedited;
  String? createdAt;
  String? updatedAt;
  int? v;

  ReactionChatData({
    this.id,
    this.from,
    this.to,
    this.statuses,
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
    this.timestamp,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
    this.isedited,
    this.createdAt,
    this.updatedAt,
    this.v,
  });

  factory ReactionChatData.fromJson(Map<String, dynamic> json) =>
      ReactionChatData(
        id: json["_id"] ?? "",
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatListsFrom.fromJson(json["to"]),
        statuses: json["statuses"] == null
            ? []
            : List<Status>.from(
                json["statuses"]!.map((x) => Status.fromJson(x))),
        status: json["status"] ?? "",
        context: json["context"] == null
            ? null
            : ChatListsDoc.fromJson(json["context"]),
        contentType: json["contentType"] ?? "",
        content: json["content"] == null
            ? null
            : ChatListsContent.fromJson(json["content"]),
        callid: json["callid"],
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
        timestamp: json["timestamp"] ?? 0,
        senttimestamp: json["senttimestamp"] ?? 0,
        deliveredtimestamp: json["deliveredtimestamp"] ?? 0,
        seentimestamp: json["seentimestamp"] ?? 0,
        isedited: json["isedited"] ?? false,
        createdAt: json["createdAt"] ?? "",
        updatedAt: json["updatedAt"] ?? "",
        v: json["__v"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from?.toJson(),
        "to": to?.toJson(),
        "statuses": statuses == null
            ? []
            : List<dynamic>.from(statuses!.map((x) => x.toJson())),
        "status": status,
        "context": context?.toJson(),
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
            : List<dynamic>.from(reactions!.map((x) => x.toJson())),
        "deletedfor": deletedfor == null
            ? []
            : List<dynamic>.from(deletedfor!.map((x) => x)),
        "timestamp": timestamp,
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
        "isedited": isedited,
        "createdAt": createdAt,
        "updatedAt": updatedAt,
        "__v": v,
      };
}
