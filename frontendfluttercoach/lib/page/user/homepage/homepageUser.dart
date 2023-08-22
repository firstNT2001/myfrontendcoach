import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/homepage/widget/widget_search.dart';

import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'dart:developer';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/course.dart';
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

  List<Course> courses = [];
  int uid = 0;
  bool isVisibleText = false;
  bool isSuggestVisible = true;
  List listcoID = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // reviewService =
    //     ReviewService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
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
                  bottomRight: Radius.circular(30.0),
                  bottomLeft: Radius.circular(30.0),
                ),
                child: Container(
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(begin: Alignment.topCenter, colors: [
                    Color.fromARGB(228, 255, 122, 13),
                    Color.fromARGB(255, 255, 150, 12),
                    Color.fromARGB(255, 255, 158, 31)
                  ])),
                  height: 150,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: 50,
                  bottom: 20,
                  left: MediaQuery.of(context).size.width * 0.58,
                  right: 15),
              child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Image.asset("assets/images/yoga.png")),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 15, top: 20),
                  child: Text("DAILY WORKOUT",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: Text("COACHING",
                      style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                          color: Colors.white)),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                          boxShadow: [
                            const BoxShadow(
                              color: Color.fromARGB(255, 156, 156, 156),
                              blurRadius: 15.0,
                              spreadRadius: 0.2,
                              offset: Offset(
                                0,
                                3,
                              ),
                            )
                          ],
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
                                  color: Colors.grey.shade100), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.5,
                                  color: Colors.grey.shade100), //<-- SEE HERE
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            prefixIcon: const Icon(
                              FontAwesomeIcons.search,
                              color: Colors.grey,
                            ),
                            hintText: "ค้นหา",
                            hintStyle: const TextStyle(color: Colors.grey,fontSize: 16)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 10, bottom: 3),
                  child: Row(
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(FontAwesomeIcons.fire, color: Colors.red),
                      ),
                      Text(
                        "คอร์สแนะนำ",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                //showCourseAll
                Visibility(
                  visible: isSuggestVisible,
                  child: Expanded(
                    child: loadcourse(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      log("User ID" + uid.toString());

      var datacourse =
          await courseService.courseOpenSell(coID: '', cid: '', name: '');

      courses = datacourse.data;
      for (int i = 0; i <= courses.length - 1; i++) {
        // listcoID.add(courses[i].coId);
        log(courses[i].coId.toString());
        
        // }
      }     
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
          if (courses.length > 5) {
            setState(() {
              courses.length = 5;
            });
          }

          //courses.sort((a, b) => a.someProperty.compareTo(b.someProperty));

          return RefreshIndicator(onRefresh: () async{
          setState(() {
            loadDataMethod = loadData();
          });
        },
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                bool isVisibleText = false;
                if(courses[index].price <=0){
                  isVisibleText=true;
                }
                final listcours = courses[index];
                return Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10, bottom: 20),
                  child: InkWell(
                    onTap: () {
                      context.read<AppData>().idcourse = listcours.coId;
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
                                            image: NetworkImage(listcours.image),
                                            fit: BoxFit.cover),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    )),
                                //color: Colors.white,
                              ),
                              Visibility(
                                visible: isVisibleText,
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    left:
                                        MediaQuery.of(context).size.width * 0.78,
                                  ),
                                  child: Container(
                                    height: 65,
                                    width: 65,
                                    decoration: const BoxDecoration(
                                      gradient: LinearGradient(
                                        stops: [.5, .5],
                                        begin: Alignment.topRight,
                                        end: Alignment.bottomLeft,
                                        colors: [
                                          Color.fromARGB(255, 185, 0, 0),
                                          Colors.transparent, // top Right part
                                        ],
                                      ),
                                    ),
                                    child: const Padding(
                                      padding: EdgeInsets.only(left: 28, top: 7),
                                      child: Text("ฟรี",
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white)),
                                    ),
                                  ),
                                ),
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
                                    // WidgetShowScore(
                                    //   couseID: listcours.coId.toString(),
                                    // ),
                                    Row(
                                      children: [
                                        Text(
                                          listcours.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge!
                                              .copyWith(color: Colors.white),
                                        ),
                                      ],
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
                                      emptyColor: const Color.fromARGB(
                                          255, 245, 245, 245),
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
                  ),
                );
              },
            ),
          );
        }
      },
    );
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