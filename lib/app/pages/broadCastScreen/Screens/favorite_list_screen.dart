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

class BrodcastFavoriteListScreen extends StatelessWidget {
  const BrodcastFavoriteListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) async {
      var controller = Get.find<ChatController>();
      controller.broadcastid = Get.arguments ?? "";
      await controller.postListFavoriteMessages(1);
      controller.scrollBrodcastFavoriteController.addListener(() async {
        if (controller.scrollBrodcastFavoriteController.position.pixels ==
            controller
                .scrollBrodcastFavoriteController.position.maxScrollExtent) {
          if (controller.isBrodcastFavoriteLoading == false) {
            controller.isBrodcastFavoriteLoading = true;
            controller.update();
            if (controller.isBrodcastFavoriteLastPage == false) {
              await controller.postListFavoriteMessages(
                  controller.pageBrodcastFavoriteCount);
            }
            controller.isBrodcastFavoriteLoading = false;
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
              () => controller.postListFavoriteMessages(1),
            ),
            color: ColorsValue.appColor,
            child: controller.brodcastFavoriteList.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      AssetConstants.chat_empty,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: controller.scrollBrodcastFavoriteController,
                    itemCount: controller.brodcastFavoriteList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = false;
                      String? newDate = '';
                      if (index == 0 &&
                          controller.brodcastFavoriteList.length == 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .brodcastFavoriteList[index].senttimestamp
                                .toString())
                            .toString();
                      } else if (index ==
                          controller.brodcastFavoriteList.length - 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .brodcastFavoriteList[index].senttimestamp
                                .toString())
                            .toString();
                      } else {
                        final DateTime date =
                            controller.returnDateAndTimeFormat(controller
                                .brodcastFavoriteList[index].senttimestamp
                                .toString());
                        final DateTime prevDate =
                            controller.returnDateAndTimeFormat(controller
                                .brodcastFavoriteList[index + 1].senttimestamp
                                .toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : controller
                                .groupMessageDateAndTime(controller
                                    .brodcastFavoriteList[index].senttimestamp
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
                                        .brodcastFavoriteList[index].from?.id
                                ? CrossAxisAlignment.end
                                : CrossAxisAlignment.start,
                            mainAxisAlignment: Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    controller
                                        .brodcastFavoriteList[index].from?.id
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
                                        (controller.brodcastFavoriteList[index]
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
                                        controller.brodcastFavoriteList[index]
                                            .from?.id
                                    ? "You"
                                    : controller.brodcastFavoriteList[index]
                                            .from?.nickname ??
                                        controller.brodcastFavoriteList[index]
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
                                  .brodcastFavoriteList[index].deletedfor!
                                  .any((element) =>
                                      element.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds))) {
                                return DeleteMessage(
                                  isSend: Get.find<Repository>().getStringValue(
                                              LocalKeys.userIds) ==
                                          controller.brodcastFavoriteList[index]
                                              .from?.id
                                      ? true
                                      : false,
                                  isDelivered: controller
                                              .brodcastFavoriteList[index]
                                              .status ==
                                          "delivered"
                                      ? true
                                      : false,
                                  isSeen: controller.brodcastFavoriteList[index]
                                              .status ==
                                          "seen"
                                      ? true
                                      : false,
                                  time: Utility.getTimeStempToTimeHHMMAA(
                                    controller.brodcastFavoriteList[index]
                                        .senttimestamp,
                                  ),
                                  isEdited: false,
                                );
                              } else {
                                switch (controller
                                    .brodcastFavoriteList[index].contentType) {
                                  case 'text':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      switch (controller
                                          .brodcastFavoriteList[index]
                                          .context
                                          ?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ImageWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              images: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: DocsWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                              fileName: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: VideoWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              video: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBrodcastFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .brodcastFavoriteList[
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
                                                        .infoBrodcastFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: AudioWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithPhotoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithVideoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithProductWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayVideoCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayAudioCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: OnlyMessage(
                                          isSeenStatus: false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                          isEdited: false,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
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
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPhotoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: SingleImageMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          images: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp),
                                          isBrodcast: controller
                                                  .brodcastFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                        ),
                                      );
                                    }
                                  case 'photowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        images: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'photowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: ImageWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        images: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'links':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      switch (controller
                                          .brodcastFavoriteList[index]
                                          .context
                                          ?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: TextWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .brodcastFavoriteList[
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
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility
                                                        .infoBrodcastFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .brodcastFavoriteList[
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
                                                        .infoBrodcastFavoriteMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                              .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .brodcastFavoriteList[
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
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? true
                                                        : false,
                                                    message: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .brodcastFavoriteList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ImageWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              images: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .context
                                                          ?.senttimestamp),
                                            ),
                                          );
                                        case 'video':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: VideoWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              video: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'docs':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: DocsWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              fileName: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .context
                                                    ?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'audio':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: AudioWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .senttimestamp),
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'poll':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
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
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithPhotoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithVideoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinksWithProductWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayVideoCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: ReplayAudioCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .brodcastFavoriteList[index],
                                              isSend: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .brodcastFavoriteList[
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
                                                  .infoBrodcastFavoriteMessageDialog(
                                                context,
                                                details,
                                                controller.brodcastFavoriteList[
                                                    index],
                                              );
                                            },
                                            child: LinkMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: false,
                                              isFavorites: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .favorites
                                                      ?.isNotEmpty ??
                                                  false,
                                              isDelivered: controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .brodcastFavoriteList[
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
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .from
                                                          ?.id
                                                  ? true
                                                  : false,
                                              message: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .senttimestamp,
                                              ),
                                            ),
                                          );
                                      }
                                    } else {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: LinkMessage(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
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
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          message: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                        ),
                                      );
                                    }
                                  case 'docs':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayDocsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: DocsMessage(
                                          isSeenStatus: false,
                                          onTap: () {
                                            Utility.downloadAndSavePDF(
                                                controller
                                                        .brodcastFavoriteList[
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
                                                  .brodcastFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          fileName: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .name ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp,
                                          ),
                                          fileUrl: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          extensions: controller
                                                  .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: DocsWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                        fileName: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .name ??
                                            "",
                                        extensions: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                      ),
                                    );
                                  case 'video':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayVideoMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: SingleVideoMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          video: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'videowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        isEdited: false,
                                        video: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'videowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: VideoWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        video: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.media
                                                .path ??
                                            "",
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'audio':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayAudioMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: MusicPlay(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .brodcastFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          audioUrl: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp),
                                        ),
                                      );
                                    }
                                  case 'audiowithtext':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.fullname ??
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'audiowithlinks':
                                    return GestureDetector(
                                      onLongPressStart: (details) {
                                        ChatScreenUtility
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: AudioWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? "You"
                                            : controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.fullname ??
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'location':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayLocationMessage(
                                          isSeenStatus: false,
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ShareCurrentLocation(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .brodcastFavoriteList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: false,
                                          isFavorites: controller
                                                  .brodcastFavoriteList[index]
                                                  .favorites
                                                  ?.isNotEmpty ??
                                              false,
                                          isDelivered: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .from
                                                      ?.id
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp),
                                          businessProfileLatLag: LatLng(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[1],
                                            controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.location
                                                .coordinates[0],
                                          ),
                                          onTap: (latLng) async {
                                            MapsLauncher.launchCoordinates(
                                              controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[1],
                                              controller
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[0],
                                            );
                                          },
                                        ),
                                      );
                                    }
                                  case 'contact':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayContactMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                                  .brodcastFavoriteList[index]
                                                  .content
                                                  ?.contact
                                                  .length ==
                                              1
                                          ? GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoBrodcastFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                          .brodcastFavoriteList[
                                                      index],
                                                );
                                              },
                                              child: ShareContact(
                                                onMessageTap: () {
                                                  for (var datas in controller
                                                          .brodcastFavoriteList[
                                                              index]
                                                          .content
                                                          ?.contact ??
                                                      <ContactContent>[]) {
                                                    RouteManagement
                                                        .gooffAndToNamedChatScreen(
                                                            datas.userdata
                                                                    ?.id ??
                                                                "",
                                                            false);
                                                  }
                                                },
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: false,
                                                isFavorites: controller
                                                        .brodcastFavoriteList[
                                                            index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .brodcastFavoriteList[
                                                            index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            )
                                          : GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoBrodcastFavoriteMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                          .brodcastFavoriteList[
                                                      index],
                                                );
                                              },
                                              child: ShareMultipulConect(
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: false,
                                                isFavorites: controller
                                                        .brodcastFavoriteList[
                                                            index]
                                                        .favorites
                                                        ?.isNotEmpty ??
                                                    false,
                                                isDelivered: controller
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .brodcastFavoriteList[
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
                                                            .brodcastFavoriteList[
                                                                index]
                                                            .from
                                                            ?.id
                                                    ? true
                                                    : false,
                                                contactList: controller
                                                        .brodcastFavoriteList[
                                                            index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                onTap: () {
                                                  RouteManagement
                                                      .goToViewAllContact(controller
                                                              .brodcastFavoriteList[
                                                                  index]
                                                              .content
                                                              ?.contact ??
                                                          []);
                                                },
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller
                                                      .brodcastFavoriteList[
                                                          index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            );
                                    }
                                  case 'poll':
                                    if (controller.brodcastFavoriteList[index]
                                            .context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: ReplayPollsMessage(
                                          bookmarkList: false,
                                          favoriteList: true,
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData: controller
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                              .infoBrodcastFavoriteMessageDialog(
                                            context,
                                            details,
                                            controller
                                                .brodcastFavoriteList[index],
                                          );
                                        },
                                        child: PollMessage(
                                          key: controller
                                              .brodcastFavoriteList[index]
                                              .content
                                              ?.poll
                                              .pollid
                                              ?.key,
                                          onVote: (choice) {
                                            controller.postPollVote(
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .content
                                                    ?.poll,
                                                controller
                                                        .brodcastFavoriteList[
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
                                              .brodcastFavoriteList[index],
                                          isSend: Get.find<Repository>()
                                                      .getStringValue(
                                                          LocalKeys.userIds) ==
                                                  controller
                                                      .brodcastFavoriteList[
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: SingleProduct(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.brodcastFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithMessage(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.brodcastFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: ProductWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
                                                .favorites
                                                ?.isNotEmpty ??
                                            false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller
                                                    .brodcastFavoriteList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.brodcastFavoriteList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        productImage: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImage(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .brodcastFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithText(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .brodcastFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: MultipalImageWithLinks(
                                        isSeenStatus: false,
                                        brodcastList: false,
                                        favoriteList: true,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .brodcastFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: VideoCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .brodcastFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: AudioCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData: controller
                                            .brodcastFavoriteList[index],
                                        isSend: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller
                                                    .brodcastFavoriteList[index]
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
                                            .infoBrodcastFavoriteMessageDialog(
                                          context,
                                          details,
                                          controller
                                              .brodcastFavoriteList[index],
                                        );
                                      },
                                      child: OnlyMessage(
                                        isSeenStatus: false,
                                        isDelivered: controller
                                                    .brodcastFavoriteList[index]
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
                                                    .brodcastFavoriteList[index]
                                                    .from
                                                    ?.id
                                            ? true
                                            : false,
                                        message: controller
                                                .brodcastFavoriteList[index]
                                                .content
                                                ?.text
                                                .message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller
                                                .brodcastFavoriteList[index]
                                                .senttimestamp),
                                        isBookmark: false,
                                        isFavorites: controller
                                                .brodcastFavoriteList[index]
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
