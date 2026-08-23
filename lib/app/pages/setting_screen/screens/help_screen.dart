import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class HelpScreen extends StatelessWidget {
  const HelpScreen({super.key});

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
                "help".tr,
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
          padding: Dimens.edgeInsets20,
          physics: ClampingScrollPhysics(),
          children: [
            Text(
              'Welcome to ChatNest Help. Find answers to common questions and learn how to use our features.'
                  .tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              'Getting Started'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'To start chatting, simply sync your contacts and find your friends on ChatNest. You can send messages, photos, and videos instantly.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'Common Questions'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              contentPadding: Dimens.edgeInsets0,
              minLeadingWidth: 0,
              leading: Container(
                margin: Dimens.edgeInsetsTop10,
                height: Dimens.two,
                width: Dimens.two,
                decoration: BoxDecoration(
                    color: ColorsValue.greyColor8888,
                    borderRadius: BorderRadius.circular(Dimens.hundred)),
              ),
              title: Text(
                "How do I change my profile picture?",
                maxLines: 2,
                style: Styles.greyColor888840014,
              ),
            ),
            ListTile(
              titleAlignment: ListTileTitleAlignment.top,
              contentPadding: Dimens.edgeInsets0,
              minLeadingWidth: 0,
              leading: Container(
                margin: Dimens.edgeInsetsTop10,
                height: Dimens.two,
                width: Dimens.two,
                decoration: BoxDecoration(
                    color: ColorsValue.greyColor8888,
                    borderRadius: BorderRadius.circular(Dimens.hundred)),
              ),
              title: Text(
                "How can I block or unblock a user?",
                maxLines: 2,
                style: Styles.greyColor888840014,
              ),
            ),
            ListTile(
              contentPadding: Dimens.edgeInsets0,
              titleAlignment: ListTileTitleAlignment.top,
              minLeadingWidth: 0,
              leading: Container(
                margin: Dimens.edgeInsetsTop10,
                height: Dimens.two,
                width: Dimens.two,
                decoration: BoxDecoration(
                    color: ColorsValue.greyColor8888,
                    borderRadius: BorderRadius.circular(Dimens.hundred)),
              ),
              title: Text(
                "Is my data secure on ChatNest?",
                maxLines: 2,
                style: Styles.greyColor888840014,
              ),
            ),
            Dimens.boxHeight16,
            Text(
              'Security Features'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'ChatNest uses industry-standard encryption to protect your messages and personal data. You can manage your privacy settings in the account section.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'Contact Support'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'If you need further assistance, please reach out to our support team through the app or via email.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
          ],
        ),
      );
    });
  }
}
