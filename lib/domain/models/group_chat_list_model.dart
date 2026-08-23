import 'package:chatnest/domain/domain.dart';

class GroypChatListStatus {
  ChatListsFrom? userid;
  String? status;
  int? senttimestamp;
  int? deliveredtimestamp;
  int? seentimestamp;

  GroypChatListStatus({
    this.userid,
    this.status,
    this.senttimestamp,
    this.deliveredtimestamp,
    this.seentimestamp,
  });

  factory GroypChatListStatus.fromJson(Map<String, dynamic> json) =>
      GroypChatListStatus(
        userid: json["userid"] == null
            ? null
            : ChatListsFrom.fromJson(json["userid"]),
        status: json["status"],
        senttimestamp: json["senttimestamp"],
        deliveredtimestamp: json["deliveredtimestamp"],
        seentimestamp: json["seentimestamp"],
      );

  Map<String, dynamic> toJson() => {
        "userid": userid?.toJson(),
        "status": status,
        "senttimestamp": senttimestamp,
        "deliveredtimestamp": deliveredtimestamp,
        "seentimestamp": seentimestamp,
      };
}
