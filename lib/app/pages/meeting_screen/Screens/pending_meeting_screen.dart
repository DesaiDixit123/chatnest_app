import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class PendingMeetingScreen extends StatelessWidget {
  const PendingMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.pastPagingController = PagingController(firstPageKey: 1);
        controller.pastPagingController.addPageRequestListener((pageKey) async {
          await controller.postMeetingPastList(pageKey);
        });
      },
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.searchPastMeetingController,
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
                        () => controller.pastPagingController.refresh(),
                      );
                    });
                  },
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.pastPagingController.refresh(),
                    ),
                     color: ColorsValue.appColor,
                    child: PagedListView<int, HostMeetingDoc>(
                      pagingController: controller.pastPagingController,
                      builderDelegate:
                          PagedChildBuilderDelegate<HostMeetingDoc>(
                        noItemsFoundIndicatorBuilder: (context) {
                          return Center(
                            child: Image.asset(
                              AssetConstants.hostMeetingEmptyimage,
                            ),
                          );
                        },
                        itemBuilder: (context, item, index) {
                          return ListTile(
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
                              child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(Dimens.hundred),
                                  child: Padding(
                                    padding: Dimens.edgeInsets12,
                                    child: SvgPicture.asset(
                                        AssetConstants.hostMeetingicon),
                                  )),
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  item.title ?? "",
                                  style: Styles.black50016,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      Utility.dateStringConvertDate(
                                          item.meetingstartdate ?? ""),
                                      style: Styles.greyColor888840012,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Dimens.boxWidth5,
                                    Container(
                                      height: Dimens.two,
                                      width: Dimens.two,
                                      color: ColorsValue.greyColor8888,
                                    ),
                                    Dimens.boxWidth5,
                                    Text(
                                      Utility.timeStringConvertTime(
                                          item.meetingstarttime ?? ""),
                                      style: Styles.greyColor888840012,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "${'participate_mamber'.tr}${item.attendees?.length}",
                                  style: Styles.greyColor888840012,
                                ),
                                Dimens.boxWidth5,
                                Text(
                                  Utility.timeStringConvertTime(
                                      item.meetingstarttime ?? ""),
                                  style: Styles.greyColor888840012,
                                ),
                              ],
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
        ),
      ),
    );
  }
}
