import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReportUserScreen extends StatelessWidget {
  const ReportUserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
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
                    controller.postChatReport(Get.arguments ?? "");
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
                  'Select a reason for reporting this user:',
                  style: Styles.black50016,
                ),
                Dimens.boxHeight15,
                ...controller.reportReasons.map((reason) {
                  return RadioListTile<String>(
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      reason.tr,
                      style: Styles.black40016,
                    ),
                    value: reason,
                    groupValue: controller.selectedReportReason,
                    activeColor: ColorsValue.appColor,
                    onChanged: (val) {
                      if (val != null) {
                        controller.selectReportReason(val);
                      }
                    },
                  );
                }).toList(),
                if (controller.selectedReportReason == 'Other') ...[
                  Dimens.boxHeight15,
                  Text(
                    'Please specify the reason below:',
                    style: Styles.black50016,
                  ),
                  Dimens.boxHeight10,
                  CustomTextFormField(
                    controller: controller.reasonController,
                    hintText: 'Enter report details...'.tr,
                    maxLines: 4,
                    fillColor: ColorsValue.textfildbackcolor,
                    keybordtype: TextInputType.text,
                    textInputAction: TextInputAction.done,
                    validation: (value) {
                      if (controller.selectedReportReason == 'Other' && (value == null || value.trim().isEmpty)) {
                        return "Please enter report details".tr;
                      }
                      return null;
                    },
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
