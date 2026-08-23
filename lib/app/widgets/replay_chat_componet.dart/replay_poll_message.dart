import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/widgets/better_poll.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class ReplayPollsMessage extends StatefulWidget {
  ReplayPollsMessage(
      {super.key,
      required this.chatListsDocData,
      required this.isSend,
      required this.isGroup,
      required this.onEmojiRemove,
      this.isSeenStatus = true,
      this.bookmarkList = false,
      this.favoriteList = false,
      this.onVote});

  bool isSend;
  bool isGroup;
  bool bookmarkList;
  bool favoriteList;
  ChatListsDoc chatListsDocData;
  Function()? onEmojiRemove;
  bool isSeenStatus;
  Function(int)? onVote;

  @override
  State<ReplayPollsMessage> createState() => _ReplayPollsMessageState();
}

class _ReplayPollsMessageState extends State<ReplayPollsMessage> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _getThumbnail();
  }

  Future<void> _getThumbnail() async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: ApiWrapper.imageUrl +
          (widget.chatListsDocData.context?.content?.media.path ?? ""),
      imageFormat: ImageFormat.PNG,
      maxWidth: 100,
      quality: 50,
    );
    setState(() {
      _thumbnail = thumbnail;
    });
  }

  String user = "king@mail.com";
  String creator = "eddy@mail.com";

  Map<String, int> usersWhoVoted = {
    'sam@mail.com': 3,
    'mike@mail.com': 4,
    'john@mail.com': 1,
    'kenny@mail.com': 1
  };

  @override
  Widget build(BuildContext context) {
    var msgCount =
        widget.chatListsDocData.context?.content?.text.message.length;
    return Row(
      children: [
        Expanded(
          flex: widget.isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Column(
            crossAxisAlignment: widget.isSend
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment:
                widget.isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Dimens.twoHundredFifty,
                padding: Dimens.edgeInsets10,
                decoration: BoxDecoration(
                  color: widget.isSend
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
                    if (widget.chatListsDocData.context?.contentType ==
                        "photo") ...[
                      Container(
                        height: Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.image,
                                        size: Dimens.fifteen,
                                        color: ColorsValue.greyColor8888,
                                      ),
                                      Dimens.boxWidth5,
                                      Text(
                                        'photo'.tr,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: Dimens.sixty,
                                  width: Dimens.sixty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          (widget.chatListsDocData.context
                                                  ?.content?.media.path ??
                                              ""),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Image.asset(
                                          AssetConstants.placeholder,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          AssetConstants.placeholder,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "photowithtext") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: Dimens.edgeInsets5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Get.find<Repository>().getStringValue(
                                                      LocalKeys.userIds) ==
                                                  widget
                                                      .chatListsDocData.from?.id
                                              ? "You"
                                              : widget.chatListsDocData.from
                                                      ?.nickname ??
                                                  widget.chatListsDocData.from
                                                      ?.fullname ??
                                                  "",
                                          style: Styles.main70014,
                                        ),
                                      ],
                                    ),
                                    Dimens.boxHeight5,
                                    Text(
                                      widget.chatListsDocData.context?.content
                                              ?.text.message ??
                                          "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: msgCount > 20
                                      ? Dimens.seventyFive
                                      : Dimens.sixty,
                                  width: msgCount > 20
                                      ? Dimens.seventyFive
                                      : Dimens.sixty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          (widget.chatListsDocData.content
                                                  ?.media.path ??
                                              ""),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Image.asset(
                                          AssetConstants.placeholder,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          AssetConstants.placeholder,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "videowithtext") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Flexible(
                              child: Padding(
                                padding: Dimens.edgeInsets5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          Get.find<Repository>().getStringValue(
                                                      LocalKeys.userIds) ==
                                                  widget
                                                      .chatListsDocData.from?.id
                                              ? "You"
                                              : widget.chatListsDocData.from
                                                      ?.nickname ??
                                                  widget.chatListsDocData.from
                                                      ?.fullname ??
                                                  "",
                                          style: Styles.main70014,
                                        ),
                                      ],
                                    ),
                                    Dimens.boxHeight5,
                                    Text(
                                      widget.chatListsDocData.context?.content
                                              ?.text.message ??
                                          "",
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: msgCount > 20
                                          ? Dimens.seventyFive
                                          : Dimens.sixty,
                                      width: msgCount > 20
                                          ? Dimens.seventyFive
                                          : Dimens.sixty,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            Dimens.five,
                                          ),
                                          bottomRight: Radius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(
                                            Dimens.five,
                                          ),
                                          bottomRight: Radius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                        child: _thumbnail != null
                                            ? Image.memory(
                                                _thumbnail!,
                                                fit: BoxFit.cover,
                                              )
                                            : Lottie.asset(
                                                AssetConstants.imageLoader,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                    Icon(
                                      Icons.play_circle,
                                      color: ColorsValue.white,
                                      size: Dimens.twenty,
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "productwithtext") ...[
                      Text(
                        Get.find<Repository>()
                                    .getStringValue(LocalKeys.userIds) ==
                                widget.chatListsDocData.from?.id
                            ? "You"
                            : widget.chatListsDocData.from?.nickname ??
                                widget.chatListsDocData.from?.fullname ??
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
                              borderRadius: BorderRadius.circular(Dimens.three),
                              child: CachedNetworkImage(
                                imageUrl: ApiWrapper.imageUrl +
                                    (widget.chatListsDocData.context?.content
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
                                    widget.chatListsDocData.context?.content
                                            ?.product.productid?.name ??
                                        "",
                                    style: Styles.black40012,
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    widget.chatListsDocData.context?.content
                                            ?.product.productid?.description ??
                                        "",
                                    softWrap: true,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.greyColor888840012,
                                  ),
                                  Text(
                                    "${'currency_symbol'.tr} ${widget.chatListsDocData.context?.content?.product.productid?.price.toString()}",
                                    style: Styles.main50012,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "video") ...[
                      Container(
                        height: Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.videocam,
                                        size: Dimens.fifteen,
                                        color: ColorsValue.greyColor8888,
                                      ),
                                      Dimens.boxWidth5,
                                      Text(
                                        'video'.tr,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              child: Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  height: Dimens.sixty,
                                  width: Dimens.sixty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.five,
                                      ),
                                    ),
                                    child: _thumbnail != null
                                        ? Image.memory(
                                            _thumbnail!,
                                            fit: BoxFit.cover,
                                          )
                                        : Lottie.asset(
                                            AssetConstants.imageLoader,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "docs") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.ic_document,
                                        height: Dimens.fifteen,
                                        width: Dimens.fifteen,
                                      ),
                                      Dimens.boxWidth5,
                                      SizedBox(
                                        width: Dimens.hundredSeventy,
                                        child: Text(
                                          "${widget.chatListsDocData.context?.content?.media.name}",
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.greyColor888840012,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "audio") ...[
                      Container(
                        height: Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        AssetConstants.ic_headphone,
                                        height: Dimens.fifteen,
                                        width: Dimens.fifteen,
                                        colorFilter: ColorFilter.mode(
                                          ColorsValue.greyColor8888,
                                          BlendMode.srcIn,
                                        ),
                                      ),
                                      Dimens.boxWidth5,
                                      Text(
                                        "audio".tr,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "text") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  SizedBox(
                                    width: Dimens.twoHundred,
                                    child: Text(
                                      "${widget.chatListsDocData.context?.content?.text.message ?? ""}",
                                      style: Styles.greyColor888840012,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "links") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  SizedBox(
                                    width: Dimens.twoHundred,
                                    child: Text(
                                      "${widget.chatListsDocData.context?.content?.text.message ?? ""}",
                                      style: Styles.greyColor888840012,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "location") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(
                                        Icons.location_on,
                                        size: Dimens.fifteen,
                                        color: ColorsValue.greyColor8888,
                                      ),
                                      Dimens.boxWidth5,
                                      Text(
                                        'location'.tr,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "contact") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: Dimens.fifteen,
                                          color: ColorsValue.greyColor8888,
                                        ),
                                        Dimens.boxWidth3,
                                        SizedBox(
                                          width: Dimens.hundredSeventy,
                                          child: Text(
                                            "Contact : ${widget.chatListsDocData.context?.content?.contact[0].userid?.nickname}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.greyColor888840012,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "phonecontact") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          size: Dimens.fifteen,
                                          color: ColorsValue.greyColor8888,
                                        ),
                                        Dimens.boxWidth3,
                                        SizedBox(
                                          width: Dimens.hundredSeventy,
                                          child: Text(
                                            "PhoneContact : ${widget.chatListsDocData.context?.content?.phonecontact?.name}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.greyColor888840012,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ] else if (widget.chatListsDocData.context?.contentType ==
                        "poll") ...[
                      Container(
                        height:
                            msgCount! > 20 ? Dimens.seventyFive : Dimens.sixty,
                        padding: Dimens.edgeInsets2,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: Dimens.four,
                              decoration: BoxDecoration(
                                color: ColorsValue.maincolor1,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                  bottomLeft: Radius.circular(
                                    Dimens.five,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: Dimens.edgeInsets5,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        Get.find<Repository>().getStringValue(
                                                    LocalKeys.userIds) ==
                                                widget.chatListsDocData.from?.id
                                            ? "You"
                                            : widget.chatListsDocData.from
                                                    ?.nickname ??
                                                widget.chatListsDocData.from
                                                    ?.fullname ??
                                                "",
                                        style: Styles.main70014,
                                      ),
                                    ],
                                  ),
                                  Dimens.boxHeight5,
                                  Expanded(
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SvgPicture.asset(
                                          AssetConstants.ic_poll_reply,
                                          height: Dimens.fifteen,
                                          width: Dimens.fifteen,
                                        ),
                                        Dimens.boxWidth5,
                                        SizedBox(
                                          width: Dimens.hundredSeventy,
                                          child: Text(
                                            "${widget.chatListsDocData.context?.content?.poll.pollid?.polltitle}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: Styles.greyColor888840012,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                    Dimens.boxHeight5,
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Polls(
                          question: Padding(
                            padding: Dimens.edgeInsetsBottom10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.chatListsDocData.content?.poll.pollid
                                          ?.polltitle ??
                                      "",
                                  style: Styles.black40014,
                                ),
                                Dimens.boxHeight10,
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      widget.chatListsDocData.content?.poll
                                                  .pollid?.allowmultipleans ??
                                              false
                                          ? AssetConstants.ic_multipal_poll
                                          : AssetConstants.ic_single_poll,
                                    ),
                                    Dimens.boxWidth6,
                                    Text(
                                      widget.chatListsDocData.content?.poll
                                                  .pollid?.allowmultipleans ??
                                              false
                                          ? "select_one_more".tr
                                          : 'select_one'.tr,
                                      style: Styles.greyColor888840010,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          children: widget.chatListsDocData.content?.poll.pollid
                                  ?.options
                                  .map(
                                    (e) => Polls.options(
                                        title: e.title,
                                        value: double.parse(
                                          e.usersvotes.length.toString(),
                                        ),
                                        img: e.usersvotes
                                            .map((e) =>
                                                e.userid?.profileimage ?? "")
                                            .toList()),
                                  )
                                  .toList() ??
                              [],
                          currentUser: Get.find<Repository>()
                                      .getStringValue(LocalKeys.userIds) ==
                                  widget.chatListsDocData.from?.id
                              ? widget.chatListsDocData.from?.id
                              : "",
                          creatorID: Get.find<Repository>()
                              .getStringValue(LocalKeys.chanelId),
                          voteData: {
                            for (var item in widget.chatListsDocData.content
                                    ?.poll.pollid?.options ??
                                <ChatListsOption>[])
                              '${item.title}': item.usersvotes.length
                          },
                          userChoice: widget
                              .chatListsDocData.content?.poll.pollid?.options
                              .map((e) => e.usersvotes.length)
                              .toList(),
                          onVoteBackgroundColor: ColorsValue.maincolor1,
                          leadingBackgroundColor: ColorsValue.maincolor1,
                          backgroundColor: Colors.white,
                          optionBarRadius: 24,
                          borderWidth: 1,
                          optionHeight: 10,
                          onVoteBorderColor: Colors.white,
                          voteCastedBorderColor: Colors.white,
                          onVote: widget.onVote,
                        ),
                        const Divider(
                          color: ColorsValue.white,
                        ),
                        InkWell(
                          onTap: () {
                            RouteManagement.goToViewPollVoteScreen("");
                          },
                          child: Center(
                            child: Text(
                              "View Votes",
                              style: Styles.main60014,
                            ),
                          ),
                        ),
                        Dimens.boxHeight5,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if ((widget.chatListsDocData.reactions
                                        ?.isNotEmpty ??
                                    false) &&
                                !widget.bookmarkList &&
                                !widget.favoriteList) ...[
                              InkWell(
                                onTap: widget.onEmojiRemove,
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
                                      widget.chatListsDocData.reactions?[0]
                                              .reaction ??
                                          "",
                                      style: Styles.black40014,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            if (!widget.favoriteList) ...[
                              Dimens.boxWidth3,
                              Visibility(
                                visible: widget.chatListsDocData.bookmarks
                                        ?.isNotEmpty ??
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
                            if (!widget.bookmarkList) ...[
                              Dimens.boxWidth3,
                              Visibility(
                                visible: widget.chatListsDocData.favorites
                                        ?.isNotEmpty ??
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
                      ],
                    ),
                  ],
                ),
              ),
              if (!widget.isGroup) ...[
                Row(
                  children: [
                    Text(
                      Utility.getTimeStempToTimeHHMMAA(
                          widget.chatListsDocData.senttimestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (widget.isSeenStatus) ...[
                      Dimens.boxWidth5,
                      widget.isSend
                          ? SvgPicture.asset(
                              widget.chatListsDocData.status == "seen"
                                  ? AssetConstants.seenIcon
                                  : widget.chatListsDocData.status ==
                                          "delivered"
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
                          widget.chatListsDocData.timestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (widget.isSeenStatus) ...[
                      Dimens.boxWidth5,
                      widget.isSend
                          ? SvgPicture.asset(
                              widget.chatListsDocData.statuses?.every(
                                          (element) =>
                                              element.status == "seen") ??
                                      false
                                  ? AssetConstants.seenIcon
                                  : widget.chatListsDocData.statuses?.every(
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
        ),
      ],
    );
  }
}
