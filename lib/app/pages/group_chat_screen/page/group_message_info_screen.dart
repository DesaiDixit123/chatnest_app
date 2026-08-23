import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/widgets/replay_chat_componet.dart/replay_phonecontact_message.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

class GroupMessageInfoScreen extends StatelessWidget {
  const GroupMessageInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.groupChatListDocs = Get.arguments;
      },
      builder: (controller) {
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
                  colorFilter: ColorFilter.mode(
                    ColorsValue.maincolor1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Text(
              'message_info'.tr,
              style: Styles.black70018,
            ),
          ),
          body: ListView(
            padding: Dimens.edgeInsets20,
            children: [
              if (controller.groupChatListDocs.contentType == "text") ...[
                if (controller.groupChatListDocs.context?.contentType !=
                    null) ...[
                  if (controller.groupChatListDocs.context?.contentType ==
                      "text") ...[
                    ReplayMessage(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.nickname ??
                              controller.groupChatListDocs.from?.fullname ??
                              "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.timestamp,
                      ),
                      replayChat: controller.groupChatListDocs.context?.content
                              ?.text.message ??
                          "",
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "photo") ...[
                    ImageWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      images: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(controller
                          .groupChatListDocs.context?.senttimestamp
                          .toString()),
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "links") ...[
                    LinksWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.nickname ??
                              controller.groupChatListDocs.from?.fullname ??
                              "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(controller
                          .groupChatListDocs.context?.senttimestamp
                          .toString()),
                      replayChat: controller.groupChatListDocs.context?.content
                              ?.text.message ??
                          "",
                      image: '',
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "docs") ...[
                    DocsWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.context?.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(controller
                          .groupChatListDocs.context?.senttimestamp
                          .toString()),
                      fileName: controller
                              .groupChatListDocs.context?.content?.media.name ??
                          "",
                      extensions: controller
                              .groupChatListDocs.context?.content?.media.name
                              .split('.')
                              .last ??
                          "",
                      fileUrl: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "video") ...[
                    VideoWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.context?.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      video: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.context?.senttimestamp
                            .toString(),
                      ),
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "contact") ...[
                    controller.groupChatListDocs.context?.content?.contact
                                .length ==
                            1
                        ? GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageBusinessDialog(
                                  context,
                                  details,
                                  controller.groupChatListDocs);
                            },
                            child: ReplayContactWithMessage(
                              isEdited: controller.groupChatListDocs.isedited ??
                                  false,
                              emoji:
                                  controller.groupChatListDocs.reactions ?? [],
                              onEmojiRemove: () {
                                controller.postChatGroupMessageUnReaction(
                                    controller.groupChatListDocs.id);
                              },
                              isBookmark: controller.groupChatListDocs.bookmarks
                                      ?.isNotEmpty ??
                                  false,
                              isFavorites: controller.groupChatListDocs
                                      .favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? "You"
                                  : controller
                                          .groupChatListDocs.from?.fullname ??
                                      controller
                                          .groupChatListDocs.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? true
                                  : false,
                              isDelivered: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "delivered") ??
                                  false,
                              message: controller.groupChatListDocs.content
                                      ?.text.message ??
                                  "",
                              images: controller
                                      .groupChatListDocs
                                      .context
                                      ?.content
                                      ?.contact[0]
                                      .userid
                                      ?.profileimage ??
                                  "",
                              isSeen: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "seen") ??
                                  false,
                              time: Utility.getTimeStempToTime(
                                controller.groupChatListDocs.timestamp,
                              ),
                              replayChat: controller.groupChatListDocs.context
                                      ?.content?.contact[0].userid?.nickname ??
                                  "",
                            ),
                          )
                        : GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageBusinessDialog(
                                  context,
                                  details,
                                  controller.groupChatListDocs);
                            },
                            child: ReplayMultiContactWithMessage(
                              isEdited: controller.groupChatListDocs.isedited ??
                                  false,
                              emoji:
                                  controller.groupChatListDocs.reactions ?? [],
                              onEmojiRemove: () {
                                controller.postChatGroupMessageUnReaction(
                                    controller.groupChatListDocs.id);
                              },
                              isBookmark: controller.groupChatListDocs.bookmarks
                                      ?.isNotEmpty ??
                                  false,
                              isFavorites: controller.groupChatListDocs
                                      .favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? "You"
                                  : controller
                                          .groupChatListDocs.from?.fullname ??
                                      controller
                                          .groupChatListDocs.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? true
                                  : false,
                              isDelivered: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "delivered") ??
                                  false,
                              message: controller.groupChatListDocs.content
                                      ?.text.message ??
                                  "",
                              isSeen: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "seen") ??
                                  false,
                              time: Utility.getTimeStempToTime(
                                controller.groupChatListDocs.timestamp,
                              ),
                              replayChat: controller.groupChatListDocs.context
                                      ?.content?.contact.length
                                      .toString() ??
                                  "",
                            ),
                          ),
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "audio") ...[
                    AudioWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.nickname ??
                              controller.groupChatListDocs.from?.fullname ??
                              "",
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.timestamp,
                      ),
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "poll") ...[
                    PollWithText(
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.nickname ??
                              controller.groupChatListDocs.from?.fullname ??
                              "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.timestamp,
                      ),
                      replayChat: controller.groupChatListDocs.context?.content
                              ?.poll.pollid?.polltitle ??
                          "",
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "location") ...[
                    LocationWithText(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.nickname ??
                              controller.groupChatListDocs.from?.fullname ??
                              "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.senttimestamp,
                      ),
                      replayChat: controller.groupChatListDocs.context?.content
                              ?.text.message ??
                          "",
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                    ),
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "photowithtext") ...[
                    TextWithPhotoWithText(
                      chatListsDocData: controller.groupChatListDocs,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "videowithtext") ...[
                    TextWithVideoWithText(
                      chatListsDocData: controller.groupChatListDocs,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "productwithtext") ...[
                    TextWithProductWithText(
                      chatListsDocData: controller.groupChatListDocs,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isGroup: false,
                    )
                  ]
                ] else ...[
                  OnlyMessage(
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    message:
                        controller.groupChatListDocs.content?.text.message ??
                            "",
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                    isEdited: controller.groupChatListDocs.isedited ?? false,
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "photo") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayPhotoMessage(
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isGroup: false,
                  )
                ] else ...[
                  SingleImageMsg(
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    images:
                        controller.groupChatListDocs.content?.media.path ?? "",
                    message:
                        controller.groupChatListDocs.content?.text.message ??
                            "",
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                  ),
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "photowithlinks") ...[
                ImageWithLinks(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  images:
                      controller.groupChatListDocs.content?.media.path ?? "",
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                ),
              ] else if (controller.groupChatListDocs.contentType ==
                  "photowithtext") ...[
                ImageWithText(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  images:
                      controller.groupChatListDocs.content?.media.path ?? "",
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "links") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  if (controller.groupChatListDocs.context?.contentType ==
                      "text") ...[
                    TextWithLinks(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.fullname ??
                              controller.groupChatListDocs.from?.nickname ??
                              "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      replayChat: controller.groupChatListDocs.context?.content
                              ?.text.message ??
                          "",
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.timestamp,
                      ),
                      onTap: () {
                        Utility.launchLinkURL(controller
                                .groupChatListDocs.content?.text.message ??
                            "");
                      },
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "contact") ...[
                    controller.groupChatListDocs.context?.content?.contact
                                .length ==
                            1
                        ? GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageBusinessDialog(
                                  context,
                                  details,
                                  controller.groupChatListDocs);
                            },
                            child: ReplayContactWithMessage(
                              isEdited: controller.groupChatListDocs.isedited ??
                                  false,
                              emoji:
                                  controller.groupChatListDocs.reactions ?? [],
                              onEmojiRemove: () {
                                controller.postChatGroupMessageUnReaction(
                                    controller.groupChatListDocs.id);
                              },
                              isBookmark: controller.groupChatListDocs.bookmarks
                                      ?.isNotEmpty ??
                                  false,
                              isFavorites: controller.groupChatListDocs
                                      .favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? "You"
                                  : controller
                                          .groupChatListDocs.from?.fullname ??
                                      controller
                                          .groupChatListDocs.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? true
                                  : false,
                              isDelivered: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "delivered") ??
                                  false,
                              message: controller.groupChatListDocs.content
                                      ?.text.message ??
                                  "",
                              images: controller
                                      .groupChatListDocs
                                      .context
                                      ?.content
                                      ?.contact[0]
                                      .userid
                                      ?.profileimage ??
                                  "",
                              isSeen: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "seen") ??
                                  false,
                              time: Utility.getTimeStempToTime(
                                controller.groupChatListDocs.timestamp,
                              ),
                              replayChat: controller.groupChatListDocs.context
                                      ?.content?.contact[0].userid?.nickname ??
                                  "",
                            ),
                          )
                        : GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageBusinessDialog(
                                  context,
                                  details,
                                  controller.groupChatListDocs);
                            },
                            child: ReplayMultiContactWithMessage(
                              isEdited: controller.groupChatListDocs.isedited ??
                                  false,
                              emoji:
                                  controller.groupChatListDocs.reactions ?? [],
                              onEmojiRemove: () {
                                controller.postChatGroupMessageUnReaction(
                                    controller.groupChatListDocs.id);
                              },
                              isBookmark: controller.groupChatListDocs.bookmarks
                                      ?.isNotEmpty ??
                                  false,
                              isFavorites: controller.groupChatListDocs
                                      .favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? "You"
                                  : controller
                                          .groupChatListDocs.from?.fullname ??
                                      controller
                                          .groupChatListDocs.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.groupChatListDocs.from?.id
                                  ? true
                                  : false,
                              isDelivered: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "delivered") ??
                                  false,
                              message: controller.groupChatListDocs.content
                                      ?.text.message ??
                                  "",
                              isSeen: controller.groupChatListDocs.statuses
                                      ?.every((element) =>
                                          element.status == "seen") ??
                                  false,
                              time: Utility.getTimeStempToTime(
                                controller.groupChatListDocs.timestamp,
                              ),
                              replayChat: controller.groupChatListDocs.context
                                      ?.content?.contact.length
                                      .toString() ??
                                  "",
                            ),
                          ),
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "photo") ...[
                    ImageWithLinks(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.context?.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      images: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(controller
                          .groupChatListDocs.context?.senttimestamp
                          .toString()),
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "video") ...[
                    VideoWithLinks(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.context?.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      video: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.context?.senttimestamp
                            .toString(),
                      ),
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "docs") ...[
                    DocsWithLinks(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.context?.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      fileName: controller
                              .groupChatListDocs.context?.content?.media.name ??
                          "",
                      extensions: controller
                              .groupChatListDocs.context?.content?.media.name
                              .split('.')
                              .last ??
                          "",
                      fileUrl: controller
                              .groupChatListDocs.context?.content?.media.path ??
                          "",
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.context?.senttimestamp
                            .toString(),
                      ),
                    )
                  ] else if (controller
                          .groupChatListDocs.context?.contentType ==
                      "audio") ...[
                    AudioWithLinks(
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      isEdited: controller.groupChatListDocs.isedited ?? false,
                      message:
                          controller.groupChatListDocs.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                        controller.groupChatListDocs.timestamp,
                      ),
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? "You"
                          : controller.groupChatListDocs.from?.fullname ??
                              controller.groupChatListDocs.from?.nickname ??
                              "",
                    )
                  ]
                ] else ...[
                  LinkMessage(
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isEdited: controller.groupChatListDocs.isedited ?? false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    message:
                        controller.groupChatListDocs.content?.text.message ??
                            "",
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "docs") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayDocsMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  DocsMessage(
                    onTap: () {
                      Utility.downloadAndSavePDF(
                          controller.groupChatListDocs.content?.media.path ??
                              "",
                          'ChatNest',
                          0);
                      controller.update();
                    },
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    fileName:
                        controller.groupChatListDocs.content?.media.name ?? "",
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                    fileUrl:
                        controller.groupChatListDocs.content?.media.path ?? "",
                    extensions: controller.groupChatListDocs.content?.media.name
                            .split('.')
                            .last ??
                        "",
                  ),
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "docswithtext") ...[
                DocsWithText(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  fileName:
                      controller.groupChatListDocs.content?.media.name ?? "",
                  extensions: controller.groupChatListDocs.content?.media.name
                          .split('.')
                          .last ??
                      "",
                  fileUrl:
                      controller.groupChatListDocs.content?.media.path ?? "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "docswithlinks") ...[
                DocsWithLinks(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  fileName:
                      controller.groupChatListDocs.content?.media.name ?? "",
                  extensions: controller.groupChatListDocs.content?.media.name
                          .split('.')
                          .last ??
                      "",
                  fileUrl:
                      controller.groupChatListDocs.content?.media.path ?? "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "video") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayVideoMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  SingleVideoMsg(
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    video:
                        controller.groupChatListDocs.content?.media.path ?? "",
                    message:
                        controller.groupChatListDocs.content?.text.message ??
                            "",
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "videowithtext") ...[
                VideoWithText(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  video: controller.groupChatListDocs.content?.media.path ?? "",
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "videowithlinks") ...[
                VideoWithLinks(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  video: controller.groupChatListDocs.content?.media.path ?? "",
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "audio") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayAudioMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  MusicPlay(
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    audioUrl:
                        controller.groupChatListDocs.content?.media.path ?? "",
                    message:
                        controller.groupChatListDocs.content?.text.message ??
                            "",
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "audiowithtext") ...[
                AudioWithText(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  userName: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? "You"
                      : controller.groupChatListDocs.from?.fullname ??
                          controller.groupChatListDocs.from?.nickname ??
                          "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "audiowithlinks") ...[
                AudioWithLinks(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  userName: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? "You"
                      : controller.groupChatListDocs.from?.fullname ??
                          controller.groupChatListDocs.from?.nickname ??
                          "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "location") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayLocationMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  ShareCurrentLocation(
                    emoji: controller.groupChatListDocs.reactions ?? [],
                    onEmojiRemove: () {
                      controller.postChatGroupMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                    isBookmark:
                        controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.groupChatListDocs.favorites?.isNotEmpty ??
                            false,
                    isSeen: controller.groupChatListDocs.statuses
                            ?.every((element) => element.status == "seen") ??
                        false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    isDelivered: controller.groupChatListDocs.statuses?.every(
                            (element) => element.status == "delivered") ??
                        false,
                    time: Utility.getTimeStempToTime(
                      controller.groupChatListDocs.timestamp,
                    ),
                    businessProfileLatLag: LatLng(
                      controller
                          .groupChatListDocs.content?.location.coordinates[1],
                      controller
                          .groupChatListDocs.content?.location.coordinates[0],
                    ),
                    onTap: (latLng) async {
                      MapsLauncher.launchCoordinates(
                        controller
                            .groupChatListDocs.content?.location.coordinates[1],
                        controller
                            .groupChatListDocs.content?.location.coordinates[0],
                      );
                    },
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "contact") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayContactMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  controller.groupChatListDocs.content?.contact.length == 1
                      ? GestureDetector(
                          onLongPressStart: (details) {
                            ChatScreenUtility.infoMessageBusinessDialog(
                              context,
                              details,
                              controller.groupChatListDocs,
                            );
                          },
                          child: ShareContact(
                            onMessageTap: () {
                              for (var datas in controller
                                      .groupChatListDocs.content?.contact ??
                                  <ContactContent>[]) {
                                RouteManagement.gooffAndToNamedChatScreen(
                                    datas.userdata?.id ?? "", false);
                              }
                            },
                            emoji: controller.groupChatListDocs.reactions ?? [],
                            onEmojiRemove: () {
                              controller.postChatGroupMessageUnReaction(
                                  controller.groupChatListDocs.id);
                            },
                            isBookmark: controller
                                    .groupChatListDocs.bookmarks?.isNotEmpty ??
                                false,
                            isFavorites: controller
                                    .groupChatListDocs.favorites?.isNotEmpty ??
                                false,
                            isSeen: controller.groupChatListDocs.statuses
                                    ?.every((element) =>
                                        element.status == "seen") ??
                                false,
                            isSend: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller.groupChatListDocs.from?.id
                                ? true
                                : false,
                            isDelivered: controller.groupChatListDocs.statuses
                                    ?.every((element) =>
                                        element.status == "delivered") ??
                                false,
                            contactList:
                                controller.groupChatListDocs.content?.contact ??
                                    [],
                            time: Utility.getTimeStempToTime(
                              controller.groupChatListDocs.timestamp,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onLongPressStart: (details) {
                            ChatScreenUtility.infoMessageBusinessDialog(
                              context,
                              details,
                              controller.groupChatListDocs,
                            );
                          },
                          child: ShareMultipulConect(
                            emoji: controller.groupChatListDocs.reactions ?? [],
                            onEmojiRemove: () {
                              controller.postChatGroupMessageUnReaction(
                                  controller.groupChatListDocs.id);
                            },
                            isBookmark: controller
                                    .groupChatListDocs.bookmarks?.isNotEmpty ??
                                false,
                            isFavorites: controller
                                    .groupChatListDocs.favorites?.isNotEmpty ??
                                false,
                            isSeen: controller.groupChatListDocs.statuses
                                    ?.every((element) =>
                                        element.status == "seen") ??
                                false,
                            isSend: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller.groupChatListDocs.from?.id
                                ? true
                                : false,
                            isDelivered: controller.groupChatListDocs.statuses
                                    ?.every((element) =>
                                        element.status == "delivered") ??
                                false,
                            contactList:
                                controller.groupChatListDocs.content?.contact ??
                                    [],
                            onTap: () {
                              controller.getContactList.clear();
                              RouteManagement.goToViewAllContact(controller
                                      .groupChatListDocs.content?.contact ??
                                  []);
                            },
                            time: Utility.getTimeStempToTime(
                              controller.groupChatListDocs.timestamp,
                            ),
                          ),
                        ),
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "phonecontact") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayPhoneContactMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  GestureDetector(
                    onLongPressStart: (details) {
                      ChatScreenUtility.infoMessageBusinessDialog(
                        context,
                        details,
                        controller.groupChatListDocs,
                      );
                    },
                    child: PhoneShareContact(
                      onMessageTap: null,
                      emoji: controller.groupChatListDocs.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatGroupMessageUnReaction(
                            controller.groupChatListDocs.id);
                      },
                      isBookmark:
                          controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.groupChatListDocs.favorites?.isNotEmpty ??
                              false,
                      isSeen: controller.groupChatListDocs.statuses
                              ?.every((element) => element.status == "seen") ??
                          false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.groupChatListDocs.from?.id
                          ? true
                          : false,
                      isDelivered: controller.groupChatListDocs.statuses?.every(
                              (element) => element.status == "delivered") ??
                          false,
                      phoneContact:
                          controller.groupChatListDocs.content?.phonecontact,
                      time: Utility.getTimeStempToTimeHHMMAA(
                        controller.groupChatListDocs.timestamp,
                      ),
                    ),
                    // PhoneShareContact(
                    //   onMessageTap: () {
                    //     for (var datas
                    //         in controller.groupChatListDocs.content?.contact ??
                    //             <ContactContent>[]) {
                    //       RouteManagement.gooffAndToNamedChatScreen(
                    //           datas.userdata?.id ?? "");
                    //     }
                    //   },
                    //   emoji: controller.groupChatListDocs.reactions ?? [],
                    //   onEmojiRemove: () {
                    //     controller.postChatGroupMessageUnReaction(
                    //         controller.groupChatListDocs.id);
                    //   },
                    //   isBookmark:
                    //       controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                    //           false,
                    //   isFavorites:
                    //       controller.groupChatListDocs.favorites?.isNotEmpty ??
                    //           false,
                    //   isSeen: controller.groupChatListDocs.statuses
                    //           ?.every((element) => element.status == "seen") ??
                    //       false,
                    //   isSend: Get.find<Repository>()
                    //               .getStringValue(LocalKeys.userIds) ==
                    //           controller.groupChatListDocs.from?.id
                    //       ? true
                    //       : false,
                    //   isDelivered: controller.groupChatListDocs.statuses?.every(
                    //           (element) => element.status == "delivered") ??
                    //       false,
                    //   contactList:
                    //       controller.groupChatListDocs.content?.contact ?? [],
                    //   time: Utility.getTimeStempToTime(
                    //     controller.groupChatListDocs.timestamp,
                    //   ),
                    // ),
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "poll") ...[
                if (controller.groupChatListDocs.context != null) ...[
                  ReplayPollsMessage(
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ] else ...[
                  PollMessage(
                    key: controller.groupChatListDocs.content?.poll.pollid?.key,
                    onVote: (choice) {
                      controller.postPollVote(
                          controller.groupChatListDocs.content?.poll,
                          controller.groupChatListDocs.content?.poll.pollid
                                  ?.options[choice].id ??
                              "");
                    },
                    isGroup: false,
                    chatListsDocData: controller.groupChatListDocs,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.groupChatListDocs.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.groupChatListDocs.id);
                    },
                  )
                ]
              ] else if (controller.groupChatListDocs.contentType ==
                  "product") ...[
                SingleProduct(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  productImage: controller.groupChatListDocs.content?.product
                          .productid?.image ??
                      "",
                  productPrice: controller
                          .groupChatListDocs.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .groupChatListDocs.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.groupChatListDocs.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "productwithtext") ...[
                ProductWithMessage(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  productImage: controller.groupChatListDocs.content?.product
                          .productid?.image ??
                      "",
                  productPrice: controller
                          .groupChatListDocs.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .groupChatListDocs.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.groupChatListDocs.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "productwithlinks") ...[
                ProductWithLinks(
                  emoji: controller.groupChatListDocs.reactions ?? [],
                  onEmojiRemove: () {
                    controller.postChatGroupMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                  isBookmark:
                      controller.groupChatListDocs.bookmarks?.isNotEmpty ??
                          false,
                  isFavorites:
                      controller.groupChatListDocs.favorites?.isNotEmpty ??
                          false,
                  isSeen: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "seen") ??
                      false,
                  isEdited: controller.groupChatListDocs.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  isDelivered: controller.groupChatListDocs.statuses
                          ?.every((element) => element.status == "delivered") ??
                      false,
                  time: Utility.getTimeStempToTime(
                    controller.groupChatListDocs.timestamp,
                  ),
                  message:
                      controller.groupChatListDocs.content?.text.message ?? "",
                  productImage: controller.groupChatListDocs.content?.product
                          .productid?.image ??
                      "",
                  productPrice: controller
                          .groupChatListDocs.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .groupChatListDocs.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.groupChatListDocs.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "multimedia") ...[
                MultipalImage(
                  isGroup: false,
                  chatListsDocData: controller.groupChatListDocs,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "multimediawithtext") ...[
                MultipalImageWithText(
                  isGroup: false,
                  chatListsDocData: controller.groupChatListDocs,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "multimediawithlinks") ...[
                MultipalImageWithLinks(
                  isGroup: false,
                  chatListsDocData: controller.groupChatListDocs,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "videocall") ...[
                VideoCall(
                  isGroup: false,
                  chatListsDocData: controller.groupChatListDocs,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                )
              ] else if (controller.groupChatListDocs.contentType ==
                  "audiocall") ...[
                AudioCall(
                  isGroup: false,
                  chatListsDocData: controller.groupChatListDocs,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.groupChatListDocs.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.groupChatListDocs.id);
                  },
                ),
              ],
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                    Dimens.five,
                  ),
                ),
                elevation: 10,
                color: ColorsValue.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      title: Text(
                        'send'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        dateConverter(
                            controller.groupChatListDocs.statuses ?? [],
                            "send"),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        AssetConstants.deliveredIcon,
                        colorFilter: ColorFilter.mode(
                          controller.groupChatListDocs.status != "send"
                              ? ColorsValue.maincolor1
                              : ColorsValue.greyColor8888,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      title: Text(
                        'delivered'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        dateConverter(
                            controller.groupChatListDocs.statuses ?? [],
                            "delivered"),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        controller.groupChatListDocs.status == "seen"
                            ? AssetConstants.seenIcon
                            : controller.groupChatListDocs.status == "delivered"
                                ? AssetConstants.deliveredIcon
                                : AssetConstants.unseenIcon,
                      ),
                    ),
                    ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      title: Text(
                        'read'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        dateConverter(
                            controller.groupChatListDocs.statuses ?? [],
                            "read"),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        controller.groupChatListDocs.status == "seen"
                            ? AssetConstants.seenIcon
                            : AssetConstants.unseenIcon,
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  String dateConverter(
      List<GroypChatListStatus> groupStatusList, String status) {
    var index = groupStatusList.indexWhere((element) =>
        element.userid?.id?.contains(
            Get.find<Repository>().getStringValue(LocalKeys.userIds)) ??
        false);
    if (!index.isNegative) {
      String myDate = "";
      if (status == "send") {
        myDate =
            Utility.parseTimeStamp(groupStatusList[index].senttimestamp ?? 0);
      } else if (status == "delivered") {
        myDate = Utility.parseTimeStamp(
            groupStatusList[index].deliveredtimestamp ?? 0);
      } else {
        myDate =
            Utility.parseTimeStamp(groupStatusList[index].seentimestamp ?? 0);
      }
      String date;
      DateTime convertedDate =
          DateFormat('dd MMMM yyyy, hh:mm a').parse(myDate.toString());
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = DateTime(now.year, now.month, now.day - 1);
      final tomorrow = DateTime(now.year, now.month, now.day + 1);

      final dateToCheck = convertedDate;
      final checkDate =
          DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
      if (checkDate == today) {
        date = "Today";
      } else if (checkDate == yesterday) {
        date = "Yesterday";
      } else if (checkDate == tomorrow) {
        date = "Tomorrow";
      } else {
        date = myDate;
      }
      return date;
    }
    return " -- ";
  }
}
