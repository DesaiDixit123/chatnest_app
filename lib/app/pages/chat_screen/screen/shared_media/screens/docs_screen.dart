import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class DocsScreen extends StatelessWidget {
  const DocsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        if (Get.arguments[1] ?? false) {
          await controller.postBrodcastDoc(1);
        } else if (Get.arguments[3] ?? false) {
          await controller.postGroupDoc(1);
        } else {
          await controller.postDocs(1);
        }
        controller.scrollDocsController.addListener(() async {
          if (controller.scrollDocsController.position.pixels ==
              controller.scrollDocsController.position.maxScrollExtent) {
            if (controller.isDocsLoading == false) {
              controller.isDocsLoading = true;
              controller.update();
              if (controller.isDocsLastPage == false) {
                if (Get.arguments[1] ?? false) {
                  await controller.postBrodcastDoc(controller.pagDocsCount);
                } else if (Get.arguments[3] ?? false) {
                  await controller.postGroupDoc(controller.pagDocsCount);
                } else {
                  await controller.postDocs(controller.pagDocsCount);
                }
              }
              controller.isDocsLoading = false;
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
                  return controller.postBrodcastDoc(1);
                } else if (Get.arguments[3] ?? false) {
                  return controller.postGroupDoc(1);
                } else {
                  return controller.postDocs(1);
                }
              },
            ),
            color: ColorsValue.appColor,
            child: controller.chatDocsList.isEmpty
                ? Center(
                    child: Text("docs_empty".tr),
                  )
                : ListView(
                    controller: controller.scrollDocsController,
                    shrinkWrap: true,
                    padding: Dimens.edgeInsets20,
                    children: [
                      if (controller.chatDocsRecentList.isNotEmpty) ...[
                        Text(
                          "Recent",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatDocsRecentList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: svgWidgets(
                                  e.content?.media.name.split(".").last,
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
                      if (controller.chatDocsWeekList.isNotEmpty) ...[
                        Text(
                          "Last Week",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatDocsWeekList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: svgWidgets(
                                  e.content?.media.name.split(".").last,
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
                      if (controller.chatDocsMonthList.isNotEmpty) ...[
                        Text(
                          "Last Month",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatDocsMonthList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: svgWidgets(
                                  e.content?.media.name.split(".").last,
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
                      if (controller.chatDocsOldList.isNotEmpty) ...[
                        Text(
                          "Older",
                          style: Styles.black50014,
                        ),
                        Column(
                          children: controller.chatDocsOldList.map((e) {
                            return Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                onTap: () {
                                  Utility.downloadAndSavePDF(
                                      e.content?.media.path ?? "", 'ChatNest', 0);
                                },
                                leading: svgWidgets(
                                  e.content?.media.name.split(".").last,
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

  svgWidgets(extensions) {
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
