import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class TextWithLinks extends StatelessWidget {
  TextWithLinks({
    super.key,
    required this.message,
    required this.userName,
    required this.isSeen,
    required this.isDelivered,
    required this.replayChat,
    required this.time,
    required this.isSend,
    required this.isEdited,
    required this.onTap,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });
  final bool isSeen;
  final String replayChat;
  final String userName;
  final String message;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  Function()? onTap;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;

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
          child: Column(
            crossAxisAlignment:
                isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              msgCount > 40 || msgReplyCount > 40
                  ? Row(
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
                          width: Get.width / 1.2,
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
                          child: Padding(
                            padding: Dimens.edgeInsets10,
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
                                            topLeft:
                                                Radius.circular(Dimens.five),
                                            bottomLeft:
                                                Radius.circular(Dimens.five),
                                          ),
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      Flexible(
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
                                            Text(
                                              replayChat,
                                              softWrap: true,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
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
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Flexible(
                                      child: InkWell(
                                        onTap: onTap,
                                        child: Text(
                                          message.toString(),
                                          style: Styles.main40014,
                                        ),
                                      ),
                                    ),
                                    Dimens.boxHeight5,
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
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                                Dimens.boxHeight5,
                              ],
                            ),
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
                        ],
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
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
                        Container(
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
                          child: Padding(
                            padding: Dimens.edgeInsets10,
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
                                            topLeft:
                                                Radius.circular(Dimens.five),
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
                                          Text(
                                            replayChat,
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
                                Dimens.boxHeight10,
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    InkWell(
                                      onTap: onTap,
                                      child: Text(
                                        message.toString(),
                                        style: Styles.main40014,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
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
                                        ]
                                      ],
                                    )
                                  ],
                                ),
                                Dimens.boxHeight5,
                              ],
                            ),
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
        ),
      ],
    );
  }
}
