import 'dart:io';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/repositories/repositories.dart';
import 'package:chatnest/domain/services/user_safety_service.dart';
import 'package:chatnest/domain/entities/enums.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:swipe_to/swipe_to.dart';
import 'package:chatnest/app/widgets/chat_component/links/meeting_link_card.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void dispose() {
    Utility.currentChatPageId = '';
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        if (!Get.arguments[1]) {
          controller.isReplyChat = false;
          controller.friendProductDoc = null;
          controller.isProductSend = false;
        }
        controller.wallpaper =
            Get.find<Repository>().getStringValue(LocalKeys.chatWallpaper);
        controller.userId = Get.arguments[0] ?? "";
        Utility.currentChatPageId = Get.arguments[0] ?? "";
        var index = Get.find<ChatController>()
            .chatPagingController
            .itemList
            ?.indexWhere((element) => element.userid == controller.userId);
        if (index?.isNegative == false) {
          Get.find<ChatController>()
              .chatPagingController
              .itemList?[index!]
              .unreadmessageCount = 0;
        }
        controller.chatMessageList.clear();
        print(Get.arguments[0]);
        await controller.getOneFriends(controller.userId);

        await controller.getChatLists(1, controller.userId);
        controller.scrollController.addListener(() async {
          if (controller.scrollController.position.pixels ==
              controller.scrollController.position.maxScrollExtent) {
            if (controller.isLoading == false) {
              controller.isLoading = true;
              controller.update();
              if (controller.isLastPage == false) {
                await controller.getChatLists(
                    controller.pageCount, controller.userId);
              }
              controller.isLoading = false;
              controller.update();
            }
          }
        });
        controller.isOverlayOpen = false;
        controller.isChatMessageEdit = false;
        controller.sendMessageController.clear();
        if (controller.chatMessageList.isNotEmpty) {
          controller.postSeenMessage(controller.chatMessageList.first.id ?? "");
        }
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
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).size.height * 0.034),
            child: Scaffold(
              appBar: GradientAppBar(
                //     shadowColor: ColorsValue.greyAAAAAA,
                //   backgroundColor: ColorsValue.white,
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
                //  titleSpacing: Dimens.five,
                title: InkWell(
                  onTap: () {
                    RouteManagement.goToChatUserProfileScreen(
                        controller.userId ?? "");
                  },
                  child: Row(
                    children: [
                      Flexible(
                        child: Container(
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
                                  (controller.getOneFriendsData?.profileimage ??
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
                      ),
                      Dimens.boxWidth10,
                      Flexible(
                        child: Text(
                          controller.getOneFriendsData?.fullname?.isNotEmpty ??
                                  false
                              ? controller.getOneFriendsData?.fullname ?? ""
                              : controller.getOneFriendsData?.nickname ?? "",
                          style: Styles.black70016,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      // Flexible(
                      //   child: Column(
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Text(
                      //         controller.getOneFriendsData?.fullname
                      //                     ?.isNotEmpty ??
                      //                 false
                      //             ? controller.getOneFriendsData?.fullname ?? ""
                      //             : controller.getOneFriendsData?.nickname ?? "",
                      //         style: Styles.black70016,
                      //         maxLines: 1,
                      //         overflow: TextOverflow.ellipsis,
                      //       ),
                      //       Dimens.boxHeight5,
                      //       Text(
                      //         controller.getOneFriendsData?.isOnline ?? false
                      //             ? "Online".tr
                      //             : "Offline",
                      //         style: Styles.main40012,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                ),
                actions: [
                  if ((controller
                          .getOneFriendsData?.businessprofiles?.isNotEmpty ??
                      false) && !(controller.getOneFriendsData?.isBlocked ?? false)) ...[
                    InkWell(
                      onTap: () {
                        RouteManagement.goToChatProductScreen(false);
                      },
                      child: Container(
                        height: double.maxFinite,
                        width: Dimens.thirty,
                        padding: Dimens.edgeInsets3,
                        child: SvgPicture.asset(
                          AssetConstants.ic_products,
                          colorFilter: const ColorFilter.mode(
                            ColorsValue.blackColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                  ],
                  Dimens.boxWidth10,
                  if ((((controller
                              .getOneFriendsData?.usersPermissions?.videocall ??
                          controller
                              .getOneFriendsData?.yourPermissions?.videocall) ??
                      true) && (controller.userId != Get.find<Repository>().getStringValue(LocalKeys.userIds))) && !(controller.getOneFriendsData?.isBlocked ?? false)) ...[
                    InkWell(
                      onTap: () async {
                        if (await Utility.cameraPermissionCheack(context) &&
                            await Utility.microphonePermissionCheack(context)) {
                          controller.postCallInitaite(
                            isLoading: true,
                            receiverId: controller.userId ?? '',
                            isAudioCall: false,
                            isGroupCall: false,
                            isVideoCall: true,
                          );
                        }
                      },
                      child: Container(
                        height: double.maxFinite,
                        width: Dimens.thirty,
                        padding: Dimens.edgeInsets3,
                        child: SvgPicture.asset(
                          AssetConstants.videoIcon,
                        ),
                      ),
                    ),
                    Dimens.boxWidth10,
                  ],
                  if ((((controller
                              .getOneFriendsData?.usersPermissions?.audiocall ??
                          controller
                              .getOneFriendsData?.yourPermissions?.audiocall) ??
                      true) && (controller.userId != Get.find<Repository>().getStringValue(LocalKeys.userIds))) && !(controller.getOneFriendsData?.isBlocked ?? false)) ...[
                    InkWell(
                      onTap: () async {
                        if (await Utility.microphonePermissionCheack(context)) {
                          controller.postCallInitaite(
                            isLoading: true,
                            receiverId: controller.userId ?? '',
                            isAudioCall: true,
                            isGroupCall: false,
                            isVideoCall: false,
                          );
                        }
                      },
                      child: Container(
                        height: double.maxFinite,
                        width: Dimens.thirty,
                        padding: Dimens.edgeInsets3,
                        child: SvgPicture.asset(
                          AssetConstants.audioIcon,
                        ),
                      ),
                    ),
                    Dimens.boxWidth5,
                  ],
                  GestureDetector(
                    onTapUp: (details) {
                      final offset = details.globalPosition;
                      final String currentUserId = Get.find<Repository>().getStringValue(LocalKeys.userIds);
                      final String targetUserId = controller.getOneFriendsData?.userid ?? controller.userId ?? '';
                      final bool isSelf = currentUserId == targetUserId;
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
                          if (!isSelf) ...[
                            PopupMenuItem(
                              value: 4,
                              child: Text(
                                "Report User",
                                style: Styles.black40016,
                              ),
                            ),
                            PopupMenuItem(
                              value: 5,
                              child: Text(
                                (controller.getOneFriendsData?.isBlocked ?? false)
                                    ? "Unblock User"
                                    : "Block User",
                                style: Styles.black40016,
                              ),
                            ),
                          ],
                        ],
                      ).then((value) {
                        if (value == 1) {
                          RouteManagement.goToSharedMediascreen(
                              controller.getOneFriendsData?.userid ?? "",
                              false,
                              controller.getOneFriendsData?.fullname?.isEmpty ??
                                      false
                                  ? controller.getOneFriendsData?.nickname ?? ""
                                  : controller.getOneFriendsData?.fullname ??
                                      "",
                              false);
                        } else if (value == 2) {
                          if (controller.isSearch) {
                            controller.isSearch = false;
                          } else {
                            controller.isSearch = true;
                          }
                          controller.update();
                        } else if (value == 3) {
                          RouteManagement.goToChatWallpaperScreen();
                        } else if (value == 4) {
                          controller.reasonController.clear();
                          controller.selectedReportReason = 'Spam';
                          controller.update();
                          RouteManagement.goToReportUserScreen(
                              controller.getOneFriendsData?.userid ?? "");
                        } else if (value == 5) {
                          final isBlocked = controller.getOneFriendsData?.isBlocked ?? false;
                          if (isBlocked) {
                            Get.dialog(
                              CupertinoAlertDialog(
                                title: const Text("Unblock User"),
                                content: const Text("Are you sure you want to unblock this user?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text("Unblock"),
                                    onPressed: () async {
                                      Get.back(); // Close dialog
                                      Utility.showLoader();
                                      try {
                                        final targetUserId = controller.getOneFriendsData?.userid ?? "";
                                        await Get.find<UserSafetyService>().unblockUser(userId: targetUserId);
                                        // Refresh details immediately
                                        await controller.getOneFriends(targetUserId);
                                        // Refresh chat list in background
                                        Get.find<ChatController>().chatPagingController.refresh();
                                        Utility.closeLoader();
                                        Utility.showMessage("User unblocked successfully", MessageType.success, null, "OK");
                                      } catch (e) {
                                        Utility.closeLoader();
                                        Utility.showMessage("Failed to unblock user: ${e.toString()}", MessageType.error, null, "OK");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          } else {
                            Get.dialog(
                              CupertinoAlertDialog(
                                title: const Text("Block User"),
                                content: const Text("Are you sure you want to block this user?"),
                                actions: [
                                  CupertinoDialogAction(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Get.back();
                                    },
                                  ),
                                  CupertinoDialogAction(
                                    isDestructiveAction: true,
                                    child: const Text("Block"),
                                    onPressed: () async {
                                      Get.back(); // Close dialog
                                      Utility.showLoader();
                                      try {
                                        final targetUserId = controller.getOneFriendsData?.userid ?? "";
                                        await Get.find<UserSafetyService>().blockUser(userId: targetUserId);
                                        // Refresh details immediately
                                        await controller.getOneFriends(targetUserId);
                                        // Refresh chat list in background
                                        Get.find<ChatController>().chatPagingController.refresh();
                                        Utility.closeLoader();
                                        Utility.showMessage("User blocked successfully", MessageType.success, null, "OK");
                                      } catch (e) {
                                        Utility.closeLoader();
                                        Utility.showMessage("Failed to block user: ${e.toString()}", MessageType.error, null, "OK");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          }
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
              resizeToAvoidBottomInset: true,
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
                        if (controller.isSearch) ...[
                          CustomTextFormField(
                            controller: controller.chatSearchController,
                            hintText: 'search'.tr,
                            fillColor: ColorsValue.textfildbackcolor,
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isSearch = false;
                                controller.chatSearchController.clear();
                                controller.getChatLists(1, controller.userId);
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
                                    return controller.getChatLists(
                                        1, controller.userId);
                                  },
                                );
                              });
                            },
                          ),
                        ],
                        Flexible(
                          child: RefreshIndicator(
                            onRefresh: () => Future.sync(
                              () =>
                                  controller.getChatLists(1, controller.userId),
                            ),
                            color: ColorsValue.appColor,
                            child: controller.chatMessageList.isEmpty
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsValue.appColor,
                                    ),
                                  )
                                : ListView.builder(
                                    reverse: true,
                                    controller: controller.scrollController,
                                    itemCount:
                                        controller.chatMessageList.length,
                                    itemBuilder: (context, index) {
                                      bool isSameDate = false;
                                      String? newDate = '';
                                      if (index == 0 &&
                                          controller.chatMessageList.length ==
                                              1) {
                                        newDate = controller
                                            .groupMessageDateAndTime(controller
                                                .chatMessageList[index]
                                                .senttimestamp
                                                .toString())
                                            .toString();
                                      } else if (index ==
                                          controller.chatMessageList.length -
                                              1) {
                                        newDate = controller
                                            .groupMessageDateAndTime(controller
                                                .chatMessageList[index]
                                                .senttimestamp
                                                .toString())
                                            .toString();
                                      } else {
                                        final DateTime date = controller
                                            .returnDateAndTimeFormat(controller
                                                .chatMessageList[index]
                                                .senttimestamp
                                                .toString());
                                        final DateTime prevDate = controller
                                            .returnDateAndTimeFormat(controller
                                                .chatMessageList[index + 1]
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
                                                .groupMessageDateAndTime(
                                                    controller
                                                        .chatMessageList[index]
                                                        .senttimestamp
                                                        .toString())
                                                .toString();
                                      }
                                      return Column(
                                        children: [
                                          if (controller.chatMessageList[index]
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
                                            if (Get.find<Repository>()
                                                .getBoolValue(
                                                    LocalKeys.isSubUser)) ...[
                                              Row(
                                                crossAxisAlignment: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .subuser
                                                                ?.id ||
                                                        Get.find<Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatMessageList[
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
                                                                .chatMessageList[
                                                                    index]
                                                                .subuser
                                                                ?.id ||
                                                        Get.find<Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .parentUserId) ==
                                                            controller
                                                                .chatMessageList[
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
                                                            BorderRadius
                                                                .circular(Dimens
                                                                    .fifty)),
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
                                                                    .chatMessageList[
                                                                        index]
                                                                    .from
                                                                    ?.profileimage ??
                                                                ""),
                                                        fit: BoxFit.cover,
                                                        placeholder:
                                                            (context, url) {
                                                          return Image.asset(
                                                            AssetConstants
                                                                .usera,
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                        errorWidget: (context,
                                                            url, error) {
                                                          return Image.asset(
                                                            AssetConstants
                                                                .usera,
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
                                                                .chatMessageList[
                                                                    index]
                                                                .subuser
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatMessageList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            "",
                                                    style: Styles.main40012,
                                                  )
                                                ],
                                              ),
                                              Dimens.boxHeight5,
                                            ],
                                          ],
                                          ListView.builder(
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: 1,
                                            itemBuilder: (context, i) {
                                              if (controller
                                                  .chatMessageList[index]
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
                                                    .chatMessageList[index]
                                                    .contentType) {
                                                  case 'label':
                                                    return LabelMessage(
                                                      message: controller
                                                              .chatMessageList[
                                                                  index]
                                                              .content
                                                              ?.text
                                                              .message ??
                                                          "",
                                                    );
                                                  case 'text':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      switch (controller
                                                          .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                            .chatMessageList[index]);
                                                              },
                                                              child:
                                                                  ReplayMessage(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                            .chatMessageList[index]);
                                                              },
                                                              child:
                                                                  ImageWithText(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                images: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .path ??
                                                                    "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                              ),
                                                            ),
                                                          );
                                                        case 'links':
                                                          final linkMessage =
                                                              controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message ??
                                                                  "";
                                                          final isLinkSender = Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>()
                                                                      .getStringValue(LocalKeys
                                                                          .userIds) ==
                                                                  controller
                                                                      .chatMessageList[index]
                                                                      .from
                                                                      ?.id;

                                                          if (linkMessage.contains(
                                                              "/meeting/join/")) {
                                                            return Align(
                                                              alignment: isLinkSender
                                                                  ? Alignment
                                                                      .centerRight
                                                                  : Alignment
                                                                      .centerLeft,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                child:
                                                                    MeetingLinkCard(
                                                                  meetingUrl:
                                                                      linkMessage,
                                                                  isSend:
                                                                      isLinkSender,
                                                                ),
                                                              ),
                                                            );
                                                          }
                                                          return SwipeTo(
                                                            onRightSwipe:
                                                                (details) {
                                                              controller
                                                                      .isReplyChat =
                                                                  true;
                                                              controller
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  LinksWithText(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                                replayChat: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  DocsWithText(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .context
                                                                    ?.senttimestamp),
                                                                fileName: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .name ??
                                                                    "",
                                                                extensions: controller
                                                                        .chatMessageList[
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
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  VideoWithText(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                video: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .path ??
                                                                    "",
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child: controller
                                                                        .chatMessageList[
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
                                                                          .infoMessageDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatMessageList[index],
                                                                      );
                                                                    },
                                                                    child:
                                                                        ReplayContactWithMessage(
                                                                      isEdited: controller
                                                                              .chatMessageList[index]
                                                                              .isedited ??
                                                                          false,
                                                                      emoji: controller
                                                                              .chatMessageList[index]
                                                                              .reactions ??
                                                                          [],
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isBookmark: controller
                                                                              .chatMessageList[index]
                                                                              .bookmarks
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isFavorites: controller
                                                                              .chatMessageList[index]
                                                                              .favorites
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? "You"
                                                                          : controller.chatMessageList[index].from?.fullname ??
                                                                              controller.chatMessageList[index].from?.nickname ??
                                                                              "",
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      message: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      images: controller
                                                                              .chatMessageList[index]
                                                                              .context
                                                                              ?.content
                                                                              ?.contact[0]
                                                                              .userid
                                                                              ?.profileimage ??
                                                                          "",
                                                                      isDelivered: controller.chatMessageList[index].status ==
                                                                              "delivered"
                                                                          ? true
                                                                          : false,
                                                                      isSeen: controller.chatMessageList[index].status ==
                                                                              "seen"
                                                                          ? true
                                                                          : false,
                                                                      time: Utility
                                                                          .getTimeStempToTimeHHMMAA(
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .senttimestamp,
                                                                      ),
                                                                      replayChat: controller
                                                                              .chatMessageList[index]
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
                                                                      ChatScreenUtility
                                                                          .infoMessageDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatMessageList[index],
                                                                      );
                                                                    },
                                                                    child:
                                                                        ReplayMultiContactWithMessage(
                                                                      isEdited: controller
                                                                              .chatMessageList[index]
                                                                              .isedited ??
                                                                          false,
                                                                      emoji: controller
                                                                              .chatMessageList[index]
                                                                              .reactions ??
                                                                          [],
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isBookmark: controller
                                                                              .chatMessageList[index]
                                                                              .bookmarks
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isFavorites: controller
                                                                              .chatMessageList[index]
                                                                              .favorites
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? "You"
                                                                          : controller.chatMessageList[index].from?.fullname ??
                                                                              controller.chatMessageList[index].from?.nickname ??
                                                                              "",
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                              controller.chatMessageList[index].subuser?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      message: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      isDelivered: controller.chatMessageList[index].status ==
                                                                              "delivered"
                                                                          ? true
                                                                          : false,
                                                                      isSeen: controller.chatMessageList[index].status ==
                                                                              "seen"
                                                                          ? true
                                                                          : false,
                                                                      time: Utility
                                                                          .getTimeStempToTimeHHMMAA(
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .senttimestamp,
                                                                      ),
                                                                      replayChat: controller
                                                                              .chatMessageList[index]
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
                                                                        .chatListsDoc =
                                                                    controller
                                                                            .chatMessageList[
                                                                        index];
                                                                controller
                                                                    .update();
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
                                                                            .chatMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    AudioWithText(
                                                                  emoji: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                      ? "You"
                                                                      : controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.nickname ??
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.fullname ??
                                                                          "",
                                                                  isSend: Get.find<
                                                                              Repository>()
                                                                          .getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                      ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                          Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                              controller.chatMessageList[index].from?.id
                                                                      : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? true
                                                                          : false,
                                                                  message: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  isDelivered: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  isEdited: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  PollWithText(
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                            .chatMessageList[index]);
                                                              },
                                                              child:
                                                                  LocationWithText(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        TextWithPhotoWithText(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isGroup:
                                                                          false,
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        TextWithVideoWithText(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isGroup:
                                                                          false,
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        TextWithProductWithText(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        ReplayVideoCallWithMessage(
                                                                      isGroup:
                                                                          false,
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        ReplayAudioCallWithMessage(
                                                                      isGroup:
                                                                          false,
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  PhoneShareTextContact(
                                                                contactName: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.phonecontact
                                                                        ?.name ??
                                                                    " -- ",
                                                                images: '',
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        "",
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  ReplayMessage(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                              ),
                                                            ),
                                                          );
                                                      }
                                                    } else {
                                                      var messageContent =
                                                          controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "";
                                                      if (messageContent.contains(
                                                          "/meeting/join/")) {
                                                        return MeetingLinkCard(
                                                          meetingUrl:
                                                              messageContent,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                        );
                                                      }
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatMessageList[
                                                                        index]);
                                                          },
                                                          child: OnlyMessage(
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            message: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            isEdited: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isedited ??
                                                                false,
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBrodcast: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isbroadcasted ??
                                                                false,
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  case 'photo':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayPhotoMessage(
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                              isGroup: false,
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatMessageList[
                                                                        index]);
                                                          },
                                                          child: SingleImageMsg(
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            images: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                            isBrodcast: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isbroadcasted ??
                                                                false,
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child: ImageWithLinks(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          images: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child: ImageWithText(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          images: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                        ),
                                                      ),
                                                    );
                                                  case 'statusreply':
                                                    return SwipeTo(
                                                      onRightSwipe: (details) {
                                                        controller.isReplyChat =
                                                            true;
                                                        controller
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child:
                                                            StatusReplyMessage(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller
                                                                .postChatMessageUnReaction(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .id,
                                                            );
                                                          },
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .senttimestamp,
                                                          ),
                                                          statusReply: controller
                                                              .chatMessageList[
                                                                  index]
                                                              .content
                                                              ?.statusreply,
                                                          onTap: () {
                                                            controller
                                                                .fetchUserStatusAndNavigate(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.statusreply
                                                                  ?.statusOwnerId,
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.statusreply
                                                                  ?.statusid,
                                                            );
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                        ),
                                                      ),
                                                    );
                                                  case 'links':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      switch (controller
                                                          .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  TextWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                onTap: () {
                                                                  Utility.launchLinkURL(controller
                                                                          .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child: controller
                                                                        .chatMessageList[
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
                                                                          .infoMessageDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatMessageList[index],
                                                                      );
                                                                    },
                                                                    child:
                                                                        ReplayContactWithLinks(
                                                                      isEdited: controller
                                                                              .chatMessageList[index]
                                                                              .isedited ??
                                                                          false,
                                                                      emoji: controller
                                                                              .chatMessageList[index]
                                                                              .reactions ??
                                                                          [],
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isBookmark: controller
                                                                              .chatMessageList[index]
                                                                              .bookmarks
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isFavorites: controller
                                                                              .chatMessageList[index]
                                                                              .favorites
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? "You"
                                                                          : controller.chatMessageList[index].from?.fullname ??
                                                                              controller.chatMessageList[index].from?.nickname ??
                                                                              "",
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      message: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      images: controller
                                                                              .chatMessageList[index]
                                                                              .context
                                                                              ?.content
                                                                              ?.contact[0]
                                                                              .userid
                                                                              ?.profileimage ??
                                                                          "",
                                                                      isDelivered: controller.chatMessageList[index].status ==
                                                                              "delivered"
                                                                          ? true
                                                                          : false,
                                                                      isSeen: controller.chatMessageList[index].status ==
                                                                              "seen"
                                                                          ? true
                                                                          : false,
                                                                      time: Utility
                                                                          .getTimeStempToTimeHHMMAA(
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .senttimestamp,
                                                                      ),
                                                                      replayChat: controller
                                                                              .chatMessageList[index]
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
                                                                      ChatScreenUtility
                                                                          .infoMessageDialog(
                                                                        context,
                                                                        details,
                                                                        controller
                                                                            .chatMessageList[index],
                                                                      );
                                                                    },
                                                                    child:
                                                                        ReplayMultiContactWithLinks(
                                                                      isEdited: controller
                                                                              .chatMessageList[index]
                                                                              .isedited ??
                                                                          false,
                                                                      emoji: controller
                                                                              .chatMessageList[index]
                                                                              .reactions ??
                                                                          [],
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isBookmark: controller
                                                                              .chatMessageList[index]
                                                                              .bookmarks
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isFavorites: controller
                                                                              .chatMessageList[index]
                                                                              .favorites
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      userName: Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? "You"
                                                                          : controller.chatMessageList[index].from?.fullname ??
                                                                              controller.chatMessageList[index].from?.nickname ??
                                                                              "",
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      message: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      isDelivered: controller.chatMessageList[index].status ==
                                                                              "delivered"
                                                                          ? true
                                                                          : false,
                                                                      isSeen: controller.chatMessageList[index].status ==
                                                                              "seen"
                                                                          ? true
                                                                          : false,
                                                                      time: Utility
                                                                          .getTimeStempToTimeHHMMAA(
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .senttimestamp,
                                                                      ),
                                                                      replayChat: controller
                                                                              .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  ImageWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .context
                                                                            ?.status ==
                                                                        "sent"
                                                                    ? true
                                                                    : false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                images: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .path ??
                                                                    "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                    .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  VideoWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .context
                                                                            ?.status ==
                                                                        "sent"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                video: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .path ??
                                                                    "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  DocsWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .context
                                                                            ?.status ==
                                                                        "sent"
                                                                    ? true
                                                                    : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                fileName: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .name ??
                                                                    "",
                                                                extensions: controller
                                                                        .chatMessageList[
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
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.media
                                                                        .path ??
                                                                    "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  AudioWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility.getTimeStempToTimeHHMMAA(controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                            .chatMessageList[index]);
                                                              },
                                                              child:
                                                                  LocationWithLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  ReplayLinks(
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                replayChat: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  PollWithLinks(
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        "",
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        LinksWithPhotoWithLinks(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isGroup:
                                                                          false,
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        LinksWithVideoWithLinks(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isGroup:
                                                                          false,
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        LinksWithProductWithLinks(
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        ReplayVideoCallWithLinks(
                                                                      isGroup:
                                                                          false,
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
                                                            },
                                                            child:
                                                                GestureDetector(
                                                                    onLongPressStart:
                                                                        (details) {
                                                                      ChatScreenUtility.infoMessageDialog(
                                                                          context,
                                                                          details,
                                                                          controller
                                                                              .chatMessageList[index]);
                                                                    },
                                                                    child:
                                                                        ReplayAudioCallWithLinks(
                                                                      isGroup:
                                                                          false,
                                                                      chatListsDocData:
                                                                          controller
                                                                              .chatMessageList[index],
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child:
                                                                  PhoneShareLinksContact(
                                                                contactName: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .context
                                                                        ?.content
                                                                        ?.phonecontact
                                                                        ?.name ??
                                                                    " -- ",
                                                                images: '',
                                                                isEdited: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .isedited ??
                                                                    false,
                                                                emoji: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .reactions ??
                                                                    [],
                                                                onEmojiRemove:
                                                                    () {
                                                                  controller.postChatMessageUnReaction(
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .id);
                                                                },
                                                                isBookmark: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .bookmarks
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                isFavorites: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .favorites
                                                                        ?.isNotEmpty ??
                                                                    false,
                                                                userName: Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                    ? "You"
                                                                    : controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.fullname ??
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.nickname ??
                                                                        "",
                                                                isSend: Get.find<
                                                                            Repository>()
                                                                        .getBoolValue(LocalKeys
                                                                            .isSubUser)
                                                                    ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .subuser
                                                                                ?.id ||
                                                                        Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                            controller
                                                                                .chatMessageList[
                                                                                    index]
                                                                                .from
                                                                                ?.id
                                                                    : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                            controller.chatMessageList[index].from?.id
                                                                        ? true
                                                                        : false,
                                                                message: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.text
                                                                        .message ??
                                                                    "",
                                                                isDelivered: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "delivered"
                                                                    ? true
                                                                    : false,
                                                                isSeen: controller
                                                                            .chatMessageList[index]
                                                                            .status ==
                                                                        "seen"
                                                                    ? true
                                                                    : false,
                                                                time: Utility
                                                                    .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp,
                                                                ),
                                                                replayChat: controller
                                                                        .chatMessageList[
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
                                                                      .chatListsDoc =
                                                                  controller
                                                                          .chatMessageList[
                                                                      index];
                                                              controller
                                                                  .update();
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
                                                                          .chatMessageList[
                                                                      index],
                                                                );
                                                              },
                                                              child: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message
                                                                          .contains(
                                                                              "/meeting/join/") ==
                                                                      true
                                                                  ? Align(
                                                                      alignment: (Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
                                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id || Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                              : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id)
                                                                          ? Alignment.centerRight
                                                                          : Alignment.centerLeft,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            bottom:
                                                                                10),
                                                                        child:
                                                                            MeetingLinkCard(
                                                                          meetingUrl:
                                                                              controller.chatMessageList[index].content?.text.message ?? "",
                                                                          isSend: Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
                                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id || Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                              : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id,
                                                                        ),
                                                                      ),
                                                                    )
                                                                  : LinkMessage(
                                                                      emoji: controller
                                                                              .chatMessageList[index]
                                                                              .reactions ??
                                                                          [],
                                                                      onEmojiRemove:
                                                                          () {
                                                                        controller.postChatMessageUnReaction(controller
                                                                            .chatMessageList[index]
                                                                            .id);
                                                                      },
                                                                      isBookmark: controller
                                                                              .chatMessageList[index]
                                                                              .bookmarks
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isFavorites: controller
                                                                              .chatMessageList[index]
                                                                              .favorites
                                                                              ?.isNotEmpty ??
                                                                          false,
                                                                      isDelivered: controller.chatMessageList[index].status ==
                                                                              "delivered"
                                                                          ? true
                                                                          : false,
                                                                      isSeen: controller.chatMessageList[index].status ==
                                                                              "seen"
                                                                          ? true
                                                                          : false,
                                                                      isEdited: controller
                                                                              .chatMessageList[index]
                                                                              .isedited ??
                                                                          false,
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                              ? true
                                                                              : false,
                                                                      message: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      time: Utility
                                                                          .getTimeStempToTimeHHMMAA(
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .senttimestamp,
                                                                      ),
                                                                    ),
                                                            ),
                                                          );
                                                      }
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.text
                                                                      .message
                                                                      .contains(
                                                                          "/meeting/join/") ==
                                                                  true
                                                              ? Align(
                                                                  alignment: (Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id)
                                                                      ? Alignment.centerRight
                                                                      : Alignment.centerLeft,
                                                                  child:
                                                                      Padding(
                                                                    padding: const EdgeInsets
                                                                        .only(
                                                                        bottom:
                                                                            10),
                                                                    child:
                                                                        MeetingLinkCard(
                                                                      meetingUrl: controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.text
                                                                              .message ??
                                                                          "",
                                                                      isSend: Get.find<Repository>().getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                          ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                              Get.find<Repository>().getStringValue(LocalKeys.parentUserId) == controller.chatMessageList[index].from?.id
                                                                          : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id,
                                                                    ),
                                                                  ),
                                                                )
                                                              : LinkMessage(
                                                                  emoji: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isDelivered: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  isEdited: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .isedited ??
                                                                      false,
                                                                  isSend: Get.find<
                                                                              Repository>()
                                                                          .getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                      ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                          Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                              controller.chatMessageList[index].from?.id
                                                                      : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? true
                                                                          : false,
                                                                  message: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.text
                                                                          .message ??
                                                                      "",
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                ),
                                                        ),
                                                      );
                                                    }
                                                  case 'docs':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayDocsMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: DocsMessage(
                                                            onTap: () {
                                                              Utility.downloadAndSavePDF(
                                                                  controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.media
                                                                          .path ??
                                                                      "",
                                                                  'Cochat',
                                                                  0);
                                                              controller
                                                                  .update();
                                                            },
                                                            isBrodcast: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isbroadcasted ??
                                                                false,
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .subuser
                                                                        ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            fileName: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.media
                                                                    .name ??
                                                                "",
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                            fileUrl: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            extensions: controller
                                                                    .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: DocsWithText(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                          fileName: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .name ??
                                                              "",
                                                          extensions: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .name
                                                                  .split('.')
                                                                  .last ??
                                                              "",
                                                          fileUrl: controller
                                                                  .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: DocsWithLinks(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                          fileName: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .name ??
                                                              "",
                                                          extensions: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .name
                                                                  .split('.')
                                                                  .last ??
                                                              "",
                                                          fileUrl: controller
                                                                  .chatMessageList[
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
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayVideoMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: SingleVideoMsg(
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            video: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: VideoWithText(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          video: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: VideoWithLinks(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          video: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.media
                                                                  .path ??
                                                              "",
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                        ),
                                                      ),
                                                    );
                                                  case 'audio':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayAudioMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child: MusicPlay(
                                                            isBrodcast: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isbroadcasted ??
                                                                false,
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            audioUrl: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.media
                                                                    .path ??
                                                                "",
                                                            message: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.text
                                                                    .message ??
                                                                "",
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: AudioWithText(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                          userName: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? "You"
                                                              : controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.fullname ??
                                                                  controller
                                                                      .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: AudioWithLinks(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .senttimestamp),
                                                          userName: Get.find<
                                                                          Repository>()
                                                                      .getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.id
                                                              ? "You"
                                                              : controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.fullname ??
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .from
                                                                      ?.nickname ??
                                                                  "",
                                                        ),
                                                      ),
                                                    );
                                                  case 'location':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayLocationMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child:
                                                              ShareCurrentLocation(
                                                            isBrodcast: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .isbroadcasted ??
                                                                false,
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            time: Utility.getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                            businessProfileLatLag:
                                                                LatLng(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.location
                                                                  .coordinates[1],
                                                              controller
                                                                  .chatMessageList[
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
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.location
                                                                    .coordinates[1],
                                                                controller
                                                                    .chatMessageList[
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
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayContactMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .content
                                                                    ?.contact
                                                                    .length ==
                                                                1
                                                            ? GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ShareContact(
                                                                  onMessageTap:
                                                                      () {
                                                                    if (controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .content
                                                                            ?.contact[
                                                                                0]
                                                                            .isfriend ==
                                                                        "no") {
                                                                      Get.dialog(
                                                                          SentRequestDialog(
                                                                        formKey:
                                                                            controller.sendRequestKey,
                                                                        title: controller.chatMessageList[index].content?.contact[0].userdata?.nickname ??
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
                                                                                controller.chatMessageList[index].content?.contact[0].usersid ?? "",
                                                                                controller.messageController.text,
                                                                                index,
                                                                                false,
                                                                                false);
                                                                          }
                                                                        },
                                                                      ));
                                                                    } else if (controller
                                                                            .chatMessageList[index]
                                                                            .content
                                                                            ?.contact[0]
                                                                            .isfriend ==
                                                                        "sent") {
                                                                      controller.cancelSentRequest(
                                                                          controller.chatMessageList[index].content?.contact[0].friendrequestid ??
                                                                              "",
                                                                          index,
                                                                          false,
                                                                          false);
                                                                    } else {
                                                                      controller.getOneFriends(controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact
                                                                          .first
                                                                          .userdata
                                                                          ?.id);
                                                                      controller.getChatLists(
                                                                          1,
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .content
                                                                              ?.contact
                                                                              .first
                                                                              .userdata
                                                                              ?.id);
                                                                    }
                                                                  },
                                                                  emoji: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isDelivered: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  isSend: Get.find<
                                                                              Repository>()
                                                                          .getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                      ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                          Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                              controller.chatMessageList[index].from?.id
                                                                      : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? true
                                                                          : false,
                                                                  contactList: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact ??
                                                                      [],
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                ),
                                                              )
                                                            : GestureDetector(
                                                                onLongPressStart:
                                                                    (details) {
                                                                  ChatScreenUtility
                                                                      .infoMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatMessageList[
                                                                        index],
                                                                  );
                                                                },
                                                                child:
                                                                    ShareMultipulConect(
                                                                  emoji: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .reactions ??
                                                                      [],
                                                                  onEmojiRemove:
                                                                      () {
                                                                    controller.postChatMessageUnReaction(controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                                  },
                                                                  isBookmark: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .bookmarks
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isFavorites: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .favorites
                                                                          ?.isNotEmpty ??
                                                                      false,
                                                                  isDelivered: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "delivered"
                                                                      ? true
                                                                      : false,
                                                                  isSeen: controller
                                                                              .chatMessageList[index]
                                                                              .status ==
                                                                          "seen"
                                                                      ? true
                                                                      : false,
                                                                  isSend: Get.find<
                                                                              Repository>()
                                                                          .getBoolValue(LocalKeys
                                                                              .isSubUser)
                                                                      ? Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].subuser?.id ||
                                                                          Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                              controller.chatMessageList[index].from?.id
                                                                      : Get.find<Repository>().getStringValue(LocalKeys.userIds) == controller.chatMessageList[index].from?.id
                                                                          ? true
                                                                          : false,
                                                                  contactList: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact ??
                                                                      [],
                                                                  onTap: () {
                                                                    controller
                                                                        .getContactList
                                                                        .clear();
                                                                    RouteManagement.goToViewAllContact(controller
                                                                            .chatMessageList[index]
                                                                            .content
                                                                            ?.contact ??
                                                                        []);
                                                                  },
                                                                  time: Utility
                                                                      .getTimeStempToTimeHHMMAA(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .senttimestamp,
                                                                  ),
                                                                ),
                                                              ),
                                                      );
                                                    }
                                                  // case 'poll':
                                                  //   if (controller
                                                  //           .chatMessageList[
                                                  //               index]
                                                  //           .context !=
                                                  //       null) {
                                                  //     return SwipeTo(
                                                  //       onRightSwipe: (details) {
                                                  //         controller.isReplyChat =
                                                  //             true;
                                                  //         controller
                                                  //                 .chatListsDoc =
                                                  //             controller
                                                  //                     .chatMessageList[
                                                  //                 index];
                                                  //         controller.update();
                                                  //       },
                                                  //       child: GestureDetector(
                                                  //           onLongPressStart:
                                                  //               (details) {
                                                  //             ChatScreenUtility
                                                  //                 .infoMessageDialog(
                                                  //                     context,
                                                  //                     details,
                                                  //                     controller
                                                  //                             .chatMessageList[
                                                  //                         index]);
                                                  //           },
                                                  //           child:
                                                  //               ReplayPollsMessage(
                                                  //             key: controller
                                                  //                 .chatMessageList[
                                                  //                     index]
                                                  //                 .content
                                                  //                 ?.poll
                                                  //                 .pollid
                                                  //                 ?.key,
                                                  //             onVote: (choice) {
                                                  //               controller.postPollVote(
                                                  //                   controller
                                                  //                       .chatMessageList[
                                                  //                           index]
                                                  //                       .content
                                                  //                       ?.poll,
                                                  //                   controller
                                                  //                           .chatMessageList[
                                                  //                               index]
                                                  //                           .content
                                                  //                           ?.poll
                                                  //                           .pollid
                                                  //                           ?.options[
                                                  //                               choice]
                                                  //                           .id ??
                                                  //                       "");
                                                  //             },
                                                  //             isGroup: false,
                                                  //             chatListsDocData:
                                                  //                 controller
                                                  //                         .chatMessageList[
                                                  //                     index],
                                                  //             isSend: Get.find<
                                                  //                         Repository>()
                                                  //                     .getBoolValue(
                                                  //                         LocalKeys
                                                  //                             .isSubUser)
                                                  //                 ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                  //                         controller
                                                  //                             .chatMessageList[
                                                  //                                 index]
                                                  //                             .subuser
                                                  //                             ?.id ||
                                                  //                     Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                  //                         controller
                                                  //                             .chatMessageList[
                                                  //                                 index]
                                                  //                             .from
                                                  //                             ?.id
                                                  //                 : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                  //                         controller
                                                  //                             .chatMessageList[index]
                                                  //                             .from
                                                  //                             ?.id
                                                  //                     ? true
                                                  //                     : false,
                                                  //             onEmojiRemove: () {
                                                  //               controller.postChatMessageUnReaction(
                                                  //                   controller
                                                  //                       .chatMessageList[
                                                  //                           index]
                                                  //                       .id);
                                                  //             },
                                                  //           )),
                                                  //     );
                                                  //   } else {
                                                  //     return SwipeTo(
                                                  //       onRightSwipe: (details) {
                                                  //         controller.isReplyChat =
                                                  //             true;
                                                  //         controller
                                                  //                 .chatListsDoc =
                                                  //             controller
                                                  //                     .chatMessageList[
                                                  //                 index];
                                                  //         controller.update();
                                                  //       },
                                                  //       child: GestureDetector(
                                                  //           onLongPressStart:
                                                  //               (details) {
                                                  //             ChatScreenUtility
                                                  //                 .infoMessageDialog(
                                                  //               context,
                                                  //               details,
                                                  //               controller
                                                  //                       .chatMessageList[
                                                  //                   index],
                                                  //             );
                                                  //           },
                                                  //           child: PollMessage(
                                                  //             key: controller
                                                  //                 .chatMessageList[
                                                  //                     index]
                                                  //                 .content
                                                  //                 ?.poll
                                                  //                 .pollid
                                                  //                 ?.key,
                                                  //             onVote: (choice) {
                                                  //               controller.postPollVote(
                                                  //                   controller
                                                  //                       .chatMessageList[
                                                  //                           index]
                                                  //                       .content
                                                  //                       ?.poll,
                                                  //                   controller
                                                  //                           .chatMessageList[
                                                  //                               index]
                                                  //                           .content
                                                  //                           ?.poll
                                                  //                           .pollid
                                                  //                           ?.options[
                                                  //                               choice]
                                                  //                           .id ??
                                                  //                       "");
                                                  //             },
                                                  //             isGroup: false,
                                                  //             chatListsDocData:
                                                  //                 controller
                                                  //                         .chatMessageList[
                                                  //                     index],
                                                  //             isSend: Get.find<
                                                  //                         Repository>()
                                                  //                     .getBoolValue(
                                                  //                         LocalKeys
                                                  //                             .isSubUser)
                                                  //                 ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                  //                         controller
                                                  //                             .chatMessageList[
                                                  //                                 index]
                                                  //                             .subuser
                                                  //                             ?.id ||
                                                  //                     Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                  //                         controller
                                                  //                             .chatMessageList[
                                                  //                                 index]
                                                  //                             .from
                                                  //                             ?.id
                                                  //                 : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                  //                         controller
                                                  //                             .chatMessageList[index]
                                                  //                             .from
                                                  //                             ?.id
                                                  //                     ? true
                                                  //                     : false,
                                                  //             onEmojiRemove: () {
                                                  //               controller.postChatMessageUnReaction(
                                                  //                   controller
                                                  //                       .chatMessageList[
                                                  //                           index]
                                                  //                       .id);
                                                  //             },
                                                  //           )),
                                                  //     );
                                                  //   }
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
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: SingleProduct(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .senttimestamp,
                                                          ),
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          productImage: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.image ??
                                                              "",
                                                          productPrice: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.price
                                                                  .toString() ??
                                                              "",
                                                          productTitle: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.name ??
                                                              "",
                                                          productdiscription: controller
                                                                  .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child:
                                                            ProductWithMessage(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .senttimestamp,
                                                          ),
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          productImage: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.image ??
                                                              "",
                                                          productPrice: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.price
                                                                  .toString() ??
                                                              "",
                                                          productTitle: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.name ??
                                                              "",
                                                          productdiscription: controller
                                                                  .chatMessageList[
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
                                                              .infoMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .chatMessageList[
                                                                index],
                                                          );
                                                        },
                                                        child: ProductWithLinks(
                                                          emoji: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .reactions ??
                                                              [],
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                          isBookmark: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .bookmarks
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isFavorites: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .favorites
                                                                  ?.isNotEmpty ??
                                                              false,
                                                          isDelivered: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "delivered"
                                                              ? true
                                                              : false,
                                                          isSeen: controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .status ==
                                                                  "seen"
                                                              ? true
                                                              : false,
                                                          isEdited: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .isedited ??
                                                              false,
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          time: Utility
                                                              .getTimeStempToTimeHHMMAA(
                                                            controller
                                                                .chatMessageList[
                                                                    index]
                                                                .senttimestamp,
                                                          ),
                                                          message: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.text
                                                                  .message ??
                                                              "",
                                                          productImage: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.image ??
                                                              "",
                                                          productPrice: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.price
                                                                  .toString() ??
                                                              "",
                                                          productTitle: controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .content
                                                                  ?.product
                                                                  .productid
                                                                  ?.name ??
                                                              "",
                                                          productdiscription: controller
                                                                  .chatMessageList[
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
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child: MultipalImage(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ));
                                                  case 'multimediawithtext':
                                                    return GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            MultipalImageWithText(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ));
                                                  case 'multimediawithlinks':
                                                    return GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child:
                                                            MultipalImageWithLinks(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                                    context,
                                                                    details,
                                                                    controller
                                                                            .chatMessageList[
                                                                        index]);
                                                          },
                                                          child: VideoCall(
                                                            isGroup: false,
                                                            chatListsDocData:
                                                                controller
                                                                        .chatMessageList[
                                                                    index],
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
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
                                                                .chatListsDoc =
                                                            controller
                                                                    .chatMessageList[
                                                                index];
                                                        controller.update();
                                                      },
                                                      child: GestureDetector(
                                                        onLongPressStart:
                                                            (details) {
                                                          ChatScreenUtility
                                                              .infoMessageDialog(
                                                                  context,
                                                                  details,
                                                                  controller
                                                                          .chatMessageList[
                                                                      index]);
                                                        },
                                                        child: AudioCall(
                                                          isGroup: false,
                                                          chatListsDocData:
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                          isSend: Get.find<Repository>()
                                                                  .getBoolValue(
                                                                      LocalKeys
                                                                          .isSubUser)
                                                              ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .subuser
                                                                          ?.id ||
                                                                  Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                      controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .from
                                                                          ?.id
                                                              : Get.find<Repository>().getStringValue(
                                                                          LocalKeys
                                                                              .userIds) ==
                                                                      controller
                                                                          .chatMessageList[index]
                                                                          .from
                                                                          ?.id
                                                                  ? true
                                                                  : false,
                                                          onEmojiRemove: () {
                                                            controller.postChatMessageUnReaction(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .id);
                                                          },
                                                        ),
                                                      ),
                                                    );
                                                  case 'phonecontact':
                                                    if (controller
                                                            .chatMessageList[
                                                                index]
                                                            .context !=
                                                        null) {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                            onLongPressStart:
                                                                (details) {
                                                              ChatScreenUtility
                                                                  .infoMessageDialog(
                                                                      context,
                                                                      details,
                                                                      controller
                                                                              .chatMessageList[
                                                                          index]);
                                                            },
                                                            child:
                                                                ReplayContactMessage(
                                                              isGroup: false,
                                                              chatListsDocData:
                                                                  controller
                                                                          .chatMessageList[
                                                                      index],
                                                              isSend: Get.find<
                                                                          Repository>()
                                                                      .getBoolValue(
                                                                          LocalKeys
                                                                              .isSubUser)
                                                                  ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .subuser
                                                                              ?.id ||
                                                                      Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                          controller
                                                                              .chatMessageList[
                                                                                  index]
                                                                              .from
                                                                              ?.id
                                                                  : Get.find<Repository>().getStringValue(LocalKeys
                                                                              .userIds) ==
                                                                          controller
                                                                              .chatMessageList[index]
                                                                              .from
                                                                              ?.id
                                                                      ? true
                                                                      : false,
                                                              onEmojiRemove:
                                                                  () {
                                                                controller.postChatMessageUnReaction(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .id);
                                                              },
                                                            )),
                                                      );
                                                    } else {
                                                      return SwipeTo(
                                                        onRightSwipe:
                                                            (details) {
                                                          controller
                                                                  .isReplyChat =
                                                              true;
                                                          controller
                                                                  .chatListsDoc =
                                                              controller
                                                                      .chatMessageList[
                                                                  index];
                                                          controller.update();
                                                        },
                                                        child: GestureDetector(
                                                          onLongPressStart:
                                                              (details) {
                                                            ChatScreenUtility
                                                                .infoMessageDialog(
                                                              context,
                                                              details,
                                                              controller
                                                                      .chatMessageList[
                                                                  index],
                                                            );
                                                          },
                                                          child:
                                                              PhoneShareContact(
                                                            onMessageTap: () {
                                                              if (controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.contact[
                                                                          0]
                                                                      .isfriend ==
                                                                  "no") {
                                                                Get.dialog(
                                                                    SentRequestDialog(
                                                                  formKey:
                                                                      controller
                                                                          .sendRequestKey,
                                                                  title: controller
                                                                          .chatMessageList[
                                                                              index]
                                                                          .content
                                                                          ?.contact[
                                                                              0]
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
                                                                      controller.sendNewFriendRequest(
                                                                          controller.chatMessageList[index].content?.contact[0].usersid ??
                                                                              "",
                                                                          controller
                                                                              .messageController
                                                                              .text,
                                                                          index,
                                                                          false,
                                                                          false);
                                                                    }
                                                                  },
                                                                ));
                                                              } else if (controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .content
                                                                      ?.contact[
                                                                          0]
                                                                      .isfriend ==
                                                                  "sent") {
                                                                controller.cancelSentRequest(
                                                                    controller
                                                                            .chatMessageList[index]
                                                                            .content
                                                                            ?.contact[0]
                                                                            .friendrequestid ??
                                                                        "",
                                                                    index,
                                                                    false,
                                                                    false);
                                                              } else {
                                                                controller.getOneFriends(
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact
                                                                        .first
                                                                        .userdata
                                                                        ?.id);
                                                                controller.getChatLists(
                                                                    1,
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .content
                                                                        ?.contact
                                                                        .first
                                                                        .userdata
                                                                        ?.id);
                                                              }
                                                            },
                                                            emoji: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .reactions ??
                                                                [],
                                                            onEmojiRemove: () {
                                                              controller.postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                            },
                                                            isBookmark: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .bookmarks
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isFavorites: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .favorites
                                                                    ?.isNotEmpty ??
                                                                false,
                                                            isDelivered: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "delivered"
                                                                ? true
                                                                : false,
                                                            isSeen: controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .status ==
                                                                    "seen"
                                                                ? true
                                                                : false,
                                                            isSend: Get.find<
                                                                        Repository>()
                                                                    .getBoolValue(
                                                                        LocalKeys
                                                                            .isSubUser)
                                                                ? Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .subuser
                                                                            ?.id ||
                                                                    Get.find<Repository>().getStringValue(LocalKeys.parentUserId) ==
                                                                        controller
                                                                            .chatMessageList[
                                                                                index]
                                                                            .from
                                                                            ?.id
                                                                : Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                                                                        controller
                                                                            .chatMessageList[index]
                                                                            .from
                                                                            ?.id
                                                                    ? true
                                                                    : false,
                                                            phoneContact: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .content
                                                                ?.phonecontact,
                                                            time: Utility
                                                                .getTimeStempToTimeHHMMAA(
                                                              controller
                                                                  .chatMessageList[
                                                                      index]
                                                                  .senttimestamp,
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }
                                                  default:
                                                    return GestureDetector(
                                                      onLongPressStart:
                                                          (details) {
                                                        ChatScreenUtility
                                                            .infoMessageDialog(
                                                          context,
                                                          details,
                                                          controller
                                                                  .chatMessageList[
                                                              index],
                                                        );
                                                      },
                                                      child: OnlyMessage(
                                                        isDelivered: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .status ==
                                                                "delivered"
                                                            ? true
                                                            : false,
                                                        isSeen: controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .status ==
                                                                "seen"
                                                            ? true
                                                            : false,
                                                        emoji: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .reactions ??
                                                            [],
                                                        onEmojiRemove: () {
                                                          controller
                                                              .postChatMessageUnReaction(
                                                                  controller
                                                                      .chatMessageList[
                                                                          index]
                                                                      .id);
                                                        },
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
                                                                    .chatMessageList[
                                                                        index]
                                                                    .subuser
                                                                    ?.id
                                                            : Get.find<Repository>()
                                                                        .getStringValue(LocalKeys
                                                                            .userIds) ==
                                                                    controller
                                                                        .chatMessageList[
                                                                            index]
                                                                        .from
                                                                        ?.id
                                                                ? true
                                                                : false,
                                                        message: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .content
                                                                ?.text
                                                                .message ??
                                                            "",
                                                        isEdited: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .isedited ??
                                                            false,
                                                        time: Utility
                                                            .getTimeStempToTimeHHMMAA(
                                                                controller
                                                                    .chatMessageList[
                                                                        index]
                                                                    .senttimestamp),
                                                        isBookmark: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .bookmarks
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isFavorites: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .favorites
                                                                ?.isNotEmpty ??
                                                            false,
                                                        isBrodcast: controller
                                                                .chatMessageList[
                                                                    index]
                                                                .isbroadcasted ??
                                                            false,
                                                      ),
                                                    );
                                                }
                                              }
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                          ),
                        ),
                        if (controller.getOneFriendsData?.isBlocked ?? false)
                          Container(
                            width: double.infinity,
                            margin: Dimens.edgeInsets20_0_20_20,
                            padding: Dimens.edgeInsets15,
                            decoration: BoxDecoration(
                              color: ColorsValue.greyE4E4E4.withOpacity(0.9),
                              borderRadius: BorderRadius.circular(Dimens.twelve),
                              border: Border.all(
                                color: ColorsValue.greyE4E4E4,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  controller.getOneFriendsData?.blockedBy == Get.find<Repository>().getStringValue(LocalKeys.userIds)
                                      ? "You have blocked this user.\nUnblock this user to continue chatting."
                                      : "This user has blocked you.",
                                  style: Styles.black70014,
                                  textAlign: TextAlign.center,
                                ),
                                if (controller.getOneFriendsData?.blockedBy == Get.find<Repository>().getStringValue(LocalKeys.userIds)) ...[
                                  Dimens.boxHeight8,
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorsValue.maincolor1,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(Dimens.six),
                                      ),
                                      padding: EdgeInsets.symmetric(
                                        horizontal: Dimens.twenty,
                                        vertical: Dimens.ten,
                                      ),
                                    ),
                                    onPressed: () async {
                                      Utility.showLoader();
                                      try {
                                        final targetUserId = controller.getOneFriendsData?.userid ?? "";
                                        await Get.find<UserSafetyService>().unblockUser(userId: targetUserId);
                                        // Refresh details immediately
                                        await controller.getOneFriends(targetUserId);
                                        // Refresh chat list in background
                                        Get.find<ChatController>().chatPagingController.refresh();
                                        Utility.closeLoader();
                                        Utility.showMessage("User unblocked successfully", MessageType.success, null, "OK");
                                      } catch (e) {
                                        Utility.closeLoader();
                                        Utility.showMessage("Failed to unblock user: ${e.toString()}", MessageType.error, null, "OK");
                                      }
                                    },
                                    child: const Text(
                                      "Unblock User",
                                      style: TextStyle(
                                        color: ColorsValue.white,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          )
                        else
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      if (controller.isReplyChat) ...[
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "text") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "photo") ...[
                                          ReplyImageMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            image: controller.chatListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "photowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                ?.content?.text.message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "photowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                ?.content?.text.message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "links") ...[
                                          ReplyLinksMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            image: controller.chatListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            message: controller.chatListsDoc
                                                ?.content?.text.message,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "docs") ...[
                                          ReplyDocsWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                ?.content?.media.name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "video") ...[
                                          ReplyVideoWithTextMsg(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            video: controller.chatListsDoc
                                                    ?.content?.media.path ??
                                                "",
                                            message: controller.chatListsDoc
                                                ?.content?.media.name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "location") ...[
                                          ReplyLocationWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                ?.content?.media.name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "contact") ...[
                                          controller.chatListsDoc?.content
                                                      ?.contact.length !=
                                                  1
                                              ? ReplyMultiContactWithTextMsg(
                                                  userName: Get.find<
                                                                  Repository>()
                                                              .getStringValue(
                                                                  LocalKeys
                                                                      .userIds) ==
                                                          controller
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.id
                                                      ? "You"
                                                      : controller
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.fullname ??
                                                          controller
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.nickname ??
                                                          "",
                                                  message: controller
                                                      .chatListsDoc
                                                      ?.content
                                                      ?.contact
                                                      .length
                                                      .toString(),
                                                  onTap: () {
                                                    controller.isReplyChat =
                                                        false;
                                                    controller.chatListsDoc =
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
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.id
                                                      ? "You"
                                                      : controller
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.fullname ??
                                                          controller
                                                              .chatListsDoc
                                                              ?.from
                                                              ?.nickname ??
                                                          "",
                                                  message: controller
                                                      .chatListsDoc
                                                      ?.content
                                                      ?.contact[0]
                                                      .userdata
                                                      ?.nickname,
                                                  onTap: () {
                                                    controller.isReplyChat =
                                                        false;
                                                    controller.chatListsDoc =
                                                        null;
                                                    controller.update();
                                                  },
                                                  image: controller
                                                      .chatListsDoc
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
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                    .chatListsDoc
                                                    ?.content
                                                    ?.phonecontact
                                                    ?.name ??
                                                " -- ",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "audio") ...[
                                          ReplyAudioWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                ?.content?.media.name,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "poll") ...[
                                          ReplyPollWithText(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller
                                                .chatListsDoc
                                                ?.content
                                                ?.poll
                                                .pollid
                                                ?.polltitle,
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          ),
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "videowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "videowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "docswithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "docswithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "audiowithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "audiowithlinks") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
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
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "productwithtext") ...[
                                          ReplyTextMessage(
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "videocall") ...[
                                          ReplyVideoCallWithText(
                                            isConference: (controller
                                                        .chatListsDoc
                                                        ?.callid
                                                        ?.isgroupcall ??
                                                    false) ||
                                                ((controller
                                                            .chatListsDoc
                                                            ?.callid
                                                            ?.members
                                                            ?.length ??
                                                        0) >
                                                    2),
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
                                        ],
                                        if (controller
                                                .chatListsDoc?.contentType ==
                                            "audiocall") ...[
                                          ReplyAudioCallWithText(
                                            isConference: (controller
                                                        .chatListsDoc
                                                        ?.callid
                                                        ?.isgroupcall ??
                                                    false) ||
                                                ((controller
                                                            .chatListsDoc
                                                            ?.callid
                                                            ?.members
                                                            ?.length ??
                                                        0) >
                                                    2),
                                            userName: Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    controller
                                                        .chatListsDoc?.from?.id
                                                ? "You"
                                                : controller.chatListsDoc?.from
                                                        ?.fullname ??
                                                    controller.chatListsDoc
                                                        ?.from?.nickname ??
                                                    "",
                                            message: controller.chatListsDoc
                                                    ?.content?.text.message ??
                                                "",
                                            onTap: () {
                                              controller.isReplyChat = false;
                                              controller.chatListsDoc = null;
                                              controller.update();
                                            },
                                          )
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
                                          Flexible(
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
                                                disabledBorder:
                                                    InputBorder.none,
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
                                                controller.isOverlayOpen =
                                                    false;
                                                controller.update();
                                              } else {
                                                controller.showOverlayDialog(
                                                    controller, false, false);
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
                            Dimens.boxWidth5,
                            GestureDetector(
                              onLongPressStart: (details) async {
                                if (await Utility.microphonePermissionCheack(
                                    context)) {
                                  controller.isMicOnOff = true;
                                  controller.update();
                                  controller.startRecording();
                                }
                              },
                              onLongPressEnd: (details) {
                                controller.isMicOnOff = false;
                                controller.update();
                                controller.stopRecording();
                              },
                              child: controller.isMicOnOff
                                  ? AvatarGlow(
                                      glowColor: Colors.black,
                                      child: Container(
                                        height: Dimens.fourty,
                                        width: Dimens.fourty,
                                        decoration: BoxDecoration(
                                          color: ColorsValue.maincolor1,
                                          borderRadius: BorderRadius.circular(
                                              Dimens.fifty),
                                        ),
                                        child: Center(
                                          child: SvgPicture.asset(
                                            AssetConstants.ic_mic_on,
                                            colorFilter: const ColorFilter.mode(
                                              ColorsValue.white,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: Dimens.fourty,
                                      width: Dimens.fourty,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius:
                                            BorderRadius.circular(Dimens.fifty),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          AssetConstants.ic_mic_on,
                                          colorFilter: const ColorFilter.mode(
                                            ColorsValue.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                            ),
                            Dimens.boxWidth10,
                            InkWell(
                              onTap: () {
                                if (controller
                                    .sendMessageController.text.isNotEmpty) {
                                  if (!controller.isChatMessageEdit) {
                                    controller.sendMessage("", false, false);
                                  } else {
                                    controller.postChatMessageEdit(
                                        controller.sendMessageController.text);
                                  }
                                  controller.isReplyChat = false;
                                  controller.isProductSend = false;
                                  controller.chatListsDoc = null;
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
                        !(controller.getOneFriendsData?.isBlocked ?? false) && controller.isEmoji
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
          ),
        );
      },
    );
  }
}
