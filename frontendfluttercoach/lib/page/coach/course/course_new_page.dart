import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/home_coach_page.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../../model/request/course_coachID_post.dart';

import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/wg_dropdown_notValue_string.dart';
import '../../../widget/wg_dropdown_string.dart';
import '../../../widget/wg_textField.dart';
import '../../../widget/wg_textFieldLines.dart';
import '../daysCourse/days_course_page.dart';

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

  //Controller
  final name = TextEditingController();
  final details = TextEditingController();
  final amount = TextEditingController();
  final days = TextEditingController();
  final price = TextEditingController();
  int lavel = 0;
  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ง่าย', 'ปานกลาง', 'ยาก'];
  final selectedValue = TextEditingController();

  // ignore: prefer_typing_uninitialized_variables
  var insertCourse;

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = " ";

  String statusCourse = "";
  String imageCourse = "";
  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();

    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    cid = context.read<AppData>().cid;
    log(cid.toString());
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double padding = 8;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                inputImage(context),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                  child: WidgetDropdownStringNotValue(
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
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: buttonNext())
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
        //if (pickedImg == null) profile = courses.first.image;
        CourseCoachIdPost courseCoachIdPost = CourseCoachIdPost(
            bid: null,
            name: name.text,
            details: details.text,
            level: lavel.toString(),
            amount: int.parse(amount.text),
            image: profile,
            days: int.parse(days.text),
            price: int.parse(price.text),
            status: status,
            expirationDate: null);
        log(jsonEncode(courseCoachIdPost));
        insertCourse = await courseService.insetCourseByCoachID(
            cid.toString(), courseCoachIdPost);
        moduleResult = insertCourse.data;
        log(moduleResult.result);
        // if (moduleResult.result == "1") {
        //   // ignore: use_build_context_synchronously
        //   //showDialogRowsAffected(context, "บันทึกสำเร็จ");
        //   Get.to(() => const HomePageCoach());
        // } else {
        //   // ignore: use_build_context_synchronously
        //   //showDialogRowsAffected(context, "บันทึกไม่สำเร็จ");
        // }

         Get.to(() => DaysCoursePage(
              coID: moduleResult.result,
            ));
      },
      child: const Text('Next'),
    );
  }

  // Image
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
                // shape: BoxShape.circle,
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
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://www.finearts.cmu.ac.th/wp-content/uploads/2021/07/blank-profile-picture-973460_1280-1.png"),
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
              // CircleAvatar(
              //     backgroundColor: Colors.white,
              //     radius: 20,
              //     child: IconButton(
              //       icon: const Icon(
              //         FontAwesomeIcons.trash,
              //         color: Colors.black,
              //       ),
              //       onPressed: () async {
              //         var response =
              //             await _courseService.deleteCourse(widget.coID);
              //         modelResult = response.data;
              //       },
              //     )),
            ],
          ),
        ),
      ],
    );
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
