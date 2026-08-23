import 'package:chatnest/app/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData themeData(BuildContext context) => ThemeData(
      disabledColor: ColorsValue.maincolor1,
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.transparent,
      ),
      shadowColor: const Color(0xFFDDE3FD),
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith<Color>((states) {
          if (states.contains(WidgetState.selected)) {
            return ColorsValue.appColor; // Purple for selected
          }
          return ColorsValue.white;
        }),
        side: const BorderSide(color: ColorsValue.maincolor1),
        checkColor: WidgetStateProperty.all<Color>(ColorsValue.white),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(
          color: Colors.black,
          fontFamily: 'Product Sans',
        ),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xffFFFFFF),
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
     primaryColor: ColorsValue.maincolor1,

      secondaryHeaderColor: ColorsValue.white,
      fontFamily: 'Product Sans',
      brightness: Brightness.light,
      textButtonTheme: TextButtonThemeData(
        style: ButtonStyle(
          foregroundColor:
              WidgetStateColor.resolveWith((states) => Colors.black),
          backgroundColor:
              WidgetStateColor.resolveWith((states) => Colors.transparent),
        ),
      ),
      timePickerTheme: TimePickerThemeData(
        backgroundColor: ColorsValue.whiteColor,
        dayPeriodBorderSide:
            const BorderSide(color: ColorsValue.blackColor, width: 1),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
          side: BorderSide(color: Colors.transparent, width: 1),
        ),
        dayPeriodTextColor: Colors.black,
        // dayPeriodShape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.all(Radius.circular(8)),
        //   side: BorderSide(color: Colors.purple, width: 4),
        // ),
        hourMinuteColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? ColorsValue.maincolor1
                : ColorsValue.maincoloropacity1),
        hourMinuteTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.white
                : ColorsValue.maincolor1),
        dialHandColor: ColorsValue.maincolor1,
        dialBackgroundColor: ColorsValue.maincoloropacity1,
        hourMinuteTextStyle: GoogleFonts.montserrat(
          fontSize: 57,
          fontWeight: FontWeight.bold,
          color: ColorsValue.white,
        ),
        dayPeriodTextStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ColorsValue.maincolor1,
        ),
        inputDecorationTheme: const InputDecorationTheme(
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(0),
        ),
        dialTextColor: WidgetStateColor.resolveWith((states) =>
            states.contains(WidgetState.selected)
                ? Colors.white
                : Colors.black),
        entryModeIconColor: Colors.black,
      ),
      scaffoldBackgroundColor: ColorsValue.transparent,
      colorScheme: ColorScheme.light(
        surface: ColorsValue.white,
        onPrimary: ColorsValue.white,
        secondary: ColorsValue.appColor,
        onSecondary: ColorsValue.white,
        brightness: Brightness.light,
        onSurface: ColorsValue.blackColor,
        onInverseSurface: const Color.fromRGBO(0, 0, 0, 0.12),
        primary: ColorsValue.maincolor1,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey,
        hintStyle: TextStyle(
          color: Get.theme.hintColor.withOpacity(.3),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          ),
          // borderSide: BorderSide(
          //   color: Color(0xFFEA6F00),
          //   // color: Color.fromARGB(255, 209, 209, 209),
          //   width: 1.5,
          // ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: Color(0xFFCCCCCC),
            width: 1.0,
          ),
        ),
      ),
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: ColorsValue.maincolor1),
    );

ThemeData darkThemeData(BuildContext context) => ThemeData(
      textSelectionTheme:
          const TextSelectionThemeData(cursorColor: Colors.white),
      appBarTheme: const AppBarTheme(
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Product Sans',
        ),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        actionsIconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      secondaryHeaderColor: const Color.fromRGBO(23, 166, 221, 1),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      primaryColor: const Color(0xFFF31B82),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.transparent,
      ),
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        surface: Colors.white.withOpacity(.16),
        primary: ColorsValue.maincolor1,
        secondary: ColorsValue.appColor,
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: Colors.grey,
        hintStyle: TextStyle(
          color: Get.theme.hintColor.withOpacity(.3),
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 209, 209, 209),
            width: 1.5,
          ),
        ),
        enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(255, 209, 209, 209),
            width: 1.5,
          ),
        ),
        errorBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color.fromRGBO(240, 151, 149, 1),
            width: 1.5,
          ),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(14),
          ),
          borderSide: BorderSide(
            color: Color.fromARGB(30, 27, 83, 244),
            width: 1.5,
          ),
        ),
      ),
      scaffoldBackgroundColor: Colors.black,
      fontFamily: 'Product Sans',
    );
