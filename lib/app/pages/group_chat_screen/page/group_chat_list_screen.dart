import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GroupChatListScreen extends StatelessWidget {
  const GroupChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<GroupChatController>(initState: (state) {
      debugPrint('GroupChatListScreen initState');
      var controller = Get.find<GroupChatController>();
      controller.groupListPagingController = PagingController(firstPageKey: 1);
      controller.groupListPagingController.addPageRequestListener((pagekey) async {
        debugPrint('GroupChatListScreen page request for $pagekey');
        await controller.groupsUserChatList(pagekey);
      });
      // force initial load in case the paging controller doesn't trigger automatically
      WidgetsBinding.instance.addPostFrameCallback((_) {
        try {
          controller.groupListPagingController.refresh();
        } catch (_) {}
      });
    }, builder: (controller) {
      debugPrint('GroupChatListScreen builder called');
      return Scaffold(
        backgroundColor: ColorsValue.white,
        floatingActionButton:
            Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)
                ? Container()
                : FloatingActionButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        Dimens.sixty,
                      ),
                    ),
                    backgroundColor: ColorsValue.maincolor1,
                    onPressed: () {
                      controller.getOneGroupData = null;
                      controller.update();
                      RouteManagement.goToCreateGroupScreen(false);
                    },
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                      size: Dimens.thirty,
                    ),
                  ),
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: Dimens.edgeInsets20_0_20_0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.groupSearchController,
                        hintText: 'search'.tr,
                        fillColor: ColorsValue.textfildbackcolor,
                        onChanged: (value) {
                          _debouncer.run(() {
                            controller.groupListPagingController.refresh();
                            controller.update();
                          });
                        },
                        suffixIcon: Icon(
                          Icons.search,
                          size: Dimens.twentyFour,
                          color: ColorsValue.hookupHeaderGreyColor,
                        ),
                      ),
                    ),
                    Padding(
                      padding: Dimens.edgeInsets10_07_0_0,
                      child: Container(
                        width: Dimens.fourtyFive,
                        height: Dimens.fourtyFive,
                        decoration: BoxDecoration(
                          color: ColorsValue.maincolor1,
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets10,
                          child: InkWell(
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: ColorsValue.white,
                                builder: (context) {
                                  return StatefulBuilder(
                                    builder: (context, setState) {
                                      return Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            topLeft:
                                                Radius.circular(Dimens.thirty),
                                            topRight: Radius.circular(
                                              Dimens.thirty,
                                            ),
                                          ),
                                        ),
                                        child: Padding(
                                          padding: Dimens.edgeInsets20_10_20_30,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    height: Dimens.five,
                                                    width: Dimens.seventy,
                                                    decoration: BoxDecoration(
                                                      color: ColorsValue.grey,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              Dimens.hundred),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Dimens.boxHeight20,
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "group_chat_filter_option"
                                                        .tr,
                                                    style: Styles.black50020,
                                                  ),
                                                  InkWell(
                                                    onTap: () {
                                                      Get.back();
                                                    },
                                                    child: SvgPicture.asset(
                                                        AssetConstants
                                                            .cancleicon),
                                                  ),
                                                ],
                                              ),
                                              Row(
                                                children: [
                                                  Checkbox(
                                                    activeColor:
                                                        ColorsValue.maincolor1,
                                                    checkColor: Colors.white,
                                                    value: controller
                                                        .isUnreadMessage,
                                                    onChanged: (value) {
                                                      if (value ?? false) {
                                                        controller
                                                                .isUnreadMessage =
                                                            value!;
                                                      } else {
                                                        controller
                                                                .isUnreadMessage =
                                                            value!;
                                                      }
                                                      setState(() {});
                                                    },
                                                  ),
                                                  Text(
                                                    "unread_messages".tr,
                                                    style: Styles
                                                        .greyColor888850014,
                                                  )
                                                ],
                                              ),
                                              Dimens.boxHeight10,
                                              CustomBottomButton(
                                                firstOnPressed: () {
                                                  Get.back();
                                                  controller.isUnreadMessage =
                                                      false;
                                                  controller
                                                      .groupListPagingController
                                                      .refresh();
                                                  controller.update();
                                                },
                                                firstbtnText:
                                                    'clear'.tr.toUpperCase(),
                                                secondOnPressed: () {
                                                  Get.back();
                                                  controller.isUnreadMessage =
                                                      true;
                                                  controller
                                                      .groupListPagingController
                                                      .refresh();
                                                  controller.update();
                                                },
                                                secondbtnTxt:
                                                    'apply'.tr.toUpperCase(),
                                                firstStyle:
                                                    Styles.hinttext50014,
                                                secondStyle: Styles.white50014,
                                                bordercolor:
                                                    ColorsValue.greyColor8888,
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            },
                            child: SvgPicture.asset(
                              AssetConstants.filterIcon,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Dimens.boxHeight20,
                if (controller.myArchiveFriendsLists.isNotEmpty) ...[
                  ListTile(
                      onTap: () {
                        RouteManagement.goToArchiveGroupScreen();
                      },
                      contentPadding: Dimens.edgeInsets0,
                      leading: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.hundred,
                          ),
                          color: ColorsValue.maincolor1,
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets12,
                          child: Image.asset(
                            AssetConstants.archive,
                            height: Dimens.twentyFour,
                            width: Dimens.twentyFour,
                            color: ColorsValue.white,
                          ),
                        ),
                      ),
                      title: Text(
                        'Archive Chat'.tr,
                        style: Styles.black50016,
                      ),
                      trailing: Container(
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
                            controller.myArchiveFriendsLists.length.toString(),
                            style: Styles.white40012,
                          ),
                        ),
                      )),
                ],
                Expanded(
                    child: RefreshIndicator(
                  onRefresh: () => Future.sync(
                    () => controller.groupListPagingController.refresh(),
                  ),
                   color: ColorsValue.appColor,
                  child: PagedListView<int, GroupChatDatum>(
                    pagingController: controller.groupListPagingController,
                    builderDelegate: PagedChildBuilderDelegate(
                        noItemsFoundIndicatorBuilder: (_) {
                      return Center(
                        child: SvgPicture.asset(
                          AssetConstants.ic_group_chat_empty,
                        ),
                      );
                    }, itemBuilder: (BuildContext context, item, int index) {
                      return Padding(
                        padding: Dimens.edgeInsets0_5_0_5,
                        child: GestureDetector(
                          onLongPressStart: Get.find<Repository>()
                                  .getBoolValue(LocalKeys.isSubUser)
                              ? null
                              : (details) {
                                  ChatScreenUtility.pinUnpinGroupChat(
                                      context, details, item);
                                },
                          child: ListTile(
                            onTap: () {
                              controller.postReadGroupChat(item.id ?? "");
                              RouteManagement.goToGroupChatScreen(
                                  item.id ?? "");
                              Get.forceAppUpdate();
                            },
                            isThreeLine: true,
                            dense: true,
                            contentPadding: Dimens.edgeInsets0,
                            leading: Get.find<HomeScreenController>()
                                        .selectedGroupChatData ==
                                    controller.groupListPagingController
                                        .itemList?[index]
                                ? Stack(
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
                                          borderRadius: BorderRadius.circular(
                                              Dimens.hundred),
                                           child: ApiWrapper.isValidImageUrl(
                                                   item.profileimage)
                                               ? CachedNetworkImage(
                                                   imageUrl:
                                                       ApiWrapper.imageUrl +
                                                           item.profileimage!,
                                                   fit: BoxFit.cover,
                                                   maxHeightDiskCache: 90,
                                                   maxWidthDiskCache: 90,
                                                   width: Dimens.fifty,
                                                   height: Dimens.fifty,
                                                   placeholder: (context,
                                                           url) =>
                                                       Image.asset(
                                                     AssetConstants.usera,
                                                     fit: BoxFit.cover,
                                                   ),
                                                   errorWidget: (context, url,
                                                           error) =>
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
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: SvgPicture.asset(
                                          AssetConstants.selectedListIcon,
                                        ),
                                      )
                                    ],
                                  )
                                : Container(
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
                                      child: ApiWrapper.isValidImageUrl(
                                              item.profileimage)
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
                            title: Text(
                              item.name ?? "",
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Styles.black50016,
                            ),
                            subtitle: Padding(
                              padding: Dimens.edgeInsetsTopt05,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (item.lastchatmessage?.deletedfor?.isNotEmpty ??
                                      false) ...[
                                    Container(
                                      height: Dimens.zero,
                                    ),
                                  ] else if (item.lastchatmessage?.contentType ==
                                      "label") ...[
                                    Text(
                                      "label",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ] else if (item
                                              .lastchatmessage?.contentType ==
                                          "text" ||
                                      item
                                              .lastchatmessage?.contentType ==
                                          "links") ...[
                                    Flexible(
                                      child: Text(
                                        item.lastchatmessage?.content?.text
                                                .message ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ),
                                  ] else if (item
                                              .lastchatmessage?.contentType ==
                                          "photo" ||
                                      item
                                              .lastchatmessage?.contentType ==
                                          "multimedia" ||
                                      item
                                              .lastchatmessage?.contentType ==
                                          "multimediawithtext" ||
                                      item
                                              .lastchatmessage?.contentType ==
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
                                    Icon(
                                      Icons.videocam,
                                      size: Dimens.fifteen,
                                      color: ColorsValue.greyColor8888,
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
                                    Flexible(
                                      child: Text(
                                        item.lastchatmessage?.content?.media
                                                .name ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ),
                                  ] else if (item.lastchatmessage?.contentType ==
                                          "contact" ||
                                      item
                                              .lastchatmessage?.contentType ==
                                          "phonecontact") ...[
                                    Icon(
                                      Icons.person,
                                      size: Dimens.fifteen,
                                      color: ColorsValue.greyColor8888,
                                    ),
                                    Dimens.boxWidth5,
                                    Text(
                                      item.lastchatmessage?.contentType ==
                                              "phonecontact"
                                          ? "PhoneContact"
                                          : "contact".tr,
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
                                  ] else if (item
                                          .lastchatmessage?.contentType ==
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
                                  ] else if (item
                                          .lastchatmessage?.contentType ==
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
                                  ] else if (item
                                          .lastchatmessage?.contentType ==
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
                                  ] else if (item
                                              .lastchatmessage?.contentType ==
                                          "photowithtext" ||
                                      item
                                              .lastchatmessage?.contentType ==
                                          "videowithtext" ||
                                      item.lastchatmessage?.contentType ==
                                          "audiowithtext" ||
                                      item.lastchatmessage?.contentType ==
                                          "docswithtext" ||
                                      item.lastchatmessage?.contentType ==
                                          "productwithtext") ...[
                                    Text(
                                      item.lastchatmessage?.content?.text
                                              .message ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ] else if (item
                                              .lastchatmessage?.contentType ==
                                          "photowithlinks" ||
                                      item.lastchatmessage?.contentType ==
                                          "videowithlinks" ||
                                      item.lastchatmessage?.contentType ==
                                          "audiowithlinks" ||
                                      item.lastchatmessage?.contentType ==
                                          "docswithlinks" ||
                                      item.lastchatmessage?.contentType ==
                                          "productwithlinks") ...[
                                    Text(
                                      item.lastchatmessage?.content?.text
                                              .message ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ] else if (item
                                          .lastchatmessage?.contentType ==
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
                                  ] else if (item
                                          .lastchatmessage?.contentType ==
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  item.lastchatmessage?.timestamp != 0
                                      ? Utility.getTimeStempToTime(
                                          item.lastchatmessage?.timestamp ?? "")
                                      : Utility.getFormatedTime(
                                          item.createdAt ?? ""),
                                  // "",
                                  style: Styles.main70012,
                                ),
                                Dimens.boxHeight3,
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Visibility(
                                      visible: item.pinned ?? false,
                                      child: SvgPicture.asset(
                                        AssetConstants.pinIcon,
                                        height: Dimens.twenty,
                                        width: Dimens.twenty,
                                      ),
                                    ),
                                    if (item.isgroupmarkedunread ?? false) ...[
                                      Container(
                                        height: Dimens.twenty,
                                        width: Dimens.twenty,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.fifty,
                                          ),
                                          color: ColorsValue.maincolor1,
                                        ),
                                      ),
                                    ] else ...[
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
                                              item.unreadmessageCount
                                                  .toString(),
                                              style: Styles.white40012,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ]
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  ),
                ))
              ],
            ),
          ),
        ),
      );
    });
  }
}
