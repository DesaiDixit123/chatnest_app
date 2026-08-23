import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class LoginSubUserScreen extends StatelessWidget {
  const LoginSubUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      initState: (state) {
        var controller = Get.find<LoginController>();
        controller.userController.clear();
        controller.passwordController.clear();
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.whiteColor,
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets30_0_30_0,
            child: Form(
              key: controller.subUserKey,
              child: ListView(
                children: [
                  Padding(
                    padding: Dimens.edgeInsetsTopt49,
                    child: Text(
                      "welcome".tr,
                      style: Styles.main70030,
                    ),
                  ),
                  Dimens.boxHeight20,
                  Text(
                    "login_to_sub_user".tr,
                    style: Styles.black70024,
                  ),
                  Dimens.boxHeight10,
                  Text(
                    "login_sub_user_des".tr,
                    style: Styles.hinttext40014,
                  ),
                  Dimens.boxHeight56,
                  CustomTextFormField(
                    hintText: 'username'.tr,
                    isCompulsoryText: true,
                    keybordtype: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorsValue.textfildbackcolor,
                    controller: controller.userController,
                    validation: (p0) {
                      if (p0!.isEmpty) {
                        return 'enter_username'.tr;
                      }
                      return null;
                    },
                  ),
                  Dimens.boxHeight20,
                  CustomTextFormField(
                    hintText: 'password'.tr,
                    isCompulsoryText: true,
                    obscure: controller.isShow ? true : false,
                    textInputAction: TextInputAction.done,
                    fillColor: ColorsValue.textfildbackcolor,
                    controller: controller.passwordController,
                    validation: (p0) {
                      if (p0!.isEmpty) {
                        return 'enter_password'.tr;
                      }
                      return null;
                    },
                    suffixIcon: InkWell(
                      onTap: () {
                        if (controller.isShow) {
                          controller.isShow = false;
                        } else {
                          controller.isShow = true;
                        }
                        controller.update();
                      },
                      child: Padding(
                        padding: Dimens.edgeInsets0_12_0_12,
                        child: SvgPicture.asset(
                          !controller.isShow
                              ? AssetConstants.ic_show
                              : AssetConstants.ic_hide,
                          height: Dimens.sixteen,
                          width: Dimens.twenty,
                          colorFilter: ColorFilter.mode(
                            controller.isShow
                                ? ColorsValue.greyColor8888
                                : ColorsValue.blackColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dimens.boxHeight43,
                  GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child: Center(
                      child: Text(
                        'Login As A User'.tr,
                        style: Styles.mainUnderline40016,
                      ),
                    ),
                  ),
                  Dimens.boxHeight35,
                  CustomButton(
                    height: Dimens.fifty,
                    text: 'login'.tr.toUpperCase(),
                    onTap: () {
                      if (controller.subUserKey.currentState!.validate()) {
                        controller.postSubUserLogin();
                      }
                    },
                    backgroundColor: ColorsValue.maincolor1,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
