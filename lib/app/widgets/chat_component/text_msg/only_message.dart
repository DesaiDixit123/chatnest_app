import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class OnlyMessage extends StatelessWidget {
  OnlyMessage({
    super.key,
    required this.message,
    required this.time,
    required this.isSend,
    required this.isSeen,
    required this.isDelivered,
    required this.isEdited,
    required this.isBookmark,
    required this.isFavorites,
    this.isBrodcast = false,
    this.isSeenStatus = true,
    required this.emoji,
    required this.onEmojiRemove,
  });

  final String message;
  final String time;
  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  final bool isBookmark;
  final bool isFavorites;
  final bool isBrodcast;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          !isSend ? Dimens.edgeInsets00_00_20_10 : Dimens.edgeInsets20_00_00_10,
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
              Flexible(
                child: Container(
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Flexible(
                              child: Text(
                                message.toString(),
                                maxLines: 10,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.black40014,
                              ),
                            ),
                            Dimens.boxWidth10,
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (isSend && isBrodcast) ...[
                                  SvgPicture.asset(
                                    AssetConstants.ic_outline_brodcast,
                                  )
                                ],
                                Dimens.boxWidth5,
                                Text(
                                  time,
                                  style: Styles.greyColor888840012,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.end,
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
                            ),
                          ],
                        ),
                        Dimens.boxHeight5,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (emoji.isNotEmpty) ...[
                              InkWell(
                                onTap: onEmojiRemove,
                                child: Container(
                                  alignment: Alignment.center,
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
                                  child: Text(
                                    emoji[0].reaction ?? "",
                                    style: Styles.black40014,
                                    overflow: TextOverflow.ellipsis,
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
