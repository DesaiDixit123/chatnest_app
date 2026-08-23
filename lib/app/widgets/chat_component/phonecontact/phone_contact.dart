import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class PhoneShareContact extends StatelessWidget {
  PhoneShareContact(
      {super.key,
      required this.isSeen,
      required this.isDelivered,
      required this.isSend,
      required this.time,
      required this.phoneContact,
      required this.isBookmark,
      required this.isFavorites,
      required this.emoji,
      required this.onEmojiRemove,
      this.isSeenStatus = true,
      this.onMessageTap});

  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final bool isSeenStatus;
  final String time;
  final PhoneContact? phoneContact;
  final bool isBookmark;
  final bool isFavorites;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;
  Function()? onMessageTap;

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
                width: Dimens.twoHundredEighty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          height: Dimens.fifty,
                          width: Dimens.fifty,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(Dimens.hundred),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(Dimens.hundred),
                            child: Image.asset(
                              AssetConstants.usera,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Dimens.boxWidth12,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              phoneContact?.name ?? "",
                              style: Styles.black60014,
                            ),
                            Dimens.boxWidth12,
                            Wrap(
                              direction: Axis.vertical,
                              children: phoneContact?.mobile
                                      ?.map(
                                        (e) => Text(
                                          e ?? "",
                                          style: Styles.black40012,
                                        ),
                                      )
                                      .toList() ??
                                  [],
                            )
                          ],
                        ),
                        Dimens.boxWidth12,
                      ],
                    ),
                    Dimens.boxHeight8,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
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
                        ]
                      ],
                    ),
                    Dimens.boxHeight8,
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
        ),
      ],
    );
  }
}
