import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../../model/request/course_coachID_post.dart';

import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dropdown/wg_dropdown_notValue_string.dart';

import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';

import '../../../widget/textField/wg_textField_int copy.dart';
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

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = "";

  String statusCourse = "";
  String imageCourse = "";

  String textErr = '';

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
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                inputImage(context),
                Positioned(
                  child: Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).size.height / 3),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          color: Colors.white),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 28,
                          ),
                          WidgetTextFieldString(
                            controller: name,
                            labelText: 'ชื่อ',
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: WidgetTextFieldInt(
                                    controller: amount,
                                    labelText: 'จำนวนคน',
                                    maxLength: 2,
                                  ),
                                ),
                                Expanded(
                                  child: WidgetTextFieldInt(
                                    controller: days,
                                    labelText: 'จำนวนวัน',
                                    maxLength: 2,
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
                                Expanded(
                                  child: WidgetTextFieldInt(
                                    controller: price,
                                    labelText: 'ราคา',
                                    maxLength: 5,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        right: 15, left: 15),
                                    child: WidgetDropdownStringNotValue(
                                      title: 'เลือกความยากง่าย',
                                      selectedValue: selectedValue,
                                      ListItems: LevelItems,
                                      //listItems: LevelItems,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          WidgetTextFieldLines(
                            controller: details,
                            labelText: 'รายละเอียด',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 0, left: 20, right: 23),
                                child: Text(
                                  textErr,
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error),
                                ),
                              ),
                            ],
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 18, left: 20, right: 20),
                              child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: button()),
                            ),
                          ),
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

  FilledButton button() {
    return FilledButton(
      //style: style,
      onPressed: () async {
        if (name.text.isEmpty ||
            details.text.isEmpty ||
            lavel.toString().isEmpty ||
            amount.text.isEmpty ||
            days.text.isEmpty ||
            price.text.isEmpty) {
          setState(() {
            textErr = 'กรุณากรอกข้อมูลให้ครบ';
          });
        }  else {
          log("selectedValue${selectedValue.text}");
          if (selectedValue.text == 'ง่าย') {
            lavel = 1;
          } else if (selectedValue.text == 'ปานกลาง') {
            lavel = 2;
          } else {
            lavel = 3;
          }
          log(selectedValue.text);
         // if (pickedImg != null) await uploadfile();
          //if (pickedImg == null) profile = courses.first.image;
          CourseCoachIdPost request = CourseCoachIdPost(
              bid: null,
              name: name.text,
              details: details.text,
              level: lavel.toString(),
              amount: int.parse(amount.text),
              image: 'profile',
              days: int.parse(days.text),
              price: int.parse(price.text),
              status: status,
              expirationDate: null);
          log(jsonEncode(request));
          log(cid.toString());
          var response =
              await courseService.insetCourseByCoachID(cid.toString(), request);
          moduleResult = response.data;
          log(moduleResult.result);
          if (moduleResult.result == '0') {
            // ignore: use_build_context_synchronously
            warning(context);
          } else {
            // ignore: use_build_context_synchronously
            success(context);
            Get.to(() => DaysCoursePage(
                  coID: moduleResult.result,
                  isVisible: true,
                ));
          }
        }
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
                      "https://meetmore.net/wp-content/uploads/2020/10/%E0%B8%AD%E0%B8%AD%E0%B8%81%E0%B8%81%E0%B8%B3%E0%B8%A5%E0%B8%B1%E0%B8%87%E0%B8%81%E0%B8%B2%E0%B8%A2%E0%B9%84%E0%B8%A1%E0%B9%88%E0%B8%A1%E0%B8%B5%E0%B9%80%E0%B8%AB%E0%B8%87%E0%B8%B7%E0%B9%88%E0%B8%AD-%E0%B8%88%E0%B8%B0%E0%B8%8A%E0%B9%88%E0%B8%A7%E0%B8%A2%E0%B9%80%E0%B8%9C%E0%B8%B2%E0%B8%9E%E0%B8%A5%E0%B8%B2%E0%B8%8D%E0%B9%84%E0%B8%AB%E0%B8%A1.png"),
                )),
          ),
        Positioned(
            bottom: 60,
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
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.shade600,
                          spreadRadius: 1,
                          blurRadius: 15)
                    ],
                    shape: BoxShape.circle,
                    //border: Border.all(width: 4, color: Colors.white),
                    color: Colors.white),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.black,
                ),
              ),
            )),
      ],
    );
  }

  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
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
