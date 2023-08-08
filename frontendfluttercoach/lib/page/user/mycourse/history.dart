import 'dart:developer';

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
      body: SafeArea(
          child: Column(
        children: [loadcourse()],
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
                                // const Color.fromARGB(255, 0, 0, 0).withAlpha(0),
                                // const Color.fromARGB(49, 0, 0, 0),
                                // const Color.fromARGB(127, 0, 0, 0)
                                const Color.fromARGB(255, 255, 255, 255)
                                    .withAlpha(0),
                                const Color.fromARGB(39, 255, 255, 255),
                                const Color.fromARGB(121, 255, 255, 255)
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
                              Text(listcours.course.name,
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
                                  Text(listcours.customer.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                ],
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
