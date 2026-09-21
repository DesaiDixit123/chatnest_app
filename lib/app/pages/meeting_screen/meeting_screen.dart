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
                  child: SvgPicture.asset(
                    AssetConstants.appbarbackarrowicon,
                    colorFilter: const ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
              bottom: TabBar(
                controller: controller.meetingTabController,
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: Dimens.edgeInsets20_0_20_0,
                indicator: const UnderlineTabIndicator(
                  borderSide: BorderSide(
                    width: 3,
                    color: Colors.black,
                  ),
                ),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.black54,
                tabs: <Widget>[
                  Tab(
                    child: Text(
                      "host_meeting".tr,
                      style: controller.meetingTabController.index == 0
                          ? Styles.black70014
                          : Styles.black50014,
                      maxLines: 1,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'join_meeting'.tr,
                      style: controller.meetingTabController.index == 1
                          ? Styles.black70014
                          : Styles.black50014,
                    ),
                  ),
                  Tab(
                    child: Text(
                      'past_meeting'.tr,
                      style: controller.meetingTabController.index == 2
                          ? Styles.black70014
                          : Styles.black50014,
                    ),
                  )
                ],
              ),
            ),
            backgroundColor: ColorsValue.white,
            body: Column(
              children: [
                if (controller.hasActiveMeetingSession)
                  _buildOngoingSessionBanner(context, controller),
                Expanded(
                  child: TabBarView(
                    physics: const NeverScrollableScrollPhysics(),
                    controller: controller.meetingTabController,
                    children: const [
                      HostMeetingScreen(),
                      JoinMeetingScreen(),
                      PendingMeetingScreen(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOngoingSessionBanner(
      BuildContext context, MeetingController controller) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFE8F5E9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade400, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Colors.green.shade600,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.videocam_rounded,
              color: Colors.white,
              size: 18,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    const Text(
                      "LIVE SESSION",
                      style: TextStyle(
                        color: Colors.green,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  controller.activeMeetingTitle,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: () async {
              if (await Utility.cameraPermissionCheack(context) &&
                  // ignore: use_build_context_synchronously
                  await Utility.microphonePermissionCheack(context)) {
                await controller.rejoinActiveMeetingSession();
              }
            },
            icon: const Icon(Icons.login_rounded, size: 16, color: Colors.white),
            label: const Text(
              "REJOIN",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: () => controller.dismissActiveMeetingBanner(),
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: Icon(
                Icons.close,
                size: 18,
                color: Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
