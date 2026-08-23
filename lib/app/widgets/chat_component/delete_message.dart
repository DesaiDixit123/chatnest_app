import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DeleteMessage extends StatelessWidget {
  DeleteMessage({
    super.key,
    required this.isSend,
    required this.isSeen,
    required this.isDelivered,
    required this.time,
    required this.isEdited,
    this.isLink = false,
  });

  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final bool isEdited;
  final String time;
  final bool isLink;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          !isSend ? Dimens.edgeInsets00_00_20_10 : Dimens.edgeInsets20_00_00_10,
      child: Column(
        crossAxisAlignment:
            isSend ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                    color: isSend
                        ? ColorsValue.maincolor1.withAlpha(50)
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
                    padding: Dimens.edgeInsets10,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SvgPicture.asset(
                          AssetConstants.ic_delete_message,
                          height: Dimens.fifteen,
                        ),
                        Dimens.boxWidth5,
                        Text(
                          "you_delete_message".tr,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.black40014,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                time,
                style: Styles.greyColor888840012,
                overflow: TextOverflow.ellipsis,
              ),
              Dimens.boxWidth5,
              isSend
                  ? SvgPicture.asset(
                      isSeen
                          ? AssetConstants.seenIcon
                          : isDelivered
                              ? AssetConstants.deliveredIcon
                              : AssetConstants.unseenIcon,
                    )
                  : Dimens.box0
            ],
          )
        ],
      ),
    );
  }
}
