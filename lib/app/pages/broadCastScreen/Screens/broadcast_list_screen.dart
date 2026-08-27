import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/gradient_app_bar.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class BroadCastListScreen extends StatelessWidget {
  const BroadCastListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(
      initState: (state) {
        var controller = Get.find<ChatController>();
        controller.broadcastPagingController =
            PagingController(firstPageKey: 1);
        controller.broadcastPagingController
            .addPageRequestListener((pagekey) async {
          await controller.postListBroadcast(pagekey);
        });
      },
      builder: (controller) {
        return Scaffold(
          backgroundColor: ColorsValue.whiteColor,
          appBar: GradientAppBar(
         //   shadowColor: ColorsValue.greyAAAAAA,
          //  backgroundColor: ColorsValue.white,
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
                      Colors.black, BlendMode.srcIn),
                ),
              ),
            ),
            title: Text(
              'broadcast'.tr,
              style: Styles.black70016,
            ),
          ),
          floatingActionButton: FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                Dimens.sixty,
              ),
            ),
            backgroundColor: ColorsValue.maincolor1,
            onPressed: () {
              RouteManagement.goToAddBroadcastScreen(false);
            },
            child: const Icon(
              Icons.add,
              color: ColorsValue.white,
            ),
          ),
          body: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.searchController,
                  hintText: 'search'.tr,
                  fillColor: ColorsValue.textfildbackcolor,
                  suffixIcon: Icon(
                    Icons.search,
                    size: Dimens.twentyFour,
                    color: ColorsValue.hookupHeaderGreyColor,
                  ),
                  onChanged: (value) {
                    _debouncer.run(() {
                      Future.sync(
                        () {
                          return controller.broadcastPagingController.refresh();
                        },
                      );
                    });
                  },
                ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.broadcastPagingController.refresh(),
                    ),
                     color: ColorsValue.appColor,
                    child: PagedListView<int, BroadcastDoc>(
                      pagingController: controller.broadcastPagingController,
                      builderDelegate: PagedChildBuilderDelegate<BroadcastDoc>(
                        noItemsFoundIndicatorBuilder: (_) {
                          return Center(
                            child: SvgPicture.asset(
                              AssetConstants.ic_brodcast_empty,
                            ),
                          );
                        },
                        itemBuilder: (context, item, index) {
                          return GestureDetector(
                            onLongPressStart: (details) {
                              if (Get.find<ChatController>().broadcastDoc ==
                                  null) {
                                ChatScreenUtility.pinUnpinBrodcastChat(
                                    context, details, item);
                              } else {
                                Get.find<ChatController>().broadcastDoc = null;
                              }
                              Get.forceAppUpdate();
                            },
                            onTap: () {
                              RouteManagement.goToBroadCastChatViewScreen(
                                  item.id ?? "");
                            },
                            child: Padding(
                              padding: Dimens.edgeInsetsTop10,
                              child: ListTile(
                                contentPadding: Dimens.edgeInsets0,
                                leading: Container(
                                  height: Dimens.fifty,
                                  width: Dimens.fifty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.maincoloropacity1,
                                  ),
                                  child: Padding(
                                    padding: Dimens.edgeInsets10,
                                    child: SvgPicture.asset(
                                        AssetConstants.promotionIcon),
                                  ),
                                ),
                                title: Text(
                                  item.broadcasttitle ?? "",
                                  style: Styles.black50016,
                                ),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      item.lastchatmessage?.timestamp == 0 ||
                                              item.lastchatmessage?.timestamp ==
                                                  null
                                          ? ""
                                          : Utility.getTimeStempToDate(
                                              item.lastchatmessage?.timestamp),
                                      style: Styles.greyColor888850012,
                                    ),
                                    Dimens.boxHeight5,
                                    Visibility(
                                      visible: item.ispinned ?? false,
                                      child: SvgPicture.asset(
                                        AssetConstants.pinIcon,
                                        height: Dimens.twenty,
                                        width: Dimens.twenty,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
