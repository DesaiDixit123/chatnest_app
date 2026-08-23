import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LinksWithProductWithLinks extends StatelessWidget {
  LinksWithProductWithLinks({
    super.key,
    required this.chatListsDocData,
    required this.isGroup,
    required this.isSend,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });

  bool isSend;
  bool isGroup;
  bool isSeenStatus;
  ChatListsDoc chatListsDocData;
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
          child: Row(
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
              Column(
                crossAxisAlignment:
                    isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment:
                    isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimens.twoHundredEighty,
                    padding: Dimens.edgeInsets10_10_10_0,
                    decoration: BoxDecoration(
                      color: isSend
                          ? ColorsValue.maincolor1.withAlpha(50)
                          : ColorsValue.textfildbackcolor,
                      borderRadius: BorderRadius.circular(
                        Dimens.five,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          Get.find<Repository>()
                                      .getStringValue(LocalKeys.userIds) ==
                                  chatListsDocData.from?.id
                              ? "You"
                              : chatListsDocData.from?.nickname ??
                                  chatListsDocData.from?.fullname ??
                                  "",
                          style: Styles.main70014,
                        ),
                        Container(
                          height: Dimens.sixty,
                          decoration: BoxDecoration(
                            color: ColorsValue.white,
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Dimens.boxWidth2,
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.three),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (chatListsDocData.context?.content
                                              ?.product.productid?.image ??
                                          ""),
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 90,
                                  maxWidthDiskCache: 90,
                                  width: Dimens.fifty,
                                  height: Dimens.fifty,
                                  placeholder: (context, url) => Image.asset(
                                    AssetConstants.placeholder,
                                    fit: BoxFit.cover,
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AssetConstants.placeholder,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Dimens.boxWidth3,
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      chatListsDocData.context?.content?.product
                                              .productid?.name ??
                                          "",
                                      style: Styles.black40012,
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      chatListsDocData.context?.content?.product
                                              .productid?.description ??
                                          "",
                                      softWrap: true,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                    Text(
                                      "${'currency_symbol'.tr} ${chatListsDocData.context?.content?.product.productid?.price.toString()}",
                                      style: Styles.main50012,
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Dimens.boxHeight5,
                        InkWell(
                          onTap: () {
                            Utility.launchLinkURL(
                                chatListsDocData.content?.text.message ?? "");
                          },
                          child: Text(
                            chatListsDocData.content?.text.message ?? "",
                            style: Styles.main40014,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Dimens.boxHeight5,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (chatListsDocData.reactions?.isNotEmpty ??
                                false) ...[
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
                                      chatListsDocData.reactions?[0].reaction ??
                                          "",
                                      style: Styles.black40014,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Dimens.boxWidth3,
                            Visibility(
                              visible: chatListsDocData.bookmarks?.isNotEmpty ??
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
                            Dimens.boxWidth3,
                            Visibility(
                              visible: chatListsDocData.favorites?.isNotEmpty ??
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
                        ),
                      ],
                    ),
                  ),
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
                                      : chatListsDocData.status == "delivered"
                                          ? AssetConstants.deliveredIcon
                                          : AssetConstants.unseenIcon,
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
                                  chatListsDocData.statuses?.every((element) =>
                                              element.status == "seen") ??
                                          false
                                      ? AssetConstants.seenIcon
                                      : chatListsDocData.statuses?.every(
                                                  (element) =>
                                                      element.status ==
                                                      "delivered") ??
                                              false
                                          ? AssetConstants.deliveredIcon
                                          : AssetConstants.unseenIcon,
                                )
                              : Dimens.box0
                        ],
                      ],
                    )
                  ]
                ],
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
        ),
      ],
    );
  }
}
