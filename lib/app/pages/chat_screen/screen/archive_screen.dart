import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../../data/helpers/api_wrapper.dart';

class ArchiveScreen extends StatelessWidget {
  const ArchiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.postArchiveChatList();
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
                  colorFilter: const ColorFilter.mode(
                    ColorsValue.maincolor1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Text(
              'Archive Chat'.tr,
              style: Styles.black70018,
            ),
          ),
          body: RefreshIndicator(
              onRefresh: () => Future.sync(
                    () => controller.postArchiveChatList(),
                  ),
                   color: ColorsValue.appColor,
              child: ListView.builder(
                padding: Dimens.edgeInsets20,
                itemCount: controller.myArchiveFriendsLists.length,
                itemBuilder: (context, index) {
                  var item = controller.myArchiveFriendsLists[index];
                  return GestureDetector(
                    onLongPressStart: (details) {
                      ChatScreenUtility.archiveRemoveSingaleChat(
                          context, details, item);
                    },
                    child: ListTile(
                      onTap: () {
                        RouteManagement.goToChatScreen(item.userid ?? "",false);
                      },
                      contentPadding: Dimens.edgeInsets0,
                      leading: Stack(
                        children: [
                          Container(
                            height: Dimens.fifty,
                            width: Dimens.fifty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.maincolor1,
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(Dimens.hundred),
                              child: ApiWrapper.isValidImageUrl(item.profileimage)
                                  ? CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          item.profileimage!,
                                      fit: BoxFit.cover,
                                      maxHeightDiskCache: 90,
                                      maxWidthDiskCache: 90,
                                      width: Dimens.fifty,
                                      height: Dimens.fifty,
                                      placeholder: (context, url) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Image.asset(
                                        AssetConstants.usera,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : Image.asset(
                                      AssetConstants.usera,
                                      fit: BoxFit.cover,
                                      width: Dimens.fifty,
                                      height: Dimens.fifty,
                                    ),
                            ),
                          ),
                          if (item.isOnline ?? false) ...[
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Icon(
                                Icons.circle,
                                color: ColorsValue.lightGreen,
                                size: Dimens.fifteen,
                              ),
                            ),
                          ],
                        ],
                      ),
                      title: Text(
                        item.displayName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Styles.black50016,
                      ),
                      subtitle: Padding(
                        padding: Dimens.edgeInsetsTopt05,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (item.lastchatmessage?.contentType ==
                                "label") ...[
                              Text(
                                "label",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                    "text" ||
                                item.lastchatmessage?.contentType ==
                                    "links") ...[
                              Flexible(
                                child: Text(
                                  item.lastchatmessage?.content?.text.message ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            ] else if (item.lastchatmessage?.contentType == "photo" ||
                                item.lastchatmessage?.contentType ==
                                    "multimedia" ||
                                item.lastchatmessage?.contentType ==
                                    "multimediawithtext" ||
                                item.lastchatmessage?.contentType ==
                                    "multimediawithlinks") ...[
                              Icon(
                                Icons.image,
                                size: Dimens.fifteen,
                                color: ColorsValue.greyColor8888,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                'photo'.tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "video") ...[
                              SvgPicture.asset(
                                AssetConstants.videoIcon,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                                colorFilter: ColorFilter.mode(
                                  ColorsValue.greyColor8888,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Dimens.boxWidth5,
                              Text(
                                'video'.tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "docs") ...[
                              SvgPicture.asset(
                                AssetConstants.ic_document,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                item.lastchatmessage?.content?.media.name ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "contact") ...[
                              Icon(
                                Icons.person,
                                size: Dimens.fifteen,
                                color: ColorsValue.greyColor8888,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "contact".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "audio") ...[
                              SvgPicture.asset(
                                AssetConstants.ic_headphone,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                                colorFilter: ColorFilter.mode(
                                  ColorsValue.greyColor8888,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "audio".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "location") ...[
                              Icon(
                                Icons.location_on,
                                size: Dimens.fifteen,
                                color: ColorsValue.greyColor8888,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                'location'.tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "poll") ...[
                              SvgPicture.asset(
                                AssetConstants.ic_poll_reply,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "poll".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "product") ...[
                              SvgPicture.asset(
                                AssetConstants.product_svg,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "product".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                    "photowithtext" ||
                                item.lastchatmessage?.contentType ==
                                    "videowithtext" ||
                                item.lastchatmessage?.contentType ==
                                    "audiowithtext" ||
                                item.lastchatmessage?.contentType ==
                                    "docswithtext" ||
                                item.lastchatmessage?.contentType ==
                                    "productwithtext") ...[
                              Flexible(
                                child: Text(
                                  item.lastchatmessage?.content?.text.message ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                    "photowithlinks" ||
                                item.lastchatmessage?.contentType ==
                                    "videowithlinks" ||
                                item.lastchatmessage?.contentType ==
                                    "audiowithlinks" ||
                                item.lastchatmessage?.contentType ==
                                    "docswithlinks" ||
                                item.lastchatmessage?.contentType ==
                                    "productwithlinks") ...[
                              Flexible(
                                child: Text(
                                  item.lastchatmessage?.content?.text.message ??
                                      "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "videocall") ...[
                              SvgPicture.asset(
                                AssetConstants.videoIcon,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                                colorFilter: ColorFilter.mode(
                                  ColorsValue.greyColor8888,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "video_call".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ] else if (item.lastchatmessage?.contentType ==
                                "audiocall") ...[
                              SvgPicture.asset(
                                AssetConstants.callicon,
                                height: Dimens.fifteen,
                                width: Dimens.fifteen,
                                colorFilter: ColorFilter.mode(
                                  ColorsValue.greyColor8888,
                                  BlendMode.srcIn,
                                ),
                              ),
                              Dimens.boxWidth5,
                              Text(
                                "audio_call".tr,
                                style: Styles.greyColor888840012,
                              ),
                            ],
                          ],
                        ),
                      ),
                      trailing: Column(
                        mainAxisAlignment: item.unreadmessageCount == 0
                            ? MainAxisAlignment.start
                            : MainAxisAlignment.center,
                        children: [
                          Text(
                            Utility.getTimeStempToTime(
                                item.lastchatmessage?.senttimestamp ?? 0),
                            style: Styles.main70012,
                          ),
                          Dimens.boxHeight3,
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (item.isPinned ?? false) ...[
                                SvgPicture.asset(
                                  AssetConstants.pinIcon,
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                ),
                              ],
                              if (item.unreadmessageCount != 0) ...[
                                Container(
                                  height: Dimens.twenty,
                                  width: Dimens.twenty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.fifty,
                                    ),
                                    color: ColorsValue.maincolor1,
                                  ),
                                  child: Center(
                                    child: Text(
                                      item.unreadmessageCount.toString(),
                                      style: Styles.white40012,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              )),
        );
      },
    );
  }
}
