import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontendfluttercoach/page/startApp.dart';
import 'package:frontendfluttercoach/page/auth/login.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/provider/coachData.dart';
import 'package:frontendfluttercoach/service/provider/courseData.dart';
import 'package:frontendfluttercoach/service/provider/dayOfCouseData.dart';
import 'package:frontendfluttercoach/service/provider/listFood.dart';
import 'package:frontendfluttercoach/theme/default.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  GetStorage gs = GetStorage();
  final DefaultTheme defaultTheme = DefaultTheme();
  WidgetsFlutterBinding.ensureInitialized();
  // Screen size
  Size screenSize =
      MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  // Setup Timeout
  final sessionConfig = SessionConfig(
    invalidateSessionForAppLostFocus: const Duration(minutes: 3),
    invalidateSessionForUserInactivity: const Duration(minutes: 3),
  );
  final sessionStateStream = StreamController<SessionState>();
  sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
    sessionStateStream.add(SessionState.stopListening);
    if (timeoutEvent == SessionTimeoutState.userInactivityTimeout ||
        timeoutEvent == SessionTimeoutState.appFocusTimeout) {
      Get.to(() => LoginPage(sessionStateStream: sessionStateStream));
    }
  });
  sessionStateStream.add(SessionState.startListening);
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
    runApp(MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AppData(),
          ),
        ],
        child: Center(
          child: SizedBox(
            width: (screenSize.width > 550) ? 550 : screenSize.width,
            child: SessionTimeoutManager(
                userActivityDebounceDuration: const Duration(seconds: 1),
                sessionConfig: sessionConfig,
                sessionStateStream: sessionStateStream.stream,
                child: GetMaterialApp(
                    title: 'Application Daily Workout Coaching',
                    debugShowCheckedModeBanner: false,
                    builder: FlutterSmartDialog.init(
                      builder: (context, child) {
                        return MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(textScaleFactor: scale),
                          child: child!,
                        );
                      },
                    ),
                    themeMode: ThemeMode.dark,
                    theme: defaultTheme.flexTheme.theme.copyWith(
                        scaffoldBackgroundColor: Colors.white,
                        inputDecorationTheme: defaultTheme
                            .flexTheme.theme.inputDecorationTheme
                            .copyWith(
                          contentPadding:
                              const EdgeInsets.fromLTRB(6, 10, 6, 3),
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
                    localizationsDelegates:
                        GlobalMaterialLocalizations.delegates,
                    supportedLocales: const [
                      Locale('th', 'TH'),
                    ],
                    home: LoginPage())),
          ),
        ),
      ),
    ));
  });
}
