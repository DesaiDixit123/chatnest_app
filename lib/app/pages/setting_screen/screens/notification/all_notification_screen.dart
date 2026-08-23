import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AllNotificationScreen extends StatelessWidget {
  const AllNotificationScreen({super.key});

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
                "mute_my_noti".tr,
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
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'mute_my_noti'.tr,
                style: Styles.black50016,
              ),
              trailing: CupertinoSwitch(
                value: !controller.isMessage && !controller.isGroup,
                activeColor: ColorsValue.maincolor1,
                onChanged: (value) {
                  controller.toggleMuteAll(value);
                },
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'msg_noti'.tr,
                style: Styles.black50016,
              ),
              trailing: CupertinoSwitch(
                value: controller.isMessage,
                activeColor: ColorsValue.maincolor1,
                onChanged: (value) {
                  controller.postNotificationStatusforChat();
                },
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'group_noti'.tr,
                style: Styles.black50016,
              ),
              trailing: CupertinoSwitch(
                value: controller.isGroup,
                activeColor: ColorsValue.maincolor1,
                onChanged: (value) {
                  controller.postNotificationStatusforGroup();
                },
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
          ],
        ),
      );
    });
  }
}
