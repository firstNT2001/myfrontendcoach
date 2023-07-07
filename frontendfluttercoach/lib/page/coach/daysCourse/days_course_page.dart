import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/day_dayID_put.dart';
import 'package:frontendfluttercoach/model/response/course_get_res.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:frontendfluttercoach/model/response/md_RowsAffected.dart';
import 'package:frontendfluttercoach/model/response/md_days.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/request/course_courseID_put.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/days.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../course/course_edit_page.dart';
import '../home_foodAndClip.dart';

class DaysCoursePage extends StatefulWidget {
  DaysCoursePage({super.key, required this.coID});
  late String coID;
  @override
  State<DaysCoursePage> createState() => _DaysCoursePageState();
}

class _DaysCoursePageState extends State<DaysCoursePage> {
  //Service
  //Days
  late DaysService _daysService;
  late Future<void> loadDaysDataMethod;
  late ModelResult modelResult;
  List<ModelDay> days = [];

  //CourseService / ไว้แก้ไข้วันที่มือเพิ่มหรือลบวัน
  late CourseService _courseService;
  late Future<void> loadCourseDataMethod;
  List<Coachbycourse> course = [];
  //
  bool onVisibles = true;
  bool offVisibles = false;

  //title
  String title = 'Days';

  int sequence = 0;
  int numberOfDays = 0;
  @override
  void initState() {
    super.initState();
    context.read<AppData>().coID = int.parse(widget.coID);

    _daysService = context.read<AppData>().daysService;
    loadDaysDataMethod = loadDaysDataAsync();

    _courseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadCourseDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.penToSquare,
            ),
            onPressed: () {
              setState(() {
                onVisibles = !onVisibles;
                offVisibles = !offVisibles;
              });
              if (offVisibles == true) {
                setState(() {
                  title = 'Edit days';
                });
              } else {
                setState(() {
                  title = 'Days';
                  loadDaysDataMethod = loadDaysDataAsync();
                });
              }
            },
          )
        ],
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: Text(title),
        centerTitle: true,
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: loadDaysDataMethod,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return Column(
                  children: [
                    //edit Day
                    ElevatedButton(onPressed: (){
                      dialogInsertDay(context);
                    }, child: const Text("เพิ่มวัน")),
                    if (offVisibles == true)
                      Expanded(
                        child: Visibility(
                          visible: offVisibles,
                          child: ReorderableListView.builder(
                            shrinkWrap: false,
                            itemCount: days.length,
                            itemBuilder: (context, index) {
                              final listday = days[index];
                              return Padding(
                                key: ValueKey(listday),
                                padding: const EdgeInsets.only(
                                    top: 8, left: 18, right: 18),
                                child: Card(
                                  key: ValueKey(listday),
                                  child: ListTile(
                                    key: ValueKey(listday),
                                    title: Text(listday.sequence.toString()),
                                    subtitle: Text(listday.did.toString()),
                                    trailing: IconButton(
                                        onPressed: () {
                                          dialogDeleteDay(context, listday.did);
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.trash,
                                        )),
                                  ),
                                ),
                              );
                            },
                            onReorder: ((oldIndex, newIndex) =>
                                updateDays(oldIndex, newIndex)),
                          ),
                        ),
                      ),
                    //Not Edit Day
                    if (onVisibles == true)
                      Expanded(
                        child: Visibility(
                          visible: onVisibles,
                          child: Container(
                            padding: const EdgeInsets.only(
                                top: 8, left: 18, right: 18),
                            child: ListView.builder(
                                shrinkWrap: true,
                                itemCount: days.length,
                                itemBuilder: (context, index) {
                                  final listdays = days[index];
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Card(
                                      elevation: 1000,
                                      child: ListTile(
                                        title:
                                            Text(listdays.sequence.toString()),
                                        subtitle: Text(listdays.did.toString()),
                                        trailing: const Icon(Icons.more_vert),
                                        onTap: () {
                                          Get.to(() => HomeFoodAndClipPage(
                                                did: listdays.did.toString(),
                                                sequence: listdays.sequence
                                                    .toString(),
                                              ));
                                        },
                                      ),
                                    ),
                                  );
                                }),
                          ),
                        ),
                      ),
                  ],
                );
              } else {
                return const Center(child: CircularProgressIndicator());
              }
            }),
      ),
    );
  }

  //load
  Future<void> loadDaysDataAsync() async {
    try {
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      days = res.data;
      log("did: ${days.first.foods.length.toString()}");
      // name.text = foods.name;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadCourseDataAsync() async {
    try {
      var res =
          await _courseService.course(coID: widget.coID, cid: '', name: '');
      course = res.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  //updateDay
  void updateDays(int oldIndex, int newIndex) {
    setState(() {
      if (oldIndex < newIndex) {
        newIndex--;
      }

      final listdays = days.removeAt(oldIndex);

      days.insert(newIndex, listdays);
      log("วันใหม่ ${newIndex.toString()}");

      updateDay(days);
    });
  }

  Future<void> updateDay(List<ModelDay> days) async {
    for (int i = 0; i < days.length; i++) {
      //log(days[i].sequence.toString());
      DayDayIdPut request = DayDayIdPut(sequence: i + 1);

      var response =
          await _daysService.updateDayByDayID(days[i].did.toString(), request);
      modelResult = response.data;
      log("${days[i].did.toString()} : ${jsonEncode(request)}");
    }
  }

  //Dialog Delete
  void dialogDeleteDay(BuildContext context, int did) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("คุณต้องการลบหรือไม",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                      },
                      child: const Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () async {
                        SmartDialog.dismiss();
                        startLoading(context);
                        //Delect Day
                        var result =
                            await _daysService.deleteDay(did.toString());
                        modelResult = result.data;

                        setState(() {
                          days.removeWhere((item) => item.did == did);
                        });
                        sequence = 0;
                        log(days.length.toString());
                        for (int i = 0; i < days.length; i++) {
                          DayDayIdPut request = DayDayIdPut(sequence: i + 1);
                          log(jsonEncode(request));
                          var response = await _daysService.updateDayByDayID(
                              days[i].did.toString(), request);
                          modelResult = response.data;
                          //log(modelResult.result);
                          sequence++;
                        }

                        CourseCourseIdPut requestCourse = CourseCourseIdPut(
                            name: course.first.name,
                            details: course.first.details,
                            level: course.first.level,
                            amount: course.first.amount,
                            image: course.first.image,
                            days: sequence,
                            price: course.first.price,
                            status: course.first.status);
                        //log(jsonEncode(requestCourse));
                        var respo = await _courseService.updateCourseByCourseID(
                            widget.coID, requestCourse);
                        modelResult = respo.data;

                        setState(() {
                          loadDaysDataMethod = loadDaysDataAsync();
                        });
                        stopLoading();
                      },
                      child: Text("ตกลง"))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void dialogInsertDay(BuildContext context) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("คุณต้องการเพิ่มวันหรือไม",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                      },
                      child: const Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () async {
                        SmartDialog.dismiss();
                        startLoading(context);
                         sequence = days.length+1;
                         log(sequence.toString());
                         DayDayIdPut request = DayDayIdPut(sequence: sequence);
                         log(jsonEncode(request));
                          var response = await _daysService.insertDayByCourseID(
                              widget.coID, request);

                        modelResult = response.data;
                        log("${modelResult.code} : ${modelResult.result}");

                        CourseCourseIdPut requestCourse = CourseCourseIdPut(
                            name: course.first.name,
                            details: course.first.details,
                            level: course.first.level,
                            amount: course.first.amount,
                            image: course.first.image,
                            days: sequence,
                            price: course.first.price,
                            status: course.first.status);
                        //log(jsonEncode(requestCourse));
                        var respo = await _courseService.updateCourseByCourseID(
                            widget.coID, requestCourse);
                        modelResult = respo.data;

                        setState(() {
                          loadDaysDataMethod = loadDaysDataAsync();
                          sequence = 0;
                        });
                        stopLoading();
                      },
                      child: Text("ตกลง"))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
