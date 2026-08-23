import 'package:chatnest/app/pages/chat_screen/chat_controller.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter/foundation.dart' as foundation;
import 'package:get/get.dart';

class ChatScreenUtility {
  static void infoMessageDialog(
      context, details, ChatListsDoc chatMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    List<String> emojiList = ["😃", "🤣", "💝", "👍", "➕"];
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                spacing: 0,
                children: emojiList.asMap().entries.map((e) {
                  return Padding(
                    padding: Dimens.edgeInsets5_0_5_0,
                    child: InkWell(
                      onTap: () {
                        if (e.key == 4) {
                          Get.back();
                          emojiDialog(chatMessageList.id, false);
                        } else {
                          Get.back();
                          Get.find<ChatController>().postChatMessageReaction(
                              chatMessageList.id, e.value);
                          Get.find<ChatController>().update();
                        }
                      },
                      child: Text(
                        e.value,
                        style: Styles.black60026,
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        if (chatMessageList.contentType != "multimedia" &&
            chatMessageList.contentType != "multimediawithlinks" &&
            chatMessageList.contentType != "multimediawithtext" &&
            chatMessageList.contentType != "videocall" &&
            chatMessageList.contentType != "audiocall") ...[
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "reply".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.replayIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (!Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) ...[
          PopupMenuItem(
            value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "delet".tr,
                  style: Styles.redColor50014,
                ),
                SvgPicture.asset(
                  AssetConstants.deletIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                chatMessageList.from?.id &&
            (chatMessageList.contentType == "text" ||
                chatMessageList.contentType == "links")) ...[
          PopupMenuItem(
            value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "edit".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.editChatIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (chatMessageList.contentType == "text" ||
            chatMessageList.contentType == "links") ...[
          PopupMenuItem(
            value: 4,
            onTap: () {
              Utility.copyText(chatMessageList.content?.text.message ?? "");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "copy".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.copyIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (chatMessageList.contentType != "videocall" &&
            chatMessageList.contentType != "audiocall") ...[
          PopupMenuItem(
            value: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "forward".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.forwordIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (!Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) ...[
          if (chatMessageList.contentType != "videocall" &&
              chatMessageList.contentType != "audiocall") ...[
            PopupMenuItem(
              value: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (chatMessageList.favorites?.isNotEmpty ?? false)
                        ? "Remove Favorite"
                        : "Add Favorite",
                    style: Styles.black50014,
                  ),
                  SvgPicture.asset(
                    AssetConstants.staricon,
                    height: Dimens.twenty,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        ColorsValue.blackColor, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (chatMessageList.bookmarks?.isNotEmpty ?? false)
                        ? "Remove Bookmark"
                        : "Add Bookmark",
                    style: Styles.black50014,
                  ),
                  Dimens.boxWidth5,
                  SvgPicture.asset(
                    AssetConstants.bookMarkIcon,
                    height: Dimens.twenty,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ],
        if (chatMessageList.contentType != "videocall" &&
            chatMessageList.contentType != "audiocall") ...[
          PopupMenuItem(
            value: 8,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "info".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.infoIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ]
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>().isReplyChat = true;
            Get.find<ChatController>().chatListsDoc = chatMessageList;
            Get.find<ChatController>().update();
            break;
          case 2:
            deleteChatMessageDialog(chatMessageList);
            break;
          case 3:
            Get.find<ChatController>().sendMessageController.text =
                chatMessageList.content?.text.message ?? "";
            Get.find<ChatController>().chatMessageIds = chatMessageList.id;
            Get.find<ChatController>().isChatMessageEdit = true;
            FocusScope.of(context)
                .requestFocus(Get.find<ChatController>().messageFocusNode);
            Get.find<ChatController>().update();
            break;
          case 5:
            Get.find<ChatController>().forwardSelectedMemberList.clear();
            RouteManagement.goToForwardMessageScreen(chatMessageList.id ?? "");
            break;
          case 6:
            Get.find<ChatController>()
                .postChatFavoriteAndRemove(chatMessageList.id, false);
            Get.find<ChatController>().update();
            break;
          case 7:
            Get.find<ChatController>()
                .postChatBookmarkAndRemove(chatMessageList.id, false, false);
            Get.find<ChatController>().update();
            break;
          case 8:
            RouteManagement.goToMessageInfoScreen(chatMessageList);
            break;
          default:
            print("click");
            break;
        }
      },
    );
  }

  static void infFavoriteMessageDialog(
      context, details, ChatListsDoc chatMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (chatMessageList.favorites?.isNotEmpty ?? false)
                    ? "Remove Favorite"
                    : "Add Favorite",
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.staricon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    ColorsValue.blackColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>()
                .postChatFavoriteAndRemove(chatMessageList.id, true);
            Get.find<ChatController>().update();
            break;
          default:
            print("click");
            break;
        }
      },
    );
  }

  static void infoBookMarksMessageDialog(context, details,
      ChatListsDoc chatMessageList, bool isgroup, bool isUserBookmark) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (chatMessageList.bookmarks?.isNotEmpty ?? false)
                    ? "Remove Bookmark"
                    : "Add Bookmark",
                style: Styles.black50014,
              ),
              Dimens.boxWidth5,
              SvgPicture.asset(
                AssetConstants.bookMarkIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            if (isgroup) {
              Get.find<ChatController>()
                  .postChatGroupBookmarkAndRemove(chatMessageList.id, true);
            } else {
              Get.find<ChatController>().postChatBookmarkAndRemove(
                  chatMessageList.id, true, isUserBookmark);
            }
            Get.find<ChatController>().update();
            break;
          default:
            print("click");
            break;
        }
      },
    );
  }

  static void deleteChatMessageDialog(ChatListsDoc chatMessageList) async {
    await Get.dialog(
      Padding(
        padding: Dimens.edgeInsetsTop20,
        child: Material(
          color: ColorsValue.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets20_0_20_0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsValue.white,
                    borderRadius: BorderRadius.circular(Dimens.fifteen),
                  ),
                  child: Padding(
                    padding: Dimens.edgeInsets25_30_25_30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "message_delete".tr,
                          style: Styles.greyColor888850014,
                        ),
                        Dimens.boxHeight30,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // if (Utility.timeToNext(
                                //     chatMessageList.senttimestamp)) ...[
                                if (Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    chatMessageList.from?.id) ...[
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      Get.find<ChatController>()
                                          .postChatDeleteMessage(
                                              chatMessageList, "all");
                                    },
                                    child: Text(
                                      "delete_for_everyone".tr,
                                      style: Styles.main70014,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                ],
                                // ],
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    Get.find<ChatController>()
                                        .postChatDeleteMessage(
                                            chatMessageList, "me");
                                  },
                                  child: Text(
                                    "delete_for_me".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                                Dimens.boxHeight20,
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "cancle".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void emojiDialog(String? id, bool isGroupChat) async {
    await Get.dialog(Padding(
      padding: Dimens.edgeInsets20,
      child: Material(
        color: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: Dimens.threeHundred,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                  Dimens.twenty,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(
                  Dimens.twenty,
                ),
                child: EmojiPicker(
                  onEmojiSelected: (category, emoji) {
                    if (id == null) return;
                    Get.back();
                    if (isGroupChat) {
                      Get.find<ChatController>()
                          .postChatGroupMessageReaction(id, emoji.emoji);
                    }
                    Get.find<ChatController>()
                        .postChatMessageReaction(id, emoji.emoji);
                  },
                  config: Config(
                    height: Dimens.twoHundredFiftySix,
                    checkPlatformCompatibility: true,
                    emojiViewConfig: EmojiViewConfig(
                      columns: 10,
                      verticalSpacing: 0,
                      horizontalSpacing: 0,
                      recentsLimit: 28,
                      noRecents: DefaultNoRecentsWidget,
                      replaceEmojiOnLimitExceed: true,
                      emojiSizeMax: 25 *
                          (foundation.defaultTargetPlatform ==
                                  TargetPlatform.iOS
                              ? 1.20
                              : 1.0),
                      backgroundColor: ColorsValue.transparent,
                    ),
                    skinToneConfig: const SkinToneConfig(),
                    categoryViewConfig: const CategoryViewConfig(
                      indicatorColor: ColorsValue.maincolor1,
                      iconColorSelected: ColorsValue.maincolor1,
                    ),
                    bottomActionBarConfig: const BottomActionBarConfig(
                      backgroundColor: ColorsValue.maincolor1,
                      buttonColor: ColorsValue.maincolor1,
                    ),
                    searchViewConfig: const SearchViewConfig(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

////========================================== Business Chat ==================================================///

  static void infoMessageBusinessDialog(
      context, details, ChatListsDoc chatGroupMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    List<String> emojiList = ["😃", "🤣", "💝", "👍", "➕"];
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 10,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Wrap(
                children: emojiList.asMap().entries.map((e) {
                  return Padding(
                    padding: Dimens.edgeInsets5_0_5_0,
                    child: InkWell(
                      onTap: () {
                        if (e.key == 4) {
                          Get.back();
                          emojiDialog(chatGroupMessageList.id, true);
                        } else {
                          Get.back();
                          Get.find<ChatController>()
                              .postChatGroupMessageReaction(
                                  chatGroupMessageList.id, e.value);
                          Get.find<ChatController>().update();
                        }
                      },
                      child: Text(
                        e.value,
                        style: Styles.black60026,
                      ),
                    ),
                  );
                }).toList(),
              )
            ],
          ),
        ),
        if (chatGroupMessageList.contentType != "multimedia" &&
            chatGroupMessageList.contentType != "multimediawithlinks" &&
            chatGroupMessageList.contentType != "multimediawithtext") ...[
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "reply".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.replayIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (!Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) ...[
          PopupMenuItem(
            value: 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "delet".tr,
                  style: Styles.redColor50014,
                ),
                SvgPicture.asset(
                  AssetConstants.deletIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
                chatGroupMessageList.from?.id &&
            (chatGroupMessageList.contentType == "text" ||
                chatGroupMessageList.contentType == "links")) ...[
          PopupMenuItem(
            value: 3,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "edit".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.editChatIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        if (chatGroupMessageList.contentType == "text" ||
            chatGroupMessageList.contentType == "links") ...[
          PopupMenuItem(
            value: 4,
            onTap: () {
              Utility.copyText(
                  chatGroupMessageList.content?.text.message ?? "");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "copy".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.copyIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "forward".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.forwordIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        if (!Get.find<Repository>().getBoolValue(LocalKeys.isSubUser)) ...[
          if (chatGroupMessageList.contentType != "videocall" &&
              chatGroupMessageList.contentType != "audiocall") ...[
            PopupMenuItem(
              value: 6,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (chatGroupMessageList.favorites?.isNotEmpty ?? false)
                        ? "Remove Favorite"
                        : "Add Favorite",
                    style: Styles.black50014,
                  ),
                  SvgPicture.asset(
                    AssetConstants.staricon,
                    height: Dimens.twenty,
                    fit: BoxFit.cover,
                    colorFilter: const ColorFilter.mode(
                        ColorsValue.blackColor, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 7,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (chatGroupMessageList.bookmarks?.isNotEmpty ?? false)
                        ? "Remove Bookmark"
                        : "Add Bookmark",
                    style: Styles.black50014,
                  ),
                  Dimens.boxWidth5,
                  SvgPicture.asset(
                    AssetConstants.bookMarkIcon,
                    height: Dimens.twenty,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
            ),
          ],
        ],
        PopupMenuItem(
          value: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "info".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.infoIcon,
                height: 20,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>().isReplyChat = true;
            Get.find<ChatController>().chatGroupListsDoc = chatGroupMessageList;
            Get.find<ChatController>().update();
            break;
          case 2:
            deleteChatBusinessMessageDialog(chatGroupMessageList);
            break;
          case 3:
            Get.find<ChatController>().sendMessageController.text =
                chatGroupMessageList.content?.text.message ?? "";
            Get.find<ChatController>().chatGroupMessageIds =
                chatGroupMessageList.id;
            Get.find<ChatController>().isChatGroupMessageEdit = true;
            Get.find<ChatController>().update();
            break;
          case 5:
            Get.find<ChatController>().forwardSelectedMemberList.clear();
            RouteManagement.goToForwardMessageGroupScreen(
                chatGroupMessageList.id ?? "");
            break;
          case 6:
            Get.find<ChatController>()
                .postChatGroupFavoriteAndRemove(chatGroupMessageList.id, false);
            Get.find<ChatController>().update();
            break;
          case 7:
            Get.find<ChatController>()
                .postChatGroupBookmarkAndRemove(chatGroupMessageList.id, false);
            Get.find<ChatController>().update();
            break;
          case 8:
            RouteManagement.goToGroupMessageInfoScreen(chatGroupMessageList);
            break;
          default:
            print(value);
            break;
        }
      },
    );
  }

  static void infoGroupFavoriteMessageDialog(
      context, details, ChatListsDoc chatGroupMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                chatGroupMessageList.favorites!.isNotEmpty
                    ? "Remove Favorite"
                    : "Add Favorite",
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.staricon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    ColorsValue.blackColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>()
                .postChatGroupFavoriteAndRemove(chatGroupMessageList.id, true);
            Get.find<ChatController>().update();
          default:
            print("click");
        }
      },
    );
  }

  static void deleteChatBusinessMessageDialog(
      ChatListsDoc chatGroupMessageList) async {
    await Get.dialog(
      Padding(
        padding: Dimens.edgeInsetsTop20,
        child: Material(
          color: ColorsValue.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets20_0_20_0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsValue.white,
                    borderRadius: BorderRadius.circular(Dimens.fifteen),
                  ),
                  child: Padding(
                    padding: Dimens.edgeInsets25_30_25_30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "message_delete".tr,
                          style: Styles.greyColor888850014,
                        ),
                        Dimens.boxHeight30,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                // if (Utility.timeToNext(
                                //     chatGroupMessageList.timestamp)) ...[
                                if (Get.find<Repository>()
                                        .getStringValue(LocalKeys.userIds) ==
                                    chatGroupMessageList.from?.id) ...[
                                  InkWell(
                                    onTap: () {
                                      Get.back();
                                      Get.find<ChatController>()
                                          .postChatGroupDeleteMessage(
                                              chatGroupMessageList, "all");
                                    },
                                    child: Text(
                                      "delete_for_everyone".tr,
                                      style: Styles.main70014,
                                    ),
                                  ),
                                  Dimens.boxHeight20,
                                  //   ],
                                ],
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    Get.find<ChatController>()
                                        .postChatGroupDeleteMessage(
                                            chatGroupMessageList, "me");
                                  },
                                  child: Text(
                                    "delete_for_me".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                                Dimens.boxHeight20,
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "cancle".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void pinUnpinSingaleChat(context, details, MyFriendDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.isPinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.isPinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "chat_lock".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_chat_lock,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Archive Chat".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              Image.asset(
                AssetConstants.archive,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                color: ColorsValue.blackColor,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View Profile".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.usericon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        if (itemData.userid != Get.find<Repository>().getStringValue(LocalKeys.userIds))
          PopupMenuItem(
            value: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Block User".tr,
                  style: Styles.black50014,
                ),
                Dimens.boxWidth10,
                SvgPicture.asset(
                  AssetConstants.ic_block,
                  height: Dimens.twenty,
                  width: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        PopupMenuItem(
          value: 6,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.ismarkedasunread ?? false
                    ? "Mark as read".tr
                    : "Mark as unread",
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.mark_read,
                height: Dimens.twenty,
                width: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) async {
        if (value == 1) {
          Get.find<ChatController>().postChatPinUnPin(itemData.userid);
        } else if (value == 2) {
          if (Utility.profileData?.recoveryEmail?.isEmpty ?? false) {
            RouteManagement.goToRecoveryEmailScreen("Lock");
          } else {
            if (Utility.profileData?.chatlockpin?.isEmpty ??
                (false || Utility.profileData?.chatlockpin == null)) {
              Get.find<ChatController>().pendingLockItem = itemData;
              RouteManagement.goToCreatChatLockPinScreen();
            } else {
              Get.find<ChatController>().postChatLock(itemData);
            }
          }
        } else if (value == 3) {
          Get.find<ChatController>().postArchiveChat(itemData.friendrequestid);
        } else if (value == 4) {
          RouteManagement.goToChatUserProfileScreen(itemData.userid ?? "");
        } else if (value == 5) {
          await Get.dialog(
            Padding(
              padding: Dimens.edgeInsetsTop20,
              child: Material(
                color: ColorsValue.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: Container(
                        decoration: BoxDecoration(
                          color: ColorsValue.white,
                          borderRadius: BorderRadius.circular(Dimens.fifteen),
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets25_30_25_30,
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: InkWell(
                                    onTap: () {
                                      Get.back();
                                    },
                                    child: SvgPicture.asset(
                                      AssetConstants.cancleicon,
                                    )),
                              ),
                              SvgPicture.asset(
                                AssetConstants.canclepopupicon,
                              ),
                              Dimens.boxHeight18,
                              Text(
                                "block_request".tr,
                                style: Styles.black70020,
                              ),
                              Dimens.boxHeight10,
                              Text(
                                "are_you_sure_block".tr,
                                style: Styles.greyColor888840014,
                              ),
                              Dimens.boxHeight18,
                              CustomBottomButton(
                                firstbtnText: "cancle".tr.toUpperCase(),
                                secondbtnTxt: "block".tr.toUpperCase(),
                                firstStyle: Styles.greyColor888850014,
                                secondStyle: Styles.white50014,
                                bordercolor: ColorsValue.greyColor8888,
                                buttoncolor: ColorsValue.redColor,
                                firstOnPressed: () {
                                  Get.back();
                                },
                                secondOnPressed: () {
                                  Get.back();
                                  Get.find<ChatController>()
                                    ..updateFriendsRequest(
                                        itemData.friendrequestid ?? "",
                                        "blocked");
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        } else if (value == 6) {
          if (itemData.ismarkedasunread ?? false) {
            Get.find<ChatController>()
                .postReadChat(itemData.friendrequestid ?? "");
          } else {
            Get.find<ChatController>()
                .postUnReadChat(itemData.friendrequestid ?? "");
          }
        }
      },
    );
  }

  static void pinUnpinGroupChat(context, details, GroupChatDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.pinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.pinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "chat_lock".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_chat_lock,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Archive Chat".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              Image.asset(
                AssetConstants.archive,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                color: ColorsValue.blackColor,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 4,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "View Profile".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.usericon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.isgroupmarkedunread ?? false
                    ? "Mark as read".tr
                    : "Mark as unread",
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.mark_read,
                height: Dimens.twenty,
                width: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<GroupChatController>()
              .postGroupChatPinUnPin(itemData.id, itemData.pinned ?? false);
        } else if (value == 2) {
          if (Utility.profileData?.chatlockpin?.isEmpty ??
              (false || Utility.profileData?.chatlockpin == null)) {
            RouteManagement.goToRecoveryEmailScreen("Lock");
          } else {
            if (Utility.profileData?.chatlockpin?.isEmpty ??
                (false || Utility.profileData?.chatlockpin == null)) {
              Get.find<ChatController>().pendingGroupLockItem = itemData;
              RouteManagement.goToCreatChatLockPinScreen();
            } else {
              Get.find<ChatController>().postGroupChatLock(itemData);
            }
          }
        } else if (value == 3) {
          Get.find<GroupChatController>().postArchiveGroupChat(itemData.id);
        } else if (value == 4) {
          RouteManagement.goToGroupProfileDetailsScreen(itemData.id ?? "");
        } else if (value == 5) {
          if (itemData.isgroupmarkedunread ?? false) {
            Get.find<GroupChatController>()
                .postReadGroupChat(itemData.id ?? "");
          } else {
            Get.find<GroupChatController>()
                .postUnReadGroupChat(itemData.id ?? "");
          }
        }
      },
    );
  }

  static void pinUnpinBrodcastChat(context, details, BroadcastDoc itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.ispinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.ispinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<BroadCastController>().postPinUnPinBroadcast(itemData.id);
        }
      },
    );
  }

////========================================== Business Chat ==================================================///

  static void infoBrodcastMessageDialog(
      context, details, ChatListsDoc chatMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        if (chatMessageList.contentType != "multimedia" &&
            chatMessageList.contentType != "multimediawithlinks" &&
            chatMessageList.contentType != "multimediawithtext") ...[
          PopupMenuItem(
            value: 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "reply".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.replayIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "delet".tr,
                style: Styles.redColor50014,
              ),
              SvgPicture.asset(
                AssetConstants.deletIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        // if (Get.find<Repository>().getStringValue(LocalKeys.userIds) ==
        //             chatMessageList.from?.id &&
        //         chatMessageList.contentType == "text" ||
        //     chatMessageList.contentType == "links") ...[
        //   PopupMenuItem(
        //     value: 3,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(
        //           "edit".tr,
        //           style: Styles.black50014,
        //         ),
        //         SvgPicture.asset(
        //           AssetConstants.editChatIcon,
        //           height: Dimens.twenty,
        //           fit: BoxFit.cover,
        //         ),
        //       ],
        //     ),
        //   ),
        // ],
        if (chatMessageList.contentType == "text" ||
            chatMessageList.contentType == "links") ...[
          PopupMenuItem(
            value: 4,
            onTap: () {
              Utility.copyText(chatMessageList.content?.text.message ?? "");
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "copy".tr,
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.copyIcon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: 5,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "forward".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.forwordIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        if (chatMessageList.contentType != "videocall" &&
            chatMessageList.contentType != "audiocall") ...[
          PopupMenuItem(
            value: 6,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  (chatMessageList.favorites?.isNotEmpty ?? false)
                      ? "Remove Favorite"
                      : "Add Favorite",
                  style: Styles.black50014,
                ),
                SvgPicture.asset(
                  AssetConstants.staricon,
                  height: Dimens.twenty,
                  fit: BoxFit.cover,
                  colorFilter: const ColorFilter.mode(
                      ColorsValue.blackColor, BlendMode.srcIn),
                ),
              ],
            ),
          ),
        ],
        PopupMenuItem(
          value: 8,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "info".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.infoIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>().isReplyChat = true;
            Get.find<ChatController>().chatBrodcastListsDoc = chatMessageList;
            Get.find<ChatController>().update();
            break;
          case 2:
            deleteBrodcastMessageDialog(chatMessageList);
            break;
          case 5:
            Get.find<ChatController>().forwardSelectedMemberList.clear();
            RouteManagement.goToForwardMessageScreen(chatMessageList.id ?? "");
            break;
          case 6:
            Get.find<ChatController>()
                .postBrodcastFavorite(chatMessageList.id, false);
            Get.find<ChatController>().update();
            break;
          case 8:
            RouteManagement.goToMessageInfoScreen(chatMessageList);
            break;
          default:
            print("click");
            break;
        }
      },
    );
  }

  static void deleteBrodcastMessageDialog(ChatListsDoc chatMessageList) async {
    await Get.dialog(
      Padding(
        padding: Dimens.edgeInsetsTop20,
        child: Material(
          color: ColorsValue.transparent,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: Dimens.edgeInsets20_0_20_0,
                child: Container(
                  decoration: BoxDecoration(
                    color: ColorsValue.white,
                    borderRadius: BorderRadius.circular(Dimens.fifteen),
                  ),
                  child: Padding(
                    padding: Dimens.edgeInsets25_30_25_30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "message_delete".tr,
                          style: Styles.greyColor888850014,
                        ),
                        Dimens.boxHeight30,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                    Get.find<ChatController>()
                                        .postBrodcastDeleteMeg(chatMessageList);
                                  },
                                  child: Text(
                                    "delete_for_me".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                                Dimens.boxHeight20,
                                InkWell(
                                  onTap: () {
                                    Get.back();
                                  },
                                  child: Text(
                                    "cancle".tr,
                                    style: Styles.main70014,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void infoBrodcastFavoriteMessageDialog(
      context, details, ChatListsDoc chatMessageList) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                (chatMessageList.favorites?.isNotEmpty ?? false)
                    ? "Remove Favorite"
                    : "Add Favorite",
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.staricon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                    ColorsValue.blackColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        switch (value) {
          case 1:
            Get.find<ChatController>()
                .postBrodcastFavorite(chatMessageList.id, true);
            Get.find<ChatController>().update();
        }
      },
    );
  }

  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
  /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

  static void pinUnpinSingaleChatLock(
      context, details, FriendsListDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.isPinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.isPinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "hidechat".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_hide,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "remove_chat_lock".tr,
                style: Styles.redColor50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_chat_lock,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.redColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<ChatController>().postChatPinUnPin(itemData.userid);
        } else if (value == 2) {
          if (Utility.profileData?.recoveryEmail?.isEmpty ?? false) {
            RouteManagement.goToRecoveryEmailScreen("Hide");
          } else {
            if (Utility.profileData?.chathidepin?.isEmpty ??
                false || Utility.profileData?.chathidepin == null) {
              RouteManagement.goToCreateHideChatPinScreen();
            } else {
              Get.find<ChatController>().postChatHide(itemData);
            }
          }
        } else if (value == 3) {
          Get.find<ChatController>().postUnLockChat(itemData);
        }
      },
    );
  }

  static void pinUnpinGroupChatLock(
      context, details, GroupFriendData itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.pinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.pinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "hide_group_chat".tr,
                style: Styles.black50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_hide,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.blackColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "group_remove_chat_lock".tr,
                style: Styles.redColor50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_chat_lock,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.redColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<GroupChatController>()
              .postGroupChatPinUnPin(itemData.id, itemData.pinned ?? false);
        } else if (value == 2) {
          if (Utility.profileData?.recoveryEmail?.isEmpty ?? false) {
            RouteManagement.goToRecoveryEmailScreen("Hide");
          } else {
            if (Utility.profileData?.chathidepin?.isEmpty ??
                false || Utility.profileData?.chathidepin == null) {
              RouteManagement.goToCreateHideChatPinScreen();
            } else {
              Get.find<ChatController>().postGroupChatHide(itemData);
            }
          }
        } else if (value == 3) {
          Get.find<ChatController>().postUnLockGroup(itemData);
        }
      },
    );
  }

  static void pinUnpinSingaleChatHide(
      context, details, FriendsListDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.isPinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.isPinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "move_hide_lock".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.lockicon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(ColorsValue.blackColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "remove_hide_chat".tr,
                style: Styles.redColor50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_hide,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.redColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<ChatController>().postChatPinUnPin(itemData.userid);
        } else if (value == 2) {
          Get.find<HideChatController>().postMoveHideToLock(itemData);
        } else if (value == 3) {
          Get.find<HideChatController>().postUnLockChat(itemData);
        }
      },
    );
  }

  static void pinUnpinGroupChatHide(
      context, details, GroupFriendData itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                itemData.pinned ?? false ? "UnPin" : "Pin".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                itemData.pinned ?? false
                    ? AssetConstants.ic_unpin
                    : AssetConstants.pinIcon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 2,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "move_hide_lock_group".tr,
                style: Styles.black50014,
              ),
              SvgPicture.asset(
                AssetConstants.lockicon,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter:
                    ColorFilter.mode(ColorsValue.blackColor, BlendMode.srcIn),
              ),
            ],
          ),
        ),
        PopupMenuItem(
          value: 3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "remove_hide_group_chat".tr,
                style: Styles.redColor50014,
              ),
              Dimens.boxWidth10,
              SvgPicture.asset(
                AssetConstants.ic_hide,
                height: Dimens.twenty,
                fit: BoxFit.cover,
                colorFilter: const ColorFilter.mode(
                  ColorsValue.redColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<GroupChatController>()
              .postGroupChatPinUnPin(itemData.id, itemData.pinned ?? false);
        } else if (value == 2) {
          Get.find<HideChatController>().postMoveHideToLockGroup(itemData);
        } else if (value == 3) {
          Get.find<HideChatController>().postUnLockGroup(itemData);
        }
      },
    );
  }

  static void archiveRemoveSingaleChat(
      context, details, MyFriendDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remove Archive",
                style: Styles.black50014,
              ),
              Image.asset(
                AssetConstants.archive,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<ChatController>()
              .postArchiveChatRemove(itemData.friendrequestid);
        }
      },
    );
  }

  static void ArchiveRemoveGroupChat(
      context, details, GroupChatDatum itemData) {
    Get.find<ChatController>().messageFocusNode.unfocus();
    final offset = details.globalPosition;
    FocusScope.of(context).unfocus();
    showMenu(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(Dimens.fifteen),
        ),
      ),
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy,
        MediaQuery.of(context).size.width - offset.dx,
        MediaQuery.of(context).size.height - offset.dy,
      ),
      items: [
        PopupMenuItem(
          value: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Remove Archive",
                style: Styles.black50014,
              ),
              Image.asset(
                AssetConstants.archive,
                height: Dimens.twenty,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
      elevation: 8.0,
    ).then(
      (value) {
        if (value == 1) {
          Get.find<GroupChatController>()
              .postArchiveGroupChatRemove(itemData.id);
        }
      },
    );
  }
}
