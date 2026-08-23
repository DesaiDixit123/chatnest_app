import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CreateMultiUserScreen extends StatelessWidget {
  const CreateMultiUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.ids = Get.arguments ?? "";
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
                "create_multi_a_user".tr,
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
        body: SafeArea(
          child: Form(
            key: controller.userKey,
            child: ListView(
              padding: Dimens.edgeInsets20,
              physics: const ClampingScrollPhysics(),
              children: [
                SvgPicture.asset(
                  AssetConstants.ic_multi_user_svg,
                  height: Dimens.twoHundred,
                  width: double.maxFinite,
                ),
                Dimens.boxHeight20,
                CustomTextFormField(
                  controller: controller.nameController,
                  isCompulsoryText: true,
                  hintText: 'name'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  keybordtype: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return 'enter_name'.tr;
                    }
                    return null;
                  },
                ),
                Dimens.boxHeight20,
                CustomTextFormField(
                  controller: controller.userNameController,
                  isCompulsoryText: true,
                  hintText: 'username'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  keybordtype: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return 'enter_username'.tr;
                    }
                    return null;
                  },
                ),
                Dimens.boxHeight20,
                CustomTextFormField(
                  controller: controller.emailController,
                  isCompulsoryText: true,
                  hintText: 'email'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  keybordtype: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "please_enter_emailId".tr;
                    } else if (!Utility.emailValidator(value)) {
                      return "please_enter_valid_emailId".tr;
                    }
                    return null;
                  },
                ),
                CustomInternationalPhoneFild(
                  hintText: 'mobile_number_star'.tr,
                  text: ''.tr,
                  initialvalue: PhoneNumber(
                      isoCode:
                          PhoneNumber.getISO2CodeByPrefix(controller.dailCode)),
                  onInputChanged: (PhoneNumber number) {
                    controller.dailCode = number.dialCode ?? '';
                  },
                  oninitialValidation: (bool value) {
                    controller.isValid = value;
                    controller.update();
                  },
                  keyboardAction: TextInputAction.next,
                  textEditingController: controller.mobileController,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "enter_mobile_number".tr;
                    } else if (!controller.isValid) {
                      return "enter_valid_mobile_number".tr;
                    }
                    return null;
                  },
                ),
                Dimens.boxHeight20,
                if (controller.ids.isEmpty) ...[
                  CustomTextFormField(
                    hintText: 'password'.tr,
                    isCompulsoryText: true,
                    obscure: controller.isShow ? true : false,
                    keybordtype: TextInputType.text,
                    textInputAction: TextInputAction.next,
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
                          controller.isShow
                              ? AssetConstants.ic_hide
                              : AssetConstants.ic_show,
                          height: Dimens.sixteen,
                          width: Dimens.twenty,
                          colorFilter: ColorFilter.mode(
                            controller.isShow
                                ? ColorsValue.blackColor
                                : ColorsValue.greyColor8888,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Dimens.boxHeight20,
                  CustomTextFormField(
                    hintText: 'confirm_password'.tr,
                    isCompulsoryText: true,
                    obscure: controller.isConfirmShow ? true : false,
                    keybordtype: TextInputType.text,
                    textInputAction: TextInputAction.next,
                    fillColor: ColorsValue.textfildbackcolor,
                    controller: controller.confirmPasswordController,
                    validation: (value) {
                      if (controller.passwordController.text.isEmpty) {
                        return 'enter_confirm_password_first'.tr;
                      } else if (controller.passwordController.text != value) {
                        return 'Password and Confirm Password must be same';
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
                CustomButton(
                  text: controller.ids.isNotEmpty
                      ? "update".tr.toUpperCase()
                      : 'assign'.tr.toUpperCase(),
                  onTap: () {
                    if (controller.userKey.currentState!.validate()) {
                      if (controller.ids.isEmpty &&
                          controller.passwordController.text.length < 8) {
                        Utility.errorMessage(
                            "User password must be at least 8 chars long..., please try again");
                      } else {
                        RouteManagement.goToAssignUserScreen();
                      }
                    }
                  },
                  backgroundColor: ColorsValue.appColor,
                  height: Dimens.fifty,
                  style: Styles.white50016,
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
