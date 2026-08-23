import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(initState: (state) async {
      var controller = Get.find<ChatController>();
      await controller.postBookmarksList(1);
      controller.scrollBookmarkdController.addListener(() async {
        if (controller.scrollBookmarkdController.position.pixels ==
            controller.scrollBookmarkdController.position.maxScrollExtent) {
          if (controller.isBookmarksLoading == false) {
            controller.isBookmarksLoading = true;
            controller.update();
            if (controller.isbookmarkLastPage == false) {
              await controller.postBookmarksList(controller.pageBookmarkCount);
            }
            controller.isBookmarksLoading = false;
            controller.update();
          }
        }
      });
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: GradientAppBar(
          // shadowColor: ColorsValue.greyAAAAAA,
          //   backgroundColor: ColorsValue.white,
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
              () => controller.postBookmarksList(1),
            ),
            color: ColorsValue.appColor,
            child: controller.bookmarkList.isEmpty
                ? Center(
                    child: SvgPicture.asset(
                      AssetConstants.ic_empty_bookmark,
                    ),
                  )
                : ListView.builder(
                    reverse: true,
                    controller: controller.scrollBookmarkdController,
                    itemCount: controller.bookmarkList.length,
                    itemBuilder: (context, index) {
                      bool isSameDate = false;
                      String? newDate = '';
                      if (index == 0 && controller.bookmarkList.length == 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .bookmarkList[index].senttimestamp
                                .toString())
                            .toString();
                      } else if (index == controller.bookmarkList.length - 1) {
                        newDate = controller
                            .groupMessageDateAndTime(controller
                                .bookmarkList[index].senttimestamp
                                .toString())
                            .toString();
                      } else {
                        final DateTime date =
                            controller.returnDateAndTimeFormat(controller
                                .bookmarkList[index].senttimestamp
                                .toString());
                        final DateTime prevDate =
                            controller.returnDateAndTimeFormat(controller
                                .bookmarkList[index + 1].senttimestamp
                                .toString());
                        isSameDate = date.isAtSameMomentAs(prevDate);

                        if (kDebugMode) {
                          print("$date $prevDate $isSameDate");
                        }
                        newDate = isSameDate
                            ? ''
                            : controller
                                .groupMessageDateAndTime(controller
                                    .bookmarkList[index].senttimestamp
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
                                        (controller.bookmarkList[index].from
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
                                        controller.bookmarkList[index].from?.id
                                    ? "You"
                                    : controller.bookmarkList[index].from
                                            ?.nickname ??
                                        controller.bookmarkList[index].from
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
                              if (controller.bookmarkList[index].deletedfor!
                                  .any((element) =>
                                      element.userid?.id ==
                                      Get.find<Repository>()
                                          .getStringValue(LocalKeys.userIds))) {
                                return DeleteMessage(
                                  isSend: true,
                                  isDelivered:
                                      controller.bookmarkList[index].status ==
                                              "delivered"
                                          ? true
                                          : false,
                                  isSeen:
                                      controller.bookmarkList[index].status ==
                                              "seen"
                                          ? true
                                          : false,
                                  time: Utility.getTimeStempToTimeHHMMAA(
                                    controller
                                        .bookmarkList[index].senttimestamp,
                                  ),
                                  isEdited: false,
                                );
                              } else {
                                switch (controller
                                    .bookmarkList[index].contentType) {
                                  case 'text':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      switch (controller.bookmarkList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ImageWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              images: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.senttimestamp),
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: LinksWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.senttimestamp),
                                              replayChat: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: DocsWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.senttimestamp),
                                              fileName: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: VideoWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              video: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .context?.senttimestamp,
                                              ),
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility.infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                                  },
                                                  child:
                                                      ReplayContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkList[index]
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
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkList[index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .bookmarkList[index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkList[index]
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
                                                    ChatScreenUtility.infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                                  },
                                                  child:
                                                      ReplayMultiContactWithMessage(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkList[index]
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
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkList[index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: AudioWithText(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              isSend: true,
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: PollWithText(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: TextWithPhotoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: TextWithVideoWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: TextWithProductWithText(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ReplayVideoCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ReplayAudioCallWithMessage(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: OnlyMessage(
                                          isSeenStatus: false,
                                          isSend: true,
                                          message: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp,
                                          ),
                                          isEdited: false,
                                          isBookmark: controller
                                                  .bookmarkList[index]
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
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayPhotoMessage(
                                          isSeenStatus: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: SingleImageMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          images: controller.bookmarkList[index]
                                                  .content?.media.path ??
                                              "",
                                          message: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
                                                      .senttimestamp),
                                          isBrodcast: controller
                                                  .bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: ImageWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        images: controller.bookmarkList[index]
                                                .content?.media.path ??
                                            "",
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: ImageWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        isEdited: false,
                                        images: controller.bookmarkList[index]
                                                .content?.media.path ??
                                            "",
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'links':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      switch (controller.bookmarkList[index]
                                          .context?.contentType) {
                                        case 'text':
                                          return GestureDetector(
                                            onLongPressStart: (details) {
                                              ChatScreenUtility
                                                  .infoBookMarksMessageDialog(
                                                      context,
                                                      details,
                                                      controller
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: TextWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              onTap: () {
                                                Utility.launchLinkURL(controller
                                                        .bookmarkList[index]
                                                        .content
                                                        ?.text
                                                        .message ??
                                                    "");
                                              },
                                            ),
                                          );
                                        case 'contact':
                                          return controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.contact
                                                      .length ==
                                                  1
                                              ? GestureDetector(
                                                  onLongPressStart: (details) {
                                                    ChatScreenUtility.infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                                  },
                                                  child: ReplayContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkList[index]
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
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkList[index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    images: controller
                                                            .bookmarkList[index]
                                                            .context
                                                            ?.content
                                                            ?.contact[0]
                                                            .userid
                                                            ?.profileimage ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkList[index]
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
                                                    ChatScreenUtility.infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                                  },
                                                  child:
                                                      ReplayMultiContactWithLinks(
                                                    isSeenStatus: false,
                                                    isEdited: false,
                                                    emoji: const [],
                                                    onEmojiRemove: null,
                                                    isBookmark: controller
                                                            .bookmarkList[index]
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
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.id
                                                        ? "You"
                                                        : controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.fullname ??
                                                            controller
                                                                .bookmarkList[
                                                                    index]
                                                                .from
                                                                ?.nickname ??
                                                            "",
                                                    isSend: true,
                                                    message: controller
                                                            .bookmarkList[index]
                                                            .content
                                                            ?.text
                                                            .message ??
                                                        "",
                                                    isDelivered: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "delivered"
                                                        ? true
                                                        : false,
                                                    isSeen: controller
                                                                .bookmarkList[
                                                                    index]
                                                                .status ==
                                                            "seen"
                                                        ? true
                                                        : false,
                                                    time: Utility
                                                        .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .senttimestamp,
                                                    ),
                                                    replayChat: controller
                                                            .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ImageWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isSend: true,
                                              isEdited: false,
                                              images: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: VideoWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              video: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .context?.senttimestamp,
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: DocsWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .context
                                                          ?.status ==
                                                      "sent"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              fileName: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name ??
                                                  "",
                                              extensions: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .name
                                                      .split('.')
                                                      .last ??
                                                  "",
                                              fileUrl: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.media
                                                      .path ??
                                                  "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .context?.senttimestamp,
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: AudioWithLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isSend: true,
                                              isEdited: false,
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                      controller
                                                          .bookmarkList[index]
                                                          .senttimestamp),
                                              userName: Get.find<Repository>()
                                                          .getStringValue(
                                                              LocalKeys
                                                                  .userIds) ==
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ReplayLinks(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              replayChat: controller
                                                      .bookmarkList[index]
                                                      .context
                                                      ?.content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: PollWithLinks(
                                              isSeenStatus: false,
                                              isEdited: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.id
                                                  ? "You"
                                                  : controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.nickname ??
                                                      controller
                                                          .bookmarkList[index]
                                                          .from
                                                          ?.fullname ??
                                                      "",
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
                                                    .senttimestamp,
                                              ),
                                              replayChat: controller
                                                      .bookmarkList[index]
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: LinksWithPhotoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: LinksWithVideoWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: LinksWithProductWithLinks(
                                              isSeenStatus: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ReplayVideoCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: ReplayAudioCallWithLinks(
                                              isSeenStatus: false,
                                              isGroup: false,
                                              chatListsDocData: controller
                                                  .bookmarkList[index],
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
                                                          .bookmarkList[index],
                                                      controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .statuses
                                                                  ?.isEmpty ??
                                                              false
                                                          ? false
                                                          : true,
                                                      false);
                                            },
                                            child: LinkMessage(
                                              isSeenStatus: false,
                                              emoji: const [],
                                              onEmojiRemove: null,
                                              isBookmark: controller
                                                      .bookmarkList[index]
                                                      .bookmarks
                                                      ?.isNotEmpty ??
                                                  false,
                                              isFavorites: false,
                                              isDelivered: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "delivered"
                                                  ? true
                                                  : false,
                                              isSeen: controller
                                                          .bookmarkList[index]
                                                          .status ==
                                                      "seen"
                                                  ? true
                                                  : false,
                                              isEdited: false,
                                              isSend: true,
                                              message: controller
                                                      .bookmarkList[index]
                                                      .content
                                                      ?.text
                                                      .message ??
                                                  "",
                                              time: Utility
                                                  .getTimeStempToTimeHHMMAA(
                                                controller.bookmarkList[index]
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: LinkMessage(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isEdited: false,
                                          isSend: true,
                                          message: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp,
                                          ),
                                        ),
                                      );
                                    }
                                  case 'docs':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayDocsMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: DocsMessage(
                                          isSeenStatus: false,
                                          onTap: () {
                                            Utility.downloadAndSavePDF(
                                                controller.bookmarkList[index]
                                                        .content?.media.path ??
                                                    "",
                                                'ChatNest',
                                                0);
                                            controller.update();
                                          },
                                          isBrodcast: controller
                                                  .bookmarkList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          fileName: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.media
                                                  .name ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp,
                                          ),
                                          fileUrl: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          extensions: controller
                                                  .bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: DocsWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                        fileName: controller.bookmarkList[index]
                                                .content?.media.name ??
                                            "",
                                        extensions: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller.bookmarkList[index]
                                                .content?.media.path ??
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: DocsWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                        fileName: controller.bookmarkList[index]
                                                .content?.media.name ??
                                            "",
                                        extensions: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.media
                                                .name
                                                .split('.')
                                                .last ??
                                            "",
                                        fileUrl: controller.bookmarkList[index]
                                                .content?.media.path ??
                                            "",
                                      ),
                                    );
                                  case 'video':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayVideoMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: SingleVideoMsg(
                                          isSeenStatus: false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          video: controller.bookmarkList[index]
                                                  .content?.media.path ??
                                              "",
                                          message: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: VideoWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        isEdited: false,
                                        video: controller.bookmarkList[index]
                                                .content?.media.path ??
                                            "",
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: VideoWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        video: controller.bookmarkList[index]
                                                .content?.media.path ??
                                            "",
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                      ),
                                    );
                                  case 'audio':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayAudioMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: MusicPlay(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .bookmarkList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          audioUrl: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.media
                                                  .path ??
                                              "",
                                          message: controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.text
                                                  .message ??
                                              "",
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: AudioWithText(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.bookmarkList[index]
                                                    .from?.id
                                            ? "You"
                                            : controller.bookmarkList[index]
                                                    .from?.fullname ??
                                                controller.bookmarkList[index]
                                                    .from?.nickname ??
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: AudioWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                        userName: Get.find<Repository>()
                                                    .getStringValue(
                                                        LocalKeys.userIds) ==
                                                controller.bookmarkList[index]
                                                    .from?.id
                                            ? "You"
                                            : controller.bookmarkList[index]
                                                    .from?.fullname ??
                                                controller.bookmarkList[index]
                                                    .from?.nickname ??
                                                "",
                                      ),
                                    );
                                  case 'location':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayLocationMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ShareCurrentLocation(
                                          isSeenStatus: false,
                                          isBrodcast: controller
                                                  .bookmarkList[index]
                                                  .isbroadcasted ??
                                              false,
                                          emoji: const [],
                                          onEmojiRemove: null,
                                          isBookmark: controller
                                                  .bookmarkList[index]
                                                  .bookmarks
                                                  ?.isNotEmpty ??
                                              false,
                                          isFavorites: false,
                                          isDelivered: controller
                                                      .bookmarkList[index]
                                                      .status ==
                                                  "delivered"
                                              ? true
                                              : false,
                                          isSeen: controller.bookmarkList[index]
                                                      .status ==
                                                  "seen"
                                              ? true
                                              : false,
                                          isSend: true,
                                          time:
                                              Utility.getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
                                                      .senttimestamp),
                                          businessProfileLatLag: LatLng(
                                            controller
                                                .bookmarkList[index]
                                                .content
                                                ?.location
                                                .coordinates[1],
                                            controller
                                                .bookmarkList[index]
                                                .content
                                                ?.location
                                                .coordinates[0],
                                          ),
                                          onTap: (latLng) async {
                                            MapsLauncher.launchCoordinates(
                                              controller
                                                  .bookmarkList[index]
                                                  .content
                                                  ?.location
                                                  .coordinates[1],
                                              controller
                                                  .bookmarkList[index]
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
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayContactMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
                                          isSend: true,
                                          onEmojiRemove: null,
                                        ),
                                      );
                                    } else {
                                      return controller.bookmarkList[index]
                                                  .content?.contact.length ==
                                              1
                                          ? GestureDetector(
                                              onLongPressStart: (details) {
                                                ChatScreenUtility
                                                    .infoBookMarksMessageDialog(
                                                        context,
                                                        details,
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                              },
                                              child: ShareContact(
                                                onMessageTap: () {
                                                  for (var datas in controller
                                                          .bookmarkList[index]
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
                                                        .bookmarkList[index]
                                                        .bookmarks
                                                        ?.isNotEmpty ??
                                                    false,
                                                isFavorites: false,
                                                isDelivered: controller
                                                            .bookmarkList[index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .bookmarkList[index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: true,
                                                contactList: controller
                                                        .bookmarkList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
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
                                                        controller.bookmarkList[
                                                            index],
                                                        controller
                                                                    .bookmarkList[
                                                                        index]
                                                                    .statuses
                                                                    ?.isEmpty ??
                                                                false
                                                            ? false
                                                            : true,
                                                        false);
                                              },
                                              child: ShareMultipulConect(
                                                isSeenStatus: false,
                                                emoji: const [],
                                                onEmojiRemove: null,
                                                isBookmark: controller
                                                        .bookmarkList[index]
                                                        .bookmarks
                                                        ?.isNotEmpty ??
                                                    false,
                                                isFavorites: false,
                                                isDelivered: controller
                                                            .bookmarkList[index]
                                                            .status ==
                                                        "delivered"
                                                    ? true
                                                    : false,
                                                isSeen: controller
                                                            .bookmarkList[index]
                                                            .status ==
                                                        "seen"
                                                    ? true
                                                    : false,
                                                isSend: true,
                                                contactList: controller
                                                        .bookmarkList[index]
                                                        .content
                                                        ?.contact ??
                                                    [],
                                                onTap: () {
                                                  controller.getContactList
                                                      .clear();
                                                  RouteManagement
                                                      .goToViewAllContact(
                                                          controller
                                                                  .bookmarkList[
                                                                      index]
                                                                  .content
                                                                  ?.contact ??
                                                              []);
                                                },
                                                time: Utility
                                                    .getTimeStempToTimeHHMMAA(
                                                  controller.bookmarkList[index]
                                                      .senttimestamp,
                                                ),
                                              ),
                                            );
                                    }
                                  case 'poll':
                                    if (controller
                                            .bookmarkList[index].context !=
                                        null) {
                                      return GestureDetector(
                                        onLongPressStart: (details) {
                                          ChatScreenUtility
                                              .infoBookMarksMessageDialog(
                                                  context,
                                                  details,
                                                  controller
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: ReplayPollsMessage(
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                      .bookmarkList[index],
                                                  controller
                                                              .bookmarkList[
                                                                  index]
                                                              .statuses
                                                              ?.isEmpty ??
                                                          false
                                                      ? false
                                                      : true,
                                                  false);
                                        },
                                        child: PollMessage(
                                          key: controller.bookmarkList[index]
                                              .content?.poll.pollid?.key,
                                          onVote: (choice) {
                                            controller.postPollVote(
                                                controller.bookmarkList[index]
                                                    .content?.poll,
                                                controller
                                                        .bookmarkList[index]
                                                        .content
                                                        ?.poll
                                                        .pollid
                                                        ?.options[choice]
                                                        .id ??
                                                    "");
                                          },
                                          isSeenStatus: false,
                                          isGroup: false,
                                          chatListsDocData:
                                              controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: SingleProduct(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        productImage: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: ProductWithMessage(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        productImage: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: ProductWithLinks(
                                        isSeenStatus: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isBookmark: controller
                                                .bookmarkList[index]
                                                .bookmarks
                                                ?.isNotEmpty ??
                                            false,
                                        isFavorites: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: controller.bookmarkList[index]
                                                    .status ==
                                                "seen"
                                            ? true
                                            : false,
                                        isEdited: false,
                                        isSend: true,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                          controller.bookmarkList[index]
                                              .senttimestamp,
                                        ),
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        productImage: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.image ??
                                            "",
                                        productPrice: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.price
                                                .toString() ??
                                            "",
                                        productTitle: controller
                                                .bookmarkList[index]
                                                .content
                                                ?.product
                                                .productid
                                                ?.name ??
                                            "",
                                        productdiscription: controller
                                                .bookmarkList[index]
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: MultipalImage(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: MultipalImageWithText(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: MultipalImageWithLinks(
                                        isSeenStatus: false,
                                        brodcastList: true,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: VideoCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: AudioCall(
                                        isSeenStatus: false,
                                        isGroup: false,
                                        chatListsDocData:
                                            controller.bookmarkList[index],
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
                                                controller.bookmarkList[index],
                                                controller
                                                            .bookmarkList[index]
                                                            .statuses
                                                            ?.isEmpty ??
                                                        false
                                                    ? false
                                                    : true,
                                                false);
                                      },
                                      child: OnlyMessage(
                                        isSeenStatus: false,
                                        isDelivered: controller
                                                    .bookmarkList[index]
                                                    .status ==
                                                "delivered"
                                            ? true
                                            : false,
                                        isSeen: false,
                                        emoji: const [],
                                        onEmojiRemove: null,
                                        isSend: true,
                                        message: controller.bookmarkList[index]
                                                .content?.text.message ??
                                            "",
                                        isEdited: false,
                                        time: Utility.getTimeStempToTimeHHMMAA(
                                            controller.bookmarkList[index]
                                                .senttimestamp),
                                        isBookmark: controller
                                                .bookmarkList[index]
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
