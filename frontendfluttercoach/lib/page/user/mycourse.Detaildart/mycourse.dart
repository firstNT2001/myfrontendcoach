import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../../../model/response/course_get_res.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../cousepage.dart';
import 'showDay_mycourse.dart';

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
      appBar: AppBar(),
      body: Column(children: [
        Row(
          children: [
            Icon(
              Icons.shopping_basket,
              size: 40.0,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Text("รายการซื้อของฉัน",
                  style: Theme.of(context).textTheme.bodyLarge),
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
                shrinkWrap: true,
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final listcours = courses[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Card(
                      elevation: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Image.network(listcours.image,
                              width: 400, height: 150, fit: BoxFit.fill),
                          ListTile(
                            title: Text(listcours.name,
                                style: Theme.of(context).textTheme.bodyLarge),
                            subtitle: Text(listcours.coach.fullName,
                                style: Theme.of(context).textTheme.bodyMedium),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 8, bottom: 8),
                            child: FilledButton(
                                onPressed: () {
                                  log(listcours.coId.toString());
                                  log(listcours.image);   
                                  context.read<AppData>().idcourse = listcours.coId;                           
                                  Get.to(() => ShowDayMycourse(
                                      coID: listcours.coId,
                                      img: listcours.image,
                                      namecourse:  listcours.name,
                                      namecoach: listcours.coach.fullName,
                                      detail: listcours.details,
                                      expirationDate:  listcours.expirationDate,
                                      dayincourse: listcours.days));
                                },
                                child: Text("ดูรายละเอียดเพิ่มเติม",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium)),
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
      },
    );
  }
}
