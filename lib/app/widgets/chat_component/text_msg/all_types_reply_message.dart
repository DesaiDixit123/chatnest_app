import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class ReplyTextMessage extends StatelessWidget {
  ReplyTextMessage({
    super.key,
    required this.userName,
    required this.message,
    required this.onTap,
  });

  String? userName;
  String? message;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName ?? "",
                          style: Styles.main70014,
                        ),
                        Flexible(
                          child: Padding(
                            padding: Dimens.edgeInsets3,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: onTap,
                                child: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Text(
                      message ?? "",
                      style: Styles.greyColor888840012,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyImageMessage extends StatelessWidget {
  ReplyImageMessage({
    super.key,
    required this.userName,
    required this.image,
    required this.onTap,
  });

  String? userName;
  String? image;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
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
                child: Stack(
                  children: [
                    Container(
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
                          imageUrl: ApiWrapper.imageUrl + (image ?? ""),
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
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: Dimens.edgeInsets3,
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            height: Dimens.twenty,
                            width: Dimens.twenty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: Dimens.fifteen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyLinksMsg extends StatelessWidget {
  ReplyLinksMsg({
    super.key,
    required this.message,
    required this.userName,
    required this.image,
    required this.onTap,
  });

  String? message;
  String? userName;
  String? image;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
            Expanded(
              flex: 3,
              child: Padding(
                padding: Dimens.edgeInsets5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName ?? "",
                          style: Styles.main70014,
                        ),
                      ],
                    ),
                    Dimens.boxHeight5,
                    Text(
                      message.toString(),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.greyColor888840012,
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyDocsWithText extends StatelessWidget {
  ReplyDocsWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
  });

  String? message;
  String? userName;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
                        style: Styles.main70014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AssetConstants.ic_document,
                        height: Dimens.fifteen,
                        width: Dimens.fifteen,
                      ),
                      Dimens.boxWidth5,
                      Text(
                        message.toString(),
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
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyVideoWithTextMsg extends StatefulWidget {
  ReplyVideoWithTextMsg({
    super.key,
    required this.message,
    required this.userName,
    required this.video,
    required this.onTap,
  });

  String? message;
  String? userName;
  String? video;
  void Function()? onTap;

  @override
  State<ReplyVideoWithTextMsg> createState() => _ReplyVideoWithTextMsgState();
}

class _ReplyVideoWithTextMsgState extends State<ReplyVideoWithTextMsg> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _getThumbnail();
  }

  Future<void> _getThumbnail() async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: ApiWrapper.imageUrl + (widget.video ?? ""),
      imageFormat: ImageFormat.PNG,
      maxWidth: 100,
      quality: 50,
    );
    setState(() {
      _thumbnail = thumbnail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.userName ?? "",
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
                child: Stack(
                  children: [
                    Container(
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
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: Dimens.edgeInsets3,
                        child: InkWell(
                          onTap: widget.onTap,
                          child: Container(
                            height: Dimens.twenty,
                            width: Dimens.twenty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: Dimens.fifteen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyLocationWithText extends StatelessWidget {
  ReplyLocationWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
  });

  String? message;
  String? userName;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
                        style: Styles.main70014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Row(
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
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyContactWithTextMsg extends StatelessWidget {
  ReplyContactWithTextMsg({
    super.key,
    required this.message,
    required this.userName,
    required this.image,
    required this.onTap,
  });

  String? message;
  String? userName;
  String? image;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
                        style: Styles.main70014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: Dimens.fifteen,
                        color: ColorsValue.greyColor8888,
                      ),
                      Dimens.boxWidth5,
                      Text(
                        "Contact : ${message.toString()}",
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
                child: Stack(
                  children: [
                    Container(
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
                          imageUrl: ApiWrapper.imageUrl + (image ?? ""),
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
                    Positioned(
                      right: 0,
                      child: Padding(
                        padding: Dimens.edgeInsets3,
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            height: Dimens.twenty,
                            width: Dimens.twenty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: Dimens.fifteen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyMultiContactWithTextMsg extends StatelessWidget {
  ReplyMultiContactWithTextMsg({
    super.key,
    required this.userName,
    required this.message,
    required this.onTap,
  });

  String? userName;
  String? message;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName ?? "",
                          style: Styles.main70014,
                        ),
                        Flexible(
                          child: Padding(
                            padding: Dimens.edgeInsets3,
                            child: Align(
                              alignment: Alignment.topRight,
                              child: InkWell(
                                onTap: onTap,
                                child: const Icon(
                                  Icons.close,
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.person,
                          size: Dimens.fifteen,
                          color: ColorsValue.greyColor8888,
                        ),
                        Dimens.boxWidth3,
                        Text(
                          "${message} Contact",
                          style: Styles.greyColor888840012,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyPhoneContactWithTextMsg extends StatelessWidget {
  ReplyPhoneContactWithTextMsg({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
    this.image,
  });

  String? message;
  String? userName;
  void Function()? onTap;
  String? image;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
                        style: Styles.main70014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Row(
                    children: [
                      Icon(
                        Icons.person,
                        size: Dimens.fifteen,
                        color: ColorsValue.greyColor8888,
                      ),
                      Dimens.boxWidth5,
                      Text(
                        "PhoneContact : ${message.toString()}",
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
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyAudioWithText extends StatelessWidget {
  ReplyAudioWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
  });

  String? message;
  String? userName;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
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
            Flexible(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyPollWithText extends StatelessWidget {
  ReplyPollWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
  });

  String? message;
  String? userName;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        userName ?? "",
                        style: Styles.main70014,
                      ),
                    ],
                  ),
                  Dimens.boxHeight5,
                  Row(
                    children: [
                      SvgPicture.asset(
                        AssetConstants.ic_poll_reply,
                        height: Dimens.fifteen,
                        width: Dimens.fifteen,
                      ),
                      Dimens.boxWidth5,
                      Text(
                        message.toString(),
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
                child: Padding(
                  padding: Dimens.edgeInsets3,
                  child: InkWell(
                    onTap: onTap,
                    child: Container(
                      height: Dimens.twenty,
                      width: Dimens.twenty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.hundred,
                        ),
                        color: ColorsValue.white,
                      ),
                      child: Center(
                        child: Icon(
                          Icons.close,
                          size: Dimens.fifteen,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyProductMessage extends StatelessWidget {
  ReplyProductMessage({
    super.key,
    required this.productImage,
    required this.productName,
    required this.productDes,
    required this.productPrice,
    required this.onTap,
  });

  String? productImage;
  String? productName;
  String? productDes;
  String? productPrice;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.greyColorEEEE,
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
            Container(
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
                  imageUrl: ApiWrapper.imageUrl + (productImage ?? ""),
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
            Dimens.boxWidth3,
            Flexible(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              productName ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.black50012,
                            ),
                            Text(
                              productDes ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.grey9BA40012,
                            ),
                          ],
                        ),
                      ),
                      Dimens.boxWidth10,
                      Padding(
                        padding: Dimens.edgeInsets3,
                        child: InkWell(
                          onTap: onTap,
                          child: Container(
                            height: Dimens.twenty,
                            width: Dimens.twenty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.white,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.close,
                                size: Dimens.fifteen,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    "${'currency_symbol'.tr} ${productPrice}",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.main40012,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyVideoCallWithText extends StatelessWidget {
  ReplyVideoCallWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
    this.isConference = false,
  });

  String? message;
  String? userName;
  bool isConference;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName ?? "",
                          style: Styles.main70014,
                        ),
                        Padding(
                          padding: Dimens.edgeInsets3,
                          child: InkWell(
                            onTap: onTap,
                            child: Container(
                              height: Dimens.twenty,
                              width: Dimens.twenty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: Dimens.fifteen,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Dimens.boxHeight5,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetConstants.videoIcon,
                          height: Dimens.fifteen,
                          width: Dimens.fifteen,
                          colorFilter: ColorFilter.mode(
                            ColorsValue.greyColor8888,
                            BlendMode.srcIn,
                          ),
                        ),
                        Dimens.boxWidth5,
                        Text(
                          isConference
                              ? "conference_call".tr
                              : "video_call".tr,
                          style: Styles.greyColor888840012,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class ReplyAudioCallWithText extends StatelessWidget {
  ReplyAudioCallWithText({
    super.key,
    required this.message,
    required this.userName,
    required this.onTap,
    this.isConference = false,
  });

  String? message;
  String? userName;
  bool isConference;
  void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: Dimens.edgeInsetsBottom10,
      child: Container(
        height: Dimens.sixty,
        width: double.infinity,
        decoration: BoxDecoration(
          color: ColorsValue.textfildbackcolor,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          userName ?? "",
                          style: Styles.main70014,
                        ),
                        Padding(
                          padding: Dimens.edgeInsets3,
                          child: InkWell(
                            onTap: onTap,
                            child: Container(
                              height: Dimens.twenty,
                              width: Dimens.twenty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.white,
                              ),
                              child: Center(
                                child: Icon(
                                  Icons.close,
                                  size: Dimens.fifteen,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Dimens.boxHeight5,
                    Row(
                      children: [
                        SvgPicture.asset(
                          AssetConstants.callicon,
                          height: Dimens.fifteen,
                          width: Dimens.fifteen,
                          colorFilter: ColorFilter.mode(
                            ColorsValue.greyColor8888,
                            BlendMode.srcIn,
                          ),
                        ),
                        Dimens.boxWidth5,
                        Text(
                          isConference
                              ? "conference_call".tr
                              : "audio_call".tr,
                          style: Styles.greyColor888840012,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
