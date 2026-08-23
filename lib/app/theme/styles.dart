//coverage:ignore-file
import 'package:chatnest/app/theme/theme.dart';
import 'package:chatnest/app/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// A chunk of styles used in the application.
/// Will be ignored for test since all are static values and would not change.
abstract class Styles {
  static String? fontFamily = globalVariable == 1 ? 'Product-Sans' : 'Avenir';

  static TextStyle hookupHeaderBlackBold30 = GoogleFonts.roboto(
    color: ColorsValue.hookupHeaderBlackColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.thirty,
  );

  static TextStyle blackBold16 = GoogleFonts.roboto(
    color: const Color(0xFF0A0A0A),
    fontWeight: FontWeight.bold,
    fontSize: Dimens.sixteen,
  );

  static TextStyle black12 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.twelve,
  );

  static TextStyle black60032 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.thirtyTwo,
    fontWeight: FontWeight.w600,
  );

  static TextStyle black60030 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.thirty,
    fontWeight: FontWeight.w600,
  );

  static TextStyle black60014 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w600,
  );

  static TextStyle black60026 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.twentySix,
    fontWeight: FontWeight.w600,
  );

  static TextStyle white60014 = GoogleFonts.roboto(
    color: ColorsValue.white,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w600,
  );

  static TextStyle blackBold12 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.twelve,
  );

  static TextStyle white14 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontSize: Dimens.fourteen,
  );

  static TextStyle white23 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontSize: Dimens.twentyThree,
  );

  static TextStyle main70030 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.thirty,
  );

  static TextStyle mainUnderline40016 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
    decoration: TextDecoration.underline,
    decorationColor: ColorsValue.maincolor1,
  );

  static TextStyle mainUnderline40014 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
    decoration: TextDecoration.underline,
    decorationColor: ColorsValue.maincolor1,
  );

  static TextStyle main70012 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twelve,
  );

  static TextStyle main70016 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.sixteen,
  );

  static TextStyle main70014 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fourteen,
  );

  static TextStyle black70024 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twentyFour,
  );

  static TextStyle black70020 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twenty,
  );

  static TextStyle black70014 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fourteen,
  );

  static TextStyle black70018 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.eighteen,
  );

  static TextStyle black70016 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.sixteen,
  );

  static TextStyle hinttext40014 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle hinttext50014 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle bold14 = GoogleFonts.roboto(
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.bold,
    color: ColorsValue.text,
  );

  static TextStyle whitebold18 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontSize: Dimens.eighteen,
    fontWeight: FontWeight.bold,
  );

  static TextStyle boldfont = GoogleFonts.roboto(
    fontWeight: FontWeight.bold,
    fontSize: Dimens.thirty,
  );

  static TextStyle blackbold14 = GoogleFonts.roboto(
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.bold,
    color: ColorsValue.color2E363F,
  );

  static TextStyle boldunderline14 = GoogleFonts.roboto(
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  static TextStyle black40016 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.sixteen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle black50012 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w500,
  );

  static TextStyle black50014 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w500,
  );

  static TextStyle black50016 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.sixteen,
    fontWeight: FontWeight.w500,
  );

  static TextStyle black50018 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.eighteen,
    fontWeight: FontWeight.w500,
  );

  static TextStyle black50020 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.twenty,
    fontWeight: FontWeight.w500,
  );

  static TextStyle main40016 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontSize: Dimens.sixteen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle main40012 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w400,
  );

  static TextStyle main60012 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w600,
  );

  static TextStyle main60014 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w600,
  );

  static TextStyle redColor60014 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w600,
  );

  static TextStyle main40014 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle whiteBold18 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.bold,
    fontSize: Dimens.eighteen,
  );

  static TextStyle main50014 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle main50012 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );

  static TextStyle main50016 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.sixteen,
  );

  static TextStyle main50018 = GoogleFonts.roboto(
    color: ColorsValue.maincolor1,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.eighteen,
  );

  static TextStyle white50014 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle white50018 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.eighteen,
  );

  static TextStyle white50012 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );

  static TextStyle white40012 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle white40014 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle white50016 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.sixteen,
  );

  static TextStyle greyAAA40014 = GoogleFonts.roboto(
    color: ColorsValue.greyAAAAAA,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle greyAAA40012 = GoogleFonts.roboto(
    color: ColorsValue.greyAAAAAA,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle darkblack60022 = GoogleFonts.roboto(
    color: ColorsValue.darkblack,
    fontWeight: FontWeight.w600,
    fontSize: Dimens.twentyTwo,
  );

  static TextStyle textfildback40016 = GoogleFonts.roboto(
    color: ColorsValue.textfildbackcolor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
  );

  static TextStyle grey9BA70014 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.fourteen,
  );

  static TextStyle grey9BA70018 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.eighteen,
  );

  static TextStyle grey9BA70012 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twelve,
  );

  static TextStyle grey9BA40012 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle grey9BA40014 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle white70010 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.ten,
  );

  static TextStyle white70018 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.eighteen,
  );

  static TextStyle white70024 = GoogleFonts.roboto(
    color: ColorsValue.whiteColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.twentyFour,
  );

  static TextStyle greyColor888840014 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle greyColor888870016 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.sixteen,
  );

  static TextStyle greyColor888840012 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle greyColor888850012 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );

  static TextStyle redcolor50012 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.twelve,
  );

  static TextStyle redcolor50014 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle redcolor50016 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.sixteen,
  );

  static TextStyle greyColor888850014 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle greyColor888850016 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.sixteen,
  );

  static TextStyle greyColor888840016 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
  );

  static TextStyle hookup50014 = GoogleFonts.roboto(
    color: ColorsValue.hookupHeaderGreyColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle hookup40010 = GoogleFonts.roboto(
    color: ColorsValue.hookupHeaderGreyColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.ten,
  );

  static TextStyle hookup40014 = GoogleFonts.roboto(
    color: ColorsValue.hookupHeaderGreyColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle hookup40012 = GoogleFonts.roboto(
    color: ColorsValue.hookupHeaderGreyColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle blackunderline50014 = GoogleFonts.roboto(
    color: ColorsValue.transparent,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    decorationColor: ColorsValue.blackcolor,
    shadows: [Shadow(offset: Offset(0, -4), color: ColorsValue.blackColor)],
  );

  static TextStyle greyunderline50014 = GoogleFonts.roboto(
    color: ColorsValue.transparent,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w500,
    decoration: TextDecoration.underline,
    decorationColor: Color(0xff919193),
    shadows: [
      Shadow(offset: Offset(0, -4), color: Color(0xff919193)),
    ],
  );
  static TextStyle black40014 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle black40012 = GoogleFonts.roboto(
    color: ColorsValue.blackcolor,
    fontSize: Dimens.twelve,
    fontWeight: FontWeight.w400,
  );

  static TextStyle blackColor40014 = GoogleFonts.roboto(
    color: ColorsValue.blackColor,
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w400,
  );

  static TextStyle greyAAA40010 = GoogleFonts.roboto(
    color: ColorsValue.grey9BA6A8,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.ten,
  );

  static TextStyle errorStyle = GoogleFonts.roboto(
    fontSize: Dimens.fourteen,
    fontWeight: FontWeight.w400,
    color: ColorsValue.redColor,
  );

  static var outlineBorderEnableRadius8 = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.eight,
      ),
    ),
    borderSide: BorderSide(color: ColorsValue.primaryColor, width: 1.0),
  );

  static var outlineBorderRadius8 = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.eight,
      ),
    ),
    borderSide: const BorderSide(color: ColorsValue.greenColor, width: 1.0),
  );

  static var errorBorderRadius8 = OutlineInputBorder(
    gapPadding: 0,
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.eight,
      ),
    ),
    borderSide: const BorderSide(color: ColorsValue.redColor, width: 1.0),
  );

  static var outlineBorderEnableRadius10 = OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(
        Dimens.ten,
      ),
    ),
    borderSide: BorderSide(
      color: ColorsValue.primaryColor,
    ),
  );
  static TextStyle redColor40010 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.ten,
  );
  static TextStyle redColor40014 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.fourteen,
  );

  static TextStyle redColor40012 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.twelve,
  );

  static TextStyle redColor50014 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w500,
    fontSize: Dimens.fourteen,
  );

  static TextStyle whiteF1F140016 = GoogleFonts.roboto(
    color: ColorsValue.whiteF1F1,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.sixteen,
  );

  static TextStyle redcolor70016 = GoogleFonts.roboto(
    color: ColorsValue.redColor,
    fontWeight: FontWeight.w700,
    fontSize: Dimens.sixteen,
  );

  static TextStyle greyColor888840010 = GoogleFonts.roboto(
    color: ColorsValue.greyColor8888,
    fontWeight: FontWeight.w400,
    fontSize: Dimens.ten,
  );
}
