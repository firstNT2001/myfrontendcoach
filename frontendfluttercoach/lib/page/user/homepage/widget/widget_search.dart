import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_Coach_get.dart';

import '../../../../model/response/md_coach_course_get.dart';
import '../../../../service/coach.dart';
import '../../../../service/course.dart';

import '../../../../service/provider/appdata.dart';
import '../../cousepage.dart';
import '../../mycourse/Widget/widget_loadScore.dart';
import '../../profilecoach.dart';

class Widgetsearch extends StatefulWidget {
  const Widgetsearch({super.key});

  @override
  State<Widgetsearch> createState() => _WidgetsearchState();
}

class _WidgetsearchState extends State<Widgetsearch> {
  late Future<void> loadDataMethod;
  late CoachService coachService;
  late CourseService courseService;

  List<Coach> coaches = [];
  List<Course> courses = [];
  TextEditingController myController = TextEditingController();
  bool isVisibleCoach = true;
  bool isVisibleCourse = true;
  bool isVisibleText = false;
  // bool isVisibleSearch = false;
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
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 18),
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
                          //isVisibleSearch = true;
                          isVisibleText = false;
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
                                isVisibleCoach = true;
                                isVisibleText = false;
                              });

                              //log(coaches.length.toString());
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
                                //isVisibleCoach = true;
                                isVisibleCourse = true;
                                isVisibleText = false;
                              });

                              log(coaches.length.toString());
                            }
                          });
                        } else {
                          log("contro ว่าง");
                          coachService
                              .coach(
                                  nameCoach: '',
                                  cid: "",
                                  email: '')
                              .then((coachdata) {
                            var datacoach = coachdata.data;
                            //var checkcoaches = coaches.length;
                            coaches = datacoach;
                            if (coaches.isNotEmpty) {
                              log("coaches.isNotEmpty");
                              setState(() {
                                isVisibleCoach = true;
                                isVisibleText = false;
                              });

                              //log(coaches.length.toString());
                            }
                          });
                          courseService
                              .courseOpenSell(
                                  cid: '', coID: '', name: '')
                              .then((coursedata) {
                            var datacourse = coursedata.data;
                            courses = datacourse;
                            if (courses.isNotEmpty) {
                              log("courses.isNotEmpty");
                              setState(() {
                                //isVisibleCoach = true;
                                isVisibleCourse = true;
                                isVisibleText = false;
                              });

                              log(coaches.length.toString());
                            }
                          });
                          // setState(() {
                          //   isVisibleText = false;

                          //   isVisibleCourse = true;
                          // });
                        }
                        if (courses.isEmpty && coaches.isEmpty) {
                          setState(() {
                            isVisibleText = true;
                          });

                          log(coaches.length.toString());
                        }
                      },
                      // onSubmitted: (value) {

                      // },
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
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 10, top: 20),
              child: Text(
                "คอร์สและโค้ชทั้งหมด",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            Center(
              child: Visibility(
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
                      Text('" ' + myController.text + ' "',
                          style: const TextStyle(
                              fontSize: 18,
                              color: Color.fromARGB(96, 85, 85, 85)))
                    ],
                  ),
                ),
              ),
            ),
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
        ),
      ),
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
          bool isVisibleTextFree = false;
          for(int i=0;i<courses.length;i++){
            
            if(courses[i].price<=0){
              isVisibleTextFree = true;
            }else{
              isVisibleTextFree = false;
            }
            log("TF = "+isVisibleTextFree.toString()+"Price"+courses[i].price.toString());
          }
          
          return Column(
            children: courses
                .map((listcours) => Padding(
                  padding:
                      const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      log("ID = "+listcours.coId.toString()+"TF = "+isVisibleTextFree.toString()+"Price"+listcours.price.toString());
                      context.read<AppData>().idcourse = listcours.coId;
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
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                                //color: Colors.white,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width *
                                      0.78,
                                ),
                                child:  (listcours.price<=0)?
                                  Align(
                                  alignment: Alignment.topRight,
                                  child: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        stops: [.5, .5],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color.fromARGB(255, 185, 0, 0),
                                          Colors.transparent, // top Right part
                                        ],
                                      ),
                                    ),
                                    child:  Padding(
                                      padding:
                                          EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.075, top: 7),
                                      child: Text("ฟรี",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ):(listcours.price>0)?Container():Container()
                                
                               
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
                              Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              listcours.name,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .titleLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
                                          ],
                                        ),
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
                                            Text(
                                              listcours.coach.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white),
                                            ),
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
                                              255, 245, 245, 245),
                                          initialRating:
                                              double.parse(listcours.level),
                                          maxRating: 3,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                      alignment: Alignment.bottomRight,
                                      child: Container(
                                        height: 45,
                                        width: 45,
                                        child: WidgetShowScore(
                                          couseID: listcours.coId.toString(),
                                        ),
                                      )),
                                  // Positioned(
                                  //   top: double.infinity,
                                  //   child: WidgetShowScore(
                                  //       couseID: listcours.coId.toString(),
                                  //     ),)

                                  //     Align(
                                  //   alignment: Alignment.bottomRight,
                                  //   child: WidgetShowScore(
                                  //           couseID: listcours.coId.toString(),
                                  //         ),
                                  // ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                )
                    )
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
          return Container();
        } else {
          return Column(
            children: coaches
                .map((coach) => Padding(
                    padding:
                        const EdgeInsets.only(left: 18, right: 18, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: ProfileCoachPage(coachID: coach.cid),
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
                    )))
                .toList(),
          );
        }
      },
    );
  }
}
