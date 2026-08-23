import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ChatLockVerifyScreen extends StatelessWidget {
  const ChatLockVerifyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (as) {
      var controller = Get.find<ChatController>();
      controller.verfiyLockPinController = TextEditingController();
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
              RouteManagement.goToHomeScreenView();
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
          key: controller.verfiyLockKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: Dimens.edgeInsets20,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'enter_chat_lock_pin'.tr,
                style: Styles.black60032,
              ),
              Dimens.boxHeight10,
              Text(
                'lock_chate_discription'.tr,
                style: Styles.black40014,
              ),
              Dimens.boxHeight67,
              PinCodeTextField(
                obscureText: true,
                controller: controller.verfiyLockPinController,
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
                    return 'enter_your_pin'.tr;
                  } else if (controller.verfiyLockPinController.text.length !=
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
                errorTextSpace: Dimens.sixteen,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      RouteManagement.goToChangeLockChatScreen();
                    },
                    child: Text(
                      'change_pin'.tr,
                      style: Styles.mainUnderline40014,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      RouteManagement.goToForgotLockChatScreen();
                    },
                    child: Text(
                      'forgot_pin'.tr,
                      style: Styles.mainUnderline40014,
                    ),
                  ),
                ],
              ),
              Dimens.boxHeight35,
              CustomButton(
                height: Dimens.fifty,
                text: "submit".tr.toUpperCase(),
                onTap: () {
                  if (controller.verfiyLockKey.currentState!.validate()) {
                    controller.postVerifyPin();
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
