import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_Coach_get.dart';
import '../../../../model/response/md_coach_course_get.dart';
import '../../../../service/coach.dart';
import '../../../../service/course.dart';
import '../../../../service/provider/appdata.dart';
import '../../cousepage.dart';
import '../../profilecoach.dart';

class WidgetSearchtext extends StatefulWidget {
  const WidgetSearchtext({super.key});

  @override
  State<WidgetSearchtext> createState() => _WidgetSearchtextState();
}

class _WidgetSearchtextState extends State<WidgetSearchtext> {
  late Future<void> loadDataMethod;
  late CoachService coachService;
  late CourseService courseService;
  List<Coach> coaches = [];
  List<Course> courses = [];
  final List<String> categories = ['คอร์ส', 'โค้ช'];
  final List<String> selectcategories = [];
  TextEditingController myController = TextEditingController();
  bool isVisibleCourse = false;
  bool isVisibleCoach = false;
  bool isVisibleSearch = true;
  bool isVisibleText = false;
  bool isVisibleTextCourse = false;
  bool isVisibleTextCoach = false;
  bool isVisibleTextCourseCoach = false;
  @override
  void initState() {
    // TODO: implement initState
    setState(() {
      loadDataMethod = loadData();
    });
    super.initState();
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                        color: const Color.fromRGBO(244, 243, 243, 1),
                        borderRadius: BorderRadius.circular(15)),
                    child: TextField(
                      controller: myController,
                      autofocus: true,
                      onChanged: (value) {
                        if (myController.text.isNotEmpty) {
                          log("contro ไม่ว่าง");

                          setState(() {
                            myController.text;
                            log("myController.text1" + myController.text);
                          });
                          log("myController.text2" + myController.text);
                          coachService
                              .coach(
                                  nameCoach: myController.text,
                                  cid: "",
                                  email: '')
                              .then((coachdata) {
                            var datacoach = coachdata.data;
                            coaches = datacoach;
                            if (coaches.isNotEmpty) {
                              log("coaches.isNotEmpty");
                              setState(() {
                                isVisibleCoach = true;
                                isVisibleSearch = false;
                                isVisibleText = false;
                                isVisibleTextCourseCoach = true;
                                isVisibleTextCourse = false;
                                isVisibleTextCoach = false;
                              });
                            } else {
                              log("coaches.isEmpty");
                              setState(() {
                                isVisibleCourse = false;
                                isVisibleCoach = false;
                                isVisibleSearch = false;
                                isVisibleText = true;
                                isVisibleTextCourseCoach = false;
                                isVisibleTextCourse = false;
                                isVisibleTextCoach = false;
                              });
                            }
                          });
                          courseService
                              .courseOpenSell(
                                  cid: '', coID: '', name: myController.text)
                              .then((coursedata) {
                            var datacourse = coursedata.data;
                            courses = datacourse;
                            if (courses.isNotEmpty) {
                              log("courses.isNotEmpty");
                              setState(() {
                                isVisibleCourse = true;
                                isVisibleSearch = false;
                                isVisibleText = false;
                                isVisibleTextCourseCoach = true;
                                isVisibleTextCourse = false;
                                isVisibleTextCoach = false;
                              });

                              log(coaches.length.toString());
                            } else {
                              log("courses.isEmpty");
                              setState(() {
                                isVisibleCourse = false;
                                isVisibleCoach = false;
                                isVisibleSearch = false;
                                isVisibleText = true;
                                isVisibleTextCourseCoach = false;

                                isVisibleTextCourse = false;
                                isVisibleTextCoach = false;
                              });
                            }
                          });
                        } else {
                          log("contro ว่าง");
                          
                          // setState(() {
                          //   isVisibleCourse = false;
                          //   isVisibleCoach = false;
                          //   isVisibleSearch = true;
                          //   isVisibleText = false;
                          //   isVisibleTextCourseCoach = false;
                          //   isVisibleTextCourse = false;
                          //   isVisibleTextCoach = false;
                          // });
                        }
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                width: 1,
                                color: Colors.grey.shade100), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 1.5,
                                color: Colors.orange), //<-- SEE HERE
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          prefixIcon: const Icon(
                            FontAwesomeIcons.search,
                            color: Colors.grey,
                          ),
                          hintText: "ค้นหาโค้ชหรือคอร์ส",
                          hintStyle: const TextStyle(color: Colors.grey)),
                    ))
              ],
            ),
          ),
          Container(
              padding: const EdgeInsets.only(top: 15, left: 15),
              child: Row(
                children: categories
                    .map((category) => Padding(
                          padding: const EdgeInsets.only(right: 15),
                          child: FilterChip(
                              selected: selectcategories.contains(category),
                              label: Text(category),
                              labelStyle: const TextStyle(fontSize: 16),
                              onSelected: (selected) {
                                setState(() {
                                  if (selected) {
                                    selectcategories.add(category);
                                    category = selectcategories.join();
                                    //log(tt);
                                    if (category == 'คอร์ส') {
                                      log("messageคอร์ส");

                                      if (myController.text.isNotEmpty) {
                                        log("myControllerคอร์สisNotEmpty");
                                        if (courses.isEmpty) {
                                          log("coursesเพิ่ม.isEmpty2");
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = true;
                                          isVisibleTextCourse = true;
                                          isVisibleTextCoach = false;
                                          isVisibleTextCourseCoach = false;
                                        } else {
                                          log("coursesเพิ่ม.isnotEmpty2");
                                          isVisibleSearch = false;
                                          isVisibleCourse = true;
                                          isVisibleCoach = false;
                                          isVisibleText = false;
                                          isVisibleTextCourse = true;
                                          isVisibleTextCoach = false;
                                          isVisibleTextCourseCoach = false;
                                        }
                                      } else {
                                        courseService
                                            .courseOpenSell(
                                                cid: '', coID: '', name: '')
                                            .then((coursedata) {
                                          var datacourse = coursedata.data;
                                          courses = datacourse;
                                          if (courses.isNotEmpty) {
                                            log("courses2.isNotEmpty");
                                            setState(() {
                                              isVisibleCourse = true;
                                              isVisibleSearch = false;
                                              isVisibleText = false;
                                              isVisibleTextCourseCoach = false;
                                              isVisibleTextCourse = true;
                                              isVisibleTextCoach = false;
                                            });
                                          }
                                        });

                                        // log("myControllerคอร์สisEmpty");
                                        // isVisibleSearch = true;
                                        // isVisibleCourse = false;

                                        // isVisibleCoach = false;
                                        // isVisibleText = false;
                                        // isVisibleTextCourse = true;
                                        // isVisibleTextCoach = false;
                                        // isVisibleTextCourseCoach = false;
                                      }
                                    } else if (category == 'โค้ช') {
                                      log("messageโค้ช");
                                      if (myController.text.isNotEmpty) {
                                        log("myControllerคอร์สisNotEmpty");
                                        if (coaches.isEmpty) {
                                          log("coachesเพิ่ม.isEmpty2");
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = true;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = true;
                                          isVisibleTextCourseCoach = false;
                                        } else {
                                          log("coachesเพิ่ม.isnotEmpty2");
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = true;
                                          isVisibleText = false;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = true;
                                          isVisibleTextCourseCoach = false;
                                        }
                                      } else {
                                        coachService
                                            .coach(
                                                nameCoach: '',
                                                cid: "",
                                                email: '')
                                            .then((coachdata) {
                                          var datacoach = coachdata.data;
                                          coaches = datacoach;
                                          if (coaches.isNotEmpty) {
                                            log("coaches2.isNotEmpty");
                                            setState(() {
                                              isVisibleCoach = true;
                                              isVisibleSearch = false;
                                              isVisibleText = false;
                                              isVisibleTextCourseCoach = false;
                                              isVisibleTextCourse = false;
                                              isVisibleTextCoach = true;
                                            });
                                          }
                                        });
                                        // log("myControllerโค้ชisEmpty");

                                        // isVisibleSearch = true;
                                        // isVisibleCourse = false;

                                        // isVisibleCoach = false;
                                        // isVisibleText = false;
                                        // isVisibleTextCourse = false;
                                        // isVisibleTextCoach = true;
                                        // isVisibleTextCourseCoach = false;
                                      }
                                    } else if (category == 'คอร์สโค้ช' ||
                                        category == 'โค้ชคอร์ส') {
                                      log("category" + category);
                                      if (myController.text.isNotEmpty) {
                                        log("myControllerโค้ชคอร์สisNotEmpty");
                                        if (courses.isEmpty &&
                                            coaches.isEmpty) {
                                          log("โค้ชคอร์สเพิ่ม.isEmpty2");
                                          setState(() {
                                            isVisibleSearch = true;
                                            isVisibleCourse = false;
                                            isVisibleCoach = false;
                                            isVisibleText = false;
                                            isVisibleTextCourse = false;
                                            isVisibleTextCoach = false;
                                            isVisibleTextCourseCoach = true;
                                          });
                                        } else {
                                          isVisibleSearch = false;
                                          isVisibleCourse = true;
                                          isVisibleCoach = true;
                                          isVisibleText = false;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = false;
                                          isVisibleTextCourseCoach = true;
                                        }
                                      } else {
                                        coachService
                                            .coach(
                                                nameCoach: '',
                                                cid: "",
                                                email: '')
                                            .then((coachdata) {
                                          var datacoach = coachdata.data;
                                          coaches = datacoach;
                                          if (coaches.isNotEmpty) {
                                            log("coaches2.isNotEmpty");
                                            setState(() {
                                              isVisibleCoach = true;
                                              isVisibleSearch = false;
                                              isVisibleText = false;
                                              isVisibleTextCourseCoach = true;
                                              isVisibleTextCourse = false;
                                              isVisibleTextCoach = false;
                                            });
                                          }
                                        });
                                        courseService
                                            .courseOpenSell(
                                                cid: '', coID: '', name: '')
                                            .then((coursedata) {
                                          var datacourse = coursedata.data;
                                          courses = datacourse;
                                          if (courses.isNotEmpty) {
                                            log("courses2.isNotEmpty");
                                            setState(() {
                                              isVisibleCourse = true;
                                              isVisibleSearch = false;
                                              isVisibleText = false;
                                              isVisibleTextCourseCoach = true;
                                              isVisibleTextCourse = false;
                                              isVisibleTextCoach = false;
                                            });

                                            log(coaches.length.toString());
                                          }
                                        });
                                      }
                                    }
                                  } else {
                                    selectcategories.remove(category);
                                    category = selectcategories.join();
                                    log(category);
                                    if (category == 'โค้ช') {
                                      log("messageลบโค้ช");
                                      if (myController.text.isNotEmpty) {
                                        if (coaches.isEmpty) {
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = true;
                                          isVisibleTextCourse = true;
                                          isVisibleTextCoach = false;
                                          isVisibleTextCourseCoach = false;
                                        } else {
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = true;
                                          isVisibleText = false;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = true;
                                          isVisibleTextCourseCoach = false;
                                        }
                                      } else {
                                        coachService
                                            .coach(
                                                nameCoach: '',
                                                cid: "",
                                                email: '')
                                            .then((coachdata) {
                                          var datacoach = coachdata.data;
                                          coaches = datacoach;
                                          if (coaches.isNotEmpty) {
                                            log("coaches2.isNotEmpty");
                                            setState(() {
                                              isVisibleCoach = true;
                                              isVisibleSearch = false;
                                              isVisibleText = false;
                                              isVisibleTextCourseCoach = true;
                                              isVisibleTextCourse = false;
                                              isVisibleTextCoach = false;
                                            });
                                          }
                                        });
                                      }
                                    } else if (category == 'คอร์ส') {
                                      log("messageลบคอร์ส");
                                      if (myController.text.isNotEmpty) {
                                        if (courses.isEmpty) {
                                          log("coursesลบ.isEmpty2");
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = true;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = true;
                                          isVisibleTextCourseCoach = false;
                                        } else {
                                          isVisibleSearch = false;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = false;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = true;
                                          isVisibleTextCourseCoach = false;
                                        }
                                      } else {
                                       courseService
                              .courseOpenSell(cid: '', coID: '', name: '')
                              .then((coursedata) {
                            var datacourse = coursedata.data;
                            courses = datacourse;
                            if (courses.isNotEmpty) {
                              log("courses2.isNotEmpty");
                              setState(() {
                                isVisibleCourse = true;
                                isVisibleSearch = false;
                                isVisibleText = false;
                                isVisibleTextCourseCoach = true;
                                isVisibleTextCourse = false;
                                isVisibleTextCoach = false;
                              });

                              log(coaches.length.toString());
                            }
                          });
                                      }
                                    } else {
                                      log("messageลบคอร์สโค้ช");
                                      isVisibleTextCourse = false;
                                      isVisibleSearch = false;
                                      isVisibleCourse = true;
                                      isVisibleCoach = true;
                                      isVisibleText = false;
                                      isVisibleTextCoach = false;
                                      isVisibleTextCourseCoach = true;
                                      if (courses.isEmpty && coaches.isEmpty) {
                                        setState(() {
                                          isVisibleSearch = true;
                                          isVisibleCourse = false;
                                          isVisibleCoach = false;
                                          isVisibleText = false;
                                          isVisibleTextCourse = false;
                                          isVisibleTextCoach = false;
                                          isVisibleTextCourseCoach = true;
                                        });
                                      }
                                    }

                                    //isSuggestVisible = true;
                                  }
                                });
                              }),
                        ))
                    .toList(),
              )),
          // Text(
          //   'Looking for: ${selectcategories.map((e) => e).join(', ')}',
          // ),
          Visibility(
              visible: isVisibleTextCourseCoach,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "คอร์สและโค้ชทั้งหมด",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )),
          Visibility(
              visible: isVisibleTextCourse,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "คอร์สทั้งหมด",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )),
          Visibility(
              visible: isVisibleTextCoach,
              child: const Padding(
                padding: EdgeInsets.only(left: 10, top: 10),
                child: Text(
                  "โค้ชทั้งหมด",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              )),
          Center(
            child: Visibility(
              visible: isVisibleSearch,
              child: const SizedBox(
                height: 180,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(FontAwesomeIcons.search,
                        color: Color.fromARGB(96, 85, 85, 85), size: 25),
                    Padding(
                      padding: EdgeInsets.only(left: 10),
                      child: Text("พิมพ์เพื่อค้นหา",
                          style: TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(96, 85, 85, 85))),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Center(
            child: Visibility(
              visible: isVisibleText,
              child: SizedBox(
                height: 180,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text("ไม่พบผลลัพธ์สำหรับ",
                        style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(96, 85, 85, 85))),
                    Text("''" + myController.text + "''",
                        style: const TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(96, 85, 85, 85)))
                  ],
                ),
              ),
            ),
          ),
          //showCourse
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Visibility(
                    visible: isVisibleCourse,
                    child: loadcourse(),
                  ),
                  //showCoach
                  Visibility(
                    visible: isVisibleCoach,
                    child: loadcoach(),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }

  Future<void> loadData() async {
    try {
      var datacourse =
          await courseService.courseOpenSell(coID: '', cid: '', name: '');
      courses = datacourse.data;
      var datacoach =
          await coachService.coach(cid: '', email: '', nameCoach: '');
      coaches = datacoach.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadcourse() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: courses
                .map((listcours) => Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: showCousePage(namecourse: listcours.name),
                          withNavBar: true,
                        );
                      },
                      child: Card(
                        elevation: 10,
                        child: Container(
                          alignment: Alignment.center,
                          width: double.infinity,
                          child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: AspectRatio(
                                      aspectRatio: 16 / 9,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(listcours.image),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      )),
                                  //color: Colors.white,
                                ),
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
                                        // const Color.fromARGB(255, 255, 255, 255)
                                        //     .withAlpha(0),
                                        // Color.fromARGB(39, 255, 255, 255),
                                        // Color.fromARGB(121, 255, 255, 255)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(listcours.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.white)),
                                      Row(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.only(right: 8),
                                            child: Icon(
                                              FontAwesomeIcons.solidUser,
                                              size: 16.0,
                                              color: Colors.white,
                                            ),
                                          ),
                                          Text(listcours.coach.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                        ],
                                      ),
                                      RatingBar.readOnly(
                                        isHalfAllowed: false,
                                        filledIcon: FontAwesomeIcons.bolt,
                                        size: 16,
                                        emptyIcon: FontAwesomeIcons.bolt,
                                        filledColor: Theme.of(context)
                                            .colorScheme
                                            .tertiaryContainer,
                                        emptyColor: const Color.fromARGB(
                                            255, 37, 37, 37),
                                        initialRating:
                                            double.parse(listcours.level),
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
                    )))
                .toList(),
          );
        }
      },
    );
  }

  Widget loadcoach() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: coaches
                .map((coach) => Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: ProfileCoachPage(coachID: coach.cid),
                          withNavBar: true,
                        );
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: double.infinity,
                        child: AspectRatio(
                          aspectRatio: 16 / 9,
                          child: Stack(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.topCenter,
                                child: AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimary,
                                        image: DecorationImage(
                                            image: NetworkImage(coach.image),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                                //color: Colors.white,
                              ),
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
                                      // const Color.fromARGB(255, 255, 255, 255)
                                      //     .withAlpha(0),
                                      // Color.fromARGB(39, 255, 255, 255),
                                      // Color.fromARGB(121, 255, 255, 255)
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
                                    Text(coach.fullName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge!
                                            .copyWith(color: Colors.white)),
                                    Row(
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(right: 8),
                                          child: Icon(
                                            FontAwesomeIcons.solidUser,
                                            size: 16.0,
                                            color: Colors.white,
                                          ),
                                        ),
                                        Text(coach.username,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(color: Colors.white)),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )))
                .toList(),
          );
        }
      },
    );
  }
}
