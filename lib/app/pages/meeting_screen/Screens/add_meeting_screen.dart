// ignore_for_file: use_build_context_synchronously

import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/theme/styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddMeetingScreen extends StatelessWidget {
  const AddMeetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MeetingController>(
      initState: (state) {
        var controller = Get.find<MeetingController>();
        controller.isEdit = Get.arguments ?? false;
      },
      builder: (controller) {
        return Scaffold(
            backgroundColor: ColorsValue.white,
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (controller.addMeetingKey.currentState!.validate()) {
                  RouteManagement.goToAddMeetingMemberScreen(controller.isEdit);
                }
              },
              backgroundColor: ColorsValue.maincolor1,
              shape: OutlineInputBorder(
                borderRadius: BorderRadius.circular(
                  Dimens.fifty,
                ),
                borderSide: BorderSide.none,
              ),
              child: SvgPicture.asset(
                AssetConstants.ic_right_side_arrow,
              ),
            ),
            appBar: AppBar(
              centerTitle: false,
              elevation: 5,
              shadowColor: Colors.black.withOpacity(0.4),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'new_meeting'.tr,
                    style: Styles.black70016,
                  ),
                  Dimens.boxHeight5,
                  Text(
                    "add_title".tr,
                    style: Styles.greyColor888840012,
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
            body: Form(
              key: controller.addMeetingKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: SingleChildScrollView(
                child: Padding(
                  padding: Dimens.edgeInsets20,
                  child: Column(
                    children: [
                      CustomTextFormField(
                        controller: controller.titleController,
                        hintText: 'type_meeting_title'.tr,
                        fillColor: ColorsValue.textfildbackcolor,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return 'enter_meeting_title'.tr;
                          }
                          return null;
                        },
                      ),
                      Dimens.boxHeight20,
                      CustomTextFormField(
                        controller: controller.desController,
                        hintText: 'description'.tr,
                        maxLines: 3,
                        fillColor: ColorsValue.textfildbackcolor,
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return 'enter_meeting_desc'.tr;
                          }
                          return null;
                        },
                      ),
                      Dimens.boxHeight20,
                      CustomTextFormField(
                        controller: controller.startDateController,
                        hintText: 'start_date'.tr,
                        readOnly: true,
                        fillColor: ColorsValue.textfildbackcolor,
                        suffixIcon: Padding(
                          padding: Dimens.edgeInsets8,
                          child: SvgPicture.asset(AssetConstants.ic_calender),
                        ),
                        validation: (p0) {
                          if (p0!.isEmpty) {
                            return 'enter_meeting_start_date'.tr;
                          }
                          return null;
                        },
                        onTapped: () async {
                          controller.pickedStart = await showDatePicker(
                            context: context,
                            initialDate: controller.selectedStartDate,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2500),
                            builder: (BuildContext context, Widget? child) {
                              return Theme(
                                data: Theme.of(context).copyWith(
                                  colorScheme: const ColorScheme.light(
                                    primary: ColorsValue.maincolor1,
                                    onPrimary: Colors.white,
                                    onBackground: Colors.white,
                                    onSurface: Colors.black,
                                  ),
                                  datePickerTheme: const DatePickerThemeData(
                                    headerBackgroundColor:
                                        ColorsValue.maincolor1,
                                    backgroundColor: ColorsValue.white,
                                    headerForegroundColor: ColorsValue.white,
                                    surfaceTintColor: ColorsValue.white,
                                  ),
                                ),
                                child: child!,
                              );
                            },
                          );
                          if (controller.pickedStart != null) {
                            controller.startTimeController.clear();
                            controller.endDateController.clear();
                            controller.endTimeController.clear();
                            controller.selectedStartDate =
                                controller.pickedStart!;
                            controller.selectValidStartDate =
                                DateFormat("yyyy-dd-MM")
                                    .format(controller.selectedStartDate);
                            controller.startDateController.text =
                                DateFormat("dd-MM-yyyy")
                                    .format(controller.selectedStartDate);
                            controller.update();
                          } else {
                            print("Not match");
                          }
                        },
                      ),
                      if (controller.startDateController.text.isNotEmpty) ...[
                        Dimens.boxHeight20,
                        CustomTextFormField(
                          controller: controller.startTimeController,
                          readOnly: true,
                          hintText: 'start_time'.tr,
                          fillColor: ColorsValue.textfildbackcolor,
                          suffixIcon: Padding(
                            padding: Dimens.edgeInsets8,
                            child: SvgPicture.asset(AssetConstants.ic_clock),
                          ),
                          validation: (p0) {
                            if (p0!.isEmpty) {
                              return 'enter_meeting_start_time'.tr;
                            }
                            return null;
                          },
                          onTapped: () async {
                            if (controller
                                .startDateController.text.isNotEmpty) {
                              controller.startTimeOfDay = await showTimePicker(
                                initialEntryMode: TimePickerEntryMode.dialOnly,
                                context: context,
                                initialTime: TimeOfDay.now(),
                                builder: (BuildContext context, Widget? child) {
                                  return MediaQuery(
                                    data: MediaQuery.of(context)
                                        .copyWith(alwaysUse24HourFormat: true),
                                    child: child ?? Container(),
                                  );
                                },
                              );
                              if (controller
                                      .startDateController.text.isNotEmpty &&
                                  controller.startTimeOfDay != null) {
                                final DateTime selectedDateTime = DateTime(
                                  controller.pickedStart!.year,
                                  controller.pickedStart!.month,
                                  controller.pickedStart!.day,
                                  controller.startTimeOfDay!.hour,
                                  controller.startTimeOfDay!.minute,
                                );
                                var sel = DateFormat("yyyy-dd-MM")
                                    .format(DateTime.now());
                                if (controller.selectValidStartDate == sel) {
                                  bool isAfter =
                                      DateTime.now().isAfter(selectedDateTime);
                                  if (isAfter) {
                                    Utility.errorMessage(
                                        "Please select future date.");
                                  } else {
                                    controller.selectValidStartTime =
                                        Utility.formatTimeOfDay(
                                            controller.startTimeOfDay ??
                                                TimeOfDay.now());
                                    controller.startTimeController.text =
                                        Utility.formatTimeOfDay(
                                            controller.startTimeOfDay ??
                                                TimeOfDay.now());
                                    controller.update();
                                  }
                                } else {
                                  controller.selectValidStartTime =
                                      Utility.formatTimeOfDay(
                                          controller.startTimeOfDay ??
                                              TimeOfDay.now());
                                  controller.startTimeController.text =
                                      Utility.formatTimeOfDay(
                                          controller.startTimeOfDay ??
                                              TimeOfDay.now());
                                  controller.update();
                                }
                              }
                              // if (controller
                              //         .startDateController.text.isNotEmpty &&
                              //     newTime != null) {
                              //   final DateTime selectedDateTime = DateTime(
                              //     controller.pickedStart!.year,
                              //     controller.pickedStart!.month,
                              //     controller.pickedStart!.day,
                              //     newTime.hour,
                              //     newTime.minute,
                              //   );
                              //   var sel = DateFormat("yyyy-dd-MM")
                              //       .format(DateTime.now());
                              //   if (controller.selectValidStartDate == sel) {
                              // bool isAfter =
                              //     DateTime.now().isAfter(selectedDateTime);
                              // if (isAfter) {
                              //   Utility.errorMessage(
                              //       "Please select future date.");
                              // } else {
                              //   controller.selectValidStartTime =
                              //       Utility.formatTimeOfDay(newTime);
                              //   controller.startTimeController.text =
                              //       Utility.formatTimeOfDay(newTime);
                              //   controller.update();
                              // }
                              //   } else {
                              //     controller.selectValidStartTime =
                              //         Utility.formatTimeOfDay(newTime);
                              //     controller.startTimeController.text =
                              //         Utility.formatTimeOfDay(newTime);
                              //     controller.update();
                              //   }
                              // }
                            } else {
                              Utility.errorMessage(
                                  "Please select time after date select.");
                            }
                          },
                        ),
                      ],
                      if (controller.startTimeController.text.isNotEmpty) ...[
                        Dimens.boxHeight20,
                        CustomTextFormField(
                          controller: controller.endDateController,
                          readOnly: true,
                          hintText: 'end_date'.tr,
                          fillColor: ColorsValue.textfildbackcolor,
                          suffixIcon: Padding(
                            padding: Dimens.edgeInsets8,
                            child: SvgPicture.asset(AssetConstants.ic_calender),
                          ),
                          validation: (p0) {
                            if (p0!.isEmpty) {
                              return 'enter_meeting_start_date'.tr;
                            }
                            return null;
                          },
                          onTapped: () async {
                            controller.pickedEnd = await showDatePicker(
                              context: context,
                              firstDate: controller.selectedStartDate,
                              lastDate: DateTime(2500),
                              initialDate: controller.selectedStartDate,
                              builder: (BuildContext context, Widget? child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: ColorsValue.maincolor1,
                                      onPrimary: Colors.white,
                                      onBackground: Colors.white,
                                      onSurface: Colors.black,
                                    ),
                                    datePickerTheme: const DatePickerThemeData(
                                      headerBackgroundColor:
                                          ColorsValue.maincolor1,
                                      backgroundColor: ColorsValue.white,
                                      headerForegroundColor: ColorsValue.white,
                                      surfaceTintColor: ColorsValue.white,
                                    ),
                                  ),
                                  child: child!,
                                );
                              },
                            );
                            if (controller.pickedEnd != null) {
                              controller.endTimeController.clear();
                              controller.selectedEndDate =
                                  controller.pickedEnd!;
                              controller.selectValidEndDate =
                                  DateFormat("yyyy-dd-MM")
                                      .format(controller.selectedEndDate);
                              controller.endDateController.text =
                                  DateFormat("dd-MM-yyyy")
                                      .format(controller.selectedEndDate);
                              controller.update();
                            }
                          },
                        ),
                      ],
                      if (controller.endDateController.text.isNotEmpty) ...[
                        Dimens.boxHeight20,
                        CustomTextFormField(
                          controller: controller.endTimeController,
                          readOnly: true,
                          hintText: 'end_time'.tr,
                          fillColor: ColorsValue.textfildbackcolor,
                          suffixIcon: Padding(
                            padding: Dimens.edgeInsets8,
                            child: SvgPicture.asset(AssetConstants.ic_clock),
                          ),
                          validation: (p0) {
                            if (p0!.isEmpty) {
                              return 'enter_meeting_end_date'.tr;
                            }
                            return null;
                          },
                          onTapped: () async {
                            final now = DateTime.now();
                            controller.endTimeOfDay = await showTimePicker(
                              initialEntryMode: TimePickerEntryMode.dialOnly,
                              context: context,
                              initialTime: TimeOfDay.now(),
                              builder: (BuildContext context, Widget? child) {
                                return MediaQuery(
                                  data: MediaQuery.of(context)
                                      .copyWith(alwaysUse24HourFormat: true),
                                  child: child ?? Container(),
                                );
                              },
                            );
                            if (controller.endTimeOfDay != null) {
                              final startDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                controller.startTimeOfDay!.hour,
                                controller.startTimeOfDay!.minute,
                              );
                              final endDateTime = DateTime(
                                now.year,
                                now.month,
                                now.day,
                                controller.endTimeOfDay!.hour,
                                controller.endTimeOfDay!.minute,
                              );
                              bool isAfter = startDateTime.isAfter(endDateTime);
                              if (isAfter) {
                                Utility.errorMessage(
                                    "End time must be after start time");
                              } else {
                                controller.selectValidEndTime =
                                    Utility.formatTimeOfDay(
                                        controller.endTimeOfDay ??
                                            TimeOfDay.now());
                                controller.endTimeController.text =
                                    Utility.formatTimeOfDay(
                                        controller.endTimeOfDay ??
                                            TimeOfDay.now());
                                controller.update();
                              }
                            }
                            // } else {
                            //   Utility.errorMessage(
                            //       "Please select time after date select.");
                            // }
                          },
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ));
      },
    );
  }
}
