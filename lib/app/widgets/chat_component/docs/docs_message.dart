import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// ignore: must_be_immutable
class DocsMessage extends StatelessWidget {
  DocsMessage({
    super.key,
    required this.isSeen,
    required this.isDelivered,
    required this.fileName,
    required this.isSend,
    required this.time,
    required this.fileUrl,
    required this.extensions,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    this.isBrodcast = false,
    required this.onEmojiRemove,
    required this.onTap,
    this.isSeenStatus = true,
  });

  final bool isSeen;
  final bool isSend;
  final bool isDelivered;
  final String fileName;
  final String time;
  final String fileUrl;
  final String extensions;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final bool isBrodcast;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;
  Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: !isSend ? 0 : 2,
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
              Container(
                width: Get.width / 1.4,
                padding: Dimens.edgeInsets10_10_10_0,
                decoration: BoxDecoration(
                  color: isSend
                      ? ColorsValue.lightmainColor
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(Dimens.five),
                    bottomRight: Radius.circular(Dimens.five),
                    topRight:
                        !isSend ? Radius.circular(Dimens.five) : Radius.zero,
                    topLeft:
                        !isSend ? Radius.zero : Radius.circular(Dimens.five),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: Dimens.edgeInsetsBottom10,
                      child: Container(
                        width: Get.width / 1.5,
                        padding: Dimens.edgeInsets10,
                        decoration: BoxDecoration(
                          color: ColorsValue.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(Dimens.five),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            svgWidgets(),
                            Dimens.boxWidth15,
                            Flexible(
                              child: Text(
                                fileName,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.black50014,
                              ),
                            ),
                            Dimens.boxWidth10,
                            InkWell(
                              onTap: onTap,
                              child: Container(
                                decoration: BoxDecoration(
                                    color: ColorsValue.textfildbackcolor,
                                    borderRadius: BorderRadius.circular(50)),
                                child: Padding(
                                  padding: Dimens.edgeInsets10,
                                  child: SvgPicture.asset(
                                    AssetConstants.downloadIcon,
                                    height: 20,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (isSend && isBrodcast) ...[
                          SvgPicture.asset(
                            AssetConstants.ic_outline_brodcast,
                          )
                        ],
                        Dimens.boxWidth5,
                        Text(
                          time,
                          style: Styles.greyColor888840012,
                        ),
                        if (isSeenStatus) ...[
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
                        ]
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (emoji.isNotEmpty) ...[
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
                                  emoji[0].reaction ?? "",
                                  style: Styles.black40014,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Dimens.boxWidth3,
                        Visibility(
                          visible: isBookmark,
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
                          visible: isFavorites,
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
                    Dimens.boxHeight5,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  svgWidgets() {
    switch (extensions) {
      case 'zip':
        return SvgPicture.asset(
          AssetConstants.ic_zip,
          height: Dimens.thirtyFive,
        );
      case 'rar':
        return SvgPicture.asset(
          AssetConstants.ic_rar,
          height: Dimens.thirtyFive,
        );

      case 'pdf':
        return SvgPicture.asset(
          AssetConstants.ic_pdf_icon,
          height: Dimens.thirtyFive,
        );

      case 'csv':
        return SvgPicture.asset(
          AssetConstants.ic_csv,
          height: Dimens.thirtyFive,
        );

      case 'doc':
        return SvgPicture.asset(
          AssetConstants.ic_doc,
          height: Dimens.thirtyFive,
        );

      case 'xls':
        return SvgPicture.asset(
          AssetConstants.ic_xsl,
          height: Dimens.thirtyFive,
        );

      case 'ppt':
        return SvgPicture.asset(
          AssetConstants.ic_ppt,
          height: Dimens.thirtyFive,
        );

      case 'tar':
        return SvgPicture.asset(
          AssetConstants.ic_tar,
          height: Dimens.thirtyFive,
        );

      case 'tar.gz':
        return SvgPicture.asset(
          AssetConstants.ic_tar_gz,
          height: Dimens.thirtyFive,
        );

      case 'odp':
        return SvgPicture.asset(
          AssetConstants.ic_odp,
          height: Dimens.thirtyFive,
        );

      case 'odt':
        return SvgPicture.asset(
          AssetConstants.ic_odt,
          height: Dimens.thirtyFive,
        );

      case 'docx':
        return SvgPicture.asset(
          AssetConstants.ic_docx,
          height: Dimens.thirtyFive,
        );

      case 'pptx':
        return SvgPicture.asset(
          AssetConstants.ic_pptx,
          height: Dimens.thirtyFive,
        );

      case 'xlsx':
        return SvgPicture.asset(
          AssetConstants.ic_xslx,
          height: Dimens.thirtyFive,
        );

      case '7z':
        return SvgPicture.asset(
          AssetConstants.ic_7x,
          height: Dimens.thirtyFive,
        );
      case 'txt':
        return SvgPicture.asset(
          AssetConstants.ic_txt,
          height: Dimens.thirtyFive,
        );

      case 'ods':
        return SvgPicture.asset(
          AssetConstants.ic_ods,
          height: Dimens.thirtyFive,
        );
    }
  }
}
