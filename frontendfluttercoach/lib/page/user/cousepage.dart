import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_native/flutter_rating_native.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';

import 'package:frontendfluttercoach/service/review.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../model/request/buycourse_coID_post.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_Review_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/buy.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import 'mycourse.Detaildart/Widget/widget_loadreview.dart';
import 'mycourse.Detaildart/mycourse.dart';

class showCousePage extends StatefulWidget {
  const showCousePage({super.key});

  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late BuyCourseService buyCourseService;
  late CourseService courseService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];
  late ModelResult moduleResult;
  int courseId = 0;
  int cusID = 0;
  int moneycus = 0;
  var buycourse;
  final now = DateTime.now();
  double value = 0.0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseId = context.read<AppData>().idcourse;
    cusID = context.read<AppData>().uid;
    moneycus = context.read<AppData>().money;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);

    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 5),
          child: loadCourse(),
        ),
        const Divider(
          color: Color.fromARGB(255, 83, 83, 83),
          indent: 8,
          endIndent: 8,
          thickness: 3,
        ),
        Expanded(
            child: WidgetloadeReview(
          couseID: courseId.toString(),
        )),
        SizedBox(
          width: 65,
          height: 65,
          child: ElevatedButton(
            onPressed: () {
              _buycouse(context);
            },
            style: ElevatedButton.styleFrom(
              primary: const Color.fromARGB(255, 15, 15, 15),
              shape: const CircleBorder(), //<-- SEE HERE
              //padding: EdgeInsets.all(30),
            ),
            child: const Icon(
              //<-- SEE HERE
              Icons.shopping_basket_outlined,
              color: Color.fromARGB(255, 255, 255, 255),
              size: 35,
            ),
          ),
        ),
      ],
    ));
  }

  Future<void> loadData() async {
    try {
      var datacouse = await courseService.course(
          coID: courseId.toString(), cid: '', name: '');
      courses = datacouse.data;
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
                Image.network(
                  courses.first.image,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 25),
                  child: Text(courses.first.name,
                      style: const TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 20),
                  child: FilledButton.icon(
                      onPressed: () {
                        log("courses.first.coach.cid ="+courses.first.coach.cid.toString());
                        Get.to(() => ProfileCoachPage(coachID: courses.first.coach.cid,));
                      },
                      icon: const Icon(
                        FontAwesomeIcons.solidUser,
                        size: 14,
                      ),
                      label: Text(courses.first.coach.fullName,
                          style: Theme.of(context).textTheme.bodyMedium)),
                ),
                Row(
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(right: 8, left: 15),
                      child: Icon(FontAwesomeIcons.calendar),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 32),
                      child: Text(courses.first.days.toString() + "วัน/คอร์ส"),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: Icon(FontAwesomeIcons.moneyBills),
                    ),
                    const Text("27 คลิป")
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10, left: 15),
                        child: Icon(FontAwesomeIcons.userPlus),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 60),
                        child: Text(courses.first.amount.toString() + "คน"),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 8),
                        child: Icon(FontAwesomeIcons.youtube),
                      ),
                      Text(courses.first.price.toString() + "บาท"),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 8),
                  child: Text(
                    "รายละเอียดคอร์ส",
                    style: TextStyle(fontSize: 16)
                    
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

  void _buycouse(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text("กรุณาชำระเงิน",style: Theme.of(context).textTheme.bodyLarge),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text("คอร์สที่ซื้อ",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(courses.first.name,
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(courses.first.price.toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(
                color: Colors.black,
                indent: 8,
                endIndent: 8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("ยอดคงเหลือ",
                    style: Theme.of(context).textTheme.bodyLarge),
                Text(moneycus.toString(),
                    style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text("ยอดสุทธิ",
                      style: Theme.of(context).textTheme.bodyLarge),
                  Text(courses.first.price.toString(),
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                  child: Text('ยกเลิก',
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
                FilledButton(
                    onPressed: () {
                      log("Date time = " + now.toString());
                      String cdate2 =
                          DateFormat("yyyy-dd-MM").format(DateTime.now());
                      log("Date time2 = " + cdate2);

                      var proposedDate = "${cdate2}T00:00:00.000Z";
                      log("Date time3 = $proposedDate");
                      //log("Date time3 = $proposedDate");
                      BuyCoursecoIdPost buyCoursecoIdPost = BuyCoursecoIdPost(
                          customerId: cusID,
                          buyDateTime: proposedDate,);
                      log(jsonEncode(buyCoursecoIdPost));
                      log(cusID.toString());
                      buycourse = buyCourseService.buyCourse(
                          courseId.toString(), buyCoursecoIdPost);
                      Get.to(() => const MyCouses());
                    },
                    child: Text("ชำระเงิน",
                        style: Theme.of(context).textTheme.bodyLarge)),
              ],
            )
          ],
        ),
      );
    });
  }
}
