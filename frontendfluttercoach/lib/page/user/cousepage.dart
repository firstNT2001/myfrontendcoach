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
import '../../model/response/md_Day_showmycourse.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_Review_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/buy.dart';
import '../../service/course.dart';
import '../../service/day.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dialogs.dart';
import 'mycourse/Widget/widget_loadreview.dart';
import 'mycourse/mycourse.dart';

class showCousePage extends StatefulWidget {
  const showCousePage({super.key});

  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late BuyCourseService buyCourseService;
  late DayService dayService;
  late CourseService courseService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];
  List<DayDetail> clip = [];
  late ModelResult moduleResult;
  int amountclip = 0;
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
    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);

    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              _buycouse(context);
              // ignore: prefer_const_constructors
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.shopping_cart),
          ),
        ),
        body: SafeArea(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: loadCourse(),
              ),
              const Divider(
                color: Color.fromARGB(255, 194, 194, 194),
                indent: 8,
                endIndent: 8,
                thickness: 1.5,
              ),
              WidgetloadeReview(
                couseID: courseId.toString(),
              ),
            ],
          ),
        ));
  }

  Future<void> loadData() async {
    try {
      var datacouse = await courseService.course(
          coID: courseId.toString(), cid: '', name: '');
      courses = datacouse.data;
      var dataclip = await dayService.day(
          did: '', coID: courseId.toString(), sequence: '');
      clip = dataclip.data;
      // for (int i = 1; i <= clip.length; i++) {
      //   // log("cid = "+clip[i].clips.first.cpId.toString());
      //    log("cid = "+i.toString());
      //    for(int k = 0; k < clip.)
      // }
      // log("amountclip =" + clip.first.clips.first.cpId.toString());
      // amountclip = clip.length;
      // log("amountclip =" + amountclip.toString());
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
                Container(
                  alignment: Alignment.topCenter,
                  child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.onPrimary,
                          image: DecorationImage(
                              image: NetworkImage(courses.first.image),
                              fit: BoxFit.cover),
                        ),
                      )),
                  //color: Colors.white,
                ),
                // Image.network(
                //   courses.first.image,
                //   height: 200,
                //   width: double.infinity,
                //   fit: BoxFit.cover,
                // ),
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
                        log("courses.first.coach.cid =" +
                            courses.first.coach.cid.toString());
                        Get.to(() => ProfileCoachPage(
                              coachID: courses.first.coach.cid,
                            ));
                      },
                      icon: const Icon(
                        FontAwesomeIcons.solidUser,
                        size: 16,
                      ),
                      label: Text(courses.first.coach.fullName,
                          style: TextStyle(color: Colors.white,fontSize: 16))),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    width: 400,
                    height: 80,
                    //color: Colors.green,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        borderRadius: BorderRadius.circular(15)
                        //more than 50% of width makes circle
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(courses.first.days.toString()),
                            const Text("วัน"),
                          ],
                        ),
                        const VerticalDivider(
                          color: Color.fromARGB(
                              255, 134, 134, 134), //color of divider
                          //width space of divider
                          thickness: 2, //thickness of divier line
                          indent: 10, //Spacing at the top of divider.
                          endIndent: 10, //Spacing at the bottom of divider.
                        ),
                        const Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("clip"),
                          ],
                        ),
                        const VerticalDivider(
                          color: Color.fromARGB(
                              255, 134, 134, 134), //color of divider
                          //width space of divider
                          thickness: 2, //thickness of divier line
                          indent: 10, //Spacing at the top of divider.
                          endIndent: 10, //Spacing at the bottom of divider.
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(courses.first.amount.toString()),
                            const Text("คน"),
                          ],
                        ),
                        const VerticalDivider(
                          color: Color.fromARGB(
                              255, 134, 134, 134), //color of divider
                          //width space of divider
                          thickness: 2, //thickness of divier line
                          indent: 10, //Spacing at the top of divider.
                          endIndent: 10, //Spacing at the bottom of divider.
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(courses.first.price.toString()),
                            const Text("บาท"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Padding(
                //       padding: const EdgeInsets.only(left: 10, right: 10),
                //       child: Container(
                //         height: 80,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color:
                //                 Theme.of(context).colorScheme.primaryContainer,
                //             borderRadius: BorderRadius.circular(15)
                //             //more than 50% of width makes circle
                //             ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(courses.first.days.toString()),
                //             const Text("วัน"),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 10),
                //       child: Container(
                //         height: 80,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color:
                //                 Theme.of(context).colorScheme.primaryContainer,
                //             borderRadius: BorderRadius.circular(15)
                //             //more than 50% of width makes circle
                //             ),
                //         child: const Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             //Text(courses.first.),Text("วัน/คอร์ส"),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(
                //         right: 10,
                //       ),
                //       child: Container(
                //         height: 80,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color:
                //                 Theme.of(context).colorScheme.primaryContainer,
                //             borderRadius: BorderRadius.circular(15)
                //             //more than 50% of width makes circle
                //             ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(courses.first.amount.toString()),
                //             const Text("คน"),
                //           ],
                //         ),
                //       ),
                //     ),
                //     Padding(
                //       padding: const EdgeInsets.only(right: 10),
                //       child: Container(
                //         height: 80,
                //         width: 70,
                //         decoration: BoxDecoration(
                //             color:
                //                 Theme.of(context).colorScheme.primaryContainer,
                //             borderRadius: BorderRadius.circular(15)
                //             //more than 50% of width makes circle
                //             ),
                //         child: Column(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Text(courses.first.price.toString()),
                //             const Text("บาท"),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const Padding(
                  padding: EdgeInsets.only(left: 8, top: 20),
                  child:
                      Text("รายละเอียดคอร์ส", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 15, bottom: 12, right: 15),
                  child: Text(courses.first.details),
                ),
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
                    onPressed: () async {
                      startLoading(context);
                      log("Date time = " + now.toString());
                      String cdate2 =
                          DateFormat("yyyy-MM-dd").format(DateTime.now());
                      log("Date time2 = " + cdate2);

                      var proposedDate = "${cdate2}T00:00:00.000Z";
                      log("Date time3 = $proposedDate");
                      //log("Date time3 = $proposedDate");
                      BuyCoursecoIdPost buyCoursecoIdPost = BuyCoursecoIdPost(
                        customerId: cusID,
                        buyDateTime: proposedDate,
                      );
                      log(jsonEncode(buyCoursecoIdPost));
                      log(cusID.toString());
                      buycourse = await buyCourseService.buyCourse(
                          courseId.toString(), buyCoursecoIdPost);
                      moduleResult = buycourse.data;
                      if (moduleResult.result == "1") {
                        stopLoading();
                        Get.to(() => const MyCouses());
                      }
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
