import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class ChangeNumberScreen extends StatelessWidget {
  const ChangeNumberScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (state) {
        var controller = Get.find<SettingController>();
        controller.dailOldCode = Utility.profileData?.countryCode ?? "";
        controller.oldMobileController.text = Utility.profileData?.mobile ?? "";
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "change_number".tr,
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
          body: Form(
            key: controller.numKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: ListView(
              physics: const ClampingScrollPhysics(),
              padding: Dimens.edgeInsets20,
              children: [
                Image.asset(
                  AssetConstants.ic_change_number,
                  height: Dimens.hundredNinty,
                  width: Dimens.hundredNinty,
                ),
                Dimens.boxHeight20,
                Text(
                  "Update your phone number to transfer your account data and settings to your new number."
                      .tr,
                  textAlign: TextAlign.center,
                  style: Styles.black50016,
                ),
                Dimens.boxHeight10,
                Text(
                  "Before you proceed, make sure your new phone number is active and can receive SMS for verification."
                      .tr,
                  textAlign: TextAlign.center,
                  style: Styles.greyColor888840014,
                ),
                Dimens.boxHeight40,
                CustomInternationalPhoneFild(
                  hintText: 'old_mobile_number'.tr,
                  text: ''.tr,
                  initialvalue: PhoneNumber(
                      isoCode: PhoneNumber.getISO2CodeByPrefix(
                          controller.dailOldCode)),
                  onInputChanged: (PhoneNumber number) {
                    controller.dailOldCode = number.dialCode ?? '';
                  },
                  oninitialValidation: (bool value) {
                    controller.isOldValid = value;
                    controller.update();
                  },
                  textEditingController: controller.oldMobileController,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "enter_old_mobile_number".tr;
                    } else if (!controller.isOldValid) {
                      return "enter_valid_old_mobile_number".tr;
                    }
                    return null;
                  },
                ),
                CustomInternationalPhoneFild(
                  hintText: 'new_mobile_number'.tr,
                  text: ''.tr,
                  initialvalue: PhoneNumber(
                      isoCode: PhoneNumber.getISO2CodeByPrefix(
                          controller.dailNewCode)),
                  onInputChanged: (PhoneNumber number) {
                    controller.dailNewCode = number.dialCode ?? '';
                  },
                  oninitialValidation: (bool value) {
                    controller.isNewValid = value;
                    controller.update();
                  },
                  textEditingController: controller.newMobileController,
                  validation: (value) {
                    if (value!.isEmpty) {
                      return "enter_new_mobile_number".tr;
                    } else if (!controller.isNewValid) {
                      return "enter_valid_new_mobile_number".tr;
                    }
                    return null;
                  },
                ),
                Dimens.boxHeight80,
                CustomButton(
                  height: Dimens.fifty,
                  text: 'change_number'.tr,
                  onTap: () async {
                    if (controller.numKey.currentState!.validate()) {
                      await Get.dialog(
                        Material(
                          color: ColorsValue.transparent,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsets20_0_20_0,
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(Dimens.sixteen),
                                      ),
                                      color: ColorsValue.whiteColor),
                                  width: Get.width,
                                  child: Padding(
                                    padding: Dimens.edgeInsets20,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Get.back();
                                              },
                                              child: SizedBox(
                                                height: Get.height / 50,
                                                child: Image.asset(
                                                  AssetConstants.cancleimage,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SvgPicture.asset(
                                          AssetConstants.ic_info_outline,
                                          height: Dimens.sixtyFour,
                                          width: Dimens.sixtyFour,
                                          colorFilter: const ColorFilter.mode(
                                            ColorsValue.maincolor1,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                        Dimens.boxHeight20,
                                        Text(
                                          "change_number_des".tr,
                                          textAlign: TextAlign.center,
                                          style: Styles.black70020,
                                        ),
                                        Dimens.boxHeight25,
                                        CustomBottomButton(
                                          firstbtnText: 'no'.tr.toUpperCase(),
                                          secondbtnTxt: 'yes'.tr.toUpperCase(),
                                          firstOnPressed: () {
                                            Get.back();
                                          },
                                          secondOnPressed: () {
                                            if (controller.numKey.currentState!
                                                .validate()) {
                                              controller.postChangeNumber();
                                            }
                                          },
                                          firstStyle: Styles.main50014,
                                          secondStyle: Styles.white50014,
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
