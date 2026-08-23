import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class CreatPinChatLockScreen extends StatelessWidget {
  const CreatPinChatLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsValue.white,
      body: SafeArea(
        child: Padding(
          padding: Dimens.edgeInsets20_30_20_0,
          child: Form(
            // key: controller.createpinFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                    onTap: () {
                      Get.back();
                    },
                    child: const Icon(Icons.arrow_back)),
                Dimens.boxHeight50,
                Text(
                  // controller.ischatpin
                  //     ? 'enter_hidechate_pin'.tr
                  //     :
                  "createnewpin".tr,
                  style: Styles.black60032,
                  // controller.ischatpin
                  // ? Styles.black60026
                  // :
                ),
                Dimens.boxHeight16,
                Text(
                  "hideChate_discription".tr,
                  style: Styles.blackColor40014,
                ),
                Dimens.boxHeight67,
                PinCodeTextField(
                  // controller: controller.chatPinController,
                  appContext: context,
                  length: 4,
                  autoFocus: true,
                  hintCharacter: "0",
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
                    borderRadius: BorderRadius.circular(Dimens.eight),
                    fieldHeight: Get.width / Dimens.six,
                    fieldWidth: Get.width / Dimens.five,
                  ),
                  cursorColor: ColorsValue.color2E363F,
                  enableActiveFill: true,
                  errorTextMargin: Dimens.edgeInsetsTop20,
                  errorTextSpace: Dimens.twentyFive,
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
                  text: "submit".tr.toUpperCase(),
                  onTap: () {
                    // if (controller.createpinFormKey.currentState!.validate()) {
                    //   controller.ischatpin = true;
                    //   controller.update();
                    // }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
