import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/startApp.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/provider/coachData.dart';
import 'package:frontendfluttercoach/service/provider/courseData.dart';
import 'package:frontendfluttercoach/service/provider/dayOfCouseData.dart';
import 'package:frontendfluttercoach/service/provider/listFood.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => AppData(),
          ),
          ChangeNotifierProvider(
            create: (context) => CourseData(),
          ),
          ChangeNotifierProvider(
            create: (context) => DayOfCourseData(),
          ),
          ChangeNotifierProvider(
            create: (context) => CoachData(),
          ),
          ChangeNotifierProvider(
            create: (context) => ListFoodData(),
          )
        ],
        child: GetMaterialApp(
          home: const StartApp(),
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.green,
          ),
          //localizationsDelegates: GlobalMaterialLocalizations.delegate,
          // supportedLocales: const [
          //   Locale('th', 'TH'),
          // ],
        )),
  ));
}
