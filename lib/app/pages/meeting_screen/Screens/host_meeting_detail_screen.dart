import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class HostMettingDetailScreen extends StatelessWidget {
  const HostMettingDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.meetingId = Get.arguments[0] ?? "";
        controller.subTitle = Get.arguments[1] ?? "";
        controller.postMeetingGetOne();
      },
      builder: (controller) {
        final hostId = controller.hostMeetingDoc?.hostby?.id ?? "";
        final visibleMembers = (controller.hostMeetingDoc?.members ?? [])
            .where((member) => (member.userid?.id ?? "") != hostId)
            .toList();

        return Scaffold(
          backgroundColor: ColorsValue.white,
          appBar: AppBar(
            elevation: 5,
            shadowColor: Colors.black.withOpacity(0.4),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  controller.hostMeetingDoc?.title ?? "",
                  style: Styles.black70018,
                ),
              ],
            ),
            leading: Padding(
              padding: Dimens.edgeInsets15,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
              ),
            ),
          ),
          body: controller.hostMeetingDoc?.id?.isNotEmpty ?? false
              ? SafeArea(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: Dimens.edgeInsets20_20_20_0,
                        child: ListTile(
                          contentPadding: Dimens.edgeInsets0,
                          title: Text(
                            controller.hostMeetingDoc?.hostby?.fullname
                                        ?.isNotEmpty ??
                                    false
                                ? controller.hostMeetingDoc?.hostby?.fullname ??
                                    ""
                                : controller.hostMeetingDoc?.hostby?.nickname ??
                                    "",
                            style: Styles.black50016,
                          ),
                          subtitle: Text(
                            controller.subTitle,
                            style: Styles.greyColor888840012,
                          ),
                          leading: Container(
                            height: Dimens.fifty,
                            width: Dimens.fifty,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              color: ColorsValue.maincolor1,
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              child: CachedNetworkImage(
                                imageUrl: ApiWrapper.imageUrl +
                                    (controller.hostMeetingDoc?.hostby
                                            ?.profileimage ??
                                        ""),
                                fit: BoxFit.cover,
                                placeholder: (context, url) {
                                  return Image.asset(
                                    AssetConstants.usera,
                                    fit: BoxFit.cover,
                                  );
                                },
                                errorWidget: (context, url, error) {
                                  return Image.asset(
                                    AssetConstants.usera,
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                            ),
                          ),
                          trailing: controller.hostMeetingDoc?.status !=
                                  "cancel"
                              ? InkWell(
                                  onTap: () {
                                    controller.titleController.text =
                                        controller.hostMeetingDoc?.title ?? "";
                                    controller.desController.text = controller
                                            .hostMeetingDoc?.description ??
                                        "";
                                    controller.startDateController.text =
                                        controller.hostMeetingDoc
                                                ?.meetingstartdate ??
                                            "";
                                    controller.endDateController.text =
                                        controller.hostMeetingDoc
                                                ?.meetingenddate ??
                                            "";
                                    controller.startTimeController.text =
                                        controller.hostMeetingDoc
                                                ?.meetingstarttime ??
                                            "";
                                    controller.endTimeController.text =
                                        controller.hostMeetingDoc
                                                ?.meetingendtime ??
                                            "";

                                    controller.pickedStart =
                                        DateFormat("dd-MM-yyyy").parse(
                                            controller.hostMeetingDoc
                                                    ?.meetingstartdate ??
                                                "");
                                    controller.pickedEnd =
                                        DateFormat("dd-MM-yyyy").parse(
                                            controller.hostMeetingDoc
                                                    ?.meetingenddate ??
                                                "");

                                    controller.selectValidStartDate =
                                        Utility.dateStringConvertTimeHHMM(
                                            controller.hostMeetingDoc
                                                    ?.meetingstartdate ??
                                                "");
                                    controller.selectValidEndDate =
                                        Utility.dateStringConvertTimeHHMM(
                                            controller.hostMeetingDoc
                                                    ?.meetingenddate ??
                                                "");
                                    controller.selectValidStartTime =
                                        Utility.timeStringConvertTimeAA(
                                            controller.hostMeetingDoc
                                                    ?.meetingstarttime ??
                                                "");
                                    controller.selectValidEndTime =
                                        Utility.timeStringConvertTimeAA(
                                            controller.hostMeetingDoc
                                                    ?.meetingendtime ??
                                                "");
                                    RouteManagement.goToAddMeetingScreen(true);
                                  },
                                  child: Container(
                                    height: Dimens.thirtyTwo,
                                    width: Dimens.thirtyTwo,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        Dimens.three,
                                      ),
                                      color: ColorsValue.maincolor1,
                                    ),
                                    child: Padding(
                                      padding: Dimens.edgeInsets6,
                                      child: SvgPicture.asset(
                                        AssetConstants.user_add,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  padding: Dimens.edgeInsets5,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                    border: Border.all(
                                      width: Dimens.one,
                                      color: ColorsValue.redColor,
                                    ),
                                  ),
                                  child: Text(
                                    'Cancel Session',
                                    style: Styles.redColor50014,
                                  ),
                                ),
                        ),
                      ),
                      Dimens.boxHeight5,
                      Padding(
                        padding: Dimens.edgeInsets20_0_20_0,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  "Session Date :- ",
                                  style: Styles.black40014,
                                ),
                                Text(
                                  "${controller.hostMeetingDoc?.meetingstartdate} - ${controller.hostMeetingDoc?.meetingenddate}",
                                  style: Styles.greyColor888840014,
                                ),
                              ],
                            ),
                            Dimens.boxHeight5,
                            Row(
                              children: [
                                Text(
                                  "Session Time :- ",
                                  style: Styles.black40014,
                                ),
                                Text(
                                  "${controller.hostMeetingDoc?.meetingstarttime} - ${controller.hostMeetingDoc?.meetingendtime}",
                                  style: Styles.greyColor888840014,
                                ),
                              ],
                            ),
                            Dimens.boxHeight5,
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Description :- ",
                                  style: Styles.black40014,
                                ),
                                Flexible(
                                  child: Text(
                                    controller.hostMeetingDoc?.description ??
                                        "",
                                    style: Styles.greyColor888840014,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Dimens.boxHeight15,
                      Divider(
                        height: 1,
                        color: ColorsValue.whiteF1F1,
                      ),
                      Expanded(
                        child: Padding(
                          padding: Dimens.edgeInsets20_20_20_0,
                          child: ListView.builder(
                            itemCount: visibleMembers.length,
                            itemBuilder: (context, index) {
                              var item = visibleMembers[index];
                              return ListTile(
                                contentPadding: Dimens.edgeInsets0,
                                title: Text(
                                  item?.userid?.fullname?.isNotEmpty ?? false
                                      ? item?.userid?.fullname ?? ""
                                      : item?.userid?.nickname ?? "",
                                  style: Styles.black50016,
                                ),
                                subtitle: Text(
                                  item?.userid?.aboutme ?? "",
                                  style: Styles.greyColor888840012,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                leading: Container(
                                  height: Dimens.fifty,
                                  width: Dimens.fifty,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    color: ColorsValue.maincolor1,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiWrapper.imageUrl +
                                          (item?.userid?.profileimage ?? ""),
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) {
                                        return Image.asset(
                                          AssetConstants.usera,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                      errorWidget: (context, url, error) {
                                        return Image.asset(
                                          AssetConstants.usera,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      if (controller.hostMeetingDoc?.status != "cancel") ...[
                        Padding(
                          padding: Dimens.edgeInsets20_0_20_0,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  text: 'host_meeting'.tr.toUpperCase(),
                                  onTap: controller.isBtnVisible ?? false
                                      ? () async {
                                          if (await Utility
                                                  .cameraPermissionCheack(
                                                      context) &&
                                              await Utility
                                                  .microphonePermissionCheack(
                                                      context)) {
                                            controller.postHostMeetingStart(
                                                controller.hostMeetingDoc?.id ??
                                                    "");
                                          }
                                        }
                                      : null,
                                  height: Dimens.fifty,
                                  backgroundColor: controller.isBtnVisible ??
                                          false
                                      ? ColorsValue.maincolor1
                                      : ColorsValue.maincolor1.withOpacity(0.6),
                                  style: Styles.white50014,
                                ),
                              ),
                              Dimens.boxWidth10,
                              Expanded(
                                child: CustomButton(
                                  text: 'CANCEL SESSION',
                                  onTap: () async {
                                    controller.postMeetingCancle(
                                        controller.hostMeetingDoc?.id ?? "");
                                  },
                                  height: Dimens.fifty,
                                  backgroundColor: ColorsValue.redColor,
                                  style: Styles.white50014,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      Dimens.boxHeight20,
                    ],
                  ),
                )
              : const Center(
                  child: const CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
