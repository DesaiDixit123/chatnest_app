import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/repositories/repositories.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class GroupProfileDetailsScreen extends StatelessWidget {
  const GroupProfileDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(initState: (state) {
      var controller = Get.find<GroupChatController>();
      controller.groupId = Get.arguments ?? "";
      controller.getOneGroup(controller.groupId);
    }, builder: (controller) {
      controller.index = controller.getOneGroupData?.members?.indexWhere(
            (element) {
              if (Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) {
                return element.userid?.id ==
                    Get.find<Repository>()
                        .getStringValue(LocalKeys.parentUserId);
              } else {
                return element.userid?.id ==
                    Get.find<Repository>().getStringValue(LocalKeys.userIds);
              }
            },
          ) ??
          0;
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          backgroundColor: ColorsValue.maincolor1,
          leading: InkWell(
            onTap: () {
              Get.back();
            },
            child: Padding(
              padding: Dimens.edgeInsets20_15_10_15,
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
        ),
        body: controller.getOneGroupData?.members != null
            ? ListView(
                children: [
                  Container(
                    padding: Dimens.edgeInsets20_0_20_0,
                    width: double.infinity,
                    color: ColorsValue.maincolor1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () {
                            RouteManagement.goToShowFullScareenImage(
                                controller.getOneGroupData?.profileimage ?? "",
                                "Image");
                          },
                          child: SizedBox(
                            height: Dimens.hundredTwenty,
                            width: Dimens.hundredTwenty,
                            child: Container(
                              height: Dimens.hundredTwenty,
                              width: Dimens.hundredTwenty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                color: ColorsValue.blackColor,
                                border: Border.all(
                                  color: ColorsValue.white,
                                  width: Dimens.two,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: ApiWrapper.imageUrl +
                                      (controller
                                              .getOneGroupData?.profileimage ??
                                          ""),
                                  fit: BoxFit.cover,
                                  maxHeightDiskCache: 300,
                                  maxWidthDiskCache: 300,
                                  width: Dimens.hundredTwenty,
                                  height: Dimens.hundredTwenty,
                                  placeholder: (context, url) => Center(
                                    child: Image.asset(
                                      AssetConstants.usera,
                                      height: Dimens.hundredTwenty,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Image.asset(
                                    AssetConstants.usera,
                                    height: Dimens.hundredTwenty,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxHeight10,
                        Text(
                          controller.getOneGroupData?.name ?? "",
                          style: Styles.whiteBold18,
                        ),
                        Dimens.boxHeight10,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if ((controller
                                        .getOneGroupData
                                        ?.members?[controller.index]
                                        .permissions
                                        ?.isadmin ??
                                    false) ||
                                (controller
                                        .getOneGroupData
                                        ?.members?[controller.index]
                                        .permissions
                                        ?.ismanager ??
                                    false)) ...[
                              InkWell(
                                onTap: () {
                                  controller.uploadGroupPic = controller
                                          .getOneGroupData?.profileimage ??
                                      "";
                                  controller.titleController.text =
                                      controller.getOneGroupData?.name ?? "";
                                  controller.descriptionController.text =
                                      controller.getOneGroupData?.description ??
                                          "";
                                  RouteManagement.goToEditGroupDetailsScreen();
                                },
                                child: Container(
                                  height: Dimens.fourty,
                                  padding: Dimens.edgeInsets12_0_12_0,
                                  decoration: BoxDecoration(
                                    color: ColorsValue.white,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'edit_group_info'.tr,
                                      style: Styles.main50014,
                                    ),
                                  ),
                                ),
                              )
                            ],
                            Dimens.boxWidth10,
                            InkWell(
                              onTap: () async {
                                if (await Utility.cameraPermissionCheack(
                                        context) &&
                                    await Utility.microphonePermissionCheack(
                                        context)) {
                                  Get.find<ChatController>()
                                      .postGroupCallInitaite(
                                    isLoading: true,
                                    receiverId: controller.groupId ?? '',
                                    isAudioCall: false,
                                    isVideoCall: true,
                                    isGroupCall: true,
                                  );
                                }
                              },
                              child: Container(
                                height: Dimens.fourty,
                                padding: Dimens.edgeInsets12_0_12_0,
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AssetConstants.videoIcon,
                                    colorFilter: ColorFilter.mode(
                                      ColorsValue.maincolor1,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Dimens.boxWidth10,
                            InkWell(
                              onTap: () async {
                                if (await Utility.microphonePermissionCheack(
                                    context)) {
                                  Get.find<ChatController>()
                                      .postGroupCallInitaite(
                                    isLoading: true,
                                    receiverId: controller.groupId ?? '',
                                    isAudioCall: true,
                                    isGroupCall: true,
                                    isVideoCall: false,
                                  );
                                }
                              },
                              child: Container(
                                height: Dimens.fourty,
                                padding: Dimens.edgeInsets12_0_12_0,
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                ),
                                child: Center(
                                  child: SvgPicture.asset(
                                    AssetConstants.callicon,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                        Dimens.boxHeight10,
                      ],
                    ),
                  ),
                  Dimens.boxHeight20,
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.ic_user_des,
                    ),
                    title: Text(
                      'description'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller.getOneGroupData?.description ?? "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  if (controller.getOneGroupData?.latestmedias?.isNotEmpty ??
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
                          InkWell(
                            onTap: () {
                              RouteManagement.goToSharedMediascreen(
                                  controller.getOneGroupData?.id ?? "",
                                  false,
                                  controller.getOneGroupData?.name ?? "",
                                  true);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "see_all".tr,
                                style: Styles.main50012,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Dimens.boxHeight10,
                    Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: SizedBox(
                        height: Dimens.eighty,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.businessMediaList.length,
                          itemBuilder: ((context, index) {
                            var item = controller.businessMediaList[index];
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
                                    child: item.isVideo ?? false
                                        ? Stack(
                                            children: [
                                              ThumbNailImageFullpage(
                                                url: (item.url ?? ""),
                                              ),
                                              Center(
                                                child: SvgPicture.asset(
                                                  AssetConstants.ic_video_play,
                                                ),
                                              ),
                                            ],
                                          )
                                        : CachedNetworkImage(
                                            imageUrl: ApiWrapper.imageUrl +
                                                (item.url ?? ""),
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                AssetConstants.placeholder,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                AssetConstants.placeholder,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                  )),
                            );
                          }),
                        ),
                      ),
                    ),
                  ],
                  Dimens.boxHeight20,
                  Divider(
                    height: Dimens.one,
                    color: ColorsValue.textfildbackcolor,
                  ),
                  if (!Get.find<Repository>()
                      .getBoolValue(LocalKeys.isSubUser)) ...[
                    // ListTile(
                    //   onTap: () {
                    //     Get.dialog(
                    //         StatefulBuilder(builder: (context, setState) {
                    //       return Padding(
                    //         padding: Dimens.edgeInsets20_0_20_0,
                    //         child: Column(
                    //           mainAxisAlignment: MainAxisAlignment.center,
                    //           mainAxisSize: MainAxisSize.min,
                    //           children: [
                    //             Container(
                    //               padding: Dimens.edgeInsets20,
                    //               decoration: BoxDecoration(
                    //                 color: ColorsValue.white,
                    //                 borderRadius:
                    //                     BorderRadius.circular(Dimens.fifteen),
                    //               ),
                    //               child: Material(
                    //                 color: Colors.transparent,
                    //                 child: Column(
                    //                   children: [
                    //                     Row(
                    //                       mainAxisAlignment:
                    //                           MainAxisAlignment.spaceBetween,
                    //                       children: [
                    //                         Text(
                    //                           'access_permission'.tr,
                    //                           style: Styles.black70016,
                    //                         ),
                    //                         SizedBox(
                    //                           height: Dimens.fifteen,
                    //                           width: Dimens.fifteen,
                    //                           child: InkWell(
                    //                             onTap: () {
                    //                               Get.back();
                    //                               controller
                    //                                   .groupSetPermission();
                    //                             },
                    //                             child: SvgPicture.asset(
                    //                               AssetConstants.cancleicon,
                    //                             ),
                    //                           ),
                    //                         ),
                    //                       ],
                    //                     ),
                    //                     Dimens.boxHeight10,
                    //                     ListTile(
                    //                       contentPadding: Dimens.edgeInsets0,
                    //                       title: Text(
                    //                         'fullname'.tr,
                    //                         style: Styles.black50014,
                    //                       ),
                    //                       leading: SvgPicture.asset(
                    //                           AssetConstants.fullnameicon),
                    //                       trailing: Transform.scale(
                    //                         scale: 0.8,
                    //                         child: CupertinoSwitch(
                    //                           value: controller.groupPermission
                    //                                   .fullname ??
                    //                               false,
                    //                           activeColor:
                    //                               ColorsValue.maincolor1,
                    //                           onChanged: (value) {
                    //                             controller.groupPermission
                    //                                 .fullname = value;
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     ListTile(
                    //                       contentPadding: Dimens.edgeInsets0,
                    //                       title: Text(
                    //                         'phone_number'.tr,
                    //                         style: Styles.black50014,
                    //                       ),
                    //                       leading: SvgPicture.asset(
                    //                           AssetConstants.callicon),
                    //                       trailing: Transform.scale(
                    //                         scale: 0.8,
                    //                         child: CupertinoSwitch(
                    //                           value: controller
                    //                                   .groupPermission.mobile ??
                    //                               false,
                    //                           activeColor:
                    //                               ColorsValue.maincolor1,
                    //                           onChanged: (value) {
                    //                             controller.groupPermission
                    //                                 .mobile = value;
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     ListTile(
                    //                       contentPadding: Dimens.edgeInsets0,
                    //                       title: Text(
                    //                         'email'.tr,
                    //                         style: Styles.black50014,
                    //                       ),
                    //                       leading: SvgPicture.asset(
                    //                           AssetConstants.smsicon),
                    //                       trailing: Transform.scale(
                    //                         scale: 0.8,
                    //                         child: CupertinoSwitch(
                    //                           value: controller
                    //                                   .groupPermission.email ??
                    //                               false,
                    //                           activeColor:
                    //                               ColorsValue.maincolor1,
                    //                           onChanged: (value) {
                    //                             controller.groupPermission
                    //                                 .email = value;
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     ListTile(
                    //                       contentPadding: Dimens.edgeInsets0,
                    //                       title: Text(
                    //                         'social_media'.tr,
                    //                         style: Styles.black50014,
                    //                       ),
                    //                       leading: SvgPicture.asset(
                    //                           AssetConstants.socialmediaicon),
                    //                       trailing: Transform.scale(
                    //                         scale: 0.8,
                    //                         child: CupertinoSwitch(
                    //                           value: controller.groupPermission
                    //                                   .socialmedia ??
                    //                               false,
                    //                           activeColor:
                    //                               ColorsValue.maincolor1,
                    //                           onChanged: (value) {
                    //                             controller.groupPermission
                    //                                 .socialmedia = value;
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     ListTile(
                    //                       contentPadding: Dimens.edgeInsets0,
                    //                       title: Text(
                    //                         'mute_notification'.tr,
                    //                         style: Styles.black50014,
                    //                       ),
                    //                       leading: SvgPicture.asset(
                    //                           AssetConstants.ic_mute_noti),
                    //                       trailing: Transform.scale(
                    //                         scale: 0.8,
                    //                         child: CupertinoSwitch(
                    //                           value: controller
                    //                                   .groupPermission.ismute ??
                    //                               false,
                    //                           activeColor:
                    //                               ColorsValue.maincolor1,
                    //                           onChanged: (value) {
                    //                             controller.groupPermission
                    //                                 .ismute = value;
                    //                             setState(() {});
                    //                           },
                    //                         ),
                    //                       ),
                    //                     ),
                    //                     Dimens.boxHeight10,
                    //                   ],
                    //                 ),
                    //               ),
                    //             ),
                    //           ],
                    //         ),
                    //       );
                    //     }));
                    //   },
                    //   leading: SvgPicture.asset(
                    //     AssetConstants.ic_user_permission,
                    //   ),
                    //   title: Text(
                    //     'access_permission'.tr,
                    //     style: Styles.black50016,
                    //   ),
                    //   trailing: SvgPicture.asset(
                    //     AssetConstants.ic_right_arrow,
                    //     height: Dimens.twenty,
                    //     width: Dimens.ten,
                    //   ),
                    // ),
                    // Divider(
                    //   height: Dimens.one,
                    //   color: ColorsValue.textfildbackcolor,
                    // ),
                    ListTile(
                      onTap: () {
                        RouteManagement.goToGroupFavoriteMessageScreen();
                      },
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      leading: SvgPicture.asset(
                        AssetConstants.staricon,
                      ),
                      title: Text(
                        'favorite_message'.tr,
                        style: Styles.black50016,
                      ),
                      trailing: SvgPicture.asset(
                        AssetConstants.ic_right_arrow,
                        height: Dimens.twenty,
                        width: Dimens.ten,
                      ),
                    ),
                    Divider(
                      height: Dimens.one,
                      color: ColorsValue.textfildbackcolor,
                    ),
                  ],
                  Dimens.boxHeight20,
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${controller.getOneGroupData?.members?.length ?? 0} Peoples",
                          style: Styles.greyColor888850014,
                        ),
                        if (!Get.find<Repository>()
                            .getBoolValue(LocalKeys.isSubUser)) ...[
                          Visibility(
                            visible: (controller
                                            .getOneGroupData
                                            ?.members?[controller.index]
                                            .permissions
                                            ?.isadmin ??
                                        false) ||
                                    (controller
                                            .getOneGroupData
                                            ?.members?[controller.index]
                                            .permissions
                                            ?.ismanager ??
                                        false)
                                ? true
                                : false,
                            child: InkWell(
                              onTap: () {
                                RouteManagement.goToCreateGroupScreen(true);
                              },
                              child: Container(
                                height: Dimens.thirtyTwo,
                                width: Dimens.thirtyTwo,
                                padding: Dimens.edgeInsets5,
                                decoration: BoxDecoration(
                                  color:
                                      ColorsValue.maincolor1.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(
                                    Dimens.four,
                                  ),
                                ),
                                child: SvgPicture.asset(
                                  AssetConstants.adduserBroadcast,
                                ),
                              ),
                            ),
                          )
                        ],
                      ],
                    ),
                  ),
                  Dimens.boxHeight20,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        (controller.getOneGroupData?.members?.length ?? 0) < 5
                            ? controller.getOneGroupData?.members?.length ?? 0
                            : 5,
                    itemBuilder: ((context, index) {
                      var item = controller.getOneGroupData?.members?[index];
                      var userLoginIndex =
                          controller.getOneGroupData?.members?.indexWhere(
                        (element) =>
                            element.userid!.id ==
                            Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds),
                      );
                      return InkWell(
                        onTap: item!.userid!.id ==
                                    Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ||
                                (Get.find<Repository>()
                                    .getBoolValue(LocalKeys.isSubUser))
                            ? () {}
                            : (controller
                                            .getOneGroupData
                                            ?.members?[userLoginIndex!]
                                            .permissions
                                            ?.isadmin ??
                                        false) ||
                                    (controller
                                            .getOneGroupData
                                            ?.members?[userLoginIndex!]
                                            .permissions
                                            ?.ismanager ??
                                        false)
                                ? () {
                                    showDialog(
                                      barrierDismissible: true,
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          child: Container(
                                            padding: Dimens.edgeInsets20,
                                            decoration: BoxDecoration(
                                              color: ColorsValue.white,
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.fifteen),
                                            ),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Visibility(
                                                  visible:
                                                      item.userid?.isfriend ==
                                                              "yes"
                                                          ? false
                                                          : true,
                                                  child: Text(
                                                    "chat_message".tr,
                                                    style: Styles
                                                        .greyColor888850016,
                                                  ),
                                                ),
                                                Dimens.boxHeight10,
                                                item.permissions!.ismanager ||
                                                        item.permissions!
                                                            .isadmin
                                                    ? InkWell(
                                                        onTap: () {
                                                          Get.back();
                                                          controller
                                                              .groupUnSetManager(
                                                                  item.userid!
                                                                      .id,
                                                                  index);
                                                          controller.update();
                                                        },
                                                        child: Text(
                                                          "remove_manager".tr,
                                                          style: Styles
                                                              .redcolor50016,
                                                        ),
                                                      )
                                                    : InkWell(
                                                        onTap: () {
                                                          controller
                                                              .groupSetManager(
                                                                  item.userid!
                                                                      .id,
                                                                  index);
                                                          controller.update();
                                                        },
                                                        child: Text(
                                                          "make_a_manager".tr,
                                                          style: Styles
                                                              .greyColor888850016,
                                                        ),
                                                      ),
                                                Dimens.boxHeight10,
                                                InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                    controller
                                                        .removeMemberGroup(
                                                            item.userid?.id ??
                                                                "");
                                                    controller.update();
                                                  },
                                                  child: Text(
                                                    "remove_member".tr,
                                                    style: Styles.redcolor50016,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  }
                                : null,
                        child: Padding(
                          padding: Dimens.edgeInsets0_5_0_5,
                          child: ListTile(
                            contentPadding: Dimens.edgeInsets15_0_15_0,
                            isThreeLine: true,
                            dense: true,
                            leading: Stack(
                              children: [
                                Container(
                                  height: Dimens.fourtyFive,
                                  width: Dimens.fourtyFive,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.maincolor1,
                                  ),
                                  child: ClipRRect(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.hundred),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          (item.userid?.profileimage ?? ""),
                                      fit: BoxFit.cover,
                                      maxHeightDiskCache: 90,
                                      maxWidthDiskCache: 90,
                                      width: Dimens.fourtyFive,
                                      height: Dimens.fourtyFive,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        width: Dimens.fourtyFive,
                                        height: Dimens.fourtyFive,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        width: Dimens.fourtyFive,
                                        height: Dimens.fourtyFive,
                                      ),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (item.permissions?.isadmin ??
                                              false) ||
                                          (item.permissions?.ismanager ?? false)
                                      ? true
                                      : false,
                                  child: Positioned(
                                    bottom: 0,
                                    right: 0,
                                    child: Container(
                                      height: Dimens.eighteen,
                                      width: Dimens.eighteen,
                                      decoration: BoxDecoration(
                                        color: (item.permissions?.ismanager ??
                                                false)
                                            ? ColorsValue.white
                                            : ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.fifty,
                                        ),
                                        border: Border.all(
                                          width: Dimens.one,
                                          color: (item.permissions?.ismanager ??
                                                  false)
                                              ? ColorsValue.maincolor1
                                              : ColorsValue.white,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets3,
                                        child: SvgPicture.asset(
                                          (item.permissions?.isadmin ?? false)
                                              ? AssetConstants.ic_outline_star
                                              : AssetConstants
                                                  .ic_outline_rising_star,
                                          colorFilter: ColorFilter.mode(
                                            (item.permissions?.ismanager ??
                                                    false)
                                                ? ColorsValue.maincolor1
                                                : ColorsValue.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            title: Text(
                              item.userid?.nickname ?? "",
                              style: Styles.black50016,
                            ),
                            subtitle: Text(
                              item.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds)
                                  ? "${item.userid?.countryCode ?? ""} ${item.userid?.mobile ?? ""} (You)"
                                  : "${item.userid?.countryCode ?? ""} ${item.userid?.mobile ?? ""}",
                              style: Styles.greyColor888840012,
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                item.userid?.isfriend == 'yes'
                                    ? GestureDetector(
                                        onTap: () {
                                          RouteManagement
                                              .gooffAndToNamedChatScreen(
                                                  item.userid?.id ?? "",false);
                                        },
                                        child: Container(
                                          height: Dimens.thirty,
                                          width: Dimens.thirty,
                                          decoration: BoxDecoration(
                                            color: ColorsValue.maincolor1,
                                            borderRadius: BorderRadius.circular(
                                              Dimens.three,
                                            ),
                                          ),
                                          child: Padding(
                                            padding: Dimens.edgeInsets6,
                                            child: SvgPicture.asset(
                                              AssetConstants.selectedchaticon,
                                              colorFilter: ColorFilter.mode(
                                                ColorsValue.white,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    : item.userid?.isfriend == 'sent'
                                        ? InkWell(
                                            onTap: () {
                                              controller.cancelSentRequest(
                                                  item.userid
                                                          ?.friendrequestid ??
                                                      "",
                                                  index);
                                            },
                                            child: Container(
                                              height: Dimens.thirty,
                                              width: Dimens.thirty,
                                              decoration: BoxDecoration(
                                                color:
                                                    ColorsValue.greyColor8888,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimens.three,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: Dimens.edgeInsets6,
                                                child: Image.asset(
                                                  AssetConstants.ic_user_remove,
                                                ),
                                              ),
                                            ),
                                          )
                                        : item.userid?.isfriend == 'no'
                                            ? InkWell(
                                                onTap: () {
                                                  controller.sentRequestDialog(
                                                      item, index);
                                                },
                                                child: Container(
                                                  height: Dimens.thirty,
                                                  width: Dimens.thirty,
                                                  decoration: BoxDecoration(
                                                      color: ColorsValue
                                                          .maincolor1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.three)),
                                                  child: Padding(
                                                    padding: Dimens.edgeInsets6,
                                                    child: Image.asset(
                                                      AssetConstants
                                                          .ic_user_add,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : item.userid?.isfriend == "blocked"
                                                ? InkWell(
                                                    onTap: () async {
                                                      await Get.dialog(
                                                        Padding(
                                                          padding: Dimens
                                                              .edgeInsetsTop20,
                                                          child: Material(
                                                            color: ColorsValue
                                                                .transparent,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Padding(
                                                                  padding: Dimens
                                                                      .edgeInsets20_0_20_0,
                                                                  child:
                                                                      Container(
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: ColorsValue
                                                                          .white,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              Dimens.fifteen),
                                                                    ),
                                                                    child:
                                                                        Padding(
                                                                      padding:
                                                                          Dimens
                                                                              .edgeInsets25_30_25_30,
                                                                      child:
                                                                          Column(
                                                                        children: [
                                                                          Align(
                                                                            alignment:
                                                                                Alignment.topRight,
                                                                            child: InkWell(
                                                                                onTap: () {
                                                                                  Get.back();
                                                                                },
                                                                                child: SvgPicture.asset(
                                                                                  AssetConstants.cancleicon,
                                                                                )),
                                                                          ),
                                                                          SvgPicture
                                                                              .asset(
                                                                            AssetConstants.canclepopupicon,
                                                                          ),
                                                                          Dimens
                                                                              .boxHeight18,
                                                                          Text(
                                                                            "unblock_request".tr,
                                                                            style:
                                                                                Styles.black70020,
                                                                          ),
                                                                          Dimens
                                                                              .boxHeight10,
                                                                          Text(
                                                                            "are_you_sure_unblock".tr,
                                                                            style:
                                                                                Styles.greyColor888840014,
                                                                          ),
                                                                          Dimens
                                                                              .boxHeight18,
                                                                          CustomBottomButton(
                                                                            firstbtnText:
                                                                                "cancle".tr.toUpperCase(),
                                                                            secondbtnTxt:
                                                                                "unblock".tr.toUpperCase(),
                                                                            firstStyle:
                                                                                Styles.greyColor888850014,
                                                                            secondStyle:
                                                                                Styles.white50014,
                                                                            bordercolor:
                                                                                ColorsValue.greyColor8888,
                                                                            buttoncolor:
                                                                                ColorsValue.redColor,
                                                                            firstOnPressed:
                                                                                () {
                                                                              Get.back();
                                                                            },
                                                                            secondOnPressed:
                                                                                () {
                                                                              Get.back();
                                                                              controller.updateFriendsRequest(item.userid?.friendrequestid ?? "", "unblocked", index);
                                                                            },
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                    child: Container(
                                                      height: Dimens.twentyFive,
                                                      width: Dimens.seventy,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                          Dimens.three,
                                                        ),
                                                        border: Border.all(
                                                          color: ColorsValue
                                                              .redColor,
                                                        ),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          'unblocked'.tr,
                                                          style: Styles
                                                              .redColor40010,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                : item.userid?.isfriend == ""
                                                    ? Container()
                                                    : Container(
                                                        height: Dimens.thirty,
                                                        width: Dimens.thirty,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorsValue
                                                              .maincolor1,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            Dimens.three,
                                                          ),
                                                        ),
                                                        child: PopupMenuButton(
                                                            padding: Dimens
                                                                .edgeInsets0,
                                                            shape: RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(Dimens
                                                                            .ten)),
                                                            icon: const Icon(
                                                              Icons.more_vert,
                                                              color: ColorsValue
                                                                  .white,
                                                            ),
                                                            itemBuilder:
                                                                (BuildContext
                                                                    context) {
                                                              return [
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                    'accept_request'
                                                                        .tr,
                                                                    style: Styles
                                                                        .black50014,
                                                                  ),
                                                                  onTap: () {
                                                                    Get.dialog(
                                                                      StatefulBuilder(
                                                                        builder:
                                                                            (context,
                                                                                setState) {
                                                                          return Material(
                                                                            color:
                                                                                ColorsValue.transparent,
                                                                            child:
                                                                                Column(
                                                                              mainAxisAlignment: MainAxisAlignment.center,
                                                                              children: [
                                                                                Expanded(
                                                                                  child: Padding(
                                                                                    padding: Dimens.edgeInsets20_0_20_0,
                                                                                    child: Container(
                                                                                      decoration: BoxDecoration(
                                                                                        color: ColorsValue.white,
                                                                                        borderRadius: BorderRadius.circular(Dimens.fifteen),
                                                                                      ),
                                                                                      child: Padding(
                                                                                        padding: Dimens.edgeInsets20,
                                                                                        child: Column(
                                                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                                          children: [
                                                                                            Align(
                                                                                              alignment: Alignment.topRight,
                                                                                              child: InkWell(
                                                                                                  onTap: () {
                                                                                                    Get.back();
                                                                                                  },
                                                                                                  child: SvgPicture.asset(
                                                                                                    AssetConstants.cancleicon,
                                                                                                  )),
                                                                                            ),
                                                                                            Center(
                                                                                              child: SvgPicture.asset(
                                                                                                AssetConstants.unhidepopupicon,
                                                                                              ),
                                                                                            ),
                                                                                            Dimens.boxHeight18,
                                                                                            Center(
                                                                                              child: Text(
                                                                                                "accept_request".tr,
                                                                                                style: Styles.black70020,
                                                                                              ),
                                                                                            ),
                                                                                            Dimens.boxHeight18,
                                                                                            CustomBottomButton(
                                                                                                firstbtnText: "cancle".tr.toUpperCase(),
                                                                                                secondbtnTxt: "accept".tr.toUpperCase(),
                                                                                                firstStyle: Styles.greyColor888850014,
                                                                                                secondStyle: Styles.white50014,
                                                                                                bordercolor: ColorsValue.greyColor8888,
                                                                                                firstOnPressed: () {
                                                                                                  Get.back();
                                                                                                },
                                                                                                secondOnPressed: () {
                                                                                                  Get.back();
                                                                                                  controller.respondFriendsRequest(item.userid?.friendrequestid ?? "", "accepted", index);
                                                                                                }),
                                                                                            Dimens.boxHeight18,
                                                                                            Text(
                                                                                              "Our profile settings for this person",
                                                                                              style: Styles.black50018,
                                                                                            ),
                                                                                            Expanded(
                                                                                              child: SingleChildScrollView(
                                                                                                child: Column(
                                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                  children: [
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'fullname'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.fullnameicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.fullname ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.fullname = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'phone_number'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.mobile ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.mobile = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'email'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.smsicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.email ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.email = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'date_of_birth'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.dobicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.dob ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.dob = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'gender'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.gendericon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.gender ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.gender = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'social_media'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.socialmediaicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.socialmedia ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.socialmedia = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'video_call'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.videoIcon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.videocall ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.videocall = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'audio_call'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.audiocall ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.audiocall = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                    ListTile(
                                                                                                      contentPadding: Dimens.edgeInsets0,
                                                                                                      title: Text(
                                                                                                        'mute_notification'.tr,
                                                                                                        style: Styles.black50014,
                                                                                                      ),
                                                                                                      subtitle: Text(
                                                                                                        'Caroline Case',
                                                                                                        style: Styles.greyColor888840014,
                                                                                                      ),
                                                                                                      leading: SvgPicture.asset(AssetConstants.ic_mute_noti),
                                                                                                      trailing: CupertinoSwitch(
                                                                                                        value: controller.authorizedPermissions.ismute ?? false,
                                                                                                        activeColor: ColorsValue.maincolor1,
                                                                                                        onChanged: (value) {
                                                                                                          controller.authorizedPermissions.ismute = value;
                                                                                                          controller.update();
                                                                                                        },
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          );
                                                                        },
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                    'rejectrequest'
                                                                        .tr,
                                                                    style: Styles
                                                                        .black50014,
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    await Get
                                                                        .dialog(
                                                                      Padding(
                                                                        padding:
                                                                            Dimens.edgeInsetsTop20,
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              ColorsValue.transparent,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: Dimens.edgeInsets20_0_20_0,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: ColorsValue.white,
                                                                                    borderRadius: BorderRadius.circular(Dimens.fifteen),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: Dimens.edgeInsets25_30_25_30,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Align(
                                                                                          alignment: Alignment.topRight,
                                                                                          child: InkWell(
                                                                                              onTap: () {
                                                                                                Get.back();
                                                                                              },
                                                                                              child: SvgPicture.asset(
                                                                                                AssetConstants.cancleicon,
                                                                                              )),
                                                                                        ),
                                                                                        SvgPicture.asset(
                                                                                          AssetConstants.canclepopupicon,
                                                                                        ),
                                                                                        Dimens.boxHeight18,
                                                                                        Text(
                                                                                          "rejectrequest".tr,
                                                                                          style: Styles.black70020,
                                                                                        ),
                                                                                        Dimens.boxHeight10,
                                                                                        Text(
                                                                                          "are_you_sure_reject".tr,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        Dimens.boxHeight18,
                                                                                        CustomBottomButton(
                                                                                            firstbtnText: "block".tr.toUpperCase(),
                                                                                            secondbtnTxt: "reject".tr.toUpperCase(),
                                                                                            firstStyle: Styles.redcolor50014,
                                                                                            secondStyle: Styles.white50014,
                                                                                            bordercolor: ColorsValue.redColor,
                                                                                            buttoncolor: ColorsValue.redColor,
                                                                                            firstOnPressed: () {
                                                                                              Get.back();
                                                                                            },
                                                                                            secondOnPressed: () {
                                                                                              Get.back();
                                                                                              controller.respondFriendsRequest(item.userid?.friendrequestid ?? "", "rejected", index);
                                                                                            })
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                                PopupMenuItem(
                                                                  child: Text(
                                                                    'block_request'
                                                                        .tr,
                                                                    style: Styles
                                                                        .redColor50014,
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    await Get
                                                                        .dialog(
                                                                      Padding(
                                                                        padding:
                                                                            Dimens.edgeInsetsTop20,
                                                                        child:
                                                                            Material(
                                                                          color:
                                                                              ColorsValue.transparent,
                                                                          child:
                                                                              Column(
                                                                            mainAxisAlignment:
                                                                                MainAxisAlignment.center,
                                                                            children: [
                                                                              Padding(
                                                                                padding: Dimens.edgeInsets20_0_20_0,
                                                                                child: Container(
                                                                                  decoration: BoxDecoration(
                                                                                    color: ColorsValue.white,
                                                                                    borderRadius: BorderRadius.circular(Dimens.fifteen),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: Dimens.edgeInsets25_30_25_30,
                                                                                    child: Column(
                                                                                      children: [
                                                                                        Align(
                                                                                          alignment: Alignment.topRight,
                                                                                          child: InkWell(
                                                                                              onTap: () {
                                                                                                Get.back();
                                                                                              },
                                                                                              child: SvgPicture.asset(
                                                                                                AssetConstants.cancleicon,
                                                                                              )),
                                                                                        ),
                                                                                        SvgPicture.asset(
                                                                                          AssetConstants.canclepopupicon,
                                                                                        ),
                                                                                        Dimens.boxHeight18,
                                                                                        Text(
                                                                                          "block_request".tr,
                                                                                          style: Styles.black70020,
                                                                                        ),
                                                                                        Dimens.boxHeight10,
                                                                                        Text(
                                                                                          "are_you_sure_block".tr,
                                                                                          style: Styles.greyColor888840014,
                                                                                        ),
                                                                                        Dimens.boxHeight18,
                                                                                        CustomBottomButton(
                                                                                          firstbtnText: "cancle".tr.toUpperCase(),
                                                                                          secondbtnTxt: "block".tr.toUpperCase(),
                                                                                          firstStyle: Styles.greyColor888850014,
                                                                                          secondStyle: Styles.white50014,
                                                                                          bordercolor: ColorsValue.greyColor8888,
                                                                                          buttoncolor: ColorsValue.redColor,
                                                                                          firstOnPressed: () {
                                                                                            Get.back();
                                                                                          },
                                                                                          secondOnPressed: () {
                                                                                            Get.back();
                                                                                            controller.respondFriendsRequest(item.userid?.friendrequestid ?? "", "blocked", index);
                                                                                          },
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ),
                                                                      ),
                                                                    );
                                                                  },
                                                                ),
                                                              ];
                                                            }),
                                                      ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                  if (!Get.find<Repository>()
                      .getBoolValue(LocalKeys.isSubUser)) ...[
                    Visibility(
                      visible:
                          (controller.getOneGroupData?.members?.length ?? 0) > 5
                              ? true
                              : false,
                      child: Padding(
                        padding: Dimens.edgeInsets20_0_20_0,
                        child: InkWell(
                          onTap: () {
                            if (controller.isShowAll) {
                              controller.isShowAll = false;
                            } else {
                              controller.isShowAll = true;
                            }
                            controller.update();
                          },
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(
                              controller.isShowAll
                                  ? "see_less".tr
                                  : 'see_all'.tr,
                              style: Styles.main50014,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Dimens.boxHeight20,
                    Divider(
                      height: Dimens.one,
                      color: ColorsValue.textfildbackcolor,
                    ),
                    ListTile(
                      onTap: () async {
                        await Get.dialog(
                          Padding(
                            padding: Dimens.edgeInsetsTop20,
                            child: Material(
                              color: ColorsValue.transparent,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: Dimens.edgeInsets20_0_20_0,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: ColorsValue.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimens.fifteen),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets25_30_25_30,
                                        child: Column(
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                  onTap: () {
                                                    Get.back();
                                                  },
                                                  child: SvgPicture.asset(
                                                    AssetConstants.cancleicon,
                                                  )),
                                            ),
                                            SvgPicture.asset(
                                              AssetConstants.deletIcon,
                                              height: Dimens.fifty,
                                              width: Dimens.fifty,
                                            ),
                                            Dimens.boxHeight18,
                                            Text(
                                              "clear_chats".tr,
                                              style: Styles.black70020,
                                            ),
                                            Dimens.boxHeight10,
                                            Text(
                                              "Are you sure you want to clear chats?",
                                              style: Styles.greyColor888840014,
                                            ),
                                            Dimens.boxHeight18,
                                            CustomBottomButton(
                                              firstbtnText:
                                                  "cancle".tr.toUpperCase(),
                                              secondbtnTxt: "clear_chats"
                                                  .tr
                                                  .toUpperCase(),
                                              firstStyle:
                                                  Styles.greyColor888850014,
                                              secondStyle: Styles.white50014,
                                              bordercolor:
                                                  ColorsValue.greyColor8888,
                                              buttoncolor: ColorsValue.redColor,
                                              firstOnPressed: () {
                                                Get.back();
                                              },
                                              secondOnPressed: () {
                                                Get.back();
                                                controller.postClearGroupChats(
                                                    controller.getOneGroupData
                                                            ?.id ??
                                                        "");
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      leading: SvgPicture.asset(
                        AssetConstants.deletIcon,
                        height: Dimens.twenty,
                        width: Dimens.twenty,
                      ),
                      title: Text(
                        'clear_chats'.tr,
                        style: Styles.redcolor50016,
                      ),
                    ),
                    Divider(
                      height: Dimens.one,
                      color: ColorsValue.textfildbackcolor,
                    ),
                    InkWell(
                      onTap: () {
                        controller.leaveGroup();
                      },
                      child: ListTile(
                        leading: SvgPicture.asset(
                          AssetConstants.ic_exit_group,
                        ),
                        title: Text(
                          "${"exit_from_friends_group".tr}${controller.getOneGroupData?.name}",
                          style: Styles.redcolor50016,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    // Divider(
                    //   height: Dimens.one,
                    //   color: ColorsValue.textfildbackcolor,
                    // ),
                    // ListTile(
                    //   leading: SvgPicture.asset(
                    //     AssetConstants.ic_report,
                    //   ),
                    //   title: Text(
                    //     'report_friends'.tr,
                    //     style: Styles.redcolor50016,
                    //   ),
                    // ),
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
