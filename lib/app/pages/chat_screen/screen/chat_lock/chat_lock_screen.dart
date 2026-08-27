import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/routes_management.dart';
import 'package:chatnest/app/pages/chat_screen/screen/chat_lock/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatLockScreen extends StatelessWidget {
  const ChatLockScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) => DefaultTabController(
        length: controller.chatLockTabController.length,
        child: Scaffold(
          appBar:
              // controller.selectedChat.isEmpty
              //     ?
              AppBar(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "chat_lock".tr,
                  style: Styles.black70018,
                ),
              ],
            ),
            leading: Padding(
              padding: Dimens.edgeInsets15,
              child: InkWell(
                onTap: () {
                  RouteManagement.goToHomeScreenView();
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
              controller: controller.chatLockTabController,
              indicatorColor: Colors.black,
              indicatorSize: TabBarIndicatorSize.tab,
              padding: Dimens.edgeInsets0,
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
                      style: controller.chatLockTabController.index == 0
                          ? Styles.black70016
                          : Styles.black50016,
                    ),
                  ),
                ),
                Tab(
                  child: Text(
                    'groupchat'.tr,
                    style: controller.chatLockTabController.index == 1
                        ? Styles.black70016
                        : Styles.black50016,
                  ),
                )
              ],
            ),
          ),
          // : AppBar(
          //     leading: Padding(
          //       padding: Dimens.edgeInsets15,
          //       child: InkWell(
          //         onTap: () {
          //           controller.selectedChat.clear();
          //           controller.update();
          //         },
          //         child: SvgPicture.asset(
          //           AssetConstants.appbarbackarrowicon,
          //           colorFilter: ColorFilter.mode(
          //               ColorsValue.blackColor, BlendMode.srcIn),
          //         ),
          //       ),
          //     ),
          //     title: Row(
          //       mainAxisAlignment: MainAxisAlignment.start,
          //       children: [
          //         Text(
          //           controller.selectedChat.length.toString(),
          //           style: Styles.black50014,
          //         ),
          //       ],
          //     ),
          //     actions: [
          //       InkWell(
          //         onTap: () {
          //           controller.showdilog();
          //         },
          //         child: SizedBox(
          //           height: Dimens.twentyTwo,
          //           width: Dimens.twentyTwo,
          //           child: Image.asset(
          //             AssetConstants.hideimg,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       ),
          //       Dimens.boxWidth10,
          //       SizedBox(
          //         height: Dimens.eighteen,
          //         width: Dimens.eighteen,
          //         child: Image.asset(
          //           AssetConstants.muteimg,
          //           fit: BoxFit.fill,
          //         ),
          //       ),
          //       Dimens.boxWidth10,
          //       InkWell(
          //         onTap: () {
          //           controller.selectedChat.clear();
          //           controller.update();
          //         },
          //         child: SizedBox(
          //           height: Dimens.fifteen,
          //           width: Dimens.fifteen,
          //           child: Image.asset(
          //             AssetConstants.cancleimg,
          //             fit: BoxFit.fill,
          //           ),
          //         ),
          //       ),
          //       Dimens.boxWidth10,
          //     ],
          //   ),
          backgroundColor: ColorsValue.white,
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            controller: controller.chatLockTabController,
            children: const [
              ChatListLockScreen(),
              GroupChatListLockScreen(),
            ],
          ),
        ),
      ),
    );
  }
}
