import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/domain.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ChangeBusinessHours extends StatelessWidget {
  const ChangeBusinessHours({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) => Scaffold(
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "business_hours".tr,
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
              child: SvgPicture.asset(
                AssetConstants.appbarbackarrowicon,
              ),
            ),
          ),
        ),
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                    height: 1,
                    color: ColorsValue.textfildbackcolor,
                  ),
                  itemCount: controller.businessHoursList.length,
                  itemBuilder: (context, index) {
                    controller.businessHoursList[index].time
                        .asMap()
                        .entries
                        .map(
                          (e) => controller.timeIndex = e.key,
                        );
                    return Padding(
                      padding: controller.businessHoursList[index].open
                          ? Dimens.edgeInsets20_10_20_10
                          : Dimens.edgeInsets20_10_20_10,
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                flex: 8,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      controller.businessHoursList[index].day,
                                      style: Styles.hookup50014,
                                    ),
                                    Dimens.boxHeight14,
                                    Wrap(
                                        children: controller
                                            .businessHoursList[index].time
                                            .asMap()
                                            .entries
                                            .map((e) {
                                      var indexTime = e.key;
                                      return Padding(
                                        padding: Dimens.edgeInsets0_5_0_5,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 3,
                                              child: InkWell(
                                                onTap: controller
                                                        .businessHoursList[
                                                            index]
                                                        .open
                                                    ? () async {
                                                        controller
                                                                .startTimeOfDay =
                                                            await showTimePicker(
                                                          initialEntryMode:
                                                              TimePickerEntryMode
                                                                  .dialOnly,
                                                          context: context,
                                                          initialTime:
                                                              TimeOfDay.now(),
                                                        );
                                                        if (controller
                                                                .startTimeOfDay !=
                                                            null) {
                                                          e.value.starttime = Utility
                                                              .formatTimeOfDayhhMMA(
                                                                  controller
                                                                          .startTimeOfDay ??
                                                                      TimeOfDay
                                                                          .now());
                                                          controller.update();
                                                        }
                                                      }
                                                    : null,
                                                child: Text(
                                                  e.value.starttime,
                                                  style: controller
                                                          .businessHoursList[
                                                              index]
                                                          .open
                                                      ? Styles
                                                          .blackunderline50014
                                                      : Styles
                                                          .greyunderline50014,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: Center(
                                                child: Text(
                                                  "-",
                                                  style: Styles.black50014,
                                                ),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 8,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  InkWell(
                                                    onTap: controller
                                                            .businessHoursList[
                                                                index]
                                                            .open
                                                        ? () async {
                                                            controller
                                                                    .endTimeOfDay =
                                                                await showTimePicker(
                                                              initialEntryMode:
                                                                  TimePickerEntryMode
                                                                      .dialOnly,
                                                              context: context,
                                                              initialTime:
                                                                  TimeOfDay
                                                                      .now(),
                                                            );
                                                            final now =
                                                                DateTime.now();
                                                            final startDateTime =
                                                                DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              controller
                                                                  .startTimeOfDay!
                                                                  .hour,
                                                              controller
                                                                  .startTimeOfDay!
                                                                  .minute,
                                                            );
                                                            final endDateTime =
                                                                DateTime(
                                                              now.year,
                                                              now.month,
                                                              now.day,
                                                              controller
                                                                  .endTimeOfDay!
                                                                  .hour,
                                                              controller
                                                                  .endTimeOfDay!
                                                                  .minute,
                                                            );
                                                            if (endDateTime.isAfter(
                                                                startDateTime)) {
                                                              e.value.endtime =
                                                                  Utility.formatTimeOfDayhhMMA(controller
                                                                          .endTimeOfDay ??
                                                                      TimeOfDay
                                                                          .now());
                                                              controller
                                                                  .update();
                                                            } else {
                                                              Utility.errorMessage(
                                                                  "End time must be after start time");
                                                            }
                                                          }
                                                        : null,
                                                    child: Text(
                                                      e.value.endtime ?? "",
                                                      style: controller
                                                              .businessHoursList[
                                                                  index]
                                                              .open
                                                          ? Styles
                                                              .blackunderline50014
                                                          : Styles
                                                              .greyunderline50014,
                                                    ),
                                                  ),
                                                  Dimens.boxWidth5,
                                                  Visibility(
                                                    visible: indexTime == 1
                                                        ? true
                                                        : false,
                                                    child: InkWell(
                                                      onTap: () {
                                                        controller
                                                            .businessHoursList[
                                                                index]
                                                            .time
                                                            .removeAt(
                                                                indexTime);
                                                        controller.update();
                                                      },
                                                      child: SvgPicture.asset(
                                                        AssetConstants
                                                            .cancleicon,
                                                        height: Dimens.fourteen,
                                                        width: Dimens.fourteen,
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }).toList()),
                                    Visibility(
                                      visible: controller
                                                      .businessHoursList[index]
                                                      .time
                                                      .length <
                                                  2 &&
                                              controller
                                                  .businessHoursList[index].open
                                          ? true
                                          : false,
                                      child: InkWell(
                                        onTap: () {
                                          if (controller
                                              .businessHoursList[index].open) {
                                            controller
                                                .businessHoursList[index].time
                                                .add(
                                              AddBusinessTime(
                                                starttime: "10:00 AM",
                                                endtime: "10:00 AM",
                                              ),
                                            );
                                            controller.update();
                                          }
                                        },
                                        child: Text(
                                          "add_new_hours".tr,
                                          style: Styles.main50014,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: CupertinoSwitch(
                                  value:
                                      controller.businessHoursList[index].open,
                                  onChanged: (value) {
                                    controller.businessHoursList[index].open =
                                        value;
                                    controller.update();
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: Dimens.edgeInsets20_0_20_20,
                child: CustomButton(
                  height: Dimens.fifty,
                  text: "save".tr,
                  onTap: () {
                    Get.back();
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
