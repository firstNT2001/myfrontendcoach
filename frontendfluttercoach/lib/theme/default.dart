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

// Light and dark ColorSchemes made by FlexColorScheme v7.1.2.
// These ColorScheme objects require Flutter 3.7 or later.
const ColorScheme flexSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff004881),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffd0e4ff),
  onPrimaryContainer: Color(0xff111314),
  secondary: Color(0xffac3306),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffffdbcf),
  onSecondaryContainer: Color(0xff141211),
  tertiary: Color(0xff006875),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xff95f0ff),
  onTertiaryContainer: Color(0xff0d1414),
  error: Color(0xffb00020),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffcd8df),
  onErrorContainer: Color(0xff141213),
  background: Color(0xfff8f9fb),
  onBackground: Color(0xff090909),
  surface: Color(0xfff8f9fb),
  onSurface: Color(0xff090909),
  surfaceVariant: Color(0xffe0e4e8),
  onSurfaceVariant: Color(0xff111112),
  outline: Color(0xff7c7c7c),
  outlineVariant: Color(0xffc8c8c8),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff101214),
  onInverseSurface: Color(0xfff5f5f5),
  inversePrimary: Color(0xff92c5ee),
  surfaceTint: Color(0xff004881),
);

const ColorScheme flexSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffa00000),
  onPrimary: Color(0xfffbefef),
  primaryContainer: Color(0xff4d4d4d),
  onPrimaryContainer: Color(0xffebebeb),
  secondary: Color(0xffffffff),
  onSecondary: Color(0xff141414),
  secondaryContainer: Color(0xff872100),
  onSecondaryContainer: Color(0xfff4e4df),
  tertiary: Color(0xff000000),
  onTertiary: Color(0xffefefef),
  tertiaryContainer: Color(0xffbbf246),
  onTertiaryContainer: Color(0xff20280e),
  error: Color(0xffcf6679),
  onError: Color(0xff140c0d),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfffbe8ec),
  background: Color(0xff181010),
  onBackground: Color(0xffececec),
  surface: Color(0xff181010),
  onSurface: Color(0xffececec),
  surfaceVariant: Color(0xff3d2c2c),
  onSurfaceVariant: Color(0xffe0dddd),
  outline: Color(0xff797979),
  outlineVariant: Color(0xff2d2d2d),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xfffaf2f2),
  onInverseSurface: Color(0xff131212),
  inversePrimary: Color(0xff530e0e),
  surfaceTint: Color(0xffa00000),
);
