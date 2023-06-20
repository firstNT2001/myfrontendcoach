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
  ),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  // fontFamily: GoogleFonts.notoSans().fontFamily,
),
darkTheme: FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xffa00000),
    primaryContainer: Color(0xff161616),
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
// Light and dark ColorSchemes made by FlexColorScheme v7.1.2.
// These ColorScheme objects require Flutter 3.7 or later.
const ColorScheme flexSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff004881),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffd0e4ff),
  onPrimaryContainer: Color(0xff000000),
  secondary: Color(0xffac3306),
  onSecondary: Color(0xffffffff),
  secondaryContainer: Color(0xffffdbcf),
  onSecondaryContainer: Color(0xff000000),
  tertiary: Color(0xff006875),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xff95f0ff),
  onTertiaryContainer: Color(0xff000000),
  error: Color(0xffb00020),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffcd8df),
  onErrorContainer: Color(0xff000000),
  background: Color(0xfff8f9fb),
  onBackground: Color(0xff000000),
  surface: Color(0xfff8f9fb),
  onSurface: Color(0xff000000),
  surfaceVariant: Color(0xffe0e4e8),
  onSurfaceVariant: Color(0xff000000),
  outline: Color(0xff737373),
  outlineVariant: Color(0xffbfbfbf),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xff101214),
  onInverseSurface: Color(0xffffffff),
  inversePrimary: Color(0xff92c5ee),
  surfaceTint: Color(0xff004881),
);

const ColorScheme flexSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xffa00000),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xff161616),
  onPrimaryContainer: Color(0xffffffff),
  secondary: Color(0xffffffff),
  onSecondary: Color(0xff000000),
  secondaryContainer: Color(0xffffffff),
  onSecondaryContainer: Color(0xff000000),
  tertiary: Color(0xff000000),
  onTertiary: Color(0xffffffff),
  tertiaryContainer: Color(0xffbbf246),
  onTertiaryContainer: Color(0xff000000),
  error: Color(0xffcf6679),
  onError: Color(0xff000000),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xffffffff),
  background: Color(0xff181010),
  onBackground: Color(0xffffffff),
  surface: Color(0xff181010),
  onSurface: Color(0xffffffff),
  surfaceVariant: Color(0xff3d2c2c),
  onSurfaceVariant: Color(0xffffffff),
  outline: Color(0xff8c8c8c),
  outlineVariant: Color(0xff404040),
  shadow: Color(0xff000000),
  scrim: Color(0xff000000),
  inverseSurface: Color(0xfffaf2f2),
  onInverseSurface: Color(0xff000000),
  inversePrimary: Color(0xff530e0e),
  surfaceTint: Color(0xffa00000),
);
