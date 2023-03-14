import 'dart:convert';
import 'dart:developer';

import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/modelCourse.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
  late HttpResponse<List<ModelCourse>> courses;
  String cid = "1";
  //var courses;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // courseService.getCoachByCid("1").then((cou) {
    //   log(cou.data.first.name);
    // });

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
              return Container(
                child: Column(
                  children: [
                    (courses != null)
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: courses.data.length,
                              itemBuilder: (context, index) {
                                return Container(
                                  padding: EdgeInsets.only(top: 20,left: 5,right: 5),
                                  child: SizedBox(
                                      height: 200,
                                      child: Card(
                                          child: Column(
                                            children: [
                                              Text(courses.data[index].image),
                                              Text(courses.data[index].name),
                                              Text(courses.data[index].details),
                                            ],
                                          ))),
                                );
                              },
                            ),
                          )
                        : Container(),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> loadData() async {
    try {
      courses = await courseService.getCoachByCid(cid);
    } catch (err) {
      log('Error: $err');
    }
  }
}
