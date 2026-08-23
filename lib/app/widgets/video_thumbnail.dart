import 'dart:typed_data';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class VideoThumbnailWidget extends StatefulWidget {
  const VideoThumbnailWidget({
    super.key,
    required this.video,
    this.width,
    this.height,
    this.isImagePath = true,
  });

  final String video;
  final double? width;
  final double? height;
  final bool isImagePath;

  @override
  State<VideoThumbnailWidget> createState() => _VideoThumbnailWidgetState();
}

class _VideoThumbnailWidgetState extends State<VideoThumbnailWidget> {
  Uint8List? _thumbnail;

  @override
  void initState() {
    super.initState();
    _getThumbnail();
  }

  Future<void> _getThumbnail() async {
    final thumbnail = await VideoThumbnail.thumbnailData(
      video: widget.isImagePath
          ? ApiWrapper.imageUrl + widget.video
          : widget.video,
      imageFormat: ImageFormat.PNG,
      maxWidth: 100,
      quality: 100,
    );
    setState(() {
      _thumbnail = thumbnail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width ?? Dimens.twoHundredFifty,
      height: widget.height ?? Dimens.twoHundredFifty,
      color: Colors.white,
      child: _thumbnail != null
          ? Image.memory(
              _thumbnail!,
              fit: BoxFit.cover,
            )
          : Lottie.asset(
              AssetConstants.imageLoader,
              fit: BoxFit.cover,
            ),
    );
  }
}
