import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../model/request/course_coachID_post.dart';

import '../../../model/response/md_Result.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dropdown/wg_dropdown_notValue_string.dart';

import '../../../widget/notificationBody.dart';
import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';

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
  String status = "0";
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
  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();

  bool isValid = true;

  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    // ignore: avoid_print
    log('Dispose used');
    super.dispose();
  }

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
                          const SizedBox(
                            height: 28,
                          ),
                          WidgetTextFieldString(
                            controller: name,
                            labelText: 'ชื่อ',
                          ),
                          Form(
                            key: _formKey,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Expanded(
                                  //   child: WidgetTextFieldInt(
                                  //     controller: amount,
                                  //     labelText: 'จำนวนคน',
                                  //     maxLength: 2,
                                  //   ),
                                  // ),
                                  Expanded(
                                      child: textForimField(
                                          context, amount, 'จำนวนคน', 2)),
                                  Expanded(
                                      child: textForimField(
                                          context, days, 'จำนวนวัน', 2)),
                                ],
                              ),
                            ),
                          ),
                          Form(
                            key: _formKey2,
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 8),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                      child: textForimField(
                                          context, price, 'ราคา', 5)),
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

  Padding textForimField(BuildContext context, TextEditingController controller,
      String labelText, int maxLength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
              validator: (value) {
                isValid = isNumeric(value!); // false
                return null;
              },
              maxLength: maxLength,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  counterText: "",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }

  FilledButton button() {
    return FilledButton(
      //style: style,
      onPressed: () async {
        _formKey.currentState!.validate();

        _formKey2.currentState!.validate();
        log(isValid.toString());
        startLoading(context);
        if (name.text.isEmpty ||
            details.text.isEmpty ||
            lavel.toString().isEmpty ||
            amount.text.isEmpty ||
            days.text.isEmpty ||
            price.text.isEmpty) {
          setState(() {
            textErr = 'กรุณากรอกข้อมูลให้ครบ';
          });
          stopLoading();
        } else if (isValid == false) {
          setState(() {
            textErr = 'กรุณากรอกตัวเลขให้ถูกต้อง';
          });
          stopLoading();
        } else if (int.parse(days.text).isNegative == true ||
            int.parse(amount.text).isNegative == true ||
            int.parse(price.text).isNegative == true) {
          setState(() {
            textErr = 'กรุณากรอกตัวเลขมากกว่า 0';
          });
          stopLoading();
        } else if (int.parse(days.text) > 30) {
          setState(() {
            textErr = 'เพิ่มวันได้สูงสุด 30 วัน';
          });
          stopLoading();
        } else if (int.parse(amount.text) > 20) {
          setState(() {
            textErr = 'เพิ่มจำนวนคนได้สูงสุด 20 คน';
          });
          stopLoading();
        } else if (pickedImg == null) {
          setState(() {
            textErr = 'กรุณาเพิ่มรูป';
          });
          stopLoading();
        } else {
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
          // if (pickedImg == null) profile = courses.first.image;
          CourseCoachIdPost request = CourseCoachIdPost(
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
          log(jsonEncode(request));
          log(cid.toString());
          var response =
              await courseService.insetCourseByCoachID(cid.toString(), request);
          moduleResult = response.data;
          log(moduleResult.result);
          stopLoading();

          if (moduleResult.result == '0') {
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'เพิ่มคอร์สไม่สำเร็จ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 2000),
            );
          } else {
            // ignore: use_build_context_synchronously
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'เพิ่มคอร์สสำเร็จ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 2000),
            );
            context.read<AppData>().img = profile;

            // ignore: use_build_context_synchronously
            pushNewScreen(
              context,
              screen: DaysCoursePage(
                coID: moduleResult.result,
                isVisible: true,
              ),
              withNavBar: true,
            ).then((value) {
              Navigator.pop(context);
            });
          }
        }
      },
      child: const Text('ต่อไป'),
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
                    color: Theme.of(context).colorScheme.primary),
                child: const Icon(
                  FontAwesomeIcons.image,
                  color: Colors.white,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(178, 220, 219, 219),
            radius: 20,
            child: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),
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
