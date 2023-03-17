import 'dart:convert';
import 'dart:developer';

import 'package:frontendfluttercoach/page/coach/courseEditPage.dart';
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
  String cid = "2";
  String statusName = "";
  String statusID = "";
  bool checkBoxVal = true;
 
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
              return Column(
                children: [
                  if (courses != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: courses.data.length,
                        itemBuilder: (context, index) {
                          checkStatusCourse(index);
                          return Container(
                            padding:
                                const EdgeInsets.only(top: 20, left: 5, right: 5),
                            child: Card(
                                child: ListTile(
                                  title: Text(courses.data[index].name),
                                  subtitle: Text(courses.data[index].name),
                                  leading: Image.network(courses.data[index].image),
                                  onTap: (){
                                    context.read<AppData>().coID = courses.data[index].coId;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => const courseEditPage()));
                                  },
                                  // child: Column(
                                  //                                 children: [
                                  // Padding(
                                  //   padding: const EdgeInsets.all(8.0),
                                  //   child: SizedBox(
                                  //     height: 100,
                                  //     width: double.infinity,
                                  //     child: Card(
                                  //       child:
                                  //           Text(courses.data[index].image),
                                  //     ),
                                  //   ),
                                  // ),
                                  // Text(courses.data[index].image),
                                  // Text(courses.data[index].name),
                                  // Text(statusName),
                                  // // ignore: unnecessary_new
                                  // ListTile(
                                  //   title:  Text(index.toString()),
                                  //   trailing:  Switch(
                                  //     value: checkBoxVal,
                                  //     onChanged: (bool? value) {
                                  //       log("ss" + value.toString());
                                  //       setState(() =>
                                  //         checkBoxVal = value!
                                  //       );
                                  //       log(checkBoxVal.toString());
                                  //     },
                                  //   ),
                                  // ),
                                  //                                 ],
                                  //                               ),
                                )),
                          );
                        },
                      ),
                    )
                  else
                    Container(),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
             
            }
          }),
    );
  }

  void checkStatusCourse(int index) {
    statusID = courses.data[index].status;
    if (statusID == "1") {
      statusName = "เปิดการขาย";
      //checkBoxVal = true;
    } else {
      statusName = "ปิดการขาย";
      //checkBoxVal = false;
    }
  }

  Future<void> loadData() async {
    try {
      courses = await courseService.getCoachByCid(cid);
    } catch (err) {
      log('Error: $err');
    }
  }
}

