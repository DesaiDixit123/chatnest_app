import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) async {
        var controller = Get.find<ProfileController>();
        controller.getProfile();
        await controller.getBusinessList();
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          body: controller.profileData != null
              ? Column(
                  children: [
                    Container(
                      width: double.infinity,
                      color: ColorsValue.maincolor1,
                      child: Padding(
                        padding: Dimens.edgeInsets20_50_20_20,
                        child: controller.profileTabController.index == 0 ||
                                controller.businessList.isEmpty
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      RouteManagement.goToHomeScreenView();
                                    },
                                    child: SvgPicture.asset(
                                      AssetConstants.whitebackarrow,
                                    ),
                                  ),
                                  Dimens.boxWidth105,
                                  Center(
                                    child: CircleAvatar(
                                      radius: Dimens.fourtyFive,
                                      backgroundColor: ColorsValue.white,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.hundred,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (controller.profileImage ?? ""),
                                          fit: BoxFit.cover,
                                          maxHeightDiskCache: 300,
                                          maxWidthDiskCache: 300,
                                          width: Dimens.hundredThirty,
                                          height: Dimens.hundredThirty,
                                          placeholder: (context, url) => Center(
                                            child: Image.asset(
                                              AssetConstants.usera,
                                              height: Dimens.hundredThirty,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              Image.asset(
                                            AssetConstants.usera,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Dimens.boxHeight10,
                                  Center(
                                    child: Text(
                                      '${controller.profileData?.fullname}',
                                      style: Styles.white50016,
                                    ),
                                  ),
                                  Dimens.boxHeight3,
                                  Center(
                                    child: Text(
                                      '${controller.profileData?.nickname}',
                                      style: Styles.textfildback40016,
                                    ),
                                  ),
                                  // Dimens.boxHeight3,
                                  // if (controller
                                  //         .profileData?.hashtag?.isNotEmpty ??
                                  //     false) ...[
                                  //   Center(
                                  //     child: Text(
                                  //       "#${controller.profileData?.hashtag}",
                                  //       style: Styles.textfildback40016,
                                  //     ),
                                  //   ),
                                  // ],
                                  Dimens.boxHeight15,
                                  Center(
                                    child: InkWell(
                                      onTap: () {
                                        RouteManagement.goTocreateProfileView();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: ColorsValue.white,
                                          borderRadius: BorderRadius.circular(
                                              Dimens.five),
                                        ),
                                        child: Padding(
                                          padding: Dimens.edgeInsets9_12_9_12,
                                          child: Text(
                                            "edit_personal_profile".tr,
                                            style: Styles.main50014,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Dimens.boxHeight15,
                                  Center(
                                    child: Wrap(
                                      children: controller
                                              .profileData?.socialmedialinks
                                              ?.map((e) {
                                            return Visibility(
                                              visible: e.url.isNotEmpty
                                                  ? true
                                                  : false,
                                              child: InkWell(
                                                onTap: () {
                                                  Utility.launchLinkURL(e.url);
                                                },
                                                child: Padding(
                                                  padding:
                                                      Dimens.edgeInsets5_0_5_0,
                                                  child: Image.asset(
                                                    e.platform == "Facebook"
                                                        ? AssetConstants
                                                            .facebookimage
                                                        : e.platform ==
                                                                "Instagram"
                                                            ? AssetConstants
                                                                .instagramimage
                                                            : e.platform == "X"
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
                                                                        : e.platform ==
                                                                                "Youtube"
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
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      RouteManagement.goToHomeScreenView();
                                    },
                                    child: SvgPicture.asset(
                                      AssetConstants.whitebackarrow,
                                    ),
                                  ),
                                  // CarouselSlider.builder(
                                  //   key: UniqueKey(),
                                  //   itemCount: controller.businessList.length,
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
                                  //                         .businessList[index]
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
                                  //     initialPage: controller.businessIndex,
                                  //     height: Dimens.hundredTwenty,
                                  //     enableInfiniteScroll: false,
                                  //     pauseAutoPlayOnManualNavigate: true,
                                  //     enlargeCenterPage: true,
                                  //     viewportFraction: 0.5,
                                  //     autoPlay: false,
                                  //     onPageChanged: (index, reason) {
                                  //       controller.businessIndex = index;
                                  //       controller.markers.clear();
                                  //       controller.getOneBusiness(
                                  //           controller.businessList[index].id ??
                                  //               "",
                                  //           false);
                                  //       controller.update();
                                  //     },
                                  //   ),
                                  // ),
                                  Dimens.boxHeight15,
                                  Center(
                                    child: Text(
                                      controller
                                              .businessList[
                                                  controller.businessIndex]
                                              .name ??
                                          "",
                                      style: Styles.whiteBold18,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          RouteManagement
                                              .goToBusinessProfileScreen(
                                                  controller
                                                          .businessList[
                                                              controller
                                                                  .businessIndex]
                                                          .id ??
                                                      "");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorsValue.white,
                                            borderRadius: BorderRadius.circular(
                                                Dimens.five),
                                          ),
                                          child: Padding(
                                            padding: Dimens.edgeInsets9_12_9_12,
                                            child: Text(
                                              "edit_business_profile".tr,
                                              style: Styles.main50014,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Dimens.boxWidth15,
                                      InkWell(
                                        onTap: () {
                                          RouteManagement
                                              .goTobusinessProductScreen(
                                                  controller
                                                          .businessList[
                                                              controller
                                                                  .businessIndex]
                                                          .id ??
                                                      "");
                                        },
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: ColorsValue.white,
                                            borderRadius: BorderRadius.circular(
                                                Dimens.five),
                                          ),
                                          child: Padding(
                                            padding: Dimens.edgeInsets10,
                                            child: SvgPicture.asset(
                                                AssetConstants.ic_promotion),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  Dimens.boxHeight20,
                                  Center(
                                    child: Wrap(
                                      children: controller
                                              .businessList[
                                                  controller.businessIndex]
                                              .socialmedialinks
                                              ?.map((e) {
                                            return Visibility(
                                              visible: e.url.isNotEmpty
                                                  ? true
                                                  : false,
                                              child: InkWell(
                                                onTap: () {
                                                  Utility.launchLinkURL(e.url);
                                                },
                                                child: Padding(
                                                  padding:
                                                      Dimens.edgeInsets5_0_5_0,
                                                  child: Image.asset(
                                                    e.platform == "Facebook"
                                                        ? AssetConstants
                                                            .facebookimage
                                                        : e.platform ==
                                                                "Instagram"
                                                            ? AssetConstants
                                                                .instagramimage
                                                            : e.platform ==
                                                                        "Twitter" ||
                                                                    e.platform ==
                                                                        "X"
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
                                                                        : e.platform ==
                                                                                "Youtube"
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
                              ),
                      ),
                    ),
                    TabBar(
                      controller: controller.profileTabController,
                      indicatorColor: ColorsValue.maincolor1,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorPadding: Dimens.edgeInsets20_0_20_0,
                      indicator: UnderlineTabIndicator(
                        borderSide: BorderSide(
                          width: Dimens.three,
                          color: ColorsValue.maincolor1,
                        ),
                      ),
                      tabs: <Widget>[
                        Padding(
                          padding: Dimens.edgeInsets20_0_20_0,
                          child: Tab(
                            child: Text(
                              "personal_info".tr,
                              style: controller.profileTabController.index == 0
                                  ? Styles.main50014
                                  : Styles.greyColor888850014,
                            ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'business_info'.tr,
                            style: controller.profileTabController.index == 1
                                ? Styles.main50014
                                : Styles.greyColor888850014,
                          ),
                        ),
                      ],
                    ),
                    controller.profileTabController.index == 0
                        ? const Flexible(
                            child: PersonalProfileScreen(),
                          )
                        : const Flexible(
                            child: BusinessInfoScreen(),
                          ),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
