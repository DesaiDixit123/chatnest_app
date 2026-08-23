import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
// import 'package:chatnest/app/widgets/better_poll.dart';
import 'package:chatnest/app/widgets/better_poll.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PollMessage extends StatefulWidget {
  PollMessage(
      {super.key,
      required this.chatListsDocData,
      required this.isSend,
      required this.isGroup,
      required this.onEmojiRemove,
      this.isSeenStatus = true,
      this.bookmarkList = false,
      this.favoriteList = false,
      this.onVote});
  bool isSend;
  bool isGroup;
  bool bookmarkList;
  bool favoriteList;
  ChatListsDoc chatListsDocData;
  Function()? onEmojiRemove;
  bool isSeenStatus;
  Function(int)? onVote;

  @override
  State<PollMessage> createState() => _PollMessageState();
}

class _PollMessageState extends State<PollMessage> {
  @override
  Widget build(BuildContext context) {
    return Row(
      key: Key(
        widget.chatListsDocData.id ?? "",
      ),
      children: [
        Expanded(
          flex: widget.isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Column(
            crossAxisAlignment: widget.isSend
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment:
                widget.isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: Dimens.edgeInsets10_10_10_0,
                decoration: BoxDecoration(
                  color: widget.isSend
                      ? ColorsValue.maincolor1.withAlpha(50)
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.five),
                    bottomRight: Radius.circular(Dimens.five),
                    topRight: !widget.isSend
                        ? Radius.circular(Dimens.five)
                        : Radius.zero,
                    topLeft: !widget.isSend
                        ? Radius.zero
                        : Radius.circular(Dimens.five),
                  ),
                ),
                width: Dimens.twoHundredFifty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Polls(
                      question: Padding(
                        padding: Dimens.edgeInsetsBottom10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.chatListsDocData.content?.poll.pollid
                                      ?.polltitle ??
                                  "",
                              style: Styles.black40014,
                            ),
                            Dimens.boxHeight10,
                            Row(
                              children: [
                                SvgPicture.asset(
                                  widget.chatListsDocData.content?.poll.pollid
                                              ?.allowmultipleans ??
                                          false
                                      ? AssetConstants.ic_multipal_poll
                                      : AssetConstants.ic_single_poll,
                                ),
                                Dimens.boxWidth6,
                                Text(
                                  widget.chatListsDocData.content?.poll.pollid
                                              ?.allowmultipleans ??
                                          false
                                      ? "select_one_more".tr
                                      : 'select_one'.tr,
                                  style: Styles.greyColor888840010,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      children: widget
                              .chatListsDocData.content?.poll.pollid?.options
                              .map(
                                (e) => Polls.options(
                                    title: e.title,
                                    value: double.parse(
                                      e.usersvotes.length.toString(),
                                    ),
                                    img: e.usersvotes
                                        .map(
                                            (e) => e.userid?.profileimage ?? "")
                                        .toList()),
                              )
                              .toList() ??
                          [],
                      currentUser: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              widget.chatListsDocData.from?.id
                          ? widget.chatListsDocData.from?.id
                          : "",
                      creatorID: Get.find<Repository>()
                          .getStringValue(LocalKeys.chanelId),
                      voteData: {
                        for (var item in widget.chatListsDocData.content?.poll
                                .pollid?.options ??
                            <ChatListsOption>[])
                          '${item.title}': item.usersvotes.length
                      },
                      userChoice: widget
                          .chatListsDocData.content?.poll.pollid?.options
                          .map((e) => e.usersvotes.any((element) =>
                                  element.userid?.id ==
                                  Get.find<Repository>()
                                      .getStringValue(LocalKeys.userIds))
                              ? 1
                              : 0)
                          .toList(),
                      onVoteBackgroundColor: ColorsValue.maincolor1,
                      leadingBackgroundColor: ColorsValue.maincolor1,
                      backgroundColor: Colors.white,
                      optionBarRadius: 24,
                      borderWidth: 1,
                      optionHeight: 10,
                      onVoteBorderColor: Colors.white,
                      voteCastedBorderColor: Colors.white,
                      onVote: widget.onVote,
                    ),
                    const Divider(
                      color: ColorsValue.white,
                    ),
                    InkWell(
                      onTap: () {
                        RouteManagement.goToViewPollVoteScreen(
                            widget.chatListsDocData.content?.poll.pollid?.id ??
                                "");
                      },
                      child: Center(
                        child: Text(
                          "View Votes",
                          style: Styles.main60014,
                        ),
                      ),
                    ),
                    Dimens.boxHeight5,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if ((widget.chatListsDocData.reactions?.isNotEmpty ??
                                false) &&
                            !widget.bookmarkList &&
                            !widget.favoriteList) ...[
                          InkWell(
                            onTap: widget.onEmojiRemove,
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
                                  widget.chatListsDocData.reactions?[0]
                                          .reaction ??
                                      "",
                                  style: Styles.black40014,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (!widget.favoriteList) ...[
                          Dimens.boxWidth3,
                          Visibility(
                            visible:
                                widget.chatListsDocData.bookmarks?.isNotEmpty ??
                                    false,
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
                                child: Icon(
                                  Icons.bookmark,
                                  size: Dimens.fifteen,
                                  color: ColorsValue.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                        if (!widget.bookmarkList) ...[
                          Dimens.boxWidth3,
                          Visibility(
                            visible:
                                widget.chatListsDocData.favorites?.isNotEmpty ??
                                    false,
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
                                child: Icon(
                                  Icons.star,
                                  size: Dimens.fifteen,
                                  color: ColorsValue.blackColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              if (!widget.isGroup) ...[
                Row(
                  children: [
                    Text(
                      Utility.getTimeStempToTimeHHMMAA(
                          widget.chatListsDocData.senttimestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (widget.isSeenStatus) ...[
                      Dimens.boxWidth5,
                      widget.isSend
                          ? SvgPicture.asset(
                              widget.chatListsDocData.status == "seen"
                                  ? AssetConstants.seenIcon
                                  : widget.chatListsDocData.status ==
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
                  children: [
                    if (widget.isSend &&
                        (widget.chatListsDocData.isbroadcasted ?? false)) ...[
                      SvgPicture.asset(
                        AssetConstants.ic_outline_brodcast,
                      )
                    ],
                    Dimens.boxWidth5,
                    Text(
                      Utility.getTimeStempToTimeHHMMAA(
                          widget.chatListsDocData.timestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (widget.isSeenStatus) ...[
                      Dimens.boxWidth5,
                      widget.isSend
                          ? SvgPicture.asset(
                              widget.chatListsDocData.statuses?.every(
                                          (element) =>
                                              element.status == "seen") ??
                                      false
                                  ? AssetConstants.seenIcon
                                  : widget.chatListsDocData.statuses?.every(
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
              ]
            ],
          ),
        ),
      ],
    );
  }
}
