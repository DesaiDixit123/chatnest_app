import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

class JoinMeetingScreen extends StatelessWidget {
  const JoinMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.joinPagingController = PagingController(firstPageKey: 1);
        controller.joinPagingController.addPageRequestListener((pageKey) async {
          await controller.postMeetingJoinList(pageKey);
        });
      },
      builder: (controller) => Scaffold(
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.searchJoinMeetingController,
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
                          return controller.joinPagingController.refresh();
                        },
                      );
                    });
                  },
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.joinPagingController.refresh(),
                    ),
                    color: ColorsValue.appColor,
                    child: PagedListView<int, HostMeetingDoc>(
                      pagingController: controller.joinPagingController,
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
                            onTap: () {
                              RouteManagement.goTojoinMeetingDetailScreen(
                                  item.id ?? "");
                            },
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
                            title: Text(
                              item.title ?? "",
                              style: Styles.black50016,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  Utility.dateStringConvertDate(
                                      item.meetingstartdate ?? ""),
                                  style: Styles.greyColor888840012,
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
                                      item.meetingendtime ?? ""),
                                  style: Styles.greyColor888840012,
                                ),
                              ],
                            ),
                            trailing: item.status != "cancel"
                                ? Visibility(
                                    visible:
                                        item.agorameta?.token?.isNotEmpty ??
                                                false
                                            ? true
                                            : false,
                                    child: InkWell(
                                      onTap: () async {
                                        if (await Utility
                                                .cameraPermissionCheack(
                                                    context) &&
                                            await Utility
                                                .microphonePermissionCheack(
                                                    context)) {
                                          controller.postMeetingJoin(item.id);
                                        }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.four,
                                          ),
                                          color: ColorsValue.maincolor1,
                                        ),
                                        child: Padding(
                                          padding: Dimens.edgeInsets4,
                                          child: Text(
                                            'join_meeting'.tr.toUpperCase(),
                                            style: Styles.white50012,
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Cancel Session',
                                    style: Styles.redColor50014,
                                  ),
                            contentPadding: Dimens.edgeInsets0,
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
