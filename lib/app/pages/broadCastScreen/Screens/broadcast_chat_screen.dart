import 'dart:io';

import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart' as foundation;

import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

class BroadCastChatScreen extends StatelessWidget {
  const BroadCastChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        controller.wallpaper =
            Get.find<Repository>().getStringValue(LocalKeys.chatWallpaper);
        controller.broadcastid = Get.arguments ?? "";
        controller.chatBrodcastMessageList.clear();
        await controller.getOneBroadcast(Get.arguments ?? "");
        await controller.postChatListBroadcast(1);
        Get.find<BroadCastController>().friendsWithoutPaginationList();
        controller.scrollBrodcastController.addListener(() async {
          if (controller.scrollBrodcastController.position.pixels ==
              controller.scrollBrodcastController.position.maxScrollExtent) {
            if (controller.isBrodcastLoading == false) {
              controller.isBrodcastLoading = true;
              controller.update();
              if (controller.isBrodcastLastPage == false) {
                await controller
                    .postChatListBroadcast(controller.pageBrodcastCount);
              }
              controller.isBrodcastLoading = false;
              controller.update();
            }
          }
        });
        controller.isOverlayOpen = false;
        controller.isChatMessageEdit = false;
        controller.sendBrodcastMsgController.clear();
        controller.autocompleteOverlay?.remove();
      },
      builder: (controller) {
        return Scaffold(
          appBar: GradientAppBar(
            //  shadowColor: ColorsValue.greyAAAAAA,
            //backgroundColor: ColorsValue.white,
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
            //   titleSpacing: Dimens.five,
            title: InkWell(
              onTap: () {
                RouteManagement.goToBroadCastProfileScreen(
                    controller.broadcastid ?? "");
              },
              child: Row(
                children: [
                  Container(
                    height: Dimens.fourty,
                    width: Dimens.fourty,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimens.hundred,
                      ),
                      color: ColorsValue.maincoloropacity1,
                    ),
                    child: Padding(
                      padding: Dimens.edgeInsets10,
                      child: SvgPicture.asset(AssetConstants.promotionIcon),
                    ),
                  ),
                  Dimens.boxWidth10,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.getOneBroadcastData?.broadcasttitle ?? "",
                        style: Styles.black70016,
                      ),
                      Dimens.boxHeight5,
                      Text(
                        "${controller.getOneBroadcastData?.members?.length} Members"
                            .tr,
                        style: Styles.greyColor888840012,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          backgroundColor: ColorsValue.white,
          body: Stack(
            children: [
              if (controller.wallpaper?.isNotEmpty ?? false) ...[
                Image.file(
                  File(controller.wallpaper!),
                  fit: BoxFit.cover,
                  width: double.maxFinite,
                  height: double.maxFinite,
                  filterQuality: FilterQuality.high,
                ),
              ],
              Padding(
                padding: Dimens.edgeInsets20,
                child: Column(
                  children: [
                    Flexible(
                      child: RefreshIndicator(
                        onRefresh: () => Future.sync(
                          () => controller.postChatListBroadcast(1),
                        ),
                        color: ColorsValue.appColor,
                        child: controller.chatBrodcastMessageList.isEmpty
                            ? Center(
                                child: SvgPicture.asset(
                                  AssetConstants.chat_empty,
                                ),
                              )
                            : ListView.builder(
                                reverse: true,
                                controller: controller.scrollBrodcastController,
                                itemCount:
                                    controller.chatBrodcastMessageList.length,
                                itemBuilder: (context, index) {
                                  bool isSameDate = false;
                                  String? newDate = '';

                                  if (index == 0 &&
                                      controller
                                              .chatBrodcastMessageList.length ==
                                          1) {
                                    newDate = controller
                                        .groupMessageDateAndTime(controller
                                            .chatBrodcastMessageList[index]
                                            .senttimestamp
                                            .toString())
                                        .toString();
                                  } else if (index ==
                                      controller
                                              .chatBrodcastMessageList.length -
                                          1) {
                                    newDate = controller
                                        .groupMessageDateAndTime(controller
                                            .chatBrodcastMessageList[index]
                                            .senttimestamp
                                            .toString())
                                        .toString();
                                  } else {
                                    final DateTime date = controller
                                        .returnDateAndTimeFormat(controller
                                            .chatBrodcastMessageList[index]
                                            .senttimestamp
                                            .toString());
                                    final DateTime prevDate = controller
                                        .returnDateAndTimeFormat(controller
                                            .chatBrodcastMessageList[index + 1]
                                            .senttimestamp
                                            .toString());
                                    isSameDate =
                                        date.isAtSameMomentAs(prevDate);

                                    if (kDebugMode) {
                                      print("$date $prevDate $isSameDate");
                                    }
                                    newDate = isSameDate
                                        ? ''
                                        : controller
                                            .groupMessageDateAndTime(controller
                                                .chatBrodcastMessageList[index]
                                                .senttimestamp
                                                .toString())
                                            .toString();
                                  }

                                  return Column(
                                    children: [
                                      if (newDate.isNotEmpty) ...[
                                        Padding(
                                          padding: Dimens.edgeInsets0_10_0_10,
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Divider(
                                                  height: Dimens.one,
                                                  color: ColorsValue
                                                      .textfildbackcolor,
                                                ),
                                              ),
                                              Expanded(
                                                child: Center(
                                                  child: Text(
                                                    newDate,
                                                    style: Styles
                                                        .greyColor888840014,
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: Divider(
                                                  height: Dimens.one,
                                                  color: ColorsValue
                                                      .textfildbackcolor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                      ListView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: 1,
                                        itemBuilder: (context, i) {
                                          if (controller
                                              .chatBrodcastMessageList[index]
                                              .deletedfor!
                                              .any((element) =>
                                                  element.userid?.id ==
                                                  Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds))) {
                                            return DeleteMessage(
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatBrodcastMessageList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isDelivered: controller
                                                          .chatBrodcastMessageList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatBrodcastMessageList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatBrodcastMessageList[
                                                        index]
                                                    .senttimestamp,
                                              ),
                                              isEdited: controller
                                                      .chatBrodcastMessageList[
                                                          index]
                                                      .isedited ??
                                                  false,
                                            );
                                          } else {
                                            switch (controller
                                                .chatBrodcastMessageList[index]
                                                .contentType) {
                                              case 'text':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  switch (controller
                                                      .chatBrodcastMessageList[
                                                          index]
                                                      .context
                                                      ?.contentType) {
                                                    case 'text':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index]);
                                                          },
                                                          child: ReplayMessage(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                    case 'photo':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index]);
                                                          },
                                                          child: ImageWithText(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            images: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                    case 'links':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: LinksWithText(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            image: '',
                                                          ),
                                                        ),
                                                      );
                                                    case 'docs':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: DocsWithText(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                            fileName: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .name ??
                                                                "",
                                                            extensions: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .name
                                                                    .split('.')
                                                                    .last ??
                                                                "",
                                                            fileUrl: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                          ),
                                                        ),
                                                      );
                                                    case 'video':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: VideoWithText(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            video: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    case 'contact':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.contact
                                                                    .length ==
                                                                1
                                                            ? GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ReplayContactWithMessage(
                                                                  isEdited: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  emoji: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                      ? "You"
                                                                      : controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.fullname ??
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.nickname ??
                                                                          "",
                                                                  isSend: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                                  message: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  images: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact[
                                                                              0]
                                                                          .userid
                                                                          ?.profileimage ??
                                                                      "",
                                                                  isDelivered: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                  replayChat: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact[
                                                                              0]
                                                                          .userid
                                                                          ?.nickname ??
                                                                      "",
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ReplayMultiContactWithMessage(
                                                                  isEdited: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  emoji: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                      ? "You"
                                                                      : controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.fullname ??
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.nickname ??
                                                                          "",
                                                                  isSend: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                                  message: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  isDelivered: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                  replayChat: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact
                                                                          .length
                                                                          .toString() ??
                                                                      "",
                                                                ),
                                                              ),
                                                      );
                                                    case 'audio':
                                                      return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatBrodcastListsDoc =
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                AudioWithText(
                                                              emoji: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              message: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isDelivered: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "delivered"
                                                                  ? true
                                                                  : false,
                                                              isSeen: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "seen"
                                                                  ? true
                                                                  : false,
                                                              isEdited: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                            ),
                                                          ));
                                                    case 'poll':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: PollWithText(
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.poll
                                                                    .pollid
                                                                    ?.polltitle ??
                                                                "",
                                                          ),
                                                        ),
                                                      );
                                                    case 'location':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              LocationWithText(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                    case 'photowithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                TextWithPhotoWithText(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    case 'videowithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                TextWithVideoWithText(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    case 'productwithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                TextWithProductWithText(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    default:
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: ReplayMessage(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                  }
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index]);
                                                      },
                                                      child: OnlyMessage(
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        message: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .senttimestamp,
                                                        ),
                                                        isEdited: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'photo':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayPhotoMessage(
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isGroup: false,
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index]);
                                                      },
                                                      child: SingleImageMsg(
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        images: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'photowithlinks':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index]);
                                                    },
                                                    child: ImageWithLinks(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      images: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                    ),
                                                  ),
                                                );
                                              case 'photowithtext':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index]);
                                                    },
                                                    child: ImageWithText(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      images: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                    ),
                                                  ),
                                                );
                                              case 'links':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  switch (controller
                                                      .chatBrodcastMessageList[
                                                          index]
                                                      .context
                                                      ?.contentType) {
                                                    case 'text':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: TextWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            onTap: () {
                                                              Utility.launchLinkURL(controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "");
                                                            },
                                                          ),
                                                        ),
                                                      );
                                                    case 'contact':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.contact
                                                                    .length ==
                                                                1
                                                            ? GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ReplayContactWithLinks(
                                                                  isEdited: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  emoji: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                      ? "You"
                                                                      : controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.fullname ??
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.nickname ??
                                                                          "",
                                                                  isSend: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                                  message: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  images: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact[
                                                                              0]
                                                                          .userid
                                                                          ?.profileimage ??
                                                                      "",
                                                                  isDelivered: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                  replayChat: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact[
                                                                              0]
                                                                          .userid
                                                                          ?.nickname ??
                                                                      "",
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ReplayMultiContactWithMessage(
                                                                  isEdited: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  emoji: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                      ? "You"
                                                                      : controller
                                                                              .chatBrodcastMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.fullname ??
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.nickname ??
                                                                          "",
                                                                  isSend: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                                  message: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  isDelivered: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatBrodcastMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                  replayChat: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .context
                                                                          ?.content
                                                                          ?.contact
                                                                          .length
                                                                          .toString() ??
                                                                      "",
                                                                ),
                                                              ),
                                                      );
                                                    case 'photo':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: ImageWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.status ==
                                                                    "sent"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            images: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                          ),
                                                        ),
                                                      );
                                                    case 'video':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: VideoWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.status ==
                                                                    "sent"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            video: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    case 'docs':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: DocsWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.status ==
                                                                    "sent"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            fileName: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .name ??
                                                                "",
                                                            extensions: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .name
                                                                    .split('.')
                                                                    .last ??
                                                                "",
                                                            fileUrl: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    case 'audio':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: AudioWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    "",
                                                          ),
                                                        ),
                                                      );
                                                    case 'location':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatBrodcastMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              LocationWithLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                    case 'links':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: ReplayLinks(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    case 'poll':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: PollWithLinks(
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            userName: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? "You"
                                                                : controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.nickname ??
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.fullname ??
                                                                    "",
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            replayChat: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.content
                                                                    ?.poll
                                                                    .pollid
                                                                    ?.polltitle ??
                                                                "",
                                                          ),
                                                        ),
                                                      );
                                                    case 'photowithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                LinksWithPhotoWithLinks(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    case 'videowithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                LinksWithVideoWithLinks(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    case 'productwithtext':
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatBrodcastMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                LinksWithProductWithLinks(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    default:
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatBrodcastListsDoc =
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: LinkMessage(
                                                            emoji: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isEdited: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isSend: Get.find<
                                                                            Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                            message: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                  }
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: LinkMessage(
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isEdited: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        message: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .senttimestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'docs':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayDocsMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: DocsMessage(
                                                        onTap: () {
                                                          Utility.downloadAndSavePDF(
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              'ChatNest',
                                                              0);
                                                          controller.update();
                                                        },
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        fileName: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .senttimestamp,
                                                        ),
                                                        fileUrl: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        extensions: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name
                                                                .split('.')
                                                                .last ??
                                                            "",
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'docswithtext':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: DocsWithText(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                      fileName: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .name ??
                                                          "",
                                                      extensions: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .name
                                                              .split('.')
                                                              .last ??
                                                          "",
                                                      fileUrl: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              case 'docswithlinks':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: DocsWithLinks(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                      fileName: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .name ??
                                                          "",
                                                      extensions: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .name
                                                              .split('.')
                                                              .last ??
                                                          "",
                                                      fileUrl: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              case 'video':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayVideoMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: SingleVideoMsg(
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        video: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'videowithtext':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: VideoWithText(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      video: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                    ),
                                                  ),
                                                );
                                              case 'videowithlinks':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: VideoWithLinks(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      video: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.media
                                                              .path ??
                                                          "",
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                    ),
                                                  ),
                                                );
                                              case 'audio':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayAudioMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: MusicPlay(
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        audioUrl: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'audiowithtext':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: AudioWithText(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                      userName: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? "You"
                                                          : controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.fullname ??
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.nickname ??
                                                              "",
                                                    ),
                                                  ),
                                                );
                                              case 'audiowithlinks':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: AudioWithLinks(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .senttimestamp),
                                                      userName: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? "You"
                                                          : controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.fullname ??
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.nickname ??
                                                              "",
                                                    ),
                                                  ),
                                                );
                                              case 'location':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayLocationMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child:
                                                          ShareCurrentLocation(
                                                        emoji: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isDelivered: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                        businessProfileLatLag:
                                                            LatLng(
                                                          controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.location
                                                              .coordinates[1],
                                                          controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.location
                                                              .coordinates[0],
                                                        ),
                                                        onTap: (latLng) async {
                                                          MapsLauncher
                                                              .launchCoordinates(
                                                            controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.location
                                                                .coordinates[1],
                                                            controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.location
                                                                .coordinates[0],
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                  );
                                                }
                                              case 'contact':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayContactMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .content
                                                                ?.contact
                                                                .length ==
                                                            1
                                                        ? GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child: ShareContact(
                                                              onMessageTap: () {
                                                                for (var datas in controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact ??
                                                                    <ContactContent>[]) {
                                                                  RouteManagement
                                                                      .gooffAndToNamedChatScreen(
                                                                          datas.userdata?.id ??
                                                                              "",
                                                                          false);
                                                                }
                                                              },
                                                              emoji: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isDelivered: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "delivered"
                                                                  ? true
                                                                  : false,
                                                              isSeen: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "seen"
                                                                  ? true
                                                                  : false,
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              contactList: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.contact ??
                                                                  [],
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                            ),
                                                          )
                                                        : GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                ShareMultipulConect(
                                                              emoji: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isDelivered: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "delivered"
                                                                  ? true
                                                                  : false,
                                                              isSeen: controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .status ==
                                                                      "seen"
                                                                  ? true
                                                                  : false,
                                                              isSend: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatBrodcastMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                              contactList: controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.contact ??
                                                                  [],
                                                              onTap: () {
                                                                controller
                                                                    .getContactList
                                                                    .clear();
                                                                RouteManagement.goToViewAllContact(controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact ??
                                                                    []);
                                                              },
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                            ),
                                                          ),
                                                  );
                                                }
                                              case 'poll':
                                                if (controller
                                                        .chatBrodcastMessageList[
                                                            index]
                                                        .context !=
                                                    null) {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatBrodcastMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayPollsMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                } else {
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatBrodcastListsDoc =
                                                          controller
                                                                  .chatBrodcastMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoBrodcastMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatBrodcastMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: PollMessage(
                                                          key: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.poll
                                                              .pollid
                                                              ?.key,
                                                          onVote: (choice) {
                                                            controller.postPollVote(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.poll,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.poll
                                                                        .pollid
                                                                        ?.options[
                                                                            choice]
                                                                        .id ??
                                                                    "");
                                                          },
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index],
                                                          isSend: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )

                                                        // PollMessage(
                                                        //   emoji: controller
                                                        //           .chatBrodcastMessageList[
                                                        //               index]
                                                        //           .reactions ??
                                                        //       [],
                                                        //   onEmojiRemove: () {
                                                        //     controller
                                                        //         .postChatMessageUnReaction(
                                                        //             controller
                                                        //                 .chatBrodcastMessageList[
                                                        //                     index]
                                                        //                 .id);
                                                        //   },
                                                        //   isBookmark: controller
                                                        //           .chatBrodcastMessageList[
                                                        //               index]
                                                        //           .bookmarks
                                                        //           ?.isNotEmpty ??
                                                        //       false,
                                                        //   isFavorites: controller
                                                        //           .chatBrodcastMessageList[
                                                        //               index]
                                                        //           .favorites
                                                        //           ?.isNotEmpty ??
                                                        //       false,
                                                        //   isDelivered: controller
                                                        //               .chatBrodcastMessageList[
                                                        //                   index]
                                                        //               .status ==
                                                        //           "delivered"
                                                        //       ? true
                                                        //       : false,
                                                        //   isSeen: controller
                                                        //               .chatBrodcastMessageList[
                                                        //                   index]
                                                        //               .status ==
                                                        //           "seen"
                                                        //       ? true
                                                        //       : false,
                                                        //   isSend: Get.find<
                                                        //                   Repository>()
                                                        //               .getStringValue(
                                                        //                   LocalKeys
                                                        //                       .userIds) ==
                                                        //           controller
                                                        //               .chatBrodcastMessageList[
                                                        //                   index]
                                                        //               .from
                                                        //               ?.id
                                                        //       ? true
                                                        //       : false,
                                                        //   title: controller
                                                        //           .chatBrodcastMessageList[
                                                        //               index]
                                                        //           .content
                                                        //           ?.poll
                                                        //           .pollid
                                                        //           ?.polltitle ??
                                                        //       "",
                                                        //   time: Utility
                                                        //       .getTimeStempToTimeHHMMAA(
                                                        //           controller
                                                        //               .chatBrodcastMessageList[
                                                        //                   index]
                                                        //               .senttimestamp),
                                                        //   chatPollList: controller
                                                        //           .chatBrodcastMessageList[
                                                        //               index]
                                                        //           .content
                                                        //           ?.poll
                                                        //           .pollid
                                                        //           ?.options ??
                                                        //       [],
                                                        //   onTap: () {
                                                        //     RouteManagement
                                                        //         .goToViewPollVoteScreen(
                                                        //             "");
                                                        //   },
                                                        // ),
                                                        ),
                                                  );
                                                }
                                              case 'product':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .friendProductDoc =
                                                        null;
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: SingleProduct(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                        controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .senttimestamp,
                                                      ),
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      productImage: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.image ??
                                                          "",
                                                      productPrice: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.price
                                                              .toString() ??
                                                          "",
                                                      productTitle: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.name ??
                                                          "",
                                                      productdiscription: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.description ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              case 'productwithtext':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: ProductWithMessage(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                        controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .senttimestamp,
                                                      ),
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      productImage: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.image ??
                                                          "",
                                                      productPrice: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.price
                                                              .toString() ??
                                                          "",
                                                      productTitle: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.name ??
                                                          "",
                                                      productdiscription: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.description ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              case 'productwithlinks':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .friendProductDoc =
                                                        null;
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: ProductWithLinks(
                                                      emoji: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isBookmark: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .favorites
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isDelivered: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "delivered"
                                                          ? true
                                                          : false,
                                                      isSeen: controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .status ==
                                                              "seen"
                                                          ? true
                                                          : false,
                                                      isEdited: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                        controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .senttimestamp,
                                                      ),
                                                      message: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      productImage: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.image ??
                                                          "",
                                                      productPrice: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.price
                                                              .toString() ??
                                                          "",
                                                      productTitle: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.name ??
                                                          "",
                                                      productdiscription: controller
                                                              .chatBrodcastMessageList[
                                                                  index]
                                                              .content
                                                              ?.product
                                                              .productid
                                                              ?.description ??
                                                          "",
                                                    ),
                                                  ),
                                                );
                                              case 'multimedia':
                                                return GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index]);
                                                    },
                                                    child: MultipalImage(
                                                      isGroup: false,
                                                      chatListsDocData: controller
                                                              .chatBrodcastMessageList[
                                                          index],
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                    ));
                                              case 'multimediawithtext':
                                                return GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index]);
                                                    },
                                                    child:
                                                        MultipalImageWithText(
                                                      isGroup: false,
                                                      chatListsDocData: controller
                                                              .chatBrodcastMessageList[
                                                          index],
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                    ));
                                              case 'multimediawithlinks':
                                                return GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoBrodcastMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatBrodcastMessageList[
                                                                  index]);
                                                    },
                                                    child:
                                                        MultipalImageWithLinks(
                                                      isGroup: false,
                                                      chatListsDocData: controller
                                                              .chatBrodcastMessageList[
                                                          index],
                                                      isSend: Get.find<
                                                                      Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                          ? true
                                                          : false,
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatMessageUnReaction(
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                    ));
                                              case 'videocall':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatGroupMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index]);
                                                      },
                                                      child: VideoCall(
                                                        isGroup: false,
                                                        chatListsDocData: controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                      )),
                                                );
                                              case 'audiocall':
                                                return SwipeTo(
                                                  onRightSwipe: (details) {
                                                    controller.isReplyChat =
                                                        true;
                                                    controller
                                                            .chatBrodcastListsDoc =
                                                        controller
                                                                .chatGroupMessageList[
                                                            index];
                                                    controller.update();
                                                  },
                                                  child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoBrodcastMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatBrodcastMessageList[
                                                                    index]);
                                                      },
                                                      child: AudioCall(
                                                        isGroup: false,
                                                        chatListsDocData: controller
                                                                .chatBrodcastMessageList[
                                                            index],
                                                        isSend: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatBrodcastMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? true
                                                            : false,
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatBrodcastMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                      )),
                                                );
                                              default:
                                                return GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBrodcastMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatBrodcastMessageList[
                                                          index],
                                                    );
                                                  },
                                                  child: OnlyMessage(
                                                    isDelivered: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    emoji: controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .reactions ??
                                                        [],
                                                    onEmojiRemove: () {
                                                      controller
                                                          .postChatMessageUnReaction(
                                                              controller
                                                                  .chatBrodcastMessageList[
                                                                      index]
                                                                  .id);
                                                    },
                                                    isSend: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isEdited: controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .isedited ??
                                                        false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatBrodcastMessageList[
                                                                    index]
                                                                .senttimestamp),
                                                    isBookmark: controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .bookmarks
                                                            ?.isNotEmpty ??
                                                        false,
                                                    isFavorites: controller
                                                            .chatBrodcastMessageList[
                                                                index]
                                                            .favorites
                                                            ?.isNotEmpty ??
                                                        false,
                                                  ),
                                                );
                                            }
                                          }
                                        },
                                      )
                                    ],
                                  );
                                },
                              ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Flexible(
                          child: Container(
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: controller.isReplyChat
                                  ? BorderRadius.only(
                                      topLeft: Radius.circular(
                                        Dimens.ten,
                                      ),
                                      topRight: Radius.circular(
                                        Dimens.ten,
                                      ),
                                      bottomLeft: Radius.circular(
                                        Dimens.twenty,
                                      ),
                                      bottomRight: Radius.circular(
                                        Dimens.twenty,
                                      ),
                                    )
                                  : BorderRadius.circular(
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
                            child: Padding(
                              padding: Dimens.edgeInsets10,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (controller.isReplyChat) ...[
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "text") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "photo") ...[
                                      ReplyImageMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        image: controller.chatBrodcastListsDoc
                                                ?.content?.media.path ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "photowithlinks") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.text.message,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "photowithtext") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.text.message,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "links") ...[
                                      ReplyLinksMsg(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        image: controller.chatBrodcastListsDoc
                                                ?.content?.media.path ??
                                            "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.text.message,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "docs") ...[
                                      ReplyDocsWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.media.name,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "video") ...[
                                      ReplyVideoWithTextMsg(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        video: controller.chatBrodcastListsDoc
                                                ?.content?.media.path ??
                                            "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.media.name,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "location") ...[
                                      ReplyLocationWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.media.name,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "contact") ...[
                                      controller.chatBrodcastListsDoc?.content
                                                  ?.contact.length !=
                                              1
                                          ? ReplyMultiContactWithTextMsg(
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.fullname ??
                                                      controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                  .chatBrodcastListsDoc
                                                  ?.content
                                                  ?.contact
                                                  .length
                                                  .toString(),
                                              onTap: () {
                                                controller.isReplyChat = false;
                                                controller
                                                        .chatBrodcastListsDoc =
                                                    null;
                                                controller.update();
                                              },
                                            )
                                          : ReplyContactWithTextMsg(
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.fullname ??
                                                      controller
                                                          .chatBrodcastListsDoc
                                                          ?.from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                  .chatBrodcastListsDoc
                                                  ?.content
                                                  ?.contact[0]
                                                  .userdata
                                                  ?.nickname,
                                              onTap: () {
                                                controller.isReplyChat = false;
                                                controller
                                                        .chatBrodcastListsDoc =
                                                    null;
                                                controller.update();
                                              },
                                              image: controller
                                                  .chatBrodcastListsDoc
                                                  ?.content
                                                  ?.contact[0]
                                                  .userdata
                                                  ?.profileimage,
                                            ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "audio") ...[
                                      ReplyAudioWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.media.name,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "poll") ...[
                                      ReplyPollWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                            ?.content?.poll.pollid?.polltitle,
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      ),
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "videowithtext") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "videowithlinks") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "docswithtext") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "docswithlinks") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "audiowithtext") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "audiowithlinks") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.isProductSend) ...[
                                      ReplyProductMessage(
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.friendProductDoc = null;
                                          controller.isProductSend = false;
                                          controller.update();
                                        },
                                        productImage: controller
                                                .friendProductDoc?.image ??
                                            "",
                                        productName:
                                            controller.friendProductDoc?.name ??
                                                "",
                                        productDes: controller.friendProductDoc
                                                ?.description ??
                                            "",
                                        productPrice: controller
                                                .friendProductDoc?.price
                                                .toString() ??
                                            "",
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "productwithtext") ...[
                                      ReplyTextMessage(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "videocall") ...[
                                      ReplyVideoCallWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                    if (controller.chatBrodcastListsDoc
                                            ?.contentType ==
                                        "audiocall") ...[
                                      ReplyAudioCallWithText(
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.id
                                            ? "You"
                                            : controller.chatBrodcastListsDoc
                                                    ?.from?.fullname ??
                                                controller.chatBrodcastListsDoc
                                                    ?.from?.nickname ??
                                                "",
                                        message: controller.chatBrodcastListsDoc
                                                ?.content?.text.message ??
                                            "",
                                        onTap: () {
                                          controller.isReplyChat = false;
                                          controller.chatBrodcastListsDoc =
                                              null;
                                          controller.update();
                                        },
                                      )
                                    ],
                                  ],
                                  // ],
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          controller.messageFocusNode.unfocus();
                                          controller.isEmoji =
                                              !controller.isEmoji;
                                          controller.update();
                                        },
                                        child: SvgPicture.asset(
                                            AssetConstants.emojiesIcon),
                                      ),
                                      Expanded(
                                        child: TextFormField(
                                          focusNode:
                                              controller.messageFocusNode,
                                          onTap: () {
                                            controller.isEmoji = false;
                                            controller.update();
                                          },
                                          controller: controller
                                              .sendBrodcastMsgController,
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              controller.isChatMessageEdit =
                                                  false;
                                            }
                                            controller.update();
                                          },
                                          decoration: InputDecoration(
                                            isDense: true,
                                            contentPadding:
                                                EdgeInsets.symmetric(
                                              horizontal: Dimens.ten,
                                            ),
                                            hintText: 'typing_here'.tr,
                                            hintStyle: Styles.hookup40012,
                                            border: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                            focusedErrorBorder:
                                                InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          controller.messageFocusNode.unfocus();
                                          if (controller.isOverlayOpen) {
                                            controller.autocompleteOverlay
                                                ?.remove();
                                            controller.isOverlayOpen = false;
                                            controller.update();
                                          } else {
                                            controller.showOverlayDialog(
                                                controller, false, true);
                                            Overlay.of(context).insert(
                                                controller
                                                    .autocompleteOverlay!);
                                            controller.isOverlayOpen = true;
                                            controller.update();
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          AssetConstants.attexhmedia,
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      InkWell(
                                        onTap: () async {
                                          controller.messageFocusNode.unfocus();
                                          var data = await Utility
                                              .cameraPermissionCheack(context);
                                          if (data) {
                                            controller.setCameraPhoto(
                                                ImageSource.camera,
                                                false,
                                                true);
                                          }
                                        },
                                        child: SvgPicture.asset(
                                          AssetConstants.cameraIcon,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxWidth10,
                        InkWell(
                          onTap: () {
                            if (controller
                                .sendBrodcastMsgController.text.isNotEmpty) {
                              controller.postSendMessageBroadcast("", false);

                              controller.isReplyChat = false;
                              controller.isProductSend = false;
                              controller.chatBrodcastListsDoc = null;
                              controller.friendProductDoc = null;
                              controller.sendBrodcastMsgController.clear();
                              controller.update();
                            }
                          },
                          child: Container(
                            height: Dimens.fourty,
                            width: Dimens.fourty,
                            decoration: BoxDecoration(
                              color: ColorsValue.maincolor1,
                              borderRadius: BorderRadius.circular(Dimens.fifty),
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
                    controller.isEmoji
                        ? Padding(
                            padding: Dimens.edgeInsetsTop10,
                            child: Offstage(
                              offstage: !controller.isEmoji,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimens.twenty,
                                ),
                                child: SizedBox(
                                  height: Dimens.twoHundredFifty,
                                  child: EmojiPicker(
                                    textEditingController:
                                        controller.sendBrodcastMsgController,
                                    config: Config(
                                      height: Dimens.twoHundredFiftySix,
                                      checkPlatformCompatibility: true,
                                      // swapCategoryAndBottomBar: false,
                                      emojiViewConfig: EmojiViewConfig(
                                        columns: 10,
                                        verticalSpacing: 0,
                                        horizontalSpacing: 0,
                                        recentsLimit: 28,
                                        noRecents: DefaultNoRecentsWidget,
                                        replaceEmojiOnLimitExceed: true,
                                        emojiSizeMax: 25 *
                                            (foundation.defaultTargetPlatform ==
                                                    TargetPlatform.iOS
                                                ? 1.20
                                                : 1.0),
                                        backgroundColor:
                                            ColorsValue.transparent,
                                      ),
                                      categoryViewConfig:
                                          const CategoryViewConfig(
                                        indicatorColor: ColorsValue.maincolor1,
                                        iconColorSelected:
                                            ColorsValue.maincolor1,
                                      ),
                                      bottomActionBarConfig:
                                          const BottomActionBarConfig(
                                        backgroundColor: ColorsValue.maincolor1,
                                        buttonColor: ColorsValue.maincolor1,
                                      ),
                                      searchViewConfig:
                                          const SearchViewConfig(),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Dimens.box0
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
