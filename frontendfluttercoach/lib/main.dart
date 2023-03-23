import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/startApp.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/provider/courseData.dart';
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
          )
        ],
        child: GetMaterialApp(
          home: const StartApp(),
          title: 'Flutter Demo',
          theme: ThemeData(
            useMaterial3: true,
            primarySwatch: Colors.green,
          ),
        )),
  ));
}

