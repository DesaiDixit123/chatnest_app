import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class VideoCall extends StatelessWidget {
  VideoCall({
    super.key,
    required this.chatListsDocData,
    required this.isSend,
    required this.isGroup,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });
  bool isSend;
  bool isGroup;
  bool isSeenStatus;
  ChatListsDoc chatListsDocData;
  Function()? onEmojiRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Column(
            crossAxisAlignment:
                isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width / 2.5,
                decoration: BoxDecoration(
                  color: isSend
                      ? ColorsValue.lightmainColor
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.five),
                    bottomRight: Radius.circular(Dimens.five),
                    topRight:
                        isSend ? Radius.zero : Radius.circular(Dimens.five),
                    topLeft:
                        isSend ? Radius.circular(Dimens.five) : Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: Dimens.edgeInsets10_10_10_0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: Dimens.fourty,
                            width: Dimens.fourty,
                            padding: Dimens.edgeInsets10,
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.five),
                              ),
                            ),
                            child: SvgPicture.asset(
                              AssetConstants.videoIcon,
                              colorFilter: const ColorFilter.mode(
                                ColorsValue.maincolor1,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Dimens.boxWidth5,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  callTitle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.black50014,
                                ),
                                Dimens.boxHeight2,
                                Text(
                                  callTiming(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840010,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Dimens.boxHeight5,
                      if (!isGroup) ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Utility.getTimeStempToTimeHHMMAA(
                                  chatListsDocData.senttimestamp),
                              style: Styles.greyColor888840012,
                            ),
                            if (isSeenStatus) ...[
                              Dimens.boxWidth5,
                              isSend
                                  ? SvgPicture.asset(
                                      chatListsDocData.status == "seen"
                                          ? AssetConstants.seenIcon
                                          : chatListsDocData.status ==
                                                  "delivered"
                                              ? AssetConstants.deliveredIcon
                                              : AssetConstants.unseenIcon,
                                    )
                                  : Dimens.box0
                            ],
                          ],
                        )
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              Utility.getTimeStempToTimeHHMMAA(
                                  chatListsDocData.timestamp),
                              style: Styles.greyColor888840012,
                            ),
                            if (isSeenStatus) ...[
                              Dimens.boxWidth5,
                              isSend
                                  ? SvgPicture.asset(
                                      chatListsDocData.statuses?.every(
                                                  (element) =>
                                                      element.status ==
                                                      "seen") ??
                                              false
                                          ? AssetConstants.seenIcon
                                          : chatListsDocData.statuses?.every(
                                                      (element) =>
                                                          element.status ==
                                                          "delivered") ??
                                                  false
                                              ? AssetConstants.deliveredIcon
                                              : AssetConstants.unseenIcon,
                                    )
                                  : Dimens.box0
                            ],
                          ],
                        )
                      ],
                      if (chatListsDocData.reactions?.isNotEmpty ?? false) ...[
                        InkWell(
                          onTap: onEmojiRemove,
                          child: Container(
                            height: Dimens.twentyFour,
                            width: Dimens.twentyFour,
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              border: Border.all(
                                width: Dimens.one,
                                color: ColorsValue.maincolor1,
                              ),
                            ),
                            child: Center(
                              child: Text(
                                chatListsDocData.reactions?[0].reaction ?? "",
                                style: Styles.black40014,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                      Dimens.boxHeight5,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String callTiming() {
    var connected = chatListsDocData.callid?.members
        ?.any((element) => element.status == "connected");

    var disConnected = chatListsDocData.callid?.members
        ?.any((element) => element.status == "disconnected");

    if ((connected ?? false) && (disConnected ?? false)) {
      var startAt;
      var endAt;

      var startIndex = chatListsDocData.callid?.members
          ?.indexWhere((element) => element.status == "connected");
      if (startIndex?.isNegative == false) {
        startAt = chatListsDocData.callid?.members?[startIndex ?? 0].startedAt;
      }

      var endIndex = chatListsDocData.callid?.members
          ?.indexWhere((element) => element.status == "disconnected");
      if (endIndex?.isNegative == false) {
        endAt = chatListsDocData.callid?.members?[endIndex ?? 0].endedAt;
      }

      DateTime dateTime1 = DateTime.fromMillisecondsSinceEpoch(startAt);
      DateTime dateTime2 = DateTime.fromMillisecondsSinceEpoch(endAt);

      Duration diff = dateTime2.difference(dateTime1);
      print(diff);
      if (diff.inDays > 0) {
        return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
      }
      if (diff.inHours > 0) {
        return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
      }
      if (diff.inMinutes > 0) {
        return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
      }
      if (diff.inSeconds > 0) {
        return "${diff.inSeconds} ${diff.inSeconds == 1 ? "s" : "s"}";
      }
      return "No answer";
    } else {
      var isCheack = chatListsDocData.callid?.members?.any(
          (element) => element.status == "ringing" && element.startedAt == 0);

      if (isCheack ?? false) {
        return "Missed call";
      } else {
        return "No answer";
      }
    }
  }

  String callTitle() {
    final isConference = (chatListsDocData.callid?.isgroupcall ?? false) ||
        ((chatListsDocData.callid?.members?.length ?? 0) > 2);
    return isConference ? "conference_call".tr : "video_call".tr;
  }
}
