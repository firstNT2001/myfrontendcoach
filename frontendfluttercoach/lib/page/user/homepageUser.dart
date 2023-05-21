import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:developer';

import '../../model/response/md_Coach_get.dart';
import '../../model/response/course_get_res.dart';
import '../../model/response/md_Customer_get.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import 'cousepage.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  late Future<void> loadDataMethod;
  late CoachService coachService;
  late CourseService courseService;
  late CustomerService customerService;
  late HttpResponse<Customer> customer;

  List<Coach> coaches = [];
  List<ModelCourse> courses = [];
  List<ModelCourse> coursesAll = [];
  TextEditingController myController = TextEditingController();

  int uid = 1;
  bool isVisible = false;
  bool isVisibles = true;
  double bmi = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);

    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("tesr"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ค้นหา',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          coachService
                              .coach(nameCoach: myController.text, cid: "")
                              .then((coachdata) {
                            var datacoach = coachdata.data;
                            //var checkcoaches = coaches.length;
                            coaches = datacoach;
                            if (coaches.isNotEmpty) {
                              //log("message"+coaches.first);
                              setState(() {
                                isVisible = true;
                                isVisibles = false;
                              });

                              log(coaches.length.toString());
                            } else {
                              setState(() {
                                isVisible = false;
                                isVisibles = true;
                              });
                            }
                          });
                          courseService
                              .course(
                                  cid: '', coID: '', name: myController.text)
                              .then((coursedata) {
                            var datacourse = coursedata.data;
                            courses = datacourse;
                            if (courses.isNotEmpty) {
                              setState(() {});
                              log(courses.length.toString());
                            }
                          });
                        } else {
                          setState(() {
                            isVisible = false;
                            isVisibles = true;
                          });
                        }
                      },
                      child: const Text("แสดงชื่อโค้ช")),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                  onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Card(
              child: ListTile(
                leading: (customer.data.gender == '2')
                    ? Icon(Icons.girl_outlined, size: 120)
                    : (customer.data.gender == '1')
                        ? Icon(Icons.boy_outlined, size: 120)
                        : Icon(Icons.abc_outlined, size: 110),

                title: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(customer.data.height.toString()),
                          const Text("CM"),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(customer.data.weight.toString()),
                          const Text("KG"),
                        ],
                      ),
                      const Divider(
                        //color of divider
                        height: 5, //height spacing of divider
                        thickness: 2, //thickness of divier line
                        indent: 50, //spacing at the start of divider
                        endIndent: 50,
                      ),
                      const Text("BMI"),
                      Text(bmi.toString()),
                    ],
                  ),
                ),
                //subtitle: Text(review.details),
              ),
            ),
          ),

          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("รายการแนะนำ"),
          ),

          Visibility(
            visible: isVisibles,
            child: SizedBox(
              height: 300,
              child: Expanded(
                  child: ListView.builder(
                shrinkWrap: true,
                itemCount: coursesAll.length,
                itemBuilder: (context, index) {
                  final listcours = coursesAll[index];

                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      children: [
                        Card(
                          child: Container(
                            height: 290,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Image.network(listcours.image,
                                    width: 400,
                                    height: 160,
                                    fit: BoxFit.fill),
                                ListTile(
                                  title: Text(listcours.name)
                                  //subtitle: Text(listcours.details),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 12),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        log(listcours.coId.toString());
                                        context.read<AppData>().idcourse =
                                            listcours.coId;

                                        Get.to(() => const showCousePage());
                                      },
                                      child: const Text(
                                          "ดูรายละเอียดเพิ่มเติม")),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )),
            ),
          ),

          Visibility(
            visible: isVisible,
            child: Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: coaches.length,
                      itemBuilder: (context, index) {
                        final coach = coaches[index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(coach.image),
                            ),
                            title: Text(coach.username.toString()),
                            subtitle: Text(coach.fullName),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              log(coach.cid.toString());
                              log("q :" + coach.qualification);
                              log("name :" + coach.fullName);
                              log("ussername :" + coach.username);
                              log("property :" + coach.property);
                              context.read<AppData>().cid = coach.cid;
                              context.read<AppData>().qualification =
                                  coach.qualification;
                              context.read<AppData>().nameCoach =
                                  coach.fullName;
                              context.read<AppData>().usercoach =
                                  coach.username;
                              context.read<AppData>().propertycoach =
                                  coach.property;
                              Get.to(() => const ProfileCoachPage());
                            },
                          ),
                        );
                      }),
                ),
              ),
            ),
          ),

          //showCourse
          Visibility(
            visible: isVisible,
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: courses.length,
                    itemBuilder: (context, index) {
                      final course = courses[index];
                      return Card(
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundImage: NetworkImage(course.image),
                          ),
                          title: Text(course.name),
                          subtitle: Text(course.details),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            log(course.coId.toString());
                            context.read<AppData>().idcourse = course.coId;

                            Get.to(() => const showCousePage());
                          },
                        ),
                      );
                    }),
              ),
            ),
          ),

          Center(
            child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const ProfileUser());
                },
                child: const Text("โปรไฟล์ของฉัน")),
          ),
        ],
      ),
    );
  }

  Future<void> loadData() async {
    try {
      customer = await customerService.customer(uid: uid.toString());
      var datacourse = await courseService.course(coID: '', cid: '', name: '');
      coursesAll = datacourse.data;
      log("lengtt = " + coursesAll.length.toString());
      double h = ((customer.data.height) + .0) / 100;
      double w = customer.data.weight + .0;
      log('BMI=: $h');
      log('BMI=: $w');
      bmi = (w / (h * h));
      log('BMI=: $bmi');
    } catch (err) {
      log('Error: $err');
    }
  }
}
// การทำมุมโค้งบางจุด
//  ClipRRect(
//                               borderRadius: const BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 topRight: Radius.circular(10),
//                               ),
//                               child: Image.network(listcours.image,
//                                   width: 300, height: 100, fit: BoxFit.fill),
//                             ),
