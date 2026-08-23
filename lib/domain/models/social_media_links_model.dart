import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

SocialMediaLinksModel socialMediaLinksModelFromJson(String str) =>
    SocialMediaLinksModel.fromJson(json.decode(str));

class SocialMediaLinksModel {
  List<Socialmedialink> socialmedialinks;

  SocialMediaLinksModel({
    required this.socialmedialinks,
  });

  factory SocialMediaLinksModel.fromJson(Map<String, dynamic> json) =>
      SocialMediaLinksModel(
        socialmedialinks: List<Socialmedialink>.from(
          json["socialmedialinks"].map(
            (x) => Socialmedialink.fromJson(x),
          ),
        ),
      );

  Map<String, dynamic> toJson() => {
        "socialmedialinks": List<dynamic>.from(
          socialmedialinks.map(
            (x) => x.toJson(),
          ),
        ),
      };
}

class Socialmedialink {
  String? icon;
  String platform;
  String url;
  double size;
  String? hintText;
  TextEditingController? textEditingController;

  Socialmedialink(
      {this.icon = "",
      required this.platform,
      required this.url,
      this.size = 0,
      this.hintText,
      this.textEditingController});

  factory Socialmedialink.fromJson(Map<String, dynamic> json) =>
      Socialmedialink(
        platform: json["platform"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "platform": platform,
        "url": url,
      };
}

class Businesshours {
  bool? switchValue;
  String? title;
  bool? isnewbusinesshour;
  TimeOfDay? selectedstartTime, selectedendTime, newstarttime, newendTime;

  Businesshours({
    this.title,
    this.newendTime,
    required this.selectedendTime,
    required this.selectedstartTime,
    this.newstarttime,
    this.isnewbusinesshour,
    required this.switchValue,
  });

  factory Businesshours.fromJson(Map<String, dynamic> json) => Businesshours(
        selectedstartTime: json["selectedstartTime"],
        selectedendTime: json["selectedendTime"],
        newstarttime: json["newstarttime"],
        newendTime: json["newendTime"],
        switchValue: json["switchValue"],
        isnewbusinesshour: json["isnewbusinesshour"],
      );

  Map<String, dynamic> toJson() => {
        "selectedstartTime": selectedstartTime,
        "selectedendTime": selectedendTime,
        "switchValue": switchValue,
      };
}

class acceptRequest {
  String? title, subtitle;
  SvgPicture? icon;
  bool? switchValue;

  acceptRequest({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.switchValue,
  });

  factory acceptRequest.fromJson(Map<String, dynamic> json) => acceptRequest(
        icon: json['icon'],
        title: json['title'],
        subtitle: json['subtitle'],
        switchValue: json["switchValue"],
      );

  Map<String, dynamic> toJson() => {
        'icon': icon,
        'title': title,
        'subtitle': subtitle,
        "switchValue": switchValue,
      };
}
