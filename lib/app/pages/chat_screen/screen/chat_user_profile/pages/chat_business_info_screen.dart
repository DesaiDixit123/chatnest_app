import 'package:cached_network_image/cached_network_image.dart';
import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:lottie/lottie.dart' as lottie;

class ChatBusinessInfoScreen extends StatelessWidget {
  const ChatBusinessInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ChatController>(builder: (controller) {
      return Scaffold(
        backgroundColor: ColorsValue.white,
        body: controller.getOneFriendsData != null
            ? ListView(
                shrinkWrap: true,
                padding: Dimens.edgeInsets0,
                children: [
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
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
                      controller
                              .getOneFriendsData
                              ?.businessprofiles?[controller.userBusinessIndex]
                              .name ??
                          "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  Padding(
                    padding: Dimens.edgeInsets20_0_20_0,
                    child: Visibility(
                      visible: controller
                                  .getOneFriendsData
                                  ?.businessprofiles?[
                                      controller.userBusinessIndex]
                                  .categories
                                  ?.isNotEmpty ??
                              false
                          ? true
                          : false,
                      child: ExpansionTile(
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
                        // dense: false,
                        children: <Widget>[
                          controller
                                      .getOneFriendsData
                                      ?.businessprofiles?[
                                          controller.userBusinessIndex]
                                      .categories
                                      ?.isNotEmpty ??
                                  false
                              ? Wrap(
                                  alignment: WrapAlignment.start,
                                  children: controller
                                          .getOneFriendsData
                                          ?.businessprofiles?[
                                              controller.userBusinessIndex]
                                          .categories
                                          ?.asMap()
                                          .entries
                                          .map((e) {
                                        return ListView(
                                          shrinkWrap: true,
                                          padding: Dimens.edgeInsets40_0_20_0,
                                          children: [
                                            Text(
                                              e.value.parentCategory
                                                      .categoryname ??
                                                  "",
                                              overflow: TextOverflow.clip,
                                              softWrap: true,
                                              style: Styles.black40014,
                                            ),
                                            Wrap(
                                              children: e.value.childCategories
                                                  .map((e) {
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
                                      }).toList() ??
                                      [],
                                )
                              : const Text(" - ")
                        ],
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
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
                      controller
                              .getOneFriendsData
                              ?.businessprofiles?[controller.userBusinessIndex]
                              .mobile ??
                          "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  Visibility(
                    visible: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .wamobile
                                ?.isEmpty ??
                            false
                        ? false
                        : true,
                    child: ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
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
                        controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .wamobile ??
                            "",
                        overflow: TextOverflow.clip,
                        softWrap: true,
                        style: Styles.greyColor888840014,
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
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
                      controller
                              .getOneFriendsData
                              ?.businessprofiles?[controller.userBusinessIndex]
                              .email ??
                          "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.ic_info_outline,
                    ),
                    title: Text(
                      'business_description'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: Text(
                      controller
                              .getOneFriendsData
                              ?.businessprofiles?[controller.userBusinessIndex]
                              .about ??
                          "",
                      overflow: TextOverflow.clip,
                      softWrap: true,
                      style: Styles.greyColor888840014,
                    ),
                  ),
                  Visibility(
                    visible: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .businesshours!
                                .isEmpty ??
                            false
                        ? false
                        : true,
                    child: Container(
                      decoration: BoxDecoration(
                        color: ColorsValue.textfildbackcolor,
                      ),
                      child: ListTile(
                        onTap: () {
                          if (controller.isShowHour) {
                            controller.isShowHour = false;
                          } else {
                            controller.isShowHour = true;
                          }
                          controller.update();
                        },
                        contentPadding: Dimens.edgeInsets20_0_20_0,
                        isThreeLine: true,
                        dense: true,
                        leading: SvgPicture.asset(
                          AssetConstants.businessHour,
                        ),
                        title: Text(
                          'business_hours'.tr,
                          style: Styles.black50014,
                        ),
                        subtitle: Column(
                          children: [
                            Wrap(
                              children: controller
                                  .getOneFriendsData!
                                  .businessprofiles![
                                      controller.userBusinessIndex]
                                  .businesshours!
                                  .asMap()
                                  .entries
                                  .map((e) {
                                return controller.isShowHour
                                    ? Padding(
                                        padding: Dimens.edgeInsets0_5_0_5,
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Flexible(
                                              flex: 5,
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    e.value.day,
                                                    style: Styles
                                                        .greyColor888840014,
                                                  ),
                                                  Text(
                                                    " - ",
                                                    style: Styles
                                                        .greyColor888840014,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Dimens.boxWidth20,
                                            Flexible(
                                              flex: 8,
                                              child: Wrap(
                                                children:
                                                    e.value.time.map((ev) {
                                                  return Column(
                                                    children: [
                                                      Padding(
                                                        padding: Dimens
                                                            .edgeInsetsTopt05,
                                                        child: Text(
                                                          e.value.open
                                                              ? "${ev.starttime} - ${ev.endtime}"
                                                              : "cloased".tr,
                                                          style: Styles
                                                              .greyColor888840014,
                                                        ),
                                                      ),
                                                    ],
                                                  );
                                                }).toList(),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )
                                    : e.key < 2
                                        ? Padding(
                                            padding: Dimens.edgeInsets0_5_0_5,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Flexible(
                                                  flex: 5,
                                                  child: Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        e.value.day,
                                                        style: Styles
                                                            .greyColor888840014,
                                                      ),
                                                      Text(
                                                        " - ",
                                                        style: Styles
                                                            .greyColor888840014,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Dimens.boxWidth20,
                                                Flexible(
                                                  flex: 8,
                                                  child: Wrap(
                                                    children:
                                                        e.value.time.map((ev) {
                                                      return Padding(
                                                        padding: Dimens
                                                            .edgeInsetsTopt05,
                                                        child: Text(
                                                          e.value.open
                                                              ? "${ev.starttime} - ${ev.endtime}"
                                                              : "cloased".tr,
                                                          style: Styles
                                                              .greyColor888840014,
                                                        ),
                                                      );
                                                    }).toList(),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Container();
                              }).toList(),
                            )
                          ],
                        ),
                        trailing: SvgPicture.asset(
                          controller.isShowHour
                              ? AssetConstants.ic_up_arrow
                              : AssetConstants.ic_down_arrow,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    contentPadding: Dimens.edgeInsets20_0_20_0,
                    isThreeLine: true,
                    dense: true,
                    leading: SvgPicture.asset(
                      AssetConstants.business_category,
                    ),
                    title: Text(
                      'interested_business_category'.tr,
                      style: Styles.black50014,
                    ),
                    subtitle: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .interestedCategories
                                ?.isNotEmpty ??
                            false
                        ? Wrap(
                            children: controller
                                .getOneFriendsData!
                                .businessprofiles![controller.userBusinessIndex]
                                .interestedCategories!
                                .asMap()
                                .entries
                                .map((e) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    e.value.parentCategory.categoryname ?? "",
                                    overflow: TextOverflow.clip,
                                    softWrap: true,
                                    style: Styles.black40014,
                                  ),
                                  Wrap(
                                    children: e.value.childCategories.map((e) {
                                      return Text(
                                        "(${e.categoryname ?? ""})",
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
                        : const Text(" - "),
                  ),
                  if (controller.locationBusinessText != "") ...[
                    ListTile(
                      contentPadding: Dimens.edgeInsets20_0_20_0,
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
                    Padding(
                      padding: Dimens.edgeInsets20_0_20_20,
                      child: Container(
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
                            key: UniqueKey(),
                            mapToolbarEnabled: false,
                            zoomGesturesEnabled: false,
                            scrollGesturesEnabled: false,
                            tiltGesturesEnabled: true,
                            rotateGesturesEnabled: false,
                            zoomControlsEnabled: false,
                            myLocationButtonEnabled: false,
                            myLocationEnabled: false,
                            onTap: (argument) {
                              MapsLauncher.launchCoordinates(
                                argument.latitude,
                                argument.longitude,
                              );
                            },
                            onMapCreated: (GoogleMapController mapsController) {
                              controller.mapController.complete(mapsController);

                              controller.mapController.future
                                  .then((controllers) {
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
                    )
                  ],
                  Dimens.boxHeight10,
                  Visibility(
                    visible: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .brochures
                                ?.isEmpty ??
                            false
                        ? false
                        : true,
                    child: Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'business_brochure'.tr,
                            style: Styles.black50014,
                          ),
                          Dimens.boxHeight10,
                          SizedBox(
                            height: Dimens.eighty,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                      .getOneFriendsData
                                      ?.businessprofiles?[
                                          controller.userBusinessIndex]
                                      .brochures
                                      ?.length ??
                                  0,
                              itemBuilder: ((context, index) {
                                var item = controller
                                    .getOneFriendsData
                                    ?.businessprofiles?[
                                        controller.userBusinessIndex]
                                    .brochures?[index];
                                return Padding(
                                  padding: Dimens.edgeInsets5_0_5_0,
                                  child: Container(
                                    height: Dimens.seventyFive,
                                    width: Dimens.seventyFive,
                                    decoration: BoxDecoration(
                                      color: ColorsValue.white,
                                      borderRadius: BorderRadius.circular(
                                        Dimens.six,
                                      ),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                        Dimens.six,
                                      ),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            ApiWrapper.imageUrl + (item ?? ""),
                                        fit: BoxFit.cover,
                                        maxHeightDiskCache: 300,
                                        maxWidthDiskCache: 300,
                                        height: Dimens.seventyFive,
                                        width: Dimens.seventyFive,
                                        placeholder: (context, url) => Center(
                                          child: Image.asset(
                                            AssetConstants.placeholder,
                                            fit: BoxFit.cover,
                                            height: Dimens.seventyFive,
                                            width: Dimens.seventyFive,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            lottie.Lottie.asset(
                                          AssetConstants.imageLoader,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimens.boxHeight10,
                  Visibility(
                    visible: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .photos
                                ?.isEmpty ??
                            false
                        ? false
                        : true,
                    child: Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'business_photo'.tr,
                            style: Styles.black50014,
                          ),
                          Dimens.boxHeight10,
                          SizedBox(
                            height: Dimens.eighty,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                      .getOneFriendsData
                                      ?.businessprofiles?[
                                          controller.userBusinessIndex]
                                      .photos
                                      ?.length ??
                                  0,
                              itemBuilder: ((context, index) {
                                var item = controller
                                    .getOneFriendsData
                                    ?.businessprofiles?[
                                        controller.userBusinessIndex]
                                    .photos?[index];
                                return Padding(
                                  padding: Dimens.edgeInsets5_0_5_0,
                                  child: InkWell(
                                    onTap: () {
                                      RouteManagement.goToShowFullScareenImage(
                                          item ?? "", 'photo'.tr);
                                    },
                                    child: Container(
                                      height: Dimens.seventyFive,
                                      width: Dimens.seventyFive,
                                      decoration: BoxDecoration(
                                        color: ColorsValue.white,
                                        borderRadius: BorderRadius.circular(
                                          Dimens.six,
                                        ),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          Dimens.six,
                                        ),
                                        child: CachedNetworkImage(
                                          imageUrl: ApiWrapper.imageUrl +
                                              (item ?? ""),
                                          fit: BoxFit.cover,
                                          maxHeightDiskCache: 300,
                                          maxWidthDiskCache: 300,
                                          height: Dimens.seventyFive,
                                          width: Dimens.seventyFive,
                                          placeholder: (context, url) => Center(
                                            child: Image.asset(
                                              AssetConstants.placeholder,
                                              fit: BoxFit.cover,
                                              height: Dimens.seventyFive,
                                              width: Dimens.seventyFive,
                                            ),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              lottie.Lottie.asset(
                                            AssetConstants.imageLoader,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimens.boxHeight10,
                  Visibility(
                    visible: controller
                                .getOneFriendsData
                                ?.businessprofiles?[
                                    controller.userBusinessIndex]
                                .videos
                                ?.isEmpty ??
                            false
                        ? false
                        : true,
                    child: Padding(
                      padding: Dimens.edgeInsets20_0_20_0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'business_video'.tr,
                            style: Styles.black50014,
                          ),
                          Dimens.boxHeight10,
                          SizedBox(
                            height: Dimens.eighty,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: controller
                                      .getOneFriendsData
                                      ?.businessprofiles?[
                                          controller.userBusinessIndex]
                                      .videos
                                      ?.length ??
                                  0,
                              itemBuilder: ((context, index) {
                                var item = controller
                                    .getOneFriendsData
                                    ?.businessprofiles?[
                                        controller.userBusinessIndex]
                                    .videos?[index];
                                return Padding(
                                  padding: Dimens.edgeInsets5_0_5_0,
                                  child: Container(
                                    height: Dimens.seventyFive,
                                    width: Dimens.seventyFive,
                                    decoration: BoxDecoration(
                                      color: ColorsValue.white,
                                      borderRadius: BorderRadius.circular(
                                        Dimens.six,
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                            Dimens.six,
                                          ),
                                          child: ThumbNailImageFullpage(
                                            url: item,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            RouteManagement
                                                .goToShowFullScareenImage(
                                                    item, "video".tr);
                                          },
                                          child: Center(
                                            child: SvgPicture.asset(
                                              AssetConstants.ic_video_play,
                                              height: Dimens.eighteen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Dimens.boxHeight10,
                ],
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      );
    });
  }
}
