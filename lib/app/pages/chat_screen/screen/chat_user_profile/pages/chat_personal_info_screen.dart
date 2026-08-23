import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/repositories/repositories.dart';
import 'package:chatnest/domain/repositories/repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChatPersonalInfoScreen extends StatelessWidget {
  const ChatPersonalInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return Padding(
        padding: Dimens.edgeInsets20,
        child: SingleChildScrollView(
          child: Column(
            children: [
              if (controller.getOneFriendsData?.latestmedias?.isNotEmpty ??
                  false) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "shared_media".tr,
                      style: Styles.black50014,
                    ),
                    InkWell(
                      onTap: () {
                        RouteManagement.goToSharedMediascreen(
                            controller.getOneFriendsData?.userid ?? "",
                            false,
                            controller.getOneFriendsData?.fullname?.isEmpty ??
                                    false
                                ? controller.getOneFriendsData?.nickname ?? ""
                                : controller.getOneFriendsData?.fullname ?? "",
                            false);
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
                Dimens.boxHeight10,
                SizedBox(
                  height: Dimens.eighty,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.shredMediaList.length,
                    itemBuilder: ((context, index) {
                      var item = controller.shredMediaList[index];
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
                                    imageUrl:
                                        ApiWrapper.imageUrl + (item.url ?? ""),
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
                          ),
                        ),
                      );
                    }),
                  ),
                ),
              ],
              Dimens.boxHeight10,
              ListTile(
                contentPadding: Dimens.edgeInsets0,
                isThreeLine: true,
                dense: true,
                leading: SvgPicture.asset(
                  AssetConstants.usericon,
                ),
                title: Text(
                  'aboutme'.tr,
                  style: Styles.black50014,
                ),
                subtitle: Text(
                  controller.getOneFriendsData?.aboutme ?? " - ",
                  overflow: TextOverflow.clip,
                  softWrap: true,
                  style: Styles.greyColor888840014,
                ),
              ),
              if (controller.getOneFriendsData?.usersPermissions?.dob ??
                  false) ...[
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.dobicon,
                  ),
                  title: Text(
                    'date_of_birth'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: Text(
                    controller.getOneFriendsData?.dob?.isNotEmpty ?? false
                        ? controller.getOneFriendsData?.dob ?? " - "
                        : " -- ",
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                ),
              ],
              if (controller.getOneFriendsData?.usersPermissions?.gender ??
                  false) ...[
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.gendericon,
                  ),
                  title: Text(
                    'gender'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: Text(
                    controller.getOneFriendsData?.gender?.isNotEmpty ?? false
                        ? controller.getOneFriendsData?.gender ?? " - "
                        : " -- ",
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                ),
              ],
              Visibility(
                visible:
                    controller.getOneFriendsData?.hobbies?.isNotEmpty ?? false
                        ? true
                        : false,
                child: ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.hobbies,
                  ),
                  title: Text(
                    'hobbies'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: controller.getOneFriendsData?.hobbies?.isNotEmpty ??
                          false
                      ? Padding(
                          padding: Dimens.edgeInsetsTopt05,
                          child: Wrap(
                            children:
                                controller.getOneFriendsData!.hobbies!.map((e) {
                              return Padding(
                                padding: Dimens.edgeInsetsRight10,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Container(
                                      padding: Dimens.edgeInsets11_5_11_5,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.hundred,
                                        ),
                                        color: ColorsValue.textfildbackcolor,
                                      ),
                                      child: Center(
                                        child: Text(
                                          e,
                                          style: Styles.greyColor888840014,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }).toList(),
                          ),
                        )
                      : Text(""),
                ),
              ),
              if (controller.getOneFriendsData?.usersPermissions?.email ??
                  false) ...[
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.smsicon,
                  ),
                  title: Text(
                    'email'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: Text(
                    controller.getOneFriendsData?.email?.isNotEmpty ?? false
                        ? controller.getOneFriendsData?.email ?? " - "
                        : " -- ",
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                ),
              ],
              if (controller.getOneFriendsData?.usersPermissions?.mobile ??
                  false) ...[
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.callicon,
                  ),
                  title: Text(
                    'phone_number'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: Text(
                    controller.getOneFriendsData?.mobile?.isNotEmpty ?? false
                        ? controller.getOneFriendsData?.mobile ?? " - "
                        : " -- ",
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                ),
              ],
              if (controller.locationText != "") ...[
                ListTile(
                  contentPadding: Dimens.edgeInsets0,
                  isThreeLine: true,
                  dense: true,
                  leading: SvgPicture.asset(
                    AssetConstants.locationicon,
                  ),
                  title: Text(
                    'location'.tr,
                    style: Styles.black50014,
                  ),
                  subtitle: Text(
                    controller.locationText.isNotEmpty
                        ? controller.locationText
                        : " -- ",
                    overflow: TextOverflow.clip,
                    softWrap: true,
                    style: Styles.greyColor888840014,
                  ),
                ),
              ],
              if (!Get.find<Repository>()
                  .getBoolValue(LocalKeys.isSubUser)) ...[
                Divider(
                  height: Dimens.one,
                  color: ColorsValue.textfildbackcolor,
                ),
                ListTile(
                  onTap: () {
                    RouteManagement.goToChatUserBookmarkScreen(
                        controller.getOneFriendsData?.userid ?? "");
                  },
                  contentPadding: Dimens.edgeInsets0,
                  leading: SvgPicture.asset(
                    AssetConstants.bookMarkIcon,
                    colorFilter: ColorFilter.mode(
                      ColorsValue.appColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: Text(
                    'bookmark_message'.tr,
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
                ListTile(
                  onTap: () {
                    RouteManagement.goToFavoriteMessageScreen();
                  },
                  contentPadding: Dimens.edgeInsets0,
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
                ListTile(
                  onTap: () {
                    Get.dialog(
                      StatefulBuilder(
                        builder: (context, setState) {
                          return Material(
                            color: ColorsValue.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: Dimens.edgeInsets20_0_20_0,
                                  child: Container(
                                      padding: Dimens.edgeInsets20,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.white,
                                        borderRadius: BorderRadius.circular(
                                            Dimens.fifteen),
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "authorized_permission".tr,
                                                style: Styles.black50018,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: SvgPicture.asset(
                                                    AssetConstants.cancleicon),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'fullname'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  Utility.profileData
                                                          ?.fullname ??
                                                      " - ",
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants
                                                        .fullnameicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .fullname ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller
                                                          .authorizedPermissions
                                                          .fullname = value;
                                                    });
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'phone_number'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  Utility.profileData?.mobile ??
                                                      " - ",
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants.callicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .mobile ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .mobile = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'email'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  Utility.profileData?.email ??
                                                      " - ",
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants.smsicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .email ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .email = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'date_of_birth'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  Utility.profileData?.dob ??
                                                      " - ",
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants.dobicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .dob ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .dob = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'gender'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  Utility.profileData?.gender ??
                                                      " - ",
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants.gendericon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .gender ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .gender = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'social_media'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  'privacy_security'.tr,
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants
                                                        .socialmediaicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .socialmedia ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .socialmedia = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'video_call'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  'privacy_security'.tr,
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                  AssetConstants.videoIcon,
                                                  colorFilter: ColorFilter.mode(
                                                    ColorsValue.maincolor1,
                                                    BlendMode.srcIn,
                                                  ),
                                                ),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .videocall ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .videocall = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              ListTile(
                                                contentPadding:
                                                    Dimens.edgeInsets0,
                                                title: Text(
                                                  'audio_call'.tr,
                                                  style: Styles.black50014,
                                                ),
                                                subtitle: Text(
                                                  'privacy_security'.tr,
                                                  style:
                                                      Styles.greyColor888840014,
                                                ),
                                                leading: SvgPicture.asset(
                                                    AssetConstants.callicon),
                                                trailing: CupertinoSwitch(
                                                  value: controller
                                                          .authorizedPermissions
                                                          .audiocall ??
                                                      false,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  onChanged: (value) {
                                                    controller
                                                        .authorizedPermissions
                                                        .audiocall = value;
                                                    setState(() {});
                                                  },
                                                ),
                                              ),
                                              CustomButton(
                                                height: Dimens.fourtyFive,
                                                text: 'save'.tr,
                                                onTap: () {
                                                  Get.back();
                                                  controller.updateFriendsRequest(
                                                      controller
                                                              .getOneFriendsData
                                                              ?.friendrequestid ??
                                                          "",
                                                      "");
                                                },
                                              ),
                                            ],
                                          )
                                        ],
                                      )),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  contentPadding: Dimens.edgeInsets0,
                  leading: SvgPicture.asset(
                    AssetConstants.authorize_permission,
                  ),
                  title: Text(
                    'authorized_permission'.tr,
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
                                    borderRadius:
                                        BorderRadius.circular(Dimens.fifteen),
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
                                          "are_you_sure_clear_chats".tr,
                                          style: Styles.greyColor888840014,
                                        ),
                                        Dimens.boxHeight18,
                                        CustomBottomButton(
                                          firstbtnText:
                                              "cancle".tr.toUpperCase(),
                                          secondbtnTxt:
                                              "clear_chats".tr.toUpperCase(),
                                          firstStyle: Styles.greyColor888850014,
                                          secondStyle: Styles.white50014,
                                          bordercolor:
                                              ColorsValue.greyColor8888,
                                          buttoncolor: ColorsValue.redColor,
                                          firstOnPressed: () {
                                            Get.back();
                                          },
                                          secondOnPressed: () {
                                            Get.back();
                                            controller.postClearIndividualChats(
                                                controller.getOneFriendsData
                                                        ?.userid ??
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
                  contentPadding: Dimens.edgeInsets0,
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
                                    borderRadius:
                                        BorderRadius.circular(Dimens.fifteen),
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
                                          firstbtnText:
                                              "cancle".tr.toUpperCase(),
                                          secondbtnTxt:
                                              "block".tr.toUpperCase(),
                                          firstStyle: Styles.greyColor888850014,
                                          secondStyle: Styles.white50014,
                                          bordercolor:
                                              ColorsValue.greyColor8888,
                                          buttoncolor: ColorsValue.redColor,
                                          firstOnPressed: () {
                                            Get.back();
                                          },
                                          secondOnPressed: () {
                                            Get.back();
                                            controller.updateFriendsRequest(
                                                controller.getOneFriendsData
                                                        ?.friendrequestid ??
                                                    "",
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
                    );
                  },
                  contentPadding: Dimens.edgeInsets0,
                  leading: SvgPicture.asset(
                    AssetConstants.ic_block,
                    height: Dimens.twenty,
                    width: Dimens.twenty,
                    colorFilter: ColorFilter.mode(
                      ColorsValue.redColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  title: Text(
                    "${'block'.tr} ${controller.getOneFriendsData?.fullname}",
                    style: Styles.redcolor50016,
                  ),
                ),
                Divider(
                  height: Dimens.one,
                  color: ColorsValue.textfildbackcolor,
                ),
                ListTile(
                  onTap: () {
                    controller.postUnFriend(
                        controller.getOneFriendsData?.friendrequestid ?? "");
                  },
                  contentPadding: Dimens.edgeInsets0,
                  leading: Image.asset(
                    AssetConstants.ic_user_remove,
                    height: Dimens.twenty,
                    width: Dimens.twenty,
                    color: ColorsValue.redColor,
                  ),
                  title: Text(
                    'unfriends'.tr,
                    style: Styles.redcolor50016,
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    });
  }
}
