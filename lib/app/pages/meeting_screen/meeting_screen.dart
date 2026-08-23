import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MeetingScreen extends StatelessWidget {
  const MeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        body: DefaultTabController(
          length: controller.meetingTabController.length,
          child: Scaffold(
            appBar: GradientAppBar(
              elevation: 5,
            //  shadowColor: Colors.black.withOpacity(0.4),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "meeting".tr,
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
                  child: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
                ),
              ),
              bottom: TabBar(
                controller: controller.meetingTabController,
                indicatorColor: ColorsValue.maincolor1,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: Dimens.edgeInsets20_0_20_0,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: ColorsValue.maincolor1,
                  ),
                ),
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "host_meeting".tr,
                      style: controller.meetingTabController.index == 0
                          ? Styles.main50014
                          : Styles.greyColor888850014,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'join_meeting'.tr,
                      style: controller.meetingTabController.index == 1
                          ? Styles.main50014
                          : Styles.greyColor888850014,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'past_meeting'.tr,
                      style: controller.meetingTabController.index == 2
                          ? Styles.main50014
                          : Styles.greyColor888850014,
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: ColorsValue.white,
            body: TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              controller: controller.meetingTabController,
              children: const [
                HostMeetingScreen(),
                JoinMeetingScreen(),
                PendingMeetingScreen(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
