import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SubUserChangePasswordScreen extends StatelessWidget {
  const SubUserChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.subUserId = Get.arguments ?? "";
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "change_password".tr,
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
        bottomNavigationBar: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: Dimens.edgeInsets20,
              child: CustomButton(
                text: 'change_password'.tr.toUpperCase(),
                onTap: () {
                  if (controller.passKey.currentState!.validate()) {
                    controller.postChangePassword();
                  }
                },
                backgroundColor: ColorsValue.appColor,
                height: Dimens.fifty,
                style: Styles.white50016,
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Form(
            key: controller.passKey,
            child: ListView(
              padding: Dimens.edgeInsets20,
              physics: const ClampingScrollPhysics(),
              children: [
                Image.asset(
                  AssetConstants.ic_password_png,
                  height: Dimens.twoHundredThirty,
                  width: double.maxFinite,
                ),
                Dimens.boxHeight50,
                CustomTextFormField(
                  controller: controller.newController,
                  hintText: 'new_password'.tr,
                  isCompulsoryText: true,
                  obscure: controller.isShow ? true : false,
                  keybordtype: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  fillColor: ColorsValue.textfildbackcolor,
                  validation: (p0) {
                    if (p0!.isEmpty) {
                      return 'enter_new_password'.tr;
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
                Dimens.boxHeight20,
                CustomTextFormField(
                  controller: controller.changeConfirmController,
                  hintText: 'confirm_password'.tr,
                  isCompulsoryText: true,
                  obscure: controller.isConfirmShow ? true : false,
                  keybordtype: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  fillColor: ColorsValue.textfildbackcolor,
                  validation: (value) {
                    if (controller.newController.text.isEmpty) {
                      return 'enter_confirm_password_first'.tr;
                    } else if (controller.newController.text != value) {
                      return 'New Password and Confirm Password must be same';
                    } else if (value!.isEmpty) {
                      return 'enter_confirm_password'.tr;
                    }
                    return null;
                  },
                  suffixIcon: InkWell(
                    onTap: () {
                      if (controller.isConfirmShow) {
                        controller.isConfirmShow = false;
                      } else {
                        controller.isConfirmShow = true;
                      }
                      controller.update();
                    },
                    child: Padding(
                      padding: Dimens.edgeInsets0_12_0_12,
                      child: SvgPicture.asset(
                        !controller.isConfirmShow
                            ? AssetConstants.ic_show
                            : AssetConstants.ic_hide,
                        height: Dimens.sixteen,
                        width: Dimens.twenty,
                        colorFilter: ColorFilter.mode(
                          controller.isConfirmShow
                              ? ColorsValue.greyColor8888
                              : ColorsValue.blackColor,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  ),
                ),
                Dimens.boxHeight20,
              ],
            ),
          ),
        ),
      );
    });
  }
}
