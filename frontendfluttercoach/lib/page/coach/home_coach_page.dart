// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:custom_rating_bar/custom_rating_bar.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:frontendfluttercoach/service/request.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../model/request/course_courseID_put.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../model/response/md_request.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

import '../../widget/dialogs.dart';
import '../../widget/notificationBody.dart';
import '../Request/request_page.dart';
import '../search/search_course.dart';
import 'course/course_new_page.dart';
import 'course/course_show.dart';

class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late CourseService _courseService;
  List<Course> courses = [];
  late ModelResult modelResult;
  //show
  bool checkBoxVal = true;
  bool isVisibles = true;
  bool onVisibles = true;
  bool offVisibles = false;

  //image resize
  Uint8List? resizedImg;
  Uint8List? bytes;

  // Coach
  late Future<void> loadCoachDataMethod;
  late CoachService _coachService;
  List<Coach> coachs = [];
  String cid = '';
  TextEditingController nameCoach = TextEditingController();
  String username = '', price = '', image = '';

  //Request
  List<Request> requests = [];
  late Future<void> loadRequestDataMethod;
  late RequestService _RequestService;

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    _courseService = context.read<AppData>().courseService;

    cid = context.read<AppData>().cid.toString(); //ID Course
    log("CoachID:$cid");
    // 2.2 async method
    loadCourseDataMethod = loadCourseData();

    //Course
    _coachService = context.read<AppData>().coachService;
    loadCoachDataMethod = loadCoachData();

    //Request
    _RequestService = context.read<AppData>().requestService;
    loadRequestDataMethod = loadRequestData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: SizedBox(
        width: 150,
        height: 50,
        child: FilledButton(
          onPressed: () {
            pushNewScreen(
              context,
              screen: const CourseNewPage(),
              withNavBar: true,
            ).then((value) {
              log('ponds');
              setState(() {
                loadCourseDataMethod = loadCourseData();
                loadRequestDataMethod = loadRequestData();
              });
            });
          },
          child: const Row(
            children: [
              Icon(FontAwesomeIcons.pencil),
              SizedBox(
                width: 10,
              ),
              Text('เพิ่มคอร์ส'),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              loadCourseDataMethod = loadCourseData();
              loadCoachDataMethod = loadCoachData();
              loadRequestDataMethod = loadRequestData();
            });
          },
          child: Column(
            children: [
              columnAll(context),
              const SizedBox(
                height: 10,
              ),
              //show Course
              if (onVisibles == true)
                Expanded(
                  child: Visibility(
                    visible: onVisibles,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: showCourse(),
                    ),
                  ),
                ),
              if (offVisibles == true)
                Expanded(
                  child: Visibility(
                    visible: offVisibles,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: showCourse(),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Column columnAll(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 196, 196, 196),
                    blurRadius: 20.0,
                    spreadRadius: 1,
                    offset: Offset(
                      0,
                      1,
                    ),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                    Color.fromARGB(227, 84, 84, 84),
                    Color.fromARGB(227, 84, 84, 84),
                    Color.fromARGB(227, 84, 84, 84),
                  ])),
                  height: 150,
                ),
              ),
            ),
            // Padding(
            //   padding: EdgeInsets.only(
            //       top: MediaQuery.of(context).size.height * 0.048,
            //       bottom: 20,
            //       left: MediaQuery.of(context).size.width * 0.58,
            //       right: 15),
            //   child: SizedBox(
            //       width: MediaQuery.of(context).size.width * 0.4,
            //       height: MediaQuery.of(context).size.height * 0.1,
            //       child: Image.asset("assets/images/yoga.png")),
            // ),
            Positioned(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                    visible: isVisibles,
                    child: Container(
                        padding: const EdgeInsets.only(top: 10, right: 15),
                        child: showRequest()),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Text("DAILY WORKOUT",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("COACHING",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 243, 243, 244),
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: const [
                          BoxShadow(
                            color: Color.fromARGB(255, 156, 156, 156),
                            blurRadius: 20.0,
                            spreadRadius: 1,
                            offset: Offset(
                              0,
                              3,
                            ),
                          )
                        ],
                      ),
                      child: TextField(
                        readOnly: true,
                        onTap: () {
                          pushNewScreen(
                            context,
                            screen: const SearchCoursePage(),
                            withNavBar: true,
                          ).then((value) {
                            log('ponds');
                            setState(() {
                              loadCourseDataMethod = loadCourseData();
                              loadRequestDataMethod = loadRequestData();
                            });
                          });
                        },
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1,
                                  color: Colors.grey.shade100), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Colors.grey.shade100), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.search,
                              color: Colors.grey,
                            ),
                            hintText: "ค้นหา",
                            hintStyle: const TextStyle(color: Colors.grey)),
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  //LoadData
  Future<void> loadCourseData() async {
    try {
      //Courses
      var datas = await _courseService.course(coID: '', cid: cid, name: '');
      courses = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadCoachData() async {
    try {
      var datas = await _coachService.coach(nameCoach: '', cid: cid, email: '');
      coachs = datas.data;
      // ignore: use_build_context_synchronously
      context.read<AppData>().nameCoach = coachs.first.fullName;
      // ignore: use_build_context_synchronously
      log(context.read<AppData>().nameCoach);
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadRequestData() async {
    try {
      var datas = await _RequestService.request(rqID: '', uid: '', cid: cid);
      requests = datas.data;
      log(requests.length.toString());
      if (requests.length > 0) {
        // ignore: use_build_context_synchronously
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'มีการขอเปลี่ยนท่า',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data
  Widget showCourse() {
    return FutureBuilder(
      future: loadCourseDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return course();
        }
      },
    );
  }

  ListView course() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: courses.length,
      itemBuilder: (context, index) {
        final listcours = courses[index];
        return Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          child: InkWell(
            onTap: () {
              pushNewScreen(
                context,
                screen: ShowCourse(
                  coID: courses[index].coId.toString(),
                ),
                withNavBar: true,
              ).then((value) {
                log('ponds');
                setState(() {
                  loadCourseDataMethod = loadCourseData();
                  loadRequestDataMethod = loadRequestData();
                });
              });
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: <Widget>[
                    if (listcours.image != '') ...{
                      Container(
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                image: DecorationImage(
                                    image: NetworkImage(listcours.image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                        //color: Colors.white,
                      ),
                    },
                    (listcours.status == '1')
                        ? Container(
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: <Color>[
                                  const Color.fromARGB(255, 0, 0, 0)
                                      .withAlpha(0),
                                  const Color.fromARGB(49, 0, 0, 0),
                                  const Color.fromARGB(127, 0, 0, 0)
                                  // const Color.fromARGB(255, 255, 255, 255)
                                  //     .withAlpha(0),
                                  // Color.fromARGB(39, 255, 255, 255),
                                  // Color.fromARGB(121, 255, 255, 255)
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(148, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'ปิด',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          (listcours.status == '1')
                              ? SwitcherButton(
                                  value: true,
                                  onChange: (value) async {
                                    CourseCourseIdPut request =
                                        CourseCourseIdPut(
                                            status: '0',
                                            amount: listcours.amount,
                                            days: listcours.days,
                                            details: listcours.details,
                                            image: listcours.image,
                                            level: listcours.level,
                                            name: listcours.name,
                                            price: listcours.price);

                                    await updateStatus(
                                        request, listcours.coId.toString());
                                    log("1$value");
                                  },
                                )
                              : SwitcherButton(
                                  value: false,
                                  onChange: (value) async {
                                    CourseCourseIdPut request =
                                        CourseCourseIdPut(
                                            status: '1',
                                            amount: listcours.amount,
                                            days: listcours.days,
                                            details: listcours.details,
                                            image: listcours.image,
                                            level: listcours.level,
                                            name: listcours.name,
                                            price: listcours.price);

                                    await updateStatus(
                                        request, listcours.coId.toString());
                                    log("0$value");
                                  },
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            listcours.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          RatingBar.readOnly(
                            isHalfAllowed: false,
                            filledIcon: FontAwesomeIcons.bolt,
                            size: 16,
                            emptyIcon: FontAwesomeIcons.bolt,
                            filledColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            emptyColor: Color.fromARGB(255, 245, 245, 245),
                            initialRating: double.parse(listcours.level),
                            maxRating: 3,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget showRequest() {
    return FutureBuilder(
        future: loadRequestDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                InkWell(
                  onTap: () {
                    Get.to(() => const RequestPage());
                  },
                  child: badges.Badge(
                    position: badges.BadgePosition.topEnd(),
                    showBadge: true,
                    ignorePointer: false,
                    badgeAnimation: const BadgeAnimation.slide(
                      toAnimate: true,
                      animationDuration: Duration(seconds: 1),
                    ),
                    badgeContent: Row(
                      children: [
                        if (requests.isNotEmpty)
                          Text(
                            requests.length.toString(),
                            style: const TextStyle(color: Colors.white),
                          ),
                      ],
                    ),
                    onTap: () {
                      Get.to(() => const RequestPage());
                    },
                    badgeStyle: badges.BadgeStyle(
                      //shape: badges.BadgeShape.square,
                      badgeColor: Theme.of(context).colorScheme.error,
                      borderSide:
                          const BorderSide(color: Colors.white, width: 2),
                      elevation: 0,
                    ),
                    child: const Icon(
                      FontAwesomeIcons.bell,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Future<void> updateStatus(CourseCourseIdPut request, String coID) async {
    log(jsonEncode(request));
    var response = await _courseService.updateCourseByCourseID(coID, request);
    modelResult = response.data;
    log(coID);
    log(modelResult.result);
    if (modelResult.result == '0') {
      // // ignore: use_build_context_synchronously
      //   InAppNotification.show(
      //     child: NotificationBody(
      //       count: 1,
      //       message: 'อัพเดทสถานะไม่สำเร็จ',
      //     ),
      //     context: context,
      //     onTap: () => print('Notification tapped!'),
      //     duration: const Duration(milliseconds: 1500),
      //   );
    } else {
      // // ignore: use_build_context_synchronously
      //   InAppNotification.show(
      //     child: NotificationBody(
      //       count: 1,
      //       message: 'อัพเดทสถานะสำเร็จ',
      //     ),
      //     context: context,
      //     onTap: () => print('Notification tapped!'),
      //     duration: const Duration(milliseconds: 1500),
      //   );
      setState(() {
        loadCourseDataMethod = loadCourseData();
      });
    }
  }
}
