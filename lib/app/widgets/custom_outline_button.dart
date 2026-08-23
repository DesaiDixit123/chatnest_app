import 'package:chatnest/app/app.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomOutlineButton extends StatefulWidget {
  VoidCallback firstOnPressed;
  TextStyle firstStyle;
  String hinttext;
  CustomOutlineButton({
    super.key,
    required this.firstOnPressed,
    required this.hinttext,
    required this.firstStyle,
  });

  @override
  State<CustomOutlineButton> createState() => _CustomOutlineButtonState();
}

class _CustomOutlineButtonState extends State<CustomOutlineButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Dimens.boxWidth5,
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsValue.whiteColor,
              fixedSize: Size(double.infinity, Dimens.fourtyFive),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(
                    width: 1,
                    color: ColorsValue.maincolor1,
                  )),
            ),
            // style: ElevatedButton.styleFrom(
            //   fixedSize: Size(double.infinity, Dimens.fourtyFive),
            //   padding: Dimens.edgeInsets0,
            //   backgroundColor: ColorsValue.secondaryColor,
            //   shape: const RoundedRectangleBorder(
            //     borderRadius: BorderRadius.zero,
            //   ),
            // ),
            onPressed: widget.firstOnPressed,
            child: Text(
              widget.hinttext,
              style: widget.firstStyle,
            ),
          ),
        ),
      ],
    );
  }
}
