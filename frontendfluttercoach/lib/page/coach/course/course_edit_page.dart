import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../model/request/course_courseID_put.dart';

import '../../../model/response/md_Result.dart';
import '../../../model/response/md_Review_get.dart';
import '../../../model/response/md_coach_course_get.dart';

import '../../../service/course.dart';

import '../../../service/provider/appdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../widget/dialogs.dart';
import '../../../widget/dropdown/wg_dropdown_string.dart';

import '../../../widget/notificationBody.dart';
import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int copy.dart';
import '../daysCourse/days_course_page.dart';
import '../navigationbar.dart';
import 'course_show.dart';

class CourseEditPage extends StatefulWidget {
  const CourseEditPage(
      {super.key, required this.coID, required this.isVisible});

  final String coID;
  final bool isVisible;
  @override
  State<CourseEditPage> createState() => _CourseEditPageState();
}

class _CourseEditPageState extends State<CourseEditPage> {
  //Service
  //CourseService
  late CourseService _courseService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];

  late ModelResult moduleResult;

  //Review
  // late ReviewService _reviewService;
  List<ModelReview> modelReviews = [];

  var sumAVG = 5.0;

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

  String textErr = "";

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    // _reviewService = context.read<AppData>().reviewService;
    _courseService = context.read<AppData>().courseService;
    loadDataMethod = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    //double height = (screenSize.height > 550) ? 550 : screenSize.height;
    double padding = 8;
    return Scaffold(
        //resizeToAvoidBottomInset: false,
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
            return Stack(
              children: [
                //เพิ่มรูป || แสดงรูป
                inputImage(context),
                Positioned(child: showText(context, width, padding)),
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  Padding showText(BuildContext context, double width, double padding) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -7),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(5, 0),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(-5, 0),
              )
            ],
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
                  SizedBox(
                      width: (width - 16 - (3 * padding)) / 2,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          const Text('จำนวนวัน'),
                          Text(days.text),
                        ],
                      )),
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
                      padding: const EdgeInsets.only(right: 15),
                      child: WidgetDropdownString(
                        title: 'เลือกความยากง่าย',
                        selectedValue: selectedValue,
                        listItems: LevelItems,
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
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 20, right: 23),
                  child: Text(
                    textErr,
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.error),
                  ),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 13, right: 13),
                child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: buttonNext()),
              ),
            )
          ],
        ),
      ),
    );
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.chevronLeft,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                ShowCourse(coID: widget.coID)),
                        ModalRoute.withName('/NavbarBottomCoach'),
                      );
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                ),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.trash,
                      ),
                      onPressed: () {
                        dialogCourse(context);
                      },
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  FilledButton buttonNext() {
    return FilledButton(
      //style: style,
      onPressed: () async {
        if (widget.isVisible == true) {
          if (selectedValue.text == 'ง่าย') {
            lavel = 1;
          } else if (selectedValue.text == 'ปานกลาง') {
            lavel = 2;
          } else {
            lavel = 3;
          }
          if (name.text == '' ||
              details.text == '' ||
              lavel.toString() == '' ||
              amount.text == '' ||
              price.text == '') {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
            log(textErr);
          } else {
            setState(() {
              textErr = '';
            });
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
            if (moduleResult.result == '0') {
              // ignore: use_build_context_synchronously
              context.read<AppData>().img = courses.first.image;
              Get.to(() => DaysCoursePage(
                    coID: widget.coID,
                    isVisible: widget.isVisible,
                  ));
            } else {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขสำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 1500),
              );
              Get.to(() => DaysCoursePage(
                    coID: widget.coID,
                    isVisible: widget.isVisible,
                  ));
            }
          }
        }
      },
      child: const Text('Next'),
    );
  }

  //LoadData
  Future<void> loadDataAsync() async {
    try {
      var res =
          await _courseService.course(cid: '', name: '', coID: widget.coID);
      courses = res.data;
      data();
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
    log(courses.first.days.toString());
    // name.text = foods.name;
  }

  //Image
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

  //Dialog Delete
  void dialogCourse(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _courseService.deleteCourse(widget.coID);
        modelResult = response.data;
        Navigator.of(context, rootNavigator: true).pop();
        if (modelResult.result == '1') {
          // ignore: use_build_context_synchronously
          Navigator.pushAndRemoveUntil<void>(
            context,
            MaterialPageRoute<void>(
                builder: (BuildContext context) => NavbarBottomCoach()),
            ModalRoute.withName('/'),
          );
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบคอร์สสำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        } else {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบคอร์สไม่สำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
    );
  }
}