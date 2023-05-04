import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/cousepage.dart';
import '../../model/response/md_Course_get.dart';
import '../../service/course.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class ProfileCoachPage extends StatefulWidget {
  const ProfileCoachPage({super.key});

  @override
  State<ProfileCoachPage> createState() => _ProfileCoachPageState();
}

class _ProfileCoachPageState extends State<ProfileCoachPage> {
  late CourseService courseService;
  late Future<void> loadDataMethod;
  List<ModelCourse> courses = [];
  int cidCoach = 0;
  String qualificationCoach = "";
  String fullnameCoach = "";
  String userNameCoach = " ";
  String propertyC = " ";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cidCoach = context.read<AppData>().cid;
    fullnameCoach = context.read<AppData>().nameCoach;
    qualificationCoach = context.read<AppData>().qualification;
    userNameCoach = context.read<AppData>().usercoach;
    propertyC = context.read<AppData>().propertycoach;

    //couse
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();

    log("AAAA : " + cidCoach.toString());
    log("BBB : " + qualificationCoach);
    log("CCC : " + fullnameCoach);
    log("DDD : " + userNameCoach);
    log("EEE : " + propertyC);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(color: Colors.pink[200], child: showText()),
            ),
            SizedBox(height: 500, width: 390, child: loadshowcouse()),
          ],
        ),
      ),
    );
  }

  Widget showText() {
    return Column(
      children: [
        Text('@' + userNameCoach),
        Text(fullnameCoach),
        Text(qualificationCoach),
        Text(propertyC),
      ],
    );
  }

  Widget loadshowcouse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                if (courses != null)
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Text(course.details),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Get.to(() => showCousePage());
                            },
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

  Future<void> loadData() async {
    try {
      var datas = await courseService.course(cid: cidCoach.toString(), coID: '', name: '');
      courses = datas.data;
      log('couse: $courses');
    } catch (err) {
      log('Error: $err');
    }
  }
}
