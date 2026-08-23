import 'dart:async';

import 'package:chatnest/app/app.dart';
import 'package:chatnest/domain/models/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// ignore: must_be_immutable
class ShareCurrentLocation extends StatefulWidget {
  ShareCurrentLocation({
    super.key,
    required this.isSeen,
    required this.isDelivered,
    required this.time,
    required this.isSend,
    required this.businessProfileLatLag,
    required this.onTap,
    required this.isBookmark,
    required this.isFavorites,
    required this.emoji,
    required this.onEmojiRemove,
    this.isBrodcast = false,
    this.isSeenStatus = true,
  });
  final bool isSeen;
  final String time;
  final bool isSend;
  final bool isDelivered;
  final bool isBrodcast;
  LatLng? businessProfileLatLag;
  Function(LatLng)? onTap;
  final bool isBookmark;
  final bool isFavorites;
  final bool isSeenStatus;
  final List<ChatReaction> emoji;
  Function()? onEmojiRemove;

  @override
  State<ShareCurrentLocation> createState() => _ShareCurrentLocationState();
}

class _ShareCurrentLocationState extends State<ShareCurrentLocation> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: widget.isSend ? 2 : 0,
          child: const SizedBox(),
        ),
        Padding(
          padding: Dimens.edgeInsetsBottom10,
          child: Column(
            crossAxisAlignment: widget.isSend
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.start,
            mainAxisAlignment:
                widget.isSend ? MainAxisAlignment.end : MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: Dimens.edgeInsets10_10_10_0,
                decoration: BoxDecoration(
                  color: widget.isSend
                      ? ColorsValue.lightmainColor
                      : ColorsValue.textfildbackcolor,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(Dimens.five),
                      bottomRight: Radius.circular(Dimens.five),
                      topRight: widget.isSend
                          ? Radius.zero
                          : Radius.circular(Dimens.five),
                      topLeft: widget.isSend
                          ? Radius.circular(Dimens.five)
                          : Radius.zero),
                ),
                width: Dimens.twoHundredFifty,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: Dimens.hundredFifty,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          Dimens.five,
                        ),
                        border: Border.all(
                          color: ColorsValue.greyAAAAAA,
                          width: Dimens.one,
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
                          mapType: MapType.hybrid,
                          buildingsEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: widget.businessProfileLatLag ??
                                const LatLng(21.170240, 72.831062),
                            zoom: 14,
                          ),
                          onMapCreated: onMapCreated,
                          markers: locationMarker,
                          onTap: widget.onTap,
                        ),
                      ),
                    ),
                    Dimens.boxHeight5,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        if (widget.isSend && widget.isBrodcast) ...[
                          SvgPicture.asset(
                            AssetConstants.ic_outline_brodcast,
                          )
                        ],
                        Dimens.boxWidth5,
                        Text(
                          widget.time,
                          style: Styles.greyColor888840012,
                        ),
                        if (widget.isSeenStatus) ...[
                          Dimens.boxWidth5,
                          widget.isSend
                              ? SvgPicture.asset(
                                  widget.isSeen
                                      ? AssetConstants.seenIcon
                                      : widget.isDelivered
                                          ? AssetConstants.deliveredIcon
                                          : AssetConstants.unseenIcon,
                                )
                              : Dimens.box0
                        ]
                      ],
                    ),
                    Dimens.boxHeight5,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.emoji.isNotEmpty) ...[
                          InkWell(
                            onTap: widget.onEmojiRemove,
                            child: Container(
                              height: Dimens.twentyFour,
                              width: Dimens.twentyFour,
                              decoration: BoxDecoration(
                                color: ColorsValue.white,
                                borderRadius: BorderRadius.circular(
                                  Dimens.hundred,
                                ),
                                border: Border.all(
                                  width: Dimens.one,
                                  color: ColorsValue.maincolor1,
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  widget.emoji[0].reaction ?? "",
                                  style: Styles.black40014,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                        Dimens.boxWidth3,
                        Visibility(
                          visible: widget.isBookmark,
                          child: Container(
                            height: Dimens.twentyFour,
                            width: Dimens.twentyFour,
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              border: Border.all(
                                width: Dimens.one,
                                color: ColorsValue.maincolor1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.bookmark,
                                size: Dimens.fifteen,
                                color: ColorsValue.blackColor,
                              ),
                            ),
                          ),
                        ),
                        Dimens.boxWidth3,
                        Visibility(
                          visible: widget.isFavorites,
                          child: Container(
                            height: Dimens.twentyFour,
                            width: Dimens.twentyFour,
                            decoration: BoxDecoration(
                              color: ColorsValue.white,
                              borderRadius: BorderRadius.circular(
                                Dimens.hundred,
                              ),
                              border: Border.all(
                                width: Dimens.one,
                                color: ColorsValue.maincolor1,
                              ),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.star,
                                size: Dimens.fifteen,
                                color: ColorsValue.blackColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Dimens.boxHeight5,
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  final Set<Marker> locationMarker = {};

  final Completer<GoogleMapController> mapController = Completer();

  void onMapCreated(GoogleMapController controller) {
    if (!mapController.isCompleted) {
      mapController.complete(controller);
    }
    moveToLocation(
      widget.businessProfileLatLag ?? const LatLng(21.170240, 72.831062),
    );
  }

  void moveToLocation(LatLng latLng) {
    mapController.future.then((controller) {
      controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: 15.0,
          ),
        ),
      );
    });
    setMarker(latLng);

    // getLocationData(
    //     lat: latLng.latitude, lng: latLng.longitude, isForNavigator: false);
  }

  void setMarker(LatLng latLng) {
    locationMarker.clear();
    locationMarker.add(
      Marker(
        markerId: const MarkerId("mark"),
        position: latLng,
      ),
    );
    setState(() {});
  }
}
