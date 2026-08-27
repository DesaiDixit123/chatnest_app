import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: GradientAppBar(
          elevation: 5,
         // shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "setting".tr,
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
                colorFilter: const ColorFilter.mode(
                  Colors.black,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        body: ListView(
          physics: const ClampingScrollPhysics(),
          children: [
            ListTile(
              onTap: () {
                RouteManagement.goToMyAccountScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.my_account_svg,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'my_account'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToPrivacySecurityScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.privarcy_security,
              ),
              title: Text(
                'privacy_Security'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToStorageScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.ic_storage,
              ),
              title: Text(
                'storage'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToChatSettingScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.ic_chat_setting,
              ),
              title: Text(
                'chat'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToNotificationScreen();
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(AssetConstants.ic_notification_svg),
              title: Text(
                'notification'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                RouteManagement.goToRequestScreen(2);
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.ic_block,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
              title: Text(
                'blocked_users'.tr,
                style: Styles.black50016,
              ),
              trailing: SvgPicture.asset(
                AssetConstants.setting_right_arrow,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            ListTile(
              onTap: () {
                Utility.launchLinkURL(
                    "https://cochat.click/privacy-policy");
              },
              contentPadding: Dimens.edgeInsets20_0_20_0,
              leading: SvgPicture.asset(
                AssetConstants.ic_term_condition,
              ),
              title: Text(
                'policies_agreement'.tr,
                style: Styles.black50016,
              ),
            ),
            Dimens.boxHeight5,
            Divider(
              height: Dimens.one,
              color: ColorsValue.greyE4E4E4,
            ),
            Dimens.boxHeight5,
            InkWell(
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
                              padding: Dimens.edgeInsets30_30_30_20,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AssetConstants.logout,
                                    height: Dimens.sixtyFour,
                                    width: Dimens.sixtyFour,
                                    colorFilter: const ColorFilter.mode(
                                      ColorsValue.redColor,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                  Text(
                                    "come_back_soon".tr,
                                    textAlign: TextAlign.center,
                                    style: Styles.black70020,
                                  ),
                                  Dimens.boxHeight15,
                                  Text(
                                    "are_you_logout".tr,
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
                                            "cancle".tr.toUpperCase(),
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
                                            controller.postLogout();
                                          },
                                          child: Text(
                                            "logout".tr.toUpperCase(),
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
              child: ListTile(
                contentPadding: Dimens.edgeInsets20_0_20_0,
                leading: SvgPicture.asset(
                  AssetConstants.logout,
                  colorFilter: const ColorFilter.mode(
                    ColorsValue.redColor,
                    BlendMode.srcIn,
                  ),
                ),
                title: Text(
                  'logout'.tr,
                  style: Styles.redcolor50016,
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
