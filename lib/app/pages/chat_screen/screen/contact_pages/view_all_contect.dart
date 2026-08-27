import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ViewAllContact extends StatelessWidget {
  const ViewAllContact({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) {
      var controller = Get.find<ChatController>();
      controller.getContactList.addAll(Get.arguments ?? []);
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          shadowColor: ColorsValue.greyAAAAAA,
          backgroundColor: ColorsValue.white,
          elevation: Dimens.two,
          centerTitle: false,
          title: Text(
            "view_all".tr,
            style: Styles.black70018,
          ),
          leading: Container(
            margin: Dimens.edgeInsets20_0_0_0,
            child: IconButton(
              icon: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
              onPressed: () {
                Get.back();
              },
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Dimens.boxHeight10,
              Expanded(
                child: ListView.builder(
                  itemCount: controller.getContactList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: Dimens.edgeInsets20_0_20_40,
                      child: Container(
                        width: Get.width,
                        decoration: BoxDecoration(
                          color: ColorsValue.textfildbackcolor,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets10,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        height: Dimens.fifty,
                                        width: Dimens.fifty,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.hundred),
                                        ),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              Dimens.hundred),
                                          child: CachedNetworkImage(
                                            imageUrl: ApiWrapper.imageUrl +
                                                (controller
                                                        .getContactList[index]
                                                        .userdata
                                                        ?.profileimage ??
                                                    ""),
                                            maxWidthDiskCache: 90,
                                            maxHeightDiskCache: 90,
                                            fit: BoxFit.cover,
                                            placeholder: (context, url) {
                                              return Image.asset(
                                                AssetConstants.usera,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                            errorWidget: (context, url, error) {
                                              return Image.asset(
                                                AssetConstants.usera,
                                                fit: BoxFit.cover,
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                      Dimens.boxWidth12,
                                      Text(
                                        controller.getContactList[index]
                                                .userdata?.nickname ??
                                            "",
                                        style: Styles.black60014,
                                      )
                                    ],
                                  ),
                                  if (controller
                                              .getContactList[index].isfriend ==
                                          "no" ||
                                      controller
                                              .getContactList[index].isfriend ==
                                          "sent") ...[
                                    InkWell(
                                      onTap: () {
                                        if (controller.getContactList[index]
                                                .isfriend ==
                                            "no") {
                                          Get.dialog(SentRequestDialog(
                                            formKey: controller.sendRequestKey,
                                            title: controller
                                                    .getContactList[index]
                                                    .userdata
                                                    ?.nickname ??
                                                "",
                                            textEditingController:
                                                controller.messageController,
                                            onTap: () {
                                              if (controller
                                                  .sendRequestKey.currentState!
                                                  .validate()) {
                                                Get.back();
                                                controller.sendNewFriendRequest(
                                                    controller
                                                            .getContactList[
                                                                index]
                                                            .usersid ??
                                                        "",
                                                    controller
                                                        .messageController.text,
                                                    index,
                                                    true,
                                                    false);
                                              }
                                            },
                                          ));
                                        } else {
                                          controller.cancelSentRequest(
                                              controller.getContactList[index]
                                                      .friendrequestid ??
                                                  "",
                                              index,
                                              true,
                                              false);
                                        }
                                        controller.update();
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: controller
                                                      .getContactList[index]
                                                      .isfriend ==
                                                  "no"
                                              ? ColorsValue.maincolor1
                                              : ColorsValue.redColor,
                                          borderRadius: BorderRadius.circular(
                                              Dimens.five),
                                        ),
                                        child: Padding(
                                          padding: Dimens.edgeInsets15_4_15_4,
                                          child: Text(
                                            controller.getContactList[index]
                                                        .isfriend ==
                                                    "no"
                                                ? "add".tr
                                                : "canclerequast".tr,
                                            style: Styles.white60014,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                              Dimens.boxHeight10,
                              const Divider(
                                height: 1,
                                color: ColorsValue.white,
                              ),
                              Dimens.boxHeight10,
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '${controller.getContactList[index].userdata?.countryCode ?? ""} ${controller.getContactList[index].userdata?.mobile ?? ""}',
                                    style: Styles.black60014,
                                  ),
                                  if (controller
                                          .getContactList[index].isfriend ==
                                      "yes") ...[
                                    Row(
                                      children: [
                                        if (controller.getOneFriendsData
                                                ?.usersPermissions?.audiocall ??
                                            false) ...[
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
                                            child: SvgPicture.asset(
                                                AssetConstants.callicon),
                                          ),
                                        ],
                                        if (controller.getOneFriendsData
                                                ?.usersPermissions?.videocall ??
                                            false) ...[
                                          Dimens.boxWidth10,
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
                                            child: SvgPicture.asset(
                                              AssetConstants.videoIcon,
                                              colorFilter:
                                                  const ColorFilter.mode(
                                                ColorsValue.maincolor1,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                        ],
                                        Dimens.boxWidth10,
                                        InkWell(
                                          onTap: () {
                                            RouteManagement
                                                .gooffAndToNamedChatScreen(
                                                    controller
                                                            .getContactList[
                                                                index]
                                                            .userdata
                                                            ?.id ??
                                                        "",false);
                                          },
                                          child: SvgPicture.asset(
                                            AssetConstants.selectedchaticon,
                                            height: Dimens.twenty,
                                          ),
                                        ),
                                      ],
                                    )
                                  ]
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
