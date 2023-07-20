// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:typed_data';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/usersBuyCourses/show_user_page.dart';
import 'package:frontendfluttercoach/service/request.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../model/response/md_request.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

import '../../widget/wg_menu.dart';
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
  List<Course> courses = [];
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
  String username = '', price = '', image = '';

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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      //backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.barsStaggered,
            //color: Colors.black,
          ),
          onPressed: () {
            Get.to(() => SideMenu(
                name: coachs.first.username,
                price: coachs.first.price.toString(),
                image: coachs.first.image));
          },
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
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
             FilledButton.icon(onPressed: (){
                      //roomchat= widget.namecourse+coID.toString();
                      Get.to(() => const ShowUserByCoursePage());
                    }, icon: const Icon(FontAwesomeIcons.facebookMessenger,size: 16,), label: Text("คุยกับโค้ช")),
            Container(
                width: screenSize.height,
                decoration: BoxDecoration(
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                          color: Colors.black54,
                          blurRadius: 10.0,
                          offset: Offset(0.0, 0.75))
                    ],
                    color: Theme.of(context).colorScheme.primary,
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
      future: loadCourseDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final listcours = courses[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                 // color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => CourseEditPage(
                            coID: courses[index].coId.toString(),
                          ));
                    },
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                image: DecorationImage(
                                  image: NetworkImage(listcours.image),
                                ),
                              )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.35,
                              child: AutoSizeText(
                                listcours.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Icon(
                                    FontAwesomeIcons.solidStar,
                                    color: Colors.yellow,
                                    size: 20,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Text("4.5"),
                                  const VerticalDivider(),
                                  Text(listcours.price.toString()),
                                ],
                              ),
                            ),
                            if (listcours.status == '1') ...{
                              Text(
                                "กำลังขาย",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            } else
                              Text(
                                "ปิดการขาย",
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
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
                  // style: const TextStyle(
                  //     color: Color.fromARGB(221, 46, 46, 46), fontSize: 20),
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
                    borderSide: const BorderSide(color: Colors.white, width: 2),
                    elevation: 0,
                  ),
                  child: const Icon(
                    FontAwesomeIcons.bell,
                   // color: Colors.black,
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
