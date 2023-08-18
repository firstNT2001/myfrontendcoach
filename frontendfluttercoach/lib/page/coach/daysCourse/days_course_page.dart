import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/day_dayID_put.dart';

import 'package:frontendfluttercoach/model/response/md_Result.dart';

import 'package:frontendfluttercoach/model/response/md_days.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';

import '../../../model/request/course_courseID_put.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/days.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/notificationBody.dart';
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
  bool isVisibleQuickAlert = true;
  bool moveIsVisible = false;
  Color moveDayColor = Colors.black;
  //title
  String title = 'Days';

  int sequence = 0;
  int numberOfDays = 0;

  List<Color> cardColors = [];

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
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: showDays()),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> showDays() {
    return FutureBuilder(
        future: loadDaysDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: load(context));
          } else {
            return gridViewDays(context);
          }
        });
  }

  gridViewDays(BuildContext context) {
    return Stack(
      children: [
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
              decoration: BoxDecoration(
                  //borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                        spreadRadius: 2,
                        blurRadius: 10,
                        color: Colors.black.withOpacity(0.1))
                  ],
                  // shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(context.read<AppData>().img),
                  )),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(178, 220, 219, 219),
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.chevronLeft,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: widget.isVisible,
                    child: CircleAvatar(
                        backgroundColor:
                            const Color.fromARGB(178, 220, 219, 219),
                        radius: 20,
                        child: IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.calendarPlus,
                          ),
                          onPressed: () {
                            dialogInsertDay(context);
                          },
                        )),
                  ),
                ],
              ),
            ),
          ],
        ),
        reorderableGridView(context),
      ],
    );
  }

  reorderableGridView(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 15,
                offset: const Offset(0, -7),
              ),
            ],
            color: Colors.white),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Text(
                    'วันออกกำลังกาย',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                  child: Column(
                    children: [
                      IconButton(
                          onPressed: () {
                            setState(() {
                              moveIsVisible = !moveIsVisible;
                            });
                            if (moveIsVisible == true) {
                              moveDayColor =
                                  Theme.of(context).colorScheme.primary;
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'เคลื่อนย้ายวัน / เปิด',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 1500),
                              );
                            } else {
                              moveDayColor = Colors.black;
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'เคลื่อนย้ายวัน / ปิด',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 1500),
                              );
                            }
                            log(moveIsVisible.toString());
                          },
                          icon: Icon(
                            FontAwesomeIcons.compress,
                            color: moveDayColor,
                          )),
                      const Text('Move Day')
                    ],
                  ),
                )
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, right: 20, left: 20),
                child: ReorderableGridView.builder(
                  itemCount: days.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4, mainAxisExtent: 65),
                  itemBuilder: (context, index) {
                    final listday = days[index];
                    int i = index + 1;
                    return (moveIsVisible == false)
                        ? PopupMenuButton(
                            key: ValueKey(index),
                            color: Colors.white,
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15.0))),
                            offset: const Offset(0, 65),
                            onOpened: () {
                              setState(() {
                                cardColors[index] =
                                    Theme.of(context).colorScheme.primary;
                              });
                            },
                            onCanceled: () {
                              setState(() {
                                cardColors[index] =
                                    Theme.of(context).colorScheme.tertiary;
                              });
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 1,
                                child: Row(
                                  children: [
                                    Icon(FontAwesomeIcons.pen),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text('แก้ไข'),
                                  ],
                                ),
                              ),
                              const PopupMenuItem(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(FontAwesomeIcons.trash),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text('ลบ'),
                                    ],
                                  )),
                            ],
                            onSelected: (value) {
                              if (value == 1) {
                                setState(() {
                                  cardColors[index] =
                                      Theme.of(context).colorScheme.tertiary;
                                });
                                Get.to(() => HomeFoodAndClipPage(
                                      did: listday.did.toString(),
                                      sequence: i.toString(),
                                      isVisible: widget.isVisible,
                                    ));
                              } else {
                                dialogDeleteDay(context, listday.did);
                                setState(() {
                                  cardColors[index] =
                                      Theme.of(context).colorScheme.tertiary;
                                });
                              }
                            },
                            child: cardText(index, i, context),
                          )
                        : InkWell(
                            key: ValueKey(index),
                            onTap: () {
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'กรุณากดค้างที่วัน',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 1500),
                              );
                            },
                            child: cardText(index, i, context));
                  },
                  //onDragUpdate: (){},
                  onReorder: (oldIndex, newIndex) {
                    startLoading(context);
                    setState(() {
                      setState(() {
                        final element = days.removeAt(oldIndex);
                        days.insert(newIndex, element);
                      });
                    });
                    updateDay(days);
                  },
                  dragWidgetBuilder: (index, child) {
                    int i = index + 1;
                    return Container(
                      key: ValueKey(index),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(child: Text(i.toString())),
                    );
                  },
                  onDragStart: (index) {
                    log("onDragStart: $index");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Padding cardText(int index, int i, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      key: ValueKey(index),
      child: Container(
        key: ValueKey(index),
        decoration: BoxDecoration(
          color: cardColors[index],
          shape: BoxShape.circle,
        ),
        child: Center(
            child: Text(
          i.toString(),
          style: Theme.of(context)
              .textTheme
              .titleMedium!
              .copyWith(color: Colors.white),
        )),
      ),
    );
  }

  //load
  Future<void> loadDaysDataAsync() async {
    try {
      log(widget.coID);
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      days = res.data;
      log("did: ${days.length.toString()}");
      for (int i = 0; i < days.length; i++) {
        cardColors.add(Theme.of(context).colorScheme.tertiary);
      }
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

    // ignore: use_build_context_synchronously
    InAppNotification.show(
      child: NotificationBody(
        count: 1,
        message: 'เคลื่อนย้ายวันสำเร็จ',
      ),
      context: context,
      onTap: () => print('Notification tapped!'),
      duration: const Duration(milliseconds: 1500),
    );
  }

  //Dialog Delete
  void dialogDeleteDay(BuildContext context, int did) {
    QuickAlert.show(
      context: context,
      barrierDismissible: isVisibleQuickAlert,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        Navigator.of(context, rootNavigator: true).pop();
        startLoading(context);
        //Delect Day
        var result = await _daysService.deleteDay(did.toString());
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
        stopLoading();
        if (modelResult.result == '1') {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบวันเรียบร้อยแล้ว',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
          setState(() {
            loadDaysDataMethod = loadDaysDataAsync();
          });
        } else {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบวันไม่สำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
    );
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
        // ignore: use_build_context_synchronously
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'ได้เพิ่มวันเรียบร้อยแล้ว',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
      },
    );
  }
}
