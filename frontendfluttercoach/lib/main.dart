import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';
import 'package:frontendfluttercoach/page/login.dart';
import 'package:frontendfluttercoach/page/register.dart';
import 'package:frontendfluttercoach/service/login.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:provider/provider.dart';

import 'package:frontendfluttercoach/model/customer.dart';

void main() {
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
        
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(),
    );
  }
}
