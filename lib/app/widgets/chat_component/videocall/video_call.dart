import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class VideoCall extends StatelessWidget {
  VideoCall({
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
    return Row(
      children: [
        Expanded(
          flex: isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: GestureDetector(
            onTap: () {
              if (Get.isRegistered<CallManagerService>()) {
                final callManager = Get.find<CallManagerService>();
                if (callManager.isCallIdActive(chatListsDocData.callid?.id)) {
                  callManager.returnToCall();
                }
              }
            },
            child: Column(
            crossAxisAlignment:
                isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            mainAxisAlignment:
                isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: Get.width / 2.5,
                decoration: BoxDecoration(
                  color: isSend
                      ? ColorsValue.lightmainColor
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.five),
                    bottomRight: Radius.circular(Dimens.five),
                    topRight:
                        isSend ? Radius.zero : Radius.circular(Dimens.five),
                    topLeft:
                        isSend ? Radius.circular(Dimens.five) : Radius.zero,
                  ),
                ),
                child: Padding(
                  padding: Dimens.edgeInsets10_10_10_0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            height: Dimens.fourty,
                            width: Dimens.fourty,
                            padding: Dimens.edgeInsets10,
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.all(
                                Radius.circular(Dimens.five),
                              ),
                            ),
                            child: SvgPicture.asset(
                              AssetConstants.videoIcon,
                              colorFilter: const ColorFilter.mode(
                                ColorsValue.maincolor1,
                                BlendMode.srcIn,
                              ),
                            ),
                          ),
                          Dimens.boxWidth5,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  callTitle(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.black50014,
                                ),
                                Dimens.boxHeight2,
                                Text(
                                  callTiming(),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Styles.greyColor888840010,
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                      Dimens.boxHeight5,
                      if (!isGroup) ...[
                        Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
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
                                          : chatListsDocData.status ==
                                                  "delivered"
                                              ? AssetConstants.deliveredIcon
                                              : AssetConstants.unseenIcon,
                                    )
                                  : Dimens.box0
                            ],
                          ],
                        )
                      ] else ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
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
                                      chatListsDocData.statuses?.every(
                                                  (element) =>
                                                      element.status ==
                                                      "seen") ??
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
                            ],
                          ],
                        )
                      ],
                      if (chatListsDocData.reactions?.isNotEmpty ?? false) ...[
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
                                chatListsDocData.reactions?[0].reaction ?? "",
                                style: Styles.black40014,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ),
                      ],
                      Dimens.boxHeight5,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
  }

  String callTiming() {
    return Utility.getCallTimingAndStatus(
      callid: chatListsDocData.callid,
      isSend: isSend,
    );
  }

  String callTitle() {
    return Utility.getCallCardTitle(
      callid: chatListsDocData.callid,
    );
  }
}
