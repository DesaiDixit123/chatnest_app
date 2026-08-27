import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/api_wrapper.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ReceivedRequestScreen extends StatelessWidget {
  const ReceivedRequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.receivedPagingController.refresh(),
                  ),
                  color: ColorsValue.appColor,
                  child: PagedListView<int, ReceiveRequestDoc>(
                    pagingController: controller.receivedPagingController,
                    builderDelegate:
                        PagedChildBuilderDelegate<ReceiveRequestDoc>(
                            noItemsFoundIndicatorBuilder: (_) => Center(
                                  child: SvgPicture.asset(
                                    AssetConstants.ic_recive_request_empty,
                                  ),
                                ),
                            itemBuilder:
                                (BuildContext context, item, int index) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: Dimens.edgeInsets20_05_20_05,
                                    child: ListTile(
                                      contentPadding: Dimens.edgeInsets0,
                                      isThreeLine: true,
                                      leading: Container(
                                        height: Dimens.fifty,
                                        width: Dimens.fifty,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          color: ColorsValue.maincolor1,
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.hundred),
                                          child: ApiWrapper.isValidImageUrl(
                                                  item.senderid.profileimage)
                                              ? CachedNetworkImage(
                                                  imageUrl:
                                                      ApiWrapper.imageUrl +
                                                          item.senderid
                                                              .profileimage,
                                                  fit: BoxFit.cover,
                                                  maxHeightDiskCache: 90,
                                                  maxWidthDiskCache: 90,
                                                  width: Dimens.fifty,
                                                  height: Dimens.fifty,
                                                  placeholder: (context,
                                                          url) =>
                                                      Image.asset(
                                                    AssetConstants.usera,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      Image.asset(
                                                    AssetConstants.usera,
                                                    fit: BoxFit.cover,
                                                  ),
                                                )
                                              : Image.asset(
                                                  AssetConstants.usera,
                                                  fit: BoxFit.cover,
                                                  width: Dimens.fifty,
                                                  height: Dimens.fifty,
                                                ),
                                        ),
                                      ),
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            item.senderid.fullname,
                                            style: Styles.black50016,
                                          ),
                                          Text(
                                            Utility.getTimeStempToDate(
                                                    item.timestamp)
                                                .toString(),
                                            style: Styles.greyColor888840012,
                                          ),
                                        ],
                                      ),
                                      subtitle: Text(
                                        item.lastchatmessage?.message
                                                    ?.contentType ==
                                                "photo"
                                            ? "📷 Photo"
                                            : item.lastchatmessage?.message
                                                        ?.contentType ==
                                                    "video"
                                                ? "🎥 Video"
                                                : item.lastchatmessage?.message
                                                            ?.contentType ==
                                                        "statusreply"
                                                    ? "💬 Status Reply: ${item.lastchatmessage?.message?.content.text!.message}"
                                                    : item
                                                                .lastchatmessage
                                                                ?.message
                                                                ?.contentType ==
                                                            "audiocall"
                                                        ? "📞 Audio Call"
                                                        : item
                                                                    .lastchatmessage
                                                                    ?.message
                                                                    ?.contentType ==
                                                                "videocall"
                                                            ? "📹 Video Call"
                                                            : item
                                                                    .lastchatmessage
                                                                    ?.message
                                                                    ?.content
                                                                    .text!
                                                                    .message ??
                                                                "",
                                        style: Styles.greyColor888840014,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: Dimens.edgeInsets20_0_20_0,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await Get.dialog(
                                                Padding(
                                                  padding:
                                                      Dimens.edgeInsetsTop20,
                                                  child: Material(
                                                    color:
                                                        ColorsValue.transparent,
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
                                                                color:
                                                                    ColorsValue
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            Dimens.fifteen),
                                                              ),
                                                              child: Padding(
                                                                padding: Dimens
                                                                    .edgeInsets25_30_25_30,
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
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
                                                                      AssetConstants
                                                                          .canclepopupicon,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight18,
                                                                    Text(
                                                                      "block_request"
                                                                          .tr,
                                                                      style: Styles
                                                                          .black70020,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight10,
                                                                    Text(
                                                                      "are_you_sure_block"
                                                                          .tr,
                                                                      style: Styles
                                                                          .greyColor888840014,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight18,
                                                                    CustomBottomButton(
                                                                      firstbtnText:
                                                                          "cancle"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                      secondbtnTxt:
                                                                          "block"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                      firstStyle:
                                                                          Styles
                                                                              .greyColor888850014,
                                                                      secondStyle:
                                                                          Styles
                                                                              .white50014,
                                                                      bordercolor:
                                                                          ColorsValue
                                                                              .greyColor8888,
                                                                      buttoncolor:
                                                                          ColorsValue
                                                                              .redColor,
                                                                      firstOnPressed:
                                                                          () {
                                                                        Get.back();
                                                                      },
                                                                      secondOnPressed:
                                                                          () {
                                                                        Get.back();
                                                                        controller.respondFriendsRequest(
                                                                            item.id,
                                                                            "blocked");
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
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: Dimens.thirty,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.five),
                                                border: Border.all(
                                                  color: ColorsValue.redColor,
                                                  width: Dimens.one,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "block".tr.toUpperCase(),
                                                  style: Styles.redcolor50012,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Dimens.boxWidth15,
                                        Expanded(
                                          child: InkWell(
                                            onTap: () async {
                                              await Get.dialog(
                                                Padding(
                                                  padding:
                                                      Dimens.edgeInsetsTop20,
                                                  child: Material(
                                                    color:
                                                        ColorsValue.transparent,
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
                                                                color:
                                                                    ColorsValue
                                                                        .white,
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            Dimens.fifteen),
                                                              ),
                                                              child: Padding(
                                                                padding: Dimens
                                                                    .edgeInsets25_30_25_30,
                                                                child: Column(
                                                                  children: [
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topRight,
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
                                                                      AssetConstants
                                                                          .canclepopupicon,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight18,
                                                                    Text(
                                                                      "rejectrequest"
                                                                          .tr,
                                                                      style: Styles
                                                                          .black70020,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight10,
                                                                    Text(
                                                                      "are_you_sure_reject"
                                                                          .tr,
                                                                      style: Styles
                                                                          .greyColor888840014,
                                                                    ),
                                                                    Dimens
                                                                        .boxHeight18,
                                                                    CustomBottomButton(
                                                                        firstbtnText: "block"
                                                                            .tr
                                                                            .toUpperCase(),
                                                                        secondbtnTxt: "reject"
                                                                            .tr
                                                                            .toUpperCase(),
                                                                        firstStyle:
                                                                            Styles
                                                                                .redcolor50014,
                                                                        secondStyle:
                                                                            Styles
                                                                                .white50014,
                                                                        bordercolor:
                                                                            ColorsValue
                                                                                .redColor,
                                                                        buttoncolor:
                                                                            ColorsValue
                                                                                .redColor,
                                                                        firstOnPressed:
                                                                            () {
                                                                          Get.back();
                                                                        },
                                                                        secondOnPressed:
                                                                            () {
                                                                          Get.back();
                                                                          controller.respondFriendsRequest(
                                                                              item.id,
                                                                              "rejected");
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
                                                ),
                                              );
                                            },
                                            child: Container(
                                              height: Dimens.thirty,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.five),
                                                border: Border.all(
                                                  color: ColorsValue.redColor,
                                                  width: Dimens.one,
                                                ),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "reject".tr.toUpperCase(),
                                                  style: Styles.redcolor50012,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Dimens.boxWidth15,
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Get.dialog(
                                                StatefulBuilder(
                                                  builder: (context, setState) {
                                                    return Material(
                                                      color: ColorsValue
                                                          .transparent,
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .stretch,
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Expanded(
                                                            child: Padding(
                                                              padding: Dimens
                                                                  .edgeInsets20_0_20_0,
                                                              child: Container(
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color:
                                                                      ColorsValue
                                                                          .white,
                                                                  borderRadius:
                                                                      BorderRadius.circular(
                                                                          Dimens
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
                                                                      Center(
                                                                        child: SvgPicture
                                                                            .asset(
                                                                          AssetConstants
                                                                              .unhidepopupicon,
                                                                        ),
                                                                      ),
                                                                      Dimens
                                                                          .boxHeight18,
                                                                      Center(
                                                                        child:
                                                                            Text(
                                                                          "accept_request"
                                                                              .tr,
                                                                          style:
                                                                              Styles.black70020,
                                                                        ),
                                                                      ),
                                                                      Dimens
                                                                          .boxHeight18,
                                                                      CustomBottomButton(
                                                                          firstbtnText: "cancle"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                          secondbtnTxt: "accept"
                                                                              .tr
                                                                              .toUpperCase(),
                                                                          firstStyle: Styles
                                                                              .greyColor888850014,
                                                                          secondStyle: Styles
                                                                              .white50014,
                                                                          bordercolor: ColorsValue
                                                                              .greyColor8888,
                                                                          firstOnPressed:
                                                                              () {
                                                                            Get.back();
                                                                          },
                                                                          secondOnPressed:
                                                                              () {
                                                                            Get.back();
                                                                            controller.respondFriendsRequest(item.id,
                                                                                "accepted");
                                                                          }),
                                                                      Dimens
                                                                          .boxHeight18,
                                                                      Text(
                                                                        "Our profile settings for this person",
                                                                        style: Styles
                                                                            .black50018,
                                                                      ),
                                                                      Expanded(
                                                                        child:
                                                                            SingleChildScrollView(
                                                                          child:
                                                                              Column(
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              ListTile(
                                                                                contentPadding: Dimens.edgeInsets0,
                                                                                title: Text(
                                                                                  'fullname'.tr,
                                                                                  style: Styles.black50014,
                                                                                ),
                                                                                subtitle: Text(
                                                                                  Utility.profileData?.fullname ?? " -- ",
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.fullnameicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.fullname ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.fullname = value;
                                                                                    setState(() {});
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
                                                                                  Utility.profileData?.mobile ?? " -- ",
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.mobile ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.mobile = value;
                                                                                    setState(() {});
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
                                                                                  Utility.profileData?.email ?? " -- ",
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.smsicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.email ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.email = value;
                                                                                    setState(() {});
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
                                                                                  Utility.profileData?.dob ?? " -- ",
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.dobicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.dob ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.dob = value;
                                                                                    setState(() {});
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
                                                                                  Utility.profileData?.gender ?? " -- ",
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.gendericon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.gender ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.gender = value;
                                                                                    setState(() {});
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
                                                                                  'privacy_security'.tr,
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.socialmediaicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.socialmedia ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.socialmedia = value;
                                                                                    setState(() {});
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
                                                                                  'privacy_security'.tr,
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(
                                                                                  AssetConstants.videoIcon,
                                                                                  colorFilter: ColorFilter.mode(
                                                                                    ColorsValue.maincolor1,
                                                                                    BlendMode.srcIn,
                                                                                  ),
                                                                                ),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.videocall ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.videocall = value;
                                                                                    setState(() {});
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
                                                                                  'privacy_security'.tr,
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.callicon),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.audiocall ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.audiocall = value;
                                                                                    setState(() {});
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
                                                                                  'privacy_security'.tr,
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                leading: SvgPicture.asset(AssetConstants.ic_mute_noti),
                                                                                trailing: CupertinoSwitch(
                                                                                  value: controller.authorizedPermissions.ismute ?? false,
                                                                                  activeColor: ColorsValue.maincolor1,
                                                                                  onChanged: (value) {
                                                                                    controller.authorizedPermissions.ismute = value;
                                                                                    setState(() {});
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
                                            child: Container(
                                              height: Dimens.thirty,
                                              decoration: BoxDecoration(
                                                color: ColorsValue.maincolor1,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        Dimens.five),
                                              ),
                                              child: Center(
                                                child: Text(
                                                  "accept".tr.toUpperCase(),
                                                  style: Styles.white50012,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Dimens.boxHeight10,
                                  Divider(
                                    height: Dimens.ten,
                                    color: ColorsValue.textfildbackcolor,
                                  )
                                ],
                              );
                            }),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
