import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';


import '../../model/response/course_get_res.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import 'cousepage.dart';

class MyCouses extends StatefulWidget {
  const MyCouses({super.key});

  @override
  State<MyCouses> createState() => _MyCousesState();
}

class _MyCousesState extends State<MyCouses> {
  late CourseService courseService;
 // late HttpResponse<ModelCourse> courses;
  List<Coachbycourse> courses = [];
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
        ),Divider(),
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
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final listcours = courses[index];
            
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.network(listcours.image,
                              width: 400,
                              height: 150,
                              fit: BoxFit.fill),
                          ListTile(
                            title: Text(listcours.name)
                            //subtitle: Text(listcours.details),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8,bottom: 8),
                            child: ElevatedButton(
                                onPressed: () {
                                  log(listcours.coId.toString());
                                  context.read<AppData>().idcourse =
                                      listcours.coId;
            
                                  Get.to(() => const showCousePage());
                                },
                                child: const Text(
                                    "ดูรายละเอียดเพิ่มเติม")),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ))
            ],
          );
        }
      },);
  }
}
