import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeHideForgotPinScreen extends StatelessWidget {
  const ChangeHideForgotPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HideChatController>(initState: (state) {
      var controller = Get.find<HideChatController>();
      controller.forgotOtpPinController = TextEditingController();
      controller.forgotNewPinController = TextEditingController();
      controller.forgotConfirmPinController = TextEditingController();
    }, builder: (controller) {
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
        body: Form(
          key: controller.forgotLockKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: Dimens.edgeInsets20,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'forgot_chat_lock_pin'.tr,
                style: Styles.black60032,
              ),
              Dimens.boxHeight10,
              Text(
                'forgot_pin_msg'.tr,
                style: Styles.black40014,
              ),
              Dimens.boxHeight37,
              Text(
                'enter_otp'.tr,
                style: Styles.black50014,
              ),
              Dimens.boxHeight5,
              PinCodeTextField(
                controller: controller.forgotOtpPinController,
                obscureText: false,
                appContext: context,
                length: 6,
                autoFocus: true,
                hintStyle: Styles.greyAAA40014,
                textStyle: Styles.darkblack60022,
                pastedTextStyle: const TextStyle(
                  color: ColorsValue.maincolor1,
                  fontWeight: FontWeight.bold,
                ),
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  activeColor: ColorsValue.maincolor1,
                  selectedColor: ColorsValue.maincolor1,
                  inactiveColor: ColorsValue.textfildbackcolor,
                  selectedFillColor: ColorsValue.textfildbackcolor,
                  inactiveFillColor: ColorsValue.textfildbackcolor,
                  activeFillColor: ColorsValue.textfildbackcolor,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(Dimens.five),
                  fieldHeight: Get.width / Dimens.eight,
                  fieldWidth: Get.width / Dimens.eight,
                ),
                cursorColor: ColorsValue.color2E363F,
                enableActiveFill: true,
                keyboardType: TextInputType.number,
                errorTextMargin: Dimens.edgeInsetsTop20,
                errorTextSpace: Dimens.twentyFive,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'pleaseenterotp'.tr;
                  } else if (controller.forgotOtpPinController.text.length !=
                      6) {
                    return 'pleaseenterrightotp'.tr;
                  }
                  return null;
                },
              ),
              Dimens.boxHeight5,
              Text(
                'enter_new_pin'.tr,
                style: Styles.black50014,
              ),
              Dimens.boxHeight5,
              PinCodeTextField(
                obscureText: true,
                controller: controller.forgotNewPinController,
                appContext: context,
                length: 4,
                autoFocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                hintStyle: Styles.greyAAA40014,
                textStyle: Styles.darkblack60022,
                pastedTextStyle: const TextStyle(
                  color: ColorsValue.maincolor1,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (controller.forgotOtpPinController.text ==
                      controller.forgotNewPinController.text) {
                    return 'old_new_pin_error'.tr;
                  } else if (value!.isEmpty) {
                    return 'enter_new_pin'.tr;
                  } else if (controller.forgotNewPinController.text.length !=
                      4) {
                    return 'enter_valid_pin'.tr;
                  }
                  return null;
                },
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  activeColor: ColorsValue.maincolor1,
                  selectedColor: ColorsValue.maincolor1,
                  inactiveColor: ColorsValue.textfildbackcolor,
                  selectedFillColor: ColorsValue.textfildbackcolor,
                  inactiveFillColor: ColorsValue.textfildbackcolor,
                  activeFillColor: ColorsValue.textfildbackcolor,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(Dimens.eight),
                  fieldWidth: Get.width / Dimens.five,
                  fieldHeight: Get.width / 6.5,
                ),
                cursorColor: ColorsValue.color2E363F,
                enableActiveFill: true,
                errorTextMargin: Dimens.edgeInsetsTop20,
                errorTextSpace: Dimens.twenty,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ],
                onChanged: (value) {
                  debugPrint(value);
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  return true;
                },
              ),
              Dimens.boxHeight10,
              Text(
                'enter_confirm_pin'.tr,
                style: Styles.black50014,
              ),
              Dimens.boxHeight5,
              PinCodeTextField(
                obscureText: true,
                controller: controller.forgotConfirmPinController,
                appContext: context,
                length: 4,
                autoFocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                hintStyle: Styles.greyAAA40014,
                textStyle: Styles.darkblack60022,
                pastedTextStyle: const TextStyle(
                  color: ColorsValue.maincolor1,
                  fontWeight: FontWeight.bold,
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_confirm_pin'.tr;
                  } else if (controller
                          .forgotConfirmPinController.text.length !=
                      4) {
                    return 'Enter Valid Confirm Pin'.tr;
                  } else if (controller.forgotConfirmPinController.text !=
                      controller.forgotNewPinController.text) {
                    return 'confirm_pin_error'.tr;
                  }
                  return null;
                },
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  activeColor: ColorsValue.maincolor1,
                  selectedColor: ColorsValue.maincolor1,
                  inactiveColor: ColorsValue.textfildbackcolor,
                  selectedFillColor: ColorsValue.textfildbackcolor,
                  inactiveFillColor: ColorsValue.textfildbackcolor,
                  activeFillColor: ColorsValue.textfildbackcolor,
                  borderWidth: 1,
                  borderRadius: BorderRadius.circular(Dimens.eight),
                  fieldWidth: Get.width / Dimens.five,
                  fieldHeight: Get.width / 6.5,
                ),
                cursorColor: ColorsValue.color2E363F,
                enableActiveFill: true,
                blinkWhenObscuring: true,
                errorTextMargin: Dimens.edgeInsetsTop20,
                errorTextSpace: Dimens.twenty,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 1),
                    color: Colors.black12,
                    blurRadius: 2,
                  )
                ],
                onChanged: (value) {
                  debugPrint(value);
                },
                beforeTextPaste: (text) {
                  debugPrint("Allowing to paste $text");
                  return true;
                },
              ),
              Dimens.boxHeight45,
              CustomButton(
                height: Dimens.fifty,
                text: "Forgot Pin".tr.toUpperCase(),
                onTap: () {
                  if (controller.forgotLockKey.currentState!.validate()) {
                    controller.postChatHideVerifyOtp();
                  }
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
