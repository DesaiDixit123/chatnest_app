import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class OurProductCars extends StatelessWidget {
  String? icon;
  GestureTapCallback? onTap;
  OurProductCars({this.icon, this.onTap, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          margin: EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(60)),
              boxShadow: [
                BoxShadow(
                  blurRadius: 5.0,
                  color: Colors.black.withOpacity(0.2),
                  offset: Offset(1.0, 1.0),
                ),
              ]),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
              child: SvgPicture.asset(
                "assets/images/social/${icon}.svg",
              ),
            ),
          )),
    );
  }
}
