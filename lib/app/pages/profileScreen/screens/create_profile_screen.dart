import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/app/widgets/custom_outline_button.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';

class CreateProfileScreen extends StatelessWidget {
  const CreateProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      initState: (state) async {
        var controller = Get.find<ProfileController>();
        controller.currentStep = 1;
        controller.isLocation = await Utility.locationPermissionCheack();
        await controller.getProfile();
      },
      builder: (controller) => Scaffold(
        backgroundColor: ColorsValue.white,
        appBar: AppBar(
          elevation: 5,
          shadowColor: Colors.black.withOpacity(0.4),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "createpersonalprofile".tr,
                style: Styles.black70018,
              ),
            ],
          ),
          leading: Padding(
            padding: Dimens.edgeInsets15,
            child: InkWell(
              onTap: () {
                Get.back();
                // Get.offAndToNamed(Routes.userProfileScreen);
              },
              child: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
            ),
          ),
        ),
        body: SafeArea(
          child: ListView(
            shrinkWrap: true,
            padding: Dimens.edgeInsets20_0_20_0,
            children: [
              Dimens.boxHeight10,
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "${controller.currentStep} of 2",
                  style: Styles.main40016,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsValue.maincolor1,
                        borderRadius: BorderRadius.circular(Dimens.two),
                      ),
                      height: Dimens.five,
                    ),
                  ),
                  Dimens.boxWidth10,
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        color: controller.currentStep == 2
                            ? ColorsValue.maincolor1
                            : ColorsValue.grey,
                        borderRadius: BorderRadius.circular(Dimens.two),
                      ),
                      height: Dimens.five,
                    ),
                  ),
                ],
              ),
              controller.currentStep == 1
                  ? Form(
                      key: controller.createprofileFormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: Dimens.edgeInsets20,
                            child: Center(
                              child: ProfileWidget(
                                imagePath: ApiWrapper.imageUrl +
                                    (controller.profileImage ?? ""),
                                isEdit: true,
                                isSelected: false,
                                onClicked: () async {
                                  if (await Utility.imagePermissionCheack(
                                      context)) {
                                    controller.setProfilePic();
                                  }
                                },
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "fullname".tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight5,
                              CustomTextFormField(
                                isCompulsoryText: true,
                                hintText: 'fullname'.tr,
                                controller: controller.firestNameController,
                                fillColor: ColorsValue.textfildbackcolor,
                                textInputAction: TextInputAction.next,
                                validation: (value) {
                                  return controller.validname(value!);
                                },
                              ),
                            ],
                          ),
                          Dimens.boxHeight20,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "emailid".tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight5,
                              CustomTextFormField(
                                isCompulsoryText: true,
                                controller: controller.emailController,
                                hintText: 'emailid'.tr,
                                keybordtype: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorsValue.textfildbackcolor,
                                validation: (value) {
                                  return controller.validEmail(value!);
                                },
                              ),
                            ],
                          ),
                          Dimens.boxHeight20,
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "dob".tr,
                                      style: Styles.black50014,
                                    ),
                                    Dimens.boxHeight5,
                                    CustomTextFormField(
                                      onTapped: () async {
                                        final DateTime? picked =
                                            await showDatePicker(
                                          context: context,
                                          initialDate: controller.selectedDate,
                                          firstDate: DateTime(1920),
                                          lastDate: DateTime(2100),
                                          builder: (BuildContext context,
                                              Widget? child) {
                                            return Theme(
                                              data: Theme.of(context).copyWith(
                                                colorScheme:
                                                    const ColorScheme.light(
                                                  primary: ColorsValue.maincolor1,
                                                  onPrimary: Colors.white,
                                                  onSurface: Colors.black,
                                                ),
                                                datePickerTheme:
                                                    const DatePickerThemeData(
                                                  headerBackgroundColor:
                                                      ColorsValue.maincolor1,
                                                  backgroundColor:
                                                      ColorsValue.white,
                                                  headerForegroundColor:
                                                      ColorsValue.white,
                                                  surfaceTintColor:
                                                      ColorsValue.white,
                                                ),
                                              ),
                                              child: child!,
                                            );
                                          },
                                        );
                                        if (picked != null &&
                                            picked != controller.selectedDate) {
                                          controller.selectedDate = picked;
                                          controller.timecontroller.text =
                                              DateFormat("dd MMM yyyy")
                                                  .format(controller.selectedDate);
                                          controller.update();
                                        }
                                      },
                                      textInputAction: TextInputAction.next,
                                      controller: controller.timecontroller,
                                      hintText: 'dob'.tr,
                                      suffixIcon: Padding(
                                        padding: Dimens.edgeInsets15,
                                        child: SvgPicture.asset(
                                          AssetConstants.calendericon,
                                        ),
                                      ),
                                      readOnly: true,
                                      fillColor: ColorsValue.textfildbackcolor,
                                      validation: (value) {
                                        if (value?.isEmpty ?? false) {
                                          return 'please_enter_the_dob'.tr;
                                        }
                                        return null;
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Dimens.boxWidth20,
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "gender".tr,
                                      style: Styles.black50014,
                                    ),
                                    Dimens.boxHeight5,
                                    Container(
                                      height: Dimens.fifty,
                                      decoration: BoxDecoration(
                                          color: ColorsValue.textfildbackcolor,
                                          borderRadius:
                                              BorderRadius.circular(Dimens.six)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton(
                                          focusColor:
                                              ColorsValue.textfildbackcolor,
                                          isExpanded: true,
                                          value: controller.selectGender,
                                          icon: Container(
                                            margin: EdgeInsets.symmetric(
                                                horizontal: Dimens.thirteen),
                                            height: Dimens.ten,
                                            width: Dimens.sixteen,
                                            alignment: Alignment.center,
                                            child: SvgPicture.asset(
                                                AssetConstants.downicon),
                                          ),
                                          onChanged: (String? val) {
                                            controller.selectGender = val;
                                            controller.update();
                                          },
                                          items:
                                              controller.genderList.map((option) {
                                            return DropdownMenuItem(
                                              value: option,
                                              child: Center(
                                                child: Text(option),
                                              ),
                                            );
                                          }).toList(),
                                          selectedItemBuilder: (con) {
                                            return controller.genderList
                                                .map((val) {
                                              return Align(
                                                alignment: Alignment.centerLeft,
                                                child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: Dimens.thirteen),
                                                  child: Text(val,
                                                      textAlign: TextAlign.center,
                                                      style: Styles.black40014),
                                                ),
                                              );
                                            }).toList();
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Dimens.boxHeight20,
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "aboutme".tr,
                                style: Styles.black50014,
                              ),
                              Dimens.boxHeight5,
                              CustomTextFormField(
                                isCompulsoryText: true,
                                hintText: 'aboutme'.tr,
                                textInputAction: TextInputAction.next,
                                fillColor: ColorsValue.textfildbackcolor,
                                maxLines: 3,
                                maxLength: 2000,
                                controller: controller.aboutmeController,
                                validation: (value) {
                                  return controller.validaboutme(value!);
                                },
                                onTapped: () {},
                                onChanged: (value) {
                                  controller
                                      .update(); // if you're using GetBuilder
                                },
                              ),
                              Dimens.boxHeight5,
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(
                                  '${controller.aboutmeController.text.length} / 2000',
                                  style: Styles.greyAAA40014,
                                ),
                              )
                            ],
                          ),
                          Dimens.boxHeight20,
                          // TextFieldTags(
                          //   key: UniqueKey(),
                          //   textfieldTagsController:
                          //       TextfieldTagsController<String>(),
                          //   textSeparators: const [' ', ','],
                          //   initialTags: controller.hobbiesList,
                          //   inputFieldBuilder: (context, textFieldTagValues) {
                          //     controller.hobbiesList.clear();
                          //     controller.hobbiesList
                          //         .addAll(textFieldTagValues.tags);
                          //     return TextField(
                          //       controller:
                          //           textFieldTagValues.textEditingController,
                          //       focusNode: textFieldTagValues.focusNode,
                          //       decoration: InputDecoration(
                          //           isDense: true,
                          //           border: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //               width: Dimens.zero,
                          //               style: BorderStyle.none,
                          //             ),
                          //             borderRadius:
                          //                 BorderRadius.circular(Dimens.five),
                          //           ),
                          //           fillColor: ColorsValue.textfildbackcolor,
                          //           filled: true,
                          //           focusedBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: Dimens.zero,
                          //                 style: BorderStyle.none),
                          //             borderRadius:
                          //                 BorderRadius.circular(Dimens.five),
                          //           ),
                          //           disabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: Dimens.zero,
                          //                 style: BorderStyle.none),
                          //             borderRadius:
                          //                 BorderRadius.circular(Dimens.five),
                          //           ),
                          //           enabledBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: Dimens.zero,
                          //                 style: BorderStyle.none),
                          //             borderRadius:
                          //                 BorderRadius.circular(Dimens.five),
                          //           ),
                          //           focusedErrorBorder: OutlineInputBorder(
                          //             borderSide: BorderSide(
                          //                 width: Dimens.zero,
                          //                 style: BorderStyle.none),
                          //             borderRadius:
                          //                 BorderRadius.circular(Dimens.five),
                          //           ),
                          //           hintText: 'hobbies'.tr,
                          //           hintStyle: Styles.greyAAA40014,
                          //           prefixIcon: textFieldTagValues
                          //                   .tags.isNotEmpty
                          //               ? SingleChildScrollView(
                          //                   controller: textFieldTagValues
                          //                       .tagScrollController,
                          //                   scrollDirection: Axis.horizontal,
                          //                   child: Row(
                          //                       children: controller.hobbiesList
                          //                           .map((String tag) {
                          //                     return Container(
                          //                       decoration: BoxDecoration(
                          //                         borderRadius:
                          //                             BorderRadius.circular(
                          //                                 Dimens.twenty),
                          //                         color: ColorsValue.white,
                          //                       ),
                          //                       margin: Dimens.edgeInsets5,
                          //                       padding: EdgeInsets.symmetric(
                          //                           horizontal: Dimens.ten,
                          //                           vertical: Dimens.five),
                          //                       child: Row(
                          //                         mainAxisAlignment:
                          //                             MainAxisAlignment
                          //                                 .spaceBetween,
                          //                         children: [
                          //                           InkWell(
                          //                             child: Text(
                          //                               tag,
                          //                               style: Styles
                          //                                   .greyColor888840014,
                          //                             ),
                          //                           ),
                          //                           Dimens.boxWidth5,
                          //                           InkWell(
                          //                             child: Icon(
                          //                               Icons.close,
                          //                               size: Dimens.fifteen,
                          //                               color: ColorsValue
                          //                                   .blackColor,
                          //                             ),
                          //                             onTap: () {
                          //                               textFieldTagValues
                          //                                   .onTagRemoved(tag);
                          //                               controller.hobbiesList
                          //                                   .remove(tag);
                          //                             },
                          //                           )
                          //                         ],
                          //                       ),
                          //                     );
                          //                   }).toList()),
                          //                 )
                          //               : null),
                          //       onChanged: textFieldTagValues.onTagChanged,
                          //       onSubmitted: textFieldTagValues.onTagSubmitted,
                          //     );
                          //   },
                          // ),

                          TextFieldTags<String>(
                            key: UniqueKey(),
                            textfieldTagsController:
                                TextfieldTagsController<String>(),
                            textSeparators: const [' ', ','],
                            initialTags: controller.hobbiesList,
                            inputFieldBuilder: (context, textFieldTagValues) {
                              return TextField(
                                controller:
                                    textFieldTagValues.textEditingController,
                                focusNode: textFieldTagValues.focusNode,
                                decoration: InputDecoration(
                                  isDense: true,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.five),
                                  ),
                                  fillColor: ColorsValue.textfildbackcolor,
                                  filled: true,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.five),
                                  ),
                                  disabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.five),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.five),
                                  ),
                                  focusedErrorBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none),
                                    borderRadius:
                                        BorderRadius.circular(Dimens.five),
                                  ),
                                  hintText: 'hobbies'.tr,
                                  hintStyle: Styles.greyAAA40014,
                                  prefixIcon: textFieldTagValues.tags.isNotEmpty
                                      ? SingleChildScrollView(
                                          controller: textFieldTagValues
                                              .tagScrollController,
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            children: controller.hobbiesList
                                                .map((String tag) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          Dimens.twenty),
                                                  color: ColorsValue.white,
                                                ),
                                                margin: Dimens.edgeInsets5,
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: Dimens.ten,
                                                  vertical: Dimens.five,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      tag,
                                                      style: Styles
                                                          .greyColor888840014,
                                                    ),
                                                    Dimens.boxWidth5,
                                                    InkWell(
                                                      child: Icon(
                                                        Icons.close,
                                                        size: Dimens.fifteen,
                                                        color: ColorsValue
                                                            .blackColor,
                                                      ),
                                                      onTap: () {
                                                        textFieldTagValues
                                                            .onTagRemoved(tag);
                                                        controller.hobbiesList
                                                            .remove(tag);
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              );
                                            }).toList(),
                                          ),
                                        )
                                      : null,
                                ),
                                onChanged: (val) {
                                  // Optional: only update UI on change if needed
                                },
                                onSubmitted: (tag) {
                                  controller.hobbiesList.add(tag);
                                },
                              );
                            },
                          ),
                          Dimens.boxHeight30,
                          CustomButton(
                            height: Dimens.fifty,
                            text: 'next'.tr.toUpperCase(),
                            onTap: () {
                              // if (controller.timecontroller.text.isEmpty) {
                              //   Utility.errorMessage(
                              //     "Please Enter Date of birth".tr,
                              //   );
                              // } else
                              if (controller.createprofileFormKey.currentState!
                                  .validate()) {
                                controller.currentStep = 2;
                                controller.update();
                              }
                            },
                          ),
                          Dimens.boxHeight30,
                        ],
                      ),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Dimens.boxHeight20,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Location",
                              style: Styles.black50014,
                            ),
                            Dimens.boxHeight5,
                            Container(
                              height: Dimens.ninty,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(Dimens.six),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(Dimens.six),
                                child: Stack(
                                  children: [
                                    GoogleMap(
                                      mapToolbarEnabled: false,
                                      zoomGesturesEnabled: false,
                                      scrollGesturesEnabled: false,
                                      tiltGesturesEnabled: true,
                                      rotateGesturesEnabled: false,
                                      zoomControlsEnabled: false,
                                      myLocationButtonEnabled: false,
                                      myLocationEnabled: false,
                                      onMapCreated: controller.onMapCreated,
                                      initialCameraPosition: CameraPosition(
                                        target: controller.profileLatLag ??
                                            const LatLng(21.170240, 72.831062),
                                        zoom: 14,
                                      ),
                                      markers: controller.markers.isEmpty
                                          ? {
                                              Marker(
                                                markerId:
                                                    const MarkerId("mark"),
                                                position: controller
                                                        .profileLatLag ??
                                                    const LatLng(
                                                        21.170240, 72.831062),
                                                draggable: true,
                                              ),
                                            }
                                          : controller.markers,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        if (await Utility
                                            .locationPermissionCheack()) {
                                          await RouteManagement
                                                  .goToLocationScreen()
                                              .then(
                                            (value) {
                                              controller.moveToLocation(
                                                  controller.profileLatLag ??
                                                      const LatLng(21.170240,
                                                          72.831062));
                                            },
                                          );
                                        }
                                      },
                                      child: SizedBox(
                                        width: double.maxFinite,
                                        height: Dimens.ninty,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () async {
                                        if (await Utility
                                            .locationPermissionCheack()) {
                                          await RouteManagement
                                                  .goToLocationScreen()
                                              .then((value) {
                                            controller.moveToLocation(
                                                controller.profileLatLag ??
                                                    const LatLng(
                                                        21.170240, 72.831062));
                                          });
                                        }
                                      },
                                      child: Visibility(
                                        visible: controller.isLocation
                                            ? false
                                            : true,
                                        child: Container(
                                          width: double.infinity,
                                          height: Dimens.ninty,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color:
                                                Colors.black12.withOpacity(0.5),
                                          ),
                                          child: Center(
                                            child: Text(
                                              "location_msg_error".tr,
                                              textAlign: TextAlign.center,
                                              style: Styles.redcolor70016,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        Dimens.boxHeight20,
                        Text(
                          "intrestedin".tr,
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight10,
                        Row(
                          children: [
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.interestedindex = 1;
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.interestedindex == 1
                                        ? ColorsValue.maincolor1
                                        : ColorsValue.withopacitymaincolor1,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(Dimens.five),
                                      bottomLeft: Radius.circular(Dimens.five),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: Dimens.edgeInsets15,
                                    child: Center(
                                        child: Text(
                                      "male".tr,
                                      style: controller.interestedindex == 1
                                          ? Styles.white50016
                                          : Styles.main50016,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Dimens.boxWidth2,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.interestedindex = 2;
                                  controller.update();
                                },
                                child: Container(
                                  color: controller.interestedindex == 2
                                      ? ColorsValue.maincolor1
                                      : ColorsValue.withopacitymaincolor1,
                                  child: Padding(
                                    padding: Dimens.edgeInsets15,
                                    child: Center(
                                        child: Text(
                                      "femail".tr,
                                      style: controller.interestedindex == 2
                                          ? Styles.white50016
                                          : Styles.main50016,
                                    )),
                                  ),
                                ),
                              ),
                            ),
                            Dimens.boxWidth2,
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.interestedindex = 3;
                                  controller.update();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: controller.interestedindex == 3
                                        ? ColorsValue.maincolor1
                                        : ColorsValue.withopacitymaincolor1,
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(Dimens.five),
                                      bottomRight: Radius.circular(Dimens.five),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: Dimens.edgeInsets15,
                                    child: Center(
                                      child: Text(
                                        "Transgender".tr,
                                        overflow: TextOverflow.ellipsis,
                                        style: controller.interestedindex == 3
                                            ? Styles.white50016
                                            : Styles.main50016,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Dimens.boxHeight20,
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "intrestedagerange".tr,
                              style: Styles.black50014,
                            ),
                            Text(
                              controller.startValue == 0.0
                                  ? "${18} - ${70} Age"
                                  : "${controller.startValue.toStringAsFixed(0)} - ${controller.endValue.toStringAsFixed(0)} Age",
                              style: Styles.main40014,
                            ),
                          ],
                        ),
                        RangeSlider(
                          min: 18,
                          max: 70,
                          activeColor: ColorsValue.maincolor1,
                          inactiveColor: ColorsValue.darkgrey,
                          values: RangeValues(
                            controller.startValue == 0.0
                                ? 18.0
                                : controller.startValue,
                            controller.endValue == 0.0
                                ? 30.0
                                : controller.endValue,
                          ),
                          onChanged: (newValues) {
                            controller.startValue = newValues.start;
                            controller.endValue = newValues.end;
                            controller.update();
                          },
                        ),
                        Dimens.boxHeight10,
                        Text(
                          "addsocialmedialink".tr,
                          style: Styles.black50014,
                        ),
                        Dimens.boxHeight10,
                        Wrap(
                          children: controller.socialMediaList
                              .asMap()
                              .entries
                              .map((e) {
                            return Padding(
                              padding: Dimens.edgeInsets5,
                              child: InkWell(
                                onTap: () {
                                  controller.index = e.key;
                                  controller.update();
                                },
                                child: Container(
                                  height: e.value.size,
                                  width: e.value.size,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: controller.index == e.key
                                          ? ColorsValue.maincolor1
                                          : Colors.transparent,
                                      width: Dimens.two,
                                    ),
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(
                                      Dimens.hundred,
                                    ),
                                    child: Image.asset(
                                      e.value.icon ?? "",
                                      height: e.value.size,
                                      width: e.value.size,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                        //     ),
                        //   ],
                        // ),
                        CustomTextFormField(
                          controller: controller
                              .socialMediaList[controller.index]
                              .textEditingController,
                          hintText: controller
                              .socialMediaList[controller.index].hintText,
                          fillColor: ColorsValue.textfildbackcolor,
                          onChanged: (value) {
                            controller.socialMediaList[controller.index].url =
                                value;
                            controller.update();
                          },
                        ),
                        Dimens.boxHeight30,
                        CustomBottomButton(
                          firstbtnText: "back".tr,
                          secondbtnTxt: "save".tr,
                          firstStyle: Styles.main50016,
                          secondStyle: Styles.white50016,
                          firstOnPressed: () {
                            controller.currentStep -= 1;
                            controller.update();
                          },
                          secondOnPressed: () async {
                            if (await Utility.locationPermissionCheack()) {
                              var data = await controller.setProfile();
                              if (data) {
                                await Get.offAndToNamed(
                                    Routes.userProfileScreen);
                                // Get.back();
                                if (!Get.isRegistered<ProfileController>()) {
                                  ProfileBinding().dependencies();
                                } else {
                                  print(false);
                                }
                              }
                            }
                          },
                        ),
                        Dimens.boxHeight12,
                        CustomOutlineButton(
                          firstOnPressed: () async {
                            if (controller.profileLatLag == null) {
                              Utility.errorMessage('please_select_location'.tr);
                            } else {
                              var data = await controller.setProfile();
                              if (data) {
                                RouteManagement.goToBusinessProfileScreen("");
                              }
                            }
                          },
                          firstStyle: Styles.main50016,
                          hinttext: 'saveand_create_business'.tr,
                        )
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
