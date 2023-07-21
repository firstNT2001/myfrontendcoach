import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/usersBuyCourses/show_course_user_page.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';

class ShowCourseUserPage extends StatefulWidget {
  const ShowCourseUserPage({super.key, required this.uid});
  final String uid;
  @override
  State<ShowCourseUserPage> createState() => _ShowCourseUserPageState();
}

class _ShowCourseUserPageState extends State<ShowCourseUserPage> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late CourseService _courseService;
  List<Buying> courses = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadUserData();
    log(widget.uid);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.primary,
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
            loadcourse(),
          ],
        ));
  }

  //LoadData
  Future<void> loadUserData() async {
    try {
      var datacouse = await _courseService.showcourseEx(uid: widget.uid);
      courses = datacouse.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadcourse() {
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
              final course = courses[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.15,
                child: InkWell(
                  onTap: () {
                    Get.to(() => ShowCourseUserPage(uid: course.customer.uid.toString()));
                  },
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.start,
                    // crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          // ignore: unnecessary_null_comparison
                          if (course.customer.image != '-') ...{
                            CircleAvatar(
                              backgroundImage:
                                  NetworkImage(course.customer.image),
                              radius: 35,
                            )
                          } else
                            const CircleAvatar(
                              backgroundImage: NetworkImage(
                                  'https://i.pinimg.com/564x/a8/0e/36/a80e3690318c08114011145fdcfa3ddb.jpg'),
                              radius: 35,
                            ),
                          const SizedBox(width: 20),
                          AutoSizeText(
                            course.customer.fullName,
                            maxLines: 5,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(endIndent: 20, indent: 20)
                    ],
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
