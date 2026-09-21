import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/pages/status_screen/status_screen.dart';
import 'package:chatnest/app/pages/call_screen/screen/call_screen.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

class HomeScreenScreen extends StatefulWidget {
  const HomeScreenScreen({super.key});

  @override
  State<HomeScreenScreen> createState() => _HomeScreenScreenState();
}

class _HomeScreenScreenState extends State<HomeScreenScreen>
    with WidgetsBindingObserver {
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    // getConnectivity();
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  showDialogBox() => showCupertinoDialog<String>(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: Text('no_connection'.tr),
          content: Text('check_connectivity'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () async {
                Navigator.pop(context, 'Cancel');
                setState(() => isAlertSet = false);
                isDeviceConnected =
                    await InternetConnectionChecker.instance.hasConnection;
                if (!isDeviceConnected && isAlertSet == false) {
                  showDialogBox();
                  setState(() => isAlertSet = true);
                }
              },
              child: Text('ok'.tr),
            ),
          ],
        ),
      );

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      Get.find<HomeScreenController>().getProfile();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      initState: (state) async {
        var controller = Get.find<HomeScreenController>();
        controller.getProfile();
      },
      builder: (controller) => DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: GradientAppBar(
              centerTitle: false,
              //   backgroundColor: ColorsValue.white,
              elevation: Dimens.ten,
              //  automaticallyImplyLeading: false,
              // leadingWidth:
              //     Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
              //         ? 0
              //         : Dimens.sixty,
              leading: Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
                  ? Container()
                  : Container(
                      padding: Dimens.edgeInsetsLeft20,
                      child: CircleAvatar(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimens.hundred,
                          ),
                          child: InkWell(
                            overlayColor: WidgetStateProperty.all(
                                ColorsValue.transparent),
                            onTap: () {
                              (controller.isProfile ?? false)
                                  ? RouteManagement.goToProfileScreen()
                                  : RouteManagement.goTocreateProfileView();
                            },
                            child: (controller.isProfile == true &&
                                    ApiWrapper.isValidImageUrl(
                                        controller.profilePic))
                                ? CachedNetworkImage(
                                    width: Dimens.thirty,
                                    height: Dimens.thirty,
                                    imageUrl: ApiWrapper.getFullImageUrl(
                                        controller.profilePic),
                                    fit: BoxFit.cover,
                                    maxHeightDiskCache: 90,
                                    maxWidthDiskCache: 90,
                                    placeholder: (context, url) => Image.asset(
                                      AssetConstants.usera,
                                      height: Dimens.thirty,
                                      width: Dimens.thirty,
                                    ),
                                    errorWidget: (context, url, error) =>
                                        Image.asset(
                                      AssetConstants.usera,
                                      height: Dimens.thirty,
                                      width: Dimens.thirty,
                                    ),
                                  )
                                : Image.asset(
                                    AssetConstants.usera,
                                    height: Dimens.thirty,
                                    width: Dimens.thirty,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                        ),
                      ),
                    ),
              title: Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
                  ? Text(
                      "${'hi'.tr}, ${Get.find<Repository>().getStringValue(LocalKeys.fullName)}",
                      style: Styles.white50014,
                    )
                  : InkWell(
                      onTap: () {
                        (controller.isProfile ?? false)
                            ? RouteManagement.goToProfileScreen()
                            : RouteManagement.goTocreateProfileView();
                      },
                      child: Text(
                        controller.fullName?.isNotEmpty ?? false
                            ? "${'hi'.tr}, ${controller.fullName}"
                            : "hi_user".tr,
                        style: Styles.white50014,
                      ),
                    ),
              actions: [
                // InkWell(
                //   onTap: () {
                //     RouteManagement.goToScreenDemo();
                //   },
                //   child: SvgPicture.asset(
                //     AssetConstants.likeicon,
                //     colorFilter: const ColorFilter.mode(
                //       Colors.black,
                //       BlendMode.srcIn,
                //     ),
                //   ),
                // ),
                // Dimens.boxWidth20,
                // InkWell(
                //   onTap: () {},
                //   child: SvgPicture.asset(
                //     AssetConstants.promotionicon,
                //   ),
                // ),
                Dimens.boxWidth20,
                if (!Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) ...[
                  InkWell(
                    onTap: () {
                      if (controller.isSelcted) {
                        controller.isSelcted = false;
                      } else {
                        controller.isSelcted = true;
                      }
                      controller.update();
                    },
                    child: Container(
                      height: Dimens.thirty,
                      width: Dimens.thirty,
                      padding: Dimens.edgeInsets3,
                      child: SvgPicture.asset(
                        controller.isSelcted
                            ? AssetConstants.downicon
                            : AssetConstants.ic_up_arrow,
                      ),
                    ),
                  ),
                  Dimens.boxWidth20,
                ] else ...[
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                  fixedSize: Size(
                                                      double.infinity,
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
                                                  fixedSize: Size(
                                                      double.infinity,
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
                    child: Container(
                      padding: Dimens.edgeInsets3,
                      margin: Dimens.edgeInsetsRight20,
                      height: Dimens.thirty,
                      width: Dimens.thirty,
                      child: SvgPicture.asset(
                        AssetConstants.logout,
                      ),
                    ),
                  ),
                ]
              ]),
          bottomNavigationBar: (Utility.profileData != null &&
                  !(Utility.profileData?.isprofilecompleted ?? false))
              ? SafeArea(
                  top: false,
                  child: Container(
                    width: double.infinity,
                    color: ColorsValue.appColor,
                    padding: Dimens.edgeInsets20_10_20_10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Text(
                            "complete_your_profile".tr,
                            style: Styles.white70018.copyWith(
                              fontSize: Dimens.sixteen,
                            ),
                          ),
                        ),
                        Dimens.boxWidth10,
                        InkWell(
                          onTap: () {
                            controller.tabController.animateTo(0);
                            RouteManagement.goTocreateProfileView();
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.circular(
                                Dimens.twenty,
                              ),
                            ),
                            child: Text(
                              "Create Profile",
                              style: Styles.main60014.copyWith(
                                color: ColorsValue.appColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                )
              : null,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Material(
                elevation: Dimens.two,
                child: Container(
                  margin: Dimens.edgeInsetsLeft10,
                  width: double.infinity,
                  child: Column(
                    children: [
                      TabBar(
                        controller: controller.tabController,
                        labelPadding: EdgeInsets.zero,
                        unselectedLabelStyle: Styles.greyColor888850012,
                        labelStyle: Styles.greyColor888850012,
                        labelColor: ColorsValue.maincolor1,
                        dividerColor: Colors.transparent,
                        dividerHeight: 0,
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicator: const BoxDecoration(),
                        tabAlignment: Get.find<Repository>()
                                .getBoolValue(LocalKeys.isSubUser)
                            ? TabAlignment.start
                            : TabAlignment.fill,
                        isScrollable: Get.find<Repository>()
                                .getBoolValue(LocalKeys.isSubUser)
                            ? true
                            : false,
                        unselectedLabelColor: ColorsValue.greyColor8888,
                        indicatorColor: ColorsValue.transparent,
                        automaticIndicatorColorAdjustment: true,
                        onTap: (value) {
                          if (controller.tabController.index == 0) {
                            if (Get.isRegistered<ChatController>()) {
                              Get.find<ChatController>()
                                  .chatPagingController
                                  .refresh();
                            }
                          } else if (controller.tabController.index == 1) {
                            controller.selectedChateData = null;
                          } else if (controller.tabController.index == 2) {
                            // Status tab
                          } else {
                            if (Get.isRegistered<CallController>()) {
                              Get.find<CallController>()
                                  .chatHsitoryPagingController
                                  .refresh();
                            }
                          }
                        },
                        tabs: [
                          Tab(
                            icon: SizedBox(
                              height: Dimens.thirty,
                              width: Dimens.thirty,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    controller.tabController.index == 0
                                        ? AssetConstants.selectedchaticon
                                        : AssetConstants.unselectedchaticon,
                                  ),
                                  if (Get.isRegistered<ChatController>() &&
                                      Get.find<ChatController>()
                                              .totalMarkeReadUser !=
                                          0) ...[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: Dimens.fifteen,
                                        width: Dimens.fifteen,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          color: ColorsValue.appColor,
                                        ),
                                        child: Text(
                                          Get.find<ChatController>()
                                              .totalMarkeReadUser
                                              .toString(),
                                          style: Styles.white40012,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            text: "chat".tr,
                          ),
                          Tab(
                            icon: SizedBox(
                              height: Dimens.thirty,
                              width: Dimens.thirty,
                              child: Stack(
                                children: [
                                  SvgPicture.asset(
                                    controller.tabController.index == 1
                                        ? AssetConstants.selectedGroupchaticon
                                        : AssetConstants.unselectedgroupchat,
                                  ),
                                  if (Get.isRegistered<GroupChatController>() &&
                                      Get.find<GroupChatController>()
                                              .totalReadGroups !=
                                          0) ...[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: Dimens.fifteen,
                                        width: Dimens.fifteen,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          color: ColorsValue.appColor,
                                        ),
                                        child: Text(
                                          Get.find<GroupChatController>()
                                              .totalReadGroups
                                              .toString(),
                                          style: Styles.white40012,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            text: "groupchat".tr,
                          ),
                          Tab(
                            icon: Icon(
                              controller.tabController.index == 2
                                  ? Icons.radio_button_checked
                                  : Icons.radio_button_unchecked,
                              size: 26,
                            ),
                            text: "status".tr,
                          ),
                          Tab(
                            icon: SvgPicture.asset(
                              controller.tabController.index == 3
                                  ? AssetConstants.selectedcallicon
                                  : AssetConstants.unselectedcall,
                            ),
                            text: "calls".tr,
                          ),
                        ],
                      ),
                      AnimatedCollapse(
                        collapsed: controller.isSelcted,
                        duration: const Duration(milliseconds: 100),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Dimens.boxHeight10,
                            ..._buildDrawerRows(controller),
                            Dimens.boxHeight10,
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              _buildOngoingMeetingBanner(context),
              Expanded(
                child: TabBarView(
                  physics: const NeverScrollableScrollPhysics(),
                  controller: controller.tabController,
                  children: const [
                    ChatListScreen(),
                    GroupChatListScreen(),
                    StatusScreen(),
                    CallScreen(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Widget _buildDrawerItem({
    required Widget icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          icon,
          Dimens.boxHeight5,
          Text(
            title,
            style: Styles.greyColor888850012,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildDrawerRows(HomeScreenController controller) {
    List<Widget> items = [];

    // 1. Network list (always available)
    items.add(_buildDrawerItem(
      icon: SvgPicture.asset(AssetConstants.ic_contact_list),
      title: "Network list",
      onTap: () => RouteManagement.goToContactListScreen(),
    ));

    // 2. Broadcast (if allowed)
    if (controller.canAccess('Broadcast')) {
      items.add(_buildDrawerItem(
        icon: Image.asset(
          AssetConstants.ic_broadcast,
          height: Dimens.twentyFour,
          width: Dimens.twentyFour,
        ),
        title: "Broadcast",
        onTap: () => RouteManagement.goToBroadcastListScreen(),
      ));
    }

    // 3. Sessions (if allowed)
    if (controller.canAccess('Session')) {
      items.add(_buildDrawerItem(
        icon: SvgPicture.asset(AssetConstants.ic_meeting),
        title: "Sessions",
        onTap: () => RouteManagement.goToMeetingScreen(),
      ));
    }

    // 4. Marketplace (if allowed)
    if (controller.canAccess('Marketplace')) {
      items.add(_buildDrawerItem(
        icon: SvgPicture.asset(AssetConstants.ic_products),
        title: "Marketplace",
        onTap: () {
          var profileController = Get.find<ProfileController>();
          if (profileController.businessList.isNotEmpty) {
            RouteManagement.goTobusinessProductScreen(
                profileController.businessList[0].id ?? "");
          } else {
            RouteManagement.goToProductScreen();
          }
        },
      ));
    }

    // 5. Secure chat (if allowed)
    if (controller.canAccess('Chat')) {
      items.add(_buildDrawerItem(
        icon: SvgPicture.asset(AssetConstants.ic_chat_lock),
        title: "Secure chat",
        onTap: () {
          if (Utility.profileData?.recoveryEmail?.isEmpty ?? false) {
            RouteManagement.goToRecoveryEmailScreen("Lock");
          } else {
            if (Utility.profileData?.chatlockpin?.isEmpty ??
                (false || Utility.profileData?.chatlockpin == null)) {
              Utility.snacBar("no_secure_chat_info".tr, ColorsValue.appColor);
            } else {
              RouteManagement.goToChatLockVerifyScreen();
            }
          }
        },
      ));
    }

    // 6. Controls (always available)
    items.add(_buildDrawerItem(
      icon: SvgPicture.asset(AssetConstants.ic_setting),
      title: "Controls",
      onTap: () => RouteManagement.goToSettingScreen(),
    ));

    // Partition items into rows of 4 columns
    List<Widget> rowWidgets = [];
    for (int i = 0; i < items.length; i += 4) {
      int end = (i + 4 < items.length) ? i + 4 : items.length;
      List<Widget> rowCells =
          items.sublist(i, end).map((w) => Expanded(child: w)).toList();
      while (rowCells.length < 4) {
        rowCells.add(const Expanded(child: SizedBox()));
      }
      if (rowWidgets.isNotEmpty) {
        rowWidgets.add(Dimens.boxHeight15);
      }
      rowWidgets.add(Row(children: rowCells));
    }

    return rowWidgets;
  }

  Widget _buildOngoingMeetingBanner(BuildContext context) {
    if (!Get.find<HomeScreenController>().canAccess('Session')) {
      return const SizedBox.shrink();
    }
    final repo = Get.find<Repository>();
    final meetingId = repo.getStringValue(LocalKeys.lastActiveMeetingId);
    if (meetingId.isEmpty) return const SizedBox.shrink();
    final title = repo.getStringValue(LocalKeys.lastActiveMeetingTitle);
    final displayTitle = title.isNotEmpty ? title : "Ongoing Session";

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 4),
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
                  displayTitle,
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
            onPressed: () {
              RouteManagement.goToMeetingScreen();
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
            onTap: () {
              repo.clearData(LocalKeys.lastActiveMeetingId);
              repo.clearData(LocalKeys.lastActiveMeetingTitle);
              repo.clearData(LocalKeys.lastActiveMeetingChannel);
              repo.clearData(LocalKeys.lastActiveMeetingToken);
              repo.clearData(LocalKeys.lastActiveMeetingIsHost);
              setState(() {});
            },
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
