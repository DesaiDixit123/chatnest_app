import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

// ignore: must_be_immutable
class LinksWithVideoWithLinks extends StatefulWidget {
  LinksWithVideoWithLinks({
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
  State<LinksWithVideoWithLinks> createState() =>
      _LinksWithVideoWithLinksState();
}

class _LinksWithVideoWithLinksState extends State<LinksWithVideoWithLinks> {
  Uint8List? _thumbnail;

  final player = AudioPlayer();
  bool isplay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String fromTime(int sec) {
    return '${(Duration(seconds: sec))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();
    _getThumbnail();

    player.onPlayerStateChanged.listen((state) {
      setState(() {
        isplay = state == PlayerState.playing;
      });
    });

    player.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
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
          child: Row(
            children: [
              if ((widget.chatListsDocData.isedited ?? false) &&
                  widget.isSend) ...[
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
                crossAxisAlignment: widget.isSend
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                mainAxisAlignment: widget.isSend
                    ? MainAxisAlignment.end
                    : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimens.threeHundredSeventeen,
                    padding: Dimens.edgeInsets10_10_10_0,
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
                        Container(
                          height: msgCount! > 20
                              ? Dimens.seventyFive
                              : Dimens.sixty,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    widget.chatListsDocData.from
                                                        ?.id
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
                        Dimens.boxHeight5,
                        InkWell(
                          onTap: () {
                            Utility.launchLinkURL(
                                widget.chatListsDocData.content?.text.message ??
                                    "");
                          },
                          child: Text(
                            widget.chatListsDocData.content?.text.message ?? "",
                            style: Styles.main40014,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Dimens.boxHeight5,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (widget.chatListsDocData.reactions?.isNotEmpty ??
                                false) ...[
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
                            Dimens.boxWidth3,
                            Visibility(
                              visible: widget
                                      .chatListsDocData.bookmarks?.isNotEmpty ??
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
                              visible: widget
                                      .chatListsDocData.favorites?.isNotEmpty ??
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
                        ]
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
                        ]
                      ],
                    )
                  ]
                ],
              ),
              if ((widget.chatListsDocData.isedited ?? false) &&
                  !widget.isSend) ...[
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
