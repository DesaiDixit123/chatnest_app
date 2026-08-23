import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class NotificationListScreen extends StatelessWidget {
  const NotificationListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.notificationPagingController =
            PagingController(firstPageKey: 1);
        controller.notificationPagingController
            .addPageRequestListener((pageKey) async {
          await controller.postNotificationList(pageKey);
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            shadowColor: ColorsValue.greyAAAAAA,
            backgroundColor: ColorsValue.white,
            elevation: Dimens.two,
            centerTitle: false,
            leading: InkWell(
              onTap: () {
                Get.back();
              },
              child: Padding(
                padding: Dimens.edgeInsets20_15_10_15,
                child: SvgPicture.asset(
                  AssetConstants.appbarbackarrowicon,
                  colorFilter: const ColorFilter.mode(
                    ColorsValue.maincolor1,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            title: Text(
              'notification'.tr,
              style: Styles.black70018,
            ),
           
          ),
          body: RefreshIndicator(
            onRefresh: () => Future.sync(
              () => controller.notificationPagingController.refresh(),
            ),
            color: ColorsValue.appColor,
            child: PagedListView<int, NotificationDoc>(
              pagingController: controller.notificationPagingController,
              builderDelegate: PagedChildBuilderDelegate<NotificationDoc>(
                noItemsFoundIndicatorBuilder: (context) {
                  return Center(
                    child: Text(
                      "Pop up data not found...",
                      style: Styles.greyColor888850016,
                    ),
                  );
                },
                itemBuilder: (context, item, index) {
                  return Dismissible(
                    key: Key(item.id ?? index.toString()),
                    direction: DismissDirection.horizontal,
                    confirmDismiss: (direction) async {
                      return controller.postDeleteNotification(
                        notificationId: item.id,
                        index: index,
                      );
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    secondaryBackground: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: Dimens.edgeInsets20_05_20_05,
                      leading: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            Dimens.hundred,
                          ),
                          color: ColorsValue.maincolor1,
                        ),
                        child: Padding(
                          padding: Dimens.edgeInsets12,
                          child: SvgPicture.asset(
                            AssetConstants.ic_notification,
                            height: Dimens.twentyFour,
                            width: Dimens.twentyFour,
                          ),
                        ),
                      ),
                      title: Text(
                        item.title ?? "",
                        style: Styles.black50016,
                      ),
                      subtitle: Text(
                        item.body ?? "",
                        style: Styles.greyColor888840012,
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
