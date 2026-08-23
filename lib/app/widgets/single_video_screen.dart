// ignore_for_file: must_be_immutable

import 'dart:async';
import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class SingleFullScreenImageVideo extends StatelessWidget {
  SingleFullScreenImageVideo({super.key});

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
        backgroundColor: ColorsValue.appColor,
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

  PhotoViewGalleryPageOptions buildForImage(video) {
    return PhotoViewGalleryPageOptions.customChild(
      child: GalleryImage(video),
      initialScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
    );
  }

  PhotoViewGalleryPageOptions buildForVideo(video) {
    return PhotoViewGalleryPageOptions.customChild(
      child: GalleryVideoPlayer(video),
      initialScale: PhotoViewComputedScale.contained,
      maxScale: PhotoViewComputedScale.contained,
    );
  }
}

class GalleryVideoPlayer extends StatefulWidget {
  dynamic video;

  GalleryVideoPlayer(this.video, {super.key});

  @override
  _GalleryVideoPlayerState createState() => _GalleryVideoPlayerState();
}

class _GalleryVideoPlayerState extends State<GalleryVideoPlayer> {
  VideoPlayerController? _controller;
  Future<void>? _initializeVideoPlayerFuture;
  bool _visible = false;

  @override
  void initState() {
    _controller = VideoPlayerController.file(File(widget.video));
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

class GalleryImage extends StatefulWidget {
  dynamic video;

  GalleryImage(this.video, {super.key});

  @override
  _GalleryImageState createState() => _GalleryImageState();
}

class _GalleryImageState extends State<GalleryImage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Image.file(
        File(widget.video),
        fit: BoxFit.cover,
      ),
    ));
  }
}
