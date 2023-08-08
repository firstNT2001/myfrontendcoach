import 'dart:convert';
import 'dart:developer';
import 'dart:io';
//import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/coach/home_coach_page.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../model/request/course_courseID_put.dart';

import '../../../model/response/md_Result.dart';
import '../../../model/response/md_Review_get.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../model/response/md_days.dart';
import '../../../model/response/md_process.dart';
import '../../../service/course.dart';

import '../../../service/days.dart';
import '../../../service/progessbar.dart';
import '../../../service/provider/appdata.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dropdown/wg_dropdown_string.dart';

import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int copy.dart';
import '../../user/chat/chat.dart';
import '../daysCourse/days_course_page.dart';
import 'FoodAndClip/course_food_clip.dart';

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
  late ProgessbarService _progessbarService;
  late Modelprogessbar modelprogessbar;
  //CourseService
  late CourseService _courseService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];

  late ModelResult moduleResult;

  //Days
  late DaysService _daysService;
  late Future<void> loadDaysDataMethod;
  List<ModelDay> modelDays = [];

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

  bool _enabled = true;
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    // _reviewService = context.read<AppData>().reviewService;
    _courseService = context.read<AppData>().courseService;
    loadDataMethod = loadDataAsync();

    _progessbarService = context.read<AppData>().progessbar;
    loadProgessData();
    
    _daysService = context.read<AppData>().daysService;

    loadDaysDataMethod = loadDaysDataAsync();
    Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
      setState(() {
        _enabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    //double height = (screenSize.height > 550) ? 550 : screenSize.height;
    double padding = 8;
    return (_enabled == true)
        ? Skeletonizer(enabled: true, child: scaffold(width, padding))
        : scaffold(width, padding);
  }

  Scaffold scaffold(double width, double padding) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        //backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        body: SafeArea(
          child: ListView(
            children: [
              showCourse(width, padding),
              if (widget.isVisible == false) ...{
                showDays(),
              },
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
            return Container();
          }
        });
  }

  Padding showText(BuildContext context, double width, double padding) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Visibility(
              visible: widget.isVisible,
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
                        SizedBox(
                          width: (width - 16 - (3 * padding)) / 2,
                          child: WidgetTextFieldInt(
                            controller: price,
                            labelText: 'ราคา',
                            maxLength: 5,
                          ),
                        ),
                        SizedBox(
                          width: (width - 16 - (3 * padding)) / 2,
                          child: WidgetDropdownString(
                            title: 'เลือกความยากง่าย',
                            selectedValue: selectedValue,
                            listItems: LevelItems,
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 20, right: 23),
                        child: Text(
                          textErr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (widget.isVisible == false) ...{
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, top: 28, left: 13),
                      child: Text('ชื่อ ${name.text}',
                          style: Theme.of(context).textTheme.headlineSmall)),
                  Padding(
                    padding: const EdgeInsets.only(left: 13),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.4,
                      height: 40,
                      decoration: BoxDecoration(
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                offset: Offset(0.0, 0.75))
                          ],
                          color: const Color.fromRGBO(244, 243, 243, 1),
                          borderRadius: BorderRadius.circular(30)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(FontAwesomeIcons.user),
                          Padding(
                            padding: const EdgeInsets.only(left: 8),
                            child: Text(context.read<AppData>().nameCoach,
                                style: Theme.of(context).textTheme.bodyLarge),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 13),
                      child: Text('รายละเอียด',
                          style: Theme.of(context).textTheme.bodyLarge)),
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8, left: 13),
                      child: Text('    ${details.text}',
                          style: Theme.of(context).textTheme.bodyLarge)),
                ],
              ),
            },
            Visibility(
              visible: widget.isVisible,
              child: Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 13, right: 13),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: buttonNext()),
                ),
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
        Visibility(
          visible: widget.isVisible,
          child: Positioned(
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
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      //border: Border.all(width: 4, color: Colors.white),
                      color: Colors.white),
                  child: const Icon(
                    FontAwesomeIcons.camera,
                    color: Colors.black,
                  ),
                ),
              )),
        ),
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
                  ),
                  onPressed: () {
                    Get.back();
                  },
                ),
              ),
              Visibility(
                visible: widget.isVisible,
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.trash,
                      ),
                      onPressed: () {
                        dialogDelete(context);
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
              Get.to(() => DaysCoursePage(
                    coID: widget.coID,
                    isVisible: widget.isVisible,
                  ));
            } else {
              // ignore: use_build_context_synchronously
              success(context);
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
      // var response = await _reviewService.review(coID: widget.coID);
      // modelReviews = response.data;
      // log(' = ${modelReviews.first.score}');
      // sumAVG = modelReviews.map((m) => m.score).reduce((a, b) => a + b) /
      //     modelReviews.length;
      // log('AVG = ${sumAVG.toString()}');
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
    log(courses.first.days.toString());
    // name.text = foods.name;
  }

  Future<void> loadDaysDataAsync() async {
    try {
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      modelDays = res.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  ///Show
  FutureBuilder<void> showDays() {
    return FutureBuilder(
      future: loadDaysDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 13),
                child: Text('วันที่',
                    style: Theme.of(context).textTheme.bodyLarge),
              ),
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 5, mainAxisExtent: 65),
                shrinkWrap: true,
                itemCount: modelDays.length,
                itemBuilder: (context, index) {
                  final modelDay = modelDays[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                              blurRadius: 3,
                              color: Colors.black,
                              spreadRadius: 0)
                        ],
                      ),
                      child: InkWell(
                          onTap: () {
                            Get.to(() => HomeFoodAndClipPage(
                                  did: modelDay.did.toString(),
                                  sequence: modelDay.sequence.toString(),
                                  isVisible: widget.isVisible,
                                ));
                          },
                          child: Center(
                              child: Text(modelDay.sequence.toString(),
                                  style:
                                      Theme.of(context).textTheme.bodyLarge))),
                    ),
                  );
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilledButton.icon(
                        onPressed: () {
                          //roomchat= widget.namecourse+coID.toString();
                          Get.to(() => ChatPage(
                                roomID: widget.coID,
                                roomName: name.text,
                                userID: context.read<AppData>().cid.toString(),
                                firstName: "โค้ช ${context.read<AppData>().nameCoach}",
                              ));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.facebookMessenger,
                          size: 16,
                        ),
                        label: const Text("คุยกับโค้ช")),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  //Image
  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedImg = result.files.first;
    });
  }
   Future<void> loadProgessData() async {
    try {
      var datas = await _progessbarService.processbar(coID: widget.coID);
      modelprogessbar = datas.data;
      log("percent${modelprogessbar.percent}");
    } catch (err) {
      log('Error: $err');
    }
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
  void dialogDelete(BuildContext context) {
    QuickAlert.show(
      context: context,

      type: QuickAlertType.confirm,
      text: 'Do you want to delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      // barrierColor: Colors.white,
      // confirmBtnTextStyle:
      //     const TextStyle(
      //   color: Colors.black,
      //   fontWeight: FontWeight.bold,
      // ),
      onConfirmBtnTap: () async {
        var response = await _courseService.deleteCourse(widget.coID);
        modelResult = response.data;
        Navigator.of(context, rootNavigator: true).pop();
        if (modelResult.result == '1') {
          Get.to(() => const HomePageCoach());
        } else {
          // ignore: use_build_context_synchronously
          warningDelete(context);
        }
      },
    );
  }
}
