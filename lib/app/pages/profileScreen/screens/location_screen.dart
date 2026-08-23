import 'package:chatnest/app/app.dart';
import 'package:chatnest/app/pages/pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationScreen extends StatelessWidget {
  const LocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (controller) {
      return Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target:
                    controller.locationLatlag ?? LatLng(21.170240, 72.831062),
                zoom: 14,
              ),
              onTap: (LatLng latLng) {
                controller.businessProfileLatLag = latLng;
                controller.profileLatLag = latLng;
                controller.locationLatlag = latLng;
                Marker(
                  markerId: MarkerId('mark'),
                  position: latLng,
                );
                controller.getPlacemarks(latLng.latitude, latLng.longitude);
                controller.update();
              },
              markers: {
                Marker(
                  markerId: const MarkerId("mark"),
                  position: controller.locationLatlag ??
                      const LatLng(21.170240, 72.831062),
                  draggable: true,
                  onDragEnd: (value) {
                    print(value);
                  },
                ),
              },
            ),
            Padding(
              padding: Dimens.edgeInsets20_50_20_0,
              child: InkWell(
                onTap: () {
                  Get.back();
                },
                child: SvgPicture.asset(
                  AssetConstants.appbarbackarrowicon,
                  colorFilter: const ColorFilter.mode(
                    ColorsValue.blackColor,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}
