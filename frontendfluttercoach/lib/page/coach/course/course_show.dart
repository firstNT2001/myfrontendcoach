import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Review_get.dart';
import '../../../model/response/md_coach_course_get.dart';

import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../../../service/review.dart';
import '../../../widget/dialogs.dart';
import '../../user/mycourse/Widget/widget_loadreview.dart';
import '../navigationbar.dart';
import 'course_edit_page.dart';

class ShowCourse extends StatefulWidget {
  const ShowCourse({super.key, required this.coID});
  final String coID;
  @override
  State<ShowCourse> createState() => _ShowCourseState();
}

class _ShowCourseState extends State<ShowCourse> {
  //CourseService
  late CourseService _courseService;
  late ReviewService _reviewService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];
  List<ModelReview> modelReview = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseService = context.read<AppData>().courseService;
    _reviewService = context.read<AppData>().reviewService;
    loadDataMethod = loadDataAsync();
    loadReviewDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: ListView(
        children: [
          showCourse(),
        ],
      )),
    );
  }

  //LoadData
  Future<void> loadDataAsync() async {
    try {
      var res =
          await _courseService.course(cid: '', name: '', coID: widget.coID);
      courses = res.data;
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
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.chevronLeft,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const NavbarBottomCoach()),
                        ModalRoute.withName('/NavbarBottomCoach'),
                      );
                    },
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                ),
                child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 20,
                    child: IconButton(
                      icon: const Icon(
                        FontAwesomeIcons.pen,
                      ),
                      onPressed: () {
                        Get.to(() => CourseEditPage(
                              coID: courses.first.coId.toString(),
                              isVisible: true,
                            ));
                      },
                    )),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding show(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -7),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(5, 0),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(-5, 0),
              )
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, top: 28, left: 13),
                    child: Text('ชื่อ ${courses.first.name}',
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
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          FontAwesomeIcons.user,
                          color: Colors.white,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(context.read<AppData>().nameCoach,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge!
                                  .copyWith(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                    child: Text('รายละเอียดคอร์ส',
                        style: Theme.of(context).textTheme.bodyLarge)),
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 15, right: 15),
                    child: Text('    ${courses.first.details}',
                        style: Theme.of(context).textTheme.bodyLarge)),
                const Divider(
                  endIndent: 20,
                  indent: 20,
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