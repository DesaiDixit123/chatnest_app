// coverage:ignore-file
import 'package:flutter/material.dart';

/// A list of custom color used in the application.
///
/// Will be ignored for test since all are static values and would not change.
abstract class ColorsValue {
  static const maincolor1 = Color(0xFF34D058);   // Green from logo
  static Color appColor = const Color(0xFF7B61FF); // Purple from logo
  static const maincoloropacity1 = Color(0xFFEBFBF0); // soft green bg
  static const lightmainColor = Color(0xFFF1FDF5); // very light background
  static const int maincolor = 0xff34D058;
  static const int maincoloropacity = 0xffEBFBF0;
  static const int lightmaincolor = 0xffF1FDF5;

  /// Colors
  static Color primaryColor = const Color(
    primaryColorHex,
  );
  static Color lightPrimaryColor = const Color(lightPrimary).withOpacity(.1);

  static Color secondaryColor = Color(
    secondaryColorHex,
  );
  static Color instagramAddIconsColor = const Color(
    instagramAddIconsColorHex,
  );
  static Color bottomSheetLightBackground = const Color(
    bottomSheetLightBackgroundHex,
  );

  static const Color blackColor = Color(
    blackColorHex,
  );
  static const Color lightGreyCancelButtonColor = Color(
    greyColorHex,
  );
  static const Color hookupHeaderBlackColor = Color(
    hookupHeaderBlackColorHex,
  );
  static const Color hookupHeaderGreyColor = Color(
    hookupHeaderGreyColorHex,
  );
  static const Color hookupSubHeaderGreyColor = Color(
    hookupSubHeaderGreyColorHex,
  );
  static const Color hookupSubHeaderLightBlackColor = Color(
    lightBlackColorHex,
  );
  static const Color hookupTermsWhiteColor = Color(
    hookupTermsWhiteColorHex,
  );
  static const Color hookupBorderGreyColor = Color(
    hookupBorderGreyColorHex,
  );

  static const Color whiteColor = Color(
    whiteColorHex,
  );

  static const Color white = Color(
    textcolor1,
  );

  static const Color greenColor = Color(
    greenColorHex,
  );

  static const Color redColor = Color(
    redColorHex,
  );
  static const Color greyFillColor = Color(
    greyFillColorHex,
  );

  static const Color redColorDark = Color(
    redColorDarkHex,
  );

  static const Color hookupOrangeColor = Color(
    hookupOrangeColorHex,
  );
  static const Color hookupOrangeSelectedColor = Color(
    hookupOrangeSelectedColorHex,
  );

  static const Color blueColor = Color(
    blueColorHex,
  );

  // static const Color bluedarkColor = Color(
  //     bluedarkColorHex
  // );

  static const Color skyBlueColor = Color(
    skyBlueColorHex,
  );

  static const Color greyColor = Color(
    greyColorHex,
  );

  static const Color greyDividerColor = Color(lightGreyDividerColorHex);

  static const Color lightGreyTextColor = Color(lightGreyTextColorHex);

  static const Color transparent = Colors.transparent;

  // ============================================

  /// Non-common Colors
  ///
  static const Color facebookButtonColor = Color(
    facebookButtonColorHex,
  );

  static const Color iconColor = Color(
    iconColorHex,
  );

  static const Color greyLightColor = Color(
    greyLightColorHex,
  );

  static const Color purpleColor = Color(
    purpleColorHex,
  );

  static const Color lightGreyColorWithOpacity35 = Color(
    lightGreyColorWithOpacityHex35,
  );

  static const Color lightGreyColor = Color(
    lightGreyColorHex,
  );

  static const Color heavyGreyColor = Color(
    heavyGreyColorHex,
  );

  static const Color lightGreyColorWithOpacity50 = Color(
    lightGreyColorWithOpacityHex50,
  );

  static const Color lightRedColor = Color(
    lightRedColorHex,
  );

  static const Color blackColorWithOpacity59 = Color(
    blackColorHexWithOpacity59,
  );

  static const Color primaryColorWithOpacity = Color(
    primaryColorHexWithOpacity,
  );

  static const Color subTitleColor = Color(
    subTitlecolorHex,
  );

  static const Color originalGreyColor = Color(
    originalGreyColorHex,
  );

  static const Color textfieldHintColor = Color(
    textfieldHintColorHex,
  );

  static const Color bottomNavBgColor = Color(
    bottomNavBgColorHex,
  );

  static const Color blueMediumColor = Color(
    blueMediumColorHex,
  );

  static const Color blueDarkColor = Color(
    darkBlueColorHex,
  );

  static const Color lightBlueColor = Color(
    lightBlueColorHex,
  );

  static const Color lightBlueishColor = Color(
    lightBlueishColorHex,
  );

  static const Color lightGreenColor = Color(
    lightGreenColorHex,
  );

  static const Color yellowColor = Color(
    yellowColorHex,
  );

  static const Color greyLightColo = Color(greyLightColoHex);

  static const Color loginPlaceholderFontColor = Color(
    loginPlaceholderFontColorHex,
  );

  static const Color pinkColor = Color(
    pinkColorHex,
  );

  static const Color greyBorderColor = Color(
    greyBorderColorHex,
  );

  static const Color shadowColor = Color(
    shadowColorHex,
  );

  static const Color checkBoxColor = Color(
    checkBoxColorHex,
  );

  static const greySvgColor = Color(
    greySvgColorHex,
  );

  static const tabBarUnselectedColor = Color(
    tabBarUnselectedColorHex,
  );

  static const reelsGiftButtonBlackColor = Color(
    reelsGiftButtonBlackColorHex,
  );

  static const reelsGiftButtonInnerBorderColor = Color(
    reelsGiftButtonInnerBorderColorHex,
  );

  static const dialogDividerColor = Color(
    dialogDividerColorHex,
  );

  static const reddishOrangeColor = Color(
    reddishOrangeColorHex,
  );

  static const withopacitymaincolor1 = Color(withopacitymaincolor);
  static const blackcolor = Color(black);
  static const textfild = Color(textfildcolor);
  static const greyColorEEEE = Color(greyColorEEEEHex);
  static const greyColor4444 = Color(greyColor4444Hex);
  static const giftBackgroundColor = Color(giftBackgroundColorHex);
  static const greyColor9195A8 = Color(greyColor9195A8Hex);
 
  static const color2E363F = Color(0xff2E363F);
  static const text = Color(textcolo);
  static const grey = Color(greycolor);
  static const darkgrey = Color(darkgrey1);
  static const textfildbackcolor = Color(textfildback);


  // ===========================================================================

  /// Tirth Kevadiya Hex Values

  static const int withopacitymaincolor = 0xffDFFDFF;
  static const int textcolo = 0xff9BA0A8;
  static const int black = 0xff242427;
  static const int textfildcolor = 0xffEEEEEE;
  static const int greycolor = 0xffD9D9D9;
  static const int textfildback = 0xffF1F1F1;
  static const int darkgrey1 = 0xffE8E8E8;


  // ===========================================================================

  /// Hex Values
  ///
  static const int primaryColorHex = 0xff34D058;
  static int secondaryColorHex = 0xff7B61FF;
  static const int blackColorHex = 0xff000000;
  static const int greyColorHex = 0xFFF8F8F8;
  static const int hookupHeaderBlackColorHex = 0xFF0A0A0A;
  static const int hookupHeaderGreyColorHex = 0xFFAAAAAA;
  static const int hookupSubHeaderGreyColorHex = 0xFF828282;
  static const int hookupTermsWhiteColorHex = 0xFFBABABA;
  static const int hookupBorderGreyColorHex = 0xFFCCCCCC;
  static const int whiteColorHex = 0xffffffff;
  static const int greenColorHex = 0xff009944;
  static const int redColorHex = 0xffFC5858;
  static const int greyFillColorHex = 0xffEEEEEE;
  static const int hookupOrangeColorHex = 0xFFEA6F00;
  static const int hookupOrangeSelectedColorHex = 0x1AEA6F00;
  static const int textcolor1 = 0xffFFFFFF;
  static const int blueColorHex = 0xff2196f3;
  static const int darkBlueColorHex = 0xff1B53F4;
  static const int skyBlueColorHex = 0xff63c0df;
  static const int blueMediumColorHex = 0xffd9e5f6;
  static const int lightBlueColorHex = 0xffd1ddfd;
  static const int lightGreenColorHex = 0xff00D215;
  static const int yellowColorHex = 0xfffedf5c;
  static const int lightBlackColorHex = 0xff040414;
  static const int facebookButtonColorHex = 0xff3B5998;
  static const int iconColorHex = 0xff606060;
  static const int greyLightColorHex = 0xff1C1C1C;
  static const int purpleColorHex = 0xffB000F0;
  static const int lightGreyColorWithOpacityHex35 = 0x59C9CCD1;
  static const int lightGreyColorHex = 0xffC9CCD1;
  static const int heavyGreyColorHex = 0xff666666;
  static const int lightGreyColorWithOpacityHex50 = 0x80C9CCD1;
  static const int lightRedColorHex = 0xffFF4A49;
  static const int blackColorHexWithOpacity59 = 0x59000000;
  static const int primaryColorHexWithOpacity = 0x596730EC;
  static const int subTitlecolorHex = 0xfe666666;
  static const int originalGreyColorHex = 0xff535353;
  static const int textfieldHintColorHex = 0xffBFBFBF;
  static const int bottomNavBgColorHex = 0xff171717;
  static const int loginPlaceholderFontColorHex = 0xffD4D5D7;
  static const int lightGreyDividerColorHex = 0xffF6F6F6;
  static const int lightGreyTextColorHex = 0xff808080;
  static const int pinkColorHex = 0xffF31B82;
  static const int greyBorderColorHex = 0xffF2F2F2;
  static const int greyLightColoHex = 0xffCFCFCF;
  static const int redColorDarkHex = 0xffEB5757;
  static const int lightBlueishColorHex = 0xffEFF3FB;
  static const int shadowColorHex = 0xffDDE3F8;
  static const int checkBoxColorHex = 0xffD4D7D9;
  static const int lightPrimary = 0xffEA6F00;
  static const int bottomSheetLightBackgroundHex = 0xffFDF1E6;
  static const int instagramAddIconsColorHex = 0xffCECECE;
  static const int greySvgColorHex = 0xff9CA4B7;
  static const int tabBarUnselectedColorHex = 0xffCC9C9C9;
  static const int reelsGiftButtonBlackColorHex = 0xff302222;
  static const int reelsGiftButtonInnerBorderColorHex = 0xffFBA23B;
  static const int dialogDividerColorHex = 0xffE1E1E1;
  static const int greyColor8888Hex = 0xff888888;
  static const int greyColorEEEEHex = 0xffEEEEEE;
  static const int greyColor4444Hex = 0xff444444;
  static const int giftBackgroundColorHex = 0xffE2E2E2;
  static const int greyColor9195A8Hex = 0xff9195A8;
  static const int reddishOrangeColorHex = 0x1AFF4C00;

  static Color greyAAAAAA = const Color(0xffAAAAAA);
  static Color grey9BA6A8 = const Color(0xff9BA6A8);
  static Color greyColor8888 = const Color(0xff888888);
  static Color greyColorC1C4D6 = const Color(0xffC1C4D6);
  static Color darkblack = const Color(0xff212121);
  static Color whiteF1F1 = const Color(0xffF1F1F1);
  static Color greyE4E4E4 = const Color(0xffE4E4E4);
  static Color greyD0D7D8 = const Color(0xffD0D7D8);
  static Color lightGreen = Color.fromARGB(255, 25, 225, 21);
}
