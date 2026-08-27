import 'package:chatnest/app/app.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      initState: (as) {
        var controller = Get.find<LoginController>();
        controller.otpTextEditingController = TextEditingController();
        controller.counter = 30;
        controller.startTimer();
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.whiteColor,
        appBar: AppBar(
          backgroundColor: ColorsValue.whiteColor,
          elevation: Dimens.zero,
          leading: Container(
            margin: Dimens.edgeInsets20_0_0_0,
            child: IconButton(
              icon: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets30_0_30_0,
          child: Form(
            key: controller.otpFormKey,
            child: ListView(
              children: [
                Dimens.boxHeight48,
                Text(
                  'verify_phone_number'.tr,
                  style: Styles.black70024,
                ),
                Dimens.boxHeight10,
                Text(
                  "${"enter_otp_you_received".tr}\n${"${Get.find<LoginController>().dailcode} ${Get.find<LoginController>().phonenumbercontroller.text}"}"
                      .tr,
                  style: Styles.hinttext40014,
                  textAlign: TextAlign.center,
                ),
                Dimens.boxHeight30,
                PinCodeTextField(
                  obscureText: true,
                  appContext: context,
                  length: 6,
                  autoFocus: true,
                  hintCharacter: "0",
                  hintStyle: Styles.greyAAA40014,
                  pastedTextStyle: const TextStyle(
                    color: ColorsValue.maincolor1,
                    fontWeight: FontWeight.bold,
                  ),
                  animationType: AnimationType.fade,
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    activeColor: ColorsValue.maincolor1,
                    selectedColor: ColorsValue.maincolor1,
                    inactiveColor: ColorsValue.textfild,
                    selectedFillColor: ColorsValue.whiteColor,
                    inactiveFillColor: ColorsValue.textfild,
                    activeFillColor: ColorsValue.whiteColor,
                    borderWidth: 1,
                    borderRadius: BorderRadius.circular(Dimens.five),
                    fieldHeight: Get.width / Dimens.eight,
                    fieldWidth: Get.width / Dimens.eight,
                  ),
                  cursorColor: ColorsValue.color2E363F,
                  enableActiveFill: true,
                  controller: controller.otpTextEditingController,
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
                    return controller.validotp(value!);
                  },
                  onChanged: (value) {
                    debugPrint(value);
                  },
                  beforeTextPaste: (text) {
                    debugPrint("Allowing to paste $text");
                    return true;
                  },
                ),
                if (controller.counter == 0) ...[
                  Dimens.boxHeight30,
                  Center(
                      child: RichText(
                    text: TextSpan(
                      text: 'didnt_recevie_code'.tr,
                      style: Styles.black40016,
                      children: [
                        TextSpan(
                          text: 'resend_code'.tr,
                          style: Styles.main40016,
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              controller.counter = 30;
                              controller.startTimer();
                              controller.sendOtpApi();
                            },
                        ),
                      ],
                    ),
                  )),
                ] else ...[
                  Dimens.boxHeight30,
                  Center(
                    child: Text(
                      '00:${controller.counter <= 9 ? '0${controller.counter}' : controller.counter}',
                      style: Styles.black50016,
                    ),
                  ),
                ],
                Dimens.boxHeight30,
                CustomButton(
                  text: "verify".toUpperCase().tr,
                  height: Dimens.fifty,
                  backgroundColor: controller.isbuttonactivate
                      ? ColorsValue.maincolor1
                      : ColorsValue.maincolor1.withOpacity(0.4),
                  onTap: controller.isbuttonactivate
                      ? () {
                          if (Get.arguments[1] ?? false) {
                            controller.postChangeNumberVerify();
                          }
                          controller.verifyOtpApi();
                        }
                      : null,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
