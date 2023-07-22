import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_coach_course_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import '../coach/course/course_edit_page.dart';

class SearchCoursePage extends StatefulWidget {
  const SearchCoursePage({super.key});

  @override
  State<SearchCoursePage> createState() => _SearchCoursePageState();
}

class _SearchCoursePageState extends State<SearchCoursePage> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late CourseService _courseService;
  List<Course> courses = [];

  TextEditingController searchName = TextEditingController();

  @override
  void initState() {
    super.initState();
    _courseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          searchBar(context),
          const SizedBox(height: 20),
          Expanded(
            child: showCourse(),
          ),
        ],
      )),
    );
  }

  //SearchBar
  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(244, 243, 243, 1),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: searchName,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  //isVisibles = true;
                  _courseService
                      .course(
                          coID: '',
                          cid: context.read<AppData>().cid.toString(),
                          name: searchName.text)
                      .then((fooddata) {
                    var datafoods = fooddata.data;
                    courses = datafoods;
                    if (courses.isNotEmpty) {
                      setState(() {});
                      log(courses.length.toString());
                    }
                  });
                });
              },
              onSubmitted: (value) {},
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  suffixIcon: Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.black,
                  ),
                  hintText: "ค้นหา...",
                  hintStyle: TextStyle(color: Colors.grey)),
            ),
          ),
        ],
      ),
    );
  }

  //LoadData
  Future<void> loadCourseData() async {
    try {
      //Courses
      var datas = await _courseService.course(
          coID: '',
          cid: context.read<AppData>().cid.toString(),
          name: searchName.text);
      courses = datas.data;
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
                          coID: courses[index].coId.toString(), isVisible: false,
                        ));
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
                                    color: const Color(0xff7c94b6),
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
}
