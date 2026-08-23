
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CreateGroupTitleScreen extends StatelessWidget {
  const CreateGroupTitleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<GroupChatController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          shadowColor: ColorsValue.greyAAAAAA,
          backgroundColor: ColorsValue.white,
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
                  ColorsValue.maincolor1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'new_group'.tr,
                style: Styles.black70016,
              ),
              Dimens.boxHeight5,
              Text(
                'new_group'.tr,
                style: Styles.greyColor888840012,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              Dimens.sixty,
            ),
          ),
          backgroundColor: ColorsValue.maincolor1,
          onPressed: () {
            if (controller.groupkey.currentState?.validate() ?? false) {
              if (controller.groupSelectedMemberList.isNotEmpty) {
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
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius:
                                      BorderRadius.circular(Dimens.fifteen),
                                ),
                                child: Padding(
                                  padding: Dimens.edgeInsets20,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'access_permission'.tr,
                                            style: Styles.black50020,
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Get.back();
                                            },
                                            child: SvgPicture.asset(
                                              AssetConstants.cancleicon,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Dimens.boxHeight18,
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          ListTile(
                                            isThreeLine: true,
                                            dense: true,
                                            contentPadding: Dimens.edgeInsets0,
                                            title: Text(
                                              'fullname'.tr,
                                              style: Styles.black50014,
                                            ),
                                            subtitle: Text(
                                              Get.find<HomeScreenController>()
                                                      .profileData
                                                      .fullname ??
                                                  " -- ",
                                              style: Styles.greyColor888840014,
                                            ),
                                            leading: SvgPicture.asset(
                                                AssetConstants.fullnameicon),
                                            trailing: CupertinoSwitch(
                                              value: controller.fullnameValue,
                                              activeColor:
                                                  ColorsValue.maincolor1,
                                              onChanged: (value) {
                                                controller.fullnameValue =
                                                    value;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            isThreeLine: true,
                                            dense: true,
                                            contentPadding: Dimens.edgeInsets0,
                                            title: Text(
                                              'phone_number'.tr,
                                              style: Styles.black50014,
                                            ),
                                            subtitle: Text(
                                              "${Get.find<HomeScreenController>().profileData.countryCode} ${Get.find<HomeScreenController>().profileData.mobile}",
                                              style: Styles.greyColor888840014,
                                            ),
                                            leading: SvgPicture.asset(
                                                AssetConstants.callicon),
                                            trailing: CupertinoSwitch(
                                              value: controller.mobileValue,
                                              activeColor:
                                                  ColorsValue.maincolor1,
                                              onChanged: (value) {
                                                controller.mobileValue = value;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            isThreeLine: true,
                                            dense: true,
                                            contentPadding: Dimens.edgeInsets0,
                                            title: Text(
                                              'email'.tr,
                                              style: Styles.black50014,
                                            ),
                                            subtitle: Text(
                                              Get.find<HomeScreenController>()
                                                      .profileData
                                                      .email ??
                                                  " -- ",
                                              style: Styles.greyColor888840014,
                                            ),
                                            leading: SvgPicture.asset(
                                                AssetConstants.smsicon),
                                            trailing: CupertinoSwitch(
                                              value: controller.emailValue,
                                              activeColor:
                                                  ColorsValue.maincolor1,
                                              onChanged: (value) {
                                                controller.emailValue = value;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          ListTile(
                                            isThreeLine: true,
                                            dense: true,
                                            contentPadding: Dimens.edgeInsets0,
                                            title: Text(
                                              'social_media'.tr,
                                              style: Styles.black50014,
                                            ),
                                            subtitle: Text(
                                              'privacy_security'.tr,
                                              style: Styles.greyColor888840014,
                                            ),
                                            leading: SvgPicture.asset(
                                                AssetConstants.socialmediaicon),
                                            trailing: CupertinoSwitch(
                                              value: controller.mediaValue,
                                              activeColor:
                                                  ColorsValue.maincolor1,
                                              onChanged: (value) {
                                                controller.mediaValue = value;
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          Dimens.boxHeight20,
                                          CustomBottomButton(
                                            firstbtnText:
                                                "cancle".tr.toUpperCase(),
                                            secondbtnTxt:
                                                "accept".tr.toUpperCase(),
                                            firstStyle:
                                                Styles.greyColor888850014,
                                            secondStyle: Styles.white50014,
                                            bordercolor:
                                                ColorsValue.greyColor8888,
                                            firstOnPressed: () {
                                              Get.back();
                                            },
                                            secondOnPressed: () {
                                              Get.back();
                                              controller.createGroupApi(
                                                  Get.arguments ?? false);
                                            },
                                          ),
                                        ],
                                      )
                                    ],
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
              } else {
                Utility.errorMessage("please_select_member".tr);
              }
            }
          },
          child: Center(
            child: Icon(
              Icons.done,
              color: Colors.white,
              size: Dimens.thirty,
            ),
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: Form(
            key: controller.groupkey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        child: InkWell(
                          onTap: () async {
                            showModalBottomSheet(
                              context: context,
                              backgroundColor: ColorsValue.white,
                              builder: (context) {
                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          topLeft:
                                              Radius.circular(Dimens.thirty),
                                          topRight: Radius.circular(
                                            Dimens.thirty,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets20_20_20_30,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Align(
                                              alignment: Alignment.topRight,
                                              child: InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: SvgPicture.asset(
                                                    AssetConstants.cancleicon),
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    Get.back();
                                                    if (await controller
                                                        .imagePermissionCheack(
                                                            context)) {
                                                      controller
                                                          .uploadGroupProfile(
                                                              ImageSource
                                                                  .camera);
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      SvgPicture.asset(
                                                        AssetConstants
                                                            .ic_select_camera,
                                                      ),
                                                      Dimens.boxHeight8,
                                                      Text(
                                                        'camera'.tr,
                                                        style: Styles.main50014,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Dimens.boxWidth60,
                                                InkWell(
                                                  onTap: () async {
                                                    Get.back();
                                                    if (await controller
                                                        .imagePermissionCheack(
                                                            context)) {
                                                      controller
                                                          .uploadGroupProfile(
                                                        ImageSource.gallery,
                                                      );
                                                    }
                                                  },
                                                  child: Column(
                                                    children: [
                                                      SvgPicture.asset(
                                                        AssetConstants
                                                            .ic_select_gallery,
                                                      ),
                                                      Dimens.boxHeight8,
                                                      Text(
                                                        'gallery'.tr,
                                                        style: Styles.main50014,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                );
                              },
                            );
                          },
                          child: Stack(
                            children: [
                              Container(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  color: ColorsValue.blackColor,
                                  border: Border.all(
                                    color: ColorsValue.maincolor1,
                                    width: Dimens.one,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  child: CachedNetworkImage(
                                    imageUrl: ApiWrapper.imageUrl +
                                        (controller.uploadGroupPic ?? ""),
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
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: Container(
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.maincolor1,
                                    border: Border.all(
                                      color: ColorsValue.white,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AssetConstants.ic_outline_edit,
                                      height: Dimens.ten,
                                      width: Dimens.ten,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Dimens.boxWidth10,
                    Expanded(
                      flex: 10,
                      child: CustomTextFormField(
                        controller: controller.titleController,
                        hintText: 'type_group_title'.tr,
                        fillColor: ColorsValue.textfildbackcolor,
                        validation: (value) {
                          if (value?.isEmpty ?? false) {
                            return 'enter_title'.tr;
                          }
                          return null;
                        },
                      ),
                    )
                  ],
                ),
                Dimens.boxHeight20,
                CustomTextFormField(
                  controller: controller.descriptionController,
                  hintText: 'description'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  maxLines: 3,
                ),
                Dimens.boxHeight20,
                Text(
                  "Participants : ${controller.groupSelectedMemberList.length.toString()}"
                      .tr,
                  style: Styles.black70020,
                ),
                Dimens.boxHeight15,
                Expanded(
                  child: GridView.builder(
                    itemCount: controller.groupSelectedMemberList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: Dimens.edgeInsets7_0_7_0,
                        child: InkWell(
                          onTap: () {
                            controller.groupSelectedMemberList.removeAt(index);
                            controller.update();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: Dimens.fifty,
                                width: Dimens.fifty,
                                child: Stack(
                                  children: [
                                    Container(
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
                                          imageUrl: ApiWrapper.imageUrl +
                                              (controller
                                                      .groupSelectedMemberList[
                                                          index]
                                                      .profileimage ??
                                                  ""),
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
                                    Positioned(
                                      right: 0,
                                      bottom: 0,
                                      child: Container(
                                        height: Dimens.eighteen,
                                        width: Dimens.eighteen,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.hundred,
                                          ),
                                          color: ColorsValue.maincolor1,
                                          border: Border.all(
                                            color: ColorsValue.white,
                                            width: Dimens.one,
                                          ),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.close,
                                            size: Dimens.twelve,
                                            color: ColorsValue.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              Text(
                                controller.groupSelectedMemberList[index]
                                        .nickname ??
                                    "",
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: Styles.greyColor888840010,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
