// ignore_for_file: deprecated_member_use

import 'dart:developer';
import 'dart:typed_data';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/response/course_get_res.dart';
import '../../model/response/md_Coach_get.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

import 'course/course_edit_page.dart';

class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  
  // Courses
  late Future<void> loadDataMethod;
  late CourseService _courseService;
  List<ModelCourse> courses = [];
  TextEditingController search = TextEditingController();
  String statusName = "";
  String statusID = "";

  bool checkBoxVal = true;
  bool isVisibles = true;
  bool isVisible = false;

  //image resize
  Uint8List? resizedImg;
  Uint8List? bytes;

  // Coach
  late CoachService _coachService;
  List<Coach> coachs = [];
  String cid = '';
  TextEditingController nameCoach = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    _courseService = context.read<AppData>().courseService;

    cid = context.read<AppData>().cid.toString();

    // 2.2 async method
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color.fromRGBO(244, 243, 243, 1),
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: Colors.black,
          ),
          onPressed: () {},
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Container(
                width: double.infinity,
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(20))),
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hello Coach $cid",
                      style: const TextStyle(
                          color: Color.fromARGB(221, 46, 46, 46), fontSize: 20),
                    ),
                    Text(
                      "เรามาสร้างคอร์สกัน",
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.86,
                        decoration: BoxDecoration(
                            color: const Color.fromRGBO(244, 243, 243, 1),
                            borderRadius: BorderRadius.circular(15)),
                        child: TextField(
                          controller: search,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              focusedBorder: InputBorder.none,
                              prefixIcon: Icon(FontAwesomeIcons.search),
                              hintText: "ค้นหาคอร์สของฉัน",
                              hintStyle: TextStyle(color: Colors.grey)),
                        ),
                      ),
                    ),
                  ],
                )),
            const SizedBox(
              height: 10,
            ),
            Visibility(
              visible: isVisibles,
              child: SizedBox(
                height: MediaQuery.of(context).size.width * 1.06,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadCourse(),
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
      //Courses
      var datas = await _courseService.course(coID: '', cid: cid, name: '');
      courses = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadCourse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                // ignore: unnecessary_null_comparison
                if (courses != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        return Container(
                          padding:
                              const EdgeInsets.only(top: 8, left: 8, right: 8),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => CourseEditPage(
                                    coID: courses[index].coId.toString(),
                                  ));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(courses[index].image,
                                      width: 400,
                                      height: 150,
                                      fit: BoxFit.fill),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 8, bottom: 5),
                                  child: Row(
                                    children: [
                                      Text(
                                        courses[index].name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineSmall,
                                      ),
                                    ],
                                  ),
                                ),
                                Text("ราคา ${courses[index].price.toString()}",
                                    style: const TextStyle(
                                        color: Color.fromARGB(255, 39, 39, 39),
                                        fontSize: 15)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  )
                else
                  Container(),
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
