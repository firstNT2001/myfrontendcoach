import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCourse.dart';
import 'package:provider/provider.dart';

import '../../service/course.dart';
import '../../service/provider/appdata.dart';



class courseEditPage extends StatefulWidget {
  const courseEditPage({super.key});

  @override
  State<courseEditPage> createState() => _courseEditPageState();
}

class _courseEditPageState extends State<courseEditPage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
   var courses;

  int coID = 0;
  
  Object? get destinations => null;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    coID = context.read<AppData>().coID;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
        courseService.getCoachByCoID(coID.toString()).then((cou) {
        log(cou.data.name);
    });
    
    // 2.2 async method
    loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(child: Center(child: Text(courses.data.name)));
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
   Future<void> loadData() async {
    try {
      courses = await courseService.getCoachByCoID(coID.toString());
    } catch (err) {
      log('Error: $err');
    }
  }
}