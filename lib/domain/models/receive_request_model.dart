import 'dart:convert';
import 'package:chatnest/domain/domain.dart';

ReceiveRequestModel receiveRequestModelFromJson(String str) =>
    ReceiveRequestModel.fromJson(json.decode(str));

class ReceiveRequestModel {
  String message;
  ReceiveRequestData data;
  int status;
  bool isSuccess;

  ReceiveRequestModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory ReceiveRequestModel.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestModel(
        message: json["Message"],
        data: ReceiveRequestData.fromJson(json["Data"]),
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

class ReceiveRequestData {
  List<ReceiveRequestDoc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  ReceiveRequestData({
    required this.docs,
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

  factory ReceiveRequestData.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestData(
        docs: List<ReceiveRequestDoc>.from(
            json["docs"].map((x) => ReceiveRequestDoc.fromJson(x))),
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
        "docs": List<dynamic>.from(docs.map((x) => x.toJson())),
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

class ReceiveRequestDoc {
  String id;
  ReceiveRequestErid senderid;
  ReceiveRequestErid receiverid;
  String status;
  ReceiveRequestLastchatmessage? lastchatmessage;
  int timestamp;
  String docId;

  ReceiveRequestDoc({
    required this.id,
    required this.senderid,
    required this.receiverid,
    required this.status,
    required this.lastchatmessage,
    required this.timestamp,
    required this.docId,
  });

  factory ReceiveRequestDoc.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestDoc(
        id: json["_id"],
        senderid: ReceiveRequestErid.fromJson(json["senderid"]),
        receiverid: ReceiveRequestErid.fromJson(json["receiverid"]),
        status: json["status"],
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : ReceiveRequestLastchatmessage.fromJson(json["lastchatmessage"]),
        timestamp: json["timestamp"],
        docId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "senderid": senderid.toJson(),
        "receiverid": receiverid.toJson(),
        "status": status,
        "lastchatmessage": lastchatmessage!.toJson(),
        "timestamp": timestamp,
        "id": docId,
      };
}

class ReceiveRequestLastchatmessage {
  ReceiveRequestMessage? message;
  int timestamp;

  ReceiveRequestLastchatmessage({
    required this.message,
    required this.timestamp,
  });

  factory ReceiveRequestLastchatmessage.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestLastchatmessage(
        message: json["message"] == null
            ? null
            : ReceiveRequestMessage.fromJson(json["message"]),
        timestamp: json["timestamp"],
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "timestamp": timestamp,
      };
}

class ReceiveRequestMessage {
  String id;
  String from;
  String to;
  dynamic context;
  String contentType;
  ReceiveRequestContent content;
  dynamic callid;
  bool isforwarded;
  String status;
  List<dynamic> favorites;
  List<dynamic> bookmarks;
  List<dynamic> reactions;
  List<dynamic> deletedfor;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  ReceiveRequestMessage({
    required this.id,
    required this.from,
    required this.to,
    required this.context,
    required this.contentType,
    required this.content,
    required this.callid,
    required this.isforwarded,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
    required this.status,
    required this.favorites,
    required this.bookmarks,
    required this.reactions,
    required this.deletedfor,
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory ReceiveRequestMessage.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestMessage(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        context: json["context"],
        contentType: json["contentType"],
        content: ReceiveRequestContent.fromJson(json["content"]),
        callid: json["callid"],
        isforwarded: json["isforwarded"],
        senttimestamp: json["senttimestamp"] ?? 0,
        deliveredtimestamp: json["deliveredtimestamp"] ?? 0,
        seentimestamp: json["seentimestamp"] ?? 0,
        status: json["status"],
        favorites: List<dynamic>.from(json["favorites"].map((x) => x)),
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
        reactions: List<dynamic>.from(json["reactions"].map((x) => x)),
        deletedfor: List<dynamic>.from(json["deletedfor"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
        v: json["__v"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "from": from,
        "to": to,
        "context": context,
        "contentType": contentType,
        "content": content.toJson(),
        "callid": callid,
        "isforwarded": isforwarded,
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
        "status": status,
        "favorites": List<dynamic>.from(favorites.map((x) => x)),
        "bookmarks": List<dynamic>.from(bookmarks.map((x) => x)),
        "reactions": List<dynamic>.from(reactions.map((x) => x)),
        "deletedfor": List<dynamic>.from(deletedfor.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class ReceiveRequestContent {
  ReceiveRequestText? text;
  ReceiveRequestMedia? media;
  ReceiveRequestProduct? product;
  StatusReply? statusreply;
  List<ChatListMultiMedia>? multimedias;
  ChatListsLocation? location;
  List<ContactContent>? contact;
  PhoneContact? phonecontact;
  ChatListsPoll? poll;

  ReceiveRequestContent({
    this.text,
    this.media,
    this.product,
    this.statusreply,
    this.multimedias,
    this.location,
    this.contact,
    this.phonecontact,
    this.poll,
  });

  factory ReceiveRequestContent.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestContent(
        text: json["text"] == null
            ? null
            : ReceiveRequestText.fromJson(json["text"]),
        media: json["media"] == null
            ? null
            : ReceiveRequestMedia.fromJson(json["media"]),
        product: json["product"] == null
            ? null
            : ReceiveRequestProduct.fromJson(json["product"]),
        statusreply: json["statusreply"] == null
            ? null
            : StatusReply.fromJson(json["statusreply"]),
        multimedias: json["multimedias"] == null
            ? []
            : List<ChatListMultiMedia>.from(json["multimedias"]!
                .map((x) => ChatListMultiMedia.fromJson(x))),
        location: json["location"] == null
            ? null
            : ChatListsLocation.fromJson(json["location"]),
        contact: json["contact"] == null
            ? []
            : List<ContactContent>.from(
                json["contact"]!.map((x) => ContactContent.fromJson(x))),
        phonecontact: json["phonecontact"] == null
            ? null
            : PhoneContact.fromJson(json["phonecontact"]),
        poll:
            json["poll"] == null ? null : ChatListsPoll.fromJson(json["poll"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text?.toJson(),
        "media": media?.toJson(),
        "product": product?.toJson(),
        "statusreply": statusreply?.toJson(),
        "multimedias": multimedias == null
            ? []
            : List<dynamic>.from(multimedias!.map((x) => x.toJson())),
        "location": location?.toJson(),
        "contact": contact == null
            ? []
            : List<dynamic>.from(contact!.map((x) => x.toJson())),
        "phonecontact": phonecontact?.toJson(),
        "poll": poll?.toJson(),
      };
}

class ReceiveRequestMedia {
  String path;
  String type;
  String mime;
  String name;

  ReceiveRequestMedia({
    required this.path,
    required this.type,
    required this.mime,
    required this.name,
  });

  factory ReceiveRequestMedia.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestMedia(
        path: json["path"],
        type: json["type"],
        mime: json["mime"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "path": path,
        "type": type,
        "mime": mime,
        "name": name,
      };
}

class ReceiveRequestProduct {
  dynamic productid;

  ReceiveRequestProduct({
    required this.productid,
  });

  factory ReceiveRequestProduct.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestProduct(
        productid: json["productid"],
      );

  Map<String, dynamic> toJson() => {
        "productid": productid,
      };
}

class ReceiveRequestText {
  String message;

  ReceiveRequestText({
    required this.message,
  });

  factory ReceiveRequestText.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestText(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

class ReceiveRequestErid {
  String id;
  String mobile;
  String countryCode;
  String profileimage;
  String fullname;
  String nickname;
  String email;

  ReceiveRequestErid({
    required this.id,
    required this.mobile,
    required this.countryCode,
    required this.profileimage,
    required this.fullname,
    required this.nickname,
    required this.email,
  });

  factory ReceiveRequestErid.fromJson(Map<String, dynamic> json) =>
      ReceiveRequestErid(
        id: json["_id"],
        mobile: json["mobile"],
        countryCode: json["country_code"],
        profileimage: json["profileimage"],
        fullname: json["fullname"],
        nickname: json["nickname"],
        email: json["email"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "mobile": mobile,
        "country_code": countryCode,
        "profileimage": profileimage,
        "fullname": fullname,
        "nickname": nickname,
        "email": email,
      };
}
