import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';

import '../../../model/response/clip_get_res.dart';
import '../../../model/response/course_get_res.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../cousepage.dart';
import 'showDay_mycourse.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyCouses extends StatefulWidget {
  const MyCouses({super.key});

  @override
  State<MyCouses> createState() => _MyCousesState();
}

class _MyCousesState extends State<MyCouses> {
  late CourseService courseService;
  // late HttpResponse<ModelCourse> courses;
  List<Coachbycourse> courses = [];
  List<ModelClip> clips=[];
  late Future<void> loadDataMethod;

  int uid = 0;
  double percen = 0;
  int coID=0;
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
          child: loadcourse(),
        )),
      ]),
    );
  }

  Future<void> loadData() async {
    try {
      log("idcus" + uid.toString());
      var datacouse = await courseService.courseByUid(uid: uid.toString());
      courses = datacouse.data;
      coID = courses.first.coId;
      log('couse: ${courses.length}');
      var dataclips = await courseService.progess(coID.toString());
      log(coID.toString());
      clips = dataclips.data;
      log("clips"+clips.length.toString());
      late int status;
      int sum = 0;
      for(int i=0;i<clips.length-1;i++){
        status = int.parse(clips[i].status);
        sum += status;
        
      }
      log("SUM"+sum.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadcourse() {
    return FutureBuilder(
      future: loadDataMethod,
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
                    log(listcours.coId.toString());
                    log(listcours.image);
                    context.read<AppData>().idcourse = listcours.coId;
                    context.read<AppData>().cid = listcours.coach.cid;
                    Get.to(() => ShowDayMycourse(
                        coID: listcours.coId,
                        img: listcours.image,
                        namecourse: listcours.name,
                        namecoach: listcours.coach.fullName,
                        detail: listcours.details,
                        expirationDate: listcours.expirationDate,
                        dayincourse: listcours.days));
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
                                  // const Color.fromARGB(255, 255, 255, 255)
                                  //     .withAlpha(0),
                                  // Color.fromARGB(39, 255, 255, 255),
                                  // Color.fromARGB(121, 255, 255, 255)
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
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 4.0,top: 4.0),
                                  child: LinearPercentIndicator(
                                    width: 280.0,
                                    lineHeight: 8.0,
                                    percent: 0.1,
                                    backgroundColor:
                                        Color.fromRGBO(255, 249, 249, 1),
                                    progressColor: Colors.greenAccent,
                                  ),
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
      },
    );
  }
}