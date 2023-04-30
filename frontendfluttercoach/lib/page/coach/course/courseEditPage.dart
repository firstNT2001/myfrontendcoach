import 'dart:convert';
import 'dart:developer';
//import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCourse.dart';
import 'package:frontendfluttercoach/page/coach/homePageCoach.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../../../model/DTO/updateCourseDTO.dart';
import '../../../service/course.dart';

import '../../../service/provider/appdata.dart';
import '../../../service/provider/courseData.dart';
import '../../../service/provider/dayOfCouseData.dart';
import 'dayOfCoursePage.dart';

class CourseEditPage extends StatefulWidget {
  const CourseEditPage({super.key});

  @override
  State<CourseEditPage> createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;

  late HttpResponse<ModelCourse> courses;
  bool switchOnOff = false;
  int coID = 0;
  String statusCourse = "";
  String imageCourse = "";
  //Controller
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _level = TextEditingController();
  final _amount = TextEditingController();
  final _days = TextEditingController();
  final _price = TextEditingController();
  int days = 0;
  String status = "";

  //updateCourse
  var updateCourse;

  Object? get destinations => null;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย

    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // ประกาศตัวแปลลง text
    coID = context.read<CourseData>().coIDCourse;
    _name.text = context.read<CourseData>().nameCourse;
    _details.text = context.read<CourseData>().detailsCourse;
    _level.text = context.read<CourseData>().lavelCourse;
    _amount.text = context.read<CourseData>().amountCourse.toString();
    imageCourse = context.read<CourseData>().imageCourse.toString();
    _days.text = context.read<CourseData>().daysCourse.toString();
    _price.text = context.read<CourseData>().priceCourse.toString();
    statusCourse = context.read<CourseData>().statusCourse;
    days = int.parse(_days.text);
    log("L "+_details.text.length.toString());
    //เช็ค สถานะการเปิดขายของคอร์ส
    status = statusCourse;
    if (statusCourse == "1") {
      //log(courses.data.status);
      log("message");
      setState(() {
        switchOnOff = true;
      });
    }
    if (statusCourse == "0") {
      setState(() {
        switchOnOff = false;
      });
    }
    log("day:" + days.toString());

    // 2.2 async method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              Expanded(child: Image.network(imageCourse)),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 5, right: 5),
                child: Center(child: textField(_name, "ชื่อ")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: TextField(
                    controller: _details,
                    maxLines: 2,
                    onChanged: (String value){
                      setState(() {
                         log("Ls "+_details.text.length.toString());
                      });
                    },
                    decoration: const InputDecoration(
                      labelText: "รายระเอียด",
                      
                    )),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child:  textFieldNumber(_amount, "จำนวนคน"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child:  textFieldNumber(_level, "ความยาก"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child:  textFieldNumber(_price, "ราคา"),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child:  textFieldNumber(_days, "จำนวนวัน"),
              ),

              Column(
                children: [
                  for (int i = 1; i <= days; i++) ...{
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20),
                      child: ElevatedButton(
                        onPressed: () {
                          context.read<DayOfCourseData>().didDayOfCouse = i;
                          Get.to(() => DayOfCoursePage());
                        },
                        child: Text('Day $i'),
                      ),
                    )
                  }
                ],
              ),
              // Padding(
              //   padding: const EdgeInsets.all(50.0),
              //   child: Center(child: Text(courses.data.status)),
              // ),

              switchOnOffStatus(context),
              ElevatedButton(
                //style: style,
                onPressed: () async {
                  UpdateCourse updateCourseDTO = UpdateCourse(
                    coachId: coID,
                    name: _name.text,
                    details: _details.text,
                    level: _level.text,
                    amount: int.parse(_amount.text),
                    image: imageCourse,
                    days: int.parse(_days.text),
                    price: int.parse(_price.text),
                    status: status,
                  );
                  log(jsonEncode(updateCourseDTO));
                  updateCourse =
                      await courseService.updateCourse(updateCourseDTO);

                  //log("rowsAffected:"+updateCourse);
                  Get.to(() => const HomePageCoach());
                },
                child: const Text('Enabled'),
              ),
            ],
          ),
        ),
      ],
    )));
  }

  Center textFieldNumber(
      // ignore: no_leading_underscores_for_local_identifiers
      final TextEditingController _controller,
      String textLabel) {
    return Center(
        child: TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: textLabel,
            )));
  }

  TextField textField(
      final TextEditingController _controller, String textLabel) {
    return TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: textLabel,
        ));
  }

  Switch switchOnOffStatus(BuildContext context) {
    return Switch(
      onChanged: (bool value) {
        setState(() {
          switchOnOff = value;
        });
        log(switchOnOff.toString());
        if (value == true) {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('เปิดขายคอร์สหรือไม'),
                    content: const Text('ต้องการเปิดขายคอร์สหรือไม'),
                    actions: <Widget>[
                      TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                            setState(() {
                              switchOnOff = false;
                            });
                          }),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          status = "1";
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        } else if (value == false) {
          showDialog<String>(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                    title: const Text('ปิดขายคอร์สหรือไม'),
                    content: const Text('ต้องการปิดขายคอร์สหรือไม'),
                    actions: <Widget>[
                      TextButton(
                          child: const Text('Cancel'),
                          onPressed: () {
                            Navigator.pop(context, 'Cancel');
                            setState(() {
                              switchOnOff = true;
                            });
                          }),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, 'OK');
                          status = "0";
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        }
      },
      value: switchOnOff,
    );
  }
}
