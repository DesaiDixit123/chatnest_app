import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class LinkMessage extends StatelessWidget {
  LinkMessage({
    super.key,
    required this.isSend,
    required this.message,
    required this.isSeen,
    required this.isDelivered,
    required this.isEdited,
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
  final String message;
  final bool isEdited;
  final String time;
  final bool isBookmark;
  final bool isFavorites;
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
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Flexible(
                            child: InkWell(
                              onTap: () {
                                Utility.launchLinkURL(message);
                              },
                              child: Text(
                                message.toString(),
                                maxLines: 20,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.main40014,
                              ),
                            ),
                          ),
                          Dimens.boxWidth5,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Dimens.boxWidth5,
                              Text(
                                time,
                                style: Styles.greyColor888840012,
                                overflow: TextOverflow.ellipsis,
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
