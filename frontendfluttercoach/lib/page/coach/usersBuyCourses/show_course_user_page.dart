import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_coach_course_get.dart';
import '../../../model/response/md_days.dart';
import '../../../service/course.dart';
import '../../../service/days.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../../user/chat/chat.dart';
import '../course/FoodAndClip/course_food_clip.dart';

class ShowCourseOfUserPage extends StatefulWidget {
  const ShowCourseOfUserPage({super.key, required this.coID});
  final String coID;
  @override
  State<ShowCourseOfUserPage> createState() => _ShowCourseOfUserPageState();
}

class _ShowCourseOfUserPageState extends State<ShowCourseOfUserPage> {
  //Service
  //CourseService
  late CourseService _courseService;
  late Future<void> loadDataMethod;
  List<Course> courses = [];

  //Days
  late DaysService _daysService;
  late Future<void> loadDaysDataMethod;
  List<ModelDay> modelDays = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _courseService = context.read<AppData>().courseService;
    loadDataMethod = loadDataAsync();

    _daysService = context.read<AppData>().daysService;

    loadDaysDataMethod = loadDaysDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            showCourse(),
            showDays(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> showCourse() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                //เพิ่มรูป || แสดงรูป
                inputImage(context),
                Positioned(child: showText(context)),
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  Stack inputImage(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.4,
          decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    spreadRadius: 2,
                    blurRadius: 10,
                    color: Colors.black.withOpacity(0.1))
              ],
              //shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(courses.first.image),
              )),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.grey.shade600,
                        spreadRadius: 1,
                        blurRadius: 15)
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 20,
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.chevronLeft,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding showText(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade600,
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, -7),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(5, 0),
              ),
              BoxShadow(
                color: Colors.grey.shade300,
                offset: const Offset(-5, 0),
              )
            ],
            color: Colors.white),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.only(
                        bottom: 8, top: 28, left: 15, right: 15),
                    child: Text('ชื่อ ${courses.first.name}',
                        style: Theme.of(context).textTheme.headlineSmall)),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 5.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(30)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: Icon(
                            FontAwesomeIcons.user,
                            color: Colors.white,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 8, right: 8),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(context.read<AppData>().nameCus,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .copyWith(color: Colors.white)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                    child: Text('รายละเอียด',
                        style: Theme.of(context).textTheme.bodyLarge)),
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 15, right: 15),
                    child: Text('    ${courses.first.details}',
                        style: Theme.of(context).textTheme.bodyLarge)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> showDays() {
    return FutureBuilder(
      future: loadDaysDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Container();
        } else {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Divider(
                endIndent: 20,
                indent: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      // shape: BoxShape.circle,
                      borderRadius:
                          const BorderRadius.all(Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15, top: 20),
                        child: Text('วันที่',
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 20.0, right: 8, left: 8),
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 5, mainAxisExtent: 65),
                          shrinkWrap: true,
                          itemCount: modelDays.length,
                          itemBuilder: (context, index) {
                            final modelDay = modelDays[index];
                            return Padding(
                              padding: const EdgeInsets.all(3.0),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  shape: BoxShape.circle,
                                ),
                                child: InkWell(
                                    onTap: () {
                                      Get.to(() => HomeFoodAndClipPage(
                                            did: modelDay.did.toString(),
                                            sequence:
                                                modelDay.sequence.toString(),
                                            isVisible: false,
                                          ));
                                    },
                                    child: Center(
                                        child: Text(
                                            modelDay.sequence.toString(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge!
                                                .copyWith(
                                                    color: Colors.white)))),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, bottom: 20, right: 8),
                    child: FilledButton.icon(
                        onPressed: () {
                          //roomchat= widget.namecourse+coID.toString();
                          Get.to(() => ChatPage(
                                roomID: widget.coID,
                                roomName: courses.first.name,
                                userID: context.read<AppData>().cid.toString(),
                                firstName:
                                    "โค้ช ${context.read<AppData>().nameCoach}",
                              ));
                        },
                        icon: const Icon(
                          FontAwesomeIcons.facebookMessenger,
                          size: 16,
                        ),
                        label: const Text("คุยกับโค้ช")),
                  ),
                ],
              )
            ],
          );
        }
      },
    );
  }

  //LoadData
  Future<void> loadDataAsync() async {
    try {
      var res =
          await _courseService.course(cid: '', name: '', coID: widget.coID);
      courses = res.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadDaysDataAsync() async {
    try {
      var res =
          await _daysService.days(did: '', coID: widget.coID, sequence: '');
      modelDays = res.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
