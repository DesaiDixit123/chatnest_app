import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

// ignore: must_be_immutable
class MultipalImageWithText extends StatelessWidget {
  MultipalImageWithText({
    super.key,
    required this.chatListsDocData,
    required this.isSend,
    required this.isGroup,
    required this.onEmojiRemove,
    this.brodcastList = false,
    this.favoriteList = false,
    this.isSeenStatus = true,
  });

  bool isSend;
  bool isGroup;
  bool brodcastList;
  bool favoriteList;
  bool isSeenStatus;
  ChatListsDoc chatListsDocData;
  Function()? onEmojiRemove;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: SizedBox(),
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
                children: [
                  if ((chatListsDocData.isedited ?? false) && isSend) ...[
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
                    width: Dimens.twoHundredFourty,
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
                        children: [
                          Container(
                            height:
                                chatListsDocData.content?.multimedias?.length ==
                                        2
                                    ? Dimens.hundred
                                    : Dimens.twoHundred,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimens.five),
                            ),
                            child: GridView.builder(
                              itemCount:
                                  chatListsDocData.content?.multimedias?.length,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: chatListsDocData
                                            .content?.multimedias?.length ==
                                        1
                                    ? 1
                                    : 2,
                                mainAxisSpacing: 3,
                                crossAxisSpacing: 3,
                                mainAxisExtent: chatListsDocData
                                            .content?.multimedias?.length ==
                                        1
                                    ? Dimens.hundred
                                    : Dimens.hundred,
                              ),
                              itemBuilder: (context, indexs) {
                                var count = chatListsDocData
                                        .content!.multimedias!.length -
                                    3;
                                return indexs < 2
                                    ? Stack(
                                        children: [
                                          if (chatListsDocData.content
                                                  ?.multimedias?[indexs].type ==
                                              "IMG") ...[
                                            InkWell(
                                              onTap: () {
                                                RouteManagement
                                                    .goToShowFullScareenImage(
                                                        chatListsDocData
                                                                .content
                                                                ?.multimedias?[
                                                                    indexs]
                                                                .path ??
                                                            "",
                                                        chatListsDocData
                                                                .content
                                                                ?.multimedias?[
                                                                    indexs]
                                                                .type ??
                                                            "");
                                              },
                                              child: Container(
                                                width: Dimens.hundredEight,
                                                height: Dimens.hundred,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.ten),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  child: CachedNetworkImage(
                                                    imageUrl: ApiWrapper
                                                            .imageUrl +
                                                        (chatListsDocData
                                                                .content
                                                                ?.multimedias?[
                                                                    indexs]
                                                                .path ??
                                                            ""),
                                                    fit: BoxFit.cover,
                                                    placeholder:
                                                        (context, url) =>
                                                            Center(
                                                      child: Lottie.asset(
                                                        AssetConstants
                                                            .imageLoader,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                    errorWidget:
                                                        (context, url, error) =>
                                                            Image.asset(
                                                      AssetConstants
                                                          .placeholder,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ] else ...[
                                            InkWell(
                                              onTap: () {
                                                RouteManagement
                                                    .goToShowFullScareenImage(
                                                        chatListsDocData
                                                                .content
                                                                ?.multimedias?[
                                                                    indexs]
                                                                .path ??
                                                            "",
                                                        "Video");
                                              },
                                              child: Container(
                                                width: Dimens.hundredEight,
                                                height: Dimens.hundred,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topRight: Radius.circular(
                                                      Dimens.five,
                                                    ),
                                                    bottomRight:
                                                        Radius.circular(
                                                      Dimens.five,
                                                    ),
                                                  ),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                    Dimens.five,
                                                  ),
                                                  child: VideoThumbnailWidget(
                                                    video: chatListsDocData
                                                            .content
                                                            ?.multimedias?[
                                                                indexs]
                                                            .path ??
                                                        "",
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Center(
                                              child: Icon(
                                                Icons.play_circle,
                                                color: ColorsValue.white,
                                                size: Dimens.twenty,
                                              ),
                                            )
                                          ]
                                        ],
                                      )
                                    : indexs == 3
                                        ? InkWell(
                                            onTap: () {
                                              RouteManagement.goToViewAllImages(
                                                  chatListsDocData
                                                      .content?.multimedias);
                                            },
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.ten),
                                              child: Container(
                                                color: ColorsValue.appColor,
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "+${count.toString()}",
                                                      style: Styles.white70024,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container();
                              },
                            ),
                          ),
                          Dimens.boxHeight10,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Text(
                                  chatListsDocData.content?.text.message ?? "",
                                  style: Styles.black40014,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Dimens.boxWidth5,
                              if (!isGroup) ...[
                                Row(
                                  children: [
                                    Text(
                                      Utility.getTimeStempToTimeHHMMAA(
                                          chatListsDocData.senttimestamp),
                                      style: Styles.greyColor888840012,
                                    ),
                                    if (isSeenStatus) ...[
                                      Dimens.boxWidth5,
                                      isSend
                                          ? SvgPicture.asset(
                                              chatListsDocData.status == "seen"
                                                  ? AssetConstants.seenIcon
                                                  : chatListsDocData.status ==
                                                          "delivered"
                                                      ? AssetConstants
                                                          .deliveredIcon
                                                      : AssetConstants
                                                          .unseenIcon,
                                            )
                                          : Dimens.box0
                                    ],
                                  ],
                                )
                              ] else ...[
                                Row(
                                  children: [
                                    Text(
                                      Utility.getTimeStempToTimeHHMMAA(
                                          chatListsDocData.timestamp),
                                      style: Styles.greyColor888840012,
                                    ),
                                    if (isSeenStatus) ...[
                                      Dimens.boxWidth5,
                                      isSend
                                          ? SvgPicture.asset(
                                              chatListsDocData.statuses?.every(
                                                          (element) =>
                                                              element.status ==
                                                              "seen") ??
                                                      false
                                                  ? AssetConstants.seenIcon
                                                  : chatListsDocData.statuses
                                                              ?.every((element) =>
                                                                  element
                                                                      .status ==
                                                                  "delivered") ??
                                                          false
                                                      ? AssetConstants
                                                          .deliveredIcon
                                                      : AssetConstants
                                                          .unseenIcon,
                                            )
                                          : Dimens.box0
                                    ],
                                  ],
                                )
                              ]
                            ],
                          ),
                          Dimens.boxHeight5,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if ((chatListsDocData.reactions?.isNotEmpty ??
                                      false) &&
                                  !brodcastList &&
                                  !favoriteList) ...[
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
                                        chatListsDocData
                                                .reactions?[0].reaction ??
                                            "",
                                        style: Styles.black40014,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                              if (!favoriteList) ...[
                                Dimens.boxWidth3,
                                Visibility(
                                  visible:
                                      chatListsDocData.bookmarks?.isNotEmpty ??
                                          false,
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
                              ],
                              if (!brodcastList) ...[
                                Dimens.boxWidth3,
                                Visibility(
                                  visible:
                                      chatListsDocData.favorites?.isNotEmpty ??
                                          false,
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
                            ],
                          ),
                          Dimens.boxHeight5,
                        ],
                      ),
                    ),
                  ),
                  if ((chatListsDocData.isedited ?? false) && !isSend) ...[
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
