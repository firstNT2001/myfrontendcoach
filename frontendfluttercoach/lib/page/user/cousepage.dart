import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontendfluttercoach/service/review.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/dio.dart';


import '../../model/response/course_get_res.dart';
import '../../model/response/md_Review_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class showCousePage extends StatefulWidget {
  const showCousePage({super.key});

  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
  late ReviewService reviewService;
  List<ModelCourse> courses = [];
  
  int courseId = 0;
  List<ModelReview> reviews = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseId = context.read<AppData>().idcourse;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("show course"),
        ),
        body: ListView(
          children: <Widget>[
            Expanded(
              child: Column(
                children: [
                  Container(
                     child: Column(children: [loadCourse()]),
                  ),           
                      SizedBox(
                        height: 320,width: 390,
                        child: loadReview()
                        )
 
                ],
              ),
            ),
          ],
        )
        );
  }

  Future<void> loadData() async {
    try {
      
      var datacouse = await courseService.course(coID: courseId.toString(), cid: '', name: '');
      log("loadCoursereview"+courseId.toString());
      var datareview = await reviewService.review(coID: courseId.toString());
      
      courses = datacouse.data;
      reviews = datareview.data;
      log("loadCourseIDDatas"+courses[0].name);
      log("loadCoursereview"+reviews.length.toString());
      
      //log('review: ${reviews.length}');
    } catch (err) {
      log('Error: $err');
    }
  }
    Widget loadCourse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                SizedBox(
                    height: 35,
                    width: 390,
                    child: Text(
                      "Daily workout",
                      style: TextStyle(fontSize: 25),
                    )),
                Image.network(
                  courses.first.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Column(
                  children: [
                    SizedBox(
                        width: 200, height: 100, child: Text(courses.first.name)),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 20),
                          child: Text(courses.first.days.toString() + "วัน/คอร์ส"),
                        ),
                        Text("27 คลิป")
                      ],
                    ),
                    Row(
                      children: [
                        Text(courses.first.amount.toString() + "คน"),
                        Text(courses.first.price.toString() + "บาท"),
                      ],
                    ),
                    Text("รายละเอียดคอร์ส"),
                    Text(courses.first.details),
                  ],
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

    Widget loadReview() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Column(
            children: [
              if (courses != null)
                Expanded(
                  child: ListView.builder(
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        final review = reviews[index];
                        return Card(
                          child: ListTile(
                            title: Text(review.uid.toString()),
                            subtitle: Text(review.details),
                          ),
                        );
                      }),
                )
              else
                Container(),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

}
