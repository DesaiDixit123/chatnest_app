import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PrivacySecurityScreen extends StatelessWidget {
  const PrivacySecurityScreen({super.key});

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
                "privacy_Security".tr,
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
                'read_receipt'.tr,
                style: Styles.black50016,
              ),
              trailing: CupertinoSwitch(
                value: controller.isReceipts,
                activeColor: ColorsValue.maincolor1,
                onChanged: (value) {
                  controller.isReceipts = value;
                  controller.postReadReceiptsstatus();
                  controller.update();
                },
              ),
            ),
            Padding(
              padding: Dimens.edgeInsets20_0_20_0,
              child: Text(
                'When this is on, people are notified when you have/nread their messages. This enables read receipts for all conversations.',
                style: Styles.greyColor888840012,
              ),
            ),
            // ListTile(
            //   contentPadding: Dimens.edgeInsets20_0_20_0,
            //   title: Text(
            //     'last_seen_online'.tr,
            //     style: Styles.black50016,
            //   ),
            //   trailing: CupertinoSwitch(
            //     value: controller.isSeenOnline,
            //     activeColor: ColorsValue.maincolor1,
            //     onChanged: (value) {
            //       controller.isSeenOnline = value;
            //       controller.postLastSeenOnlineOfflineStatus();
            //       controller.update();
            //     },
            //   ),
            // ),
            // Padding(
            //   padding: Dimens.edgeInsets20_0_20_0,
            //   child: Text(
            //     'who_can_seem_last_seen'.tr,
            //     style: Styles.greyColor888850012,
            //   ),
            // ),
            // Dimens.boxHeight14,
            // RadioListTile(
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            //   visualDensity: const VisualDensity(
            //       horizontal: VisualDensity.minimumDensity,
            //       vertical: VisualDensity.minimumDensity),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'everyone'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 0,
            //   groupValue: controller.seen,
            //   onChanged: (value) {
            //     controller.seen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            // ),
            // RadioListTile(
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            //   visualDensity: const VisualDensity(
            //       horizontal: VisualDensity.minimumDensity,
            //       vertical: VisualDensity.minimumDensity),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'my_contacts'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 1,
            //   groupValue: controller.seen,
            //   onChanged: (value) {
            //     controller.seen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            // ),
            // RadioListTile(
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            //   visualDensity: const VisualDensity(
            //       horizontal: VisualDensity.minimumDensity,
            //       vertical: VisualDensity.minimumDensity),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'my_contacts_except'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 2,
            //   groupValue: controller.seen,
            //   onChanged: (value) {
            //     controller.seen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            // ),
            // RadioListTile(
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            //   visualDensity: const VisualDensity(
            //     horizontal: VisualDensity.minimumDensity,
            //     vertical: VisualDensity.minimumDensity,
            //   ),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'nobody'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 3,
            //   groupValue: controller.seen,
            //   onChanged: (value) {
            //     controller.seen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            // ),
            // Divider(
            //   color: ColorsValue.greyE4E4E4,
            // ),
            // Padding(
            //   padding: Dimens.edgeInsets20_0_20_0,
            //   child: Text(
            //     'who_can_see_online'.tr,
            //     style: Styles.greyColor888850012,
            //   ),
            // ),
            // Dimens.boxHeight14,
            // RadioListTile(
            //   visualDensity: const VisualDensity(
            //       horizontal: VisualDensity.minimumDensity,
            //       vertical: VisualDensity.minimumDensity),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'everyone'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 0,
            //   groupValue: controller.notSeen,
            //   onChanged: (value) {
            //     controller.notSeen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            // ),
            // RadioListTile(
            //   contentPadding: Dimens.edgeInsets10_0_10_0,
            //   visualDensity: const VisualDensity(
            //       horizontal: VisualDensity.minimumDensity,
            //       vertical: VisualDensity.minimumDensity),
            //   materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            //   title: Text(
            //     'same_last_seen'.tr,
            //     style: Styles.black50018,
            //   ),
            //   value: 1,
            //   groupValue: controller.notSeen,
            //   onChanged: (value) {
            //     controller.notSeen = value!;
            //     controller.update();
            //   },
            //   activeColor: ColorsValue.appColor,
            // ),
            // Padding(
            //   padding: Dimens.edgeInsets20_0_20_0,
            //   child: Text(
            //     "If you don't share when you were last seen or online, you won't be able to see when other people were last seen or online.",
            //     style: Styles.greyColor888840012,
            //   ),
            // ),
          ],
        ),
      );
    });
  }
}
