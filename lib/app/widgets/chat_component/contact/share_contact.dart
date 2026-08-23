import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ShareContact extends StatelessWidget {
  ShareContact(
      {super.key,
      required this.isSeen,
      required this.isDelivered,
      required this.isSend,
      required this.time,
      required this.contactList,
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
  final List<ContactContent> contactList;
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
                            child: CachedNetworkImage(
                              imageUrl: ApiWrapper.imageUrl +
                                  (contactList[0].userdata?.profileimage ?? ""),
                              fit: BoxFit.cover,
                              maxHeightDiskCache: 90,
                              maxWidthDiskCache: 90,
                              width: Dimens.fifty,
                              height: Dimens.fifty,
                              placeholder: (context, url) => Image.asset(
                                AssetConstants.usera,
                                fit: BoxFit.cover,
                              ),
                              errorWidget: (context, url, error) => Image.asset(
                                AssetConstants.usera,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxWidth12,
                        Text(
                          contactList[0].userdata?.fullname ?? "",
                          style: Styles.black60014,
                        )
                      ],
                    ),
                    Dimens.boxHeight8,
                    const Divider(
                      height: 1,
                      color: ColorsValue.white,
                    ),
                    Dimens.boxHeight8,
                    InkWell(
                      onTap: onMessageTap,
                      child: SizedBox(
                        width: double.infinity,
                        child: Center(
                          child: Text(
                            contactList[0].isfriend == "no"
                                ? "Add"
                                : contactList[0].isfriend == "sent"
                                    ? "Cancle Request"
                                    : "message".tr,
                            style: contactList[0].isfriend == "sent"
                                ? Styles.redColor60014
                                : Styles.main60014,
                          ),
                        ),
                      ),
                    ),
                    Dimens.boxHeight5,
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
        ),
      ],
    );
  }
}
