import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MessageInfoScreen extends StatelessWidget {
  const MessageInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.chatMessageInfo = Get.arguments;
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
              if (controller.chatMessageInfo.contentType == "text") ...[
                if (controller.chatMessageInfo.context?.contentType !=
                    null) ...[
                  if (controller.chatMessageInfo.context?.contentType ==
                      "text") ...[
                    ReplayMessage(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                    ),
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "photo") ...[
                    ImageWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      images: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                          controller.chatMessageInfo.context?.senttimestamp),
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "links") ...[
                    LinksWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                          controller.chatMessageInfo.context?.senttimestamp),
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      image: '',
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "docs") ...[
                    DocsWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.context?.from?.id
                          ? true
                          : false,
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                          controller.chatMessageInfo.context?.senttimestamp),
                      fileName: controller
                              .chatMessageInfo.context?.content?.media.name ??
                          "",
                      extensions: controller
                              .chatMessageInfo.context?.content?.media.name
                              .split('.')
                              .last ??
                          "",
                      fileUrl: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "video") ...[
                    VideoWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.context?.from?.id
                          ? true
                          : false,
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      video: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.context?.senttimestamp,
                      ),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "contact") ...[
                    controller.chatMessageInfo.context?.content?.contact
                                .length ==
                            1
                        ? GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageDialog(
                                context,
                                details,
                                controller.chatMessageInfo,
                              );
                            },
                            child: ReplayContactWithMessage(
                              isEdited:
                                  controller.chatMessageInfo.isedited ?? false,
                              emoji: controller.chatMessageInfo.reactions ?? [],
                              onEmojiRemove: () {},
                              isBookmark: controller
                                      .chatMessageInfo.bookmarks?.isNotEmpty ??
                                  false,
                              isFavorites: controller
                                      .chatMessageInfo.favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? "You"
                                  : controller.chatMessageInfo.from?.fullname ??
                                      controller
                                          .chatMessageInfo.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? true
                                  : false,
                              message: controller
                                      .chatMessageInfo.content?.text.message ??
                                  "",
                              images: controller
                                      .chatMessageInfo
                                      .context
                                      ?.content
                                      ?.contact[0]
                                      .userid
                                      ?.profileimage ??
                                  "",
                              isSeen:
                                  controller.chatMessageInfo.status == "seen"
                                      ? true
                                      : false,
                              isDelivered: controller.chatMessageInfo.status ==
                                      "delivered"
                                  ? true
                                  : false,
                              time: Utility.getTimeStempToTime(
                                controller.chatMessageInfo.senttimestamp,
                              ),
                              replayChat: controller.chatMessageInfo.context
                                      ?.content?.contact[0].userid?.nickname ??
                                  "",
                            ),
                          )
                        : GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageDialog(
                                context,
                                details,
                                controller.chatMessageInfo,
                              );
                            },
                            child: ReplayMultiContactWithMessage(
                              isEdited:
                                  controller.chatMessageInfo.isedited ?? false,
                              emoji: controller.chatMessageInfo.reactions ?? [],
                              onEmojiRemove: () {},
                              isBookmark: controller
                                      .chatMessageInfo.bookmarks?.isNotEmpty ??
                                  false,
                              isFavorites: controller
                                      .chatMessageInfo.favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? "You"
                                  : controller.chatMessageInfo.from?.fullname ??
                                      controller
                                          .chatMessageInfo.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? true
                                  : false,
                              message: controller
                                      .chatMessageInfo.content?.text.message ??
                                  "",
                              isDelivered: controller.chatMessageInfo.status ==
                                      "delivered"
                                  ? true
                                  : false,
                              isSeen:
                                  controller.chatMessageInfo.status == "seen"
                                      ? true
                                      : false,
                              time: Utility.getTimeStempToTime(
                                controller.chatMessageInfo.senttimestamp,
                              ),
                              replayChat: controller.chatMessageInfo.context
                                      ?.content?.contact.length
                                      .toString() ??
                                  "",
                            ),
                          ),
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "audio") ...[
                    AudioWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "poll") ...[
                    PollWithText(
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      replayChat: controller.chatMessageInfo.context?.content
                              ?.poll.pollid?.polltitle ??
                          "",
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "location") ...[
                    LocationWithText(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                    ),
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "photowithtext") ...[
                    TextWithPhotoWithText(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "videowithtext") ...[
                    TextWithVideoWithText(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "productwithtext") ...[
                    TextWithProductWithText(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ]
                ] else ...[
                  OnlyMessage(
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    message:
                        controller.chatMessageInfo.content?.text.message ?? "",
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp,
                    ),
                    isEdited: controller.chatMessageInfo.isedited ?? false,
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType == "photo") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayPhotoMessage(
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                    isGroup: false,
                  )
                ] else ...[
                  SingleImageMsg(
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    images:
                        controller.chatMessageInfo.content?.media.path ?? "",
                    message:
                        controller.chatMessageInfo.content?.text.message ?? "",
                    time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp),
                  ),
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "photowithlinks") ...[
                ImageWithLinks(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  images: controller.chatMessageInfo.content?.media.path ?? "",
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                ),
              ] else if (controller.chatMessageInfo.contentType ==
                  "photowithtext") ...[
                ImageWithText(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  images: controller.chatMessageInfo.content?.media.path ?? "",
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                ),
              ] else if (controller.chatMessageInfo.contentType == "links") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  if (controller.chatMessageInfo.context?.contentType ==
                      "text") ...[
                    TextWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.fullname ??
                              controller.chatMessageInfo.from?.nickname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      onTap: () {
                        Utility.launchLinkURL(
                            controller.chatMessageInfo.content?.text.message ??
                                "");
                      },
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "contact") ...[
                    controller.chatMessageInfo.context?.content?.contact
                                .length ==
                            1
                        ? GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageDialog(
                                context,
                                details,
                                controller.chatMessageInfo,
                              );
                            },
                            child: ReplayContactWithMessage(
                              isEdited:
                                  controller.chatMessageInfo.isedited ?? false,
                              emoji: controller.chatMessageInfo.reactions ?? [],
                              onEmojiRemove: () {},
                              isBookmark: controller
                                      .chatMessageInfo.bookmarks?.isNotEmpty ??
                                  false,
                              isFavorites: controller
                                      .chatMessageInfo.favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? "You"
                                  : controller.chatMessageInfo.from?.fullname ??
                                      controller
                                          .chatMessageInfo.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? true
                                  : false,
                              message: controller
                                      .chatMessageInfo.content?.text.message ??
                                  "",
                              images: controller
                                      .chatMessageInfo
                                      .context
                                      ?.content
                                      ?.contact[0]
                                      .userid
                                      ?.profileimage ??
                                  "",
                              isDelivered: controller.chatMessageInfo.status ==
                                      "delivered"
                                  ? true
                                  : false,
                              isSeen:
                                  controller.chatMessageInfo.status == "seen"
                                      ? true
                                      : false,
                              time: Utility.getTimeStempToTime(
                                controller.chatMessageInfo.senttimestamp,
                              ),
                              replayChat: controller.chatMessageInfo.context
                                      ?.content?.contact[0].userid?.nickname ??
                                  "",
                            ),
                          )
                        : GestureDetector(
                            onLongPressStart: (details) {
                              ChatScreenUtility.infoMessageDialog(
                                context,
                                details,
                                controller.chatMessageInfo,
                              );
                            },
                            child: ReplayMultiContactWithMessage(
                              isEdited:
                                  controller.chatMessageInfo.isedited ?? false,
                              emoji: controller.chatMessageInfo.reactions ?? [],
                              onEmojiRemove: () {},
                              isBookmark: controller
                                      .chatMessageInfo.bookmarks?.isNotEmpty ??
                                  false,
                              isFavorites: controller
                                      .chatMessageInfo.favorites?.isNotEmpty ??
                                  false,
                              userName: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? "You"
                                  : controller.chatMessageInfo.from?.fullname ??
                                      controller
                                          .chatMessageInfo.from?.nickname ??
                                      "",
                              isSend: Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds) ==
                                      controller.chatMessageInfo.from?.id
                                  ? true
                                  : false,
                              message: controller
                                      .chatMessageInfo.content?.text.message ??
                                  "",
                              isDelivered: controller.chatMessageInfo.status ==
                                      "delivered"
                                  ? true
                                  : false,
                              isSeen:
                                  controller.chatMessageInfo.status == "seen"
                                      ? true
                                      : false,
                              time: Utility.getTimeStempToTime(
                                controller.chatMessageInfo.senttimestamp,
                              ),
                              replayChat: controller.chatMessageInfo.context
                                      ?.content?.contact.length
                                      .toString() ??
                                  "",
                            ),
                          )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "photo") ...[
                    ImageWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen:
                          controller.chatMessageInfo.context?.status == "seen"
                              ? true
                              : false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.context?.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      images: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                          controller.chatMessageInfo.context?.senttimestamp),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "video") ...[
                    VideoWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen:
                          controller.chatMessageInfo.context?.status == "seen"
                              ? true
                              : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.context?.from?.id
                          ? true
                          : false,
                      video: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.context?.senttimestamp,
                      ),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "docs") ...[
                    DocsWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen:
                          controller.chatMessageInfo.context?.status == "seen"
                              ? true
                              : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.context?.from?.id
                          ? true
                          : false,
                      fileName: controller
                              .chatMessageInfo.context?.content?.media.name ??
                          "",
                      extensions: controller
                              .chatMessageInfo.context?.content?.media.name
                              .split('.')
                              .last ??
                          "",
                      fileUrl: controller
                              .chatMessageInfo.context?.content?.media.path ??
                          "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.context?.senttimestamp,
                      ),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "audio") ...[
                    AudioWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {},
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      time: Utility.getTimeStempToTime(
                          controller.chatMessageInfo.senttimestamp),
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.fullname ??
                              controller.chatMessageInfo.from?.nickname ??
                              "",
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "location") ...[
                    LocationWithLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                    ),
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "photowithtext") ...[
                    LinksWithPhotoWithLinks(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "videowithtext") ...[
                    LinksWithVideoWithLinks(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "productwithtext") ...[
                    LinksWithProductWithLinks(
                      chatListsDocData: controller.chatMessageInfo,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isGroup: false,
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "links") ...[
                    ReplayLinks(
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.fullname ??
                              controller.chatMessageInfo.from?.nickname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      replayChat: controller
                              .chatMessageInfo.context?.content?.text.message ??
                          "",
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                    )
                  ] else if (controller.chatMessageInfo.context?.contentType ==
                      "poll") ...[
                    PollWithLinks(
                      isEdited: controller.chatMessageInfo.isedited ?? false,
                      emoji: controller.chatMessageInfo.reactions ?? [],
                      onEmojiRemove: () {
                        controller.postChatMessageUnReaction(
                            controller.chatMessageInfo.id);
                      },
                      isBookmark:
                          controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                              false,
                      isFavorites:
                          controller.chatMessageInfo.favorites?.isNotEmpty ??
                              false,
                      isSend: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? true
                          : false,
                      userName: Get.find<Repository>()
                                  .getStringValue(LocalKeys.userIds) ==
                              controller.chatMessageInfo.from?.id
                          ? "You"
                          : controller.chatMessageInfo.from?.nickname ??
                              controller.chatMessageInfo.from?.fullname ??
                              "",
                      message:
                          controller.chatMessageInfo.content?.text.message ??
                              "",
                      isDelivered:
                          controller.chatMessageInfo.status == "delivered"
                              ? true
                              : false,
                      isSeen: controller.chatMessageInfo.status == "seen"
                          ? true
                          : false,
                      time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp,
                      ),
                      replayChat: controller.chatMessageInfo.context?.content
                              ?.poll.pollid?.polltitle ??
                          "",
                    )
                  ]
                ] else ...[
                  LinkMessage(
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isEdited: controller.chatMessageInfo.isedited ?? false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    message:
                        controller.chatMessageInfo.content?.text.message ?? "",
                    time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp,
                    ),
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType == "docs") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayDocsMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  DocsMessage(
                    onTap: () {
                      Utility.downloadAndSavePDF(
                          controller.chatMessageInfo.content?.media.path ?? "",
                          'ChatNest',
                          0);
                      controller.update();
                    },
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    fileName:
                        controller.chatMessageInfo.content?.media.name ?? "",
                    time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp,
                    ),
                    fileUrl:
                        controller.chatMessageInfo.content?.media.path ?? "",
                    extensions: controller.chatMessageInfo.content?.media.name
                            .split('.')
                            .last ??
                        "",
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "docswithtext") ...[
                DocsWithText(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                  fileName:
                      controller.chatMessageInfo.content?.media.name ?? "",
                  extensions: controller.chatMessageInfo.content?.media.name
                          .split('.')
                          .last ??
                      "",
                  fileUrl: controller.chatMessageInfo.content?.media.path ?? "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "docswithlinks") ...[
                DocsWithLinks(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                  fileName:
                      controller.chatMessageInfo.content?.media.name ?? "",
                  extensions: controller.chatMessageInfo.content?.media.name
                          .split('.')
                          .last ??
                      "",
                  fileUrl: controller.chatMessageInfo.content?.media.path ?? "",
                )
              ] else if (controller.chatMessageInfo.contentType == "video") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayVideoMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  SingleVideoMsg(
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    video: controller.chatMessageInfo.content?.media.path ?? "",
                    message:
                        controller.chatMessageInfo.content?.text.message ?? "",
                    time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp),
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "videowithtext") ...[
                VideoWithText(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  video: controller.chatMessageInfo.content?.media.path ?? "",
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "videowithlinks") ...[
                VideoWithLinks(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  video: controller.chatMessageInfo.content?.media.path ?? "",
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                )
              ] else if (controller.chatMessageInfo.contentType == "audio") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayAudioMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  MusicPlay(
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    audioUrl:
                        controller.chatMessageInfo.content?.media.path ?? "",
                    message:
                        controller.chatMessageInfo.content?.text.message ?? "",
                    time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp),
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "audiowithtext") ...[
                AudioWithText(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                  userName: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? "You"
                      : controller.chatMessageInfo.from?.fullname ??
                          controller.chatMessageInfo.from?.nickname ??
                          "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "audiowithlinks") ...[
                AudioWithLinks(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  time: Utility.getTimeStempToTime(
                      controller.chatMessageInfo.senttimestamp),
                  userName: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? "You"
                      : controller.chatMessageInfo.from?.fullname ??
                          controller.chatMessageInfo.from?.nickname ??
                          "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "location") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayLocationMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  ShareCurrentLocation(
                    emoji: controller.chatMessageInfo.reactions ?? [],
                    onEmojiRemove: () {},
                    isBookmark:
                        controller.chatMessageInfo.bookmarks?.isNotEmpty ??
                            false,
                    isFavorites:
                        controller.chatMessageInfo.favorites?.isNotEmpty ??
                            false,
                    isDelivered:
                        controller.chatMessageInfo.status == "delivered"
                            ? true
                            : false,
                    isSeen: controller.chatMessageInfo.status == "seen"
                        ? true
                        : false,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    time: Utility.getTimeStempToTime(
                        controller.chatMessageInfo.senttimestamp),
                    businessProfileLatLag: LatLng(
                      controller
                          .chatMessageInfo.content?.location.coordinates[1],
                      controller
                          .chatMessageInfo.content?.location.coordinates[0],
                    ),
                    onTap: (latLng) async {
                      MapsLauncher.launchCoordinates(
                        controller
                            .chatMessageInfo.content?.location.coordinates[1],
                        controller
                            .chatMessageInfo.content?.location.coordinates[0],
                      );
                    },
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "contact") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayContactMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  controller.chatMessageInfo.content?.contact.length == 1
                      ? GestureDetector(
                          onLongPressStart: (details) {
                            ChatScreenUtility.infoMessageDialog(
                              context,
                              details,
                              controller.chatMessageInfo,
                            );
                          },
                          child: ShareContact(
                            onMessageTap: () {
                              Get.back();
                              controller.getOneFriends(controller
                                  .chatMessageInfo
                                  .content
                                  ?.contact
                                  .first
                                  .userdata
                                  ?.id);
                              controller.getChatLists(
                                  1,
                                  controller.chatMessageInfo.content?.contact
                                      .first.userdata?.id);
                            },
                            emoji: controller.chatMessageInfo.reactions ?? [],
                            onEmojiRemove: () {},
                            isBookmark: controller
                                    .chatMessageInfo.bookmarks?.isNotEmpty ??
                                false,
                            isFavorites: controller
                                    .chatMessageInfo.favorites?.isNotEmpty ??
                                false,
                            isDelivered:
                                controller.chatMessageInfo.status == "delivered"
                                    ? true
                                    : false,
                            isSeen: controller.chatMessageInfo.status == "seen"
                                ? true
                                : false,
                            isSend: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller.chatMessageInfo.from?.id
                                ? true
                                : false,
                            contactList:
                                controller.chatMessageInfo.content?.contact ??
                                    [],
                            time: Utility.getTimeStempToTime(
                              controller.chatMessageInfo.senttimestamp,
                            ),
                          ),
                        )
                      : GestureDetector(
                          onLongPressStart: (details) {
                            ChatScreenUtility.infoMessageDialog(
                              context,
                              details,
                              controller.chatMessageInfo,
                            );
                          },
                          child: ShareMultipulConect(
                            emoji: controller.chatMessageInfo.reactions ?? [],
                            onEmojiRemove: () {},
                            isBookmark: controller
                                    .chatMessageInfo.bookmarks?.isNotEmpty ??
                                false,
                            isFavorites: controller
                                    .chatMessageInfo.favorites?.isNotEmpty ??
                                false,
                            isDelivered:
                                controller.chatMessageInfo.status == "delivered"
                                    ? true
                                    : false,
                            isSeen: controller.chatMessageInfo.status == "seen"
                                ? true
                                : false,
                            isSend: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller.chatMessageInfo.from?.id
                                ? true
                                : false,
                            contactList:
                                controller.chatMessageInfo.content?.contact ??
                                    [],
                            onTap: () {
                              controller.getContactList.clear();
                              RouteManagement.goToViewAllContact(
                                  controller.chatMessageInfo.content?.contact ??
                                      []);
                            },
                            time: Utility.getTimeStempToTime(
                              controller.chatMessageInfo.senttimestamp,
                            ),
                          ),
                        )
                ]
              ] else if (controller.chatMessageInfo.contentType == "poll") ...[
                if (controller.chatMessageInfo.context != null) ...[
                  ReplayPollsMessage(
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ] else ...[
                  PollMessage(
                    key: controller.chatMessageInfo.content?.poll.pollid?.key,
                    onVote: (choice) {
                      controller.postPollVote(
                          controller.chatMessageInfo.content?.poll,
                          controller.chatMessageInfo.content?.poll.pollid
                                  ?.options[choice].id ??
                              "");
                    },
                    isGroup: false,
                    chatListsDocData: controller.chatMessageInfo,
                    isSend: Get.find<Repository>()
                                .getStringValue(LocalKeys.userIds) ==
                            controller.chatMessageInfo.from?.id
                        ? true
                        : false,
                    onEmojiRemove: () {
                      controller.postChatMessageUnReaction(
                          controller.chatMessageInfo.id);
                    },
                  )
                ]
              ] else if (controller.chatMessageInfo.contentType ==
                  "product") ...[
                SingleProduct(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  time: Utility.getTimeStempToTime(
                    controller.chatMessageInfo.senttimestamp,
                  ),
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  productImage: controller
                          .chatMessageInfo.content?.product.productid?.image ??
                      "",
                  productPrice: controller
                          .chatMessageInfo.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .chatMessageInfo.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.chatMessageInfo.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "productwithtext") ...[
                ProductWithMessage(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  time: Utility.getTimeStempToTime(
                    controller.chatMessageInfo.senttimestamp,
                  ),
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  productImage: controller
                          .chatMessageInfo.content?.product.productid?.image ??
                      "",
                  productPrice: controller
                          .chatMessageInfo.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .chatMessageInfo.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.chatMessageInfo.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "productwithlinks") ...[
                ProductWithLinks(
                  emoji: controller.chatMessageInfo.reactions ?? [],
                  onEmojiRemove: () {},
                  isBookmark:
                      controller.chatMessageInfo.bookmarks?.isNotEmpty ?? false,
                  isFavorites:
                      controller.chatMessageInfo.favorites?.isNotEmpty ?? false,
                  isDelivered: controller.chatMessageInfo.status == "delivered"
                      ? true
                      : false,
                  isSeen: controller.chatMessageInfo.status == "seen"
                      ? true
                      : false,
                  isEdited: controller.chatMessageInfo.isedited ?? false,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  time: Utility.getTimeStempToTime(
                    controller.chatMessageInfo.senttimestamp,
                  ),
                  message:
                      controller.chatMessageInfo.content?.text.message ?? "",
                  productImage: controller
                          .chatMessageInfo.content?.product.productid?.image ??
                      "",
                  productPrice: controller
                          .chatMessageInfo.content?.product.productid?.price
                          .toString() ??
                      "",
                  productTitle: controller
                          .chatMessageInfo.content?.product.productid?.name ??
                      "",
                  productdiscription: controller.chatMessageInfo.content
                          ?.product.productid?.description ??
                      "",
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "multimedia") ...[
                MultipalImage(
                  isGroup: false,
                  chatListsDocData: controller.chatMessageInfo,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.chatMessageInfo.id);
                  },
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "multimediawithtext") ...[
                MultipalImageWithText(
                  isGroup: false,
                  chatListsDocData: controller.chatMessageInfo,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.chatMessageInfo.id);
                  },
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "multimediawithlinks") ...[
                MultipalImageWithLinks(
                  isGroup: false,
                  chatListsDocData: controller.chatMessageInfo,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.chatMessageInfo.id);
                  },
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "videocall") ...[
                VideoCall(
                  isGroup: false,
                  chatListsDocData: controller.chatMessageInfo,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.chatMessageInfo.id);
                  },
                )
              ] else if (controller.chatMessageInfo.contentType ==
                  "audiocall") ...[
                AudioCall(
                  isGroup: false,
                  chatListsDocData: controller.chatMessageInfo,
                  isSend: Get.find<Repository>()
                              .getStringValue(LocalKeys.userIds) ==
                          controller.chatMessageInfo.from?.id
                      ? true
                      : false,
                  onEmojiRemove: () {
                    controller.postChatMessageUnReaction(
                        controller.chatMessageInfo.id);
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
                        dateConverter(Utility.parseTimeStamp(
                            controller.chatMessageInfo.senttimestamp ?? 0)),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        AssetConstants.unseenIcon,
                        colorFilter: ColorFilter.mode(
                          ColorsValue.greyColor8888,
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
                        controller.chatMessageInfo.deliveredtimestamp == 0
                            ? " -- "
                            : dateConverter(Utility.parseTimeStamp(
                                controller.chatMessageInfo.deliveredtimestamp ??
                                    0)),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        controller.chatMessageInfo.status == "seen"
                            ? AssetConstants.seenIcon
                            : controller.chatMessageInfo.status == "delivered"
                                ? AssetConstants.deliveredIcon
                                : AssetConstants.unseenIcon,
                        colorFilter: ColorFilter.mode(
                          ColorsValue.greyColor8888,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
                      title: Text(
                        'read'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        controller.chatMessageInfo.seentimestamp == 0
                            ? " -- "
                            : dateConverter(Utility.parseTimeStamp(
                                controller.chatMessageInfo.seentimestamp ?? 0)),
                        style: Styles.greyColor888840014,
                      ),
                      trailing: SvgPicture.asset(
                        controller.chatMessageInfo.status == "seen"
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

  String dateConverter(String myDate) {
    String date;
    // final dateToCheck = convertedDate;
    // final checkDate =
    //     DateTime(dateToCheck.year, dateToCheck.month, dateToCheck.day);
    // if (checkDate == today) {
    //   date = "Today";
    // } else if (checkDate == yesterday) {
    //   date = "Yesterday";
    // } else if (checkDate == tomorrow) {
    //   date = "Tomorrow";
    // } else {
    date = myDate;
    // }
    return date;
  }
}
