import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/cousepage.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../service/provider/appdata.dart';

class ProfileCoachPage extends StatefulWidget {
  ProfileCoachPage({super.key, required this.coachID});
  late int coachID;

  @override
  State<ProfileCoachPage> createState() => _ProfileCoachPageState();
}

class _ProfileCoachPageState extends State<ProfileCoachPage> {
  late CourseService courseService;
  late CoachService coachService;
  late Future<void> loadDataMethod;
  late List<Course> courses = [];
  late List<Coach> coach = [];
  int selectedIndex = 0;
 
  PageController pageController = PageController();
  void onTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //couse
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
         // crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          loadcoach(),
         // const Divider(
         //   color: Colors.black,
         //   indent: 8,
         //   endIndent: 8,
         // ),
         Padding(
           padding: const EdgeInsets.only(left: 8,top: 15,bottom: 8,right: 8 ),
           child: ClipRRect(
               borderRadius: const BorderRadius.only(
                 topLeft: Radius.circular(12),
                 topRight: Radius.circular(12),
                 bottomLeft: Radius.circular(12),
                 bottomRight: Radius.circular(12)
               ),
               child: Container(
                   color: Colors.amber,
                   child:  const Padding(
                     padding: EdgeInsets.only(left: 8,right: 8,top: 5,bottom: 5),
                     child: Text(
                       "คอร์สทั้งหมด",
                       style: TextStyle(fontSize: 16),
                     ),
                   ))),
         ),
         loadcourse(),
        ],),
      ),
    );
  }
Widget loadcourse() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(children: courses.map((listcours) =>   Padding(
                padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                child: InkWell(
                  onTap: () {
                    context.read<AppData>().idcourse = listcours.coId;
                    Get.to(() => const showCousePage());
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
                                (listcours.level == '1')
                                    ? Row(
                                        children: [
                                          Icon(FontAwesomeIcons.bolt,
                                              size: 16,
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .tertiaryContainer),
                                          const Icon(FontAwesomeIcons.bolt,
                                              size: 16),
                                          const Icon(FontAwesomeIcons.bolt,
                                              size: 16),
                                        ],
                                      )
                                    : (listcours.level == '2')
                                        ? Row(
                                            children: [
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              const Icon(FontAwesomeIcons.bolt,
                                                  size: 16),
                                            ],
                                          )
                                        : Row(
                                            children: [
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                              Icon(FontAwesomeIcons.bolt,
                                                  size: 16,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .tertiaryContainer),
                                            ],
                                          )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
           ).toList(),);
       
       
          // return ListView.builder(
          //   // shrinkWrap: true,
          //   primary: false,
          //   itemCount: courses.length,
          //   itemBuilder: (context, index) {
          //     final listcours = courses[index];
          //     return 
          //     Padding(
          //       padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
          //       child: InkWell(
          //         onTap: () {
          //           context.read<AppData>().idcourse = listcours.coId;
          //           Get.to(() => const showCousePage());
          //         },
          //         child: Container(
          //           alignment: Alignment.center,
          //           width: double.infinity,
          //           child: AspectRatio(
          //             aspectRatio: 16 / 9,
          //             child: Stack(
          //               children: <Widget>[
          //                 Container(
          //                   alignment: Alignment.topCenter,
          //                   child: AspectRatio(
          //                       aspectRatio: 16 / 9,
          //                       child: Container(
          //                         decoration: BoxDecoration(
          //                           color: const Color(0xff7c94b6),
          //                           image: DecorationImage(
          //                               image: NetworkImage(listcours.image),
          //                               fit: BoxFit.cover),
          //                           borderRadius: BorderRadius.circular(20),
          //                         ),
          //                       )),
          //                   //color: Colors.white,
          //                 ),
          //                 Container(
          //                   padding: const EdgeInsets.all(5.0),
          //                   alignment: Alignment.bottomCenter,
          //                   decoration: BoxDecoration(
          //                     gradient: LinearGradient(
          //                       begin: Alignment.topCenter,
          //                       end: Alignment.bottomCenter,
          //                       colors: <Color>[
          //                         const Color.fromARGB(255, 0, 0, 0)
          //                             .withAlpha(0),
          //                         const Color.fromARGB(49, 0, 0, 0),
          //                         const Color.fromARGB(127, 0, 0, 0)
          //                         // const Color.fromARGB(255, 255, 255, 255)
          //                         //     .withAlpha(0),
          //                         // Color.fromARGB(39, 255, 255, 255),
          //                         // Color.fromARGB(121, 255, 255, 255)
          //                       ],
          //                     ),
          //                     borderRadius: BorderRadius.circular(20),
          //                   ),
          //                 ),
          //                 Padding(
          //                   padding: const EdgeInsets.all(8.0),
          //                   child: Column(
          //                     crossAxisAlignment: CrossAxisAlignment.start,
          //                     mainAxisAlignment: MainAxisAlignment.end,
          //                     children: [
          //                       Text(listcours.name,
          //                           style:
          //                               Theme.of(context).textTheme.titleLarge),
          //                       Row(
          //                         children: [
          //                           const Padding(
          //                             padding: EdgeInsets.only(right: 8),
          //                             child: Icon(
          //                               FontAwesomeIcons.solidUser,
          //                               size: 16.0,
          //                             ),
          //                           ),
          //                           Text(listcours.coach.fullName,
          //                               style: Theme.of(context)
          //                                   .textTheme
          //                                   .bodyLarge),
          //                         ],
          //                       ),
          //                       (listcours.level == '1')
          //                           ? Row(
          //                               children: [
          //                                 Icon(FontAwesomeIcons.bolt,
          //                                     size: 16,
          //                                     color: Theme.of(context)
          //                                         .colorScheme
          //                                         .tertiaryContainer),
          //                                 const Icon(FontAwesomeIcons.bolt,
          //                                     size: 16),
          //                                 const Icon(FontAwesomeIcons.bolt,
          //                                     size: 16),
          //                               ],
          //                             )
          //                           : (listcours.level == '2')
          //                               ? Row(
          //                                   children: [
          //                                     Icon(FontAwesomeIcons.bolt,
          //                                         size: 16,
          //                                         color: Theme.of(context)
          //                                             .colorScheme
          //                                             .tertiaryContainer),
          //                                     Icon(FontAwesomeIcons.bolt,
          //                                         size: 16,
          //                                         color: Theme.of(context)
          //                                             .colorScheme
          //                                             .tertiaryContainer),
          //                                     const Icon(FontAwesomeIcons.bolt,
          //                                         size: 16),
          //                                   ],
          //                                 )
          //                               : Row(
          //                                   children: [
          //                                     Icon(FontAwesomeIcons.bolt,
          //                                         size: 16,
          //                                         color: Theme.of(context)
          //                                             .colorScheme
          //                                             .tertiaryContainer),
          //                                     Icon(FontAwesomeIcons.bolt,
          //                                         size: 16,
          //                                         color: Theme.of(context)
          //                                             .colorScheme
          //                                             .tertiaryContainer),
          //                                     Icon(FontAwesomeIcons.bolt,
          //                                         size: 16,
          //                                         color: Theme.of(context)
          //                                             .colorScheme
          //                                             .tertiaryContainer),
          //                                   ],
          //                                 )
          //                     ],
          //                   ),
          //                 )
          //               ],
          //             ),
          //           ),
          //         ),
          //       ),
          //     );
           
          //   },
          // );
        }
      },
    );
  }

  Widget loadcoach() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(100),
                              bottomRight: Radius.circular(100)),
                          child: Container(
                            height: 180,
                            width: 200,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        Positioned(
                            right: -75,
                            top: -110,
                            child: Container(
                              height: 200,
                              width: 150,
                              margin: const EdgeInsets.all(100.0),
                              decoration: const BoxDecoration(
                                  color:
                                      Color.fromARGB(255, 255, 255, 255),
                                  shape: BoxShape.circle),
                            )),
                        Positioned(
                          right: 30,
                          top: 20,
                          child: CircleAvatar(
                            radius: 70,
                            backgroundImage: NetworkImage(coach.first.image),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("@${coach.first.username}",
                              style: const TextStyle(fontSize: 16)),
                          Text(coach.first.fullName,
                              style: const TextStyle(fontSize: 16)),
                          
                        ],
                      ),
                    )
                  ],
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10, left: 8),
                  child: Row(
                              children: [
                                const Icon(
                                  FontAwesomeIcons.graduationCap,
                                  size: 18,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8,right: 8),
                                  child: Text(coach.first.qualification,
                                      style: const TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 10, left: 8),
                  child: Text("คุณสมบัติ", style: TextStyle(fontSize: 16)),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(coach.first.property,
                      style: const TextStyle(fontSize: 16)),
                ),
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
          cid: widget.coachID.toString(), coID: '', name: '');
      log("iddddddddd= " + widget.coachID.toString());
      var datacoach = await coachService.coach(
          nameCoach: '', cid: widget.coachID.toString());
      log("idddddddddcoach= " + datacoach.data.first.fullName);
      courses = datas.data;
      coach = datacoach.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
