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
// Theme config for FlexColorScheme version 7.2.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
theme: FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xffff6000),
    primaryContainer: Color(0xffffddc9),
    secondary: Color(0xffffee00),
    secondaryContainer: Color(0xffffb77d),
    tertiary: Color(0xff454545),
    tertiaryContainer: Color(0xff95f0ff),
    appBarColor: Color(0xffffb77d),
    error: Color(0xffb00020),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    inputDecoratorBackgroundAlpha: 16,
    inputDecoratorBorderSchemeColor: SchemeColor.onBackground,
    inputDecoratorRadius: 33.0,
    inputDecoratorFocusedBorderWidth: 1.0,
    cardRadius: 20.0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
darkTheme: FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff9fc9ff),
    primaryContainer: Color(0xff00325b),
    secondary: Color(0xffffb59d),
    secondaryContainer: Color(0xff872100),
    tertiary: Color(0xff86d2e1),
    tertiaryContainer: Color(0xff004e59),
    appBarColor: Color(0xff872100),
    error: Color(0xffcf6679),
  ),
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    inputDecoratorRadius: 33.0,
    inputDecoratorFocusedBorderWidth: 1.0,
    cardRadius: 20.0,
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,


  );
}
