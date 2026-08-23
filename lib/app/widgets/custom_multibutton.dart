import 'package:chatnest/app/theme/theme.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomBottomButton extends StatelessWidget {
  String? firstbtnText, secondbtnTxt;
  VoidCallback? firstOnPressed, secondOnPressed;
  TextStyle? firstStyle, secondStyle;
  Color? bordercolor;
  Color? buttoncolor;
  bool? ispadding = false;
  bool? isspace = false;

  CustomBottomButton(
      {super.key,
      required this.firstbtnText,
      required this.secondbtnTxt,
      required this.firstOnPressed,
      required this.secondOnPressed,
      this.buttoncolor,
      this.bordercolor,
      this.firstStyle,
      this.secondStyle,
      this.ispadding,
      this.isspace});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.only(
            left: Dimens.five,
            right: Dimens.five,
            top: Dimens.zero,
            bottom: Dimens.zero,
          ),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorsValue.whiteColor,
              fixedSize: Size(double.infinity, Dimens.fourtyFive),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.six),
                side: BorderSide(
                  width: Dimens.one,
                  color: bordercolor ?? ColorsValue.maincolor1,
                ),
              ),
            ),
            onPressed: firstOnPressed,
            child: Text(
              firstbtnText!,
              textAlign: TextAlign.center,
              style: this.firstStyle,
            ),
          ),
        ),
      ),
      isspace == true ? Dimens.box0 : Dimens.boxWidth10,
      Expanded(
        child: Padding(
          padding: ispadding == true
              ? EdgeInsets.only(left: Dimens.ten, right: Dimens.ten)
              : EdgeInsets.only(left: Dimens.zero, right: Dimens.zero),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              fixedSize: Size(double.infinity, Dimens.fourtyFive),
              backgroundColor:
                  buttoncolor == null ? ColorsValue.maincolor1 : buttoncolor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(Dimens.six),
              ),
            ),
            onPressed: secondOnPressed,
            child: Text(
              secondbtnTxt!,
              textAlign: TextAlign.center,
              
              style: this.secondStyle,
            ),
          ),
        ),
      )
    ]);
  }
}
