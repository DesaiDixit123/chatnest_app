import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class RecoveryEmailScreen extends StatelessWidget {
  const RecoveryEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(initState: (state) {
      var controller = Get.find<SettingController>();
      controller.isLock = Get.arguments ?? "";
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
                "recovery_email".tr,
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
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                fixedSize: Size(
                  double.maxFinite,
                  Dimens.fifty,
                ),
                backgroundColor: ColorsValue.appColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimens.five,
                  ),
                ),
              ),
              onPressed: () {
                if (controller.emailKey.currentState!.validate()) {
                  controller.postRecoveryEmail();
                }
              },
              child: Text(
                'submit'.tr.toUpperCase(),
                style: Styles.white50016,
              ),
            ),
          ),
        ),
        body: Form(
          key: controller.emailKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: Dimens.edgeInsets20,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'enter_email_address'.tr,
                style: Styles.black50016,
              ),
              Dimens.boxHeight10,
              CustomTextFormField(
                controller: controller.recoveryEmailController,
                hintText: 'email'.tr,
                fillColor: ColorsValue.textfildbackcolor,
                validation: (value) {
                  if (value!.isEmpty) {
                    return "please_enter_emailId".tr;
                  } else if (!Utility.emailValidator(value)) {
                    return "please_enter_valid_emailId".tr;
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      );
    });
  }
}
