// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/service/request.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/response/course_get_res.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_request.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

import '../Request/request_page.dart';
import 'course/course_edit_page.dart';

class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late CourseService _courseService;
  List<ModelCourse> courses = [];
  TextEditingController search = TextEditingController();
  String statusName = "";
  String statusID = "";

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

  //Request
  List<ModelRequest> requests = [];
  late Future<void> loadRequestDataMethod;
  late RequestService _RequestService;

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    _courseService = context.read<AppData>().courseService;

    cid = context.read<AppData>().cid.toString(); //ID Course

    // 2.2 async method
    loadCourseDataMethod = loadCourseData();

    //Course
    _coachService = context.read<AppData>().couchService;
    loadCoachDataMethod = loadCoachData();

    //Request
    _RequestService = context.read<AppData>().requestService;
    loadRequestDataMethod = loadRequestData();
  }

  @override
  Widget build(BuildContext context) {
    //Size
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double height = (screenSize.height > 550) ? 550 : screenSize.height;
    double padding = 8;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        leading: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.barsStaggered,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),
        actions: [
          Visibility(
            visible: isVisibles,
            child: Container(
                padding: const EdgeInsets.only(top: 10, right: 15),
                child: showRequest()),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: screenSize.height,
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    //Show name coach
                    Visibility(
                      visible: isVisibles,
                      child: showCoach(),
                    ),

                    //search course
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(244, 243, 243, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          controller: search,
                          onSubmitted: (value) {
                            setState(() {
                              onVisibles = false;
                              offVisibles = true;
                              _courseService
                                  .course(cid: cid, coID: '', name: search.text)
                                  .then((coursedata) {
                                var datacourse = coursedata.data;
                                courses = datacourse;
                                if (courses.isNotEmpty) {
                                  setState(() {});
                                  log(courses.length.toString());
                                }
                              });
                            });
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.search),
                              hintText: "ค้นหาคอร์สของฉัน",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            //show Course
            Visibility(
              visible: onVisibles,
              child: SizedBox(
                height: screenSize.height / 1.6,
                width: double.infinity,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showCourse(),
                ),
              ),
            ),
            Visibility(
              visible: offVisibles,
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 1.06,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showCourse(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //LoadData
  Future<void> loadCourseData() async {
    try {
      //Courses
      var datas =
          await _courseService.course(coID: '', cid: cid, name: search.text);
      courses = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadCoachData() async {
    try {
      var datas = await _coachService.coach(nameCoach: '', cid: cid);
      coachs = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadRequestData() async {
    try {
      var datas = await _RequestService.request(rqID: '', uid: '', cid: cid);
      requests = datas.data;
      log(requests.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data
  Widget showCourse() {
    return FutureBuilder(
        future: loadCourseDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                // ignore: unnecessary_null_comparison
                if (courses != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => CourseEditPage(
                                    coID: courses[index].coId.toString(),
                                  ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(courses[index].image,
                                      width: 400,
                                      height: 150,
                                      fit: BoxFit.fill),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        courses[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text("ราคา ${courses[index].price.toString()}",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 39, 39, 39),
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget showCoach() {
    return FutureBuilder(
        future: loadCoachDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Hello Coach ${coachs.first.username}",
                  style: const TextStyle(
                      color: Color.fromARGB(221, 46, 46, 46), fontSize: 20),
                ),
                Text(
                  "เรามาสร้างคอร์สกัน",
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget showRequest() {
    return FutureBuilder(
        future: loadRequestDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                badges.Badge(
                  position: badges.BadgePosition.topEnd(),
                  showBadge: true,
                  ignorePointer: false,
                  badgeAnimation: const BadgeAnimation.slide(
                    toAnimate: true,
                    animationDuration: Duration(seconds: 1),
                  ),
                  badgeContent: Text(
                    requests.length.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Get.to(() => const RequestPage());
                  },
                  badgeStyle: badges.BadgeStyle(
                    //shape: badges.BadgeShape.square,
                    badgeColor: Theme.of(context).colorScheme.error,
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    elevation: 4,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.bell,
                    color: Colors.black,
                  ),
                )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
