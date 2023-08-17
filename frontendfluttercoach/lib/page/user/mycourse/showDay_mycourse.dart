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
import '../../../model/response/md_Customer_get.dart';
import '../../../model/response/md_Day_showmycourse.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/customer.dart';
import '../../../service/day.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/notificationBody.dart';
import '../navigationbar.dart';
import '../profilecoach.dart';
import 'mycourse.dart';

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
  late ModelResult modelResult;
  DateTime nows = DateTime.now();
  late DateTime today;
  late DateTime expirationDate;
  String txtdateEX = "";
  String txtdateStart = "";
  late String roomchat;
  var update;
  int coachId=0;

  
  void initState() {
    // TODO: implement initState
    coachId =context.read<AppData>().cid;
    super.initState();
    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();

    today = DateTime(nows.year, nows.month, nows.day);
    expirationDate =
        DateTime(nows.year, nows.month, nows.day + widget.dayincourse - 1);
    var formatter = DateFormat.yMMMd();

    var onlyBuddhistYear = nows.yearInBuddhistCalendar;
    txtdateEX = formatter.formatInBuddhistCalendarThai(expirationDate);
    txtdateStart = formatter.formatInBuddhistCalendarThai(nows);
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
            Get.to(() => ChatPage(
                  roomID: widget.coID.toString() + widget.namecourse,
                  userID: widget.coID.toString(),
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
      body: SafeArea(
        child: ListView(
          children: [
             Padding(
              padding: EdgeInsets.only(left: 15, top: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("DAILY WORKOUT",
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                      IconButton(onPressed: () {
                        dialogCourse(context);
                      }, icon: Icon(FontAwesomeIcons.ellipsisVertical)),
                      
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text("COACHING",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            ),
            Image.network(
              widget.img,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 25, bottom: 8),
              child: Row(
                children: [
                  Text(widget.namecourse,
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                  // FilledButton.icon(onPressed: (){
                  //   //roomchat= widget.namecourse+coID.toString();
                  //   Get.to(() => ChatPage(roomID: coID.toString(), userID: coID.toString(), firstName: widget.namecourse, roomName: "เผาา",));
                  // }, icon: Icon(FontAwesomeIcons.facebookMessenger,size: 16,), label: Text("คุยกับโค้ช"))
                ],
              ),
            ),
            InkWell(
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15, bottom: 10),
                    child: FilledButton.icon(
                        onPressed: () {
                          log("messagecoID"+coachId.toString());
                          pushNewScreen(
                      context,
                      screen: ProfileCoachPage(
                              coachID:coachId,
                            ),
                      withNavBar: true,
                    );
                        },
                        icon: const Icon(
                          FontAwesomeIcons.solidUser,
                          size: 16,
                        ),
                        label: Text(widget.namecoach,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 16))),
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15, bottom: 10),
              child: Text("รายละเอียดคอร์ส",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, bottom: 8, right: 8),
              child: Text(widget.detail,
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("วันที่",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 5, bottom: 30),
              child: loadDay(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var dataday = await dayService.day(
          did: '', coID: widget.coID.toString(), sequence: '');
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
          return Container(
            height: 250,
            decoration: BoxDecoration(
                color: Color.fromARGB(255, 218, 218, 218),
                borderRadius: BorderRadius.circular(20)
                //more than 50% of width makes circle
                ),
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: GridView.count(
                  crossAxisCount: 5,
                  children: days
                      .map((day) => Column(children: [
                            InkWell(
                              onTap: () {
                                if (widget.expirationDate ==
                                    "0001-01-01T00:00:00Z") {
                                  //log(message);
                                  _bindPage(context);
                                  log("ยังไม่เริ่ม$widget.expirationDate");
                                  setState(() {
                                    loadDataMethod = loadData();
                                  });
                                } else if (today.day > expirationDate.day) {
                                  log("IUIUIU " + today.day.toString());
                                  log("IUIUIU " +
                                      expirationDate.day.toString());
                                } else {
                                  log("เริ่มแล้ว$widget.expirationDate");
                                  log(" DID:= ${day.did}");
                                  context.read<AppData>().did = day.did;
                                  context.read<AppData>().idcourse = widget.coID;

                                  Get.to(() => showFood(
                                        indexSeq: day.sequence,
                                      ));
                                }
                                log("day.sequence" + day.sequence.toString());
                              },
                              child: Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                    color: Colors.black,
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
                              ),
                            ),
                            //  Padding(
                            //    padding: const EdgeInsets.all(8.0),
                            //    child: Text(day.sequence.toString()),
                            //  )
                          ]))
                      .toList()),
            ),
          );
          // Card(child: Padding(
          //   padding: const EdgeInsets.all(20),
          //   child: Column(
          //     children: days.map((day) => Container(child: Text(day.sequence.toString()),)).toList(),
          //   ),
          // ),);
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
            Text("วันที่เริ่ม $txtdateEX",
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
                      context.read<AppData>().idcourse = widget.coID;
                      log(days.first.did.toString());
                      SmartDialog.dismiss();
                      Get.to(() => showFood(indexSeq: days.first.sequence - 1));
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
  void dialogCourse(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'คุณต้องการที่จะยกเลิกคอร์สใช่หรือไม่?',
      confirmBtnText: 'ใช่',
      cancelBtnText: 'ไม่',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await courseService.deleteCourse(widget.coID.toString());
        modelResult = response.data;
        Navigator.of(context, rootNavigator: true).pop();
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
    );
  }
}
// ListView(
//             children: [
              
//               Image.network(
//                 widget.img,
//                 height: 200,
//                 width: double.infinity,
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, top: 25),
//                 child: Row(
//                   children: [
//                     Text(widget.namecourse,
//                         style: Theme.of(context).textTheme.bodyLarge),
//                     FilledButton.icon(onPressed: (){
//                       //roomchat= widget.namecourse+coID.toString();
//                       Get.to(() => ChatPage(roomID: coID.toString(), userID: coID.toString(), firstName: widget.namecourse, roomName: "เผาา",));
//                     }, icon: Icon(FontAwesomeIcons.facebookMessenger,size: 16,), label: Text("คุยกับโค้ช"))
//                   ],
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15, bottom: 8),
//                 child: Text(widget.namecoach,
//                     style: Theme.of(context).textTheme.bodyLarge),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 15),
//                 child: Text("รายละเอียดคอร์ส",
//                     style: Theme.of(context).textTheme.bodyLarge),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 17, bottom: 8, right: 8),
//                 child:
//                     Text(widget.detail, style: Theme.of(context).textTheme.bodyLarge),
//               ),
//               Expanded(
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   itemCount: days.length,
//                   itemBuilder: (context, index) {
//                     final listday = days[index];
//                     return Card(
//                       child: ListTile(
//                         title: Row(
//                           children: [
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Text("วันที่",
//                                   style: Theme.of(context).textTheme.bodyLarge),
//                             ),
//                             Padding(
//                               padding: const EdgeInsets.only(top: 4),
//                               child: Text(listday.sequence.toString(),
//                                   style: Theme.of(context).textTheme.bodyLarge),
//                             ),
//                           ],
//                         ),
//                         trailing: ElevatedButton(
//                             onPressed: () { 
//                               if (widget.expirationDate == "0001-01-01T00:00:00Z") {
//                                 //log(message);
//                                 _bindPage(context);
//                                 log("ยังไม่เริ่ม$widget.expirationDate");
//                                 setState(() {
//                                   loadDataMethod = loadData();
//                                 });
//                               } else if( today.day > expirationDate.day){

//                                   log("IUIUIU "+today.day.toString());
//                                   log("IUIUIU "+expirationDate.day.toString());
//                               }else {
//                                 log("เริ่มแล้ว$widget.expirationDate");
//                                 log(" DID:= ${listday.did}");
//                                 context.read<AppData>().did = listday.did;
//                                 context.read<AppData>().idcourse = coID;
                
//                                 Get.to(() =>   showFood(indexSeq: index,));

//                               }
//                             },
//                             child: Text("เริ่ม",
//                                 style: Theme.of(context).textTheme.bodyLarge)),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           );