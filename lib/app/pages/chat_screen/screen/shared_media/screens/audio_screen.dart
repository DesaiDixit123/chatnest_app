import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class AudioMediaScreen extends StatelessWidget {
  const AudioMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        if (Get.arguments[1] ?? false) {
          await controller.postBrodcastAudio(1);
        } else if (Get.arguments[3] ?? false) {
          await controller.postGroupAudio(1);
        } else {
          await controller.postAudios(1);
        }
        controller.scrollAudioMediaController.addListener(() async {
          if (controller.scrollAudioMediaController.position.pixels ==
              controller.scrollAudioMediaController.position.maxScrollExtent) {
            if (controller.isAudioMediaLoading == false) {
              controller.isAudioMediaLoading = true;
              controller.update();
              if (controller.isAudioMediaLastPage == false) {
                if (Get.arguments[1] ?? false) {
                  await controller
                      .postBrodcastAudio(controller.pagAudioMediaCount);
                } else if (Get.arguments[3] ?? false) {
                  await controller.postGroupAudio(controller.pagMediaCount);
                } else {
                  await controller.postAudios(controller.pagAudioMediaCount);
                }
              }
              controller.isAudioMediaLoading = false;
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
                  return controller.postBrodcastAudio(1);
                } else if (Get.arguments[3] ?? false) {
                  return controller.postGroupAudio(1);
                } else {
                  return controller.postAudios(1);
                }
              },
            ),
            color: ColorsValue.appColor,
            child: controller.chatAudioMediaList.isEmpty
                ? Center(
                    child: Text("audio_empty".tr),
                  )
                : ListView(
                    controller: controller.scrollAudioMediaController,
                    shrinkWrap: true,
                    padding: Dimens.edgeInsets20,
                    children: [
                      if (controller.chatAudioMediaRecentList.isNotEmpty) ...[
                        Text(
                          "Recent",
                          style: Styles.black50014,
                        ),
                        Column(
                          children:
                              controller.chatAudioMediaRecentList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: SvgPicture.asset(
                                  AssetConstants.ic_mp3,
                                ),
                                title: Text(
                                  e.content?.media.name ?? "",
                                  style: Styles.black50014,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${e.content?.media.filesizeinmb.toString()} mb .",
                                      style: Styles.greyColor888840012,
                                    ),
                                    Dimens.boxWidth3,
                                    Text(
                                      "${e.content?.media.fileext.toString()}",
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  Utility.parseTimeStamptoDDMMYY(
                                      e.senttimestamp ?? 0),
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      if (controller.chatAudioMediaWeekList.isNotEmpty) ...[
                        Text(
                          "Last Week",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatAudioMediaWeekList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: SvgPicture.asset(
                                  AssetConstants.ic_mp3,
                                ),
                                title: Text(
                                  e.content?.media.name ?? "",
                                  style: Styles.black50014,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${e.content?.media.filesizeinmb.toString()} mb .",
                                      style: Styles.greyColor888840012,
                                    ),
                                    Dimens.boxWidth3,
                                    Text(
                                      "${e.content?.media.fileext.toString()}",
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  Utility.parseTimeStamptoDDMMYY(
                                      e.senttimestamp ?? 0),
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      if (controller.chatAudioMediaMonthList.isNotEmpty) ...[
                        Text(
                          "Last Month",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatAudioMediaMonthList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: SvgPicture.asset(
                                  AssetConstants.ic_mp3,
                                ),
                                title: Text(
                                  e.content?.media.name ?? "",
                                  style: Styles.black50014,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${e.content?.media.filesizeinmb.toString()} mb .",
                                      style: Styles.greyColor888840012,
                                    ),
                                    Dimens.boxWidth3,
                                    Text(
                                      "${e.content?.media.fileext.toString()}",
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  Utility.parseTimeStamptoDDMMYY(
                                      e.senttimestamp ?? 0),
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      if (controller.chatAudioMediaOldList.isNotEmpty) ...[
                        Text(
                          "Older",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatAudioMediaOldList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: SvgPicture.asset(
                                  AssetConstants.ic_mp3,
                                ),
                                title: Text(
                                  e.content?.media.name ?? "",
                                  style: Styles.black50014,
                                ),
                                subtitle: Row(
                                  children: [
                                    Text(
                                      "${e.content?.media.filesizeinmb.toString()} mb .",
                                      style: Styles.greyColor888840012,
                                    ),
                                    Dimens.boxWidth3,
                                    Text(
                                      "${e.content?.media.fileext.toString()}",
                                      style: Styles.greyColor888840012,
                                    ),
                                  ],
                                ),
                                trailing: Text(
                                  Utility.parseTimeStamptoDDMMYY(
                                      e.senttimestamp ?? 0),
                                  style: Styles.greyColor888840012,
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ],
                  ),
          ),
        );
      },
    );
  }
}
