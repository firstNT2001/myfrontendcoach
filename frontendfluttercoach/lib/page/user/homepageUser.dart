import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../model/response/md_Coach_get.dart';
import '../../model/response/course_get_res.dart';
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
  List<Coachbycourse> courses = [];
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
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 310,
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10),
                        hintText: '   ค้นหา',
                        border: InputBorder.none),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: FilledButton(
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
                            isSuggestVisible = true;
                          });
                        }
                      },
                      // style: ElevatedButton.styleFrom(
                      //     primary: Color.fromARGB(230, 18, 17, 17)),
                      child:  Text("ค้นหา",style: Theme.of(context).textTheme.bodyLarge)),
                ),
              ],
            ),
          ),
          //BMI
          // Padding(
          //   padding:
          //       const EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 12),
          //   child: loadcustomer(),
          // ),

          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                 Text("คอร์สแนะนำ",
                    style:
                        Theme.of(context).textTheme.bodyLarge),
                const Icon(
                  FontAwesomeIcons.fire,
                  color: Color.fromARGB(255, 192, 0, 0),
                )
              ],
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
                            title: Text(coach.username.toString(),style: Theme.of(context).textTheme.bodyLarge),
                            subtitle: Text(coach.fullName,style: Theme.of(context).textTheme.bodyLarge),
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
                          title: Text(course.name,style: Theme.of(context).textTheme.bodyLarge),
                          subtitle: Text(course.details,style: Theme.of(context).textTheme.bodyLarge),
                          trailing: const Icon(Icons.arrow_forward),
                          onTap: () {
                            log(course.coId.toString());
                            log(customer.data.price.toString());
                            context.read<AppData>().idcourse = course.coId;
                            context.read<AppData>().money = customer.data.price;
                            Get.to(() => const showCousePage());
                          },
                        ),
                      );
                    }),
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
          
          return Card(
            elevation: 0,
            color: Theme.of(context).colorScheme.outlineVariant,
            child: Container(
              height: 300,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    child: AspectRatio(aspectRatio: 16/9,child: Image.network(listcours.image, fit: BoxFit.cover)),                 
                  ),
                  ListTile(
                    title: Text(listcours.name,style: Theme.of(context).textTheme.bodyLarge),
                    subtitle: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: const Icon(FontAwesomeIcons.solidUser,size: 16.0,),
                        ),
                        Text(listcours.coach.fullName,style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    ),
                     trailing: FilledButton(
                        onPressed: () {
                          log(listcours.coId.toString());
                          context.read<AppData>().idcourse = listcours.coId;
                          log(" uid : ${customer.data.uid}");
                          log(" money : ${customer.data.price}");
                          context.read<AppData>().uid = customer.data.uid;
                          context.read<AppData>().money = customer.data.price;
                          Get.to(() => const showCousePage());
                        },                       
                        child: const Text("ดูรายละเอียดเพิ่มเติม")),
                        contentPadding: EdgeInsets.symmetric(
                        vertical: 0.0, horizontal: 8.0),
                  ),
                  
                ],
              ),
            ),
          );
            },
          );
        }
      },
    );
  }

  Widget loadcustomer() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(
            children: [
              Card(             
                child: ListTile(
                  leading: (customer.data.gender == '2')
                      ? const Icon(Icons.girl_outlined, size: 120)
                      : (customer.data.gender == '1')
                          ? const Icon(Icons.boy_outlined, size: 120)
                          : const Icon(Icons.abc_outlined, size: 110),

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
