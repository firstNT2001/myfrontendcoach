import 'dart:convert';
import 'dart:developer';

import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/chat/chat.dart';
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
import '../../waitingForEdit/chat.dart';
import '../chat/room.dart';

class ShowDayMycourse extends StatefulWidget {
  ShowDayMycourse(
      {super.key,
      required this.coID,
      required this.img,
      required this.namecourse,
      required this.namecoach,
      required this.detail,
      required this.expirationDate,
      required this.dayincourse});
  late int coID;    
  late String img;
  late String namecourse;
  late String namecoach;
  late String detail;
  late String expirationDate;
  late int dayincourse;

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

  DateTime nows = DateTime.now();
  late DateTime today;
  late DateTime expirationDate;
  String txtdateEX = "";
  String txtdateStart = "";
  late String roomchat ;
  var update;
  int coID = 0;
  void initState() {
    // TODO: implement initState
    super.initState();
    coID = context.read<AppData>().idcourse;
    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();

    today = DateTime(nows.year, nows.month, nows.day);
    expirationDate = DateTime(nows.year, nows.month, nows.day + widget.dayincourse-1);
    var formatter = DateFormat.yMMMd();

    var onlyBuddhistYear = nows.yearInBuddhistCalendar;
    txtdateEX = formatter.formatInBuddhistCalendarThai(expirationDate);
    txtdateStart = formatter.formatInBuddhistCalendarThai(nows);
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
          await dayService.day(did: '', coID: widget.coID.toString(), sequence: '');
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
              const SizedBox(
                  height: 35,
                  width: 390,
                  child: Text(
                    "Daily workout",
                    style: TextStyle(fontSize: 25),
                  )),
              Image.network(
                widget.img,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, top: 25),
                child: Row(
                  children: [
                    Text(widget.namecourse,
                        style: Theme.of(context).textTheme.bodyLarge),
                    FilledButton.icon(onPressed: (){
                      //roomchat= widget.namecourse+coID.toString();
                      Get.to(() => ChatPage(roomID: coID.toString(), userID: coID.toString(), firstName: widget.namecourse, roomName: "เผาา",));
                    }, icon: Icon(FontAwesomeIcons.facebookMessenger,size: 16,), label: Text("คุยกับโค้ช"))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, bottom: 8),
                child: Text(widget.namecoach,
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
                    Text(widget.detail, style: Theme.of(context).textTheme.bodyLarge),
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
                              if (widget.expirationDate == "0001-01-01T00:00:00Z") {
                                //log(message);
                                _bindPage(context);
                                log("ยังไม่เริ่ม$widget.expirationDate");
                              } else if( today.day > expirationDate.day){

                                  log("IUIUIU "+today.day.toString());
                                  log("IUIUIU "+expirationDate.day.toString());
                              }else {
                                log("เริ่มแล้ว$widget.expirationDate");
                                log(" DID:= ${listday.did}");
                                context.read<AppData>().did = listday.did;
                                context.read<AppData>().idcourse = coID;

                                Get.to(() =>   showFood(indexSeq: index,));
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
                          CourseExpiration(days: widget.dayincourse);

                      log(jsonEncode(courseExpiration));
                      update = await courseService.updateCourseExpiration(
                          widget.coID.toString(), courseExpiration);
                      moduleResult = update.data;
                      log(moduleResult.result);
                      context.read<AppData>().did = days.first.did;
                      context.read<AppData>().idcourse = coID;
                      log(days.first.did.toString());
                      Get.to(() => showFood(indexSeq: days.first.sequence-1));
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
    void _bindtoReviewPage(BuildContext ctx) {
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
              child: Text("คอร์ส${widget.namecourse}ของคุณได้หมดอายุการใช้งานแล้ว",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            
            Text("กรุณากดปุ่มตกลงเพื่อให้คะแนนตอร์สหลังออกกำลังกายจบคอร์ส",
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
                          CourseExpiration(days: widget.dayincourse);

                      log(jsonEncode(courseExpiration));
                      update = await courseService.updateCourseExpiration(
                          widget.coID.toString(), courseExpiration);
                      moduleResult = update.data;
                      log(moduleResult.result);
                      context.read<AppData>().did = days.first.did;
                      context.read<AppData>().idcourse = coID;
                      log(days.first.did.toString());
                      Get.to(() => showFood(indexSeq: days.first.sequence-1));
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
