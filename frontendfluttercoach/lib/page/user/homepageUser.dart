import 'package:dio/dio.dart';
import 'package:flutter/material.dart';


import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_coach_course_get.dart';
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
  List<Course> courses = [];
  //List<ModelCourse> coursesAll = [];

  //late List<Coachbycourse> coachname=[];
  TextEditingController myController = TextEditingController();

  int uid = 0;
  bool isVisible = false;
  bool isSuggestVisible = true;
  double bmi = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
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
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(left: 15, top: 45),
            child: Text("DAILY WORKOUT",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("COACHING",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 244),
                    borderRadius: BorderRadius.circular(15)),
                child: TextField(
                  controller: myController,
                  onChanged: (value) {
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
                            isSuggestVisible = false;
                          });

                          log(coaches.length.toString());
                        } else {
                          setState(() {
                            isVisible = false;
                            isSuggestVisible = true;
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
                    } else {
                      setState(() {
                        isVisible = false;
                        isSuggestVisible = true;
                      });
                    }
                  },
                  // onSubmitted: (value) {
                  
                  // },
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      prefixIcon: Icon(FontAwesomeIcons.search),
                      hintText: "ค้นหา",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          ),
          Visibility(
            visible: isSuggestVisible,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
                child: loadcourse(),
              ),
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
                          color: Theme.of(context).colorScheme.outline,
                          child: ListTile(
                            leading: CircleAvatar(
                              radius: 50,
                              backgroundImage: NetworkImage(coach.image),
                            ),
                            title: Text(coach.username.toString(),
                                style: Theme.of(context).textTheme.bodyLarge),
                            subtitle: Text(coach.fullName,
                                style: Theme.of(context).textTheme.bodyLarge),
                            trailing: const Icon(Icons.arrow_forward),
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
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: loadcourse(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loadData() async {
    try {
      log("User ID"+uid.toString());
      customer = await customerService.customer(uid: uid.toString());
      var datacourse = await courseService.course(coID: '', cid: '', name: '');

      courses = datacourse.data;
      // log("list coachname =${courses.length}");
      // double h = ((customer.data.height) + .0) / 100;
      // double w = customer.data.weight + .0;
      // log('BMI=: $h');
      // log('BMI=: $w');
      // bmi = (w / (h * h));
      // log('BMI=: $bmi');
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
                    log(listcours.coId.toString());
                    log(customer.data.price.toString());
                    context.read<AppData>().idcourse = listcours.coId;
                    context.read<AppData>().money = customer.data.price;
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
              );
            },
          );
        }
      },
    );
  }
 //customer
  // Widget loadcustomer() {
  //   return FutureBuilder(
  //     future: loadDataMethod,
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState != ConnectionState.done) {
  //         return const Center(child: CircularProgressIndicator());
  //       } else {
  //         return Column(
  //           children: [
  //             Card(
  //               child: ListTile(
  //                 leading: (customer.data.gender == '2')
  //                     ? const Icon(Icons.girl_outlined, size: 120)
  //                     : (customer.data.gender == '1')
  //                         ? const Icon(Icons.boy_outlined, size: 120)
  //                         : const Icon(Icons.abc_outlined, size: 110),

  //                 title: Padding(
  //                   padding: const EdgeInsets.all(15.0),
  //                   child: Column(
  //                     crossAxisAlignment: CrossAxisAlignment.center,
  //                     children: [
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(customer.data.height.toString()),
  //                           const Text("CM"),
  //                         ],
  //                       ),
  //                       Row(
  //                         mainAxisAlignment: MainAxisAlignment.center,
  //                         children: [
  //                           Text(customer.data.weight.toString()),
  //                           const Text("KG"),
  //                         ],
  //                       ),
  //                       const Divider(
  //                         //color of divider
  //                         height: 5, //height spacing of divider
  //                         thickness: 2, //thickness of divier line
  //                         indent: 50, //spacing at the start of divider
  //                         endIndent: 50,
  //                       ),
  //                       const Text("BMI"),
  //                       Text(bmi.toString()),
  //                     ],
  //                   ),
  //                 ),
  //                 //subtitle: Text(review.details),
  //               ),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }
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

// onTap: () {
//                               log(coach.cid.toString());
//                               log("q :${coach.qualification}");
//                               log("name :${coach.fullName}");
//                               log("ussername :${coach.username}");
//                               log("property :${coach.property}");
//                               context.read<AppData>().cid = coach.cid;
//                               context.read<AppData>().qualification =
//                                   coach.qualification;
//                               context.read<AppData>().nameCoach =
//                                   coach.fullName;
//                               context.read<AppData>().usercoach =
//                                   coach.username;
//                               context.read<AppData>().propertycoach =
//                                   coach.property;
//                               Get.to(() => const ProfileCoachPage());
//                             },