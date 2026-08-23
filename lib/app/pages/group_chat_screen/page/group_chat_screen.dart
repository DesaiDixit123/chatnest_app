import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';

class GroupChatScreen extends StatefulWidget {
  const GroupChatScreen({super.key});

  @override
  State<GroupChatScreen> createState() => _GroupChatScreenState();
}

class _GroupChatScreenState extends State<GroupChatScreen> {
  @override
  void dispose() {
    Utility.currentChatPageId = '';
    Get.forceAppUpdate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        controller.wallpaper =
            Get.find<Repository>().getStringValue(LocalKeys.chatWallpaper);
        controller.groupId = Get.arguments ?? "";
        Utility.currentChatPageId = Get.arguments ?? "";
        var index = Get.find<GroupChatController>()
            .groupListPagingController
            .itemList
            ?.indexWhere((element) => element.id == controller.groupId);
        if (index?.isNegative == false) {
          Get.find<GroupChatController>()
              .groupListPagingController
              .itemList?[index!]
              .unreadmessageCount = 0;
        }
        controller.getOneGroup();
        await controller.getGroupChatLists(1);
        controller.scrollGroupController.addListener(() async {
          if (controller.scrollGroupController.position.pixels ==
              controller.scrollGroupController.position.maxScrollExtent) {
            if (controller.isLoading == false) {
              controller.isLoading = true;
              controller.update();
              if (controller.isGroupLastPage == false) {
                await controller.getGroupChatLists(controller.pageGroupCount);
              }
              controller.isLoading = false;
              controller.update();
            }
          }
        });
        controller.isOverlayOpen = false;
        controller.isChatGroupMessageEdit = false;
        controller.sendMessageController.clear();
        controller.chatGroupMessageList
            .any((element) => element.contentType == "lable");
        controller.postGroupSeenMessage(
            controller.chatGroupMessageList.first.id ?? "");
        controller.autocompleteOverlay?.remove();
      },
      builder: (controller) {
        return PopScope(
          canPop: false,
          onPopInvoked: (didPop) {
            if (didPop) {
              return;
            }
            if (controller.isOverlayOpen) {
              controller.autocompleteOverlay?.remove();
              controller.update();
            }
            Get.back();
          },
          child: Scaffold(
            appBar: AppBar(
              shadowColor: ColorsValue.greyAAAAAA,
              backgroundColor: ColorsValue.white,
              elevation: Dimens.two,
              centerTitle: false,
              leading: InkWell(
                onTap: () {
                  if (controller.isOverlayOpen) {
                    controller.autocompleteOverlay?.remove();
                    controller.update();
                  }
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
              titleSpacing: Dimens.three,
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    RouteManagement.goToGroupProfileDetailsScreen(
                        controller.groupId ?? "");
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: Dimens.fourty,
                        width: Dimens.fourty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.hundred,
                          ),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(Dimens.hundred),
                          child: CachedNetworkImage(
                            imageUrl: ApiWrapper.imageUrl +
                                (controller.getOneGroupData.profileimage ?? ""),
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
                      Dimens.boxWidth10,
                      Text(
                        controller.getOneGroupData.name ?? "",
                        style: Styles.black70016,
                      ),
                    ],
                  ),
                ),
              ),
              actions: [

                GestureDetector(
                  onTapUp: (details) {
                    final offset = details.globalPosition;
                    showMenu(
                      context: context,
                      position: RelativeRect.fromLTRB(
                        offset.dx,
                        offset.dy,
                        MediaQuery.of(context).size.width - offset.dx,
                        MediaQuery.of(context).size.height - offset.dy,
                      ),
                      items: [
                        PopupMenuItem(
                          value: 1,
                          child: Text(
                            "Shared Media",
                            style: Styles.black40016,
                          ),
                        ),
                        PopupMenuItem(
                          value: 2,
                          child: Text(
                            "Search",
                            style: Styles.black40016,
                          ),
                        ),
                        PopupMenuItem(
                          value: 3,
                          child: Text(
                            "Wallpaper",
                            style: Styles.black40016,
                          ),
                        ),
                        PopupMenuItem(
                          value: 4,
                          child: Text(
                            "Report",
                            style: Styles.black40016,
                          ),
                        ),
                      ],
                    ).then((value) {
                      if (value == 1) {
                        RouteManagement.goToSharedMediascreen(
                            controller.getOneGroupData.id ?? "",
                            false,
                            controller.getOneGroupData.name ?? "",
                            true);
                      } else if (value == 2) {
                        if (controller.isGroupSearch) {
                          controller.isGroupSearch = false;
                        } else {
                          controller.isGroupSearch = true;
                        }
                        controller.update();
                      } else if (value == 3) {
                        RouteManagement.goToChatWallpaperScreen();
                      } else if (value == 4) {
                        controller.reasonController.clear();
                        controller.update();
                        RouteManagement.goToReportGroupScreen(
                            controller.getOneGroupData.id ?? "");
                      }
                    });
                  },
                  child: Container(
                    height: double.maxFinite,
                    width: Dimens.thirty,
                    padding: Dimens.edgeInsets3,
                    child: SvgPicture.asset(
                      AssetConstants.ic_more,
                    ),
                  ),
                ),
                Dimens.boxWidth20,
              ],
            ),
            backgroundColor: ColorsValue.white,
            body: Stack(
              children: [
                if (controller.imagePath.isNotEmpty) ...[
                  Image.file(
                    File(controller.imagePath),
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
                      if (controller.isGroupSearch) ...[
                        CustomTextFormField(
                          controller: controller.groupChatSearchController,
                          hintText: 'search'.tr,
                          fillColor: ColorsValue.textfildbackcolor,
                          suffixIcon: IconButton(
                            onPressed: () {
                              controller.isGroupSearch = false;
                              controller.groupChatSearchController.clear();
                              controller.getGroupChatLists(1);
                              controller.update();
                            },
                            icon: Icon(
                              Icons.close,
                              size: Dimens.twentyFour,
                              color: ColorsValue.hookupHeaderGreyColor,
                            ),
                          ),
                          prefixIcon: Icon(
                            Icons.search,
                            size: Dimens.twentyFour,
                            color: ColorsValue.hookupHeaderGreyColor,
                          ),
                          onChanged: (value) {
                            debouncer.run(() {
                              Future.sync(
                                () {
                                  return controller.getGroupChatLists(1);
                                },
                              );
                            });
                          },
                        ),
                      ],
                      Flexible(
                        child: RefreshIndicator(
                          onRefresh: () => Future.sync(
                            () => controller.getGroupChatLists(1),
                          ),
                          color: ColorsValue.appColor,
                          child: controller.chatGroupMessageList.isEmpty
                              ? Center(
                                  child: CircularProgressIndicator(
                                    color: ColorsValue.appColor,
                                  ),
                                )
                              : ListView.builder(
                                  reverse: true,
                                  controller: controller.scrollGroupController,
                                  itemCount:
                                      controller.chatGroupMessageList.length,
                                  itemBuilder: (context, index) {
                                    bool isSameDate = false;
                                    String? newDate = '';
                                    if (index == 0 &&
                                        controller
                                                .chatGroupMessageList.length ==
                                            1) {
                                      newDate = controller
                                          .groupMessageDateAndTime(controller
                                              .chatGroupMessageList[index]
                                              .timestamp
                                              .toString())
                                          .toString();
                                    } else if (index ==
                                        controller.chatGroupMessageList.length -
                                            1) {
                                      newDate = controller
                                          .groupMessageDateAndTime(controller
                                              .chatGroupMessageList[index]
                                              .timestamp
                                              .toString())
                                          .toString();
                                    } else {
                                      final DateTime date = controller
                                          .returnDateAndTimeFormat(controller
                                              .chatGroupMessageList[index]
                                              .timestamp
                                              .toString());
                                      final DateTime prevDate = controller
                                          .returnDateAndTimeFormat(controller
                                              .chatGroupMessageList[index + 1]
                                              .timestamp
                                              .toString());
                                      isSameDate =
                                          date.isAtSameMomentAs(prevDate);

                                      if (kDebugMode) {
                                        print("$date $prevDate $isSameDate");
                                      }
                                      newDate = isSameDate
                                          ? ''
                                          : controller
                                              .groupMessageDateAndTime(
                                                  controller
                                                      .chatGroupMessageList[
                                                          index]
                                                      .timestamp
                                                      .toString())
                                              .toString();
                                    }

                                    return Column(
                                      children: [
                                        if (controller
                                            .chatGroupMessageList[index]
                                            .deletedfor!
                                            .any((element) =>
                                                element.userid?.id ==
                                                Get.find<Repository>()
                                                    .getStringValue(LocalKeys
                                                        .userIds))) ...[
                                          Container()
                                        ] else ...[
                                          if (newDate.isNotEmpty) ...[
                                            Padding(
                                              padding:
                                                  Dimens.edgeInsets0_10_0_10,
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
                                                      child: Container(
                                                        margin: Dimens
                                                            .edgeInsets5_0_5_0,
                                                        height:
                                                            Dimens.twentyFive,
                                                        alignment:
                                                            Alignment.center,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: ColorsValue
                                                              .textfildbackcolor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                            Dimens.five,
                                                          ),
                                                        ),
                                                        child: Text(
                                                          newDate,
                                                          style: Styles
                                                              .greyColor888840012,
                                                        ),
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
                                          Visibility(
                                            visible: controller
                                                            .chatGroupMessageList[
                                                                index]
                                                            .contentType ==
                                                        'label' ||
                                                    Get.find<Repository>()
                                                            .getStringValue(
                                                                LocalKeys
                                                                    .userIds) ==
                                                        controller
                                                            .chatGroupMessageList[
                                                                index]
                                                            .from
                                                            ?.id
                                                ? false
                                                : true,
                                            child: Row(
                                              crossAxisAlignment: Get.find<
                                                                  Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .subuser
                                                              ?.id ||
                                                      Get.find<Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .from
                                                              ?.id
                                                  ? CrossAxisAlignment.end
                                                  : CrossAxisAlignment.start,
                                              mainAxisAlignment: Get.find<
                                                                  Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .subuser
                                                              ?.id ||
                                                      Get.find<Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .parentUserId) ==
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .from
                                                              ?.id
                                                  ? MainAxisAlignment.end
                                                  : MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height: Dimens.twenty,
                                                  width: Dimens.twenty,
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.fifty)),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            Dimens.fifty),
                                                    child: CachedNetworkImage(
                                                      height: Dimens.twenty,
                                                      width: Dimens.twenty,
                                                      imageUrl: ApiWrapper
                                                              .imageUrl +
                                                          (controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.profileimage ??
                                                              ""),
                                                      fit: BoxFit.cover,
                                                      placeholder:
                                                          (context, url) {
                                                        return Image.asset(
                                                          AssetConstants.usera,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                      errorWidget: (context,
                                                          url, error) {
                                                        return Image.asset(
                                                          AssetConstants.usera,
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Dimens.boxWidth5,
                                                Text(
                                                  Get.find<Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .subuser
                                                                  ?.id ||
                                                          Get.find<Repository>()
                                                                  .getStringValue(
                                                                      LocalKeys
                                                                          .userIds) ==
                                                              controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .from
                                                                  ?.id
                                                      ? "You"
                                                      : controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .from
                                                              ?.nickname ??
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .from
                                                              ?.fullname ??
                                                          "",
                                                  style: Styles.main40012,
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                        Dimens.boxHeight5,
                                        ListView.builder(
                                          shrinkWrap: true,
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemCount: 1,
                                          itemBuilder: (context, i) {
                                            if (controller
                                                .chatGroupMessageList[index]
                                                .deletedfor!
                                                .any((element) =>
                                                    element.userid?.id ==
                                                    Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds))) {
                                              return Container();
                                            } else {
                                              switch (controller
                                                  .chatGroupMessageList[index]
                                                  .contentType) {
                                                case 'label':
                                                  return LabelMessage(
                                                    message: controller
                                                            .chatGroupMessageList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                  );
                                                case 'text':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    switch (controller
                                                        .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatGroupMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayMessage(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatGroupMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ImageWithText(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              images: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility.getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.senttimestamp),
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                LinksWithText(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp
                                                                  .toString()),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child: DocsWithText(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp
                                                                  .toString()),
                                                              fileName: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .name ??
                                                                  "",
                                                              extensions: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .name
                                                                      .split(
                                                                          '.')
                                                                      .last ??
                                                                  "",
                                                              fileUrl: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                VideoWithText(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              video: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp
                                                                    .toString(),
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.contact
                                                                      .length ==
                                                                  1
                                                              ? GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayContactWithMessage(
                                                                    isEdited: controller
                                                                            .chatGroupMessageList[index]
                                                                            .isedited ??
                                                                        false,
                                                                    emoji: controller
                                                                            .chatGroupMessageList[index]
                                                                            .reactions ??
                                                                        [],
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isBookmark: controller
                                                                            .chatGroupMessageList[index]
                                                                            .bookmarks
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    isFavorites: controller
                                                                            .chatGroupMessageList[index]
                                                                            .favorites
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                        ? "You"
                                                                        : controller.chatGroupMessageList[index].from?.fullname ??
                                                                            controller.chatGroupMessageList[index].from?.nickname ??
                                                                            "",
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    isDelivered: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "delivered") ??
                                                                        false,
                                                                    message: controller
                                                                            .chatGroupMessageList[index]
                                                                            .content
                                                                            ?.text
                                                                            .message ??
                                                                        "",
                                                                    images: controller
                                                                            .chatGroupMessageList[index]
                                                                            .context
                                                                            ?.content
                                                                            ?.contact[0]
                                                                            .userid
                                                                            ?.profileimage ??
                                                                        "",
                                                                    isSeen: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "seen") ??
                                                                        false,
                                                                    time: Utility
                                                                        .getTimeStempToTimeHHMMAA(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .timestamp,
                                                                    ),
                                                                    replayChat: controller
                                                                            .chatGroupMessageList[index]
                                                                            .context
                                                                            ?.content
                                                                            ?.contact[0]
                                                                            .userid
                                                                            ?.nickname ??
                                                                        "",
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayMultiContactWithMessage(
                                                                    isEdited: controller
                                                                            .chatGroupMessageList[index]
                                                                            .isedited ??
                                                                        false,
                                                                    emoji: controller
                                                                            .chatGroupMessageList[index]
                                                                            .reactions ??
                                                                        [],
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isBookmark: controller
                                                                            .chatGroupMessageList[index]
                                                                            .bookmarks
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    isFavorites: controller
                                                                            .chatGroupMessageList[index]
                                                                            .favorites
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                        ? "You"
                                                                        : controller.chatGroupMessageList[index].from?.fullname ??
                                                                            controller.chatGroupMessageList[index].from?.nickname ??
                                                                            "",
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    isDelivered: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "delivered") ??
                                                                        false,
                                                                    message: controller
                                                                            .chatGroupMessageList[index]
                                                                            .content
                                                                            ?.text
                                                                            .message ??
                                                                        "",
                                                                    isSeen: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "seen") ??
                                                                        false,
                                                                    time: Utility
                                                                        .getTimeStempToTimeHHMMAA(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .timestamp,
                                                                    ),
                                                                    replayChat: controller
                                                                            .chatGroupMessageList[index]
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
                                                                      .chatGroupListsDoc =
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                              onLongPressStart:
                                                                  (details) {
                                                                ChatScreenUtility
                                                                    .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  AudioWithText(
                                                                emoji: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatGroupMessageUnReaction(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatGroupMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isDelivered: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "delivered") ??
                                                                    false,
                                                                message: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isSeen: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "seen") ??
                                                                    false,
                                                                isEdited: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .timestamp,
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child: PollWithText(
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatGroupMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                LocationWithText(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      TextWithPhotoWithText(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        true,
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      TextWithVideoWithText(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        true,
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      TextWithProductWithText(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        false,
                                                                  )),
                                                        );
                                                      case 'videocall':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayVideoCallWithMessage(
                                                                    isGroup:
                                                                        false,
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                  )),
                                                        );
                                                      case 'audiocall':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatGroupMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayAudioCallWithMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      case 'phonecontact':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                PhoneShareTextContact(
                                                              contactName: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.phonecontact
                                                                      ?.name ??
                                                                  " -- ",
                                                              images: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.contact[
                                                                          0]
                                                                      .userid
                                                                      ?.profileimage ??
                                                                  "",
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      "",
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
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
                                                      default:
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                ReplayMessage(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child: OnlyMessage(
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          message: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
                                                          isEdited: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                case 'photo':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayPhotoMessage(
                                                          chatListsDocData:
                                                              controller
                                                                      .chatGroupMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isGroup: true,
                                                          isGroupSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child: SingleImageMsg(
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          isSend: Get.find<
                                                                      Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .subuser
                                                                      ?.id
                                                              : Get.find<Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          images: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index]);
                                                      },
                                                      child: ImageWithLinks(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        images: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                case 'photowithtext':
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index]);
                                                      },
                                                      child: ImageWithText(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        images: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                case 'links':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    switch (controller
                                                        .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                TextWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              onTap: () {
                                                                Utility.launchLinkURL(controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "");
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      case 'videocall':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayVideoCallWithLinks(
                                                                    isGroup:
                                                                        false,
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                  )),
                                                        );
                                                      case 'audiocall':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayAudioCallWithLinks(
                                                                    isGroup:
                                                                        false,
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                  )),
                                                        );
                                                      case 'contact':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.contact
                                                                      .length ==
                                                                  1
                                                              ? GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayContactWithMessage(
                                                                    isEdited: controller
                                                                            .chatGroupMessageList[index]
                                                                            .isedited ??
                                                                        false,
                                                                    emoji: controller
                                                                            .chatGroupMessageList[index]
                                                                            .reactions ??
                                                                        [],
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isBookmark: controller
                                                                            .chatGroupMessageList[index]
                                                                            .bookmarks
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    isFavorites: controller
                                                                            .chatGroupMessageList[index]
                                                                            .favorites
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                        ? "You"
                                                                        : controller.chatGroupMessageList[index].from?.fullname ??
                                                                            controller.chatGroupMessageList[index].from?.nickname ??
                                                                            "",
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    isDelivered: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "delivered") ??
                                                                        false,
                                                                    message: controller
                                                                            .chatGroupMessageList[index]
                                                                            .content
                                                                            ?.text
                                                                            .message ??
                                                                        "",
                                                                    images: controller
                                                                            .chatGroupMessageList[index]
                                                                            .context
                                                                            ?.content
                                                                            ?.contact[0]
                                                                            .userid
                                                                            ?.profileimage ??
                                                                        "",
                                                                    isSeen: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "seen") ??
                                                                        false,
                                                                    time: Utility
                                                                        .getTimeStempToTimeHHMMAA(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .timestamp,
                                                                    ),
                                                                    replayChat: controller
                                                                            .chatGroupMessageList[index]
                                                                            .context
                                                                            ?.content
                                                                            ?.contact[0]
                                                                            .userid
                                                                            ?.nickname ??
                                                                        "",
                                                                  ),
                                                                )
                                                              : GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      ReplayMultiContactWithMessage(
                                                                    isEdited: controller
                                                                            .chatGroupMessageList[index]
                                                                            .isedited ??
                                                                        false,
                                                                    emoji: controller
                                                                            .chatGroupMessageList[index]
                                                                            .reactions ??
                                                                        [],
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isBookmark: controller
                                                                            .chatGroupMessageList[index]
                                                                            .bookmarks
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    isFavorites: controller
                                                                            .chatGroupMessageList[index]
                                                                            .favorites
                                                                            ?.isNotEmpty ??
                                                                        false,
                                                                    userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                        ? "You"
                                                                        : controller.chatGroupMessageList[index].from?.fullname ??
                                                                            controller.chatGroupMessageList[index].from?.nickname ??
                                                                            "",
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    isDelivered: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "delivered") ??
                                                                        false,
                                                                    message: controller
                                                                            .chatGroupMessageList[index]
                                                                            .content
                                                                            ?.text
                                                                            .message ??
                                                                        "",
                                                                    isSeen: controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .statuses
                                                                            ?.every((element) =>
                                                                                element.status ==
                                                                                "seen") ??
                                                                        false,
                                                                    time: Utility
                                                                        .getTimeStempToTimeHHMMAA(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .timestamp,
                                                                    ),
                                                                    replayChat: controller
                                                                            .chatGroupMessageList[index]
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                ImageWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              images: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .context
                                                                  ?.senttimestamp
                                                                  .toString()),
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                VideoWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              video: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp
                                                                    .toString(),
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                DocsWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              fileName: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .name ??
                                                                  "",
                                                              extensions: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .name
                                                                      .split(
                                                                          '.')
                                                                      .last ??
                                                                  "",
                                                              fileUrl: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.media
                                                                      .path ??
                                                                  "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp
                                                                    .toString(),
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                AudioWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
                                                              ),
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatGroupMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                LocationWithLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child: ReplayLinks(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                PollWithLinks(
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      "",
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      LinksWithPhotoWithLinks(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        true,
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      LinksWithVideoWithLinks(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        true,
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
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                                  onLongPressStart:
                                                                      (details) {
                                                                    ChatScreenUtility.infoMessageBusinessDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatGroupMessageList[index]);
                                                                  },
                                                                  child:
                                                                      LinksWithProductWithLinks(
                                                                    chatListsDocData:
                                                                        controller
                                                                            .chatGroupMessageList[index],
                                                                    isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                        ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].subuser?.id ||
                                                                            Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                                controller.chatGroupMessageList[index].from?.id
                                                                        : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatGroupMessageList[index].from?.id
                                                                            ? true
                                                                            : false,
                                                                    onEmojiRemove:
                                                                        () {
                                                                      controller.postChatGroupMessageUnReaction(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                    },
                                                                    isGroup:
                                                                        false,
                                                                  )),
                                                        );
                                                      case 'phonecontact':
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child:
                                                                PhoneShareLinksContact(
                                                              contactName: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.phonecontact
                                                                      ?.name ??
                                                                  " -- ",
                                                              images: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .context
                                                                      ?.content
                                                                      ?.contact[
                                                                          0]
                                                                      .userid
                                                                      ?.profileimage ??
                                                                  "",
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              userName: Get.find<
                                                                              Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? "You"
                                                                  : controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.fullname ??
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.nickname ??
                                                                      "",
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .senttimestamp,
                                                              ),
                                                              replayChat: controller
                                                                      .chatGroupMessageList[
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
                                                      default:
                                                        return SwipeTo(
                                                          onRightSwipe:
                                                              (details) {
                                                            controller
                                                                    .isReplyChat =
                                                                true;
                                                            controller
                                                                    .chatGroupListsDoc =
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index];
                                                            controller.update();
                                                          },
                                                          child:
                                                              GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                              );
                                                            },
                                                            child: LinkMessage(
                                                              emoji: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .reactions ??
                                                                  [],
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatGroupMessageUnReaction(
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isBookmark: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .bookmarks
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isFavorites: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .favorites
                                                                      ?.isNotEmpty ??
                                                                  false,
                                                              isSeen: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "seen") ??
                                                                  false,
                                                              isEdited: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .isedited ??
                                                                  false,
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatGroupMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatGroupMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              isDelivered: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .statuses
                                                                      ?.every((element) =>
                                                                          element
                                                                              .status ==
                                                                          "delivered") ??
                                                                  false,
                                                              message: controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "",
                                                              time: Utility
                                                                  .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .timestamp,
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: LinkMessage(
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isEdited: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          message: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  }
                                                case 'docs':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageBusinessDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatGroupMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              ReplayDocsMessage(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: DocsMessage(
                                                          onTap: () {
                                                            Utility.downloadAndSavePDF(
                                                                controller
                                                                        .chatGroupMessageList[
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
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          fileName: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .name ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
                                                          fileUrl: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          extensions: controller
                                                                  .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: DocsWithText(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        fileName: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name ??
                                                            "",
                                                        extensions: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name
                                                                .split('.')
                                                                .last ??
                                                            "",
                                                        fileUrl: controller
                                                                .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: DocsWithLinks(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        fileName: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name ??
                                                            "",
                                                        extensions: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .name
                                                                .split('.')
                                                                .last ??
                                                            "",
                                                        fileUrl: controller
                                                                .chatGroupMessageList[
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
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageBusinessDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatGroupMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              ReplayVideoMessage(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: SingleVideoMsg(
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isSend: Get.find<
                                                                      Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .subuser
                                                                      ?.id
                                                              : Get.find<Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          video: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: VideoWithText(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        video: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                case 'videowithlinks':
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: VideoWithLinks(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        video: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.media
                                                                .path ??
                                                            "",
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                case 'audio':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageBusinessDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatGroupMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              ReplayAudioMessage(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: MusicPlay(
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isSend: Get.find<
                                                                      Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .subuser
                                                                      ?.id
                                                              : Get.find<Repository>()
                                                                          .getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          audioUrl: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: AudioWithText(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        userName: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? "You"
                                                            : controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.fullname ??
                                                                controller
                                                                    .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: AudioWithLinks(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        userName: Get.find<
                                                                        Repository>()
                                                                    .getStringValue(
                                                                        LocalKeys
                                                                            .userIds) ==
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.id
                                                            ? "You"
                                                            : controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.fullname ??
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.nickname ??
                                                                "",
                                                      ),
                                                    ),
                                                  );
                                                case 'location':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageBusinessDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatGroupMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              ReplayLocationMessage(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child:
                                                            ShareCurrentLocation(
                                                          emoji: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isSeen: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "seen") ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isDelivered: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .statuses
                                                                  ?.every((element) =>
                                                                      element
                                                                          .status ==
                                                                      "delivered") ??
                                                              false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .timestamp,
                                                          ),
                                                          businessProfileLatLag:
                                                              LatLng(
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.location
                                                                .coordinates[1],
                                                            controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.location
                                                                .coordinates[0],
                                                          ),
                                                          onTap:
                                                              (latLng) async {
                                                            MapsLauncher
                                                                .launchCoordinates(
                                                              controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.location
                                                                  .coordinates[1],
                                                              controller
                                                                  .chatGroupMessageList[
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
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            ReplayContactMessage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatGroupMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  } else {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.contact
                                                                  .length ==
                                                              1
                                                          ? GestureDetector(
                                                              onLongPressStart:
                                                                  (details) {
                                                                ChatScreenUtility
                                                                    .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  ShareContact(
                                                                onMessageTap:
                                                                    () {
                                                                  for (var datas in controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact ??
                                                                      <ContactContent>[]) {
                                                                    if (datas
                                                                            .isfriend ==
                                                                        "no") {
                                                                      Get.dialog(
                                                                          SentRequestDialog(
                                                                        formKey:
                                                                            controller.sendRequestKey,
                                                                        title: datas.userdata?.nickname ??
                                                                            "",
                                                                        textEditingController:
                                                                            controller.messageController,
                                                                        onTap:
                                                                            () {
                                                                          if (controller
                                                                              .sendRequestKey
                                                                              .currentState!
                                                                              .validate()) {
                                                                            Get.back();
                                                                            controller.sendNewFriendRequest(
                                                                              datas.usersid ?? "",
                                                                              controller.messageController.text,
                                                                              index,
                                                                              false,
                                                                              true,
                                                                            );
                                                                          }
                                                                        },
                                                                      ));
                                                                    } else if (datas
                                                                            .isfriend ==
                                                                        "sent") {
                                                                      controller
                                                                          .cancelSentRequest(
                                                                        datas.friendrequestid ??
                                                                            "",
                                                                        index,
                                                                        true,
                                                                        false,
                                                                      );
                                                                    } else {
                                                                      RouteManagement.gooffAndToNamedChatScreen(
                                                                          datas.userdata?.id ??
                                                                              "",
                                                                          false);
                                                                    }
                                                                  }
                                                                },
                                                                emoji: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatGroupMessageUnReaction(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSeen: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "seen") ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatGroupMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isDelivered: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "delivered") ??
                                                                    false,
                                                                contactList: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact ??
                                                                    [],
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .timestamp,
                                                                ),
                                                              ),
                                                            )
                                                          : GestureDetector(
                                                              onLongPressStart:
                                                                  (details) {
                                                                ChatScreenUtility
                                                                    .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  ShareMultipulConect(
                                                                emoji: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatGroupMessageUnReaction(
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSeen: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "seen") ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatGroupMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatGroupMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isDelivered: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .statuses
                                                                        ?.every((element) =>
                                                                            element.status ==
                                                                            "delivered") ??
                                                                    false,
                                                                contactList: controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact ??
                                                                    [],
                                                                onTap: () {
                                                                  controller
                                                                      .getContactList
                                                                      .clear();
                                                                  RouteManagement.goToViewAllContact(controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact ??
                                                                      []);
                                                                },
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .timestamp,
                                                                ),
                                                              ),
                                                            ),
                                                    );
                                                  }
                                                case 'poll':
                                                  if (controller
                                                          .chatGroupMessageList[
                                                              index]
                                                          .context !=
                                                      null) {
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageBusinessDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatGroupMessageList[
                                                                        index]);
                                                          },
                                                          child:
                                                              ReplayPollsMessage(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatGroupMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatGroupMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                                .chatGroupListsDoc =
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatGroupMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: PollMessage(
                                                          key: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .content
                                                              ?.poll
                                                              .pollid
                                                              ?.key,
                                                          onVote: (choice) {
                                                            controller.postPollVote(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.poll,
                                                                controller
                                                                        .chatGroupMessageList[
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
                                                                      .chatGroupMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ),
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
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: SingleProduct(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        productImage: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.image ??
                                                            "",
                                                        productPrice: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.price
                                                                .toString() ??
                                                            "",
                                                        productTitle: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.name ??
                                                            "",
                                                        productdiscription: controller
                                                                .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: ProductWithMessage(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        productImage: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.image ??
                                                            "",
                                                        productPrice: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.price
                                                                .toString() ??
                                                            "",
                                                        productTitle: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.name ??
                                                            "",
                                                        productdiscription: controller
                                                                .chatGroupMessageList[
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
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: ProductWithLinks(
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isEdited: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                        message: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        productImage: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.image ??
                                                            "",
                                                        productPrice: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.price
                                                                .toString() ??
                                                            "",
                                                        productTitle: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .content
                                                                ?.product
                                                                .productid
                                                                ?.name ??
                                                            "",
                                                        productdiscription: controller
                                                                .chatGroupMessageList[
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
                                                            .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index]);
                                                      },
                                                      child: MultipalImage(
                                                        isGroup: false,
                                                        chatListsDocData: controller
                                                                .chatGroupMessageList[
                                                            index],
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                      ));
                                                case 'multimediawithtext':
                                                  return GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index]);
                                                      },
                                                      child:
                                                          MultipalImageWithText(
                                                        isGroup: false,
                                                        chatListsDocData: controller
                                                                .chatGroupMessageList[
                                                            index],
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                      ));
                                                case 'multimediawithlinks':
                                                  return GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                                context,
                                                                details,
                                                                controller
                                                                        .chatGroupMessageList[
                                                                    index]);
                                                      },
                                                      child:
                                                          MultipalImageWithLinks(
                                                        isGroup: false,
                                                        chatListsDocData: controller
                                                                .chatGroupMessageList[
                                                            index],
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child: VideoCall(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatGroupMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
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
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageBusinessDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatGroupMessageList[
                                                                      index]);
                                                        },
                                                        child: AudioCall(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatGroupMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatGroupMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatGroupMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        )),
                                                  );
                                                case 'phonecontact':
                                                  return SwipeTo(
                                                    onRightSwipe: (details) {
                                                      controller.isReplyChat =
                                                          true;
                                                      controller
                                                              .chatGroupListsDoc =
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index];
                                                      controller.update();
                                                    },
                                                    child: GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageBusinessDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatGroupMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: PhoneShareContact(
                                                        onMessageTap: () {
                                                          for (var datas in controller
                                                                  .chatGroupMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.contact ??
                                                              <ContactContent>[]) {
                                                            if (datas
                                                                    .isfriend ==
                                                                "no") {
                                                              Get.dialog(
                                                                  SentRequestDialog(
                                                                formKey: controller
                                                                    .sendRequestKey,
                                                                title: datas
                                                                        .userdata
                                                                        ?.nickname ??
                                                                    "",
                                                                textEditingController:
                                                                    controller
                                                                        .messageController,
                                                                onTap: () {
                                                                  if (controller
                                                                      .sendRequestKey
                                                                      .currentState!
                                                                      .validate()) {
                                                                    Get.back();
                                                                    controller
                                                                        .sendNewFriendRequest(
                                                                      datas.usersid ??
                                                                          "",
                                                                      controller
                                                                          .messageController
                                                                          .text,
                                                                      index,
                                                                      false,
                                                                      true,
                                                                    );
                                                                  }
                                                                },
                                                              ));
                                                            } else if (datas
                                                                    .isfriend ==
                                                                "sent") {
                                                              controller
                                                                  .cancelSentRequest(
                                                                datas.friendrequestid ??
                                                                    "",
                                                                index,
                                                                true,
                                                                false,
                                                              );
                                                            } else {
                                                              RouteManagement
                                                                  .gooffAndToNamedChatScreen(
                                                                      datas.userdata
                                                                              ?.id ??
                                                                          "",
                                                                      false);
                                                            }
                                                          }
                                                        },
                                                        emoji: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatGroupMessageUnReaction(
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .id);
                                                        },
                                                        isBookmark: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isSeen: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "seen") ??
                                                            false,
                                                        isSend: Get.find<Repository>()
                                                                .getBoolValue(
                                                                    LocalKeys
                                                                        .isSubUser)
                                                            ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id ||
                                                                Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                    controller
                                                                        .chatGroupMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatGroupMessageList[index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        isDelivered: controller
                                                                .chatGroupMessageList[
                                                                    index]
                                                                .statuses
                                                                ?.every((element) =>
                                                                    element
                                                                        .status ==
                                                                    "delivered") ??
                                                            false,
                                                        phoneContact: controller
                                                            .chatGroupMessageList[
                                                                index]
                                                            .content
                                                            ?.phonecontact,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                          controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .timestamp,
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                default:
                                                  return GestureDetector(
                                                    onLongPressStart:
                                                        (details) {
                                                      ChatScreenUtility
                                                          .infoMessageBusinessDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .chatGroupMessageList[
                                                            index],
                                                      );
                                                    },
                                                    child: OnlyMessage(
                                                      isSeen: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .statuses
                                                              ?.every((element) =>
                                                                  element
                                                                      .status ==
                                                                  "seen") ??
                                                          false,
                                                      emoji: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .reactions ??
                                                          [],
                                                      onEmojiRemove: () {
                                                        controller
                                                            .postChatGroupMessageUnReaction(
                                                                controller
                                                                    .chatGroupMessageList[
                                                                        index]
                                                                    .id);
                                                      },
                                                      isSend: Get.find<Repository>()
                                                              .getBoolValue(
                                                                  LocalKeys
                                                                      .isSubUser)
                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .subuser
                                                                      ?.id ||
                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                  controller
                                                                      .chatGroupMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                          : Get.find<Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatGroupMessageList[index]
                                                                      .from
                                                                      ?.id
                                                              ? true
                                                              : false,
                                                      isDelivered: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .statuses
                                                              ?.every((element) =>
                                                                  element
                                                                      .status ==
                                                                  "delivered") ??
                                                          false,
                                                      message: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                      isEdited: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .isedited ??
                                                          false,
                                                      time: Utility
                                                          .getTimeStempToTimeHHMMAA(
                                                        controller
                                                            .chatGroupMessageList[
                                                                index]
                                                            .timestamp,
                                                      ),
                                                      isBookmark: controller
                                                              .chatGroupMessageList[
                                                                  index]
                                                              .bookmarks
                                                              ?.isNotEmpty ??
                                                          false,
                                                      isFavorites: controller
                                                              .chatGroupMessageList[
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
                                      if (controller
                                              .chatGroupListsDoc?.context !=
                                          null) ...[
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "photo") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "video") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "contact") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "audio") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "text") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "links") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "poll") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.context?.contentType ==
                                            "docs") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.context?.from?.id
                                                ? "You"
                                                : controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.fullname ??
                                                    controller
                                                        .chatGroupListsDoc
                                                        ?.context
                                                        ?.from
                                                        ?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.text
                                                .message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                      ] else ...[
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "text") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "photo") ...[
                                          ReplyImageMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            image: controller.chatGroupListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "photowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.text
                                                .message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "photowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.text
                                                .message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "links") ...[
                                          ReplyLinksMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            image: controller.chatGroupListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.text
                                                .message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "docs") ...[
                                          ReplyDocsWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.media
                                                .name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "phonecontact") ...[
                                          ReplyPhoneContactWithTextMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.phonecontact
                                                    ?.name ??
                                                " -- ",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "video") ...[
                                          ReplyVideoWithTextMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            video: controller.chatGroupListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.media
                                                .name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "location") ...[
                                          ReplyLocationWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.media
                                                .name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "contact") ...[
                                          controller.chatGroupListsDoc?.content
                                                      ?.contact.length !=
                                                  1
                                              ? ReplyMultiContactWithTextMsg(
                                                  userName: Get.find<
                                                                  Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.id
                                                      ? "You"
                                                      : controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.fullname ??
                                                          controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.nickname ??
                                                          "",
                                                  message: controller
                                                      .chatGroupListsDoc
                                                      ?.content
                                                      ?.contact
                                                      .length
                                                      .toString(),
                                                  onTap: () {
                                                    controller.isReplyChat =
                                                        false;
                                                    controller
                                                            .chatGroupListsDoc =
                                                        null;
                                                    controller.update();
                                                  },
                                                )
                                              : ReplyContactWithTextMsg(
                                                  userName: Get.find<
                                                                  Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.id
                                                      ? "You"
                                                      : controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.fullname ??
                                                          controller
                                                              .chatGroupListsDoc
                                                              ?.from
                                                              ?.nickname ??
                                                          "",
                                                  message: controller
                                                      .chatGroupListsDoc
                                                      ?.content
                                                      ?.contact[0]
                                                      .userdata
                                                      ?.nickname,
                                                  onTap: () {
                                                    controller.isReplyChat =
                                                        false;
                                                    controller
                                                            .chatGroupListsDoc =
                                                        null;
                                                    controller.update();
                                                  },
                                                  image: controller
                                                      .chatGroupListsDoc
                                                      ?.content
                                                      ?.contact[0]
                                                      .userdata
                                                      ?.profileimage,
                                                ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "phonecontact") ...[
                                          ReplyPhoneContactWithTextMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.contact[0]
                                                .userdata
                                                ?.nickname,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                            image: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.contact[0]
                                                .userdata
                                                ?.profileimage,
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "audio") ...[
                                          ReplyAudioWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.media
                                                .name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "poll") ...[
                                          ReplyPollWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatGroupListsDoc
                                                ?.content
                                                ?.poll
                                                .pollid
                                                ?.polltitle,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "videowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "videowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "docswithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "docswithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "audiowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "audiowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.isProductSend) ...[
                                          ReplyProductMessage(
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.friendProductDoc =
                                                  null;
                                              controller.isProductSend = false;
                                              controller.update();
                                            },
                                            productImage: controller
                                                    .friendProductDoc?.image ??
                                                "",
                                            productName: controller
                                                    .friendProductDoc?.name ??
                                                "",
                                            productDes: controller
                                                    .friendProductDoc
                                                    ?.description ??
                                                "",
                                            productPrice: controller
                                                    .friendProductDoc?.price
                                                    .toString() ??
                                                "",
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "productwithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "videocall") ...[
                                          ReplyVideoCallWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller.chatGroupListsDoc
                                                ?.contentType ==
                                            "audiocall") ...[
                                          ReplyAudioCallWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller.chatGroupListsDoc
                                                        ?.from?.id
                                                ? "You"
                                                : controller.chatGroupListsDoc
                                                        ?.from?.fullname ??
                                                    controller.chatGroupListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatGroupListsDoc
                                                    ?.content
                                                    ?.text
                                                    .message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatGroupListsDoc =
                                                  null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                      ],
                                    ],
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            controller.messageFocusNode
                                                .unfocus();
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
                                                .sendMessageController,
                                            onChanged: (value) {
                                              if (value.isEmpty) {
                                                controller
                                                        .isChatGroupMessageEdit =
                                                    false;
                                                controller.update();
                                              }
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
                                            controller.messageFocusNode
                                                .unfocus();
                                            if (controller.isOverlayOpen) {
                                              controller.autocompleteOverlay
                                                  ?.remove();
                                              controller.isOverlayOpen = false;
                                              controller.update();
                                            } else {
                                              controller.showOverlayDialog(
                                                  controller, true, false);
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
                                            controller.messageFocusNode
                                                .unfocus();
                                            var data = await Utility
                                                .cameraPermissionCheack(
                                                    context);
                                            if (data) {
                                              controller.setCameraPhoto(
                                                  ImageSource.camera,
                                                  false,
                                                  false);
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
                                  .sendMessageController.text.isNotEmpty) {
                                if (!controller.isChatGroupMessageEdit) {
                                  controller.sendGroupMessage("", false, false);
                                } else {
                                  controller.postChatGroupMessageEdit(
                                      controller.sendMessageController.text);
                                }
                                controller.isReplyChat = false;
                                controller.isProductSend = false;
                                controller.chatGroupListsDoc = null;
                                controller.friendProductDoc = null;
                                controller.sendMessageController.clear();
                                controller.update();
                              }
                            },
                            child: Container(
                              height: Dimens.fourty,
                              width: Dimens.fourty,
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
                                          controller.sendMessageController,
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
                                          indicatorColor:
                                              ColorsValue.maincolor1,
                                          iconColorSelected:
                                              ColorsValue.maincolor1,
                                        ),
                                        bottomActionBarConfig:
                                            const BottomActionBarConfig(
                                          backgroundColor:
                                              ColorsValue.maincolor1,
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
          ),
        );
      },
    );
  }
}
