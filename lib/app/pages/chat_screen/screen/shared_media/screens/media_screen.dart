import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class MediaScreen extends StatelessWidget {
  const MediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        if (Get.arguments[1] ?? false) {
          await controller.postBrodcastPhoto(1);
        } else if (Get.arguments[3] ?? false) {
          await controller.postGroupPhoto(1);
        } else {
          await controller.postPhotoVideo(1);
        }
        controller.scrollMediaController.addListener(() async {
          if (controller.scrollMediaController.position.pixels ==
              controller.scrollMediaController.position.maxScrollExtent) {
            if (controller.isMediaLoading == false) {
              controller.isMediaLoading = true;
              controller.update();
              if (controller.isMediaLastPage == false) {
                if (Get.arguments[1] ?? false) {
                  await controller.postBrodcastPhoto(controller.pagMediaCount);
                } else if (Get.arguments[3] ?? false) {
                  await controller.postGroupPhoto(controller.pagMediaCount);
                } else {
                  await controller.postPhotoVideo(controller.pagMediaCount);
                }
              }
              controller.isMediaLoading = false;
              controller.update();
            }
          }
        });
      },
      builder: (controller) {
        return Scaffold(
          body: RefreshIndicator(
            onRefresh: () => Future.sync(
              () {
                if (Get.arguments[1] ?? false) {
                  return controller.postBrodcastPhoto(1);
                } else if (Get.arguments[3] ?? false) {
                  return controller.postGroupPhoto(1);
                } else {
                  return controller.postPhotoVideo(1);
                }
              },
            ),
            color: ColorsValue.appColor,
            child: controller.chatMediaList.isEmpty
                ? Center(
                    child: Text("media_empty".tr),
                  )
                : ListView(
                    shrinkWrap: true,
                    controller: controller.scrollMediaController,
                    padding: Dimens.edgeInsets20,
                    children: [
                      if (controller.chatMediaRecentList.isNotEmpty) ...[
                        Text(
                          "Recent",
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight5,
                        GridView(
                          padding: Dimens.edgeInsets0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          children: controller.chatMediaRecentList
                              .asMap()
                              .entries
                              .map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.downloadAndSavePDF(
                                    e.value.url ?? "", 'ChatNest', 0);
                              },
                              child: Container(
                                height: Dimens.seventyFour,
                                width: Dimens.seventyFour,
                                decoration: BoxDecoration(
                                  color: ColorsValue.lightmainColor,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                  child: e.value.isVideo ?? false
                                      ? Stack(
                                          children: [
                                            ThumbNailImageFullpage(
                                              url: (e.value.url ?? ""),
                                            ),
                                            Center(
                                              child: SvgPicture.asset(
                                                AssetConstants.ic_video_play,
                                              ),
                                            ),
                                          ],
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (e.value.url ?? ""),
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
                            );
                          }).toList(),
                        ),
                      ],
                      if (controller.chatMediaWeekList.isNotEmpty) ...[
                        Dimens.boxHeight5,
                        Text(
                          "Last Week",
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight5,
                        GridView(
                          padding: Dimens.edgeInsets0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          children: controller.chatMediaWeekList
                              .asMap()
                              .entries
                              .map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.downloadAndSavePDF(
                                    e.value.url ?? "", 'ChatNest', 0);
                              },
                              child: Container(
                                height: Dimens.seventyFour,
                                width: Dimens.seventyFour,
                                decoration: BoxDecoration(
                                  color: ColorsValue.lightmainColor,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                  child: e.value.isVideo ?? false
                                      ? Stack(
                                          children: [
                                            ThumbNailImageFullpage(
                                              url: (e.value.url ?? ""),
                                            ),
                                            Center(
                                              child: SvgPicture.asset(
                                                AssetConstants.ic_video_play,
                                              ),
                                            ),
                                          ],
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (e.value.url ?? ""),
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
                            );
                          }).toList(),
                        ),
                      ],
                      if (controller.chatMediaMonthList.isNotEmpty) ...[
                        Dimens.boxHeight5,
                        Text(
                          "Last Month",
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight5,
                        GridView(
                          padding: Dimens.edgeInsets0,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          children: controller.chatMediaMonthList
                              .asMap()
                              .entries
                              .map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.downloadAndSavePDF(
                                    e.value.url ?? "", 'ChatNest', 0);
                              },
                              child: Container(
                                height: Dimens.seventyFour,
                                width: Dimens.seventyFour,
                                decoration: BoxDecoration(
                                  color: ColorsValue.lightmainColor,
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(
                                    Dimens.five,
                                  ),
                                  child: e.value.isVideo ?? false
                                      ? Stack(
                                          children: [
                                            ThumbNailImageFullpage(
                                              url: (e.value.url ?? ""),
                                            ),
                                            Center(
                                              child: SvgPicture.asset(
                                                AssetConstants.ic_video_play,
                                              ),
                                            ),
                                          ],
                                        )
                                      : CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (e.value.url ?? ""),
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
                            );
                          }).toList(),
                        ),
                      ],
                      if (controller.chatMediaOldList.isNotEmpty) ...[
                        Dimens.boxHeight5,
                        Text(
                          "Older",
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight5,
                        GridView(
                          padding: Dimens.edgeInsets0,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            crossAxisSpacing: 5,
                            mainAxisSpacing: 5,
                          ),
                          children: controller.chatMediaOldList
                              .asMap()
                              .entries
                              .map((e) {
                            return Container(
                              height: Dimens.seventyFour,
                              width: Dimens.seventyFour,
                              decoration: BoxDecoration(
                                color: ColorsValue.lightmainColor,
                                borderRadius: BorderRadius.circular(
                                  Dimens.five,
                                ),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(
                                  Dimens.five,
                                ),
                                child: e.value.isVideo ?? false
                                    ? Stack(
                                        children: [
                                          ThumbNailImageFullpage(
                                            url: (e.value.url ?? ""),
                                          ),
                                          Center(
                                            child: SvgPicture.asset(
                                              AssetConstants.ic_video_play,
                                            ),
                                          ),
                                        ],
                                      )
                                    : CachedNetworkImage(
                                        imageUrl: ApiWrapper.imageUrl +
                                            (e.value.url ?? ""),
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
                            );
                          }).toList(),
                        ),
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
