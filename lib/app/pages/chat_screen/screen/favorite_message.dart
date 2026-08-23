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

class FavoriteMessageScreen extends StatelessWidget {
  const FavoriteMessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) async {
      var controller = Get.find<ChatController>();
      await controller.listFavoriteMessage(1);
      controller.scrollFavoriteController.addListener(() async {
        if (controller.scrollFavoriteController.position.pixels ==
            controller.scrollFavoriteController.position.maxScrollExtent) {
          if (controller.isFavoriteLoading == false) {
            controller.isFavoriteLoading = true;
            controller.update();
            if (controller.isFavoriteLastPage == false) {
              await controller.listFavoriteMessage(controller.pagFavoriteCount);
            }
            controller.isFavoriteLoading = false;
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
              () => controller.listFavoriteMessage(1),
            ),
            color: ColorsValue.appColor,
            child: controller.chatFavoriteList.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      AssetConstants.chat_empty,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: controller.scrollController,
                    itemCount: controller.chatFavoriteList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = false;
                      String? newDate = '';
                      if (index == 0 &&
                          controller.chatFavoriteList.length == 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .chatFavoriteList[index].senttimestamp
                                .toString())
                            .toString();
                      } else if (index ==
                          controller.chatFavoriteList.length - 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .chatFavoriteList[index].senttimestamp
                                .toString())
                            .toString();
                      } else {
                        final DateTime date =
                            controller.returnDateAndTimeFormat(controller
                                .chatFavoriteList[index].senttimestamp
                                .toString());
                        final DateTime prevDate =
                            controller.returnDateAndTimeFormat(controller
                                .chatFavoriteList[index + 1].senttimestamp
                                .toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : controller
                                .groupMessageDateAndTime(controller
                                    .chatFavoriteList[index].senttimestamp
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
                                    controller.chatFavoriteList[index].from?.id
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller.chatFavoriteList[index].from?.id
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
                                        (controller.chatFavoriteList[index].from
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
                                            .chatFavoriteList[index].from?.id
                                    ? "You"
                                    : controller.chatFavoriteList[index].from
                                            ?.nickname ??
                                        controller.chatFavoriteList[index].from
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
                              if (controller.chatFavoriteList[index].deletedfor!
                                  .any((element) =>
                                      element.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds))) {
                                return DeleteMessage(
                                  isSend: Get.find<Repository>().getStringValue(
                                              LocalKeys.userIds) ==
                                          controller
                                              .chatFavoriteList[index].from?.id
                                      ? true
                                      : false,
                                  isDelivered: controller
                                              .chatFavoriteList[index].status ==
                                          "delivered"
                                      ? true
                                      : false,
                                  isSeen: controller
                                              .chatFavoriteList[index].status ==
                                          "seen"
                                      ? true
                                      : false,
                                  time: Utility.getTimeStempToTimeHHMMAA(
                                    controller
                                        .chatFavoriteList[index].senttimestamp,
                                  ),
                                  isEdited: false,
                                );
                              } else {
                                switch (controller
                                    .chatFavoriteList[index].contentType) {
                                  case 'text':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      switch (controller.chatFavoriteList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
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
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'photo':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ImageWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              images: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: LinksWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: DocsWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              fileName: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .chatFavoriteList[index]
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: VideoWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              video: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatFavoriteList[
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
                                                            .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatFavoriteList[
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
                                                        .infFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatFavoriteList[
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
                                                            .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: AudioWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: PollWithText(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
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
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'photowithtext':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: TextWithPhotoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: TextWithVideoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: TextWithProductWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ReplayVideoCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ReplayAudioCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
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
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: OnlyMessage(
                                          isSeenStatus: false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                          isEdited: false,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
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
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPhotoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: SingleImageMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          images: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp),
                                          isBrodcast: controller
                                                  .chatFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                        ),
                                      );
                                    }
                                  case 'photowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        images: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'photowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        images: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'links':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      switch (controller.chatFavoriteList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: TextWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .chatFavoriteList[index]
                                                        .content
                                                        ?.text
                                                        .message ??
                                                    "");
                                              },
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatFavoriteList[
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
                                                            .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatFavoriteList[
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
                                                        .infFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .chatFavoriteList[
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
                                                            .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .chatFavoriteList[
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
                                                                .chatFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .chatFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ImageWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              images: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                            ),
                                          );
                                        case 'video':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: VideoWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              video: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'docs':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: DocsWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              fileName: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'audio':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: AudioWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .senttimestamp),
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
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
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                            ),
                                          );
                                        case 'links':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ReplayLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .chatFavoriteList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: PollWithLinks(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .chatFavoriteList[index]
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: LinksWithPhotoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: LinksWithVideoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: LinksWithProductWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ReplayVideoCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: ReplayAudioCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .chatFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .chatFavoriteList[
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
                                                  .infFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller
                                                    .chatFavoriteList[index],
                                              );
                                            },
                                            child: LinkMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .chatFavoriteList[index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .chatFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .chatFavoriteList[
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
                                                          .chatFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .chatFavoriteList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: LinkMessage(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isEdited: false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                        ),
                                      );
                                    }
                                  case 'docs':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayDocsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: DocsMessage(
                                          isSeenStatus: false,
                                          onTap: () {
                                            Utility.downloadAndSavePDF(
                                                controller
                                                        .chatFavoriteList[index]
                                                        .content
                                                        ?.media
                                                        .path ??
                                                    "",
                                                'ChatNest',
                                                0);
                                            controller.update();
                                          },
                                          isBrodcast: controller
                                                  .chatFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          fileName: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .name ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                          fileUrl: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          extensions: controller
                                                  .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                      ),
                                    );
                                  case 'video':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayVideoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: SingleVideoMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          video: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'videowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        video: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'videowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        video: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'audio':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayAudioMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: MusicPlay(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .chatFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          audioUrl: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'audiowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller.chatFavoriteList[index]
                                                    .from?.fullname ??
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'audiowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller.chatFavoriteList[index]
                                                    .from?.fullname ??
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'location':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayLocationMessage(
                                          isSeenStatus: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ShareCurrentLocation(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .chatFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .chatFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .chatFavoriteList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp),
                                          businessProfileLatLag: LatLng(
                                            controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[1],
                                            controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[0],
                                          ),
                                          onTap: (latLng) async {
                                            MapsLauncher.launchCoordinates(
                                              controller
                                                  .chatFavoriteList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[1],
                                              controller
                                                  .chatFavoriteList[index]
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
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayContactMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return controller.chatFavoriteList[index]
                                                  .content?.contact.length ==
                                              1
                                          ? GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .chatFavoriteList[index],
                                                );
                                              },
                                              child: ShareContact(
                                                onMessageTap: () {
                                                  for (var datas in controller
                                                          .chatFavoriteList[
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
                                                              false,
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
                                                        .chatFavoriteList[index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .chatFavoriteList[
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
                                                            .chatFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .chatFavoriteList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .chatFavoriteList[index],
                                                );
                                              },
                                              child: ShareMultipulConect(
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: false,
                                                isFavorites: controller
                                                        .chatFavoriteList[index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .chatFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .chatFavoriteList[
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
                                                            .chatFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .chatFavoriteList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                onTap: () {
                                                  controller.getContactList
                                                      .clear();
                                                  RouteManagement
                                                      .goToViewAllContact(controller
                                                              .chatFavoriteList[
                                                                  index]
                                                              .content
                                                              ?.contact ??
                                                          []);
                                                },
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .chatFavoriteList[index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            );
                                    }
                                  case 'poll':
                                    if (controller
                                            .chatFavoriteList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPollsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                              .infFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller.chatFavoriteList[index],
                                          );
                                        },
                                        child: PollMessage(
                                          key: controller
                                              .chatFavoriteList[index]
                                              .content
                                              ?.poll
                                              .pollid
                                              ?.key,
                                          onVote: (choice) {
                                            controller.postPollVote(
                                                controller
                                                    .chatFavoriteList[index]
                                                    .content
                                                    ?.poll,
                                                controller
                                                        .chatFavoriteList[index]
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
                                              .chatFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: SingleProduct(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.chatFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithMessage(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.chatFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .chatFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.chatFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImage(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.chatFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithText(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.chatFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithLinks(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.chatFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: VideoCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.chatFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: AudioCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.chatFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .chatFavoriteList[index]
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
                                            .infFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller.chatFavoriteList[index],
                                        );
                                      },
                                      child: OnlyMessage(
                                        isSeenStatus: false,
                                        isDelivered: controller
                                                    .chatFavoriteList[index]
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
                                                    .chatFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .chatFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.chatFavoriteList[index]
                                                .senttimestamp),
                                        isBookmark: false,
                                        isFavorites: controller
                                                .chatFavoriteList[index]
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
