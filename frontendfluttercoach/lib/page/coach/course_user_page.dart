import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_coach_course_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class CourseUserPage extends StatefulWidget {
  const CourseUserPage({super.key});

  @override
  State<CourseUserPage> createState() => _CourseUserPageState();
}

class _CourseUserPageState extends State<CourseUserPage> {
   //Course
  List<Course> courses = [];
  late Future<void> loadCourseDataMethod;
  late CourseService _CourseService;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _CourseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadCourseData();

  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              "",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          
          ),
      body: Column(
        children: [
           Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: showCourse(),
                ),
              ),
        ],
      ),
    );
  }
  
   Future<void> loadCourseData() async {
    try {
      var response = await _CourseService.usersBuyCourses(context.read<AppData>().cid.toString());
      courses = response.data;
      // log(requests.length.toString());
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
                                  image: NetworkImage(listcours.buying!.customer.image),
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
                                listcours.buying!.customer.fullName,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            // IntrinsicHeight(
                            //   child: Row(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children: [
                            //       const Icon(
                            //         FontAwesomeIcons.solidStar,
                            //         color: Colors.yellow,
                            //         size: 20,
                            //       ),
                            //       const SizedBox(
                            //         width: 10,
                            //       ),
                            //       const Text("4.5"),
                            //       const VerticalDivider(),
                            //       Text(listcours.price.toString()),
                            //     ],
                            //   ),
                            // ),
                            // if (listcours.status == '1') ...{
                            //   Text(
                            //     "กำลังขาย",
                            //     style: Theme.of(context).textTheme.bodySmall,
                            //   ),
                            // } else
                            //   Text(
                            //     "ปิดการขาย",
                            //     style: Theme.of(context).textTheme.bodySmall,
                            //   ),
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
}