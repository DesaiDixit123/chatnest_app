import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/navigators/navigators.dart';
import 'package:chatnest/data/data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class FindFriendScreen extends StatefulWidget {
  const FindFriendScreen({super.key});

  @override
  State<FindFriendScreen> createState() => _FindFriendScreenState();
}

class _FindFriendScreenState extends State<FindFriendScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<FindFriendController>(
      initState: (controller) {
        var controller = Get.find<FindFriendController>();
        // Future.delayed(Duration.zero, () async {
        //   Utility.locationPermissionCheack();
        // });
        controller.findfriendController.clear();
        controller.messageController.clear();
        controller.postFindFriendsLocation();
      },
      builder: (controller) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              controller.messageFocusNode.unfocus();
            },
            child: Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: controller.initialCameraPosition,
                  markers: controller.mapMarkers,
                  onMapCreated: (GoogleMapController mapcontroller) async {
                    controller.googleMapController.complete(mapcontroller);
                    controller.clusterManager.setMapId(mapcontroller.mapId);
                  },
                  onCameraMove: (position) {
                    controller.clusterManager.onCameraMove(position);
                  },
                  onCameraIdle: controller.clusterManager.updateMap,
                  myLocationButtonEnabled: false,
                  myLocationEnabled: false,
                ),
                Padding(
                  padding: Dimens.edgeInsets20,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: GetBuilder<FindFriendController>(
                            id: 'Harshil',
                            builder: (contexts) {
                              return SizedBox(
                                height: Dimens.fourtyFive,
                                child: GooglePlaceAutoCompleteTextField(
                                  focusNode: controller.messageFocusNode,
                                  seperatedBuilder: const SizedBox(),
                                  textEditingController:
                                      controller.findfriendController,
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
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                    ),
                                    disabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
                                    ),
                                    focusedErrorBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: Dimens.zero,
                                        style: BorderStyle.none,
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(Dimens.five),
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
                                        width: Dimens.zero,
                                        color: ColorsValue.transparent),
                                    borderRadius: BorderRadius.circular(
                                      Dimens.five,
                                    ),
                                  ),
                                  debounceTime: 1000,
                                  isLatLngRequired: true,
                                  itemClick: (postalCodeResponse) {
                                    // controller.moveToLocation(LatLng(
                                    //     double.parse(postalCodeResponse.lat!),
                                    //     double.parse(postalCodeResponse.lng!)));
                                    // controller.update();
                                  },
                                  getPlaceDetailWithLatLng:
                                      (postalCodeResponse) async {
                                    controller.messageFocusNode.unfocus();
                                    controller.selectedLocationLatLag = LatLng(
                                        double.parse(postalCodeResponse.lat!),
                                        double.parse(postalCodeResponse.lng!));

                                    // controller.onMapCreated;

                                    controller.googleMapController.future
                                        .then((value) {
                                      value.animateCamera(
                                        CameraUpdate.newCameraPosition(
                                          CameraPosition(
                                            target: controller
                                                    .selectedLocationLatLag ??
                                                const LatLng(
                                                    21.170240, 72.831062),
                                            zoom: 15.0,
                                          ),
                                        ),
                                      );
                                    });

                                    await controller.postFindFriendsLocation();
                                  },
                                  itemBuilder:
                                      (context, index, Prediction prediction) {
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
                              );
                            }),
                      ),
                      Padding(
                        padding: Dimens.edgeInsetsLeft10,
                        child: Container(
                          height: Dimens.fourtyFive,
                          decoration: BoxDecoration(
                            color: ColorsValue.maincolor1,
                            borderRadius: BorderRadius.circular(Dimens.five),
                          ),
                          child: Padding(
                            padding: Dimens.edgeInsets10,
                            child: InkWell(
                              onTap: () {
                                RouteManagement
                                    .goTofindFriendrequasthistoryScreen();
                              },
                              child: SvgPicture.asset(
                                AssetConstants.findFriendFilter,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          // body: controller.customMarkers.length > 0
          //     ? Stack(
          //         children: [
          //           CustomGoogleMapMarkerBuilder(
          //             customMarkers: controller.customMarkers,
          //             builder: (BuildContext context, Set<Marker>? markers) {
          //               if (markers == null) {
          //                 return Center(
          //                   child: SizedBox(
          //                     height: Dimens.sixty,
          //                     width: Dimens.sixty,
          //                     child: CircularProgressIndicator(
          //                       color: Colors.black,
          //                     ),
          //                   ),
          //                 );
          //               }
          //               return GoogleMap(
          //                 initialCameraPosition: CameraPosition(
          //                   target: controller.selectedLocationLatLag ??
          //                       const LatLng(
          //                         21.170240,
          //                         72.831062,
          //                       ),
          //                   zoom: 14,
          //                 ),
          //                 zoomGesturesEnabled: true,
          //                 zoomControlsEnabled: true,
          //                 tiltGesturesEnabled: false,
          //                 myLocationEnabled: true,
          //                 mapToolbarEnabled: false,
          //                 compassEnabled: false,
          //                 myLocationButtonEnabled: false,
          //                 mapType: MapType.hybrid,
          //                 markers: markers,
          //                 onMapCreated: controller.onMapCreated,
          //               );
          //             },
          //           ),
          // Padding(
          //   padding: Dimens.edgeInsets20,
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       Expanded(
          //         child: GetBuilder<FindFriendController>(
          //             id: 'Harshil',
          //             builder: (context) {
          //               return SizedBox(
          //                 height: Dimens.fourtyFive,
          //                 child: GooglePlaceAutoCompleteTextField(
          //                   seperatedBuilder: const SizedBox(),
          //                   textEditingController:
          //                       controller.findfriendController,
          //                   googleAPIKey: ApiWrapper.placeApiCall,
          //                   inputDecoration: InputDecoration(
          //                     suffixIcon: Icon(
          //                       Icons.search,
          //                       size: Dimens.twentyFour,
          //                       color:
          //                           ColorsValue.hookupHeaderGreyColor,
          //                     ),
          //                     counterText: '',
          //                     contentPadding: Dimens.edgeInsets10,
          //                     focusedBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         width: Dimens.zero,
          //                         style: BorderStyle.none,
          //                       ),
          //                       borderRadius: BorderRadius.circular(
          //                           Dimens.five),
          //                     ),
          //                     disabledBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         width: Dimens.zero,
          //                         style: BorderStyle.none,
          //                       ),
          //                       borderRadius: BorderRadius.circular(
          //                           Dimens.five),
          //                     ),
          //                     enabledBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         width: Dimens.zero,
          //                         style: BorderStyle.none,
          //                       ),
          //                       borderRadius: BorderRadius.circular(
          //                           Dimens.five),
          //                     ),
          //                     focusedErrorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         width: Dimens.zero,
          //                         style: BorderStyle.none,
          //                       ),
          //                       borderRadius: BorderRadius.circular(
          //                           Dimens.five),
          //                     ),
          //                     fillColor:
          //                         ColorsValue.textfildbackcolor,
          //                     filled: true,
          //                     errorBorder: OutlineInputBorder(
          //                       borderSide: BorderSide(
          //                         width: Dimens.zero,
          //                         style: BorderStyle.none,
          //                       ),
          //                       borderRadius: BorderRadius.circular(
          //                         Dimens.five,
          //                       ),
          //                     ),
          //                     border: InputBorder.none,
          //                     hintText: 'search'.tr,
          //                     hintStyle: Styles.greyAAA40014,
          //                     isCollapsed: false,
          //                   ),
          //                   boxDecoration: BoxDecoration(
          //                     shape: BoxShape.rectangle,
          //                     border: Border.all(
          //                         width: Dimens.zero,
          //                         color: ColorsValue.transparent),
          //                     borderRadius: BorderRadius.circular(
          //                       Dimens.five,
          //                     ),
          //                   ),
          //                   debounceTime: 1000,
          //                   isLatLngRequired: true,
          //                   itemClick: (postalCodeResponse) {},
          //                   getPlaceDetailWithLatLng:
          //                       (postalCodeResponse) async {
          //                     controller.selectedLocationLatLag =
          //                         LatLng(
          //                             double.parse(
          //                                 postalCodeResponse.lat!),
          //                             double.parse(
          //                                 postalCodeResponse.lng!));
          //                     controller.update();
          //                     await controller
          //                         .postFindFriendsLocation();
          //                   },
          //                   itemBuilder: (context, index,
          //                       Prediction prediction) {
          //                     return Container(
          //                       color: ColorsValue.textfildbackcolor,
          //                       padding: Dimens.edgeInsets10,
          //                       child: Row(
          //                         children: [
          //                           const Icon(
          //                             Icons.location_on,
          //                           ),
          //                           Dimens.boxWidth7,
          //                           Expanded(
          //                             child: Text(
          //                               prediction.description ?? "-",
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     );
          //                   },
          //                   isCrossBtnShown: false,
          //                 ),
          //               );
          //             }),
          //       ),
          //       Padding(
          //         padding: Dimens.edgeInsetsLeft10,
          //         child: Container(
          //           height: Dimens.fourtyFive,
          //           decoration: BoxDecoration(
          //             color: ColorsValue.maincolor1,
          //             borderRadius:
          //                 BorderRadius.circular(Dimens.five),
          //           ),
          //           child: Padding(
          //             padding: Dimens.edgeInsets10,
          //             child: InkWell(
          //               onTap: () {
          //                 RouteManagement
          //                     .goTofindFriendrequasthistoryScreen();
          //               },
          //               child: SvgPicture.asset(
          //                 AssetConstants.findFriendFilter,
          //               ),
          //             ),
          //           ),
          //         ),
          //       )
          //     ],
          //   ),
          // ),
          //         ],
          //       )
          //     : Center(
          //         child: SizedBox(
          //           height: Dimens.sixty,
          //           width: Dimens.sixty,
          //           child: const CircularProgressIndicator(
          //             color: Colors.black,
          //           ),
          //         ),
          //       ),
        );
      },
    );
  }
}
