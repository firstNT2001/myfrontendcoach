import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/login.dart';
import 'package:frontendfluttercoach/sevice/login.dart';
import 'package:frontendfluttercoach/sevice/provider/appdata.dart';
import 'package:provider/provider.dart';

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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
    Widget build(BuildContext context) {
        return Scaffold(
                
                body: ElevatedButton(
                  onPressed: (){
                    context.read<HomePage>();
                  },
                  child: Text('Login'),)
                
            );
        
    }
  
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 1. กำหนดตัวแปร
  List<Login> logins = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;

  // 2. สร้าง initState เพื่อสร้าง object ของ service 
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
  // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    loginService = 
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl); 
  // 2.2 async method
    loadDataMethod = loadData(); 
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        
      ),
  // 3. เรียก service ในรูปแบบของ FutureBuilder (หรือจะไม่ใช้ก็ได้ แค่ตัวอย่างให้ดูเฉยๆ)
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(child: Text(jsonEncode(logins)));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
  // 4. Async method ที่เรียก service เมื่อได้ข้อมูลก็เอาไปเก็บไว้ที่ destinations ที่ประกาศไว้ด้านบนเป็น List
  Future<void> loadData() async {
    try {
      logins = await loginService.getDestinations();
    } catch (err) {
      log('Error: $err');
    }
  }
}
