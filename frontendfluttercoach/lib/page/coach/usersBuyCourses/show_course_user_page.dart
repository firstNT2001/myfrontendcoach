import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_Buying_get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_process.dart';
import '../../../service/buy.dart';
import '../../../service/progessbar.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../course/course_edit_page.dart';

class ShowCourseUserPage extends StatefulWidget {
  const ShowCourseUserPage({super.key, required this.uid});
  final String uid;
  @override
  State<ShowCourseUserPage> createState() => _ShowCourseUserPageState();
}

class _ShowCourseUserPageState extends State<ShowCourseUserPage> {
  // Courses
  late Future<void> loadCourseDataMethod;
  late BuyCourseService _buyingService;
  late ProgessbarService _progessService;
  late Modelprogessbar progess;

  List<Buying> courses = [];
  List<double> lisetProgessbar = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _progessService = context.read<AppData>().progessbar;
    _buyingService = context.read<AppData>().buyCourseService;

    loadCourseDataMethod = loadUserData();

  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          //backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            "",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Get.back();
            },
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(child: showCourse()),
            ],
          ),
        ));
  }

  //LoadData
  Future<void> loadUserData() async {
    try {
      var datacouse = await _buyingService.buying(
          uid: widget.uid,
          cid: context.read<AppData>().cid.toString(),
          coID: '');
      courses = datacouse.data;

      log(courses.length.toString());
      for (int i = 0; i < courses.length; i++) {
        log("i${courses[i].courseId}");
        var datas = await _progessService.processbar(
            coID: courses[i].courseId.toString());
        progess = datas.data;
        lisetProgessbar.add((progess.percent / 100).toPrecision(1));
        log("percent${lisetProgessbar[i].toString()}");
      }
    } catch (err) {
      log('Error: $err');
    }
  }

 

  Widget showCourse() {
    return FutureBuilder(
      future: loadCourseDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final listcours = courses[index];
              final listpercents = lisetProgessbar[index];
              final listshowpercents = lisetProgessbar[index] * 100;
              return Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: InkWell(
                  onTap: () {
                    Get.to(() => CourseEditPage(
                          coID: listcours.course.coId.toString(),
                          isVisible: false,
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
                                  padding: const EdgeInsets.only(
                                      bottom: 4.0, top: 4.0),
                                  child: FittedBox(
                                    child: LinearPercentIndicator(
                                      width: MediaQuery.of(context).size.width *
                                          0.65,
                                      fillColor: const Color.fromARGB(
                                          0, 255, 255, 255),
                                      lineHeight: 10.0,
                                      percent: listpercents,
                                      trailing: Text(
                                        "$listshowpercents%",
                                        style: const TextStyle(
                                            fontSize: 16.0,
                                            color: Colors.white),
                                      ),
                                      barRadius: const Radius.circular(7),
                                      backgroundColor: Colors.grey,
                                      progressColor:
                                          Theme.of(context).colorScheme.primary,
                                    ),
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
