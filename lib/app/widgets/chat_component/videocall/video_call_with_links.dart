import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class ReplayVideoCallWithLinks extends StatelessWidget {
  ReplayVideoCallWithLinks({
    super.key,
    required this.chatListsDocData,
    required this.isSend,
    required this.isGroup,
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
    var msgCount =
        chatListsDocData.content?.text.message.toString().length ?? 0;
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Column(
            crossAxisAlignment:
                isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              msgCount > 40
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
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
                        Container(
                          width: Get.width / 1.5,
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.maincolor1.withAlpha(50)
                                : ColorsValue.textfildbackcolor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimens.five),
                              bottomRight: Radius.circular(Dimens.five),
                              topRight: isSend
                                  ? Radius.zero
                                  : Radius.circular(Dimens.five),
                              topLeft: isSend
                                  ? Radius.circular(Dimens.five)
                                  : Radius.zero,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsetsLeft5,
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dimens.thirtyFive,
                                      width: Dimens.three,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.only(
                                          topRight:
                                              Radius.circular(Dimens.five),
                                          bottomRight:
                                              Radius.circular(Dimens.five),
                                        ),
                                      ),
                                    ),
                                    Dimens.boxWidth10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Get.find<Repository>().getStringValue(
                                                      LocalKeys.userIds) ==
                                                  chatListsDocData.from?.id
                                              ? "You"
                                              : chatListsDocData
                                                      .from?.nickname ??
                                                  chatListsDocData
                                                      .from?.fullname ??
                                                  "",
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.main50014,
                                        ),
                                        Row(
                                          children: [
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
                                              callTitle(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 3,
                                              style: Styles.black40014,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              InkWell(
                                onTap: () {
                                  Utility.launchLinkURL(
                                      chatListsDocData.content?.text.message ??
                                          "");
                                },
                                child: Text(
                                  chatListsDocData.content?.text.message ?? "",
                                  style: Styles.main40014,
                                  maxLines: 5,
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
                                            chatListsDocData
                                                    .reactions?[0].reaction ??
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
                                    visible: chatListsDocData
                                            .bookmarks?.isNotEmpty ??
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
                                    visible: chatListsDocData
                                            .favorites?.isNotEmpty ??
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
                        if ((chatListsDocData.isedited ?? false) &&
                            !isSend) ...[
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
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
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
                        Container(
                          padding: Dimens.edgeInsets10_10_10_0,
                          decoration: BoxDecoration(
                            color: isSend
                                ? ColorsValue.maincolor1.withAlpha(50)
                                : ColorsValue.textfildbackcolor,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(Dimens.five),
                              bottomRight: Radius.circular(Dimens.five),
                              topRight: isSend
                                  ? Radius.zero
                                  : Radius.circular(Dimens.five),
                              topLeft: isSend
                                  ? Radius.circular(Dimens.five)
                                  : Radius.zero,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Padding(
                                padding: Dimens.edgeInsetsLeft5,
                                child: Row(
                                  children: [
                                    Container(
                                      height: Dimens.thirtyFive,
                                      width: Dimens.three,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.only(
                                          topRight:
                                              Radius.circular(Dimens.five),
                                          bottomRight:
                                              Radius.circular(Dimens.five),
                                        ),
                                      ),
                                    ),
                                    Dimens.boxWidth10,
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          Get.find<Repository>().getStringValue(
                                                      LocalKeys.userIds) ==
                                                  chatListsDocData.from?.id
                                              ? "You"
                                              : chatListsDocData
                                                      .from?.nickname ??
                                                  chatListsDocData
                                                      .from?.fullname ??
                                                  "",
                                          softWrap: true,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: Styles.main50014,
                                        ),
                                        Row(
                                          children: [
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
                                              callTitle(),
                                              overflow: TextOverflow.ellipsis,
                                              softWrap: true,
                                              maxLines: 3,
                                              style: Styles.black40014,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxHeight5,
                              InkWell(
                                onTap: () {
                                  Utility.launchLinkURL(
                                      chatListsDocData.content?.text.message ??
                                          "");
                                },
                                child: Text(
                                  chatListsDocData.content?.text.message ?? "",
                                  style: Styles.main40014,
                                  maxLines: 5,
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
                                            chatListsDocData
                                                    .reactions?[0].reaction ??
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
                                    visible: chatListsDocData
                                            .bookmarks?.isNotEmpty ??
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
                                    visible: chatListsDocData
                                            .favorites?.isNotEmpty ??
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
                        if ((chatListsDocData.isedited ?? false) &&
                            !isSend) ...[
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
                      ],
                    ),
              if (!isGroup) ...[
                Row(
                  children: [
                    Text(
                      Utility.getTimeStempToTimeHHMMAA(
                          chatListsDocData.senttimestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (isSeenStatus) ...[
                      Dimens.boxWidth5,
                      isSend
                          ? SvgPicture.asset(
                              chatListsDocData.status == "seen"
                                  ? AssetConstants.seenIcon
                                  : chatListsDocData.status == "delivered"
                                      ? AssetConstants.deliveredIcon
                                      : AssetConstants.unseenIcon,
                            )
                          : Dimens.box0
                    ]
                  ],
                )
              ] else ...[
                Row(
                  children: [
                    Text(
                      Utility.getTimeStempToTimeHHMMAA(
                          chatListsDocData.timestamp),
                      style: Styles.greyColor888840012,
                    ),
                    if (isSeenStatus) ...[
                      Dimens.boxWidth5,
                      isSend
                          ? SvgPicture.asset(
                              chatListsDocData.statuses?.every((element) =>
                                          element.status == "seen") ??
                                      false
                                  ? AssetConstants.seenIcon
                                  : chatListsDocData.statuses?.every(
                                              (element) =>
                                                  element.status ==
                                                  "delivered") ??
                                          false
                                      ? AssetConstants.deliveredIcon
                                      : AssetConstants.unseenIcon,
                            )
                          : Dimens.box0
                    ]
                  ],
                )
              ],
            ],
          ),
        ),
      ],
    );
  }

  String callTitle() {
    return Utility.getCallCardTitle(
      callid: chatListsDocData.callid,
    );
  }
}
