import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HideChatScreen extends StatelessWidget {
  const HideChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HideChatController>(
      builder: (controller) => DefaultTabController(
        length: controller.hidechattabController.length,
        child: Scaffold(
          appBar: AppBar(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "hidechat".tr,
                  style: Styles.black70018,
                ),
              ],
            ),
            leading: Padding(
              padding: Dimens.edgeInsets15,
              child: InkWell(
                onTap: () {
                  RouteManagement.goTofindFriendrequasthistoryScreen();
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
              controller: controller.hidechattabController,
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
                Padding(
                  padding: Dimens.edgeInsets20_0_20_0,
                  child: Tab(
                    child: Text(
                      "chat".tr,
                      style: controller.hidechattabController.index == 0
                          ? Styles.black70016
                          : Styles.black50016,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'groupchat'.tr,
                    style: controller.hidechattabController.index == 1
                        ? Styles.black70016
                        : Styles.black50016,
                  ),
                )
              ],
            ),
          ),
          backgroundColor: ColorsValue.white,
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.hidechattabController,
            children: const [
              ChatHideScreen(),
              GroupCheatScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
