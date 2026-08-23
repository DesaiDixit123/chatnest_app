import 'dart:convert';

SentFirendsListModel sentFirendsListModelFromJson(String str) =>
    SentFirendsListModel.fromJson(json.decode(str));

class SentFirendsListModel {
  String message;
  SentFirendsData data;
  int status;
  bool isSuccess;

  SentFirendsListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory SentFirendsListModel.fromJson(Map<String, dynamic> json) =>
      SentFirendsListModel(
        message: json["Message"],
        data: SentFirendsData.fromJson(json["Data"]),
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

class SentFirendsData {
  List<SentFirendsDoc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  SentFirendsData({
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

  factory SentFirendsData.fromJson(Map<String, dynamic> json) =>
      SentFirendsData(
        docs: List<SentFirendsDoc>.from(
            json["docs"].map((x) => SentFirendsDoc.fromJson(x))),
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

class SentFirendsDoc {
  String id;
  SentFirendsErid? senderid;
  SentFirendsErid? receiverid;
  String status;
  SentFirendsLastchatmessage? lastchatmessage;
  int timestamp;
  String docId;

  SentFirendsDoc({
    required this.id,
    this.senderid,
    this.receiverid,
    required this.status,
    this.lastchatmessage,
    required this.timestamp,
    required this.docId,
  });

  factory SentFirendsDoc.fromJson(Map<String, dynamic> json) => SentFirendsDoc(
        id: json["_id"],
        senderid: json["senderid"] == null
            ? null
            : SentFirendsErid.fromJson(json["senderid"]),
        receiverid: json["receiverid"] == null
            ? null
            : SentFirendsErid.fromJson(json["receiverid"]),
        status: json["status"],
        lastchatmessage: json["lastchatmessage"] == null
            ? null
            : SentFirendsLastchatmessage.fromJson(json["lastchatmessage"]),
        timestamp: json["timestamp"],
        docId: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "senderid": senderid!.toJson(),
        "receiverid": receiverid!.toJson(),
        "status": status,
        "lastchatmessage": lastchatmessage!.toJson(),
        "timestamp": timestamp,
        "id": docId,
      };
}

class SentFirendsLastchatmessage {
  SentFirendsMessage? message;
  int? timestamp;

  SentFirendsLastchatmessage({
    this.message,
    this.timestamp,
  });

  factory SentFirendsLastchatmessage.fromJson(Map<String, dynamic> json) =>
      SentFirendsLastchatmessage(
        message: json["message"] == null
            ? null
            : SentFirendsMessage.fromJson(json["message"]),
        timestamp: json["timestamp"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "message": message!.toJson(),
        "timestamp": timestamp,
      };
}

class SentFirendsMessage {
  String id;
  String from;
  String to;
  dynamic context;
  String contentType;
  Content content;
  dynamic callid;
  bool isforwarded;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;
  String status;
  List<dynamic> favorites;
  List<dynamic> bookmarks;
  List<dynamic> reactions;
  DateTime createdAt;
  DateTime updatedAt;
  int v;

  SentFirendsMessage({
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
    required this.createdAt,
    required this.updatedAt,
    required this.v,
  });

  factory SentFirendsMessage.fromJson(Map<String, dynamic> json) =>
      SentFirendsMessage(
        id: json["_id"],
        from: json["from"],
        to: json["to"],
        context: json["context"],
        contentType: json["contentType"],
        content: Content.fromJson(json["content"]),
        callid: json["callid"],
        isforwarded: json["isforwarded"],
        senttimestamp: json["senttimestamp"] ?? 0,
        deliveredtimestamp: json["deliveredtimestamp"] ?? 0,
        seentimestamp: json["seentimestamp"] ?? 0,
        status: json["status"],
        favorites: List<dynamic>.from(json["favorites"].map((x) => x)),
        bookmarks: List<dynamic>.from(json["bookmarks"].map((x) => x)),
        reactions: List<dynamic>.from(json["reactions"].map((x) => x)),
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
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
        "__v": v,
      };
}

class Content {
  SentFirendsText text;
  SentFirendsMedia media;
  SentFirendsProduct product;

  Content({
    required this.text,
    required this.media,
    required this.product,
  });

  factory Content.fromJson(Map<String, dynamic> json) => Content(
        text: SentFirendsText.fromJson(json["text"]),
        media: SentFirendsMedia.fromJson(json["media"]),
        product: SentFirendsProduct.fromJson(json["product"]),
      );

  Map<String, dynamic> toJson() => {
        "text": text.toJson(),
        "media": media.toJson(),
        "product": product.toJson(),
      };
}

class SentFirendsMedia {
  String path;
  String type;
  String mime;
  String name;

  SentFirendsMedia({
    required this.path,
    required this.type,
    required this.mime,
    required this.name,
  });

  factory SentFirendsMedia.fromJson(Map<String, dynamic> json) =>
      SentFirendsMedia(
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

class SentFirendsProduct {
  dynamic productid;

  SentFirendsProduct({
    required this.productid,
  });

  factory SentFirendsProduct.fromJson(Map<String, dynamic> json) =>
      SentFirendsProduct(
        productid: json["productid"],
      );

  Map<String, dynamic> toJson() => {
        "productid": productid,
      };
}

class SentFirendsText {
  String message;

  SentFirendsText({
    required this.message,
  });

  factory SentFirendsText.fromJson(Map<String, dynamic> json) =>
      SentFirendsText(
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
      };
}

class SentFirendsErid {
  String id;
  String mobile;
  String countryCode;
  String profileimage;
  String fullname;
  String nickname;
  String email;

  SentFirendsErid({
    required this.id,
    required this.mobile,
    required this.countryCode,
    required this.profileimage,
    required this.fullname,
    required this.nickname,
    required this.email,
  });

  factory SentFirendsErid.fromJson(Map<String, dynamic> json) =>
      SentFirendsErid(
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
