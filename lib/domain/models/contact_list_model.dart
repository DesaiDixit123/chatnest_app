import 'dart:convert';

ContactListModel contactListModelFromJson(String str) =>
    ContactListModel.fromJson(json.decode(str));

String contactListModelToJson(ContactListModel data) =>
    json.encode(data.toJson());

class ContactListModel {
  String? message;
  List<ContactListData>? data;
  int? status;
  bool? isSuccess;

  ContactListModel({
    this.message,
    this.data,
    this.status,
    this.isSuccess,
  });

  factory ContactListModel.fromJson(Map<String, dynamic> json) =>
      ContactListModel(
        message: json["Message"],
        data: json["Data"] == null || json["Data"]["contactList"] == null
            ? []
            : List<ContactListData>.from(json["Data"]["contactList"]!
                .map((x) => ContactListData.fromJson(x))),
        status: json["Status"],
        isSuccess: json["IsSuccess"],
      );

  Map<String, dynamic> toJson() => {
        "Message": message,
        "Data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "Status": status,
        "IsSuccess": isSuccess,
      };
}

class ContactListData {
  String? contactName;
  String? contactNumber;
  bool? isIfUser;
  bool? isChatNestUser;
  ChatNestUser? chatNestUser;

  // Friend request management fields
  String? isfriend; // "no", "sent", "received", "block", "yes"
  String? friendrequestid;

  ContactListData({
    this.contactName,
    this.contactNumber,
    this.isIfUser,
    this.isChatNestUser,
    this.chatNestUser,
    this.isfriend,
    this.friendrequestid,
  });

  factory ContactListData.fromJson(Map<String, dynamic> json) =>
      ContactListData(
        contactName: json["contactName"],
        contactNumber: json["contactNumber"],
        isIfUser: json["isIfUser"],
        isChatNestUser: json["isChatNestUser"] ?? json["isCoChatUser"],
        chatNestUser: (json["chatNestUser"] != null)
            ? ChatNestUser.fromJson(json["chatNestUser"])
            : (json["coChatUser"] != null)
                ? ChatNestUser.fromJson(json["coChatUser"])
                : null,
        isfriend: json["isfriend"],
        friendrequestid: json["friendrequestid"],
      );

  Map<String, dynamic> toJson() => {
        "contactName": contactName,
        "contactNumber": contactNumber,
        "isIfUser": isIfUser,
        "isChatNestUser": isChatNestUser,
        "chatNestUser": chatNestUser?.toJson(),
        "isfriend": isfriend,
        "friendrequestid": friendrequestid,
      };

  // Helper getter to get userid from chatNestUser
  String? get userid => chatNestUser?.id;

  // Helper getters for backward compatibility
  String? get name => contactName;
  String? get mobile => contactNumber;
}

class ChatNestUser {
  String? id;
  String? fullName;
  String? mobile;
  String? email;
  String? username;
  String? profileImage;
  String? status;
  String? lastSeen;
  String? createdAt;

  ChatNestUser({
    this.id,
    this.fullName,
    this.mobile,
    this.email,
    this.username,
    this.profileImage,
    this.status,
    this.lastSeen,
    this.createdAt,
  });

  factory ChatNestUser.fromJson(Map<String, dynamic> json) => ChatNestUser(
        id: json["_id"],
        fullName: json["fullName"],
        mobile: json["mobile"],
        email: json["email"],
        username: json["username"],
        profileImage: json["profileImage"],
        status: json["status"],
        lastSeen: json["lastSeen"],
        createdAt: json["createdAt"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "fullName": fullName,
        "mobile": mobile,
        "email": email,
        "username": username,
        "profileImage": profileImage,
        "status": status,
        "lastSeen": lastSeen,
        "createdAt": createdAt,
      };
}
