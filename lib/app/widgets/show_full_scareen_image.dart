import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';
import 'package:video_player/video_player.dart';

class ShowFullScareenImage extends StatelessWidget {
  ShowFullScareenImage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                Get.arguments[1],
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                Get.back();
              },
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
        ),
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Container(
            color: ColorsValue.appColor,
            child: PhotoViewGallery.builder(
              backgroundDecoration: const BoxDecoration(
                color: ColorsValue.white,
              ),
              builder: (BuildContext context, int index) {
                switch (Get.arguments[1]) {
                  case "Photo":
                    return buildForImage(Get.arguments[0]);
                  case "Video":
                    return buildForVideo(Get.arguments[0]);
                  default:
                    return buildForImage(Get.arguments[0]);
                }
              },
              itemCount: 1,
            ),
          ),
        ),
      );
    });
  }

  PhotoViewGalleryPageOptions buildForImage(image) {
    return PhotoViewGalleryPageOptions(
      imageProvider: CachedNetworkImageProvider(ApiWrapper.imageUrl + image),
      initialScale: PhotoViewComputedScale.contained * 1,
      minScale: PhotoViewComputedScale.contained * 1,
    );
  }

  PhotoViewGalleryPageOptions buildForVideo(video) {
    return PhotoViewGalleryPageOptions.customChild(
      child: GalleryAllVideoPlayer(video),
      initialScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
    );
  }
}

// ignore: must_be_immutable
class GalleryAllVideoPlayer extends StatefulWidget {
  dynamic video;

  GalleryAllVideoPlayer(this.video, {super.key});

  @override
  _GalleryAllVideoPlayerState createState() => _GalleryAllVideoPlayerState();
}

class _GalleryAllVideoPlayerState extends State<GalleryAllVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool _visible = false;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      ApiWrapper.imageUrl + widget.video,
    );
    _controller!.setLooping(true);
    _initializeVideoPlayerFuture = _controller!.initialize();
    _initializeVideoPlayerFuture!.then((val) {
      setState(() {
        _controller!.play();
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsValue.white,
      body: Stack(
        children: <Widget>[
          InkWell(
            onTap: () {
              setState(() {
                if (_controller!.value.isPlaying) {
                  _controller!.pause();
                } else {
                  _controller!.play();
                }
                _visible = true;
              });
              Timer(const Duration(milliseconds: 1000), () {
                setState(() {
                  _visible = false;
                });
              });
            },
            child: Center(
              child: FutureBuilder(
                future: _initializeVideoPlayerFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return AspectRatio(
                      aspectRatio: _controller!.value.aspectRatio,
                      child: VideoPlayer(_controller!),
                    );
                  } else {
                    return const CircularProgressIndicator();
                  }
                },
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _visible ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 500),
              child: Container(
                color: Colors.transparent,
                child: Icon(
                  !_controller!.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow,
                  color: ColorsValue.secondaryColor,
                  size: Dimens.sixty,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: Dimens.twenty,
            left: Dimens.zero,
            right: Dimens.zero,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: Dimens.fiftyFive),
              child: VideoProgressIndicator(
                _controller!,
                padding: Dimens.edgeInsets0,
                colors: VideoProgressColors(
                    playedColor: ColorsValue.appColor,
                    bufferedColor: ColorsValue.secondaryColor.withAlpha(100),
                    backgroundColor: ColorsValue.appColor.withAlpha(100)),
                allowScrubbing: true,
              ),
            ),
          )
        ],
      ),
    );
  }
}
