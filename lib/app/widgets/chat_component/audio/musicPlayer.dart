import 'package:audioplayers/audioplayers.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class MusicPlay extends StatefulWidget {
  MusicPlay({
    super.key,
    required this.isSend,
    required this.message,
    required this.audioUrl,
    required this.isSeen,
    required this.isDelivered,
    required this.time,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isBrodcast = false,
    this.isSeenStatus = true,
  });

  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final bool isBrodcast;
  final String message;
  final String audioUrl;
  final String time;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;

  @override
  State<MusicPlay> createState() => _MusicPlayState();
}

class _MusicPlayState extends State<MusicPlay> {
  final player = AudioPlayer();
  bool isplay = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  String fromTime(int sec) {
    print(sec);
    return '${(Duration(seconds: sec))}'.split('.')[0].padLeft(8, '0');
  }

  @override
  void initState() {
    super.initState();

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

    player.onPlayerComplete.listen((event) {
      setState(() {
        event = PlayerState.stopped;
        duration = Duration.zero;
        getDuration(true);
      });
    });

    player.onPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
    getDuration(false);
  }

  getDuration(bool compleate) async {
    final playerss =
        await player.setSourceUrl(ApiWrapper.imageUrl + widget.audioUrl);
    var dur = await player.getDuration();
    print('Audio duration: ${duration.inMinutes} : ${duration.inSeconds}');
    if (compleate) {
      position = Duration.zero;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
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
                width: Get.width / 1.2,
                padding: Dimens.edgeInsets10_10_10_0,
                decoration: BoxDecoration(
                  color: widget.isSend
                      ? ColorsValue.lightmainColor
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.five),
                    bottomRight: Radius.circular(Dimens.five),
                    topRight: widget.isSend
                        ? Radius.zero
                        : Radius.circular(Dimens.five),
                    topLeft: widget.isSend
                        ? Radius.circular(Dimens.five)
                        : Radius.zero,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: Dimens.thirty,
                          child: SvgPicture.asset(
                              AssetConstants.attechMusicIcon,
                              height: Dimens.thirty),
                        ),
                        Dimens.boxWidth5,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                      onTap: () {
                                        !isplay
                                            ? player.play(
                                                UrlSource(ApiWrapper.imageUrl +
                                                    widget.audioUrl),
                                              )
                                            : player.pause();
                                      },
                                      child: !isplay
                                          ? SvgPicture.asset(
                                              AssetConstants.pulsemusic)
                                          : SvgPicture.asset(
                                              AssetConstants.playMusic)),
                                  Dimens.boxWidth10,
                                  Flexible(
                                    child: SliderTheme(
                                      data: SliderThemeData(
                                        trackShape: CustomTrackShape(),
                                        disabledActiveTrackColor: Colors.blue,
                                        disabledInactiveTrackColor:
                                            Colors.black12,
                                        trackHeight: 3,
                                        thumbShape: RoundSliderThumbShape(
                                          enabledThumbRadius: 6.0,
                                        ),
                                      ),
                                      child: Slider(
                                        inactiveColor: Colors.grey,
                                        activeColor: ColorsValue.maincolor1,
                                        min: 0,
                                        max: duration.inSeconds.toDouble(),
                                        value: position.inSeconds.toDouble(),
                                        onChanged: (val) {
                                          final position =
                                              Duration(seconds: val.toInt());
                                          player.seek(position);
                                          player.resume();
                                        },
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    fromTime((duration - position).inSeconds),
                                    style: Styles.greyColor888840012,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Dimens.boxHeight10,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.isSend && widget.isBrodcast) ...[
                          SvgPicture.asset(
                            AssetConstants.ic_outline_brodcast,
                          )
                        ],
                        Dimens.boxWidth5,
                        Text(
                          widget.time,
                          style: Styles.greyColor888840012,
                        ),
                        if (widget.isSeenStatus) ...[
                          Dimens.boxWidth5,
                          widget.isSend
                              ? SvgPicture.asset(
                                  widget.isSeen
                                      ? AssetConstants.seenIcon
                                      : widget.isDelivered
                                          ? AssetConstants.deliveredIcon
                                          : AssetConstants.unseenIcon,
                                )
                              : Dimens.box0
                        ],
                      ],
                    ),
                    Dimens.boxHeight5,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.emoji.isNotEmpty) ...[
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
                                  widget.emoji[0].reaction ?? "",
                                  style: Styles.black40014,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Dimens.boxWidth3,
                        Visibility(
                          visible: widget.isBookmark,
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
                          visible: widget.isFavorites,
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

class CustomTrackShape extends RoundedRectSliderTrackShape {
  @override
  Rect getPreferredRect({
    required RenderBox parentBox,
    Offset offset = Offset.zero,
    required SliderThemeData sliderTheme,
    bool isEnabled = false,
    bool isDiscrete = false,
  }) {
    final trackHeight = (sliderTheme.trackHeight);
    final trackLeft = offset.dy + (parentBox.size.width) / 590;
    final trackTop = offset.dy + (parentBox.size.height - trackHeight!) / 2;
    final trackWidth = parentBox.size.width / 1.1;
    return Rect.fromLTWH(
      trackLeft,
      trackTop,
      trackWidth,
      trackHeight,
    );
  }
}
