import 'dart:io';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MultipalSendImageScreen extends StatelessWidget {
  const MultipalSendImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return SafeArea(
        child: Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            shadowColor: ColorsValue.greyAAAAAA,
            backgroundColor: ColorsValue.white,
            elevation: Dimens.two,
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
            actions: [
              Padding(
                padding: Dimens.edgeInsetsRight20,
                child: InkWell(
                  onTap: () {
                    controller.sendImage(ImageSource.gallery, true,
                        Get.arguments[0] ?? false, Get.arguments[1] ?? false);
                  },
                  child: SvgPicture.asset(
                    AssetConstants.ic_image_add,
                  ),
                ),
              )
            ],
          ),
          body: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: Center(
                      child: Padding(
                        padding: Dimens.edgeInsets0_30_0_30,
                        child: controller.sentImageMsgLists.isNotEmpty
                            ? controller
                                        .sentImageMsgLists[
                                            controller.sentImageMsgIndex]
                                        .isVideo ??
                                    false
                                ? InkWell(
                                    onTap: () {
                                      RouteManagement
                                          .goToSingleFullScreenImageVideo(
                                              controller
                                                      .sentImageMsgLists[
                                                          controller
                                                              .sentImageMsgIndex]
                                                      .url ??
                                                  "",
                                              "Video");
                                    },
                                    child: SizedBox(
                                      height: Dimens.twoHundredFifty,
                                      width: double.infinity,
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(Dimens.five),
                                        child: Stack(
                                          children: [
                                            VideoThumbnailWidget(
                                              video: controller
                                                      .sentImageMsgLists[
                                                          controller
                                                              .sentImageMsgIndex]
                                                      .url ??
                                                  "",
                                              isImagePath: false,
                                              width: double.infinity,
                                              height: Dimens.twoHundredFifty,
                                            ),
                                            Center(
                                              child: SvgPicture.asset(
                                                AssetConstants.ic_video_play,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : InkWell(
                                    onTap: () {
                                      RouteManagement
                                          .goToSingleFullScreenImageVideo(
                                              controller
                                                      .sentImageMsgLists[
                                                          controller
                                                              .sentImageMsgIndex]
                                                      .url ??
                                                  "",
                                              "Image");
                                    },
                                    child: Image.file(
                                      File(
                                        controller
                                                .sentImageMsgLists[controller
                                                    .sentImageMsgIndex]
                                                .url ??
                                            "",
                                      ),
                                      width: double.infinity,
                                    ),
                                  )
                            : Image.asset(
                                AssetConstants.placeholder,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: Dimens.twoHundredFifty,
                              ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: Dimens.edgeInsets20,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimens.seventy,
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: controller.sentImageMsgLists.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: Dimens.edgeInsets5,
                                    child: Container(
                                      height: Dimens.sixty,
                                      width: Dimens.sixty,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        border: Border.all(
                                          width: controller.sentImageMsgIndex ==
                                                  index
                                              ? Dimens.two
                                              : Dimens.zero,
                                          color: ColorsValue.maincolor1,
                                        ),
                                        borderRadius: BorderRadius.circular(
                                          Dimens.five,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.five,
                                        ),
                                        child: Stack(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                controller.sentImageMsgIndex =
                                                    index;
                                                controller.update();
                                              },
                                              child: controller
                                                          .sentImageMsgLists[
                                                              index]
                                                          .isVideo ??
                                                      false
                                                  ? SizedBox(
                                                      width: Dimens.sixty,
                                                      height: Dimens.sixty,
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(Dimens
                                                                    .five),
                                                        child: Stack(
                                                          children: [
                                                            VideoThumbnailWidget(
                                                              video: controller
                                                                      .sentImageMsgLists[
                                                                          controller
                                                                              .sentImageMsgIndex]
                                                                      .url ??
                                                                  "",
                                                              isImagePath:
                                                                  false,
                                                              width:
                                                                  Dimens.sixty,
                                                              height:
                                                                  Dimens.sixty,
                                                            ),
                                                            Center(
                                                              child: SvgPicture
                                                                  .asset(
                                                                AssetConstants
                                                                    .ic_video_play,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  : Image.file(
                                                      File(
                                                        controller
                                                                .sentImageMsgLists[
                                                                    index]
                                                                .url ??
                                                            "",
                                                      ),
                                                      fit: BoxFit.cover,
                                                      width: double.infinity,
                                                      height: Dimens
                                                          .twoHundredFifty,
                                                    ),
                                            ),
                                            Visibility(
                                              visible: controller
                                                          .sentImageMsgIndex ==
                                                      index
                                                  ? true
                                                  : false,
                                              child: InkWell(
                                                onTap: () {
                                                  controller.sentImageMsgLists
                                                      .remove(controller
                                                              .sentImageMsgLists[
                                                          index]);
                                                  controller.update();
                                                  if (controller
                                                      .sentImageMsgLists
                                                      .isEmpty) {
                                                    Get.back();
                                                  }
                                                },
                                                child: Container(
                                                  height: Dimens.sixty,
                                                  width: Dimens.sixty,
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  child: Padding(
                                                    padding:
                                                        Dimens.edgeInsets15,
                                                    child: SvgPicture.asset(
                                                      AssetConstants.ic_delete,
                                                      colorFilter:
                                                          const ColorFilter
                                                              .mode(
                                                        ColorsValue.white,
                                                        BlendMode.srcIn,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Dimens.boxHeight10,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Flexible(
                                child: Container(
                                  height: Dimens.fourtyFive,
                                  decoration: BoxDecoration(
                                    color: ColorsValue.white,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.fourtyone,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        spreadRadius: 0.3,
                                        blurRadius: 3,
                                        offset: Offset(0, 1),
                                        color: Colors.black38,
                                      )
                                    ],
                                  ),
                                  child: TextFormField(
                                    controller:
                                        controller.sendMessageController,
                                    decoration: InputDecoration(
                                      isDense: true,
                                      contentPadding: Dimens.edgeInsets10,
                                      hintText: 'typing_here'.tr,
                                      hintStyle: Styles.hookup40012,
                                      border: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      focusedErrorBorder: InputBorder.none,
                                    ),
                                  ),
                                ),
                              ),
                              Dimens.boxWidth10,
                              InkWell(
                                onTap: () async {
                                  if (controller.sentImageMsgLists.isNotEmpty) {
                                    if (Get.arguments[0] ?? false) {
                                      if (controller.sentImageMsgLists.length >
                                          1) {
                                        await controller
                                            .postGroupChatSendBulkMessage(
                                                "", false);
                                      } else {
                                        await controller.sendGroupMessage(
                                            "", false, false);
                                      }
                                    } else if (Get.arguments[1] ?? false) {
                                      if (controller.sentImageMsgLists.length >
                                          1) {
                                        await controller
                                            .postSendMultiMediaBroadcast(
                                                "", false);
                                      } else {
                                        await controller
                                            .postSendMessageBroadcast(
                                                "", false);
                                      }
                                    } else {
                                      if (controller.sentImageMsgLists.length >
                                          1) {
                                        await controller
                                            .postChatSendBulkMessage("", false);
                                      } else {
                                        await controller.sendMessage(
                                            "", false, false);
                                      }
                                    }

                                    if (controller.chatListsDoc == null) {
                                      controller.isReplyChat = false;
                                      controller.chatListsDoc = null;
                                    }
                                    controller.sendMessageController.clear();
                                    controller.update();
                                    Get.back();
                                  } else {
                                    Utility.errorMessage("Please Select Image");
                                  }
                                },
                                child: Container(
                                  height: Dimens.fourtyFive,
                                  width: Dimens.fourtyFive,
                                  decoration: BoxDecoration(
                                    color: ColorsValue.maincolor1,
                                    borderRadius:
                                        BorderRadius.circular(Dimens.fifty),
                                  ),
                                  child: Center(
                                    child: SvgPicture.asset(
                                      AssetConstants.sendIcon,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
