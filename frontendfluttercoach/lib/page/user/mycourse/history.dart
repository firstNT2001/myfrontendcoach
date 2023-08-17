import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Buying_get.dart';
import '../../../service/course.dart';
import '../../../service/provider/appdata.dart';
import '../Review/review.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late CourseService courseService;
  List<Buying> courses = [];
  late Future<void> loadDataMethod;

  late int uid;
  @override
  void initState() {
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
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            // Get.to(() => DaysCoursePage(
            //       coID: context.read<AppData>().coID.toString(),
            //       isVisible: widget.isVisible,
            //     ));
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10,bottom: 10,top: 10),
            child: Text("ประวัติการซื้อคอร์ส",
                style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600)),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8,right: 8),
            child: loadcourse(),
          )],
      )),
    );
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
                                      image:
                                          NetworkImage(listcours.course.image),
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
                                const Color.fromARGB(255, 0, 0, 0).withAlpha(0),
                                const Color.fromARGB(49, 0, 0, 0),
                                const Color.fromARGB(127, 0, 0, 0)
                                // const Color.fromARGB(255, 255, 255, 255)
                                //     .withAlpha(0),
                                // const Color.fromARGB(39, 255, 255, 255),
                                // const Color.fromARGB(121, 255, 255, 255)
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(listcours.course.name,
                                  style: Theme.of(context)
                                          .textTheme
                                          .titleLarge!
                                          .copyWith(color: Colors.white),),
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
                                  Text(listcours.course.coach.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),),
                                ],
                              ),
                               RatingBar.readOnly(
                                  isHalfAllowed: false,
                                  filledIcon: FontAwesomeIcons.bolt,
                                  size: 16,
                                  emptyIcon: FontAwesomeIcons.bolt,
                                  filledColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  emptyColor:
                                      Color.fromARGB(255, 245, 245, 245),
                                  initialRating: double.parse(listcours.course.level),
                                  maxRating: 3,
                                ),
                            ],
                          ),
                        ),
                        Positioned(
                            right: 8,
                            bottom: 8,
                            child: FilledButton(
                                onPressed: () {
                                  Get.to(() => ReviewPage(billID: listcours.bid,));
                                },
                                child: const Text("ให้คะแนน")))
                      ],
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

  Future<void> loadData() async {
    try {
      log("idcus$uid");
      var datacouse = await courseService.showcourseEx(uid: uid.toString());
      courses = datacouse.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
