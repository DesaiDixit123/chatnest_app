import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(
      milliseconds: 500,
    );
    return GetBuilder<ChatController>(initState: (state) {
      debugPrint('ChatListScreen initState');
      var controller = Get.find<ChatController>();
      WidgetsBinding.instance.addPostFrameCallback((_) {
        debugPrint('ChatListScreen postFrame: refreshing chatPagingController');
        try {
          controller.applyLocalFilter();
        } catch (_) {}
      });
    }, builder: (controller) {
      //final callController = Get.find<CallController>();

      debugPrint('ChatListScreen builder called');
      return Scaffold(
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 38.0),
          child: FloatingActionButton(
            onPressed: () {
              RouteManagement.goToContactListScreen();
            },
            child: const Icon(Icons.person_add),
          ),
        ),
        backgroundColor: ColorsValue.white,
        body: RefreshIndicator(
          onRefresh: () => Future.sync(
            () => controller.chatPagingController.refresh(),
          ),
          color: ColorsValue.appColor,
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              padding: Dimens.edgeInsets20,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.serchController,
                        hintText: 'search'.tr,
                        fillColor: ColorsValue.textfildbackcolor,
                        suffixIcon: Icon(
                          Icons.search,
                          size: Dimens.twentyFour,
                          color: ColorsValue.hookupHeaderGreyColor,
                        ),
                        onChanged: (value) {
                          debouncer.run(() {
                            controller.applyLocalFilter();
                          });
                        },
                      ),
                    ),
                    Padding(
                      padding: Dimens.edgeInsets10_07_0_0,
                      child: InkWell(
                        onTap: () {
                          controller.messageFocusNode.unfocus();
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
                                        topLeft: Radius.circular(Dimens.thirty),
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
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                "chate_filter".tr,
                                                style: Styles.black50020,
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: SvgPicture.asset(
                                                    AssetConstants.cancleicon),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  checkColor: ColorsValue.white,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  value: controller.isUnread,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller.isUnread =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "unread_message".tr,
                                                style:
                                                    Styles.greyColor888850014,
                                              )
                                            ],
                                          ),
                                          // Row(
                                          //   children: [
                                          //     Transform.scale(
                                          //       scale: 1.2,
                                          //       child: Checkbox(
                                          //         checkColor:
                                          //             ColorsValue.white,
                                          //         activeColor: ColorsValue
                                          //             .maincolor1,
                                          //         value: controller
                                          //             .isContectList,
                                          //         onChanged: (value) {
                                          //           setState(() {
                                          //             controller
                                          //                     .isContectList =
                                          //                 value!;
                                          //           });
                                          //         },
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       "contectList_friend".tr,
                                          //       style: Styles
                                          //           .greyColor888850014,
                                          //     )
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Transform.scale(
                                          //       scale: 1.2,
                                          //       child: Checkbox(
                                          //         checkColor:
                                          //             ColorsValue.white,
                                          //         activeColor: ColorsValue
                                          //             .maincolor1,
                                          //         value: controller
                                          //             .isFefildFriend,
                                          //         onChanged: (value) {
                                          //           setState(() {
                                          //             controller
                                          //                     .isFefildFriend =
                                          //                 value!;
                                          //           });
                                          //         },
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       "fe_filed_friends".tr,
                                          //       style: Styles
                                          //           .greyColor888850014,
                                          //     )
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Transform.scale(
                                          //       scale: 1.2,
                                          //       child: Checkbox(
                                          //         checkColor:
                                          //             ColorsValue.white,
                                          //         activeColor: ColorsValue
                                          //             .maincolor1,
                                          //         value: controller
                                          //             .isReceveFriend,
                                          //         onChanged: (value) {
                                          //           setState(() {
                                          //             controller
                                          //                     .isReceveFriend =
                                          //                 value!;
                                          //           });
                                          //         },
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       "reciver_friend".tr,
                                          //       style: Styles
                                          //           .greyColor888850014,
                                          //     )
                                          //   ],
                                          // ),
                                          // Row(
                                          //   children: [
                                          //     Transform.scale(
                                          //       scale: 1.2,
                                          //       child: Checkbox(
                                          //         checkColor:
                                          //             ColorsValue.white,
                                          //         activeColor: ColorsValue
                                          //             .maincolor1,
                                          //         value: controller
                                          //             .isSendFriend,
                                          //         onChanged: (value) {
                                          //           setState(() {
                                          //             controller
                                          //                     .isSendFriend =
                                          //                 value!;
                                          //           });
                                          //         },
                                          //       ),
                                          //     ),
                                          //     Text(
                                          //       "sender_friend".tr,
                                          //       style: Styles
                                          //           .greyColor888850014,
                                          //     )
                                          //   ],
                                          // ),
                                          Dimens.boxHeight10,
                                          CustomBottomButton(
                                            firstOnPressed: () {
                                              Get.back();
                                              controller.isUnread = false;
                                              controller.isContectList = false;
                                              controller.isFefildFriend = false;
                                              controller.isReceveFriend = false;
                                              controller.isSendFriend = false;
                                              controller.chatPagingController
                                                  .refresh();
                                              controller.update();
                                            },
                                            firstbtnText:
                                                'clear'.tr.toUpperCase(),
                                            secondOnPressed: () async {
                                              controller.chatPagingController
                                                  .refresh();
                                              Get.back();
                                            },
                                            secondbtnTxt:
                                                'apply'.tr.toUpperCase(),
                                            firstStyle: Styles.hinttext50014,
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
                        child: Container(
                          width: Dimens.fourtyFive,
                          height: Dimens.fourtyFive,
                          decoration: BoxDecoration(
                            color: ColorsValue.maincolor1,
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets10,
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
                        RouteManagement.goToArchiveScreen();
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
                ListTile(
                  onTap: () {
                    RouteManagement.goToNotificationListScreen();
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
                      child: SvgPicture.asset(
                        AssetConstants.ic_notification,
                        height: Dimens.twentyFour,
                        width: Dimens.twentyFour,
                      ),
                    ),
                  ),
                  title: Text(
                    'notification'.tr,
                    style: Styles.black50016,
                  ),
                  subtitle: Text(
                    "Latest updates & announcements",
                    style: Styles.greyColor888840012,
                  ),
                ),
                PagedListView<int, MyFriendDatum>(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  pagingController: controller.chatPagingController,
                  builderDelegate: PagedChildBuilderDelegate<MyFriendDatum>(
                    noItemsFoundIndicatorBuilder: (_) {
                      return Center(
                        child: SvgPicture.asset(
                          AssetConstants.chat_empty,
                        ),
                      );
                    },
                    itemBuilder: (BuildContext context, item, int index) {
                      return GestureDetector(
                        onLongPressStart: Get.find<Repository>()
                                .getBoolValue(LocalKeys.isSubUser)
                            ? null
                            : (details) {
                                ChatScreenUtility.pinUnpinSingaleChat(
                                    context, details, item);
                              },
                        child: ListTile(
                          onTap: () {
                            controller.markChatAsReadLocal(
                              item.friendrequestid ?? "",
                              item.userid ?? "",
                            );

                            RouteManagement.goToChatScreen(
                                item.userid ?? "", false);

                            // Fire API in background (no refresh!)
                            controller.postReadChat(item.friendrequestid);
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
                                  child: (item.userid ==
                                              Get.find<Repository>()
                                                  .getStringValue(
                                                      LocalKeys.userIds) &&
                                          !(Get.find<HomeScreenController>()
                                                  .isProfile ??
                                              false))
                                      ? Image.asset(
                                          AssetConstants.usera,
                                          fit: BoxFit.cover,
                                          width: Dimens.fifty,
                                          height: Dimens.fifty,
                                        )
                                      : ApiWrapper.isValidImageUrl(
                                              item.profileimage)
                                          ? CachedNetworkImage(
                                              imageUrl:
                                                  ApiWrapper.getFullImageUrl(
                                                      item.profileimage),
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
                                              errorWidget:
                                                  (context, url, error) =>
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
                                if (item.isBlocked ?? false) ...[
                                  Text(
                                    item.blockedBy == Get.find<Repository>().getStringValue(LocalKeys.userIds)
                                        ? "You blocked this user".tr
                                        : "Blocked".tr,
                                    style: const TextStyle(
                                      color: ColorsValue.redColor,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    ),
                                  ),
                                ] else if (item.userid ==
                                    Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds)) ...[
                                  Text(
                                    "Message yourself".tr,
                                    style: Styles.greyColor888840012,
                                  ),
                                ] else if (item.lastchatmessage?.deletedfor?.isNotEmpty ??
                                    false) ...[
                                  Container(
                                    height: Dimens.zero,
                                  ),
                                ] else if (item.lastchatmessage?.contentType ==
                                    "label") ...[
                                  Text(
                                    "",
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
                                      item.lastchatmessage?.content?.text
                                              .message ??
                                          "",
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
                                  ),
                                ] else if (item.lastchatmessage?.contentType ==
                                        "photo" ||
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
                                    item.lastchatmessage?.content?.media.name ??
                                        "",
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: Styles.greyColor888840012,
                                  ),
                                ] else if (item.lastchatmessage?.contentType == "contact" ||
                                    item.lastchatmessage?.contentType ==
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
                                      item.lastchatmessage?.content?.text
                                              .message ??
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
                                      item.lastchatmessage?.content?.text
                                              .message ??
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
                                    (item.lastchatmessage?.callid
                                                    ?.isgroupcall ??
                                                false) ||
                                            ((item.lastchatmessage?.callid
                                                        ?.members?.length ??
                                                    0) >
                                                2)
                                        ? "conference_call".tr
                                        : "audio_call".tr,
                                    style: Styles.greyColor888840012,
                                  ),
                                ] else if (item.lastchatmessage?.contentType ==
                                    "statusreply") ...[
                                  Icon(
                                    Icons.reply,
                                    size: Dimens.fifteen,
                                    color: ColorsValue.greyColor8888,
                                  ),
                                  Dimens.boxWidth5,
                                  Flexible(
                                    child: Text(
                                      item.lastchatmessage?.content?.text
                                              .message ??
                                          'Status Reply',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: Styles.greyColor888840012,
                                    ),
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
                                  if ((item.isPinned ?? false) &&
                                      !Get.find<Repository>().getBoolValue(
                                          LocalKeys.isSubUser)) ...[
                                    SvgPicture.asset(
                                      AssetConstants.pinIcon,
                                      height: Dimens.twenty,
                                      width: Dimens.twenty,
                                    ),
                                    Dimens.boxWidth3,
                                  ],
                                  if (item.ismarkedasunread ?? false) ...[
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
                                            item.unreadmessageCount.toString(),
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
                      );
                    },
                  ),
                ),
                // GetBuilder<CallController>(
                //   init: Get.find<CallController>(),
                //   builder: (callCtrl) {
                //     // Filter to only show contacts who are NOT on the app
                //     final inviteList = callCtrl.contactsList
                //         .where((contact) => contact.isChatNestUser != true)
                //         .toList();

                //     debugPrint(
                //         '💬 ChatListScreen: GetBuilder<CallController> rebuilding, inviteList.length = ${inviteList.length}');
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Dimens.boxHeight30,
                //         Text("Invite Friends", style: Styles.black70016),
                //         Dimens.boxHeight10,
                //         callCtrl.contactsList.isEmpty
                //             ? const Center(
                //                 child: Padding(
                //                   padding: EdgeInsets.all(20.0),
                //                   child: CircularProgressIndicator(),
                //                 ),
                //               )
                //             : inviteList.isEmpty
                //                 ? const Center(
                //                     child: Padding(
                //                       padding: EdgeInsets.all(20.0),
                //                       child: Text(
                //                           "All your contacts are already on the app!"),
                //                     ),
                //                   )
                //                 : ListView.builder(
                //                     shrinkWrap: true,
                //                     physics:
                //                         const NeverScrollableScrollPhysics(),
                //                     itemCount: inviteList.length,
                //                     itemBuilder: (context, index) {
                //                       final user = inviteList[index];

                //                       return ListTile(
                //                         contentPadding: Dimens.edgeInsets0,
                //                         leading: const CircleAvatar(
                //                           backgroundImage:
                //                               AssetImage(AssetConstants.usera),
                //                         ),
                //                         title: Text(user.contactName ?? ""),
                //                         subtitle:
                //                             Text(user.contactNumber ?? ""),
                //                         trailing: Container(
                //                           padding: const EdgeInsets.symmetric(
                //                               horizontal: 12, vertical: 6),
                //                           decoration: BoxDecoration(
                //                             color: Colors.grey,
                //                             borderRadius:
                //                                 BorderRadius.circular(5),
                //                           ),
                //                           child: Text("INVITE",
                //                               style: Styles.white70010),
                //                         ),
                //                       );
                //                     },
                //                   ),
                //       ],
                //     );
                //   },
                // ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
