import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class MyAccountScreen extends StatelessWidget {
  const MyAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "my_account".tr,
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
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            ListTile(
              onTap: () {
                RouteManagement.goToChangeNumberScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'change_my_number'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () async {
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                      ColorsValue.redColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                  Text(
                                    "are_disable_account".tr,
                                    textAlign: TextAlign.center,
                                    style: Styles.black70020,
                                  ),
                                  Dimens.boxHeight15,
                                  Text(
                                    "disable_des".tr,
                                    style: Styles.hinttext40014,
                                    textAlign: TextAlign.center,
                                  ),
                                  Dimens.boxHeight20,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(double.infinity,
                                                Dimens.fourtyFive),
                                            backgroundColor:
                                                ColorsValue.maincolor1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.six),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "no".tr.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: Styles.white50014,
                                          ),
                                        ),
                                      ),
                                      Dimens.boxWidth15,
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(double.infinity,
                                                Dimens.fourtyFive),
                                            backgroundColor:
                                                ColorsValue.redColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.six),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            controller.postDisableAccount();
                                          },
                                          child: Text(
                                            "yes".tr.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: Styles.white50014,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'disable_my_account'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () async {
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
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
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
                                      ColorsValue.redColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                  Text(
                                    "are_delete_account".tr,
                                    textAlign: TextAlign.center,
                                    style: Styles.black70020,
                                  ),
                                  Dimens.boxHeight15,
                                  Text(
                                    "delete_des".tr,
                                    style: Styles.hinttext40014,
                                    textAlign: TextAlign.center,
                                  ),
                                  Dimens.boxHeight20,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(double.infinity,
                                                Dimens.fourtyFive),
                                            backgroundColor:
                                                ColorsValue.maincolor1,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.six),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                          },
                                          child: Text(
                                            "no".tr.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: Styles.white50014,
                                          ),
                                        ),
                                      ),
                                      Dimens.boxWidth15,
                                      Expanded(
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            fixedSize: Size(double.infinity,
                                                Dimens.fourtyFive),
                                            backgroundColor:
                                                ColorsValue.redColor,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.six),
                                            ),
                                          ),
                                          onPressed: () {
                                            Get.back();
                                            controller.postDeleteAccount();
                                          },
                                          child: Text(
                                            "yes".tr.toUpperCase(),
                                            textAlign: TextAlign.center,
                                            style: Styles.white50014,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'delete_my_account'.tr,
                style: Styles.black50016.copyWith(color: ColorsValue.redColor),
              ),
            ),
            Dimens.boxHeight5,
            // Divider(
            //   height: Dimens.one,
            //   color: ColorsValue.greyE4E4E4,
            // ),
            // Dimens.boxHeight5,
            // ListTile(
            //   onTap: () {
            //     RouteManagement.goToMultiUserScreen();
            //   },
            //   contentPadding: Dimens.edgeInsets20_0_20_0,
            //   title: Text(
            //     'create_multi_user'.tr,
            //     style: Styles.black50016,
            //   ),
            // ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToRecoveryEmailScreen("");
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'recovery_email'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            ListTile(
              onTap: () {
                RouteManagement.goToReportUserGroupListScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              title: Text(
                'report_user_group'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
          ],
        ),
      );
    });
  }
}
