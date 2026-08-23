import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ReportUserGroupListScreen extends StatelessWidget {
  const ReportUserGroupListScreen({super.key});

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
                "report_user_group".tr,
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
          bottom: TabBar(
            controller: controller.reportTabController,
            indicatorColor: ColorsValue.maincolor1,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorPadding: Dimens.edgeInsets10_0_10_0,
            indicator: const UnderlineTabIndicator(
              borderSide: BorderSide(
                width: 3,
                color: ColorsValue.maincolor1,
              ),
            ),
            tabs: <Widget>[
              Tab(
                child: Text(
                  "Chat".tr,
                  style: controller.reportTabController.index == 0
                      ? Styles.main50014
                      : Styles.greyColor888850014,
                  maxLines: 1,
                  softWrap: true,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Tab(
                child: Text(
                  'Group'.tr,
                  style: controller.reportTabController.index == 1
                      ? Styles.main50014
                      : Styles.greyColor888850014,
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: controller.reportTabController,
          children: const [
            ChatReportScreen(),
            GroupReportScreen(),
          ],
        ),
      );
    });
  }
}
