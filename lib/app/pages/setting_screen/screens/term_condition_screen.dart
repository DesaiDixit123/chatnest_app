import 'package:chatnest/app/app.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class TermConditionScreen extends StatelessWidget {
  const TermConditionScreen({super.key});

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
                "tearm_condition".tr,
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
          physics: const ClampingScrollPhysics(),
          children: [
            // ─── Zero-Tolerance Banner (visible without scrolling) ───────────
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFFFFF3CD),
                border: Border.all(color: const Color(0xFFFFD600), width: 1.5),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined,
                      color: Color(0xFFB8860B), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Zero Tolerance Policy',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7A5700),
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'ChatNest has a zero-tolerance policy for objectionable content or abusive users. Any violations may result in immediate account suspension or permanent ban.',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7A5700),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Dimens.boxHeight16,
            // ─────────────────────────────────────────────────────────────────
            Text(
              'Welcome to ChatNest. These terms and conditions outline the rules and regulations for the use of our app.'
                  .tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              'Acceptance of Terms'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'By accessing this app, we assume you accept these terms and conditions. Do not continue to use ChatNest if you do not agree to all of the terms and conditions stated on this page.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'User Responsibility'.tr,
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
                "Users are responsible for maintaining the confidentiality of their account information.",
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
                "Users agree not to use the app for any unlawful or prohibited activities.",
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
                "All content shared on the platform must respect community guidelines and intellectual property rights.",
                maxLines: 2,
                style: Styles.greyColor888840014,
              ),
            ),
            Dimens.boxHeight16,
            Text(
              'Content Policy & Zero Tolerance'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'By using this application, users agree not to upload, share, or post any abusive, harmful, offensive, hateful, sexual, misleading, or objectionable content.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight10,
            Text(
              'ChatNest maintains a zero-tolerance policy against abusive users and objectionable content. Any violating content may be removed and accounts may be suspended or permanently banned without notice.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight10,
            Text(
              'Users are responsible for the content they share within the application.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'Privacy Policy'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'We are committed to protecting your privacy. Please review our Privacy Policy to understand how we collect, use, and safeguard your personal information.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'Modification of Terms'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              'ChatNest reserves the right to revise these terms at any time. By using this app, you are expected to review these terms on a regular basis.'
                  .tr,
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              'Contact Information'.tr,
              style: Styles.black50014,
            ),
            Dimens.boxHeight5,
            Text(
              "If you have any questions or concerns about these Terms & Conditions, please contact us at:\nEmail: admin@thekhushiempire.com\nPhone: +91 9924697299",
              style: Styles.greyColor888840014,
            ),
          ],
        ),
      );
    });
  }
}
