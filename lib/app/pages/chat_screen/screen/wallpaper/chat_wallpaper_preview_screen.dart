import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/repositories/repositories.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class ChatWallpaperPreviewScreen extends StatelessWidget {
  const ChatWallpaperPreviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.textfildbackcolor,
          appBar: AppBar(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "wallpaper_preview".tr,
                  style: Styles.black70018,
                ),
              ],
            ),
            leading: Padding(
              padding: Dimens.edgeInsets15,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  AssetConstants.appbarbackarrowicon,
                ),
              ),
            ),
          ),
          bottomNavigationBar: SafeArea(
            child: InkWell(
              onTap: () {
                Get.find<Repository>()
                    .saveValue(LocalKeys.chatWallpaper, controller.imagePath);
                Get.back();
              },
              child: Padding(
                padding: Dimens.edgeInsetsBottom10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: Dimens.hundredSixtyFive,
                      height: Dimens.fourtyFive,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                        color: ColorsValue.appColor,
                      ),
                      child: Center(
                        child: Text(
                          'set_wallpaper'.tr,
                          style: Styles.white50016,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        Dimens.ten,
                      ),
                      color: ColorsValue.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(
                        Dimens.ten,
                      ),
                      child: Stack(
                        children: [
                          if (controller.imgFile != null) ...[
                            Image.file(
                              controller.imgFile!,
                              fit: BoxFit.cover,
                              width: double.maxFinite,
                              height: double.maxFinite,
                              filterQuality: FilterQuality.high,
                            ),
                          ],
                          Padding(
                            padding: Dimens.edgeInsets20,
                            child: Column(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      margin: Dimens.edgeInsetsRight60,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.textfildbackcolor,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft:
                                              Radius.circular(Dimens.five),
                                          bottomRight:
                                              Radius.circular(Dimens.five),
                                          topRight:
                                              Radius.circular(Dimens.five),
                                          topLeft: Radius.zero,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. ",
                                              style: Styles.black40014,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: Dimens.edgeInsets00_05_60_00,
                                      child: Text(
                                        "10:20",
                                        style: Styles.greyColor888840012,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    Dimens.boxHeight10
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      margin: Dimens.edgeInsetsLeft60,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.maincolor1,
                                        borderRadius: BorderRadius.only(
                                          bottomLeft:
                                              Radius.circular(Dimens.five),
                                          bottomRight:
                                              Radius.circular(Dimens.five),
                                          topLeft: Radius.circular(Dimens.five),
                                          topRight: Radius.zero,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets10,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. ",
                                              style: Styles.black40014,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "10:20",
                                          style: Styles.greyColor888840012,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Dimens.boxWidth3,
                                        SvgPicture.asset(
                                          AssetConstants.unseenIcon,
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
