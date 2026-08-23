import 'package:chatnest/app/app.dart';
import 'package:chatnest/data/helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class ShareLocationScreen extends StatelessWidget {
  const ShareLocationScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final _debouncer = Debouncer(milliseconds: 500);
    return GetBuilder<ChatController>(
      initState: (state) async {
        var controller = Get.find<ChatController>();
        controller.getSearchListData();
        controller.getCurrentPosition();
      },
      builder: (controller) => Scaffold(
        appBar: AppBar(
          shadowColor: ColorsValue.greyAAAAAA,
          backgroundColor: ColorsValue.white,
          elevation: Dimens.two,
          centerTitle: false,
          title: Text(
            "send_location".tr,
            style: Styles.black70018,
          ),
          leading: Container(
            margin: Dimens.edgeInsets20_0_0_0,
            child: IconButton(
              icon: SvgPicture.asset(AssetConstants.appbarbackarrowicon),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                if (controller.isSearchLoation) {
                  controller.isSearchLoation = false;
                } else {
                  controller.isSearchLoation = true;
                }
                controller.update();
              },
              child: Padding(
                padding: Dimens.edgeInsetsRight10,
                child: SvgPicture.asset(
                  AssetConstants.searchIcon,
                  height: Dimens.twenty,
                  width: Dimens.twenty,
                  colorFilter: ColorFilter.mode(
                    ColorsValue.appColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
            Padding(
              padding: Dimens.edgeInsetsRight20,
              child: InkWell(
                onTap: () {
                  if (controller.selectedLocationLatLag == null) {
                    Utility.errorMessage("please_select_location".tr);
                    return;
                  }
                  controller
                      .getLocationScreen(controller.selectedLocationLatLag!);
                  if (Get.arguments[0] ?? false) {
                    controller.sendGroupMessage("", true, false);
                  } else if (Get.arguments[1] ?? false) {
                    controller.postSendMessageBroadcast("", true);
                  } else {
                    controller.sendMessage("", true, false);
                  }
                  Get.back();
                },
                child: SvgPicture.asset(
                  AssetConstants.ic_share,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: ColorsValue.white,
        body: SafeArea(
          child: Column(
            children: [
              if (controller.isSearchLoation) ...[
                Padding(
                  padding: Dimens.edgeInsets20_10_20_10,
                  child: SizedBox(
                    height: Dimens.fourtyFive,
                    child: GooglePlaceAutoCompleteTextField(
                      focusNode: controller.locationFocusNode,
                      textEditingController:
                          controller.searchLocationController,
                      seperatedBuilder: const SizedBox(),
                      googleAPIKey: ApiWrapper.placeApiCall,
                      inputDecoration: InputDecoration(
                        suffixIcon: Icon(
                          Icons.search,
                          size: Dimens.twentyFour,
                          color: ColorsValue.hookupHeaderGreyColor,
                        ),
                        counterText: '',
                        contentPadding: Dimens.edgeInsets10,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimens.zero,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        disabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimens.zero,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimens.zero,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimens.zero,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.circular(Dimens.five),
                        ),
                        fillColor: ColorsValue.textfildbackcolor,
                        filled: true,
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            width: Dimens.zero,
                            style: BorderStyle.none,
                          ),
                          borderRadius: BorderRadius.circular(
                            Dimens.five,
                          ),
                        ),
                        border: InputBorder.none,
                        hintText: 'search'.tr,
                        hintStyle: Styles.greyAAA40014,
                        isCollapsed: false,
                      ),
                      boxDecoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.all(
                            width: Dimens.zero, color: ColorsValue.transparent),
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                      ),
                      debounceTime: 1000,
                      isLatLngRequired: true,
                      getPlaceDetailWithLatLng: (postalCodeResponse) async {
                        controller.locationFocusNode.unfocus();
                        controller.selectedLocationLatLag = LatLng(
                            double.parse(postalCodeResponse.lat!),
                            double.parse(postalCodeResponse.lng!));
                        controller.mapController.future.then((value) {
                          value.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(
                                target: controller.selectedLocationLatLag ??
                                    const LatLng(21.170240, 72.831062),
                                zoom: 15.0,
                              ),
                            ),
                          );
                        });
                        controller.update();
                      },
                      itemClick: (postalCodeResponse) {
                        print("object");
                        // controller.moveToLocation(LatLng(
                        //     double.parse(postalCodeResponse.lat!),
                        //     double.parse(postalCodeResponse.lng!)));
                        // controller.update();
                      },
                      itemBuilder: (context, index, Prediction prediction) {
                        return Container(
                          color: ColorsValue.textfildbackcolor,
                          padding: Dimens.edgeInsets10,
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                              ),
                              Dimens.boxWidth7,
                              Expanded(
                                child: Text(
                                  prediction.description ?? "-",
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      isCrossBtnShown: false,
                    ),
                  ),
                ),
              ],
              SizedBox(
                height: controller.isSearchLoation
                    ? Dimens.threeHundred
                    : Dimens.threeHundredFifty,
                child: GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: controller.selectedLocationLatLag ??
                        const LatLng(
                          21.170240,
                          72.831062,
                        ),
                    zoom: 14,
                  ),
                  onTap: (LatLng latLng) async {
                    controller.selectedLocationLatLag = latLng;
                    controller.update();
                  },
                  onMapCreated: controller.onMapCreated,
                  markers: {
                    Marker(
                      markerId: const MarkerId("mark"),
                      position: controller.selectedLocationLatLag ??
                          const LatLng(21.170240, 72.831062),
                      draggable: true,
                      onDragEnd: (value) {
                        print(value);
                      },
                    ),
                  },
                ),
              ),
              Dimens.boxHeight10,
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: Dimens.edgeInsets20_0_20_0,
                          child: ListTile(
                            onTap: () async {
                              await controller.getCurrentPosition();
                              controller.sendMessageController.clear();
                              controller.update();
                              if (Get.arguments[0] ?? false) {
                                controller.sendGroupMessage("", true, false);
                              } else if (Get.arguments[1] ?? false) {
                                controller.postSendMessageBroadcast("", true);
                              } else {
                                controller.sendMessage("", true, false);
                              }
                              Get.back();
                            },
                            contentPadding: Dimens.edgeInsets0,
                            title: Text(
                              "current_location".tr,
                              style: Styles.black70014,
                            ),
                            subtitle: Text(
                              'accurate_10_menters'.tr,
                              style: Styles.main40012,
                            ),
                            leading: Container(
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(Dimens.thirty),
                                border: Border.all(
                                  color: ColorsValue.maincolor1,
                                  width: 2,
                                ),
                                color: ColorsValue.maincoloropacity1,
                              ),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(Dimens.thirty),
                                child: Padding(
                                  padding: Dimens.edgeInsets8,
                                  child: SvgPicture.asset(
                                    'assets/icons/curentLocation.svg',
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const Divider(
                          color: ColorsValue.textfildbackcolor,
                          height: 1,
                        ),
                        Wrap(
                          direction: Axis.vertical,
                          children: controller.searchList
                              .map(
                                (e) => InkWell(
                                  onTap: () {
                                    controller.selectedLocationLatLag =
                                        e.latLng;
                                    controller.moveToLocation(
                                        controller.selectedLocationLatLag!);
                                    controller.update();
                                  },
                                  child: SizedBox(
                                    width: Get.width / 1,
                                    child: Padding(
                                      padding: Dimens.edgeInsets20_20_20_0,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.thirty),
                                              color:
                                                  ColorsValue.maincoloropacity1,
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      Dimens.thirty),
                                              child: Padding(
                                                padding: Dimens.edgeInsets10,
                                                child: SvgPicture.asset(
                                                    AssetConstants
                                                        .locationicon),
                                              ),
                                            ),
                                          ),
                                          Dimens.boxWidth10,
                                          Flexible(
                                            child: Text(
                                              e.name ?? "",
                                              style: Styles.black50014,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
