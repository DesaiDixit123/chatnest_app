import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class GroupReportScreen extends StatelessWidget {
  const GroupReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SettingController>(
      initState: (state) {
        var controller = Get.find<SettingController>();
        controller.reportGroupChatPagingController =
            PagingController(firstPageKey: 1);
        controller.reportGroupChatPagingController
            .addPageRequestListener((pageKey) async {
          await controller.postGroupChatReportList(pageKey);
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          body: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => controller.reportGroupChatPagingController.refresh(),
            ),
             color: ColorsValue.appColor,
            child: PagedListView<int, GroupReportDoc>(
              padding: Dimens.edgeInsets20,
              pagingController: controller.reportGroupChatPagingController,
              builderDelegate: PagedChildBuilderDelegate<GroupReportDoc>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      "GroupChat Report data not found...",
                      style: Styles.greyColor888850016,
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return InkWell(
                    onTap: () {
                      RouteManagement.goToGetOneReportScreen(
                          item.id ?? "", false);
                    },
                    child: ListTile(
                      contentPadding: Dimens.edgeInsets0,
                      leading: Stack(
                        children: [
                          Container(
                            height: Dimens.fifty,
                            width: Dimens.fifty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.blackColor,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ApiWrapper.imageUrl +
                                    (item.groupid?.profileimage ?? ""),
                                fit: BoxFit.cover,
                                maxHeightDiskCache: 300,
                                maxWidthDiskCache: 300,
                                width: Dimens.fifty,
                                height: Dimens.fifty,
                                placeholder: (context, url) => Center(
                                  child: Image.asset(
                                    AssetConstants.usera,
                                    height: Dimens.fifty,
                                  ),
                                ),
                                errorWidget: (context, url, error) =>
                                    Image.asset(AssetConstants.usera),
                              ),
                            ),
                          ),
                        ],
                      ),
                      title: Text(
                        item.groupid?.name ?? " -- ",
                        style: Styles.black50016,
                      ),
                      subtitle: Text(
                        item.groupid?.description ?? " -- ",
                        style: Styles.greyColor888840012,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
