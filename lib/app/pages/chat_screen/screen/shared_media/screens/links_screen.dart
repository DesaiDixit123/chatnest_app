import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LinksScreen extends StatelessWidget {
  const LinksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        if (Get.arguments[1] ?? false) {
          await controller.postBrodcastLink(1);
        } else if (Get.arguments[3] ?? false) {
          await controller.postGroupLink(1);
        } else {
          await controller.postLinks(1);
        }
        controller.scrollLinksController.addListener(() async {
          if (controller.scrollLinksController.position.pixels ==
              controller.scrollLinksController.position.maxScrollExtent) {
            if (controller.isLinksLoading == false) {
              controller.isLinksLoading = true;
              controller.update();
              if (controller.isLinksLastPage == false) {
                if (Get.arguments[1] ?? false) {
                  await controller.postBrodcastLink(controller.pagLinksCount);
                } else if (Get.arguments[3] ?? false) {
                  await controller.postGroupLink(controller.pagLinksCount);
                } else {
                  await controller.postLinks(controller.pagLinksCount);
                }
              }
              controller.isLinksLoading = false;
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
                  return controller.postBrodcastLink(1);
                } else if (Get.arguments[3] ?? false) {
                  return controller.postGroupLink(1);
                } else {
                  return controller.postLinks(1);
                }
              },
            ),
             color: ColorsValue.appColor,
            child: controller.chatLinksList.isEmpty
                ? Center(
                    child: Text("links_empty".tr),
                  )
                : ListView(
                    controller: controller.scrollLinksController,
                    shrinkWrap: true,
                    padding: Dimens.edgeInsets20,
                    children: [
                      if (controller.chatLinksRecentList.isNotEmpty) ...[
                        Text(
                          "Recent",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatLinksRecentList.map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.launchLinkURL(
                                    e.content?.text.message ?? "");
                              },
                              child: Padding(
                                padding: Dimens.edgeInsetsTop10,
                                child: Container(
                                  padding: Dimens.edgeInsets10,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                    border: Border.all(
                                      color: ColorsValue.greyColor8888,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Dimens.sixty,
                                        width: Dimens.sixty,
                                        decoration: BoxDecoration(
                                          color: ColorsValue.lightmainColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.link,
                                          size: Dimens.twentyEight,
                                          color: ColorsValue.maincolor1,
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      Flexible(
                                        child: Text(
                                          e.content?.text.message ?? "",
                                          maxLines: 3,
                                          style: Styles.main50014,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      Dimens.boxHeight5,
                      if (controller.chatLinksWeekList.isNotEmpty) ...[
                        Text(
                          "Last Week",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatLinksWeekList.map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.launchLinkURL(
                                    e.content?.text.message ?? "");
                              },
                              child: Padding(
                                padding: Dimens.edgeInsetsTop10,
                                child: Container(
                                  padding: Dimens.edgeInsets10,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                    border: Border.all(
                                      color: ColorsValue.greyColor8888,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Dimens.sixty,
                                        width: Dimens.sixty,
                                        decoration: BoxDecoration(
                                          color: ColorsValue.lightmainColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.link,
                                          size: Dimens.twentyEight,
                                          color: ColorsValue.maincolor1,
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      Flexible(
                                        child: Text(
                                          e.content?.text.message ?? "",
                                          maxLines: 3,
                                          style: Styles.main50014,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      Dimens.boxHeight5,
                      if (controller.chatLinksMonthList.isNotEmpty) ...[
                        Text(
                          "Last Month",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatLinksMonthList.map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.launchLinkURL(
                                    e.content?.text.message ?? "");
                              },
                              child: Padding(
                                padding: Dimens.edgeInsetsTop10,
                                child: Container(
                                  padding: Dimens.edgeInsets10,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                    border: Border.all(
                                      color: ColorsValue.greyColor8888,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Dimens.sixty,
                                        width: Dimens.sixty,
                                        decoration: BoxDecoration(
                                          color: ColorsValue.lightmainColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.link,
                                          size: Dimens.twentyEight,
                                          color: ColorsValue.maincolor1,
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      Flexible(
                                        child: Text(
                                          e.content?.text.message ?? "",
                                          maxLines: 3,
                                          style: Styles.main50014,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        )
                      ],
                      Dimens.boxHeight5,
                      if (controller.chatLinksOldList.isNotEmpty) ...[
                        Text(
                          "Older",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatLinksOldList.map((e) {
                            return InkWell(
                              onTap: () {
                                Utility.launchLinkURL(
                                    e.content?.text.message ?? "");
                              },
                              child: Padding(
                                padding: Dimens.edgeInsetsTop10,
                                child: Container(
                                  padding: Dimens.edgeInsets10,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                    border: Border.all(
                                      color: ColorsValue.greyColor8888,
                                      width: Dimens.one,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: Dimens.sixty,
                                        width: Dimens.sixty,
                                        decoration: BoxDecoration(
                                          color: ColorsValue.lightmainColor,
                                          borderRadius: BorderRadius.circular(
                                            Dimens.five,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.link,
                                          size: Dimens.twentyEight,
                                          color: ColorsValue.maincolor1,
                                        ),
                                      ),
                                      Dimens.boxWidth10,
                                      Flexible(
                                        child: Text(
                                          e.content?.text.message ?? "",
                                          maxLines: 3,
                                          style: Styles.main50014,
                                        ),
                                      )
                                    ],
                                  ),
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
