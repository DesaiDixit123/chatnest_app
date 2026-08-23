import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'instant_meeting_dialog.dart';

class HostMeetingScreen extends StatelessWidget {
  const HostMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.hostPagingController = PagingController(firstPageKey: 1);
        controller.hostPagingController.addPageRequestListener((pageKey) async {
          await controller.postMeetingHostingList(pageKey);
        });
      },
      builder: (controller) => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Show bottom sheet with meeting options
            Get.bottomSheet(
              Container(
                padding: Dimens.edgeInsets20,
                decoration: BoxDecoration(
                  color: ColorsValue.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimens.twenty),
                    topRight: Radius.circular(Dimens.twenty),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'meeting_options'.tr,
                      style: Styles.black70018,
                    ),
                    Dimens.boxHeight20,

                    // Instant Meeting Option
                    ListTile(
                      onTap: () {
                        Get.back(); // Close bottom sheet
                        controller.titleController.clear();
                        controller.desController.clear();
                        controller.selectedMemberList.clear();
                        controller.update();

                        // Show instant meeting dialog
                        Get.bottomSheet(
                          const InstantMeetingDialog(),
                          isScrollControlled: true,
                          isDismissible: true,
                          enableDrag: true,
                        );
                      },
                      leading: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.ten),
                          color: ColorsValue.maincolor1.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.video_call,
                          color: ColorsValue.maincolor1,
                          size: Dimens.twentyFour,
                        ),
                      ),
                      title: Text(
                        'start_instant_meeting'.tr,
                        style: Styles.black50016,
                      ),
                      subtitle: Text(
                        'instant_meeting_description'.tr,
                        style: Styles.greyColor888840012,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: Dimens.sixteen,
                        color: ColorsValue.greyColor8888,
                      ),
                    ),
                    Dimens.boxHeight10,

                    // Schedule Meeting Option
                    ListTile(
                      onTap: () {
                        Get.back(); // Close bottom sheet
                        controller.selectedStartDate = DateTime.now();
                        controller.selectedEndDate = DateTime.now();
                        controller.meetingId = "";
                        controller.titleController.clear();
                        controller.desController.clear();
                        controller.startDateController.clear();
                        controller.endDateController.clear();
                        controller.startTimeController.clear();
                        controller.endTimeController.clear();
                        controller.update();
                        RouteManagement.goToAddMeetingScreen(false);
                      },
                      leading: Container(
                        height: Dimens.fifty,
                        width: Dimens.fifty,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimens.ten),
                          color: ColorsValue.maincolor1.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.calendar_today,
                          color: ColorsValue.maincolor1,
                          size: Dimens.twentyFour,
                        ),
                      ),
                      title: Text(
                        'schedule_meeting'.tr,
                        style: Styles.black50016,
                      ),
                      subtitle: Text(
                        'schedule_meeting_description'.tr,
                        style: Styles.greyColor888840012,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: Dimens.sixteen,
                        color: ColorsValue.greyColor8888,
                      ),
                    ),
                    Dimens.boxHeight20,
                  ],
                ),
              ),
              isDismissible: true,
              enableDrag: true,
            );
          },
          backgroundColor: ColorsValue.maincolor1,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              Dimens.fifty,
            ),
            borderSide: BorderSide.none,
          ),
          child: const Icon(
            Icons.add,
            color: ColorsValue.white,
          ),
        ),
        body: SafeArea(
          child: Padding(
            padding: Dimens.edgeInsets20_20_20_0,
            child: Column(
              children: [
                CustomTextFormField(
                  controller: controller.searchHostMeetingController,
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
                          return controller.hostPagingController.refresh();
                        },
                      );
                    });
                  },
                ),
                Dimens.boxHeight20,
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () => Future.sync(
                      () => controller.hostPagingController.refresh(),
                    ),
                    color: ColorsValue.appColor,
                    child: PagedListView<int, HostMeetingDoc>(
                      pagingController: controller.hostPagingController,
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
                            onTap:
                                //  item.status != "cancel"
                                //     ?
                                () {
                              RouteManagement.goToHostMeetingDetailScreen(
                                  item.id ?? "", 'Host Session');
                            },
                            // : null,
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
                                ),
                              ),
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
                                      item.meetingstarttime ?? ""),
                                  style: Styles.greyColor888840012,
                                ),
                              ],
                            ),
                            trailing: item.status != "cancel"
                                ? InkWell(
                                    onTap: controller.isBtnVisible ?? false
                                        ? () async {
                                            if (await Utility
                                                    .cameraPermissionCheack(
                                                        context) &&
                                                await Utility
                                                    .microphonePermissionCheack(
                                                        context)) {
                                              controller.postHostMeetingStart(
                                                  item.id ?? "");
                                            }
                                          }
                                        : null,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.four,
                                        ),
                                        color: controller.isBtnVisible ?? false
                                            ? ColorsValue.maincolor1
                                            : ColorsValue.maincolor1
                                                .withOpacity(0.6),
                                      ),
                                      child: Padding(
                                        padding: Dimens.edgeInsets4,
                                        child: Text(
                                          'host_meeting'.tr.toUpperCase(),
                                          style: Styles.white50012,
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
