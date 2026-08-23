import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusinessInfoScreen extends StatelessWidget {
  const BusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      builder: (controller) {
        return controller.businessList.isNotEmpty
            ? ListView(
                shrinkWrap: true,
                padding: Dimens.edgeInsets20_0_20_0,
                children: [
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.businessnameicon,
                    ),
                    title: Text(
                      'business_name'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller.getOneBusinessData.name ?? "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  Visibility(
                    visible:
                        controller.getOneBusinessData.categories?.isNotEmpty ??
                                false
                            ? true
                            : false,
                    child: ExpansionTile(
                      childrenPadding: Dimens.edgeInsets0,
                      tilePadding: Dimens.edgeInsets0,
                      backgroundColor: Colors.transparent,
                      collapsedBackgroundColor: Colors.transparent,
                      collapsedShape: BeveledRectangleBorder(
                        side: BorderSide(
                          width: Dimens.zero,
                          color: Colors.transparent,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: Dimens.zero,
                          color: Colors.transparent,
                        ),
                      ),
                      leading: SvgPicture.asset(
                        AssetConstants.businesscategoryicon,
                      ),
                      title: Text(
                        'businessCategory'.tr,
                        style: Styles.black50014,
                      ),
                      onExpansionChanged: (value) {
                        if (controller.isCategory) {
                          controller.isCategory = false;
                        } else {
                          controller.isCategory = true;
                        }
                        controller.update();
                      },
                      trailing: SvgPicture.asset(
                        controller.isCategory
                            ? AssetConstants.ic_up_arrow
                            : AssetConstants.ic_down_arrow,
                      ),
                      children: <Widget>[
                        controller.getOneBusinessData.categories?.isNotEmpty ??
                                false
                            ? Wrap(
                                children: controller
                                    .getOneBusinessData.categories!
                                    .asMap()
                                    .entries
                                    .map((e) {
                                  return ListView(
                                    shrinkWrap: true,
                                    padding: Dimens.edgeInsets40_0_20_0,
                                    children: [
                                      Text(
                                        e.value.parentCategory.categoryname ??
                                            "",
                                        overflow: TextOverflow.clip,
                                        softWrap: true,
                                        style: Styles.black40014,
                                      ),
                                      Wrap(
                                        children:
                                            e.value.childCategories.map((e) {
                                          return Text(
                                            "(${e.categoryname ?? ""}) ${''}",
                                            overflow: TextOverflow.clip,
                                            softWrap: true,
                                            style: Styles.grey9BA40014,
                                          );
                                        }).toList(),
                                      )
                                    ],
                                  );
                                }).toList(),
                              )
                            : const Text(" - ")
                      ],
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.callicon,
                    ),
                    title: Text(
                      'business_phone_number'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller.getOneBusinessData.mobile ?? " - ",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  Visibility(
                    visible: controller.getOneBusinessData.wamobile != ""
                        ? true
                        : false,
                    child: ListTile(
                      contentPadding: Dimens.edgeInsets0,
                      isThreeLine: true,
                      dense: true,
                      leading: SvgPicture.asset(
                        AssetConstants.callicon,
                      ),
                      title: Text(
                        'business_wa_phone_number'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        controller.getOneBusinessData.wamobile ?? " - ",
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: Styles.greyColor888840014,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.smsicon,
                    ),
                    title: Text(
                      'business_emailId'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller.getOneBusinessData.email ?? " - ",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.businesswebsiteicon,
                    ),
                    title: Text(
                      'business_website'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller.getOneBusinessData.website ?? " - ",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  if (controller.locationBusinessText != "") ...[
                    ListTile(
                      contentPadding: Dimens.edgeInsets0,
                      isThreeLine: true,
                      dense: true,
                      leading: SvgPicture.asset(
                        AssetConstants.locationicon,
                      ),
                      title: Text(
                        'location'.tr,
                        style: Styles.black50014,
                      ),
                      subtitle: Text(
                        controller.locationBusinessText.isNotEmpty
                            ? controller.locationBusinessText
                            : " -- ",
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: Styles.greyColor888840014,
                      ),
                    ),
                    Dimens.boxHeight10,
                    Container(
                      height: Dimens.eightyFive,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                        child: GoogleMap(
                          mapToolbarEnabled: false,
                          zoomGesturesEnabled: false,
                          scrollGesturesEnabled: false,
                          tiltGesturesEnabled: true,
                          rotateGesturesEnabled: false,
                          zoomControlsEnabled: false,
                          myLocationButtonEnabled: false,
                          myLocationEnabled: false,
                          onMapCreated: (GoogleMapController mapsController) {
                            if (!controller.controllerMap.isCompleted) {
                              controller.controllerMap.complete(mapsController);
                            }

                            controller.controllerMap.future.then((controllers) {
                              controllers.animateCamera(
                                CameraUpdate.newCameraPosition(
                                  CameraPosition(
                                    target: controller.businessLatlag ??
                                        const LatLng(21.170240, 72.831062),
                                    zoom: 15.0,
                                  ),
                                ),
                              );
                            });

                            controller.setMarker(controller.businessLatlag ??
                                const LatLng(21.170240, 72.831062));
                          },
                          initialCameraPosition: CameraPosition(
                            target: controller.businessLatlag ??
                                LatLng(21.170240, 72.831062),
                            zoom: 14,
                          ),
                          markers: controller.markers.isEmpty
                              ? {
                                  Marker(
                                    markerId: const MarkerId("mark"),
                                    position: controller.businessLatlag ??
                                        const LatLng(21.170240, 72.831062),
                                    draggable: true,
                                  ),
                                }
                              : controller.markers,
                        ),
                      ),
                    ),
                    Dimens.boxHeight10,
                  ],
                  ExpansionTile(
                    childrenPadding: Dimens.edgeInsets0,
                    tilePadding: Dimens.edgeInsets0,
                    backgroundColor: Colors.transparent,
                    collapsedBackgroundColor: Colors.transparent,
                    collapsedShape: BeveledRectangleBorder(
                      side: BorderSide(
                        width: Dimens.zero,
                        color: Colors.transparent,
                      ),
                    ),
                    shape: RoundedRectangleBorder(
                      side: BorderSide(
                        width: Dimens.zero,
                        color: Colors.transparent,
                      ),
                    ),
                    leading: SvgPicture.asset(
                      AssetConstants.businessHour,
                    ),
                    title: Text(
                      'business_hours'.tr,
                      style: Styles.black50014,
                    ),
                    onExpansionChanged: (value) {
                      if (controller.isCategory) {
                        controller.isCategory = false;
                      } else {
                        controller.isCategory = true;
                      }
                      controller.update();
                    },
                    trailing: SvgPicture.asset(
                      controller.isCategory
                          ? AssetConstants.ic_up_arrow
                          : AssetConstants.ic_down_arrow,
                    ),
                    children: controller
                        .businessList[controller.businessIndex].businesshours!
                        .asMap()
                        .entries
                        .map((e) {
                      return Padding(
                        padding: Dimens.edgeInsets20_5_20_5,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    e.value.day,
                                    style: Styles.greyColor888840014,
                                  ),
                                  Text(
                                    " - ",
                                    style: Styles.greyColor888840014,
                                  ),
                                ],
                              ),
                            ),
                            Dimens.boxWidth20,
                            Flexible(
                              flex: 8,
                              child: Wrap(
                                children: e.value.time.map((ev) {
                                  return Padding(
                                    padding: Dimens.edgeInsetsTopt05,
                                    child: Text(
                                      e.value.open
                                          ? "${ev.starttime} - ${ev.endtime}"
                                          : "cloased".tr,
                                      style: Styles.greyColor888840014,
                                    ),
                                  );
                                }).toList(),
                              ),
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  Dimens.boxHeight20,
                  CustomButton(
                    text: 'add_new_business'.tr.toUpperCase(),
                    style: Styles.white50016,
                    onTap: () {
                      RouteManagement.goToBusinessProfileScreen("");
                    },
                    height: Dimens.fifty,
                  ),
                  Dimens.boxHeight20,
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorsValue.whiteColor,
                      fixedSize: Size(double.infinity, Dimens.fifty),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                        side: const BorderSide(
                          width: 1,
                          color: ColorsValue.redColor,
                        ),
                      ),
                    ),
                    onPressed: () {
                      controller.removeBusiness(
                          controller.getOneBusinessData.id ?? "");
                    },
                    child: Text(
                      'delet_business_profile'.tr.toUpperCase(),
                      style: Styles.redcolor50014,
                    ),
                  ),
                  Dimens.boxHeight50,
                ],
              )
            : ListView(
                shrinkWrap: true,
                padding: Dimens.edgeInsets20_20_20_0,
                children: [
                  Column(
                    children: [
                      Text(
                        "create_business_profile".tr,
                        style: Styles.black50018,
                      ),
                      Dimens.boxHeight5,
                      Text(
                        "empty_business_profile_discription".tr,
                        style: Styles.greyColor888840014,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: Dimens.hundredSixty,
                        width: Dimens.hundredSixty,
                        child: Image.asset(
                          AssetConstants.emptybusinessprofile,
                        ),
                      ),
                    ],
                  ),
                  Dimens.boxHeight30,
                  CustomButton(
                    text: 'create'.tr.toUpperCase(),
                    height: Dimens.fifty,
                    onTap: () {
                      RouteManagement.goToBusinessProfileScreen("");
                    },
                  ),
                ],
              );
      },
    );
  }
}
