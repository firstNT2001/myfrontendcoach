import 'dart:convert';
import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/chat/chat.dart';
import 'package:frontendfluttercoach/page/user/mycourse/showFood_Clip.dart';
import 'package:get/get.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../model/request/course_EX.dart';
import '../../../model/response/md_Day_showmycourse.dart';
import '../../../model/response/md_Result.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/day.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/notificationBody.dart';
import '../profilecoach.dart';
import 'mycourse.dart';

class ShowDayMycourse extends StatefulWidget {
  ShowDayMycourse({super.key, required this.namecourse, required this.nameCoach});
  late String namecourse;
  late String nameCoach;

  @override
  State<ShowDayMycourse> createState() => _ShowDayMycourseState();
}

class _ShowDayMycourseState extends State<ShowDayMycourse> {
  late ModelResult moduleResult;
  late DayService dayService;
  late Course courses;
  late CourseService _courseService;

  // late HttpResponse<ModelCourse> courses;
  List<DayDetail> days = [];
  late Future<void> loadDataMethod;
  late ModelResult modelResult;
  DateTime nows = DateTime.now();
  late DateTime today;
  late DateTime expirationDate;
  late DateTime showtodaycolor;
  //
  List<DateTime> listindexday = [];
  int dayincourse = 0;
  late DateTime exdate;
  late DateTime dayex;
  int indexToday = 0;
  int indexEx = 0;
  String txtdateEX = "";
  String txtdateStart = "";
  late String roomchat;
  var update;
  int coachId = 0;
  int coID = 0;
  void initState() {
    // TODO: implement initState

    super.initState();

    coachId = context.read<AppData>().cid;
    coID = context.read<AppData>().idcourse;
    log("messagecoID" + coID.toString());
    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);
    _courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();

    today = DateTime(nows.year, nows.month, nows.day);

    var formatter = DateFormat.yMMMd();

    var onlyBuddhistYear = nows.yearInBuddhistCalendar;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: SizedBox(
        height: 60,
        width: 60,
        child: FloatingActionButton(
          heroTag: 'chat',
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
          onPressed: () {
            Get.to(() => ChatPage(
                  roomID: coID.toString() + widget.namecourse,
                  userID: coID.toString(),
                  firstName: widget.namecourse,
                  roomName: widget.namecourse,
                ));
            // ignore: prefer_const_constructors
          },
          shape: const CircleBorder(),
          child: const Icon(
            FontAwesomeIcons.facebookMessenger,
            size: 25,
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          widget.namecourse,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(FontAwesomeIcons.ellipsisVertical),
            onPressed: () {
              dialogCourse(context);
            },
          )
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            loadImgCourse(),
          ],
        ),
      ),
    );
  }

  Widget loadImgCourse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                Container(
                  // alignment: Alignment.center,
                  // width: double.infinity,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Stack(
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topCenter,
                          child: AspectRatio(
                              aspectRatio: 16 / 9,
                              child: Container(
                                decoration: BoxDecoration(
                                  color:
                                      Theme.of(context).colorScheme.onPrimary,
                                  image: DecorationImage(
                                      image: NetworkImage(courses.image),
                                      fit: BoxFit.cover),
                                ),
                              )),
                          //color: Colors.white,
                        ),
                        Container(
                          padding: const EdgeInsets.all(5.0),
                          alignment: Alignment.bottomCenter,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                const Color.fromARGB(255, 0, 0, 0).withAlpha(0),
                                const Color.fromARGB(49, 0, 0, 0),
                                const Color.fromARGB(127, 0, 0, 0)
                                // const Color.fromARGB(255, 255, 255, 255)
                                //     .withAlpha(0),
                                // Color.fromARGB(70, 255, 255, 255),
                                // Color.fromARGB(149, 255, 255, 255)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 4),
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15, top: 25, bottom: 8),
                              child: Row(
                                children: [
                                  Text(widget.namecourse,
                                      style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            ),
                            InkWell(
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 10),
                                    child: FilledButton.icon(
                                        onPressed: () {
                                          pushNewScreen(
                                            context,
                                            screen: ProfileCoachPage(
                                              coachID: coachId,
                                            ),
                                            withNavBar: true,
                                          );
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.solidUser,
                                          size: 16,
                                        ),
                                        label: Text(widget.nameCoach,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 16))),
                                  ),
                                ],
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15, bottom: 10),
                              child: Text("รายละเอียดคอร์ส",
                                  style: TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, bottom: 8, right: 8),
                              child: Text(courses.details,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 15),
                              child: Text("วันที่",
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700)),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20, right: 20, top: 5, bottom: 30),
                              child: loadDay(),
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadData() async {
    try {
      var dataday =
          await dayService.day(did: '', coID: coID.toString(), sequence: '');
      days = dataday.data;

      var datacourse = await _courseService.coursebyCoID(coID.toString());
      courses = datacourse.data;
      expirationDate = DateTime(nows.year, nows.month, nows.day + courses.days);

      indexEx = expirationDate.day + expirationDate.month;

      log("message" + indexEx.toString());

      showtodaycolor = DateTime(expirationDate.year,
          expirationDate.month - nows.month, expirationDate.day - nows.day);
         log("INDEX" + expirationDate.toString()); 
      log("INDEX" + showtodaycolor.toString());
        var formatter = DateFormat.yMMMd();
   var onlyBuddhistYear = nows.yearInBuddhistCalendar;
    txtdateEX = formatter.formatInBuddhistCalendarThai(expirationDate);
    txtdateStart = formatter.formatInBuddhistCalendarThai(nows);
      int dayx = showtodaycolor.day;
      for (int i = 0; i <= dayx; i++) {
        dayex = DateTime(
            expirationDate.year, expirationDate.month, expirationDate.day - i);
        listindexday.add(dayex);
        listindexday.sort();
        //log("อิหยัง= ${dayex.day}");
      }
      log("iรf= $listindexday");
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadDay() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 194, 194, 194),
                borderRadius: BorderRadius.circular(30)
                //more than 50% of width makes circle
                ),
            height: (days.length / 5 * 50) + 100,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5,
                    mainAxisExtent: 60,
                  ),
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final day = days[index];
                    final indextoday = listindexday[index];
                    //log("messageindextoday"+indextoday.toString());
                    return Column(
                      children: [
                        InkWell(
                            onTap: () {
                              if (courses.expirationDate ==
                                  "0001-01-01T00:00:00Z") {
                                _bindPage(context);
                                log("ยังไม่เริ่ม$widget.expirationDate");
                                setState(() {
                                  loadDataMethod = loadData();
                                });
                              } else {
                                log("เริ่มแล้ว$widget.expirationDate");
                                context.read<AppData>().did = day.did;
                                context.read<AppData>().idcourse = coID;

                                log(" DID220:= ${day.sequence - 1}");
                                Get.to(
                                    () => showFood(indexSeq: day.sequence - 1));
                              }
                            },
                            child: (indextoday.isBefore(today))
                                ? Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                        color: Color.fromARGB(255, 255, 124, 2),
                                        borderRadius: BorderRadius.circular(100)
                                        //more than 50% of width makes circle
                                        ),
                                    child: Center(
                                        child: Text(
                                      day.sequence.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                      ),
                                    )),
                                  )
                                : (indextoday.isAfter(today))
                                    ? Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 107, 107, 107),
                                            borderRadius:
                                                BorderRadius.circular(100)
                                            //more than 50% of width makes circle
                                            ),
                                        child: Center(
                                            child: Text(
                                          day.sequence.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                      )
                                    : Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Color.fromARGB(255, 53, 53, 53),
                                            borderRadius:
                                                BorderRadius.circular(100)
                                            //more than 50% of width makes circle
                                            ),
                                        child: Center(
                                            child: Text(
                                          day.sequence.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        )),
                                      ))
                      ],
                    );
                  },
                ),
              ),
            ),
          );
        }
      },
    );
  }

  void _bindPage(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text("คุณต้องการที่จะเริ่มออกกำลังกายหรือไม่",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Text("วันที่เริ่ม $txtdateStart",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("วันที่สิ้นสุด $txtdateEX",
                style: Theme.of(context).textTheme.bodyLarge),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                    child: const Text('ยกเลิก'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      CourseExpiration courseExpiration =
                          CourseExpiration(days: courses.days);

                      log(jsonEncode(courseExpiration));
                      update = await _courseService.updateCourseExpiration(
                          coID.toString(), courseExpiration);
                      moduleResult = update.data;
                      log(moduleResult.result);
                      context.read<AppData>().did = days.first.did;
                      context.read<AppData>().idcourse = coID;
                      log(days.first.did.toString());
                      SmartDialog.dismiss();
                      courses.expirationDate = txtdateEX;
                      log("new widget.expirationDate" + courses.expirationDate);
                      Get.to(() => showFood(indexSeq: days.first.sequence - 1))!
                          .then((value) {
                        log("messageCheak");

                        setState(() {
                          loadDataMethod = loadData();
                        });
                      });
                    },
                    child: const Text('เริ่มเลย'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void dialogCourse(BuildContext ctx) {
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text("กรุณาชำระเงิน",style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Image.asset(
                  "assets/images/delete.png",
                  fit: BoxFit.fill,
                )),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("คุณต้องการที่จะยกเลิกคอร์สใช่หรือไม่",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, right: 10, bottom: 10),
              child: Text(
                  "เมื่อคุณยกเลิกคอร์ส คอร์สจะถูกลบทันทีและไม่มีการคืนเงิน",
                  style: TextStyle(
                    fontSize: 16,
                  )),
            ),

            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color.fromARGB(
                          255, 167, 18, 8), // Background color
                    ),
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                    child: const Text('ยกเลิก',
                        style: TextStyle(fontSize: 16, color: Colors.white)),
                  ),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green, // Background color
                      ),
                      onPressed: () async {
                        SmartDialog.dismiss();
                        var response =
                            await _courseService.deleteCourse(coID.toString());
                        modelResult = response.data;

                        if (modelResult.result == '1') {
                          // ignore: use_build_context_synchronously
                          pushNewScreen(
                            context,
                            screen: const MyCouses(),
                            withNavBar: true,
                          );
                          // ignore: use_build_context_synchronously
                          InAppNotification.show(
                            child: NotificationBody(
                              count: 1,
                              message: 'ลบคอร์สสำเร็จ',
                            ),
                            context: context,
                            onTap: () => print('Notification tapped!'),
                            duration: const Duration(milliseconds: 1500),
                          );
                        } else {
                          // ignore: use_build_context_synchronously
                          InAppNotification.show(
                            child: NotificationBody(
                              count: 1,
                              message: 'ลบคอร์สไม่สำเร็จ',
                            ),
                            context: context,
                            onTap: () => print('Notification tapped!'),
                            duration: const Duration(milliseconds: 1500),
                          );
                        }
                      },
                      child: const Text("ตกลง",
                          style: TextStyle(fontSize: 16, color: Colors.white))),
                ],
              ),
            )
          ],
        ),
      );
    });
  }
}
