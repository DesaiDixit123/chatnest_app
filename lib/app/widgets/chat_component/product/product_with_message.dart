import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ProductWithMessage extends StatelessWidget {
  ProductWithMessage({
    super.key,
    required this.message,
    required this.isSeen,
    required this.isDelivered,
    required this.productImage,
    required this.productPrice,
    required this.productTitle,
    required this.productdiscription,
    required this.time,
    required this.isSend,
    required this.isEdited,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    this.isSeenStatus = true,
    required this.onEmojiRemove,
  });
  final bool isSeen;
  final String message;
  final String productImage;
  final String productTitle;
  final String productdiscription;
  final String productPrice;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  final bool isBookmark;
  final bool isFavorites;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;
  bool isSeenStatus;

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
                          width: Get.width / 1.2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                child: Row(
                                  children: [
                                    Dimens.boxWidth3,
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.three),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            ApiWrapper.imageUrl + productImage,
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 90,
                                        maxWidthDiskCache: 90,
                                        width: Dimens.fifty,
                                        height: Dimens.fifty,
                                        placeholder: (context, url) =>
                                            Image.asset(
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
                                    Dimens.boxWidth10,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productTitle.toString(),
                                            style: Styles.black50014,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            productdiscription.toString(),
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.greyColor888840012,
                                          ),
                                          Text(
                                            "${'currency_symbol'.tr} ${productPrice.toString()}",
                                            style: Styles.main50012,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      message.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.black40014,
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
                          width: Dimens.twoHundredEighty,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.five),
                                ),
                                child: Row(
                                  children: [
                                    Dimens.boxWidth3,
                                    ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(Dimens.three),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            ApiWrapper.imageUrl + productImage,
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 90,
                                        maxWidthDiskCache: 90,
                                        width: Dimens.fifty,
                                        height: Dimens.fifty,
                                        placeholder: (context, url) =>
                                            Image.asset(
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
                                    Dimens.boxWidth10,
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            productTitle.toString(),
                                            style: Styles.black50014,
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          Text(
                                            productdiscription.toString(),
                                            softWrap: true,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.greyColor888840012,
                                          ),
                                          Text(
                                            "${'currency_symbol'.tr} ${productPrice.toString()}",
                                            style: Styles.main50012,
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Flexible(
                                    child: Text(
                                      message.toString(),
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.black40014,
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
            ],
          ),
        ),
      ],
    );
  }
}
