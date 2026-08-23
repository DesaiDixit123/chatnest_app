import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class PollWithLinks extends StatelessWidget {
  PollWithLinks({
    super.key,
    required this.message,
    required this.userName,
    required this.isSeen,
    required this.isDelivered,
    required this.replayChat,
    required this.time,
    required this.isSend,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    required this.isEdited,
    this.isSeenStatus = true,
  });
  final bool isSeen;
  final String replayChat;
  final String userName;
  final String message;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;
  bool isEdited;

  @override
  Widget build(BuildContext context) {
    var msgCount = message.toString().length;
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Row(
            children: [
              if (isEdited && isSend) ...[
                Padding(
                  padding: Dimens.edgeInsetsLeft5,
                  child: Icon(
                    Icons.edit,
                    size: Dimens.twenty,
                    color: ColorsValue.grey9BA6A8,
                  ),
                ),
                Dimens.boxWidth5,
              ],
              Column(
                crossAxisAlignment:
                    isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment:
                    isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  msgCount > 40
                      ? Container(
                          width: Get.width / 1.5,
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.maincolor1.withAlpha(50)
                                : ColorsValue.textfildbackcolor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimens.five),
                              bottomRight: Radius.circular(Dimens.five),
                              topRight: isSend
                                  ? Radius.zero
                                  : Radius.circular(Dimens.five),
                              topLeft: isSend
                                  ? Radius.circular(Dimens.five)
                                  : Radius.zero,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsetsLeft5,
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dimens.thirtyFive,
                                      width: Dimens.three,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(Dimens.five),
                                          bottomLeft:
                                              Radius.circular(Dimens.five),
                                        ),
                                      ),
                                    ),
                                    Dimens.boxWidth10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.main50014,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AssetConstants.ic_poll_reply,
                                              height: Dimens.fifteen,
                                              width: Dimens.fifteen,
                                            ),
                                            Dimens.boxWidth5,
                                            Text(
                                              replayChat,
                                              style: Styles.black40014,
                                              maxLines: 10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight10,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Utility.launchLinkURL(message);
                                      },
                                      child: Text(
                                        message.toString(),
                                        style: Styles.main40014,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Dimens.boxHeight5,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (emoji.isNotEmpty) ...[
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
                                            emoji[0].reaction ?? "",
                                            style: Styles.black40014,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Dimens.boxWidth3,
                                  Visibility(
                                    visible: isBookmark,
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
                                  Dimens.boxWidth3,
                                  Visibility(
                                    visible: isFavorites,
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
                              ),
                            ],
                          ),
                        )
                      : Container(
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.maincolor1.withAlpha(50)
                                : ColorsValue.textfildbackcolor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimens.five),
                              bottomRight: Radius.circular(Dimens.five),
                              topRight: isSend
                                  ? Radius.zero
                                  : Radius.circular(Dimens.five),
                              topLeft: isSend
                                  ? Radius.circular(Dimens.five)
                                  : Radius.zero,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsetsLeft5,
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dimens.thirtyFive,
                                      width: Dimens.three,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(Dimens.five),
                                          bottomLeft:
                                              Radius.circular(Dimens.five),
                                        ),
                                      ),
                                    ),
                                    Dimens.boxWidth10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userName,
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.main50014,
                                        ),
                                        Row(
                                          children: [
                                            SvgPicture.asset(
                                              AssetConstants.ic_poll_reply,
                                              height: Dimens.fifteen,
                                              width: Dimens.fifteen,
                                            ),
                                            Dimens.boxWidth5,
                                            Text(
                                              replayChat,
                                              style: Styles.black40014,
                                              maxLines: 10,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight10,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Utility.launchLinkURL(message);
                                      },
                                      child: Text(
                                        message.toString(),
                                        style: Styles.main40014,
                                        maxLines: 10,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Dimens.boxHeight5,
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (emoji.isNotEmpty) ...[
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
                                            emoji[0].reaction ?? "",
                                            style: Styles.black40014,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                  Dimens.boxWidth3,
                                  Visibility(
                                    visible: isBookmark,
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
                                  Dimens.boxWidth3,
                                  Visibility(
                                    visible: isFavorites,
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
                              ),
                            ],
                          ),
                        ),
                  Row(
                    children: [
                      Text(
                        time,
                        style: Styles.greyColor888840012,
                      ),
                      if (isSeenStatus) ...[
                        Dimens.boxWidth5,
                        isSend
                            ? SvgPicture.asset(
                                isSeen
                                    ? AssetConstants.seenIcon
                                    : isDelivered
                                        ? AssetConstants.deliveredIcon
                                        : AssetConstants.unseenIcon,
                              )
                            : Dimens.box0
                      ],
                    ],
                  )
                ],
              ),
              if (isEdited && !isSend) ...[
                Padding(
                  padding: Dimens.edgeInsetsLeft5,
                  child: Icon(
                    Icons.edit,
                    size: Dimens.twenty,
                    color: ColorsValue.grey9BA6A8,
                  ),
                ),
                Dimens.boxWidth5,
              ],
            ],
          ),
        ),
      ],
    );
  }
}
