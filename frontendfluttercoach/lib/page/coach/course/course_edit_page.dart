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

import '../../../service/provider/dayOfCouseData.dart';
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

  //selectLevel
  final List<String> LevelItems = ['ง่าย', 'ปานกลาง', 'ยาก'];
  String? selectedValue;

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
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text("Edit Course"),
          centerTitle: true,
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SafeArea(
          child: ListView(
            children: [
              FutureBuilder(
                  future: loadDataMethod,
                  builder: (context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //เพิ่มรูป || แสดงรูป

                          Stack(
                            children: [
                              //      const SizedBox(
                              //   height: 18,
                              // ),
                              //     SizedBox(
                              //   width: double.infinity,
                              //   height: MediaQuery.of(context).size.height *0.6,
                              //   child: Container(
                              //     decoration: const BoxDecoration(
                              //         borderRadius: BorderRadius.only(
                              //             topLeft: Radius.circular(20),
                              //             topRight: Radius.circular(20)),
                              //         color: Colors.white),)),
                              inputImage(context),
                            ],
                          ),

                          // Container(
                          //   width: MediaQuery.of(context).size.width ,
                          //   height: double.infinity,
                          //   color: Colors.black, //change your color here
                          // ),
                          const SizedBox(
                            height: 18,
                          ),
                          SizedBox(
                            width: double.infinity,
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
                                        bottom: 8,
                                        top: 28,
                                        left: 13,
                                        right: 13),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              (width - 16 - (3 * padding)) / 2,
                                          child: WidgetTextFieldString(
                                            controller: amount,
                                            labelText: 'จำนวนคน',
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              (width - 16 - (3 * padding)) / 2,
                                          child: WidgetTextFieldString(
                                            controller: days,
                                            labelText: 'จำนวนวัน',
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width:
                                              (width - 16 - (3 * padding)) / 2,
                                          child: WidgetTextFieldString(
                                            controller: price,
                                            labelText: 'ราคา',
                                          ),
                                        ),
                                        SizedBox(
                                          width:
                                              (width - 16 - (3 * padding)) / 2,
                                          child: DropdownButtonFormField2(
                                            decoration: InputDecoration(
                                              //Add isDense true and zero Padding.
                                              //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
                                              isDense: true,
                                              contentPadding: EdgeInsets.zero,
                                              border: OutlineInputBorder(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                              //Add more decoration as you want here
                                              //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
                                            ),
                                            isExpanded: true,
                                            hint: const Text(
                                              'เลือกความยากง่าย',
                                              style: TextStyle(fontSize: 14),
                                            ),
                                            value: selectedValue,
                                            items: LevelItems.map((item) =>
                                                DropdownMenuItem<String>(
                                                  value: item,
                                                  child: Text(
                                                    item,
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                )).toList(),
                                            validator: (value) {
                                              if (value == null) {
                                                return 'Please select Level.';
                                              }
                                              return null;
                                            },
                                            onChanged: (value) {
                                              //Do something when changing the item if you want.
                                            },
                                            onSaved: (value) {
                                              selectedValue = value.toString();
                                            },
                                            buttonStyleData:
                                                const ButtonStyleData(
                                              height: 39,
                                              padding: EdgeInsets.only(
                                                  left: 0, right: 5),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons.arrow_drop_down,
                                                color: Colors.black45,
                                              ),
                                              iconSize: 30,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 8,
                                          top: 8,
                                          left: 13,
                                          right: 13),
                                      child: WidgetTextFieldLines(
                                        controller: details,
                                        labelText: 'รายละเอียด',
                                      )),
                                  // switchOnOffStatus(context),
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      child: buttonNext())
                                ],
                              ),
                            ),
                          ),
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

  Stack inputImage(BuildContext context) {
    return Stack(
      children: [
        if (pickedImg != null) ...{
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1))
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
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.3,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
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
                    border: Border.all(width: 4, color: Colors.white),
                    color: Colors.amber),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }

  ElevatedButton buttonNext() {
    return ElevatedButton(
      //style: style,
      onPressed: () async {
        if (pickedImg != null) await uploadfile();
        if (pickedImg == null) profile = courses.first.image;
        CourseCourseIdPut updateCourseDTO = CourseCourseIdPut(
          name: name.text,
          details: details.text,
          level: '',
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
        //log("rowsAffected:"+updateCourse);
        Get.to(() => const HomePageCoach());
      },
      child: const Text('Next'),
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
    //level.text = courses.first.level;
    if (courses.first.level == '1') {
      selectedValue = LevelItems[0];
    } else if (courses.first.level == '2') {
      selectedValue = LevelItems[1];
    } else if (courses.first.level == '3') {
      selectedValue = LevelItems[2];
    }
    log("selectedValue ${selectedValue}");
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
