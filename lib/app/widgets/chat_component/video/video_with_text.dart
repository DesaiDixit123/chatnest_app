import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

// ignore: must_be_immutable
class VideoWithText extends StatelessWidget {
  VideoWithText({
    super.key,
    required this.isSeen,
    required this.isDelivered,
    required this.message,
    required this.isSend,
    required this.isEdited,
    required this.video,
    required this.time,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });

  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  final String message;
  final String video;
  final String time;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
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
                    width: Dimens.twoHundredFifty,
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
                      children: [
                        SizedBox(
                          width: Dimens.twoHundredFifty,
                          height: Dimens.twoHundredFifty,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.five),
                            child: InkWell(
                              onTap: () {
                                RouteManagement.goToShowFullScareenImage(
                                    ApiWrapper.imageUrl + video, "Video");
                              },
                              child: Stack(
                                children: [
                                  VideoThumbnailWidget(
                                    video: video,
                                  ),
                                  Center(
                                    child: SvgPicture.asset(
                                      AssetConstants.ic_video_play,
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
              // Row(
              //   children: [
              //     Text(
              //       time,
              //       style: Styles.greyColor888840012,
              //     ),
              //     if (isSeenStatus) ...[
              //       Dimens.boxWidth5,
              //       isSend
              //           ? SvgPicture.asset(
              //               isSeen
              //                   ? AssetConstants.seenIcon
              //                   : isDelivered
              //                       ? AssetConstants.deliveredIcon
              //                       : AssetConstants.unseenIcon,
              //             )
              //           : Dimens.box0
              //     ],
              //   ],
              // )
            ],
          ),
        )
      ],
    );
  }
}
