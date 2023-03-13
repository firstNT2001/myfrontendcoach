import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';
import 'package:frontendfluttercoach/page/chat.dart';
import 'package:frontendfluttercoach/page/homePage.dart';
import 'package:frontendfluttercoach/page/login.dart';
import 'package:frontendfluttercoach/page/register.dart';
import 'package:frontendfluttercoach/page/start.dart';
import 'package:frontendfluttercoach/page/startApp.dart';

import 'package:frontendfluttercoach/service/login.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:provider/provider.dart';

import 'package:frontendfluttercoach/model/modelCustomer.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future< void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => AppData(),
    )
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        primarySwatch: Colors.green,
      ),
      home: StartApp(),
    );
  }
}
