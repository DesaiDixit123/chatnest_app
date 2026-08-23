import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ShareMultipulConect extends StatelessWidget {
  ShareMultipulConect({
    super.key,
    required this.isSeen,
    required this.isDelivered,
    required this.isSend,
    required this.time,
    required this.contactList,
    required this.onTap,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });

  final bool isSend;
  final bool isDelivered;
  final bool isSeen;
  final bool isSeenStatus;
  final String time;
  final List<ContactContent> contactList;
  Function() onTap;
  final bool isBookmark;
  final bool isFavorites;
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
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: Dimens.ninty,
                          child: Stack(
                            alignment: Alignment.center,
                            textDirection: TextDirection.rtl,
                            fit: StackFit.loose,
                            clipBehavior: Clip.antiAlias,
                            children: [
                              Container(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred),
                                  border: Border.all(
                                    width: Dimens.one,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiWrapper.imageUrl +
                                        (contactList[0]
                                                .userdata
                                                ?.profileimage ??
                                            ""),
                                    fit: BoxFit.cover,
                                    maxHeightDiskCache: 90,
                                    maxWidthDiskCache: 90,
                                    width: Dimens.fifty,
                                    height: Dimens.fifty,
                                    placeholder: (context, url) => Image.asset(
                                      AssetConstants.usera,
                                      fit: BoxFit.cover,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      AssetConstants.usera,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: Dimens.ten,
                                child: Container(
                                  height: Dimens.fifty,
                                  width: Dimens.fifty,
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.hundred),
                                    border: Border.all(
                                      width: Dimens.one,
                                      color: ColorsValue.maincolor1,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.hundred),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          (contactList[1]
                                                  .userdata
                                                  ?.profileimage ??
                                              ""),
                                      fit: BoxFit.cover,
                                      maxHeightDiskCache: 90,
                                      maxWidthDiskCache: 90,
                                      width: Dimens.fifty,
                                      height: Dimens.fifty,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '${contactList[0].userdata?.nickname} and ${contactList.length - 1} other contacts',
                            overflow: TextOverflow.ellipsis,
                            softWrap: true,
                            maxLines: 2,
                            style: Styles.black60014,
                          ),
                        )
                      ],
                    ),
                    Dimens.boxHeight10,
                    const Divider(
                      height: 1,
                      color: ColorsValue.white,
                    ),
                    Dimens.boxHeight8,
                    Center(
                      child: InkWell(
                        onTap: onTap,
                        child: Text(
                          "view_all".tr,
                          style: Styles.main60014,
                        ),
                      ),
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
                        ],
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
