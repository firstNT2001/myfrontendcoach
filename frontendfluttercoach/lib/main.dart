import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:frontendfluttercoach/page/auth/login.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';

import 'package:frontendfluttercoach/theme/default.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetStorage gs = GetStorage();
  final DefaultTheme defaultTheme = DefaultTheme();

  // Screen size
  Size screenSize =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  // Setup Timeout

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Lock orientation Only on Android Chrome
  /// Android chrome must unins tall app first
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    // DeviceOrientation.landscapeLeft,
    // DeviceOrientation.landscapeRight,
  ]).then((value) {
    Intl.defaultLocale = "th";
    // initializeDateFormatting();

    double scale = 1.0;
    if (gs.read<bool>('s') != null) {
      if (gs.read<bool>('s')!) {
        scale = 1.2;
      } else {
        scale = 1.0;
      }
    }
    runApp(InAppNotification(
      child: MultiProvider(
          providers: [
            ChangeNotifierProvider(
              create: (context) => AppData(),
            ),
          ],
          child: GetMaterialApp(
            home: const LoginPage(),
            title: 'Application Daily Workout Coaching',
            debugShowCheckedModeBanner: false,
            builder: FlutterSmartDialog.init(
              builder: (context, child) {
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(textScaleFactor: scale),
                  child: child!,
                );
              },
            ),
            themeMode: ThemeMode.system,
            theme: defaultTheme.flexTheme.theme.copyWith(
                scaffoldBackgroundColor: Colors.white,
                inputDecorationTheme:
                    defaultTheme.flexTheme.theme.inputDecorationTheme.copyWith(
                  contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
                  isDense: true,
                )),
            darkTheme: defaultTheme.flexTheme.darkTheme.copyWith(
                inputDecorationTheme: defaultTheme
                    .flexTheme.darkTheme.inputDecorationTheme
                    .copyWith(
              contentPadding: const EdgeInsets.fromLTRB(6, 10, 6, 3),
              isDense: true,
            )),
            navigatorObservers: [FlutterSmartDialog.observer],
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [
              Locale('th', 'TH'),
            ],
          )),
    ));
  });
}
