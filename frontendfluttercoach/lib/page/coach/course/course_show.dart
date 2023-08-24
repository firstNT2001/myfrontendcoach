import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Review_get.dart';
import '../../../model/response/md_amoutclip.dart';
import '../../../model/response/md_coach_course_get.dart';

import '../../../service/buy.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../service/review.dart';
import '../../../widget/dialogs.dart';
import '../../user/mycourse/Widget/widget_loadScore.dart';
import '../../user/mycourse/Widget/widget_loadreview.dart';
import 'course_edit_page.dart';

class ShowCourse extends StatefulWidget {
  const ShowCourse({super.key, required this.coID});
  final String coID;
  @override
  State<ShowCourse> createState() => _ShowCourseState();
}

class _ShowCourseState extends State<ShowCourse> {
  //CourseService
  late BuyCourseService _buyCourseService;

  late CourseService _courseService;
  late ReviewService _reviewService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];
  List<ModelReview> modelReview = [];
  late ModelAmountclip clipamount;

  int amountclip = 0;
  int amountUser = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseService = context.read<AppData>().courseService;
    _reviewService = context.read<AppData>().reviewService;
    _buyCourseService = context.read<AppData>().buyCourseService;
    loadDataMethod = loadDataAsync();
    loadReviewDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        //resizeToAvoidBottomInset: false,

        body: SafeArea(
            child: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              loadDataMethod = loadDataAsync();
              loadReviewDataAsync();
            });
          },
          child: ListView(
            children: [
              showCourse(),
            ],
          ),
        )),
      ),
    );
  }

  //LoadData
  Future<void> loadDataAsync() async {
    try {
      var res =
          await _courseService.course(cid: '', name: '', coID: widget.coID);
      courses = res.data;

      var dataamount = await _courseService.amoutclip(coID: widget.coID);
      clipamount = dataamount.data;
      amountclip = clipamount.amount;
      var dataamountUser =
          await _buyCourseService.amountUserinCourse(originalID: widget.coID);
      amountUser = dataamountUser.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  //LoadData
  Future<void> loadReviewDataAsync() async {
    try {
      var res = await _reviewService.review(coID: widget.coID);
      modelReview = res.data;
      for (var intdex in modelReview) {
        log('score:${intdex.score.toString()}');
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  FutureBuilder<void> showCourse() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                //เพิ่มรูป || แสดงรูป
                inputImage(context),

                show(context),
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  Stack inputImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              image: DecorationImage(
            fit: BoxFit.cover,
            image: NetworkImage(courses.first.image),
          )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
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
              CircleAvatar(
                  backgroundColor: const Color.fromARGB(178, 220, 219, 219),
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.pen,
                    ),
                    onPressed: () {
                      pushNewScreen(
                        context,
                        screen: CourseEditPage(
                          coID: courses.first.coId.toString(),
                          isVisible: true,
                        ),
                        withNavBar: true,
                      ).then((value) {
                        log('ponds');
                        setState(() {
                          loadDataMethod = loadDataAsync();
                          loadReviewDataAsync();
                        });
                      });
                    },
                  )),
            ],
          ),
        ),
      ],
    );
  }

  Padding show(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
             
              children: [
                // Padding(
                //     padding:
                //         const EdgeInsets.only(bottom: 8, top: 28, left: 13),
                //     child: Text('ชื่อ ${courses.first.name}',
                //         style: Theme.of(context).textTheme.headlineSmall)),
                // Padding(
                //   padding: const EdgeInsets.only(right: 25, top: 15),
                //   child: Align(
                //     alignment: Alignment.topRight,
                //     child: WidgetShowScore(
                //       couseID: courses.first.coId.toString(),
                //     ),
                //   ),
                // ),

                Padding(
                  padding: const EdgeInsets.only(left: 15, top: 28, bottom: 5),
                  child: Row(
                    children: [
                      Text(courses.first.name,
                          style: const TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(
                        width: 10,
                      ),
                      RatingBar.readOnly(
                        isHalfAllowed: false,
                        filledIcon: FontAwesomeIcons.bolt,
                        size: 22,
                        emptyIcon: FontAwesomeIcons.bolt,
                        filledColor:
                            Theme.of(context).colorScheme.tertiaryContainer,
                        emptyColor: const Color.fromARGB(255, 179, 179, 179),
                        initialRating: double.parse(courses.first.level),
                        maxRating: 3,
                      ),
                    ],
                  ),
                ),
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(context.read<AppData>().nameCoach,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: SizedBox(
                      height: MediaQuery.of(context).size.height * 0.1,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: Row(children: [
                                    const Icon(FontAwesomeIcons.calendarCheck),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 6),
                                      child: Text(
                                          courses.first.days.toString() +
                                              " วัน",
                                          style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600)),
                                    )
                                  ]),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.37),
                                  child: SizedBox(
                                    child: Row(children: [
                                      const Icon(FontAwesomeIcons.youtube),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 7, top: 6),
                                        child: Text(
                                            amountclip.toString() + " คลิป",
                                            style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600)),
                                      )
                                    ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Stack(
                              children: [
                                SizedBox(
                                  child: courses.first.amount > amountUser
                                      ? Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 10),
                                              child: Icon(
                                                  FontAwesomeIcons.userPlus),
                                            ),
                                            Text(
                                              courses.first.amount.toString() +
                                                  "/" +
                                                  amountUser.toString() +
                                                  " คน",
                                              style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600),
                                            )
                                          ],
                                        )
                                      : courses.first.amount <= amountUser
                                          ? Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 10),
                                                  child: Icon(FontAwesomeIcons
                                                      .userPlus),
                                                ),
                                                Text(
                                                  courses.first.amount
                                                          .toString() +
                                                      "/" +
                                                      amountUser.toString() +
                                                      " คน",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Color.fromARGB(
                                                        255,
                                                        157,
                                                        10,
                                                        0,
                                                      )),
                                                )
                                              ],
                                            )
                                          : Container(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      left: MediaQuery.of(context).size.width *
                                          0.37),
                                  child: SizedBox(
                                    child: courses.first.price > 0
                                        ? Row(
                                            children: [
                                              const Icon(
                                                  FontAwesomeIcons.coins),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 5, top: 6),
                                                child: Text(
                                                    courses.first.price
                                                            .toString() +
                                                        " บาท",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w600)),
                                              )
                                            ],
                                          )
                                        : courses.first.price <= 0
                                            ? const Row(
                                                children: [
                                                  Icon(FontAwesomeIcons.coins),
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 5, top: 6),
                                                    child: Text(" ฟรี",
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w600)),
                                                  )
                                                ],
                                              )
                                            : Container(),
                                    // Row(children: [
                                    // const Icon(
                                    //     FontAwesomeIcons.coins),

                                    //   )
                                    // ]),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Padding(
                    padding: EdgeInsets.only(bottom: 8, left: 15, right: 15),
                    child: Text('รายละเอียดคอร์ส',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w600))),
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 15, right: 15),
                    child: Text('    ${courses.first.details}',
                        style: Theme.of(context).textTheme.bodyLarge)),

                const Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: Divider(
                    color: Color.fromARGB(255, 194, 194, 194),
                    indent: 8,
                    endIndent: 8,
                    thickness: 1.5,
                  ),
                ),
                WidgetloadeReview(
                  couseID: widget.coID,
                ),
                // Center(
                //   child: Padding(
                //     padding:
                //         const EdgeInsets.only(bottom: 18, left: 15, right: 15),
                //     child: SizedBox(
                //         width: MediaQuery.of(context).size.width,
                //         child: button()),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FilledButton button() {
    return FilledButton(
      //style: style,
      onPressed: () async {},
      child: const Text('จัดการวัน'),
    );
  }
}
