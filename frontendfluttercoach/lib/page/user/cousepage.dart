import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:frontendfluttercoach/service/review.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:retrofit/dio.dart';

import '../../model/request/buycourse_coID_post.dart';
import '../../model/response/course_get_res.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_Review_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/buy.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import 'homepageUser.dart';

class showCousePage extends StatefulWidget {
  const showCousePage({super.key});

  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late BuyCourseService buyCourseService;
  late CourseService courseService;
  late Future<void> loadDataMethod;
  late ReviewService reviewService;
  List<Coachbycourse> courses = [];
  late ModelResult moduleResult;
  int courseId = 0;
  int cusID = 0;
  int moneycus = 0;
  List<ModelReview> reviews = [];
  var buycourse;
  final now = DateTime.now();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseId = context.read<AppData>().idcourse;
    cusID = context.read<AppData>().uid;
    moneycus = context.read<AppData>().money;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    reviewService =
        ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);
    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
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
                  Divider(
                    color: Colors.black,
                    indent: 8,
                    endIndent: 8,
                  ),
                  Center(
                    child: Text(
                      "คะแนนจากผู้ซื้อ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 150, width: 390, child: loadReview()),
                  SizedBox(
                    width: 65,
                    height: 65,
                    child: ElevatedButton(
                      onPressed: () {
                        openDialog();
                      },
                      style: ElevatedButton.styleFrom(
                        primary: Color.fromARGB(255, 15, 15, 15),
                        shape: CircleBorder(), //<-- SEE HERE
                        //padding: EdgeInsets.all(30),
                      ),
                      child: Icon(
                        //<-- SEE HERE
                        Icons.shopping_basket_outlined,
                        color: Color.fromARGB(255, 255, 255, 255),
                        size: 35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ));
  }

  Future openDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("กรุณาชำระเงิน"),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("คอร์สที่ซื้อ"),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(courses.first.name),
                    Text(courses.first.price.toString()),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,bottom: 10),
                  child: Divider(
                    color: Colors.black,
                    indent: 8,
                    endIndent: 8,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("ยอดคงเหลือ"),
                    Text(moneycus.toString()),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("ยอดสุทธิ"),
                    Text(courses.first.price.toString()),
                  ],
                ),
              ],
            ),
            actions: [
              TextButton(onPressed: () {
                 log("Date time = "+ now.toString());
                        String cdate2 = DateFormat("yyyy-dd-MM").format(DateTime.now());
                        log("Date time2 = "+ cdate2);

                        var proposedDate = "${cdate2}T00:00:00.000Z";
                        log("Date time3 = $proposedDate");
                        //log("Date time3 = $proposedDate");
                        BuyCoursecoIdPost buyCoursecoIdPost = BuyCoursecoIdPost(
                          customerId: cusID, 
                          buyDateTime:  proposedDate, 
                          image: "-");
                          log(jsonEncode(buyCoursecoIdPost));
                          log(cusID.toString());
                          buycourse =  buyCourseService.buyCourse(courseId.toString(), buyCoursecoIdPost);
                          Get.to(() => const HomePageUser());
              }, child: Text("ชำระเงิน"))
            ],
          ));
  Future<void> loadData() async {
    try {
      var datacouse = await courseService.course(
          coID: courseId.toString(), cid: '', name: '');
      log("loadCoursereview" + courseId.toString());
      var datareview = await reviewService.review(coID: courseId.toString());

      courses = datacouse.data;
      reviews = datareview.data;
      log("loadCourseIDDatas" + courses[0].name);
      log("loadCoursereview" + reviews.length.toString());

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
              crossAxisAlignment: CrossAxisAlignment.start,
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
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 25, bottom: 8),
                  child: Text(courses.first.name,
                      style:
                          TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 8, left: 15),
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Text(courses.first.days.toString() + "วัน/คอร์ส"),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: Icon(FontAwesomeIcons.moneyBills),
                    ),
                    Text("27 คลิป")
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10, left: 15),
                        child: Icon(FontAwesomeIcons.userPlus),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Text(courses.first.amount.toString() + "คน"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Icon(FontAwesomeIcons.youtube),
                      ),
                      Text(courses.first.price.toString() + "บาท"),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    "รายละเอียดคอร์ส",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 12),
                  child: Text(courses.first.details),
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
