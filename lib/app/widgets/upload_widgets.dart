import 'package:dotted_border/dotted_border.dart';
import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class UploadWidgets extends StatelessWidget {
  final String txt;
  final String? svgPicture;
  Color bgColor;
  double height;
  GestureTapCallback onTap;
  UploadWidgets(
      {Key? key,
      required this.txt,
      required this.height,
      required this.onTap,
      required this.bgColor,
      this.svgPicture})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: bgColor, borderRadius: BorderRadius.circular(Dimens.five)),
      child: InkWell(
        onTap: onTap,
        child: DottedBorder(
          color: ColorsValue.text,
          radius: Radius.circular(Dimens.five),
          borderType: BorderType.RRect,
          strokeWidth: Dimens.two,
          dashPattern: [Dimens.two],
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // SvgPicture.asset(svgPicture ?? ""),
              Dimens.boxWidth10,
              Center(
                child: Text(
                  txt,
                  style: Styles.grey9BA70014,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
