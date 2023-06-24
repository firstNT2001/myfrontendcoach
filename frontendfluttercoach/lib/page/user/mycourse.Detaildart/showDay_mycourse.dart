
import 'dart:convert';
import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontendfluttercoach/page/user/mycourse.Detaildart/showFood_Clip.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../model/request/course_EX.dart';
import '../../../model/response/md_Day_showmycourse.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/day.dart';
import '../../../service/provider/appdata.dart';

class ShowDayMycourse extends StatefulWidget {
  const ShowDayMycourse({super.key});

  @override
  State<ShowDayMycourse> createState() => _ShowDayMycourseState();
}

class _ShowDayMycourseState extends State<ShowDayMycourse> {
  late ModelResult moduleResult;
  late DayService dayService;
  late CourseService courseService;
  // late HttpResponse<ModelCourse> courses;
  List<DayDetail> days = [];
  late Future<void> loadDataMethod;
  int coID = 0;
  String img = "";
  String namecourse = "";
  String namecoach = "";
  String detail = "";
  String expirationDate = "";
  DateTime nows = DateTime.now();
  String dateEX = "";
  String dateStart = "";
  int dayincourse = 0;
  var update;
  void initState() {
    // TODO: implement initState
    super.initState();
    coID = context.read<AppData>().idcourse;
    img = context.read<AppData>().img;
    namecourse = context.read<AppData>().namecourse;
    namecoach = context.read<AppData>().namecoach;
    detail = context.read<AppData>().detail;
    expirationDate = context.read<AppData>().exdate;
    dayincourse = context.read<AppData>().day;

    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService = CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();

    DateTime date = DateTime(nows.year, nows.month, nows.day + dayincourse);

    var formatter = DateFormat.yMMMd();

    var onlyBuddhistYear = nows.yearInBuddhistCalendar;
    dateEX = formatter.formatInBuddhistCalendarThai(date);
    dateStart = formatter.formatInBuddhistCalendarThai(nows);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          //loadCourse(),
          Expanded(child: loadDay())
        ],
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var dataday =
          await dayService.day(did: '', coID: coID.toString(), sequence: '');
      days = dataday.data;
      log('couse: ${days.length}');
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
          return ListView(
            children: [
              SizedBox(
                  height: 35,
                  width: 390,
                  child: Text(
                    "Daily workout",
                    style: TextStyle(fontSize: 25),
                  )),
              Image.network(
                img,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Text(namecourse,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 8),
                child: Text(namecoach,
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: Text("รายละเอียดคอร์ส",
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 17, bottom: 8, right: 8),
                child:
                    Text(detail, style: Theme.of(context).textTheme.bodyLarge),
              ),
              Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: days.length,
                  itemBuilder: (context, index) {
                    final listday = days[index];
                    return Card(
                      child: ListTile(
                        title: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("วันที่",
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(listday.sequence.toString(),
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                          ],
                        ),
                        trailing: ElevatedButton(
                            onPressed: () {
                              if (expirationDate == "0001-01-01T00:00:00Z") {
                                //log(message);
                                _bindPage(context);
                                log("ยังไม่เริ่ม$expirationDate");
                               
                              } else {
                                log("เริ่มแล้ว$expirationDate");
                                log(" DID:= ${listday.did}");
                                context.read<AppData>().did = listday.did;
                                Get.to(() => const showFood());
                              }
                            },
                            child: Text("เริ่ม",
                                style: Theme.of(context).textTheme.bodyLarge)),
                      ),
                    );
                  },
                ),
              ),
            ],
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
            Text("วันที่เริ่ม $dateStart",
                style: Theme.of(context).textTheme.bodyLarge),
            Text("วันที่เริ่ม $dateEX",
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
                                    CourseExpiration(days: dayincourse);
                                
                                log(jsonEncode(courseExpiration));
                                update =
                                    await courseService.updateCourseExpiration(
                                        coID.toString(), courseExpiration);
                                moduleResult = update.data;
                                log(moduleResult.result);
                                context.read<AppData>().did = days.first.did;
                      Get.to(() => const showFood());
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
}
