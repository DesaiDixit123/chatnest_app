import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(
      milliseconds: 500,
    );
    return GetBuilder<CallController>(
      builder: (controller) {
        final consentVal = Get.find<Repository>().getBoolValue(LocalKeys.isContactsSyncConsented);
        debugPrint('📱 UI Build: isContactsSyncConsented = $consentVal, isPermissionGrantedState = ${controller.isPermissionGrantedState}');
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: GradientAppBar(
            //   shadowColor: ColorsValue.greyAAAAAA,
            // backgroundColor: ColorsValue.white,
            elevation: Dimens.two,
            centerTitle: false,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: Dimens.edgeInsets20_15_10_15,
                child: SvgPicture.asset(
                  AssetConstants.appbarbackarrowicon,
                  colorFilter: const ColorFilter.mode(
                    Colors.black,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Text(
              'contact_list'.tr,
              style: Styles.black70018,
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextFormField(
                  controller: controller.searchCallController,
                  hintText: 'search'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  suffixIcon: Icon(
                    Icons.search,
                    size: Dimens.twentyFour,
                    color: ColorsValue.hookupHeaderGreyColor,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      controller.searchContactsList.clear();
                    } else {
                      _debouncer.run(() {
                        Future.sync(
                          () {
                            return controller.searchContactsList = controller
                                .contactsList
                                .where(
                                  (item) => item.name!.toLowerCase().contains(
                                        controller.searchCallController.text
                                            .toLowerCase(),
                                      ),
                                )
                                .toList();
                          },
                        );
                      });
                    }
                    controller.update();
                  },
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: controller.contactsList.isNotEmpty
                      ? ListView.builder(
                          itemCount: controller.searchContactsList.isEmpty
                              ? controller.contactsList.length
                              : controller.searchContactsList.length,
                          itemBuilder: ((context, index) {
                            var item = controller.searchContactsList.isEmpty
                                ? controller.contactsList[index]
                                : controller.searchContactsList[index];
                            return InkWell(
                              onTap: () {
                                if (item.isChatNestUser == true &&
                                    (item.userid?.isNotEmpty ?? false)) {
                                  RouteManagement.gooffAndToNamedChatScreen(
                                      item.userid!, false);
                                }
                              },
                              child: ListTile(
                                contentPadding: Dimens.edgeInsets0,
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
                                      Dimens.hundred,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: "",
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Image.asset(AssetConstants.usera,
                                            fit: BoxFit.cover);
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(AssetConstants.usera,
                                            fit: BoxFit.cover);
                                      },
                                    ),
                                  ),
                                ),
                                title: Text(
                                  (item.name != null &&
                                          item.name!.trim().isNotEmpty &&
                                          item.name != item.mobile)
                                      ? item.name!
                                      : (Utility.getContactNameForPhone(
                                              item.mobile) ??
                                          item.name ??
                                          "User"),
                                  style: Styles.black50016,
                                ),
                                subtitle: Text(
                                  item.mobile.toString(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840012,
                                ),
                                trailing: item.isChatNestUser == false
                                    ? InkWell(
                                        onTap: () {
                                          Get.dialog(
                                            SentRequestDialog(
                                              formKey:
                                                  controller.sendRequestKey,
                                              title: item.name,
                                              textEditingController:
                                                  controller.messageController,
                                              onTap: () {
                                                if (controller.sendRequestKey
                                                    .currentState!
                                                    .validate()) {
                                                  Get.back();
                                                  controller
                                                      .sendNewFriendRequest(
                                                          item.userid ?? "",
                                                          controller
                                                              .messageController
                                                              .text,
                                                          index);
                                                }
                                              },
                                            ),
                                          );
                                        },
                                        child: Container(
                                          height: Dimens.twentyFive,
                                          width: Dimens.seventy,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(
                                              Dimens.three,
                                            ),
                                            color: ColorsValue.maincolor1,
                                          ),
                                          child: Center(
                                            child: Text(
                                              'invite'.tr.toUpperCase(),
                                              style: Styles.white70010,
                                            ),
                                          ),
                                        ),
                                      )
                                    : item.isfriend == "no"
                                        ? InkWell(
                                            onTap: () {
                                              // Get.dialog(
                                              //   SentRequestDialog(
                                              //     formKey:
                                              //         controller.sendRequestKey,
                                              //     title: controller
                                              //         .contactsList[index].name,
                                              //     textEditingController:
                                              //         controller
                                              //             .messageController,
                                              //     onTap: () {
                                              //       if (controller
                                              //           .sendRequestKey
                                              //           .currentState!
                                              //           .validate()) {
                                              //         Get.back();
                                              //         controller.sendNewFriendRequest(
                                              //             controller
                                              //                     .contactsList[
                                              //                         index]
                                              //                     .userid ??
                                              //                 "",
                                              //             controller
                                              //                 .messageController
                                              //                 .text,
                                              //             index);
                                              //       }
                                              //     },
                                              //   ),
                                              // );
                                              //controller.update();
                                            },
                                            child: Container(
                                              height: Dimens.thirty,
                                              width: Dimens.thirty,
                                              decoration: BoxDecoration(
                                                color: ColorsValue.maincolor1,
                                                borderRadius:
                                                    BorderRadius.circular(
                                                  Dimens.three,
                                                ),
                                              ),
                                              child: Padding(
                                                padding: Dimens.edgeInsets6,
                                                child: Image.asset(
                                                  AssetConstants.ic_user_add,
                                                ),
                                              ),
                                            ),
                                          )
                                        : item.isfriend == 'sent'
                                            ? InkWell(
                                                onTap: () {
                                                  controller.cancelSentRequest(
                                                      item.friendrequestid ??
                                                          "");
                                                  controller.update();
                                                },
                                                child: Container(
                                                  height: Dimens.thirty,
                                                  width: Dimens.thirty,
                                                  decoration: BoxDecoration(
                                                      color: ColorsValue
                                                          .greyColor8888,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.three)),
                                                  child: Padding(
                                                    padding: Dimens.edgeInsets6,
                                                    child: Image.asset(
                                                      AssetConstants
                                                          .ic_user_remove,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : item.isfriend == 'received'
                                                ? Container(
                                                    height: Dimens.thirty,
                                                    width: Dimens.thirty,
                                                    decoration: BoxDecoration(
                                                      color: ColorsValue
                                                          .maincolor1,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                        Dimens.three,
                                                      ),
                                                    ),
                                                    child: PopupMenuButton(
                                                      padding:
                                                          Dimens.edgeInsets0,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      Dimens
                                                                          .ten)),
                                                      icon: const Icon(
                                                        Icons.more_vert,
                                                        color:
                                                            ColorsValue.white,
                                                      ),
                                                      itemBuilder: (BuildContext
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
                                                                  builder: (context,
                                                                      setState) {
                                                                    return Material(
                                                                      color: ColorsValue
                                                                          .transparent,
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Expanded(
                                                                            child:
                                                                                Padding(
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
                                                                                            controller.respondFriendsRequest(item.friendrequestid ?? "", "accepted");
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                                                                  '',
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
                                                            onTap: () async {
                                                              await Get.dialog(
                                                                Padding(
                                                                  padding: Dimens
                                                                      .edgeInsetsTop20,
                                                                  child:
                                                                      Material(
                                                                    color: ColorsValue
                                                                        .transparent,
                                                                    child:
                                                                        Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                Dimens.edgeInsets20_0_20_0,
                                                                            child:
                                                                                Container(
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
                                                                                          controller.respondFriendsRequest(item.friendrequestid ?? "", "rejected");
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
                                                          ),
                                                          PopupMenuItem(
                                                            child: Text(
                                                              'block_request'
                                                                  .tr,
                                                              style: Styles
                                                                  .redColor50014,
                                                            ),
                                                            onTap: () async {
                                                              await Get.dialog(
                                                                Padding(
                                                                  padding: Dimens
                                                                      .edgeInsetsTop20,
                                                                  child:
                                                                      Material(
                                                                    color: ColorsValue
                                                                        .transparent,
                                                                    child:
                                                                        Expanded(
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.stretch,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Padding(
                                                                            padding:
                                                                                Dimens.edgeInsets20_0_20_0,
                                                                            child:
                                                                                Container(
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
                                                                                        controller.respondFriendsRequest(item.friendrequestid ?? "", "blocked");
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
                                                          ),
                                                        ];
                                                      },
                                                    ),
                                                  )
                                                : item.isfriend == 'block'
                                                    ? InkWell(
                                                        onTap: () async {
                                                          await Get.dialog(
                                                            Padding(
                                                              padding: Dimens
                                                                  .edgeInsetsTop20,
                                                              child: Material(
                                                                color: ColorsValue
                                                                    .transparent,
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
                                                                        padding:
                                                                            Dimens.edgeInsets20_0_20_0,
                                                                        child:
                                                                            Container(
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            color:
                                                                                ColorsValue.white,
                                                                            borderRadius:
                                                                                BorderRadius.circular(Dimens.fifteen),
                                                                          ),
                                                                          child:
                                                                              Padding(
                                                                            padding:
                                                                                Dimens.edgeInsets25_30_25_30,
                                                                            child:
                                                                                Column(
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
                                                                                  "unblock_request".tr,
                                                                                  style: Styles.black70020,
                                                                                ),
                                                                                Dimens.boxHeight10,
                                                                                Text(
                                                                                  "are_you_sure_unblock".tr,
                                                                                  style: Styles.greyColor888840014,
                                                                                ),
                                                                                Dimens.boxHeight18,
                                                                                CustomBottomButton(
                                                                                  firstbtnText: "cancle".tr.toUpperCase(),
                                                                                  secondbtnTxt: "unblock".tr.toUpperCase(),
                                                                                  firstStyle: Styles.greyColor888850014,
                                                                                  secondStyle: Styles.white50014,
                                                                                  bordercolor: ColorsValue.greyColor8888,
                                                                                  buttoncolor: ColorsValue.redColor,
                                                                                  firstOnPressed: () {
                                                                                    Get.back();
                                                                                  },
                                                                                  secondOnPressed: () {
                                                                                    Get.back();
                                                                                    controller.updateFriendsRequest(item.friendrequestid ?? "", "unblocked");
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
                                                          height:
                                                              Dimens.twentyFive,
                                                          width: Dimens.seventy,
                                                          decoration:
                                                              BoxDecoration(
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
                                                    : InkWell(
                                                        onTap: () {
                                                          RouteManagement.gooffAndToNamedChatScreen(
                                                              item.userid ?? "",
                                                              false);
                                                        },
                                                        child: Container(
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
                                                          child: Padding(
                                                            padding: Dimens
                                                                .edgeInsets6,
                                                            child: Image.asset(
                                                              AssetConstants
                                                                  .ic_chat_png,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                              ),
                            );
                          }),
                        )
                      : !(Get.find<Repository>().getBoolValue(LocalKeys.isContactsSyncConsented) && controller.isPermissionGrantedState)
                          ? Center(
                              child: SingleChildScrollView(
                                child: Padding(
                                  padding: Dimens.edgeInsets20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.contacts_outlined,
                                        size: Dimens.eighty,
                                        color: ColorsValue.maincolor1.withOpacity(0.6),
                                      ),
                                      Dimens.boxHeight20,
                                      Text(
                                        "Find Friends on ChatNest".tr,
                                        style: Styles.black70018,
                                        textAlign: TextAlign.center,
                                      ),
                                      Dimens.boxHeight10,
                                      Text(
                                        "Sync your contacts to find and chat with friends already using ChatNest. Your contacts will be securely uploaded to our server for contact matching.",
                                        style: Styles.greyColor888840014,
                                        textAlign: TextAlign.center,
                                      ),
                                      Dimens.boxHeight30,
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: ColorsValue.maincolor1,
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 40,
                                            vertical: 15,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(30),
                                          ),
                                        ),
                                        onPressed: () async {
                                          await controller.handleContactSyncRequest(context);
                                        },
                                        child: Text(
                                          "Sync Contacts".tr,
                                          style: Styles.white50016,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : controller.isContactsSyncLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Center(
                                  child: Text(
                                    "No contacts found".tr,
                                    style: Styles.greyColor888840014,
                                  ),
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
