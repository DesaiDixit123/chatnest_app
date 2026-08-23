import 'dart:convert';

BlockedUserListModel blockedUserListModelFromJson(String str) =>
    BlockedUserListModel.fromJson(json.decode(str));

class BlockedUserListModel {
  String message;
  BlockedUserData data;
  int status;
  bool isSuccess;

  BlockedUserListModel({
    required this.message,
    required this.data,
    required this.status,
    required this.isSuccess,
  });

  factory BlockedUserListModel.fromJson(Map<String, dynamic> json) =>
      BlockedUserListModel(
        message: json["Message"] ?? '',
        data: BlockedUserData.fromJson(json["Data"]),
        status: json["Status"] ?? 0,
        isSuccess: json["IsSuccess"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data.toJson(),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class BlockedUserData {
  List<BlockedUserDoc> docs;
  int totalDocs;
  int limit;
  int totalPages;
  int page;
  int pagingCounter;
  bool hasPrevPage;
  bool hasNextPage;
  dynamic prevPage;
  dynamic nextPage;

  BlockedUserData({
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

  factory BlockedUserData.fromJson(Map<String, dynamic> json) =>
      BlockedUserData(
        docs: List<BlockedUserDoc>.from(
            json["docs"].map((x) => BlockedUserDoc.fromJson(x))),
        totalDocs: json["totalDocs"] ?? 0,
        limit: json["limit"] ?? 10,
        totalPages: json["totalPages"] ?? 0,
        page: json["page"] ?? 1,
        pagingCounter: json["pagingCounter"] ?? 1,
        hasPrevPage: json["hasPrevPage"] ?? false,
        hasNextPage: json["hasNextPage"] ?? false,
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

/// Represents a single blocked user returned by POST /friends/blockedlist.
/// The backend (block.js → getBlockedList) returns a flat user object.
class BlockedUserDoc {
  /// The blocked user's MongoDB ID
  String id;

  /// The block record's ID (used as param for unblock)
  String blockId;

  String fullName;
  String nickName;
  String profileimage;
  String contactNo;
  String aboutUs;
  String emailId;
  String gender;
  String dob;
  String status;
  int timestamp;

  BlockedUserDoc({
    required this.id,
    required this.blockId,
    required this.fullName,
    required this.nickName,
    required this.profileimage,
    required this.contactNo,
    required this.aboutUs,
    required this.emailId,
    required this.gender,
    required this.dob,
    required this.status,
    required this.timestamp,
  });

  factory BlockedUserDoc.fromJson(Map<String, dynamic> json) => BlockedUserDoc(
        id: json["_id"] ?? '',
        blockId: json["block_id"] ?? '',
        fullName: json["fullName"] ?? '',
        nickName: json["nickName"] ?? '',
        profileimage: json["profileimage"] ?? '',
        contactNo: json["contact_no"] ?? '',
        aboutUs: json["aboutUs"] ?? '',
        emailId: json["emailId"] ?? '',
        gender: json["gender"] ?? '',
        dob: json["dob"] ?? '',
        status: json["status"] ?? 'blocked',
        timestamp: json["timestamp"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "block_id": blockId,
        "fullName": fullName,
        "nickName": nickName,
        "profileimage": profileimage,
        "contact_no": contactNo,
        "aboutUs": aboutUs,
        "emailId": emailId,
        "gender": gender,
        "dob": dob,
        "status": status,
        "timestamp": timestamp,
      };
}
