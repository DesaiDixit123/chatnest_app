import 'package:flutter/material.dart';

class AgoraUser {
   int uid;
  String? name;
  String? bannerImg;
  bool? isAudioEnabled;
  bool? isVideoEnabled;
  bool? isSpeakerPhone;
  Widget? view;

  AgoraUser({
    required this.uid,
    this.name,
    this.isAudioEnabled,
    this.isVideoEnabled,
    this.isSpeakerPhone,
    this.bannerImg,
    this.view,
  });
}
