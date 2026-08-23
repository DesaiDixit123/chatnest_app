import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "notification".tr,
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
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            ListTile(
              onTap: () {
                RouteManagement.goToAllNotificationScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'mute_my_noti'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            if (!Platform.isIOS) ...[
              ListTile(
                onTap: () {
                  RouteManagement.goToRingtoneScreen();
                },
                contentPadding: Dimens.edgeInsets20_0_20_0,
                title: Text(
                  'ringtone'.tr,
                  style: Styles.black50016,
                ),
              ),
              Dimens.boxHeight5,
              Divider(
                height: Dimens.one,
                color: ColorsValue.greyE4E4E4,
              ),
              Dimens.boxHeight5,
            ]
          ],
        ),
      );
    });
  }
}
