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
// Made for FlexColorScheme version 7.0.1. Make sure you
// use same or higher package version, but still same major version.
// If you use a lower version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
    theme: FlexThemeData.light(
      colors: const FlexSchemeColor(
        primary: Color(0xff0d9a20),
        primaryContainer: Color(0xffd3f7d5),
        secondary: Color.fromARGB(255, 0, 0, 0),
        secondaryContainer: Color.fromARGB(255, 0, 0, 0),
        tertiary: Color(0xff33c046),
        tertiaryContainer: Color(0xffcbf1d0),
        appBarColor: Color(0xffffdfee),
        error: Color(0xffb00020),
      ),
      usedColors: 3,
      appBarOpacity: 0.94,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      surfaceTint: const Color(0xff0d9a20),
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        blendOnLevel: 10,
        blendOnColors: false,
        useM2StyleDividerInM3: true,
        textButtonSchemeColor: SchemeColor.onPrimaryContainer,
        filledButtonSchemeColor: SchemeColor.primaryContainer,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonSchemeColor: SchemeColor.onSecondaryContainer,
        inputDecoratorSchemeColor: SchemeColor.outline,
        inputDecoratorIsFilled: false,
        inputDecoratorBorderSchemeColor: SchemeColor.outline,
        inputDecoratorUnfocusedBorderIsColored: false,
        dialogBackgroundSchemeColor: SchemeColor.background,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      // To use the playground font, add GoogleFonts package and uncomment
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
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
      usedColors: 3,
      surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
      blendLevel: 13,
      tabBarStyle: FlexTabBarStyle.forAppBar,
      subThemesData: const FlexSubThemesData(
        interactionEffects: false,
        tintedDisabledControls: false,
        blendOnLevel: 20,
        useM2StyleDividerInM3: true,
        textButtonSchemeColor: SchemeColor.onPrimaryContainer,
        filledButtonSchemeColor: SchemeColor.primaryContainer,
        elevatedButtonSchemeColor: SchemeColor.onPrimaryContainer,
        elevatedButtonSecondarySchemeColor: SchemeColor.primaryContainer,
        outlinedButtonSchemeColor: SchemeColor.onSecondaryContainer,
        inputDecoratorIsFilled: false,
        inputDecoratorUnfocusedBorderIsColored: false,
        dialogBackgroundSchemeColor: SchemeColor.background,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      useMaterial3: true,
      // To use the Playground font, add GoogleFonts package and uncomment
      fontFamily: GoogleFonts.notoSansThai().fontFamily,
    ),
// If you do not have a themeMode switch, uncomment this line
// to let the device system mode control the theme mode:
// themeMode: ThemeMode.system,
  );
}

const ColorScheme flexSchemeLight = ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xff0d9a20),
  onPrimary: Color(0xffffffff),
  primaryContainer: Color(0xffd3f7d5),
  onPrimaryContainer: Color(0xff0c0e0c),
  secondary: Color(0xffffafd6),
  onSecondary: Color(0xff000000),
  secondaryContainer: Color(0xffffdfee),
  onSecondaryContainer: Color(0xff0e0d0e),
  tertiary: Color(0xff33c046),
  onTertiary: Color(0xff000000),
  tertiaryContainer: Color(0xffcbf1d0),
  onTertiaryContainer: Color(0xff0c0e0c),
  error: Color(0xffb00020),
  onError: Color(0xffffffff),
  errorContainer: Color(0xfffcd8df),
  onErrorContainer: Color(0xff0e0c0d),
  background: Color(0xffffffff),
  onBackground: Color(0xff070707),
  surface: Color(0xffffffff),
  onSurface: Color(0xff070707),
  surfaceVariant: Color(0xffffffff),
  onSurfaceVariant: Color(0xff0e0e0e),
  outline: Color(0xff545454),
  shadow: Color(0xff000000),
  inverseSurface: Color(0xff121212),
  onInverseSurface: Color(0xfff8f8f8),
  inversePrimary: Color(0xffa6ffb2),
  surfaceTint: Color(0xff0d9a20),
);
const ColorScheme flexSchemeDark = ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xff9fc9ff),
  onPrimary: Color(0xff101314),
  primaryContainer: Color(0xff00325b),
  onPrimaryContainer: Color(0xffdfe7ee),
  secondary: Color(0xffffb59d),
  onSecondary: Color(0xff141210),
  secondaryContainer: Color(0xff66483e),
  onSecondaryContainer: Color(0xffefebe9),
  tertiary: Color(0xffc5efff),
  onTertiary: Color(0xff131414),
  tertiaryContainer: Color(0xff4294b3),
  onTertiaryContainer: Color(0xffeaf7fb),
  error: Color(0xffcf6679),
  onError: Color(0xff140c0d),
  errorContainer: Color(0xffb1384e),
  onErrorContainer: Color(0xfffbe8ec),
  background: Color(0xff191b1f),
  onBackground: Color(0xffeceded),
  surface: Color(0xff191b1f),
  onSurface: Color(0xffeceded),
  surfaceVariant: Color(0xff21262d),
  onSurfaceVariant: Color(0xffdcdcde),
  outline: Color(0xff9da3a3),
  shadow: Color(0xff000000),
  inverseSurface: Color(0xfff9fbff),
  onInverseSurface: Color(0xff131314),
  inversePrimary: Color(0xff536578),
  surfaceTint: Color(0xff9fc9ff),
);
