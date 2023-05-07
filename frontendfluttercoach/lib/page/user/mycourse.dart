import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../model/response/md_Course_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class MyCouses extends StatefulWidget {
  const MyCouses({super.key});

  @override
  State<MyCouses> createState() => _MyCousesState();
}

class _MyCousesState extends State<MyCouses> {
  late CourseService courseService;
  List<ModelCourse> courses = [];
  late Future<void> loadDataMethod;

  int uid = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("รายการซื้อของฉัน"),
      ),
      body: Column(children: [
        Row(
          children: [
            Icon(
              Icons.shopping_basket,
              size: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("รายการซื้อของฉัน"),
            )
          ],
        ),
        Divider(),
        Expanded(
            child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: loadshowcouse(),
        )),
      ]),
    );
  }

  Future<void> loadData() async {
    try {
      log("idcus" + uid.toString());
      var datacouse = await courseService.courseByUid(uid: uid.toString());
      courses = datacouse.data;
      log('couse: ${courses.length}');
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadshowcouse() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: courses.length,
                  itemBuilder: (context, index) {
                    final course = courses[index];
                    print("img =" + course.image);
                    return Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(course.image),
                          ),
                          ListTile(
                            title: Text(course.name),
                            subtitle: Text(course.details),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              //Get.to(() => showCousePage());
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }
}
