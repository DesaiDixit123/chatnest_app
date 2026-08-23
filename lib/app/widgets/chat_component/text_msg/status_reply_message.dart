import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class StatusReplyMessage extends StatelessWidget {
  StatusReplyMessage({
    super.key,
    required this.message,
    required this.isSeen,
    required this.isDelivered,
    required this.statusReply,
    required this.time,
    required this.isSend,
    required this.isEdited,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.onTap,
    this.isSeenStatus = true,
  });
  final bool isSeen;
  final bool isEdited;
  final StatusReply? statusReply;
  final String message;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  final Function()? onTap;
  Function()? onEmojiRemove;

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
          child: Column(
            crossAxisAlignment:
                isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              msgCount > 40
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
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (statusReply != null) ...[
                                GestureDetector(
                                  onTap: onTap,
                                  child: Padding(
                                    padding: Dimens.edgeInsetsLeft5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: Dimens.thirtyFive,
                                          width: Dimens.three,
                                          decoration: BoxDecoration(
                                            color: ColorsValue.appColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(Dimens.five),
                                              bottomLeft:
                                                  Radius.circular(Dimens.five),
                                            ),
                                          ),
                                        ),
                                        if (statusReply!.statusMedia != null &&
                                            statusReply!
                                                .statusMedia!.isNotEmpty) ...[
                                          Dimens.boxWidth10,
                                          Container(
                                            width: Dimens.fourty,
                                            height: Dimens.fourty,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.five),
                                              color: ColorsValue.grey9BA6A8,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.five),
                                              child: statusReply!
                                                          .statusMediaType ==
                                                      "image"
                                                  ? CachedNetworkImage(
                                                      imageUrl: ApiWrapper
                                                              .imageUrl +
                                                          (statusReply!
                                                                  .statusMedia ??
                                                              ""),
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) {
                                                        return Image.asset(
                                                          AssetConstants
                                                              .placeholder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Image.asset(
                                                          AssetConstants
                                                              .placeholder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    )
                                                  : Icon(
                                                      Icons.play_circle_outline,
                                                      color:
                                                          ColorsValue.appColor,
                                                      size: Dimens.twenty,
                                                    ),
                                            ),
                                          ),
                                        ],
                                        Dimens.boxWidth10,
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Moment",
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.main50012,
                                              ),
                                              Text(
                                                statusReply!.statusMediaType ==
                                                        "image"
                                                    ? "Photo"
                                                    : statusReply!
                                                                .statusMediaType ==
                                                            "video"
                                                        ? "Video"
                                                        : "Moment",
                                                style: Styles.black40014,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Dimens.boxHeight10,
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
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
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (statusReply != null) ...[
                                GestureDetector(
                                  onTap: onTap,
                                  child: Padding(
                                    padding: Dimens.edgeInsetsLeft5,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          height: Dimens.thirtyFive,
                                          width: Dimens.three,
                                          decoration: BoxDecoration(
                                            color: ColorsValue.appColor,
                                            borderRadius: BorderRadius.only(
                                              topLeft:
                                                  Radius.circular(Dimens.five),
                                              bottomLeft:
                                                  Radius.circular(Dimens.five),
                                            ),
                                          ),
                                        ),
                                        if (statusReply!.statusMedia != null &&
                                            statusReply!
                                                .statusMedia!.isNotEmpty) ...[
                                          Dimens.boxWidth10,
                                          Container(
                                            width: Dimens.fourty,
                                            height: Dimens.fourty,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.five),
                                              color: ColorsValue.grey9BA6A8,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.five),
                                              child: statusReply!
                                                          .statusMediaType ==
                                                      "image"
                                                  ? CachedNetworkImage(
                                                      imageUrl: ApiWrapper
                                                              .imageUrl +
                                                          (statusReply!
                                                                  .statusMedia ??
                                                              ""),
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) {
                                                        return Image.asset(
                                                          AssetConstants
                                                              .placeholder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Image.asset(
                                                          AssetConstants
                                                              .placeholder,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    )
                                                  : Icon(
                                                      Icons.play_circle_outline,
                                                      color:
                                                          ColorsValue.appColor,
                                                      size: Dimens.twenty,
                                                    ),
                                            ),
                                          ),
                                        ],
                                        Dimens.boxWidth10,
                                        Flexible(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                "Moment",
                                                softWrap: true,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: Styles.main40012,
                                              ),
                                              Text(
                                                statusReply!.statusMediaType ==
                                                        "image"
                                                    ? "Photo"
                                                    : statusReply!
                                                                .statusMediaType ==
                                                            "video"
                                                        ? "Video"
                                                        : "Moment",
                                                style: Styles.black40014,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Dimens.boxHeight10,
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    message.toString(),
                                    style: Styles.black40014,
                                    maxLines: 10,
                                    overflow: TextOverflow.ellipsis,
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
                    ),
            ],
          ),
        ),
      ],
    );
  }
}
