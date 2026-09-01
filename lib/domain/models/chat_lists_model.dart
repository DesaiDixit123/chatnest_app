import 'dart:convert';

import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';

bool _parseBool(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == "true" || normalized == "yes" || normalized == "1";
  }
  return false;
}

double? _parseDouble(dynamic value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  if (value is String) return double.tryParse(value.trim());
  return null;
}

num _parseNum(dynamic value) {
  if (value == null) return 0;
  if (value is num) return value;
  if (value is String) return num.tryParse(value.trim()) ?? 0;
  return 0;
}

ChatListsModel chatListsModelFromJson(String str) =>
    ChatListsModel.fromJson(json.decode(str));

class ChatListsModel {
  String message;
  ChatListsData data;
  int status;
  bool isSuccess;

  ChatListsModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory ChatListsModel.fromJson(Map<String, dynamic> json) => ChatListsModel(
        message: json["Message"] ?? '',
        data: ChatListsData.fromJson(json["Data"]),
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

class ChatListsData {
  List<ChatListsDoc>? docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  ChatListsData({
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

  factory ChatListsData.fromJson(Map<String, dynamic> json) => ChatListsData(
        docs: json["docs"] == null
            ? []
            : List<ChatListsDoc>.from(
                json["docs"].map((x) => ChatListsDoc.fromJson(x))),
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

class ChatListsDoc {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  Subuser? subuser;
  String? status;
  ChatConatextDoc? context;
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

  ChatListsDoc({
    this.id,
    this.from,
    this.to,
    this.subuser,
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

  factory ChatListsDoc.fromJson(Map<String, dynamic> json) => ChatListsDoc(
        id: json["_id"] ?? "",
        from: json["from"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["from"])
            : (json["from"] != null
                ? ChatListsFrom(id: json["from"].toString())
                : null),
        to: json["to"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["to"])
            : (json["to"] != null
                ? ChatListsFrom(id: json["to"].toString())
                : null),
        subuser: json["subuser"] is Map<String, dynamic>
            ? Subuser.fromJson(json["subuser"])
            : null,
        status: json["status"] ?? "",
        context: json["context"] is Map<String, dynamic>
            ? ChatConatextDoc.fromJson(json["context"])
            : null,
        contentType: json["contentType"] ?? "",
        content: json["content"] is Map<String, dynamic>
            ? ChatListsContent.fromJson(json["content"])
            : null,
        callid: json["callid"] is Map<String, dynamic>
            ? ChatListsCallid.fromJson(json["callid"])
            : null,
        isforwarded: json["isforwarded"] ?? false,
        favorites: json["favorites"] is List
            ? List<ChatListDeletedfor>.from((json["favorites"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ChatListDeletedfor.fromJson(x)))
            : [],
        bookmarks: json["bookmarks"] is List
            ? List<ChatListDeletedfor>.from((json["bookmarks"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ChatListDeletedfor.fromJson(x)))
            : [],
        reactions: json["reactions"] is List
            ? List<ChatReaction>.from((json["reactions"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ChatReaction.fromJson(x)))
            : [],
        deletedfor: json["deletedfor"] is List
            ? List<ChatListDeletedfor>.from((json["deletedfor"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ChatListDeletedfor.fromJson(x)))
            : [],
        senttimestamp: _parseNum(json["senttimestamp"]).toInt(),
        deliveredtimestamp: _parseNum(json["deliveredtimestamp"]).toInt(),
        seentimestamp: _parseNum(json["seentimestamp"]).toInt(),
        isedited: json["isedited"] ?? false,
        createdAt: json["createdAt"]?.toString() ?? "",
        updatedAt: json["updatedAt"]?.toString() ?? "",
        v: _parseNum(json["__v"]).toInt(),
        docId: json["id"]?.toString(),
        statuses: json["statuses"] is List
            ? List<GroypChatListStatus>.from((json["statuses"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => GroypChatListStatus.fromJson(x)))
            : [],
        timestamp: _parseNum(json["timestamp"]).toInt(),
        isGroupMessage: json["isGroupMessage"],
        groupId: json["groupId"]?.toString() ?? "",
        tomessage: json["tomessage"]?.toString() ?? "",
        type: json["type"]?.toString() ?? "",
        members: json["members"] is List
            ? List<Member>.from((json["members"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => Member.fromJson(x)))
            : [],
        isbroadcasted: json["isbroadcasted"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from!.toJson(),
        "to": to!.toJson(),
        "subuser": subuser?.toJson(),
        "status": status,
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

class Subuser {
  String? id;
  String? fullname;
  String? email;
  String? mobile;
  String? countryCode;

  Subuser({
    this.id,
    this.fullname,
    this.email,
    this.mobile,
    this.countryCode,
  });

  factory Subuser.fromJson(Map<String, dynamic> json) => Subuser(
        id: json["_id"],
        fullname: json["fullname"],
        email: json["email"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullname": fullname,
        "email": email,
        "mobile": mobile,
        "country_code": countryCode,
      };
}

class ChatReaction {
  ChatListsFrom? userid;
  String? reaction;
  int? timestamp;

  ChatReaction({
    this.userid,
    this.reaction,
    this.timestamp,
  });

  factory ChatReaction.fromJson(Map<String, dynamic> json) => ChatReaction(
        userid: json["userid"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["userid"])
            : (json["userid"] != null ? ChatListsFrom(id: json["userid"].toString()) : null),
        reaction: json["reaction"]?.toString() ?? "",
        timestamp: _parseNum(json["timestamp"]).toInt(),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
        "reaction": reaction,
        "timestamp": timestamp,
      };
}

class ChatListsCallid {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? touser;
  dynamic togroup;
  bool? isvideocall;
  bool? isaudiocall;
  bool? isgroupcall;
  String? status;
  ChatListsFrom? initiatedby;
  List<CallHistoryMember>? members;
  CallHistoryAgorameta? agorameta;
  int? timestamp;
  String? callingfrom;
  DateTime? createdAt;
  DateTime? updatedAt;
  int? v;
  int? duration;
  int? startTime;
  int? endedAt;
  int? callStartedAt;

  ChatListsCallid({
    this.id,
    this.from,
    this.touser,
    this.togroup,
    this.isvideocall,
    this.isaudiocall,
    this.isgroupcall,
    this.status,
    this.initiatedby,
    this.members,
    this.agorameta,
    this.timestamp,
    this.callingfrom,
    this.createdAt,
    this.updatedAt,
    this.v,
    this.duration,
    this.startTime,
    this.endedAt,
    this.callStartedAt,
  });

  factory ChatListsCallid.fromJson(Map<String, dynamic> json) =>
      ChatListsCallid(
        id: json["_id"]?.toString(),
        from: json["from"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["from"])
            : null,
        touser: json["touser"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["touser"])
            : null,
        togroup: json["togroup"],
        isvideocall: _parseBool(json["isvideocall"]),
        isaudiocall: _parseBool(json["isaudiocall"]),
        isgroupcall: _parseBool(json["isgroupcall"]),
        status: json["status"]?.toString(),
        initiatedby: json["initiatedby"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["initiatedby"])
            : null,
        members: json["members"] is List
            ? List<CallHistoryMember>.from((json["members"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => CallHistoryMember.fromJson(x)))
            : [],
        agorameta: json["agorameta"] is Map<String, dynamic>
            ? CallHistoryAgorameta.fromJson(json["agorameta"])
            : null,
        timestamp: _parseNum(json["timestamp"]).toInt(),
        callingfrom: json["callingfrom"]?.toString(),
        createdAt: json["createdAt"] == null
            ? null
            : DateTime.tryParse(json["createdAt"].toString()),
        updatedAt: json["updatedAt"] == null
            ? null
            : DateTime.tryParse(json["updatedAt"].toString()),
        v: _parseNum(json["__v"]).toInt(),
        duration: json["duration"] is num
            ? (json["duration"] as num).toInt()
            : int.tryParse(json["duration"]?.toString() ?? ""),
        startTime: json["startTime"] is num
            ? (json["startTime"] as num).toInt()
            : int.tryParse(json["startTime"]?.toString() ?? ""),
        endedAt: json["endedAt"] is num
            ? (json["endedAt"] as num).toInt()
            : int.tryParse(json["endedAt"]?.toString() ?? ""),
        callStartedAt: json["callStartedAt"] is num
            ? (json["callStartedAt"] as num).toInt()
            : int.tryParse(json["callStartedAt"]?.toString() ?? ""),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from?.toJson(),
        "touser": touser?.toJson(),
        "togroup": togroup,
        "isvideocall": isvideocall,
        "isaudiocall": isaudiocall,
        "isgroupcall": isgroupcall,
        "status": status,
        "initiatedby": initiatedby?.toJson(),
        "members": members == null
            ? []
            : List<dynamic>.from(members!.map((x) => x.toJson())),
        "agorameta": agorameta?.toJson(),
        "timestamp": timestamp,
        "callingfrom": callingfrom,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "__v": v,
        "duration": duration,
        "startTime": startTime,
        "endedAt": endedAt,
        "callStartedAt": callStartedAt,
      };
}

class ChatListDeletedfor {
  ChatListsFrom? userid;
  int? timestamp;

  ChatListDeletedfor({
    this.userid,
    this.timestamp,
  });

  factory ChatListDeletedfor.fromJson(Map<String, dynamic> json) =>
      ChatListDeletedfor(
        userid: json["userid"] is Map<String, dynamic>
            ? ChatListsFrom.fromJson(json["userid"])
            : (json["userid"] != null ? ChatListsFrom(id: json["userid"].toString()) : null),
        timestamp: _parseNum(json["timestamp"]).toInt(),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
        "timestamp": timestamp,
      };
}

class ChatListsContent {
  ChatListsText text;
  ChatListsMedia media;
  List<ChatListMultiMedia>? multimedias;
  ChatListsProduct product;
  ChatListsLocation location;
  List<ContactContent> contact;
  ChatListsPoll poll;
  PhoneContact? phonecontact;
  StatusReply? statusreply;

  ChatListsContent({
    required this.text,
    required this.media,
    this.multimedias,
    required this.product,
    required this.location,
    required this.contact,
    required this.poll,
    this.phonecontact,
    this.statusreply,
  });

  factory ChatListsContent.fromJson(Map<String, dynamic> json) =>
      ChatListsContent(
        text: json["text"] is Map<String, dynamic>
            ? ChatListsText.fromJson(json["text"])
            : ChatListsText(message: ""),
        media: json["media"] is Map<String, dynamic>
            ? ChatListsMedia.fromJson(json["media"])
            : ChatListsMedia(
                path: "",
                type: "",
                mime: "",
                name: "",
              ),
        multimedias: json["multimedias"] is List
            ? List<ChatListMultiMedia>.from((json["multimedias"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ChatListMultiMedia.fromJson(x)))
            : [],
        product: json["product"] is Map<String, dynamic>
            ? ChatListsProduct.fromJson(json["product"])
            : ChatListsProduct(productid: null),
        location: json["location"] is Map<String, dynamic>
            ? ChatListsLocation.fromJson(json["location"])
            : ChatListsLocation(coordinates: []),
        contact: json["contact"] is List
            ? List<ContactContent>.from((json["contact"] as List)
                .where((x) => x is Map<String, dynamic>)
                .map((x) => ContactContent.fromJson(x)))
            : [],
        poll: json["poll"] is Map<String, dynamic>
            ? ChatListsPoll.fromJson(json["poll"])
            : ChatListsPoll(pollid: null),
        phonecontact: json["phonecontact"] is Map<String, dynamic>
            ? PhoneContact.fromJson(json["phonecontact"])
            : null,
        statusreply: json["statusreply"] is Map<String, dynamic>
            ? StatusReply.fromJson(json["statusreply"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "media": media.toJson(),
        "multimedias": multimedias == null
            ? []
            : List<dynamic>.from(multimedias!.map((x) => x.toJson())),
        "product": product.toJson(),
        "location": location.toJson(),
        // ignore: unnecessary_null_comparison
        "contact": contact == null
            ? []
            : List<dynamic>.from(contact.map((x) => x.toJson())),
        "poll": poll.toJson(),
        "phonecontact": phonecontact?.toJson(),
        "statusreply": statusreply?.toJson(),
      };
}

class ContactContent {
  String? usersid;
  ChatListsFrom? userdata;
  String? isfriend;
  String? friendrequestid;

  ContactContent({
    this.usersid,
    this.userdata,
    this.isfriend,
    this.friendrequestid,
  });

  factory ContactContent.fromJson(Map<String, dynamic> json) => ContactContent(
        usersid: json["userid"].runtimeType == String ? json["userid"] : '',
        userdata: json["userdata"] == null || json["userid"] == null
            ? null
            : ChatListsFrom.fromJson(json["userdata"] ?? json["userid"]),
        isfriend: json["isfriend"],
        friendrequestid: json["friendrequestid"],
      );

  Map<String, dynamic> toJson() => {
        "userid": usersid,
        "userdata": userdata?.toJson(),
        "isfriend": isfriend,
        "friendrequestid": friendrequestid,
      };
}

class ChatListsLocation {
  List<dynamic> coordinates;

  ChatListsLocation({
    required this.coordinates,
  });

  factory ChatListsLocation.fromJson(Map<String, dynamic> json) =>
      ChatListsLocation(
        coordinates: List<dynamic>.from(json["coordinates"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class ChatListsMedia {
  String path;
  String type;
  String mime;
  String name;
  String? fileext;
  double? filesizeinmb;

  ChatListsMedia({
    required this.path,
    required this.type,
    required this.mime,
    required this.name,
    this.fileext,
    this.filesizeinmb,
  });

  factory ChatListsMedia.fromJson(Map<String, dynamic> json) => ChatListsMedia(
        path: json["path"] ?? "",
        type: json["type"] ?? "",
        mime: json["mime"] ?? "",
        name: json["name"] ?? "",
        fileext: json["fileext"] ?? "",
        filesizeinmb: _parseDouble(json["filesizeinmb"]),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
        "mime": mime,
        "name": name,
        "fileext": fileext,
        "filesizeinmb": filesizeinmb,
      };
}

class ChatListMultiMedia {
  String path;
  String type;
  String mime;
  String name;
  String fileext;
  num filesizeinmb;

  ChatListMultiMedia({
    required this.path,
    required this.type,
    required this.mime,
    required this.name,
    required this.fileext,
    required this.filesizeinmb,
  });

  factory ChatListMultiMedia.fromJson(Map<String, dynamic> json) =>
      ChatListMultiMedia(
        path: json["path"] ?? "",
        type: json["type"] ?? "",
        mime: json["mime"] ?? "",
        name: json["name"] ?? "",
        fileext: json["fileext"] ?? "",
        filesizeinmb: _parseNum(json["filesizeinmb"]),
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
        "mime": mime,
        "name": name,
        "fileext": fileext,
        "filesizeinmb": filesizeinmb,
      };
}

class ChatListsPoll {
  Pollid? pollid;

  ChatListsPoll({
    required this.pollid,
  });

  factory ChatListsPoll.fromJson(Map<String, dynamic> json) => ChatListsPoll(
        pollid: json["pollid"] is Map<String, dynamic>
            ? Pollid.fromJson(json["pollid"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "pollid": pollid?.toJson(),
      };
}

class Pollid {
  String id;
  String polltitle;
  bool status;
  List<ChatListsOption> options;
  bool allowmultipleans;
  BroadcastCreatedBy? createdBy;
  BroadcastCreatedBy? updatedBy;
  DateTime createdAt;
  DateTime updatedAt;
  int v;
  Key? key;

  Pollid({
    required this.id,
    required this.polltitle,
    required this.status,
    required this.options,
    required this.allowmultipleans,
    required this.createdBy,
    required this.updatedBy,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
    required this.key,
  });

  factory Pollid.fromJson(Map<String, dynamic> json) => Pollid(
        key: UniqueKey(),
        id: json["_id"],
        polltitle: json["polltitle"],
        status: json["status"],
        options: List<ChatListsOption>.from(
            json["options"].map((x) => ChatListsOption.fromJson(x))),
        allowmultipleans: json["allowmultipleans"],
        createdBy: json["createdBy"] == null || json["createdBy"] is String
            ? null
            : BroadcastCreatedBy.fromJson(json["createdBy"]),
        updatedBy: json["updatedBy"] == null || json["updatedBy"] is String
            ? null
            : BroadcastCreatedBy.fromJson(json["updatedBy"]),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "polltitle": polltitle,
        "status": status,
        "options": List<dynamic>.from(options.map((x) => x.toJson())),
        "allowmultipleans": allowmultipleans,
        "createdBy": createdBy?.toJson(),
        "updatedBy": updatedBy?.toJson(),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class ChatListsOption {
  String title;
  String? id;
  List<Usersvote> usersvotes;

  ChatListsOption({
    required this.title,
    required this.usersvotes,
    this.id,
  });

  factory ChatListsOption.fromJson(Map<String, dynamic> json) =>
      ChatListsOption(
        title: json["title"],
        usersvotes: json["usersvotes"] == null
            ? []
            : List<Usersvote>.from(
                json["usersvotes"]!.map((x) => Usersvote.fromJson(x))),
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "title": title,
        // ignore: unnecessary_null_comparison
        "usersvotes": usersvotes == null
            ? []
            : List<dynamic>.from(usersvotes.map((x) => x.toJson())),
        "_id": id,
      };
}

class Usersvote {
  BroadcastCreatedBy? userid;
  int? timestamp;
  String? id;

  Usersvote({
    this.userid,
    this.timestamp,
    this.id,
  });

  factory Usersvote.fromJson(Map<String, dynamic> json) => Usersvote(
        userid: json["userid"] == null || json["userid"] is String
            ? null
            : BroadcastCreatedBy.fromJson(json["userid"]),
        timestamp: json["timestamp"] ?? 0,
        id: json["_id"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
        "timestamp": timestamp,
        "_id": id,
      };
}

class ChatListsProduct {
  Productid? productid;

  ChatListsProduct({
    this.productid,
  });

  factory ChatListsProduct.fromJson(Map<String, dynamic> json) =>
      ChatListsProduct(
        productid: json["productid"] is Map<String, dynamic>
            ? Productid.fromJson(json["productid"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "productid": productid?.toJson(),
      };
}

class StatusReply {
  String? statusid;
  String? statusOwnerId;
  String? statusMedia;
  String? statusMediaType;

  StatusReply({
    this.statusid,
    this.statusOwnerId,
    this.statusMedia,
    this.statusMediaType,
  });

  factory StatusReply.fromJson(Map<String, dynamic> json) => StatusReply(
        statusid: json["statusid"],
        statusOwnerId: json["statusOwnerId"],
        statusMedia: json["statusMedia"],
        statusMediaType: json["statusMediaType"],
      );

  Map<String, dynamic> toJson() => {
        "statusid": statusid,
        "statusOwnerId": statusOwnerId,
        "statusMedia": statusMedia,
        "statusMediaType": statusMediaType,
      };
}

class Productid {
  String? id;
  String? name;
  String? description;
  int? price;
  int? offer;
  String? offerType;
  String? code;
  String? image;

  Productid({
    this.id,
    this.name,
    this.description,
    this.price,
    this.offer,
    this.offerType,
    this.code,
    this.image,
  });

  factory Productid.fromJson(Map<String, dynamic> json) => Productid(
        id: json["_id"],
        name: json["name"],
        description: json["description"],
        price: json["price"],
        offer: json["offer"],
        offerType: json["offer_type"],
        code: json["code"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "name": name,
        "description": description,
        "price": price,
        "offer": offer,
        "offer_type": offerType,
        "code": code,
        "image": image,
      };
}

class ChatListsText {
  String message;

  ChatListsText({
    required this.message,
  });

  factory ChatListsText.fromJson(Map<String, dynamic> json) => ChatListsText(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

class ChatListsFrom {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? aboutme;
  String? name;

  ChatListsFrom({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.aboutme,
    this.name,
  });

  factory ChatListsFrom.fromJson(Map<String, dynamic> json) => ChatListsFrom(
        id: json["_id"] ?? "",
        mobile: json["mobile"] ?? "",
        countryCode: json["country_code"] ?? "",
        profileimage: json["profileimage"] ?? "",
        fullname: json["fullname"] ?? "",
        nickname: json["nickname"] ?? "",
        aboutme: json["aboutme"] ?? "",
        name: json["name"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "aboutme": aboutme,
        "name": name,
      };
}

class ChatConatextDoc {
  String? id;
  ChatListsFrom? from;
  ChatListsFrom? to;
  Subuser? subuser;
  String? status;
  ChatListsDoc? context;
  String? contentType;
  ChatContextContent? content;
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

  ChatConatextDoc({
    this.id,
    this.from,
    this.to,
    this.subuser,
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

  factory ChatConatextDoc.fromJson(Map<String, dynamic> json) =>
      ChatConatextDoc(
        id: json["_id"] ?? "",
        from:
            json["from"] == null ? null : ChatListsFrom.fromJson(json["from"]),
        to: json["to"] == null ? null : ChatListsFrom.fromJson(json["to"]),
        subuser:
            json["subuser"] == null ? null : Subuser.fromJson(json["subuser"]),
        status: json["status"] ?? "",
        context: json["context"] == null
            ? null
            : ChatListsDoc.fromJson(json["context"]),
        contentType: json["contentType"] ?? "",
        content: json["content"] == null
            ? null
            : ChatContextContent.fromJson(json["content"]),
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
        "subuser": subuser?.toJson(),
        "status": status,
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

class ChatContextContent {
  ChatListsText text;
  ChatListsMedia media;
  List<ChatListMultiMedia>? multimedias;
  ChatListsProduct product;
  ChatListsLocation location;
  List<ContactConatext> contact;
  ChatListsPoll poll;
  PhoneContact? phonecontact;

  ChatContextContent({
    required this.text,
    required this.media,
    this.multimedias,
    required this.product,
    required this.location,
    required this.contact,
    required this.poll,
    this.phonecontact,
  });

  factory ChatContextContent.fromJson(Map<String, dynamic> json) =>
      ChatContextContent(
        text: ChatListsText.fromJson(json["text"]),
        media: ChatListsMedia.fromJson(json["media"]),
        multimedias: json["multimedias"] == null
            ? []
            : List<ChatListMultiMedia>.from(json["multimedias"]!
                .map((x) => ChatListMultiMedia.fromJson(x))),
        product: ChatListsProduct.fromJson(json["product"]),
        location: ChatListsLocation.fromJson(json["location"]),
        contact: json["contact"] == null
            ? []
            : List<ContactConatext>.from(
                json["contact"]!.map((x) => ContactConatext.fromJson(x))),
        poll: ChatListsPoll.fromJson(json["poll"]),
        phonecontact: json["phonecontact"] == null
            ? null
            : PhoneContact.fromJson(json["phonecontact"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "media": media.toJson(),
        "multimedias": multimedias == null
            ? []
            : List<dynamic>.from(multimedias!.map((x) => x.toJson())),
        "product": product.toJson(),
        "location": location.toJson(),
        // ignore: unnecessary_null_comparison
        "contact": contact == null
            ? []
            : List<dynamic>.from(contact.map((x) => x.toJson())),
        "poll": poll.toJson(),
        "phonecontact": phonecontact?.toJson(),
      };
}

class ContactConatext {
  From? userid;

  ContactConatext({
    this.userid,
  });

  factory ContactConatext.fromJson(Map<String, dynamic> json) =>
      ContactConatext(
        userid: json["userid"] == null ? null : From.fromJson(json["userid"]),
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
      };
}

class From {
  String? id;
  String? mobile;
  String? countryCode;
  String? profileimage;
  String? fullname;
  String? nickname;
  String? aboutme;

  From({
    this.id,
    this.mobile,
    this.countryCode,
    this.profileimage,
    this.fullname,
    this.nickname,
    this.aboutme,
  });

  factory From.fromJson(Map<String, dynamic> json) => From(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        aboutme: json["aboutme"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "aboutme": aboutme,
      };
}
