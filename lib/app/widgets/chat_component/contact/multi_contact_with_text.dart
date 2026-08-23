import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReplayMultiContactWithMessage extends StatelessWidget {
  ReplayMultiContactWithMessage({
    super.key,
    required this.message,
    required this.isSeen,
    required this.isDelivered,
    required this.replayChat,
    required this.userName,
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
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;
  final bool isEdited;
  final bool isSeenStatus;

  @override
  Widget build(BuildContext context) {
    var msgCount = message.toString().length;
    var msgReplyCount = replayChat.toString().length;
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: msgCount > 40 || msgReplyCount > 40
              ? Row(
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
                      crossAxisAlignment: isSend
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: isSend
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: Get.width / 1.2,
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.lightmainColor
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
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.maincolor1,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.five),
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsetsLeft5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorsValue.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(Dimens.five),
                                        bottomRight:
                                            Radius.circular(Dimens.five),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: Dimens.edgeInsets5,
                                      child: Column(
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
                                              Icon(
                                                Icons.person,
                                                size: Dimens.fifteen,
                                                color:
                                                    ColorsValue.greyColor8888,
                                              ),
                                              Dimens.boxWidth3,
                                              Text(
                                                "${replayChat} Contact",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 3,
                                                style: Styles.black40014,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Dimens.boxHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Utility.launchLinkURL(message);
                                      },
                                      child: Text(
                                        message.toString(),
                                        style: Styles.black40014,
                                      ),
                                    ),
                                  ),
                                  Dimens.boxWidth5,
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
                                                        ? AssetConstants
                                                            .deliveredIcon
                                                        : AssetConstants
                                                            .unseenIcon,
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
                )
              : Row(
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
                      crossAxisAlignment: isSend
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      mainAxisAlignment: isSend
                          ? MainAxisAlignment.end
                          : MainAxisAlignment.start,
                      children: [
                        Container(
                          width: msgCount > 20 || msgReplyCount > 20
                              ? Get.width / 1.5
                              : Get.width / 2,
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.lightmainColor
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
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.maincolor1,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(Dimens.five),
                                  ),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsetsLeft5,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: ColorsValue.white,
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(Dimens.five),
                                        bottomRight:
                                            Radius.circular(Dimens.five),
                                      ),
                                    ),
                                    child: Padding(
                                      padding: Dimens.edgeInsets5,
                                      child: Column(
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
                                              Icon(
                                                Icons.person,
                                                size: Dimens.fifteen,
                                                color:
                                                    ColorsValue.greyColor8888,
                                              ),
                                              Dimens.boxWidth3,
                                              Text(
                                                "${replayChat} Contact",
                                                overflow: TextOverflow.ellipsis,
                                                softWrap: true,
                                                maxLines: 3,
                                                style: Styles.black40014,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Dimens.boxHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: InkWell(
                                      onTap: () {
                                        Utility.launchLinkURL(message);
                                      },
                                      child: Text(
                                        message.toString(),
                                        style: Styles.black40014,
                                      ),
                                    ),
                                  ),
                                  Dimens.boxWidth5,
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
                                                        ? AssetConstants
                                                            .deliveredIcon
                                                        : AssetConstants
                                                            .unseenIcon,
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
