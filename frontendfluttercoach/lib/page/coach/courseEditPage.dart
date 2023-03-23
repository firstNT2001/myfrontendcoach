import 'dart:convert';
import 'dart:developer';
//import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCourse.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../../service/course.dart';
import '../../service/provider/appdata.dart';

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

  //Controller
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _level = TextEditingController();
  final _amount = TextEditingController();
  //final _image = TextEditingController();
  final _day = TextEditingController();
  final _price = TextEditingController();

  Object? get destinations => null;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    coID = context.read<AppData>().coID;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService.getCourseByCoID(coID.toString()).then((cou) {
      // log(cou.data.status);

      //เช็ค สถานะการเปิดขายของคอร์ส
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
      // ประกาศตัวแปลลง text
      _name.text = cou.data.name;
      _details.text = cou.data.details;
      _level.text = cou.data.level;
      _amount.text = cou.data.amount.toString();
      _day.text = cou.data.days.toString();
      _price.text = cou.data.price.toString();
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
              log(courses.data.name);
              return Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        //Expanded(child: Image.network(courses.data.image)),
                        Padding(
                          padding: const EdgeInsets.all(50.0),
                          child: Center(child: textField(_name,"ชื่อ")),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Center(child: textField(_details,"รายละเอียด")),
                        ),
                        // Padding(
                        //   padding: const EdgeInsets.all(50.0),
                        //   child: Center(child: Text(courses.data.status)),
                        // ),
                        switchOnOffStatus(context),
                        ElevatedButton(
                          //style: style,
                          onPressed: () {
                            log(_name.text);
                          },
                          child: const Text('Enabled'),
                        ),
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

  TextField textField(final TextEditingController _controller,String textLabel) {
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
