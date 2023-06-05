import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:io';



import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:provider/provider.dart';


import '../../../model/request/course_courseID_put.dart';
import '../../../model/response/course_get_res.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';

import '../../../service/provider/appdata.dart';

import '../../../service/provider/dayOfCouseData.dart';
import '../../../widget/wg_textField.dart';
import '../daysCourse/days_course_page.dart';
import '../home_coach_page.dart';

class CourseEditPage extends StatefulWidget {
  late String coID;
  CourseEditPage({super.key, required this.coID});

  @override
  State<CourseEditPage> createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  late CourseService _courseService;
  late Future<void> loadDataMethod;
  List<ModelCourse> courses = [];

  late ModelResult moduleResult;

  bool switchOnOff = false;

  String statusCourse = "";
  String imageCourse = "";
  //Controller
  final name = TextEditingController();
  final details = TextEditingController();
  final level = TextEditingController();
  final amount = TextEditingController();
  final days = TextEditingController();
  final price = TextEditingController();
  int day = 0;
  String status = "";

  //updateCourse
  // ignore: prefer_typing_uninitialized_variables
  var updateCourse;

  Object? get destinations => null;

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = " ";

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย

    _courseService = context.read<AppData>().courseService;
    loadDataMethod = loadDataAsync();
    log(widget.coID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text("Edit Course"),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              FutureBuilder(
                  future: loadDataMethod,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              if (pickedImg != null) ...{
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.cyan),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                          image: FileImage(
                                            File(pickedImg!.path!),
                                          ),
                                          fit: BoxFit.cover)),
                                ),
                              } else
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 3, color: Colors.cyan),
                                      boxShadow: [
                                        BoxShadow(
                                            spreadRadius: 2,
                                            blurRadius: 10,
                                            color:
                                                Colors.black.withOpacity(0.1))
                                      ],
                                      shape: BoxShape.circle,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image:
                                            NetworkImage(courses.first.image),
                                      )),
                                ),
                              Positioned(
                                  bottom: 0,
                                  right: 0,
                                  child: InkWell(
                                    onTap: () {
                                      log("message");
                                      selectImg();
                                    },
                                    child: Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              width: 4, color: Colors.white),
                                          color: Colors.amber),
                                      child: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                      ),
                                    ),
                                  )),
                            ],
                          ),

                          //Expanded(child: Image.network(imageCourse)),
                          WidgetTextFieldString(
                            controller: name,
                            labelText: 'ชื่อ',
                          ),
                          WidgetTextFieldString(
                            controller: details,
                            labelText: 'รายระเอียด',
                          ),
                          WidgetTextFieldString(
                            controller: amount,
                            labelText: 'จำนวนคน',
                          ),
                          WidgetTextFieldString(
                            controller: level,
                            labelText: 'ความยาก',
                          ),
                          WidgetTextFieldString(
                            controller: price,
                            labelText: 'ราคา',
                          ),
                          WidgetTextFieldString(
                            controller: days,
                            labelText: 'จำนวนวัน',
                          ),

                          Column(
                            children: [
                              for (int i = 1; i <= day; i++) ...{
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(20),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      context
                                          .read<DayOfCourseData>()
                                          .didDayOfCouse = i;
                                      Get.to(() => const DaysCoursePage());
                                    },
                                    child: Text('Day $i'),
                                  ),
                                )
                              }
                            ],
                          ),
                          switchOnOffStatus(context),
                          ElevatedButton(
                            //style: style,
                            onPressed: () async {
                              if (pickedImg != null) await uploadfile();
                              if (pickedImg == null) profile = courses.first.image;
                              CourseCourseIdPut updateCourseDTO =
                                  CourseCourseIdPut(
                                name: name.text,
                                details: details.text,
                                level: level.text,
                                amount: int.parse(amount.text),
                                image: profile,
                                days: int.parse(days.text),
                                price: int.parse(price.text),
                                status: status,
                              );
                              log(jsonEncode(updateCourseDTO));
                              log(widget.coID.toString());
                              updateCourse =
                                  await _courseService.updateCourseByCourseID(
                                      widget.coID.toString(), updateCourseDTO);
                              moduleResult = updateCourse.data;
                              log(jsonEncode(moduleResult.result));
                              //log("rowsAffected:"+updateCourse);
                              Get.to(() => const HomePageCoach());
                            },
                            child: const Text('Enabled'),
                          )
                        ],
                      );
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  }),
            ],
          ),
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

  Future<void> loadDataAsync() async {
    try {
      var res =
          await _courseService.course(cid: '', name: '', coID: widget.coID);
      courses = res.data;
      data();
      // name.text = foods.name;
    } catch (err) {
      log('Error: $err');
    }
  }

  void data() {
    name.text = courses.first.name;
    details.text = courses.first.details;
    level.text = courses.first.level;
    amount.text = courses.first.amount.toString();
    price.text = courses.first.price.toString();
    days.text = courses.first.days.toString();
    statusCourse = courses.first.status;
    log("coachId: ${courses.first.coachId}");
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
    // name.text = foods.name;
  }

  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    
    setState(() {
      pickedImg = result.files.first;
    });
  }

  //uploadfile
  Future uploadfile() async {
    final path = 'files/${pickedImg!.name}';
    final file = File(pickedImg!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('link img firebase $urlDownload');
    profile = urlDownload;
  }
}
