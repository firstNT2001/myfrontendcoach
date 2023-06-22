import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  ThemeData theme;
  ThemeData darkTheme;
  AppTheme({required this.theme, required this.darkTheme});
}

class DefaultTheme {
  AppTheme flexTheme = AppTheme(
// Theme config for FlexColorScheme version 7.1.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
theme: FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff004881),
    primaryContainer: Color(0xffd0e4ff),
    secondary: Color(0xffac3306),
    secondaryContainer: Color(0xffffdbcf),
    tertiary: Color(0xff006875),
    tertiaryContainer: Color(0xff95f0ff),
    appBarColor: Color(0xffffdbcf),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    switchSchemeColor: SchemeColor.error,
    switchThumbSchemeColor: SchemeColor.onPrimary,
    checkboxSchemeColor: SchemeColor.error,
    radioSchemeColor: SchemeColor.error,
    sliderBaseSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: false,
    fabSchemeColor: SchemeColor.error,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondaryContainer,
    bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.error,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondaryContainer,
    bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.error,
    bottomNavigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
darkTheme: FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xffa00000),
    primaryContainer: Color(0xff4d4d4d),
    secondary: Color(0xffffffff),
    secondaryContainer: Color(0xff872100),
    tertiary: Color(0xff000000),
    tertiaryContainer: Color(0xffbbf246),
    appBarColor: Color(0xff872100),
    error: Color(0xffcf6679),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    switchSchemeColor: SchemeColor.error,
    switchThumbSchemeColor: SchemeColor.onPrimary,
    checkboxSchemeColor: SchemeColor.error,
    radioSchemeColor: SchemeColor.error,
    sliderBaseSchemeColor: SchemeColor.primary,
    inputDecoratorSchemeColor: SchemeColor.primary,
    inputDecoratorIsFilled: false,
    inputDecoratorBorderSchemeColor: SchemeColor.onPrimary,
    inputDecoratorPrefixIconSchemeColor: SchemeColor.onSecondary,
    fabSchemeColor: SchemeColor.error,
    bottomNavigationBarSelectedLabelSchemeColor: SchemeColor.secondaryContainer,
    bottomNavigationBarUnselectedLabelSchemeColor: SchemeColor.error,
    bottomNavigationBarSelectedIconSchemeColor: SchemeColor.secondaryContainer,
    bottomNavigationBarUnselectedIconSchemeColor: SchemeColor.error,
    bottomNavigationBarBackgroundSchemeColor: SchemeColor.onPrimary,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,

  );
}
