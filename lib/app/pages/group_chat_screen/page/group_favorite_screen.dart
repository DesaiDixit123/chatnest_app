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

class GroupFavoriteMessageScreen extends StatelessWidget {
  const GroupFavoriteMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) async {
      var controller = Get.find<ChatController>();
      await controller.listGroupFavoriteMessage(1);
      controller.scrollGroupFavoriteController.addListener(() async {
        if (controller.scrollGroupFavoriteController.position.pixels ==
            controller.scrollGroupFavoriteController.position.maxScrollExtent) {
          if (controller.isGroupFavoriteLoading == false) {
            controller.isGroupFavoriteLoading = true;
            controller.update();
            if (controller.isGroupFavoriteLastPage == false) {
              await controller
                  .listGroupFavoriteMessage(controller.pageGroupFavoriteCount);
            }
            controller.isGroupFavoriteLoading = false;
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
                colorFilter: const ColorFilter.mode(
                  ColorsValue.maincolor1,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ),
          title: Text(
            'favorite_message'.tr,
            style: Styles.black70018,
          ),
        ),
        body: Padding(
          padding: Dimens.edgeInsets20,
          child: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => controller.listGroupFavoriteMessage(1),
            ),
            color: ColorsValue.appColor,
            child: controller.chatGroupFavoriteList.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      AssetConstants.chat_empty,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: controller.scrollGroupFavoriteController,
                    itemCount: controller.chatGroupFavoriteList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = false;
                      String? newDate = '';
                      if (index == 0 &&
                          controller.chatGroupFavoriteList.length == 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .chatGroupFavoriteList[index].timestamp
                                .toString())
                            .toString();
                      } else if (index ==
                          controller.chatGroupFavoriteList.length - 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .chatGroupFavoriteList[index].timestamp
                                .toString())
                            .toString();
                      } else {
                        final DateTime date =
                            controller.returnDateAndTimeFormat(controller
                                .chatGroupFavoriteList[index].timestamp
                                .toString());
                        final DateTime prevDate =
                            controller.returnDateAndTimeFormat(controller
                                .chatGroupFavoriteList[index + 1].timestamp
                                .toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : controller
                                .groupMessageDateAndTime(controller
                                    .chatGroupFavoriteList[index].timestamp
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
                            crossAxisAlignment: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller
                                        .chatGroupFavoriteList[index].from?.id
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller
                                        .chatGroupFavoriteList[index].from?.id
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
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
                                        (controller.chatGroupFavoriteList[index]
                                                .from?.profileimage ??
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
                                        controller.chatGroupFavoriteList[index]
                                            .from?.id
                                    ? "You"
                                    : controller.chatGroupFavoriteList[index]
                                            .from?.nickname ??
                                        controller.chatGroupFavoriteList[index]
                                            .from?.fullname ??
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
                              if (controller
                                  .chatGroupFavoriteList[index].deletedfor!
                                  .any((element) =>
                                      element.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds))) {
                                return DeleteMessage(
                                  isSend: Get.find<Repository>().getStringValue(
                                              LocalKeys.userIds) ==
                                          controller
                                              .chatGroupFavoriteList[index]
                                              .from
                                              ?.id
                                      ? true
                                      : false,
                                  isDelivered: controller
                                              .chatGroupFavoriteList[index]
                                              .status ==
                                          "delivered"
                                      ? true
                                      : false,
                                  isSeen: controller
                                              .chatGroupFavoriteList[index]
                                              .status ==
                                          "seen"
                                      ? true
                                      : false,
                                  time: Utility.getTimeStempToTimeHHMMAA(
                                    controller
                                        .chatGroupFavoriteList[index].timestamp,
                                  ),
                                  isEdited: false,
                                );
                              } else {
                                switch (controller
                                    .chatGroupFavoriteList[index].contentType) {
                                  case 'text':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      switch (controller
                                          .chatGroupFavoriteList[index]
                                          .context
                                          ?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'photo':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ImageWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              images: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.timestamp),
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.timestamp),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: DocsWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.timestamp),
                                              fileName: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .chatGroupFavoriteList[
                                                          index]
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: VideoWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              video: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .context
                                                    ?.timestamp,
                                              ),
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoGroupFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatGroupFavoriteList[
                                                          index],
                                                    );
                                                  },
                                                  child:
                                                      ReplayContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: false,
                                                    isFavorites: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .favorites
                                                            ?.isNotEmpty ??
                                                        false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .timestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatGroupFavoriteList[
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
                                                        .infoGroupFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatGroupFavoriteList[
                                                          index],
                                                    );
                                                  },
                                                  child:
                                                      ReplayMultiContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: false,
                                                    isFavorites: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .favorites
                                                            ?.isNotEmpty ??
                                                        false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .timestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatGroupFavoriteList[
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: AudioWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: PollWithText(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LocationWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'photowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithPhotoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithVideoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'productwithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithProductWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayVideoCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        case 'audiocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayAudioCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        default:
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: OnlyMessage(
                                          isSeenStatus: false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp,
                                          ),
                                          isEdited: false,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBrodcast: false,
                                        ),
                                      );
                                    }
                                  case 'photo':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPhotoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                          isGroup: false,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: SingleImageMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          images: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp),
                                          isBrodcast: controller
                                                  .chatGroupFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                        ),
                                      );
                                    }
                                  case 'photowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        images: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                      ),
                                    );
                                  case 'photowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        images: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                      ),
                                    );
                                  case 'links':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      switch (controller
                                          .chatGroupFavoriteList[index]
                                          .context
                                          ?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .content
                                                        ?.text
                                                        .message ??
                                                    "");
                                              },
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoGroupFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatGroupFavoriteList[
                                                          index],
                                                    );
                                                  },
                                                  child: ReplayContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: false,
                                                    isFavorites: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .favorites
                                                            ?.isNotEmpty ??
                                                        false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .timestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatGroupFavoriteList[
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
                                                        .infoGroupFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatGroupFavoriteList[
                                                          index],
                                                    );
                                                  },
                                                  child:
                                                      ReplayMultiContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: false,
                                                    isFavorites: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .favorites
                                                            ?.isNotEmpty ??
                                                        false,
                                                    userName: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: Get.find<
                                                                    Repository>()
                                                                .getStringValue(
                                                                    LocalKeys
                                                                        .userIds) ==
                                                            controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatGroupFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .timestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatGroupFavoriteList[
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ImageWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              images: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.timestamp),
                                            ),
                                          );
                                        case 'video':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: VideoWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              video: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .context
                                                    ?.timestamp,
                                              ),
                                            ),
                                          );
                                        case 'docs':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: DocsWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              fileName: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .context
                                                    ?.timestamp,
                                              ),
                                            ),
                                          );
                                        case 'audio':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: AudioWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .timestamp),
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatGroupFavoriteList[
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LocationWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: PollWithLinks(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                              replayChat: controller
                                                      .chatGroupFavoriteList[
                                                          index]
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
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithPhotoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithVideoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'productwithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithProductWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                              isGroup: false,
                                            ),
                                          );
                                        case 'videocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayVideoCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        case 'audiocall':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayAudioCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatGroupFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              onEmojiRemove: null,
                                            ),
                                          );
                                        default:
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoGroupFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                        .chatGroupFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinkMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatGroupFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .timestamp,
                                              ),
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: LinkMessage(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isEdited: false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp,
                                          ),
                                        ),
                                      );
                                    }
                                  case 'docs':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayDocsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: DocsMessage(
                                          isSeenStatus: false,
                                          onTap: () {
                                            Utility.downloadAndSavePDF(
                                                controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .content
                                                        ?.media
                                                        .path ??
                                                    "",
                                                'ChatNest',
                                                0);
                                            controller.update();
                                          },
                                          isBrodcast: controller
                                                  .chatGroupFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          fileName: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .name ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp,
                                          ),
                                          fileUrl: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          extensions: controller
                                                  .chatGroupFavoriteList[index]
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
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                        fileName: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .chatGroupFavoriteList[index]
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
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                        fileName: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                      ),
                                    );
                                  case 'video':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayVideoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: SingleVideoMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          video: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp),
                                        ),
                                      );
                                    }
                                  case 'videowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        video: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                      ),
                                    );
                                  case 'videowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        video: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                      ),
                                    );
                                  case 'audio':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayAudioMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: MusicPlay(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .chatGroupFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          audioUrl: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp),
                                        ),
                                      );
                                    }
                                  case 'audiowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.fullname ??
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'audiowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.fullname ??
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'location':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayLocationMessage(
                                          isSeenStatus: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ShareCurrentLocation(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .chatGroupFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatGroupFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp),
                                          businessProfileLatLag: LatLng(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[1],
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[0],
                                          ),
                                          onTap: (latLng) async {
                                            MapsLauncher.launchCoordinates(
                                              controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[1],
                                              controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[0],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  case 'contact':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayContactMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return controller
                                                  .chatGroupFavoriteList[index]
                                                  .content
                                                  ?.contact
                                                  .length ==
                                              1
                                          ? GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoGroupFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                          .chatGroupFavoriteList[
                                                      index],
                                                );
                                              },
                                              child: ShareContact(
                                                onMessageTap: () {
                                                  for (var datas in controller
                                                          .chatGroupFavoriteList[
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
                                                                true,
                                                                false);
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
                                                              true,
                                                              false);
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
                                                isBookmark: false,
                                                isFavorites: controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: Get.find<Repository>()
                                                            .getStringValue(
                                                                LocalKeys
                                                                    .userIds) ==
                                                        controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoGroupFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                          .chatGroupFavoriteList[
                                                      index],
                                                );
                                              },
                                              child: ShareMultipulConect(
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: false,
                                                isFavorites: controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: Get.find<Repository>()
                                                            .getStringValue(
                                                                LocalKeys
                                                                    .userIds) ==
                                                        controller
                                                            .chatGroupFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                onTap: () {
                                                  RouteManagement
                                                      .goToViewAllContact(controller
                                                              .chatGroupFavoriteList[
                                                                  index]
                                                              .content
                                                              ?.contact ??
                                                          []);
                                                },
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .timestamp,
                                                ),
                                              ),
                                            );
                                    }
                                  case 'poll':
                                    if (controller.chatGroupFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPollsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoGroupFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .chatGroupFavoriteList[index],
                                          );
                                        },
                                        child: PollMessage(
                                          key: controller
                                              .chatGroupFavoriteList[index]
                                              .content
                                              ?.poll
                                              .pollid
                                              ?.key,
                                          onVote: (choice) {
                                            controller.postPollVote(
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .content
                                                    ?.poll,
                                                controller
                                                        .chatGroupFavoriteList[
                                                            index]
                                                        .content
                                                        ?.poll
                                                        .pollid
                                                        ?.options[choice]
                                                        .id ??
                                                    "");
                                          },
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatGroupFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatGroupFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    }
                                  case 'product':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: SingleProduct(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller
                                              .chatGroupFavoriteList[index]
                                              .timestamp,
                                        ),
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatGroupFavoriteList[index]
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
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithMessage(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller
                                              .chatGroupFavoriteList[index]
                                              .timestamp,
                                        ),
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatGroupFavoriteList[index]
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
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller
                                              .chatGroupFavoriteList[index]
                                              .timestamp,
                                        ),
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatGroupFavoriteList[index]
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
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImage(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .chatGroupFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'multimediawithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithText(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .chatGroupFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'multimediawithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithLinks(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .chatGroupFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'videocall':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: VideoCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .chatGroupFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  case 'audiocall':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: AudioCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .chatGroupFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        onEmojiRemove: null,
                                      ),
                                    );
                                  default:
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoGroupFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .chatGroupFavoriteList[index],
                                        );
                                      },
                                      child: OnlyMessage(
                                        isSeenStatus: false,
                                        isDelivered: controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatGroupFavoriteList[
                                                        index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatGroupFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .chatGroupFavoriteList[index]
                                                .timestamp),
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatGroupFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
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
