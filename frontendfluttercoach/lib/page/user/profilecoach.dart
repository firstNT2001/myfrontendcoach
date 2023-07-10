import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/cousepage.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../service/provider/appdata.dart';

class ProfileCoachPage extends StatefulWidget {
  const ProfileCoachPage({super.key});

  @override
  State<ProfileCoachPage> createState() => _ProfileCoachPageState();
}

class _ProfileCoachPageState extends State<ProfileCoachPage> {
  late CourseService courseService;
  late CoachService coachService;
  late Future<void> loadDataMethod;
  late List<Course> courses = [];
  late List<Coach> coach = [];
  int cidCoach = 0;
  int selectedIndex = 0;
  PageController pageController = PageController();
  void onTapped(int index){
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cidCoach = context.read<AppData>().cid;
    //couse
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    coachService = CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();

    log("AAAA : " + cidCoach.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            loadcoach(),
            Divider(
              color: Colors.black,
              indent: 8,
              endIndent: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("คอร์สทั้งหมด",style: TextStyle(fontSize: 16)),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height*0.4,
              child: loadshowcouse()),
          ],
        ),
    );
  }

  Widget loadshowcouse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: courses.length,
                      itemBuilder: (context, index) {
                        final course = courses[index];
                        return Card(
                          child: ListTile(
                            title: Text(course.name),
                            subtitle: Text(course.details),
                            trailing: const Icon(Icons.arrow_forward),
                            onTap: () {
                              Get.to(() => showCousePage());
                            },
                          ),
                        );
                      },
                    ),
                  )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget loadcoach() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [             
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15,top: 20),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: NetworkImage(coach.first.image), 
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left:30 ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(coach.first.username,style: TextStyle(fontSize: 16)),
                                  Text(coach.first.fullName,style: TextStyle(fontSize: 16)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8,top: 20),
                        child: Text("การศึกษา",style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(coach.first.qualification),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10,left: 8),
                        child: Text("คุณสมบัติ",style: TextStyle(fontSize: 16)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12),
                        child: Text(coach.first.property),
                      ),
                    ],
                  )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadData() async {
    try {
      var datas = await courseService.course(
          cid: cidCoach.toString(), coID: '', name: '');
          log("iddddddddd= "+cidCoach.toString());
      var datacoach = await coachService.coach(nameCoach: '', cid: cidCoach.toString());
      log("idddddddddcoach= "+datacoach.data.first.fullName);
      courses = datas.data;
      coach = datacoach.data;
      log('couse: $courses');
    } catch (err) {
      log('Error: $err');
    }
  }

}
