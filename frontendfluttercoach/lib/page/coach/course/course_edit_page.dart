import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:io';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/request/course_courseID_put.dart';
import '../../../model/response/course_get_res.dart';
import '../../../model/response/md_Result.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';

import '../../../service/provider/appdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../service/provider/dayOfCouseData.dart';
import '../../../widget/wg_dropdown_string.dart';
import '../../../widget/wg_textField.dart';
import '../../../widget/wg_textFieldLines.dart';
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
  List<Coachbycourse> courses = [];

  late ModelResult moduleResult;

  bool switchOnOff = false;

  String statusCourse = "";
  String imageCourse = "";
  //Controller
  final name = TextEditingController();
  final details = TextEditingController();
  final amount = TextEditingController();
  final days = TextEditingController();
  final price = TextEditingController();
  int lavel = 0;
  int day = 0;
  String status = "";

  ///deleteCourse
  late ModelResult modelResult;

  //updateCourse
  // ignore: prefer_typing_uninitialized_variables
  var updateCourse;

  Object? get destinations => null;

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = " ";

  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ง่าย', 'ปานกลาง', 'ยาก'];
  final selectedValue = TextEditingController();

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
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double padding = 8;
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SafeArea(
          child: ListView(
            children: [
              showCourse(width, padding),
            ],
          ),
        ));
  }

  FutureBuilder<void> showCourse(double width, double padding) {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    //เพิ่มรูป || แสดงรูป
                    inputImage(context),

                    const SizedBox(
                      height: 18,
                    ),
                    // TextField

                    Padding(
                      padding: const EdgeInsets.only(top: 250),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height * 0.6,
                        child: Container(
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20)),
                              color: Colors.white),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 8, top: 28, left: 13, right: 13),
                                child: WidgetTextFieldString(
                                  controller: name,
                                  labelText: 'ชื่อ',
                                ),
                              ),

                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (width - 16 - (3 * padding)) / 2,
                                      child: WidgetTextFieldString(
                                        controller: amount,
                                        labelText: 'จำนวนคน',
                                      ),
                                    ),
                                    SizedBox(
                                        width: (width - 16 - (3 * padding)) / 2,
                                        child: TextField(
                                            controller: days,
                                            readOnly: true,
                                            textAlignVertical:
                                                TextAlignVertical.center,
                                            textAlign: TextAlign.center,
                                            decoration: InputDecoration(
                                                labelText: 'จำนวนวัน',
                                                filled: true,
                                                fillColor: Theme.of(context)
                                                    .colorScheme
                                                    .background))),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: (width - 16 - (3 * padding)) / 2,
                                      child: WidgetTextFieldString(
                                        controller: price,
                                        labelText: 'ราคา',
                                      ),
                                    ),
                                    SizedBox(
                                      width: (width - 16 - (3 * padding)) / 2,
                                      child: WidgetDropdownString(
                                        title: 'เลือกความยากง่าย',
                                        selectedValue: selectedValue,
                                        ListItems: LevelItems,
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 8, top: 8, left: 13, right: 13),
                                  child: WidgetTextFieldLines(
                                    controller: details,
                                    labelText: 'รายละเอียด',
                                  )),
                              // switchOnOffStatus(context),
                              SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.6,
                                  child: buttonNext())
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Stack inputImage(BuildContext context) {
    return Stack(
      children: [
        if (pickedImg != null) ...{
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
                //shape: BoxShape.circle,
                image: DecorationImage(
                    image: FileImage(
                      File(pickedImg!.path!),
                    ),
                    fit: BoxFit.cover)),
          ),
        } else
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
                //shape: BoxShape.circle,
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(courses.first.image),
                )),
          ),
        Positioned(
            bottom: 70,
            right: 8,
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
                    border: Border.all(width: 4, color: Colors.white),
                    color: Colors.amber),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Get.to(() => const HomePageCoach());
                  },
                ),
              ),
              CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.trash,
                      color: Colors.black,
                    ),
                    onPressed: () async {
                      var response =
                          await _courseService.deleteCourse(widget.coID);
                      modelResult = response.data;
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  ElevatedButton buttonNext() {
    return ElevatedButton(
      //style: style,
      onPressed: () async {
        log("selectedValue${selectedValue.text}");
        if (selectedValue.text == 'ง่าย') {
          lavel = 1;
        } else if (selectedValue.text == 'ปานกลาง') {
          lavel = 2;
        } else {
          lavel = 3;
        }
        log(selectedValue.text);
        if (pickedImg != null) await uploadfile();
        if (pickedImg == null) profile = courses.first.image;
        CourseCourseIdPut updateCourseDTO = CourseCourseIdPut(
          name: name.text,
          details: details.text,
          level: lavel.toString(),
          amount: int.parse(amount.text),
          image: profile,
          days: int.parse(days.text),
          price: int.parse(price.text),
          status: courses.first.status,
        );
        log(jsonEncode(updateCourseDTO));
        log(widget.coID.toString());
        updateCourse = await _courseService.updateCourseByCourseID(
            widget.coID.toString(), updateCourseDTO);
        moduleResult = updateCourse.data;
        log(jsonEncode(moduleResult.result));

        Get.to(() => DaysCoursePage(
              coID: widget.coID,
            ));
      },
      child: const Text('Next'),
    );
  }

  // Switch switchOnOffStatus(BuildContext context) {
  //   return Switch(
  //     onChanged: (bool value) {
  //       setState(() {
  //         switchOnOff = value;
  //       });
  //       log(switchOnOff.toString());
  //       if (value == true) {
  //         showDialog<String>(
  //             context: context,
  //             builder: (BuildContext context) => AlertDialog(
  //                   title: const Text('เปิดขายคอร์สหรือไม'),
  //                   content: const Text('ต้องการเปิดขายคอร์สหรือไม'),
  //                   actions: <Widget>[
  //                     TextButton(
  //                         child: const Text('Cancel'),
  //                         onPressed: () {
  //                           Navigator.pop(context, 'Cancel');
  //                           setState(() {
  //                             switchOnOff = false;
  //                           });
  //                         }),
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context, 'OK');
  //                         status = "1";
  //                       },
  //                       child: const Text('OK'),
  //                     ),
  //                   ],
  //                 ));
  //       } else if (value == false) {
  //         showDialog<String>(
  //             context: context,
  //             builder: (BuildContext context) => AlertDialog(
  //                   title: const Text('ปิดขายคอร์สหรือไม'),
  //                   content: const Text('ต้องการปิดขายคอร์สหรือไม'),
  //                   actions: <Widget>[
  //                     TextButton(
  //                         child: const Text('Cancel'),
  //                         onPressed: () {
  //                           Navigator.pop(context, 'Cancel');
  //                           setState(() {
  //                             switchOnOff = true;
  //                           });
  //                         }),
  //                     TextButton(
  //                       onPressed: () {
  //                         Navigator.pop(context, 'OK');
  //                         status = "0";
  //                       },
  //                       child: const Text('OK'),
  //                     ),
  //                   ],
  //                 ));
  //       }
  //     },
  //     value: switchOnOff,
  //   );
  // }

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
    //level.text = courses.first.level;
    if (courses.first.level == '1') {
      selectedValue.text = LevelItems[0];
    } else if (courses.first.level == '2') {
      selectedValue.text = LevelItems[1];
    } else if (courses.first.level == '3') {
      selectedValue.text = LevelItems[2];
    }
    log("selectedValue $selectedValue");
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
