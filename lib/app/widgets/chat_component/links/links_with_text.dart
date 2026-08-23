import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'meeting_link_card.dart';

// ignore: must_be_immutable
class LinksWithText extends StatelessWidget {
  LinksWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.isSeen,
    required this.isDelivered,
    required this.replayChat,
    required this.time,
    required this.image,
    required this.isSend,
    required this.isEdited,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });

  final bool isSeen;
  final String replayChat;
  final String message;
  final String userName;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  final String image;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;

  @override
  @override
  Widget build(BuildContext context) {
    if (message.contains("/meeting/join/")) {
      return MeetingLinkCard(
        meetingUrl: message,
        isSend: isSend,
      );
    }

    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Column(
        mainAxisAlignment:
            isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment:
            isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
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
              Container(
                width: Get.width / 1.5,
                padding: Dimens.edgeInsets10_10_10_0,
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: Dimens.edgeInsetsLeft5,
                      child: Row(
                        children: [
                          Flexible(
                            child: Container(
                              height: Dimens.thirtyFive,
                              width: Dimens.three,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(Dimens.five),
                                  bottomLeft: Radius.circular(Dimens.five),
                                ),
                              ),
                            ),
                          ),
                          Dimens.boxWidth10,
                          Flexible(
                            flex: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  userName,
                                  softWrap: true,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.main50014,
                                ),
                                Text(
                                  replayChat,
                                  overflow: TextOverflow.ellipsis,
                                  softWrap: true,
                                  maxLines: 1,
                                  style: Styles.black40014,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Dimens.boxHeight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Text(
                            message.toString(),
                            style: Styles.black40014,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Dimens.boxWidth10,
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
                    Dimens.boxHeight5,
                  ],
                ),
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
        ],
      ),
    );
  }
}
