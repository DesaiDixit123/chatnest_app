import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChangeLockChatScreen extends StatelessWidget {
  const ChangeLockChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) {
      var controller = Get.find<ChatController>();
      controller.changeOldPinController = TextEditingController();
      controller.changeNewPinController = TextEditingController();
      controller.changeConfirmPinController = TextEditingController();
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
          key: controller.changeLockKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: Dimens.edgeInsets20,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'change_lock_pin'.tr,
                style: Styles.black60032,
              ),
              Dimens.boxHeight10,
              Text(
                'change_pin_msg'.tr,
                style: Styles.black40014,
              ),
              Dimens.boxHeight37,
              Text(
                'enter_old_pin'.tr,
                style: Styles.black50014,
              ),
              Dimens.boxHeight5,
              PinCodeTextField(
                obscureText: true,
                controller: controller.changeOldPinController,
                appContext: context,
                length: 4,
                autoFocus: true,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'enter_old_pin'.tr;
                  } else if (controller.changeOldPinController.text.length !=
                      4) {
                    return 'enter_valid_pin'.tr;
                  }
                  return null;
                },
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
              Dimens.boxHeight5,
              Text(
                'enter_new_pin'.tr,
                style: Styles.black50014,
              ),
              Dimens.boxHeight5,
              PinCodeTextField(
                obscureText: true,
                controller: controller.changeNewPinController,
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
                  if (controller.changeOldPinController.text ==
                      controller.changeNewPinController.text) {
                    return 'old_new_pin_error'.tr;
                  } else if (value!.isEmpty) {
                    return 'enter_new_pin'.tr;
                  } else if (controller.changeNewPinController.text.length !=
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
                controller: controller.changeConfirmPinController,
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
                          .changeConfirmPinController.text.length !=
                      4) {
                    return 'Enter Valid Confirm Pin'.tr;
                  } else if (controller.changeConfirmPinController.text !=
                      controller.changeNewPinController.text) {
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
                text: "change_pin_text".tr.toUpperCase(),
                onTap: () {
                  if (controller.changeLockKey.currentState!.validate()) {
                    controller.postChangePinLock();
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
