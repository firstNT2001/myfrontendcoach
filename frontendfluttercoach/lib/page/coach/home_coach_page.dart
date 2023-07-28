// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:typed_data';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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
import '../search/search_course.dart';
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
      //backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        //backgroundColor: Theme.of(context).colorScheme.primary,
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("DAILY WORKOUT",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("COACHING",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            ),
          
            //search course
            searchButter(context),

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

  Padding searchButter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => const SearchCoursePage());
        },
        child: Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Get.to(() => const SearchCoursePage());
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                  ),
                  label: const Text(
                    "ค้นหาคอร์สของฉัน...",
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            )),
      ),
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
      var datas = await _coachService.coach(nameCoach: '', cid: cid);
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
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: InkWell(
                  onTap: () {
                    Get.to(() => CourseEditPage(
                          coID: courses[index].coId.toString(), isVisible: true,
                        ));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    child: AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Stack(
                        children: <Widget>[
                          if (listcours.image != '')...{
                              Container(
                                alignment: Alignment.topCenter,
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: const Color(0xff7c94b6),
                                        image: DecorationImage(
                                            image:
                                                NetworkImage(listcours.image),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                                //color: Colors.white,
                              ),
                            },
                          Container(
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
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(listcours.name,
                                    style:
                                        Theme.of(context).textTheme.titleLarge),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        FontAwesomeIcons.solidUser,
                                        size: 16.0,
                                      ),
                                    ),
                                    Text(listcours.coach.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge),
                                  ],
                                ),
                                (listcours.level == '1')
                                    ? Row(
                                        children: [
                                          Icon(FontAwesomeIcons.bolt,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer),
                                          const Icon(FontAwesomeIcons.bolt,
                                              size: 16),
                                          const Icon(FontAwesomeIcons.bolt,
                                              size: 16),
                                        ],
                                      )
                                    : (listcours.level == '2')
                                        ? Row(
                                            children: [
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              const Icon(FontAwesomeIcons.bolt,
                                                  size: 16),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                            ],
                                          )
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
