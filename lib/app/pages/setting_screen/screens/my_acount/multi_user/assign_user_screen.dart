import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AssignUserScreen extends StatelessWidget {
  const AssignUserScreen({super.key});

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
                "assign_users".tr,
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
                if (controller.myFriendsLists.isNotEmpty ||
                    controller.groupChatUserList.isNotEmpty) {
                  controller.postSaveSubUser();
                } else {
                  Utility.errorMessage(
                      "Select chat or group chat assign user.");
                }
              },
              child: Text(
                controller.ids.isNotEmpty
                    ? "update".tr.toUpperCase()
                    : 'assign'.tr.toUpperCase(),
                style: Styles.white50016,
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: Dimens.edgeInsets20_10_20_10,
              child: TabBar(
                dividerColor: ColorsValue.greyE4E4E4,
                padding: Dimens.edgeInsets0,
                tabAlignment: TabAlignment.start,
                controller: controller.tabController,
                labelColor: ColorsValue.appColor,
                unselectedLabelColor: ColorsValue.greyColorC1C4D6,
                indicatorColor: ColorsValue.appColor,
                isScrollable: true,
                indicatorSize: TabBarIndicatorSize.label,
                labelStyle: Styles.main70016,
                unselectedLabelStyle: Styles.greyColor888850012,
                tabs: [
                  Tab(
                    text: "chat".tr,
                  ),
                  Tab(
                    text: "groupchat".tr,
                  ),
                ],
              ),
            ),
            Dimens.boxHeight5,
            Expanded(
              child: TabBarView(
                physics: const NeverScrollableScrollPhysics(),
                controller: controller.tabController,
                children: const [
                  AssignChatScreen(),
                  AssignGroupChatScreen(),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
