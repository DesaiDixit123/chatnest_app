import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class LinksWithPhotoWithLinks extends StatelessWidget {
  LinksWithPhotoWithLinks({
    super.key,
    required this.chatListsDocData,
    required this.isGroup,
    required this.isSend,
    required this.onEmojiRemove,
    this.isSeenStatus = true,
  });

  bool isSend;
  bool isGroup;
  bool isSeenStatus;
  ChatListsDoc chatListsDocData;
  Function()? onEmojiRemove;

  @override
  Widget build(BuildContext context) {
    var msgCount = chatListsDocData.context?.content?.text.message.length;
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Row(
            children: [
              if ((chatListsDocData.isedited ?? false) && isSend) ...[
                Padding(
                  padding: Dimens.edgeInsetsLeft5,
                  child: Icon(
                    Icons.edit,
                    size: Dimens.twenty,
                    color: ColorsValue.grey9BA6A8,
                  ),
                ),
                Dimens.boxWidth5,
              ],
              Column(
                crossAxisAlignment:
                    isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                mainAxisAlignment:
                    isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: Dimens.threeHundredSeventeen,
                    padding: Dimens.edgeInsets10_10_10_0,
                    decoration: BoxDecoration(
                      color: isSend
                          ? ColorsValue.lightmainColor
                          : ColorsValue.textfildbackcolor,
                      borderRadius: BorderRadius.circular(
                        Dimens.five,
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          height: msgCount! > 20
                              ? Dimens.seventyFive
                              : Dimens.sixty,
                          padding: Dimens.edgeInsets2,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              Dimens.five,
                            ),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: Dimens.four,
                                decoration: BoxDecoration(
                                  color: ColorsValue.maincolor1,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      Dimens.five,
                                    ),
                                    bottomLeft: Radius.circular(
                                      Dimens.five,
                                    ),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Padding(
                                  padding: Dimens.edgeInsets5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            Get.find<Repository>()
                                                        .getStringValue(
                                                            LocalKeys
                                                                .userIds) ==
                                                    chatListsDocData.from?.id
                                                ? "You"
                                                : chatListsDocData
                                                        .from?.nickname ??
                                                    chatListsDocData
                                                        .from?.fullname ??
                                                    "",
                                            style: Styles.main70014,
                                          ),
                                        ],
                                      ),
                                      Dimens.boxHeight5,
                                      Text(
                                        chatListsDocData.context?.content?.text
                                                .message ??
                                            "",
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: Styles.greyColor888840012,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: msgCount > 20
                                        ? Dimens.seventyFive
                                        : Dimens.sixty,
                                    width: msgCount > 20
                                        ? Dimens.seventyFive
                                        : Dimens.sixty,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                          Dimens.five,
                                        ),
                                        bottomRight: Radius.circular(
                                          Dimens.five,
                                        ),
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(
                                          Dimens.five,
                                        ),
                                        bottomRight: Radius.circular(
                                          Dimens.five,
                                        ),
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl: ApiWrapper.imageUrl +
                                            (chatListsDocData.context?.content
                                                    ?.media.path ??
                                                ""),
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) {
                                          return Image.asset(
                                            AssetConstants.placeholder,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                        errorWidget: (context, url, error) {
                                          return Image.asset(
                                            AssetConstants.placeholder,
                                            fit: BoxFit.cover,
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Dimens.boxHeight5,
                        InkWell(
                          onTap: () {
                            Utility.launchLinkURL(
                                chatListsDocData.content?.text.message ?? "");
                          },
                          child: Text(
                            chatListsDocData.content?.text.message ?? "",
                            style: Styles.main40014,
                            maxLines: 10,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Dimens.boxHeight5,
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (chatListsDocData.reactions?.isNotEmpty ??
                                false) ...[
                              InkWell(
                                onTap: onEmojiRemove,
                                child: Container(
                                  height: Dimens.twentyFour,
                                  width: Dimens.twentyFour,
                                  decoration: BoxDecoration(
                                    color: ColorsValue.white,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    border: Border.all(
                                      width: Dimens.one,
                                      color: ColorsValue.maincolor1,
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      chatListsDocData.reactions?[0].reaction ??
                                          "",
                                      style: Styles.black40014,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            Dimens.boxWidth3,
                            Visibility(
                              visible: chatListsDocData.bookmarks?.isNotEmpty ??
                                  false,
                              child: Container(
                                height: Dimens.twentyFour,
                                width: Dimens.twentyFour,
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  border: Border.all(
                                    width: Dimens.one,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.bookmark,
                                    size: Dimens.fifteen,
                                    color: ColorsValue.blackColor,
                                  ),
                                ),
                              ),
                            ),
                            Dimens.boxWidth3,
                            Visibility(
                              visible: chatListsDocData.favorites?.isNotEmpty ??
                                  false,
                              child: Container(
                                height: Dimens.twentyFour,
                                width: Dimens.twentyFour,
                                decoration: BoxDecoration(
                                  color: ColorsValue.white,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.hundred,
                                  ),
                                  border: Border.all(
                                    width: Dimens.one,
                                    color: ColorsValue.maincolor1,
                                  ),
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.star,
                                    size: Dimens.fifteen,
                                    color: ColorsValue.blackColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  
                ],
              ),
              if ((chatListsDocData.isedited ?? false) && !isSend) ...[
                Padding(
                  padding: Dimens.edgeInsetsLeft5,
                  child: Icon(
                    Icons.edit,
                    size: Dimens.twenty,
                    color: ColorsValue.grey9BA6A8,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
