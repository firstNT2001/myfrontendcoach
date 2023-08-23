import 'dart:developer';
import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/cousepage.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/coach.dart';
import '../../service/course.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../service/customer.dart';
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
   late CustomerService customerService;
  List<Customer> customer = [];
int uid=0;
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
    uid = context.read<AppData>().uid;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
        customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);
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
        // title: Text(
        //   "โปรไฟล์โค้ช",
        //   style: Theme.of(context).textTheme.headlineMedium,
        // ),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            
            ListView(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 170),
                  child: loadcoach(),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 8, top: 15, bottom: 8, right: 8),
                  child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                          bottomRight: Radius.circular(12)),
                      child: Container(
                          color: Colors.amber,
                          child: const Padding(
                            padding: EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            child: Text(
                              "คอร์สทั้งหมด",
                              style: TextStyle(fontSize: 17,fontWeight: FontWeight.w600),
                            ),
                          ))),
                ),
                loadcourse(),
              ],
            ),
            loadcoachIMG(),
          ],
        ),
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
          return Column(
            children: courses
                .map((listcours) => Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 15),
                    child: InkWell(
                      onTap: () {
                        pushNewScreen(
                          context,
                          screen: showCousePage(namecourse: listcours.name),
                          withNavBar: true,
                        );
                      },
                      child: Card(
                        elevation: 10,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary,
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage(listcours.image),
                                              fit: BoxFit.cover),
                                          borderRadius:
                                              BorderRadius.circular(20),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text(listcours.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.white)),
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
                                          Text(listcours.coach.fullName,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyLarge!
                                                  .copyWith(
                                                      color: Colors.white)),
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
                                        emptyColor: const Color.fromARGB(
                                            255, 37, 37, 37),
                                        initialRating:
                                            double.parse(listcours.level),
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
                    )))
                .toList(),
          );
        }
      },
    );
  }
  Widget loadcoachIMG() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    Container(
              decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Color.fromARGB(255, 156, 156, 156),
                    blurRadius: 20.0,
                    spreadRadius: 1,
                    offset: Offset(
                      0,
                      3,
                    ),
                  )
                ],
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(40.0),
                  bottomLeft: Radius.circular(40.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                    Color.fromARGB(228, 255, 122, 13),
                    Color.fromARGB(255, 255, 150, 12),
                    Color.fromARGB(255, 255, 158, 31)
                  ])),
                  height: 200,
                ),
              ),
            ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 10, top: 8),
                          child: Container(
                            height:
                                MediaQuery.of(context).size.height * 0.17,
                            width: MediaQuery.of(context).size.width * 0.36,
                            decoration: BoxDecoration(
                              color: const Color(0xff7c94b6),
                              image: DecorationImage(
                                  image: NetworkImage(coach.first.image),
                                  fit: BoxFit.cover),
                              borderRadius: BorderRadius.circular(100),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 30,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text("@${coach.first.username}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                            Text("@${coach.first.fullName}",
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600)),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
               
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
            return Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  
                  const Padding(
                    padding: EdgeInsets.only(top: 15, left: 10),
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.graduationCap,
                          size: 18,
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 8, right: 8),
                          child: Text("วุฒิการศึกษา",
                              style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ), Padding(
                          padding: const EdgeInsets.only(left: 18, right: 15,top: 5),
                          child: Text(coach.first.qualification,
                              style: const TextStyle(fontSize: 16)),
                        ),
                  const Padding(
                    padding: EdgeInsets.only(top: 10, left: 10),
                    child: Row(
                      children: [
                        Icon(
                            FontAwesomeIcons.buildingColumns,
                            size: 18,
                          ),
                        Padding(
                          padding: EdgeInsets.only(top: 10, left: 8),
                          child: Text("คุณสมบัติ", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700)),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 18,right: 15),
                    child: Text(coach.first.property,
                        style: const TextStyle(fontSize: 16)),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Future<void> loadData() async {
    try {
      var result = await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
      var datas = await courseService.course(
          cid: widget.coachID.toString(), coID: '', name: '');
      log("iddddddddd= " + widget.coachID.toString());
      var datacoach = await coachService.coach(
          nameCoach: '', cid: widget.coachID.toString(), email: '');
      log("idddddddddcoach= " + datacoach.data.first.fullName);
      courses = datas.data;
      coach = datacoach.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
