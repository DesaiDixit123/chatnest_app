import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class BroadCastProfileScreen extends StatelessWidget {
  const BroadCastProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BroadCastController>(
      initState: (state) {
        var controller = Get.find<BroadCastController>();
        controller.getOneBroadcast(Get.arguments ?? "");
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            backgroundColor: ColorsValue.maincolor1,
            leading: Padding(
              padding: Dimens.edgeInsetsLeft20,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SvgPicture.asset(
                    AssetConstants.backicon,
                    colorFilter: const ColorFilter.mode(
                      ColorsValue.white,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
              ),
            ),
          ),
          body: SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Container(
                  color: ColorsValue.maincolor1,
                  padding: Dimens.edgeInsets20,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: Dimens.hundredTwenty,
                        width: Dimens.hundredTwenty,
                        padding: Dimens.edgeInsets20,
                        decoration: BoxDecoration(
                          color: ColorsValue.lightmainColor,
                          borderRadius: BorderRadius.circular(
                            Dimens.twoHundred,
                          ),
                          border: Border.all(
                            width: Dimens.two,
                            color: ColorsValue.white,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            Dimens.twoHundred,
                          ),
                          child: SvgPicture.asset(
                            AssetConstants.promotionIcon,
                          ),
                        ),
                      ),
                      Dimens.boxHeight10,
                      Text(
                        controller.getOneBroadcastData?.broadcasttitle ?? "",
                        style: Styles.white70018,
                      ),
                      Dimens.boxHeight10,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              RouteManagement.goToAddBroadcastScreen(true);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsValue.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.five),
                                ),
                              ),
                              child: Padding(
                                padding: Dimens.edgeInsets10,
                                child: Text(
                                  "edit_broadCast_name".tr.toUpperCase(),
                                  style: Styles.main50014,
                                ),
                              ),
                            ),
                          ),
                          Dimens.boxWidth10,
                          InkWell(
                            onTap: () {
                              controller.postDeleteBroadcast(
                                  controller.getOneBroadcastData?.id ?? "");
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: ColorsValue.white,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(Dimens.five),
                                ),
                              ),
                              child: Padding(
                                padding: Dimens.edgeInsets8,
                                child: SvgPicture.asset(
                                  AssetConstants.deletIcon,
                                  height: Dimens.twentyFour,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                if (controller.getOneBroadcastData?.latestmedias?.isNotEmpty ??
                    false) ...[
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "shared_media".tr,
                          style: Styles.black50014,
                        ),
                        TextButton(
                          onPressed: () {
                            RouteManagement.goToSharedMediascreen(
                                controller.getOneBroadcastData?.id ?? "",
                                true,
                                controller
                                        .getOneBroadcastData?.broadcasttitle ??
                                    "",
                                false);
                          },
                          child: Text(
                            "see_all".tr,
                            style: Styles.main50012,
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: Dimens.edgeInsets20_10_20_0,
                    child: SizedBox(
                      height: Dimens.eighty,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller
                            .getOneBroadcastData?.latestmedias?.length,
                        itemBuilder: ((context, index) {
                          var item = controller
                              .getOneBroadcastData?.latestmedias?[index];
                          return Padding(
                            padding: Dimens.edgeInsets5_0_5_0,
                            child: Container(
                              height: Dimens.seventyFive,
                              width: Dimens.seventyFive,
                              decoration: BoxDecoration(
                                color: ColorsValue.white,
                                borderRadius: BorderRadius.circular(
                                  Dimens.six,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimens.six,
                                ),
                                child: item?.contentType == "multimedia" ||
                                        item?.contentType ==
                                            "multimediawithtext" ||
                                        item?.contentType ==
                                            "multimediawithlinks"
                                    ? item?.content?.multimedias![0].type ==
                                            "IMG"
                                        ? item?.content?.multimedias![0].path
                                                    .split('.')
                                                    .last ==
                                                "svg"
                                            ? SvgPicture.network(
                                                ApiWrapper.imageUrl +
                                                    (item
                                                            ?.content
                                                            ?.multimedias?[0]
                                                            .path ??
                                                        ""),
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: ApiWrapper.imageUrl +
                                                    (item
                                                            ?.content
                                                            ?.multimedias?[0]
                                                            .path ??
                                                        ""),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) {
                                                  return Image.asset(
                                                    AssetConstants.placeholder,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Image.asset(
                                                    AssetConstants.placeholder,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                        : Stack(
                                            children: [
                                              ThumbNailImageFullpage(
                                                url: (item
                                                        ?.content?.media.path ??
                                                    ""),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goToShowFullScareenImage(
                                                          item?.content?.media
                                                                  .path ??
                                                              "",
                                                          "Video");
                                                },
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    AssetConstants
                                                        .ic_video_play,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                    : item?.content?.media.type == "IMG"
                                        ? item?.content?.media.path
                                                    .split('.')
                                                    .last ==
                                                "svg"
                                            ? SvgPicture.network(
                                                ApiWrapper.imageUrl +
                                                    (item?.content?.media
                                                            .path ??
                                                        ""),
                                                fit: BoxFit.cover,
                                              )
                                            : CachedNetworkImage(
                                                imageUrl: ApiWrapper.imageUrl +
                                                    (item?.content?.media
                                                            .path ??
                                                        ""),
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) {
                                                  return Image.asset(
                                                    AssetConstants.placeholder,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                                errorWidget:
                                                    (context, url, error) {
                                                  return Image.asset(
                                                    AssetConstants.placeholder,
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              )
                                        : Stack(
                                            children: [
                                              ThumbNailImageFullpage(
                                                url: (item
                                                        ?.content?.media.path ??
                                                    ""),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  RouteManagement
                                                      .goToShowFullScareenImage(
                                                          item?.content?.media
                                                                  .path ??
                                                              "",
                                                          "Video");
                                                },
                                                child: Center(
                                                  child: SvgPicture.asset(
                                                    AssetConstants
                                                        .ic_video_play,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                  ),
                  Dimens.boxHeight20,
                  const Divider(
                    height: 1,
                    color: ColorsValue.grey,
                  ),
                ],
                Dimens.boxHeight10,
                Padding(
                  padding: Dimens.edgeInsets20_0_20_0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "${controller.getOneBroadcastData?.members?.length} peoples"
                            .tr,
                        style: Styles.greyColor888850014,
                      ),
                      InkWell(
                        onTap: () {
                          RouteManagement.goToAddBroadcastScreen(true);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: ColorsValue.maincolor1.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets2,
                            child: SvgPicture.asset(
                              AssetConstants.adduserBroadcast,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: Dimens.edgeInsets20_0_20_20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount:
                            (controller.getOneBroadcastData?.members?.length ??
                                0),
                        itemBuilder: (context, index) => index < 5
                            ? ListTile(
                                contentPadding: Dimens.edgeInsets0,
                                leading: Container(
                                  height: Dimens.fifty,
                                  width: Dimens.fifty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.blackColor,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${ApiWrapper.imageUrl}${controller.getOneBroadcastData?.members?[index].userid?.profileimage ?? ""}",
                                      fit: BoxFit.cover,
                                      maxHeightDiskCache: 300,
                                      maxWidthDiskCache: 300,
                                      width: Dimens.fifty,
                                      height: Dimens.fifty,
                                      placeholder: (context, url) => Center(
                                        child: Image.asset(
                                          AssetConstants.usera,
                                          height: Dimens.fifty,
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(AssetConstants.usera),
                                    ),
                                  ),
                                ),
                                trailing: InkWell(
                                    onTap: () {
                                      Get.dialog(
                                        StatefulBuilder(
                                          builder: (context, setState) =>
                                              Padding(
                                            padding: Dimens.edgeInsetsTop20,
                                            child: Material(
                                              color: ColorsValue.transparent,
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.stretch,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding: Dimens
                                                        .edgeInsets20_0_20_0,
                                                    child: Container(
                                                      decoration: BoxDecoration(
                                                        color:
                                                            ColorsValue.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(Dimens
                                                                    .fifteen),
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            Dimens.edgeInsets20,
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    RouteManagement.gooffAndToNamedChatScreen(controller
                                                                            .getOneBroadcastData
                                                                            ?.members?[index]
                                                                            .userid
                                                                            ?.id ??
                                                                        "",false);
                                                                  },
                                                                  child: Text(
                                                                    "chat_message"
                                                                        .tr,
                                                                    style: Styles
                                                                        .greyColor888840014,
                                                                  ),
                                                                ),
                                                                InkWell(
                                                                  onTap: () {
                                                                    Get.back();
                                                                  },
                                                                  child: SvgPicture.asset(
                                                                      AssetConstants
                                                                          .cancleicon),
                                                                )
                                                              ],
                                                            ),
                                                            Dimens.boxHeight10,
                                                            InkWell(
                                                              onTap: () {
                                                                Get.back();
                                                                print(controller
                                                                    .getOneBroadcastData!
                                                                    .members!
                                                                    .length);
                                                                if (controller
                                                                        .getOneBroadcastData!
                                                                        .members!
                                                                        .length <=
                                                                    2) {
                                                                  Utility.errorMessage(
                                                                      "At least 2 Contacts must be selected");
                                                                } else {
                                                                  controller.postBrodcastMemberRemove(
                                                                      controller
                                                                          .getOneBroadcastData!,
                                                                      index);
                                                                }
                                                              },
                                                              child: Text(
                                                                "remove_member"
                                                                    .tr,
                                                                style: Styles
                                                                    .redColor40014,
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    child:
                                        const Icon(Icons.more_vert_outlined)),
                                title: Text(
                                  controller.getOneBroadcastData
                                          ?.members?[index].userid?.fullname ??
                                      "",
                                  style: Styles.black50016,
                                ),
                                subtitle: Text(
                                  "${controller.getOneBroadcastData?.members?[index].userid?.countryCode ?? ""} ${controller.getOneBroadcastData?.members?[index].userid?.mobile ?? ""}",
                                  style: Styles.greyColor888840012,
                                ),
                              )
                            : Visibility(
                                visible:
                                    controller.showMemberList ? true : false,
                                child: ListTile(
                                  contentPadding: Dimens.edgeInsets0,
                                  leading: Container(
                                    height: Dimens.fifty,
                                    width: Dimens.fifty,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimens.hundred,
                                      ),
                                      color: ColorsValue.blackColor,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        Dimens.hundred,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${ApiWrapper.imageUrl}${controller.getOneBroadcastData?.members?[index].userid?.profileimage ?? ""}",
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 300,
                                        maxWidthDiskCache: 300,
                                        width: Dimens.fifty,
                                        height: Dimens.fifty,
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(
                                            AssetConstants.usera,
                                            height: Dimens.fifty,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(AssetConstants.usera),
                                      ),
                                    ),
                                  ),
                                  trailing: InkWell(
                                      onTap: () {
                                        Get.dialog(
                                          StatefulBuilder(
                                            builder: (context, setState) =>
                                                Padding(
                                              padding: Dimens.edgeInsetsTop20,
                                              child: Material(
                                                color: ColorsValue.transparent,
                                                child: Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .stretch,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Padding(
                                                        padding: Dimens
                                                            .edgeInsets20_0_20_0,
                                                        child: Container(
                                                          decoration:
                                                              BoxDecoration(
                                                            color: ColorsValue
                                                                .white,
                                                            borderRadius: BorderRadius
                                                                .circular(Dimens
                                                                    .fifteen),
                                                          ),
                                                          child: Padding(
                                                            padding: Dimens
                                                                .edgeInsets20,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .start,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "chat_message",
                                                                      style: Styles
                                                                          .greyColor888840012,
                                                                    ),
                                                                    InkWell(
                                                                      onTap:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      child: SvgPicture.asset(
                                                                          AssetConstants
                                                                              .cancleicon),
                                                                    )
                                                                  ],
                                                                ),
                                                                Dimens
                                                                    .boxHeight10,
                                                                Text(
                                                                  "remove_member",
                                                                  style: Styles
                                                                      .redColor40014,
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                      child:
                                          const Icon(Icons.more_vert_outlined)),
                                  title: Text(
                                    controller
                                            .getOneBroadcastData
                                            ?.members?[index]
                                            .userid
                                            ?.fullname ??
                                        "",
                                    style: Styles.black50016,
                                  ),
                                  subtitle: Text(
                                    "${controller.getOneBroadcastData?.members?[index].userid?.countryCode ?? ""} ${controller.getOneBroadcastData?.members?[index].userid?.mobile ?? ""}",
                                    style: Styles.greyColor888840012,
                                  ),
                                ),
                              ),
                      ),
                      Visibility(
                        visible:
                            (controller.getOneBroadcastData?.members?.length ??
                                        0) >
                                    5
                                ? true
                                : false,
                        child: InkWell(
                          onTap: () {
                            if (controller.showMemberList) {
                              controller.showMemberList = false;
                            } else {
                              controller.showMemberList = true;
                            }
                            controller.update();
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                controller.showMemberList
                                    ? "show_less".tr
                                    : "show_more".tr,
                                style: Styles.main60012,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Dimens.boxHeight20,
                      Divider(
                        height: Dimens.one,
                        color: ColorsValue.textfildbackcolor,
                      ),
                      ListTile(
                        onTap: () {
                          RouteManagement.goToBrodcastFavoriteListScreen(
                              Get.arguments ?? "");
                        },
                        contentPadding: Dimens.edgeInsets0,
                        title: Text(
                          "Favorite Message",
                          style: Styles.black50016,
                        ),
                        leading: SvgPicture.asset(AssetConstants.staricon),
                        trailing:
                            SvgPicture.asset(AssetConstants.ic_right_arrow),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
