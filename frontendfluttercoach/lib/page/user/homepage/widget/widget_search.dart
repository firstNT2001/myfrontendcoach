import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../model/response/md_Coach_get.dart';
import '../../../../model/response/md_Customer_get.dart';
import '../../../../model/response/md_coach_course_get.dart';
import '../../../../service/coach.dart';
import '../../../../service/course.dart';
import '../../../../service/customer.dart';
import '../../../../service/provider/appdata.dart';
import '../../cousepage.dart';

class Widgetsearch extends StatefulWidget {
  const Widgetsearch({super.key});

  @override
  State<Widgetsearch> createState() => _WidgetsearchState();
}

class _WidgetsearchState extends State<Widgetsearch> {
  late Future<void> loadDataMethod;
  late CoachService coachService;
  late CourseService courseService;

  late CustomerService customerService;
  List<Customer> customer = [];
  List<Coach> coaches = [];
  List<Course> courses = [];
  TextEditingController myController = TextEditingController();
  bool isVisibleCoach = false;
  bool isVisibleCourse = true;
  bool isVisibleText = false;
  bool isVisibleSearch = false;
  int uid = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 243, 243, 244),
                      borderRadius: BorderRadius.circular(15)),
                  child: TextField(
                    controller: myController,
                    onChanged: (value) {
                      if (myController.text.isNotEmpty) {
                        //isVisibleSearch = true;
                        isVisibleText = false;
                        isVisibleSearch = false;
                        setState(() {});
                        log("contro ไม่ว่าง");
                        coachService
                            .coach(
                                nameCoach: myController.text,
                                cid: "",
                                email: '')
                            .then((coachdata) {
                          var datacoach = coachdata.data;
                          //var checkcoaches = coaches.length;
                          coaches = datacoach;
                          if (coaches.isNotEmpty) {
                            log("coaches.isNotEmpty");
                            setState(() {
                              //isVisibleCoach = true;
                              isVisibleSearch = false;
                              isVisibleText = false;
                            });

                            //log(coaches.length.toString());
                          } else {
                            log("coaches.isEmpty");
                            setState(() {
                              //isVisibleCoach = false;
                              isVisibleSearch =false;
                              isVisibleText = true;
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
                              isVisibleSearch = false;
                              //isVisibleCoach = true;
                              isVisibleText = false;
                            });

                            log(coaches.length.toString());
                          } else {
                            log("courses.isEmpty");
                            setState(() {
                              isVisibleSearch = false;
                              //isVisibleCoach = false;
                              isVisibleText = true;
                            });
                          }
                        });
                      } else {
                        log("contro ว่าง");
                        setState(() {
                          isVisibleText = false;
                          isVisibleSearch = true;
                          isVisibleCoach = false;
                          isVisibleCourse = false;
                        });
                      }
                    },
                    // onSubmitted: (value) {

                    // },
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1,
                              color: Theme.of(context)
                                  .colorScheme
                                  .tertiary), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              width: 1.5,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primary), //<-- SEE HERE
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        prefixIcon: const Icon(FontAwesomeIcons.search),
                        hintText: "ค้นหา",
                        hintStyle: const TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(
                    onPressed: () {
                       if (courses.isEmpty) {
                          log("coaEm");
                          setState(() {
                            isVisibleText = false;
                            isVisibleSearch = true;
                            isVisibleCoach = false;
                            isVisibleCourse = false;
                          });
                        } else {

                          log("notcoaEm");
                          setState(() {
                            isVisibleText = false;
                            isVisibleCoach = false;
                            isVisibleCourse = true;
                            isVisibleSearch = false;
                          });}
                    },
                    child: const Text("คอร์ส")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FilledButton(
                      onPressed: () {
                        if (coaches.isEmpty) {
                          log("coaEm");
                          setState(() {
                           // isVisibleSearch
                           isVisibleText = false;
                            isVisibleSearch = true;
                            isVisibleCoach = false;
                            isVisibleCourse = false;
                          });
                        } else {
                          log("notcoaEm");
                          setState(() {
                            isVisibleText = false;
                            isVisibleCoach = true;
                            isVisibleCourse = false;
                            isVisibleSearch = false;
                          });
                        }
                        // setState(() {
                        //   isVisibleCoach = true;
                        //   isVisibleCourse = false;
                        // });
                      },
                      child: const Text("โค้ช")),
                ),
              ],
            ),
            Visibility(
              visible: isVisibleText,
              child: SizedBox(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
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
            Visibility(
              visible: isVisibleSearch,
              child: const SizedBox(
                height: 100,
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
            Visibility(
              visible: isVisibleCoach,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: coaches.length,
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: InkWell(
                            onTap: () {
                              pushNewScreen(
                                context,
                                screen: const showCousePage(),
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
                                                  image:
                                                      NetworkImage(coach.image),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(coach.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
                                          Row(
                                            children: [
                                              const Padding(
                                                padding:
                                                    EdgeInsets.only(right: 8),
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
                                                      .copyWith(
                                                          color: Colors.white)),
                                            ],
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
                        // Card(
                        //   color: Theme.of(context).colorScheme.outline,
                        //   child: ListTile(
                        //     leading: CircleAvatar(
                        //       radius: 50,
                        //       backgroundImage: NetworkImage(coach.image),
                        //     ),
                        //     title: Text(coach.username.toString(),
                        //         style: Theme.of(context).textTheme.bodyLarge),
                        //     subtitle: Text(coach.fullName,
                        //         style: Theme.of(context).textTheme.bodyLarge),
                        //     trailing: const Icon(Icons.arrow_forward),
                        //   ),
                        // );
                      }),
                ),
              ),
            ),
            //showCourse
            Visibility(
              visible: isVisibleCourse,
              child: Expanded(
                child: loadcourse(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var datacourse =
          await courseService.courseOpenSell(coID: '', cid: '', name: '');
      courses = datacourse.data;
      var result =
          await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
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
          return Padding(
            padding: const EdgeInsets.only(
              left: 10,
              right: 10,
            ),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                final listcours = courses[index];
                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: InkWell(
                    onTap: () {
                      Get.to(() => const showCousePage());
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
                                          image: NetworkImage(listcours.image),
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
                                              .copyWith(color: Colors.white)),
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
                                    emptyColor: const Color.fromARGB(255, 37, 37, 37),
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
                );
              },
            ),
          );
        }
      },
    );
  }
}
