import 'dart:convert';
import 'dart:developer';
//import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCourse.dart';
import 'package:provider/provider.dart';

import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class courseEditPage extends StatefulWidget {
  const courseEditPage({super.key});

  @override
  State<courseEditPage> createState() => _courseEditPageState();
}

class _courseEditPageState extends State<courseEditPage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;

  var courses;
  bool switchOnOff = false;
  int coID = 0;
  String statusCourse = "";

  Object? get destinations => null;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    coID = context.read<AppData>().coID;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService.getCourseByCoID(coID.toString()).then((cou) {
      log(cou.data.status);
      statusCourse = cou.data.status;
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
    });

    // 2.2 async method
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              log(courses.data.image);

              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Expanded(child: Image.network(courses.data.image)),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(
                              child: TextField(
                                  decoration: InputDecoration(
                                      labelText: 'Name',
                                      onChange:(){
                                        setState(() {
                                          
                                        });
                                      }
                                      ))),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(child: Text(courses.data.status)),
                        ),
                        switchOnOffStatus(context),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
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
                        onPressed: () => Navigator.pop(context, 'OK'),
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
                        onPressed: () => Navigator.pop(context, 'OK'),
                        child: const Text('OK'),
                      ),
                    ],
                  ));
        }
      },
      value: switchOnOff,
    );
  }

  Future<void> loadData() async {
    try {
      courses = await courseService.getCourseByCoID(coID.toString());
      //log(courses.data.status);
    } catch (err) {
      log('Error: $err');
    }
  }
}
