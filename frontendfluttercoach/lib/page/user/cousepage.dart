import 'dart:convert';
import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../model/request/buycourse_coID_post.dart';
import '../../model/response/md_Day_showmycourse.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_amoutclip.dart';
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
  late ModelAmountclip clipamount;
  
  List<Course> courses = [];
  List<DayDetail> clip = [];
  late ModelResult moduleResult;
  int amountclip = 0;
  int courseId = 0;
  int cusID = 0;
  int moneycus = 0;
  var buycourse;
  int amountUser = 0;
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
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              // Get.to(() => DaysCoursePage(
              //       coID: context.read<AppData>().coID.toString(),
              //       isVisible: widget.isVisible,
              //     ));
              Navigator.pop(context);
            },
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
      var dataamount = await courseService.amoutclip(coID:  courseId.toString());
      clipamount = dataamount.data;
      amountclip = clipamount.amount;
      var dataamountUser = await buyCourseService.amountUserinCourse(originalID: courseId.toString());
      amountUser = dataamountUser.data;
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
                  child: Row(
                    children: [
                      Text(courses.first.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                              SizedBox(width: 10,),
                               RatingBar.readOnly(
                                  isHalfAllowed: false,
                                  filledIcon: FontAwesomeIcons.bolt,
                                  size: 22,
                                  emptyIcon: FontAwesomeIcons.bolt,
                                  filledColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  emptyColor:
                                      Color.fromARGB(255, 179, 179, 179),
                                  initialRating: double.parse(courses.first.level),
                                  maxRating: 3,
                                ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 10),
                  child: FilledButton.icon(
                      onPressed: () {
                        log("courses.first.coach.cid =" +
                            courses.first.coach.cid.toString());
                       
                            pushNewScreen(
                      context,
                      screen: ProfileCoachPage(
                              coachID: courses.first.coach.cid,
                            ),
                      withNavBar: true,
                    );
                      },
                      icon: const Icon(
                        FontAwesomeIcons.solidUser,
                        size: 16,
                      ),
                      label: Text(courses.first.coach.fullName,
                          style: const TextStyle(color: Colors.white,fontSize: 16))),
                ),
                
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: SizedBox(
                    height:  MediaQuery.of(context).size.height * 0.1,width:  MediaQuery.of(context).size.width * 0.6,
                    child: Column(children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Row(
                              children: [const Icon(FontAwesomeIcons.calendarCheck),
                          Padding(
                            padding: const EdgeInsets.only(left: 5,top: 6),
                            child: Text(courses.first.days.toString()+" วัน",style: Theme.of(context).textTheme.bodyLarge),
                          )]),),
                          SizedBox(width: 60,),
                          SizedBox(child: Row(children: [const Icon(FontAwesomeIcons.youtube),
                          Padding(
                            padding: const EdgeInsets.only(left: 5,top: 6),
                            child: Text(amountclip.toString()+" คลิป",style: Theme.of(context).textTheme.bodyLarge),
                          )]),),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Row(children: [const Icon(FontAwesomeIcons.userPlus),
                            Padding(
                              padding: const EdgeInsets.only(left: 10,top: 6),
                              child: Text(courses.first.amount.toString()+"/"+amountUser.toString()+" คน",style: Theme.of(context).textTheme.bodyLarge),
                            )]),),
                            SizedBox(width: 38,),
                            SizedBox(child: Row(children: [const Icon(FontAwesomeIcons.coins),
                            Padding(
                              padding: const EdgeInsets.only(left: 5,top: 6),
                              child: Text(courses.first.price.toString()+" บาท",style: Theme.of(context).textTheme.bodyLarge),
                            )]),),
                          ],
                        ),
                      ),
                    ],)),
                ) ,                    
                const Padding(
                  padding: EdgeInsets.only(left:12, ),
                  child:
                      Text("รายละเอียดคอร์ส", style: TextStyle(fontSize: 18,fontWeight: FontWeight.w600)),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 20, bottom: 12, right: 15),
                  child: Text(courses.first.details,style: Theme.of(context).textTheme.bodyLarge),
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
                      String cdate2 =
                          DateFormat("yyyy-MM-dd").format(DateTime.now());

                      var proposedDate = "${cdate2}T00:00:00.000Z";
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
                        SmartDialog.dismiss();
                        stopLoading();
                        pushNewScreen(
                          context,
                          screen: const MyCouses(),
                          withNavBar: true,
                        );
                        
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
