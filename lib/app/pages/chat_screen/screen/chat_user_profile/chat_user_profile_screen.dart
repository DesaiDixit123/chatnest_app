import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_options.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChatUserProfilescreen extends StatelessWidget {
  const ChatUserProfilescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
        initState: (state) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            final args = Get.arguments;
            if (args != null && args is String) {
              Get.find<ChatController>().getOneFriends(args);
            }
          });
        },
        builder: (controller) {
          return Scaffold(
            backgroundColor: ColorsValue.white,
            body: controller.getOneFriendsData != null
                ? Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: Dimens.edgeInsets20_50_20_20,
                        color: ColorsValue.maincolor1,
                        child: controller.tabController?.index == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: InkWell(
                                      onTap: () {
                                        Get.back();
                                      },
                                      child: SvgPicture.asset(
                                        AssetConstants.whitebackarrow,
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      RouteManagement.goToShowFullScareenImage(
                                          controller.getOneFriendsData
                                                  ?.profileimage ??
                                              "",
                                          "Image");
                                    },
                                    child: Container(
                                      height: Dimens.hundredTwenty,
                                      width: Dimens.hundredTwenty,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: ColorsValue.white,
                                        border: Border.all(
                                          width: Dimens.one,
                                          color: ColorsValue.white,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.hundredFifty,
                                        ),
                                        child: ApiWrapper.isValidImageUrl(controller.getOneFriendsData?.profileimage)
                                            ? CachedNetworkImage(
                                                imageUrl: ApiWrapper.imageUrl +
                                                    controller
                                                        .getOneFriendsData!
                                                        .profileimage!,
                                                fit: BoxFit.cover,
                                                maxHeightDiskCache: 300,
                                                maxWidthDiskCache: 300,
                                                width: Dimens.hundredFifty,
                                                height: Dimens.hundredFifty,
                                                placeholder: (context, url) =>
                                                    Center(
                                                  child: Image.asset(
                                                    AssetConstants.usera,
                                                    height: Dimens.hundredFifty,
                                                    width: Dimens.hundredFifty,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Image.asset(
                                                  AssetConstants.usera,
                                                  height: Dimens.hundredFifty,
                                                  width: Dimens.hundredFifty,
                                                  fit: BoxFit.cover,
                                                ),
                                              )
                                            : Image.asset(
                                                AssetConstants.usera,
                                                height: Dimens.hundredFifty,
                                                width: Dimens.hundredFifty,
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                    ),
                                  ),
                                  Dimens.boxHeight15,
                                  Text(
                                    controller.getOneFriendsData?.fullname
                                                ?.isNotEmpty ??
                                            false
                                        ? controller
                                                .getOneFriendsData?.fullname ??
                                            ""
                                        : controller
                                                .getOneFriendsData?.nickname ??
                                            "",
                                    style: Styles.white50016,
                                  ),
                                  Dimens.boxHeight5,
                                  if (controller.getOneFriendsData?.fullname
                                          ?.isNotEmpty ??
                                      false) ...[
                                    Text(
                                      controller.getOneFriendsData?.nickname ??
                                          "",
                                      style: Styles.textfildback40016,
                                    ),
                                  ],
                                  Dimens.boxHeight10,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.getOneFriendsData
                                              ?.usersPermissions?.videocall ??
                                          false) ...[
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (await Utility
                                                        .cameraPermissionCheack(
                                                            context) &&
                                                    await Utility
                                                        .microphonePermissionCheack(
                                                            context)) {
                                                  controller.postCallInitaite(
                                                    isLoading: false,
                                                    receiverId:
                                                        controller.userId ?? '',
                                                    isAudioCall: false,
                                                    isGroupCall: false,
                                                    isVideoCall: true,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.videoIcon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'video'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                      ],
                                      Dimens.boxWidth15,
                                      if (controller.getOneFriendsData
                                              ?.usersPermissions?.audiocall ??
                                          false) ...[
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (await Utility
                                                    .microphonePermissionCheack(
                                                        context)) {
                                                  controller.postCallInitaite(
                                                    isLoading: false,
                                                    receiverId:
                                                        controller.userId ?? '',
                                                    isAudioCall: true,
                                                    isGroupCall: false,
                                                    isVideoCall: false,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.callicon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'audio'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                      ],
                                      // Dimens.boxWidth15,
                                      // Column(
                                      //   children: [
                                      //     InkWell(
                                      //       onTap: () async {},
                                      //       child: Container(
                                      //         height: Dimens.fourty,
                                      //         width: Dimens.fourty,
                                      //         decoration: BoxDecoration(
                                      //           color: ColorsValue.white,
                                      //           borderRadius:
                                      //               BorderRadius.circular(
                                      //                   Dimens.five),
                                      //         ),
                                      //         child: Padding(
                                      //           padding: Dimens.edgeInsets8,
                                      //           child: SvgPicture.asset(
                                      //             AssetConstants.ic_share,
                                      //             colorFilter:
                                      //                 const ColorFilter.mode(
                                      //               ColorsValue.maincolor1,
                                      //               BlendMode.srcIn,
                                      //             ),
                                      //           ),
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     Dimens.boxHeight5,
                                      //     Text(
                                      //       'Share'.tr,
                                      //       style: Styles.white40012,
                                      //     ),
                                      //   ],
                                      // ),
                                    ],
                                  ),
                                  Dimens.boxHeight15,
                                  if (controller.getOneFriendsData
                                          ?.usersPermissions?.socialmedia ??
                                      false) ...[
                                    Center(
                                      child: Wrap(
                                        children: controller.getOneFriendsData
                                                ?.socialmedialinks
                                                ?.map((e) {
                                              return Visibility(
                                                visible: e.url.isNotEmpty
                                                    ? true
                                                    : false,
                                                child: InkWell(
                                                  onTap: () {
                                                    Utility.launchLinkURL(
                                                        e.url);
                                                  },
                                                  child: Padding(
                                                    padding: Dimens
                                                        .edgeInsets5_0_5_0,
                                                    child: Image.asset(
                                                      e.platform == "Facebook"
                                                          ? AssetConstants
                                                              .facebookimage
                                                          : e.platform ==
                                                                  "Instagram"
                                                              ? AssetConstants
                                                                  .instagramimage
                                                              : e.platform ==
                                                                          "X" ||
                                                                      e.platform ==
                                                                          "Twitter"
                                                                  ? AssetConstants
                                                                      .ximage
                                                                  : e.platform ==
                                                                          "Pinterest"
                                                                      ? AssetConstants
                                                                          .printrestimage
                                                                      : e.platform ==
                                                                              "Linkedin"
                                                                          ? AssetConstants
                                                                              .linkedinimage
                                                                          : e.platform == "Youtube"
                                                                              ? AssetConstants.youtubeimage
                                                                              : "",
                                                      height: Dimens.thirtyFive,
                                                      width: Dimens.thirtyFive,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                    )
                                  ]
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(
                                      AssetConstants.whitebackarrow,
                                    ),
                                  ),
                                  // CarouselSlider.builder(
                                  //   itemCount: controller.getOneFriendsData
                                  //           ?.businessprofiles?.length ??
                                  //       0,
                                  //   itemBuilder: (ctx, index, realIndex) {
                                  //     return Container(
                                  //       height: Dimens.hundredTwenty,
                                  //       width: Dimens.hundredTwenty,
                                  //       decoration: BoxDecoration(
                                  //         color: Colors.white,
                                  //         borderRadius: BorderRadius.circular(
                                  //           Dimens.hundredEighty,
                                  //         ),
                                  //         border: Border.all(
                                  //           color: Colors.white,
                                  //           width: Dimens.one,
                                  //         ),
                                  //       ),
                                  //       child: ClipRRect(
                                  //         borderRadius: BorderRadius.circular(
                                  //           Dimens.hundredEighty,
                                  //         ),
                                  //         child: Center(
                                  //           child: CachedNetworkImage(
                                  //             imageUrl: ApiWrapper.imageUrl +
                                  //                 (controller
                                  //                         .getOneFriendsData
                                  //                         ?.businessprofiles?[
                                  //                             index]
                                  //                         .profileimage ??
                                  //                     ""),
                                  //             fit: BoxFit.cover,
                                  //             maxHeightDiskCache: 300,
                                  //             maxWidthDiskCache: 300,
                                  //             height: Dimens.hundredTwenty,
                                  //             width: Dimens.hundredTwenty,
                                  //             placeholder: (context, url) =>
                                  //                 Center(
                                  //               child: Image.asset(
                                  //                 AssetConstants.usera,
                                  //               ),
                                  //             ),
                                  //             errorWidget:
                                  //                 (context, url, error) =>
                                  //                     Image.asset(
                                  //               AssetConstants.usera,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     );
                                  //   },
                                  //   options: CarouselOptions(
                                  //     initialPage: 0,
                                  //     height: Dimens.hundredTwenty,
                                  //     enableInfiniteScroll: false,
                                  //     pauseAutoPlayOnManualNavigate: true,
                                  //     enlargeCenterPage: true,
                                  //     viewportFraction: 0.5,
                                  //     autoPlay: false,
                                  //     onPageChanged: (index, reason) async {
                                  //       controller.userBusinessIndex = index;
                                  //       controller.locationBusinessText =
                                  //           await controller.getLocation(
                                  //               controller
                                  //                   .getOneFriendsData!
                                  //                   .businessprofiles![index]
                                  //                   .location!
                                  //                   .coordinates[1],
                                  //               controller
                                  //                   .getOneFriendsData!
                                  //                   .businessprofiles![index]
                                  //                   .location!
                                  //                   .coordinates[0]);
                                  //       controller.markers.clear();
                                  //       controller.businessLatlag = LatLng(
                                  //           controller
                                  //               .getOneFriendsData!
                                  //               .businessprofiles![index]
                                  //               .location!
                                  //               .coordinates[1],
                                  //           controller
                                  //               .getOneFriendsData!
                                  //               .businessprofiles![index]
                                  //               .location!
                                  //               .coordinates[0]);
                                  //       controller.update();
                                  //     },
                                  //   ),
                                  // ),
                                  Dimens.boxHeight15,
                                  Center(
                                    child: Text(
                                      controller
                                                  .getOneFriendsData
                                                  ?.businessprofiles
                                                  ?.isNotEmpty ??
                                              false
                                          ? (controller
                                                  .getOneFriendsData
                                                  ?.businessprofiles?[controller
                                                      .userBusinessIndex]
                                                  .name ??
                                              "")
                                          : "",
                                      style: Styles.white50016,
                                    ),
                                  ),
                                  Dimens.boxHeight10,
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      if (controller.getOneFriendsData
                                              ?.usersPermissions?.videocall ??
                                          false) ...[
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (await Utility
                                                        .cameraPermissionCheack(
                                                            context) &&
                                                    await Utility
                                                        .microphonePermissionCheack(
                                                            context)) {
                                                  controller.postCallInitaite(
                                                    isLoading: true,
                                                    receiverId:
                                                        controller.userId ?? '',
                                                    isAudioCall: false,
                                                    isGroupCall: false,
                                                    isVideoCall: true,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.videoIcon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'video'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                        Dimens.boxWidth15,
                                      ],
                                      if (controller.getOneFriendsData
                                              ?.usersPermissions?.audiocall ??
                                          false) ...[
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () async {
                                                if (await Utility
                                                    .microphonePermissionCheack(
                                                        context)) {
                                                  controller.postCallInitaite(
                                                    isLoading: true,
                                                    receiverId:
                                                        controller.userId ?? '',
                                                    isAudioCall: true,
                                                    isGroupCall: false,
                                                    isVideoCall: false,
                                                  );
                                                }
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.callicon,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'audio'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                        Dimens.boxWidth15,
                                      ],
                                      if (controller.getOneFriendsData
                                              ?.businessprofiles?.isNotEmpty ??
                                          false) ...[
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                RouteManagement
                                                    .goToChatProductScreen(true);
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.ic_products,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'products'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                        Dimens.boxWidth15,
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .getOneFriendsData
                                                        ?.businessprofiles?[
                                                            controller
                                                                .userBusinessIndex]
                                                        .website ??
                                                    "");
                                              },
                                              child: Container(
                                                height: Dimens.fourty,
                                                width: Dimens.fourty,
                                                decoration: BoxDecoration(
                                                  color: ColorsValue.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.five),
                                                ),
                                                child: Padding(
                                                  padding: Dimens.edgeInsets8,
                                                  child: SvgPicture.asset(
                                                    AssetConstants.ic_website,
                                                    colorFilter:
                                                        const ColorFilter.mode(
                                                      ColorsValue.maincolor1,
                                                      BlendMode.srcIn,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Dimens.boxHeight5,
                                            Text(
                                              'website'.tr,
                                              style: Styles.white40012,
                                            ),
                                          ],
                                        ),
                                      ],
                                      //     Dimens.boxWidth15,
                                      //     Column(
                                      //       children: [
                                      //         InkWell(
                                      //           onTap: () async {},
                                      //           child: Container(
                                      //             height: Dimens.fourty,
                                      //             width: Dimens.fourty,
                                      //             decoration: BoxDecoration(
                                      //               color: ColorsValue.white,
                                      //               borderRadius:
                                      //                   BorderRadius.circular(
                                      //                       Dimens.five),
                                      //             ),
                                      //             child: Padding(
                                      //               padding: Dimens.edgeInsets8,
                                      //               child: SvgPicture.asset(
                                      //                 AssetConstants.ic_share,
                                      //                 colorFilter:
                                      //                     const ColorFilter.mode(
                                      //                   ColorsValue.maincolor1,
                                      //                   BlendMode.srcIn,
                                      //                 ),
                                      //               ),
                                      //             ),
                                      //           ),
                                      //         ),
                                      //         Dimens.boxHeight5,
                                      //         Text(
                                      //           'Share'.tr,
                                      //           style: Styles.white40012,
                                      //         ),
                                      //       ],
                                      //     ),
                                    ],
                                  ),
                                  Dimens.boxHeight15,
                                  if ((controller.getOneFriendsData
                                              ?.usersPermissions?.socialmedia ??
                                          false) &&
                                      (controller.getOneFriendsData
                                              ?.businessprofiles?.isNotEmpty ??
                                          false)) ...[
                                    Center(
                                      child: Wrap(
                                        children: controller
                                                .getOneFriendsData
                                                ?.businessprofiles?[controller
                                                    .userBusinessIndex]
                                                .socialmedialinks
                                                ?.map((e) {
                                              return Visibility(
                                                visible: e.url.isNotEmpty
                                                    ? true
                                                    : false,
                                                child: InkWell(
                                                  onTap: () {
                                                    Utility.launchLinkURL(
                                                        e.url);
                                                  },
                                                  child: Padding(
                                                    padding: Dimens
                                                        .edgeInsets5_0_5_0,
                                                    child: Image.asset(
                                                      e.platform == "Facebook"
                                                          ? AssetConstants
                                                              .facebookimage
                                                          : e.platform ==
                                                                  "Instagram"
                                                              ? AssetConstants
                                                                  .instagramimage
                                                              : e.platform ==
                                                                          "X" ||
                                                                      e.platform ==
                                                                          "Twitter"
                                                                  ? AssetConstants
                                                                      .ximage
                                                                  : e.platform ==
                                                                          "Pinterest"
                                                                      ? AssetConstants
                                                                          .printrestimage
                                                                      : e.platform ==
                                                                              "Linkedin"
                                                                          ? AssetConstants
                                                                              .linkedinimage
                                                                          : e.platform == "Youtube"
                                                                              ? AssetConstants.youtubeimage
                                                                              : "",
                                                      height: Dimens.thirtyFive,
                                                      width: Dimens.thirtyFive,
                                                    ),
                                                  ),
                                                ),
                                              );
                                            }).toList() ??
                                            [],
                                      ),
                                    )
                                  ],
                                ],
                              ),
                      ),
                      if (controller.getOneFriendsData?.businessprofiles
                              ?.isNotEmpty ??
                          false) ...[
                        TabBar(
                          controller: controller.tabController,
                          indicatorColor: ColorsValue.maincolor1,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicatorWeight: 5,
                          indicatorPadding: Dimens.edgeInsets20_0_20_0,
                          indicator: UnderlineTabIndicator(
                            borderSide: BorderSide(
                              width: Dimens.three,
                              color: ColorsValue.maincolor1,
                            ),
                          ),
                          labelPadding: Dimens.edgeInsets0,
                          padding: Dimens.edgeInsets0,
                          tabs: [
                            Padding(
                              padding: Dimens.edgeInsets20_0_20_0,
                              child: Tab(
                                child: Text(
                                  "personal_info".tr,
                                  style: controller.tabController?.index == 0
                                      ? Styles.main50016
                                      : Styles.greyColor888850016,
                                ),
                              ),
                            ),
                            Tab(
                              child: Text(
                                'business_info'.tr,
                                style: controller.tabController?.index == 1
                                    ? Styles.main50016
                                    : Styles.greyColor888850016,
                              ),
                            ),
                          ],
                        ),
                        Flexible(
                          child: TabBarView(
                            controller: controller.tabController,
                            children: const [
                              ChatPersonalInfoScreen(),
                              ChatBusinessInfoScreen(),
                            ],
                          ),
                        ),
                      ] else ...[
                        const Flexible(
                          child: ChatPersonalInfoScreen(),
                        ),
                      ],
                    ],
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          );
        });
  }
}
