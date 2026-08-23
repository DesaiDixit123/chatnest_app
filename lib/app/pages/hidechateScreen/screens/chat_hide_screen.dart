import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class ChatHideScreen extends StatelessWidget {
  const ChatHideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final debouncer = Debouncer(
      milliseconds: 500,
    );
    return GetBuilder<HideChatController>(initState: (state) {
      var controller = Get.find<HideChatController>();
      controller.chatHidePagingController = PagingController(firstPageKey: 1);
      controller.chatHidePagingController
          .addPageRequestListener((pageKey) async {
        await controller.postChatHideFriends(pageKey);
      });
    }, builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        body: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: CustomTextFormField(
                        controller: controller.serchChatHideController,
                        hintText: 'search'.tr,
                        fillColor: ColorsValue.textfildbackcolor,
                        suffixIcon: Icon(
                          Icons.search,
                          size: Dimens.twentyFour,
                          color: ColorsValue.hookupHeaderGreyColor,
                        ),
                        onChanged: (value) {
                          debouncer.run(() {
                            Future.sync(
                              () {
                                return controller.chatHidePagingController
                                    .refresh();
                              },
                            );
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
                                          Row(
                                            children: [
                                              Transform.scale(
                                                scale: 1.2,
                                                child: Checkbox(
                                                  checkColor: ColorsValue.white,
                                                  activeColor:
                                                      ColorsValue.maincolor1,
                                                  value:
                                                      controller.isContectList,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller.isContectList =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "contectList_friend".tr,
                                                style:
                                                    Styles.greyColor888850014,
                                              )
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
                                                  value:
                                                      controller.isFefildFriend,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller
                                                              .isFefildFriend =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "fe_filed_friends".tr,
                                                style:
                                                    Styles.greyColor888850014,
                                              )
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
                                                  value:
                                                      controller.isReceveFriend,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller
                                                              .isReceveFriend =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "reciver_friend".tr,
                                                style:
                                                    Styles.greyColor888850014,
                                              )
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
                                                  value:
                                                      controller.isSendFriend,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      controller.isSendFriend =
                                                          value!;
                                                    });
                                                  },
                                                ),
                                              ),
                                              Text(
                                                "sender_friend".tr,
                                                style:
                                                    Styles.greyColor888850014,
                                              )
                                            ],
                                          ),
                                          Dimens.boxHeight10,
                                          CustomBottomButton(
                                            firstOnPressed: () {
                                              Get.back();
                                              controller.isUnread = false;
                                              controller.isContectList = false;
                                              controller.isFefildFriend = false;
                                              controller.isReceveFriend = false;
                                              controller.isSendFriend = false;
                                              controller
                                                  .chatHidePagingController
                                                  .refresh();
                                              controller.update();
                                            },
                                            firstbtnText:
                                                'clear'.tr.toUpperCase(),
                                            secondOnPressed: () async {
                                              controller
                                                  .chatHidePagingController
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
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.chatHidePagingController.refresh(),
                    ),
                     color: ColorsValue.appColor,
                    child: PagedListView<int, FriendsListDatum>(
                      pagingController: controller.chatHidePagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<FriendsListDatum>(
                        noItemsFoundIndicatorBuilder: (_) {
                          return Utility.profileData?.chatlockpin?.isEmpty ??
                                  false ||
                                      Utility.profileData?.chatlockpin == null
                              ? Center(
                                  child: Text(
                                    'hide_chat_mesg'.tr,
                                    style: Styles.grey9BA70018,
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : Center(
                                  child: SvgPicture.asset(
                                    AssetConstants.chat_empty,
                                  ),
                                );
                        },
                        itemBuilder: (BuildContext context, item, int index) {
                          return GestureDetector(
                            onLongPressStart: (details) {
                              if (Get.find<HomeScreenController>()
                                      .selectedChateData ==
                                  null) {
                                ChatScreenUtility.pinUnpinSingaleChatHide(
                                    context, details, item);
                              } else {
                                Get.find<HomeScreenController>()
                                    .selectedChateData = null;
                              }
                              Get.forceAppUpdate();
                            },
                            child: ListTile(
                              onTap: () {
                                Get.find<HomeScreenController>()
                                    .selectedChateData = null;
                                RouteManagement.goToChatScreen(
                                    item.userid ?? "", false);
                                Get.forceAppUpdate();
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
                                      child: CachedNetworkImage(
                                        imageUrl: ApiWrapper.imageUrl +
                                            (item.profileimage ?? ""),
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 90,
                                        maxWidthDiskCache: 90,
                                        width: Dimens.fifty,
                                        height: Dimens.fifty,
                                        placeholder: (context, url) =>
                                            Image.asset(
                                          AssetConstants.usera,
                                        ),
                                        errorWidget: (context, url, error) =>
                                            Image.asset(
                                          AssetConstants.usera,
                                        ),
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
                                item.fullname?.isNotEmpty ?? false
                                    ? item.fullname ?? ""
                                    : item.nickname ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.black50016,
                              ),
                              subtitle: Padding(
                                padding: Dimens.edgeInsetsTopt05,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (item
                                            .lastchatmessage?.contentType ==
                                        "label") ...[
                                      Text(
                                        "label",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ] else if (item.lastchatmessage?.contentType == "text" ||
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
                                    ] else if (item
                                            .lastchatmessage?.contentType ==
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
                                    ] else if (item
                                            .lastchatmessage?.contentType ==
                                        "docs") ...[
                                      SvgPicture.asset(
                                        AssetConstants.ic_document,
                                        height: Dimens.fifteen,
                                        width: Dimens.fifteen,
                                      ),
                                      Dimens.boxWidth5,
                                      Text(
                                        item.lastchatmessage?.content?.media
                                                .name ??
                                            "",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ] else if (item
                                            .lastchatmessage?.contentType ==
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
                                    ] else if (item
                                            .lastchatmessage?.contentType ==
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
                                    ] else if (item
                                                .lastchatmessage?.contentType ==
                                            "photowithtext" ||
                                        item
                                                .lastchatmessage?.contentType ==
                                            "videowithtext" ||
                                        item
                                                .lastchatmessage?.contentType ==
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
                                mainAxisAlignment: item.unreadmessageCount == 0
                                    ? MainAxisAlignment.start
                                    : MainAxisAlignment.center,
                                children: [
                                  Text(
                                    Utility.getTimeStempToTime(
                                        item.lastchatmessage?.senttimestamp ??
                                            0),
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
                                              item.unreadmessageCount
                                                  .toString(),
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
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}
