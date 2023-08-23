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
import 'Widget/widget_loadprogess.dart';
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
 
  // late HttpResponse<ModelCourse> courses;

  List<Course> mycourse = [];
  List<Buying> courses = [];
  List<ModelClip> clips = [];

    List<double> listpercentText =[];
  late Future<void> loadDataMethod;


  //show day not ex
  DateTime nows = DateTime.now();
  late DateTime today;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  
  
    _courseService = context.read<AppData>().courseService;
    
    loadDataMethod = loadData();
    today = DateTime(nows.year, nows.month, nows.day);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        actions: [IconButton(
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
                }),]),
      body: SafeArea(
        child: RefreshIndicator(
            onRefresh: () async{
              setState(() {
                loadDataMethod = loadData();
              });
            },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,bottom: 10),
              child: Text("รายการซื้อของฉัน",
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
            ),
            Expanded(
                child: loadcourse()),
          ]),
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      log(context.read<AppData>().uid.toString());
      var datas = await _courseService.showcourseNotEx(
          uid: context.read<AppData>().uid.toString());
      courses = datas.data;
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
                    context.read<AppData>().cid = listcours.course.coachId;
                    context.read<AppData>().idcourse = listcours.course.coId;
                    log(listcours.customerId.toString());
                    log(listcours.course.image);
                    String stExpirationDay = listcours.course.expirationDate;
                    context.read<AppData>().idcourse = listcours.course.coId;
                    //context.read<AppData>().cid = listcours.coach.cid;
                    pushNewScreen(
                      context,
                      screen: ShowDayMycourse(namecourse: listcours.course.name, nameCoach: listcours.course.coach.fullName,) ,
                      withNavBar: true,
                    );    
                  },
                  child: Card(
                    elevation: 10,
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
                                  WidgetProgess(coID: listcours.courseId.toString(),)
                                 
                                ],
                              ),
                            )
                          ],
                        ),
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
