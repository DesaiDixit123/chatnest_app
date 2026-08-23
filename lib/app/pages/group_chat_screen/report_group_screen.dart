import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReportGroupScreen extends StatelessWidget {
  const ReportGroupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "report".tr,
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
                if (controller.reportKey.currentState!.validate()) {
                  controller.postGroupChatReport(Get.arguments ?? "");
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
          key: controller.reportKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: ListView(
            padding: Dimens.edgeInsets20,
            physics: const ClampingScrollPhysics(),
            children: [
              Text(
                'enter_email_reason'.tr,
                style: Styles.black50016,
              ),
              Dimens.boxHeight10,
              CustomTextFormField(
                controller: controller.reasonController,
                hintText: 'reason'.tr,
                maxLines: 4,
                fillColor: ColorsValue.textfildbackcolor,
                keybordtype: TextInputType.text,
                textInputAction: TextInputAction.done,
                validation: (value) {
                  if (value!.isEmpty) {
                    return "enter_email_reason".tr;
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
