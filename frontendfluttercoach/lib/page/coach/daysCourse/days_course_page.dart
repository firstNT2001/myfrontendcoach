import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/day_dayID_put.dart';

import 'package:frontendfluttercoach/model/response/md_Result.dart';

import 'package:frontendfluttercoach/model/response/md_days.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../model/request/course_courseID_put.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/days.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dialogs.dart';
import '../course/FoodAndClip/course_food_clip.dart';

class DaysCoursePage extends StatefulWidget {
  const DaysCoursePage(
      {super.key, required this.coID, required this.isVisible});
  final String coID;
  final bool isVisible;
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
  List<Course> course = [];
  //
  bool onVisibles = true;
  bool offVisibles = false;

  //title
  String title = 'Days';

  int sequence = 0;
  int numberOfDays = 0;

  bool _enabled = true;

  @override
  void initState() {
    super.initState();
    context.read<AppData>().coID = int.parse(widget.coID);

    _daysService = context.read<AppData>().daysService;
    loadDaysDataMethod = loadDaysDataAsync();

    _courseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadCourseDataAsync();
    Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
      setState(() {
        _enabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.calendarPlus,
              color: Colors.black,
            ),
            onPressed: () {
              dialogInsertDay(context);
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
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Expanded(child: showDays()),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> showDays() {
    return FutureBuilder(
        future: loadDaysDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          return (_enabled)
              ? Skeletonizer(
                  textBoneBorderRadius:
                      TextBoneBorderRadius.fromHeightFactor(.10),
                  enabled: true,
                  ignoreContainers: false,
                  child: gridViewDays(context),
                )
              : gridViewDays(context);
        });
  }

  ReorderableGridView gridViewDays(BuildContext context) {
    return ReorderableGridView.builder(
      itemCount: days.length,
      itemBuilder: (context, index) {
        final listday = days[index];
        index = index + 1;
        return Card(
          color: Colors.white,
          key: ValueKey(index),
          child: InkWell(
              onTap: () {
                Get.to(() => HomeFoodAndClipPage(
                      did: listday.did.toString(),
                      sequence: index.toString(),
                      isVisible: widget.isVisible,
                    ));
              },
              child: Center(child: Text(index.toString()))),
        );
      },
      onReorder: (oldIndex, newIndex) {
        startLoading(context);
        setState(() {
          setState(() {
            final element = days.removeAt(oldIndex);
            days.insert(newIndex, element);
          });
        });
        updateDay(days);

        //  updateDays(oldIndex, newIndex);
        // loadDaysDataMethod = loadDaysDataAsync();
      },
      dragWidgetBuilder: (index, child) {
        return Card(
          color: Theme.of(context).colorScheme.primary,
          child: Text(index.toString()),
        );
      },
      onDragStart: (index) {
        log("onDragStart: $index");
      },
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5, mainAxisExtent: 65),
    );
  }

  //load
  Future<void> loadDaysDataAsync() async {
    try {
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      days = res.data;
      log("did: ${days.length.toString()}");
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

  Future<void> updateDay(List<ModelDay> days) async {
    for (int i = 0; i < days.length; i++) {
      //log(days[i].sequence.toString());
      DayDayIdPut request = DayDayIdPut(sequence: i + 1);

      var response =
          await _daysService.updateDayByDayID(days[i].did.toString(), request);
      modelResult = response.data;
      log("${days[i].did.toString()} : ${jsonEncode(request)}");
    }
    stopLoading();
    success(context);
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
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to add a day?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        Navigator.of(context, rootNavigator: true).pop();
        startLoading(context);
        sequence = days.length + 1;
        log(sequence.toString());
        DayDayIdPut request = DayDayIdPut(sequence: sequence);
        log(jsonEncode(request));
        var response =
            await _daysService.insertDayByCourseID(widget.coID, request);

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

        log('onConfirmBtnTap');
      },
    );
  }
}
