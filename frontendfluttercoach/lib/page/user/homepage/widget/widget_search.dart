import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
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
  late HttpResponse<Customer> customer;
  List<Coach> coaches = [];
  List<Course> courses = [];
  TextEditingController myController = TextEditingController();
  bool isVisibleCoach = false;
  bool isVisibleCourse = true;
  bool isVisibleText = true;
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
                        log("logg " + myController.text);
                        coachService
                            .coach(nameCoach: myController.text, cid: "")
                            .then((coachdata) {
                          var datacoach = coachdata.data;
                          //var checkcoaches = coaches.length;
                          coaches = datacoach;
                          // if (coaches.isNotEmpty) {
                          //   //log("message"+coaches.first);
                          //   setState(() {
                          //     isVisibleCoach = true;
                          //     isVisibleCourse = false;
                          //   });

                          //   log(coaches.length.toString());
                          // } else {
                          //   setState(() {
                          //     isVisibleCoach = false;
                          //     isVisibleCourse = true;
                          //   });
                          // }
                        });
                        courseService
                            .course(cid: '', coID: '', name: myController.text)
                            .then((coursedata) {
                          var datacourse = coursedata.data;
                          courses = datacourse;
                          // if (courses.isNotEmpty) {
                          //   setState(() {});
                          //   log(courses.length.toString());
                          // }
                        });
                      } else {
                        Container();
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
                        prefixIcon: Icon(FontAwesomeIcons.search),
                        hintText: "ค้นหา",
                        hintStyle: TextStyle(color: Colors.grey)),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                FilledButton(onPressed: () {setState(() {
                      isVisibleCoach = false;
                      isVisibleCourse = true;
                    });}, child: Text("คอร์ส")),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: FilledButton(
                      onPressed: () {
                        setState(() {
                          isVisibleCoach = true;
                          isVisibleCourse = false;
                        });
                      },
                      child: Text("โค้ช")),
                ),
                
              ],
            ),
            // Visibility(
            //   visible: isVisibleText,
            //   child: Container(
            //     height: 500,
            //     child: Row(
            //       crossAxisAlignment: CrossAxisAlignment.center,
            //       mainAxisAlignment: MainAxisAlignment.center,
            //                   children: [
            //                     Icon(Icons.search,size: 70,color: const Color.fromARGB(96, 85, 85, 85)),
            //                     Text("ค้นหา",style: TextStyle(fontSize: 50,color: Color.fromARGB(96, 85, 85, 85) )),
            //                   ],
            //                 ),
            //   ),
            // ),
            Visibility(
              visible: isVisibleCoach,
              child: Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: coaches.length,
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        return  Padding(
                          padding: const EdgeInsets.all(8.0),
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
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
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
      var datacourse = await courseService.course(coID: '', cid: '', name: '');
      courses = datacourse.data;
      customer = await customerService.customer(uid: uid.toString());
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
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
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
                                      color:
                                          Theme.of(context).colorScheme.onPrimary,
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
                                    emptyColor: Color.fromARGB(255, 37, 37, 37),
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
            ),
          );
        }
      },
    );
  }
}
