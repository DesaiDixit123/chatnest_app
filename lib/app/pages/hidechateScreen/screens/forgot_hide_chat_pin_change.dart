import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ForgotHideChatScreen extends StatelessWidget {
  const ForgotHideChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HideChatController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          shadowColor: ColorsValue.greyAAAAAA,
          backgroundColor: ColorsValue.white,
          elevation: Dimens.zero,
          centerTitle: false,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: Dimens.edgeInsets20_15_10_15,
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        body: ListView(
          padding: Dimens.edgeInsets20,
          physics: const ClampingScrollPhysics(),
          children: [
            Text(
              'forgot_hide_chat_msg'.tr,
              style: Styles.black60032,
            ),
            Dimens.boxHeight10,
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'We’ve just sent a link to '.tr,
                  style: Styles.black40014,
                ),
              ],
            ),
            Flexible(
              child: Text(
                "${Get.find<HomeScreenController>().profileData.recoveryEmail ?? ""}",
                style: Styles.main60014,
                maxLines: 2,
              ),
            ),
            Dimens.boxHeight10,
            Text(
              "Check your email to know your otp.",
              style: Styles.black40014,
            ),
            Dimens.boxHeight30,
            SvgPicture.asset(AssetConstants.ic_forgot_vector),
            Dimens.boxHeight40,
            CustomButton(
              height: Dimens.fifty,
              text: "cheack_mail".tr.toUpperCase(),
              onTap: () {
                controller.postForgotPinHide();
              },
            ),
            Dimens.boxHeight10,
            InkWell(
              onTap: () {
                Get.back();
              },
              child: Center(
                child: Text(
                  'back_hide_pin'.tr,
                  style: Styles.mainUnderline40014,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
