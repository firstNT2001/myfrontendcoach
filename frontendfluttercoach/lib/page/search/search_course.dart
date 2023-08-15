import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:switcher_button/switcher_button.dart';

import '../../model/request/course_courseID_put.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dialogs.dart';
import '../coach/course/course_edit_page.dart';
import '../coach/navigationbar.dart';

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
  late ModelResult modelResult;

  @override
  void initState() {
    super.initState();
    _courseService = context.read<AppData>().courseService;
    loadCourseDataMethod = loadCourseData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false, child: scaffold(context));
  }

  Scaffold scaffold(BuildContext context) {
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
             Navigator.pushAndRemoveUntil<void>(
                        context,
                        MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const NavbarBottomCoach()),
                        ModalRoute.withName('/NavbarBottomCoach'),
                      );
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
          return Center(child: load(context));
        } else {
          return listViewCourse();
        }
      },
    );
  }

  ListView listViewCourse() {
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
                    coID: courses[index].coId.toString(),
                    isVisible: true,
                  ));
            },
            child: Container(
              alignment: Alignment.center,
              width: double.infinity,
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Stack(
                  children: <Widget>[
                    if (listcours.image != '') ...{
                      Container(
                        alignment: Alignment.topCenter,
                        child: AspectRatio(
                            aspectRatio: 16 / 9,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Theme.of(context).colorScheme.onPrimary,
                                image: DecorationImage(
                                    image: NetworkImage(listcours.image),
                                    fit: BoxFit.cover),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                        //color: Colors.white,
                      ),
                    },
                    (listcours.status == '1')
                        ? Container(
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
                          )
                        : Container(
                            padding: const EdgeInsets.all(5.0),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(148, 0, 0, 0),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Center(
                              child: Text(
                                'ปิด',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineLarge!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          (listcours.status == '1')
                              ? SwitcherButton(
                                  value: true,
                                  onChange: (value) async {
                                    CourseCourseIdPut request =
                                        CourseCourseIdPut(
                                            status: '0',
                                            amount: listcours.amount,
                                            days: listcours.days,
                                            details: listcours.details,
                                            image: listcours.image,
                                            level: listcours.level,
                                            name: listcours.name,
                                            price: listcours.price);

                                    await updateStatus(
                                        request, listcours.coId.toString());
                                    log("1$value");
                                  },
                                )
                              : SwitcherButton(
                                  value: false,
                                  onChange: (value) async {
                                    CourseCourseIdPut request =
                                        CourseCourseIdPut(
                                            status: '1',
                                            amount: listcours.amount,
                                            days: listcours.days,
                                            details: listcours.details,
                                            image: listcours.image,
                                            level: listcours.level,
                                            name: listcours.name,
                                            price: listcours.price);

                                    await updateStatus(
                                        request, listcours.coId.toString());
                                    log("0$value");
                                  },
                                ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            listcours.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(color: Colors.white),
                          ),
                          RatingBar.readOnly(
                            isHalfAllowed: false,
                            filledIcon: FontAwesomeIcons.bolt,
                            size: 16,
                            emptyIcon: FontAwesomeIcons.bolt,
                            filledColor:
                                Theme.of(context).colorScheme.tertiaryContainer,
                            emptyColor: Color.fromARGB(255, 245, 245, 245),
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
    );
  }

  Future<void> updateStatus(CourseCourseIdPut request, String coID) async {
    var response = await _courseService.updateCourseByCourseID(coID, request);
    modelResult = response.data;
    log(coID);
    log(modelResult.result);
    if (modelResult.result == '0') {
    } else {
      setState(() {
        loadCourseDataMethod = loadCourseData();
      });
    }
  }
}
