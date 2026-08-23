import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

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
                "privacy_policy".tr,
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
              '1. SECURITY AND PRIVACY POLICY'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              '1.1 PURPOSE'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "The purpose of this policy is to safeguard users' personal data and communications by ensuring the implementation of advanced security mechanisms, including but not limited to end-to-end encryption. This policy outlines the steps taken by CHATNEST to ensure user privacy and data protection, in compliance with applicable legal standards such as the General Data Protection Regulation (GDPR) and California Consumer Privacy Act (CCPA).",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.2 DATA ENCRYPTION'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "CHATNEST employs end-to-end encryption to ensure that only the intendedusers have access to the messages they send and receive. No third party,including the service provider, can access or intercept these communications.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.3 DATA COLLECTION'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "We collect the following data from users for the purpose of providing and improving our services:",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              "=> User's phone number or email address;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> IP address;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Metadata related to communications (e.g., timestamps, message delivery status);",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Device Location (latitude and longitude) when you share location in chat or select address markers on maps;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> No content from the actual messages is stored on our servers beyond what is necessary for transmission and delivery.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.3.1 LOCATION DATA USAGE & DISCLOSURE'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "CHATNEST accesses precise and approximate device location data strictly in the foreground while you actively use location-dependent features (e.g., sharing your current location in a chat message or setting address markers on Google Maps). Location coordinates are securely transmitted via encrypted HTTPS/TLS to CHATNEST servers solely to deliver location attachments to recipients or display map pins. CHATNEST does NOT track, collect, or access your device location in the background when the app is closed or minimized. You can grant, deny, or revoke location permissions at any time via your device settings.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.4 DATA USAGE'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "We use the data collected for:",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              "=> Authenticating users;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Delivering messages;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Troubleshooting service issues;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Enhancing user experience and developing new features.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "We do not sell, share, or otherwise distribute personal data to third parties except as required by law or as necessary for the operation of the service.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.5 USER CONSENT'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "By using CHATNEST, users consent to the collection, processing, and storage of their data as outlined in this policy.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.6 BREACH NOTIFICATION'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "In the event of a data breach, we will notify affected users and the relevant regulatory authorities within 3 to 4 working days as required under applicable law.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.7 CONTACT US'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "If you have any questions or concerns about this Privacy Policy or our data practices, please contact us at:\nEmail: admin@thekhushiempire.com\nPhone: +91 9924697299",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              '1.8 ACCOUNT DELETION'.tr,
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "You have the right to permanently delete your ChatNest account and associated personal data at any time. When you delete your account, the following data is permanently removed from our servers:",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              "=> Your profile information (name, photo, mobile number, email);",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your authentication and session data;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your chat messages (individual and group);",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your status posts, polls, and broadcasts;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your business profile and products;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your contacts, friend requests, and notifications;",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight5,
            Text(
              "=> Your FCM/push notification tokens.",
              style: Styles.greyColor888840014,
            ),
            Dimens.boxHeight16,
            Text(
              "HOW TO DELETE YOUR ACCOUNT:",
              style: Styles.black70016,
            ),
            Dimens.boxHeight16,
            Text(
              "Option 1 — In-app:\n1. Open ChatNest.\n2. Go to Settings.\n3. Tap My Account.\n4. Tap Delete My Account.\n5. Confirm by tapping YES.\n\nOption 2 — Web:\nVisit https://api.cochat.click/account-deletion to request account deletion using your registered mobile number and OTP verification.",
              style: Styles.greyColor888840014,
            ),
          ],
        ),
      );
    });
  }
}
