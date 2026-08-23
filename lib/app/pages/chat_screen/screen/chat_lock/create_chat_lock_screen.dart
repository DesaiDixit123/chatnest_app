import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatChatLockPinScreen extends StatelessWidget {
  const CreatChatLockPinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (as) {
      var controller = Get.find<ChatController>();
      controller.createLockPinController = TextEditingController();
      controller.isEnterPin = false;
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
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: Form(
            key: controller.createLockKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  controller.isEnterPin
                      ? 'confirm_chat_lock_pin'.tr
                      : 'new_chat_lock_pin'.tr,
                  style: Styles.black60030,
                ),
                Dimens.boxHeight10,
                Text(
                  'lock_chate_discription'.tr,
                  style: Styles.black40014,
                ),
                Dimens.boxHeight67,
                PinCodeTextField(
                  obscureText: true,
                  controller: controller.createLockPinController,
                  appContext: context,
                  length: 4,
                  autoFocus: true,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'enter_your_pin'.tr;
                    } else if (controller.createLockPinController.text.length !=
                        4) {
                      return 'enter_valid_pin'.tr;
                    } else if (controller.createLockPinController.text !=
                            controller.createPin &&
                        controller.isEnterPin) {
                      return 'confirm_pin_error'.tr;
                    }
                    return null;
                  },
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
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
                Dimens.boxHeight35,
                CustomButton(
                  height: Dimens.fifty,
                  text: "create".tr.toUpperCase(),
                  onTap: () {
                    if (controller.createLockKey.currentState!.validate() &&
                        controller.createLockPinController.text.length == 4) {
                      if (controller.isEnterPin) {
                        controller.postCreatePin();
                      } else {
                        controller.isEnterPin = true;
                        controller.createPin =
                            controller.createLockPinController.text;
                        controller.createLockPinController.clear();
                        controller.update();
                      }
                    }
                  },
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
