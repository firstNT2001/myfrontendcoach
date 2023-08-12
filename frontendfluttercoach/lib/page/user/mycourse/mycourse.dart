import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../model/response/clip_get_res.dart';
import '../../../model/response/md_Buying_get.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../model/response/md_process.dart';
import '../../../service/course.dart';
import '../../../service/progessbar.dart';
import '../../../service/provider/appdata.dart';
import 'history.dart';
import 'showDay_mycourse.dart';
import 'package:percent_indicator/percent_indicator.dart';

class MyCouses extends StatefulWidget {
  const MyCouses({super.key});

  @override
  State<MyCouses> createState() => _MyCousesState();
}

class _MyCousesState extends State<MyCouses> {
  late CourseService _courseService;
  late ProgessbarService progessService;
  // late HttpResponse<ModelCourse> courses;
  late Modelprogessbar progess;
  List<Course> mycourse = [];
  List<Buying> courses = [];
  List<ModelClip> clips = [];
  List<double> listpercent =[];
  late Future<void> loadDataMethod;

  double percen = 0.00;

  //show day not ex
  DateTime nows = DateTime.now();
  late DateTime today;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    progessService =
        ProgessbarService(Dio(), baseUrl: context.read<AppData>().baseurl);
    _courseService = context.read<AppData>().courseService;
    loadDataMethod = loadData();
    
    today = DateTime(nows.year, nows.month, nows.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(children: [
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
                icon: const Icon(
                  Icons.history_rounded,
                  size: 40,
                ),
                onPressed: () {
                  pushNewScreen(
                      context,
                      screen: const HistoryPage(),
                      withNavBar: true,
                    );    
                }),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 15),
            child: Row(
              children: [
                const Icon(
                  Icons.shopping_basket,
                  size: 28.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Text("รายการซื้อของฉัน",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ],
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: loadcourse(),
          )),
        ]),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      log(context.read<AppData>().uid.toString());
      var datas = await _courseService.showcourseNotEx(
          uid: context.read<AppData>().uid.toString());
      courses = datas.data;
      for (int i = 0; i < courses.length; i++) {
        log("i${courses[i].courseId}");
        var datas = await progessService.processbar(
            coID: courses[i].courseId.toString());
        progess = datas.data;
        percen=progess.percent/100;
        listpercent.add(percen);
        log("percent${percen.toString()}");
      }
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
              final listpercents = listpercent[index];
              final listshowpercents = listpercent[index]*100;
              
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: InkWell(
                  onTap: () {
                    context.read<AppData>().cid = listcours.course.coachId;
                    log(listcours.customerId.toString());
                    log(listcours.course.image);
                    String stExpirationDay = listcours.course.expirationDate;
                    context.read<AppData>().idcourse = listcours.course.coId;
                    //context.read<AppData>().cid = listcours.coach.cid;
                    pushNewScreen(
                      context,
                      screen: ShowDayMycourse(
                        coID: listcours.course.coId,
                        img: listcours.course.image,
                        namecourse: listcours.course.name,
                        namecoach: listcours.course.coach.fullName,
                        detail: listcours.course.details,
                        expirationDate: stExpirationDay,
                        dayincourse: listcours.course.days) ,
                      withNavBar: true,
                    );    
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
                                        image: NetworkImage(
                                            listcours.course.image),
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
                                Text(
                                  listcours.course.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(right: 8),
                                      child: Icon(
                                        FontAwesomeIcons.solidUser,
                                        size: 16.0,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      listcours.course.coach.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(bottom: 4.0, top: 4.0),
                                  child: FittedBox(
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      fillColor:
                                          Color.fromARGB(0, 255, 255, 255),
                                      lineHeight: 10.0,
                                      percent: listpercents,
                                      trailing: Text(
                                        listshowpercents.toString()+"%",
                                        style: TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                      barRadius: Radius.circular(7),
                                      backgroundColor: Colors.grey,
                                      progressColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding: const EdgeInsets.only(
                                //       bottom: 4.0, top: 4.0),
                                //   child: LinearPercentIndicator(
                                //     width: 280.0,
                                //     lineHeight: 8.0,
                                //     percent: 0.1,
                                //     backgroundColor:
                                //         const Color.fromRGBO(255, 249, 249, 1),
                                //     progressColor: Colors.greenAccent,
                                //   ),
                                // ),
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
