import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../model/request/course_coachID_post.dart';

import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../service/provider/coachData.dart';

class CourseNewPage extends StatefulWidget {
  const CourseNewPage({super.key});

  @override
  State<CourseNewPage> createState() => _CourseNewPageState();
}

class _CourseNewPageState extends State<CourseNewPage> {
  late CourseService courseService;
  late ModelResult moduleResult;
  int cid = 0;
  String image = "_";
  String status = "1";
  bool switchOnOff = true;
  // String expirationDate = "";
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _level = TextEditingController();
  final _amount = TextEditingController();
  final _days = TextEditingController();
  final _price = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var insertCourse;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    cid = context.read<CoachData>().cid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                //Expanded(child: Image.network(imageCourse)),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                  child: Center(child: textField(_name, "ชื่อ")),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: Center(child: textField(_details, "รายละเอียด")),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  // child: Center(child: textField(_amount, "จำนวนคน")),
                  child: textFieldNumber(_amount, "จำนวนคน"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: textFieldNumber(_level, "ความยาก"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: textFieldNumber(_price, "ราคา"),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: textFieldNumber(_days, "จำนวนวัน"),
                ),
                switchOnOffStatus(context),
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                  child: ElevatedButton(
                    //style: style,
                    onPressed: () async {
                      CourseCoachIdPost courseCoachIdPost = CourseCoachIdPost(
                          bid: null,
                          name: _name.text,
                          details: _details.text,
                          level: _level.text,
                          amount: int.parse(_amount.text),
                          image: image,
                          days: int.parse(_days.text),
                          price: int.parse(_price.text),
                          status: status,
                          expirationDate: null);
                      log(jsonEncode(courseCoachIdPost));
                      insertCourse = await courseService.insetCourseByCoachID(
                          cid.toString(), courseCoachIdPost);
                      moduleResult = insertCourse.data;
                      log(jsonEncode(moduleResult.result));
                      if (moduleResult.result == "1") {
                        // ignore: use_build_context_synchronously
                        showDialogRowsAffected(context, "บันทึกสำเร็จ");
                      } else {
                        // ignore: use_build_context_synchronously
                        showDialogRowsAffected(context, "บันทึกไม่สำเร็จ");
                      }
                    },
                    child: const Text('Enabled'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<String?> showDialogRowsAffected(BuildContext context, String name) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(name),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
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
      // ignore: no_leading_underscores_for_local_identifiers
      final TextEditingController _controller,
      String textLabel) {
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
