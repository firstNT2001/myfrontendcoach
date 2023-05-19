
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'dart:developer';

import '../../model/response/md_Coach_get.dart';
import '../../model/response/course_get_res.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import '../../service/provider/appdata.dart';
import 'cousepage.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  late CoachService coachService;
  late CourseService courseService;
  List<Coach> coaches = [];
  List<ModelCourse> courses = [];
  TextEditingController myController = TextEditingController();
  bool isVisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
        coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
        
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("tesr"),
      ),
      body: Column(
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
                    decoration: InputDecoration(
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
                              });

                              log(coaches.length.toString());
                            } else {
                              setState(() {
                                isVisible = false;
                              });
                            }
                          });
                          courseService
                              .course(cid: '', coID: '', name: myController.text)
                              .then((coursedata) {
                            var datacourse = coursedata.data;
                            courses = datacourse;
                            if (courses.isNotEmpty) {
                              setState(() {});
                              log(courses.length.toString());
                            }
                          });
                        }
                      },
                      child: Text("แสดงชื่อโค้ช")),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.tune_rounded)),
            ],
          ),

           Visibility(
                  visible: isVisible ,
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
                                    log("q :"+ coach.qualification);
                                    log("name :"+ coach.fullName);
                                    log("ussername :"+ coach.username);
                                    log("property :"+ coach.property);
                                    context.read<AppData>().cid = coach.cid;
                                    context.read<AppData>().qualification = coach.qualification;
                                    context.read<AppData>().nameCoach = coach.fullName;
                                    context.read<AppData>().usercoach = coach.username;
                                    context.read<AppData>().propertycoach = coach.property;
                                    Get.to(()=>ProfileCoachPage());

                                  },
                                ),
                              );
                            }),
                      ),
                    ),
                  ),
                ),
            
          //showCourse
          (courses != null)
              ? Expanded(
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
                                    

                                  Get.to(()=>showCousePage());
                                },
                              ),
                            ); 
                          }),
                    ),
                  ),
                )
              : Container(color: Colors.amber),
              ElevatedButton(onPressed: (){

                Get.to(() => ProfileUser());
              }, child: Text("โปรไฟล์ของฉัน")),
        ],
      ),
      
    );
  }
}
