import 'dart:convert';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/homepage/widget/widget_search.dart';

import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../model/response/md_Coach_get.dart';
import '../../../model/response/md_Customer_get.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/coach.dart';
import '../../../service/course.dart';
import '../../../service/customer.dart';
import '../../../service/provider/appdata.dart';
import '../cousepage.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  late Future<void> loadDataMethod;
  late CourseService courseService;
  late CustomerService customerService;
  late HttpResponse<Customer> customer;
  List<Course> courses = [];
  int uid = 0;
  bool isVisible = false;
  bool isSuggestVisible = true;
  double bmi = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
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
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 15),
            child: Text("COACHING",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
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
                  readOnly: true,
                  onTap: () {
                    pushNewScreen(
                      context,
                      screen: const Widgetsearch(),
                      withNavBar: true,
                    );                 
                  },
                  decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1,
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            width: 1.5,
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary), //<-- SEE HERE
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      prefixIcon: Icon(FontAwesomeIcons.search),
                      hintText: "ค้นหา",
                      hintStyle: TextStyle(color: Colors.grey)),
                ),
              ),
            ),
          ),
          //showCourseAll
          Visibility(
            visible: isSuggestVisible,
            child: Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8, right: 8),
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
      // Coachbycourse course = Coachbycourse();
      // log(jsonEncode(course));
      log("User ID" + uid.toString());
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
                    pushNewScreen(
                      context,
                      screen: const showCousePage(),
                      withNavBar: true,
                    );
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
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
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
                                Text(
                                  listcours.name,
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
                                      listcours.coach.fullName,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .copyWith(color: Colors.white),
                                    ),
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
                                  initialRating: double.parse(listcours.level),
                                  maxRating: 3,
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