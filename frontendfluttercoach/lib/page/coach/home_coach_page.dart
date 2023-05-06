import 'dart:developer';

import 'package:frontendfluttercoach/service/provider/coachData.dart';
import 'package:get/get.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/response/course_get_res.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import '../../service/provider/courseData.dart';

import 'clip/clipCoach/clip_page.dart';
import 'course/course_edit_page.dart';
import 'food/foodCoach/food_page.dart';


class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
  List<ModelCourse> courses = [];
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
                  Container(
                    padding: const EdgeInsets.only(top: 50, left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CoachData>().cid = int.parse(cid);
                        Get.to(() => const CourseEditPage());
                      },
                      child: const Text("สร้างคอร์ส"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CoachData>().cid = int.parse(cid);
                        Get.to(() => const FoodCoachPage());
                      },
                      child: const Text("หน้าอาหาร"),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.only(top: 20, left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CoachData>().cid = int.parse(cid);
                        Get.to(() => const ClipCoachPage());
                      },
                      child: const Text("หน้าคลิป"),
                    ),
                  ),
                  // ignore: unnecessary_null_comparison
                  if (courses != null)
                    Expanded(
                      child: ListView.builder(
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                top: 8, left: 5, right: 5),
                            child: Card(
                                child: ListTile(
                              title: Text(courses[index].name),
                              subtitle: Text(courses[index].name),
                              leading: Image.network(courses[index].image),
                              onTap: () {
                                context.read<CourseData>().coIDCourse =
                                    courses[index].coId;
                                context.read<CourseData>().nameCourse =
                                    courses[index].name;
                                context.read<CourseData>().detailsCourse =
                                    courses[index].details;
                                context.read<CourseData>().lavelCourse =
                                    courses[index].level;
                                context.read<CourseData>().amountCourse =
                                    courses[index].amount;
                                context.read<CourseData>().imageCourse =
                                    courses[index].image;
                                context.read<CourseData>().daysCourse =
                                    courses[index].days;
                                context.read<CourseData>().priceCourse =
                                    courses[index].price;
                                context.read<CourseData>().statusCourse =
                                    courses[index].status;
                                Get.to(() => const CourseEditPage());
                              },
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

  Future<void> loadData() async {
    try {
      var datas = await courseService.course(coID: '', cid: cid, name: '');
      courses = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
