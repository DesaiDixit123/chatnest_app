import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ChatUserBookmarkScreen extends StatelessWidget {
  const ChatUserBookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) async {
      var controller = Get.find<ChatController>();
      await controller.postIndiviualBookmark(1, Get.arguments ?? "");
      controller.bookmarkUserController.addListener(() async {
        if (controller.bookmarkUserController.position.pixels ==
            controller.bookmarkUserController.position.maxScrollExtent) {
          if (controller.isUserBookmarksLoading == false) {
            controller.isUserBookmarksLoading = true;
            controller.update();
            if (controller.isUserbookmarkLastPage == false) {
              await controller.postIndiviualBookmark(
                  controller.pageUserBookmarkCount, Get.arguments ?? "");
            }
            controller.isUserBookmarksLoading = false;
            controller.update();
          }
        }
      });
    }, builder: (controller) {
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
              ),
            ),
          ),
          title: Text(
            'bookmark'.tr,
            style: Styles.black70018,
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20_0_20_0,
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => controller.postIndiviualBookmark(1, Get.arguments ?? ""),
            ),
            color: ColorsValue.appColor,
            child: controller.bookmarkUserList.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      AssetConstants.ic_empty_bookmark,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: controller.bookmarkUserController,
                    itemCount: controller.bookmarkUserList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = false;
                      String? newDate = '';
                      if (index == 0 &&
                          controller.bookmarkUserList.length == 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .bookmarkUserList[index].senttimestamp
                                .toString())
                            .toString();
                      } else if (index ==
                          controller.bookmarkUserList.length - 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .bookmarkUserList[index].senttimestamp
                                .toString())
                            .toString();
                      } else {
                        final DateTime date =
                            controller.returnDateAndTimeFormat(controller
                                .bookmarkUserList[index].senttimestamp
                                .toString());
                        final DateTime prevDate =
                            controller.returnDateAndTimeFormat(controller
                                .bookmarkUserList[index + 1].senttimestamp
                                .toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : controller
                                .groupMessageDateAndTime(controller
                                    .bookmarkUserList[index].senttimestamp
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
                                      color: ColorsValue.textfildbackcolor,
                                    ),
                                  ),
                                  Expanded(
                                    child: Center(
                                      child: Text(
                                        newDate,
                                        style: Styles.greyColor888840014,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      height: Dimens.one,
                                      color: ColorsValue.textfildbackcolor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                height: Dimens.twenty,
                                width: Dimens.twenty,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(Dimens.fifty)),
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.fifty),
                                  child: CachedNetworkImage(
                                    height: Dimens.twenty,
                                    width: Dimens.twenty,
                                    imageUrl: ApiWrapper.imageUrl +
                                        (controller.bookmarkUserList[index].from
                                                ?.profileimage ??
                                            ""),
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
                              Dimens.boxWidth5,
                              Text(
                                Get.find<Repository>().getStringValue(
                                            LocalKeys.userIds) ==
                                        controller
                                            .bookmarkUserList[index].from?.id
                                    ? "You"
                                    : controller.bookmarkUserList[index].from
                                            ?.nickname ??
                                        controller.bookmarkUserList[index].from
                                            ?.fullname ??
                                        "",
                                style: Styles.main40012,
                              )
                            ],
                          ),
                          Dimens.boxHeight5,
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: 1,
                            itemBuilder: (context, i) {
                              if (controller.bookmarkUserList[index].deletedfor!
                                  .any((element) =>
                                      element.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds))) {
                                return DeleteMessage(
                                  isSend: true,
                                  isDelivered: controller
                                              .bookmarkUserList[index].status ==
                                          "delivered"
                                      ? true
                                      : false,
                                  isSeen: controller
                                              .bookmarkUserList[index].status ==
                                          "seen"
                                      ? true
                                      : false,
                                  time: Utility.getTimeStempToTimeHHMMAA(
                                    controller
                                        .bookmarkUserList[index].senttimestamp,
                                  ),
                                  isEdited: false,
                                );
                              } else {
                                switch (controller
                                    .bookmarkUserList[index].contentType) {
                                  case 'text':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      switch (controller.bookmarkUserList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                            ),
                                          );
                                        case 'photo':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ImageWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              images: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LinksWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              image: '',
                                            ),
                                          );
                                        case 'docs':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: DocsWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              fileName: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                            ),
                                          );
                                        case 'video':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: VideoWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              video: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBookMarksMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .bookmarkUserList[
                                                                index],
                                                            false,
                                                            true);
                                                  },
                                                  child:
                                                      ReplayContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .bookmarks
                                                            ?.isNotEmpty ??
                                                        false,
                                                    isFavorites: false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.nickname ??
                                                        "",
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBookMarksMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .bookmarkUserList[
                                                                index],
                                                            false,
                                                            true);
                                                  },
                                                  child:
                                                      ReplayMultiContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .bookmarks
                                                            ?.isNotEmpty ??
                                                        false,
                                                    isFavorites: false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact
                                                            .length
                                                            .toString() ??
                                                        "",
                                                  ),
                                                );
                                        case 'audio':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: AudioWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              isSend: true,
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: PollWithText(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isSend: true,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.poll
                                                      .pollid
                                                      ?.polltitle ??
                                                  "",
                                            ),
                                          );
                                        case 'location':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LocationWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                            ),
                                          );
                                        case 'photowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: TextWithPhotoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: TextWithVideoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'productwithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: TextWithProductWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayVideoCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        case 'audiocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayAudioCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        default:
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: OnlyMessage(
                                          isSeenStatus: false,
                                          isSend: true,
                                          message: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp,
                                          ),
                                          isEdited: false,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBrodcast: false,
                                        ),
                                      );
                                    }
                                  case 'photo':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayPhotoMessage(
                                          isSeenStatus: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                          isGroup: false,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: SingleImageMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          images: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp),
                                          isBrodcast: controller
                                                  .bookmarkUserList[index]
                                                  .isbroadcasted ??
                                              false,
                                        ),
                                      );
                                    }
                                  case 'photowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: ImageWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        images: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'photowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: ImageWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        isEdited: false,
                                        images: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'links':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      switch (controller.bookmarkUserList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: TextWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .bookmarkUserList[index]
                                                        .content
                                                        ?.text
                                                        .message ??
                                                    "");
                                              },
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBookMarksMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .bookmarkUserList[
                                                                index],
                                                            false,
                                                            true);
                                                  },
                                                  child: ReplayContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .bookmarks
                                                            ?.isNotEmpty ??
                                                        false,
                                                    isFavorites: false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.nickname ??
                                                        "",
                                                  ),
                                                )
                                              : GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBookMarksMessageDialog(
                                                            context,
                                                            details,
                                                            controller
                                                                    .bookmarkUserList[
                                                                index],
                                                            false,
                                                            true);
                                                  },
                                                  child:
                                                      ReplayMultiContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .bookmarks
                                                            ?.isNotEmpty ??
                                                        false,
                                                    isFavorites: false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkUserList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact
                                                            .length
                                                            .toString() ??
                                                        "",
                                                  ),
                                                );
                                        case 'photo':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ImageWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isSend: true,
                                              isEdited: false,
                                              images: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                            ),
                                          );
                                        case 'video':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: VideoWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              video: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'docs':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: DocsWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              fileName: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'audio':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: AudioWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isSend: true,
                                              isEdited: false,
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .senttimestamp),
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                            ),
                                          );
                                        case 'location':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LocationWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isSend: true,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: PollWithLinks(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isSend: true,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkUserList[index]
                                                      .context
                                                      ?.content
                                                      ?.poll
                                                      .pollid
                                                      ?.polltitle ??
                                                  "",
                                            ),
                                          );
                                        case 'photowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LinksWithPhotoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LinksWithVideoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'productwithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LinksWithProductWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayVideoCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        case 'audiocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: ReplayAudioCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkUserList[index],
                                              isSend: true,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        default:
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .bookmarkUserList[
                                                          index],
                                                      false,
                                                      true);
                                            },
                                            child: LinkMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkUserList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkUserList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: LinkMessage(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isEdited: false,
                                          isSend: true,
                                          message: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp,
                                          ),
                                        ),
                                      );
                                    }
                                  case 'docs':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayDocsMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: DocsMessage(
                                          isSeenStatus: false,
                                          onTap: () {
                                            Utility.downloadAndSavePDF(
                                                controller
                                                        .bookmarkUserList[index]
                                                        .content
                                                        ?.media
                                                        .path ??
                                                    "",
                                                'ChatNest',
                                                0);
                                            controller.update();
                                          },
                                          isBrodcast: controller
                                                  .bookmarkUserList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          fileName: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .name ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp,
                                          ),
                                          fileUrl: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          extensions: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .name
                                                  .split('.')
                                                  .last ??
                                              "",
                                        ),
                                      );
                                    }
                                  case 'docswithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: DocsWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                      ),
                                    );
                                  case 'docswithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: DocsWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                      ),
                                    );
                                  case 'video':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayVideoMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: SingleVideoMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          video: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'videowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: VideoWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        isEdited: false,
                                        video: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'videowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: VideoWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        video: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'audio':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayAudioMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: MusicPlay(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .bookmarkUserList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          audioUrl: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'audiowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: AudioWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .bookmarkUserList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller.bookmarkUserList[index]
                                                    .from?.fullname ??
                                                controller
                                                    .bookmarkUserList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'audiowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: AudioWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .bookmarkUserList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller.bookmarkUserList[index]
                                                    .from?.fullname ??
                                                controller
                                                    .bookmarkUserList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'location':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayLocationMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ShareCurrentLocation(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .bookmarkUserList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkUserList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .bookmarkUserList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp),
                                          businessProfileLatLag: LatLng(
                                            controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.location
                                                .coordinates[1],
                                            controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.location
                                                .coordinates[0],
                                          ),
                                          onTap: (latLng) async {
                                            MapsLauncher.launchCoordinates(
                                              controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[1],
                                              controller
                                                  .bookmarkUserList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[0],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  case 'contact':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayContactMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return controller.bookmarkUserList[index]
                                                  .content?.contact.length ==
                                              1
                                          ? GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .bookmarkUserList[
                                                            index],
                                                        false,
                                                        true);
                                              },
                                              child: ShareContact(
                                                onMessageTap: () {
                                                  for (var datas in controller
                                                          .bookmarkUserList[
                                                              index]
                                                          .content
                                                          ?.contact ??
                                                      <ContactContent>[]) {
                                                    if (datas.isfriend ==
                                                        "no") {
                                                      Get.dialog(
                                                          SentRequestDialog(
                                                        formKey: controller
                                                            .sendRequestKey,
                                                        title: datas.userdata
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
                                                            controller.sendNewFriendFavoriteRequest(
                                                                datas.usersid ??
                                                                    "",
                                                                controller
                                                                    .messageController
                                                                    .text,
                                                                index,
                                                                false,
                                                                true);
                                                          }
                                                        },
                                                      ));
                                                    } else if (datas.isfriend ==
                                                        "sent") {
                                                      controller
                                                          .cancelSentFavoriteRequest(
                                                              datas.friendrequestid ??
                                                                  "",
                                                              index,
                                                              false,
                                                              true);
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
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: controller
                                                        .bookmarkUserList[index]
                                                        .bookmarks
                                                        ?.isNotEmpty ??
                                                    false,
                                                isFavorites: false,
                                                isDelivered: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: true,
                                                contactList: controller
                                                        .bookmarkUserList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller
                                                                .bookmarkUserList[
                                                            index],
                                                        false,
                                                        true);
                                              },
                                              child: ShareMultipulConect(
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: controller
                                                        .bookmarkUserList[index]
                                                        .bookmarks
                                                        ?.isNotEmpty ??
                                                    false,
                                                isFavorites: false,
                                                isDelivered: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .bookmarkUserList[
                                                                index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: true,
                                                contactList: controller
                                                        .bookmarkUserList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                onTap: () {
                                                  controller.getContactList
                                                      .clear();
                                                  RouteManagement
                                                      .goToViewAllContact(controller
                                                              .bookmarkUserList[
                                                                  index]
                                                              .content
                                                              ?.contact ??
                                                          []);
                                                },
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .bookmarkUserList[index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            );
                                    }
                                  case 'poll':
                                    if (controller
                                            .bookmarkUserList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: ReplayPollsMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkUserList[index],
                                                  false,
                                                  true);
                                        },
                                        child: PollMessage(
                                          key: controller
                                              .bookmarkUserList[index]
                                              .content
                                              ?.poll
                                              .pollid
                                              ?.key,
                                          onVote: (choice) {
                                            controller.postPollVote(
                                                controller
                                                    .bookmarkUserList[index]
                                                    .content
                                                    ?.poll,
                                                controller
                                                        .bookmarkUserList[index]
                                                        .content
                                                        ?.poll
                                                        .pollid
                                                        ?.options[choice]
                                                        .id ??
                                                    "");
                                          },
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .bookmarkUserList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    }
                                  case 'product':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: SingleProduct(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkUserList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.description ??
                                            "",
                                      ),
                                    );
                                  case 'productwithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: ProductWithMessage(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkUserList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.description ??
                                            "",
                                      ),
                                    );
                                  case 'productwithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: ProductWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkUserList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.description ??
                                            "",
                                      ),
                                    );
                                  case 'multimedia':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: MultipalImage(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkUserList[index],
                                        isSend: true,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'multimediawithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: MultipalImageWithText(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkUserList[index],
                                        isSend: true,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'multimediawithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: MultipalImageWithLinks(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkUserList[index],
                                        isSend: true,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'videocall':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: VideoCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkUserList[index],
                                        isSend: true,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'audiocall':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: AudioCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkUserList[index],
                                        isSend: true,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  default:
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBookMarksMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .bookmarkUserList[index],
                                                false,
                                                true);
                                      },
                                      child: OnlyMessage(
                                        isSeenStatus: false,
                                        isDelivered: controller
                                                    .bookmarkUserList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isSend: true,
                                        message: controller
                                                .bookmarkUserList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkUserList[index]
                                                .senttimestamp),
                                        isBookmark: controller
                                                .bookmarkUserList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isBrodcast: false,
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
      );
    });
  }
}
