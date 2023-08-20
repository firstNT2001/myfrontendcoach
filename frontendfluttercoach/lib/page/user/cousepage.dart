import 'dart:convert';
import 'dart:developer';

import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profilecoach.dart';
import 'package:get/get.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../model/request/buycourse_coID_post.dart';
import '../../model/response/md_Day_showmycourse.dart';
import '../../model/response/md_Result.dart';
import '../../model/response/md_amoutclip.dart';
import '../../model/response/md_coach_course_get.dart';
import '../../service/buy.dart';
import '../../service/course.dart';
import '../../service/day.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dialogs.dart';
import '../../widget/notificationBody.dart';
import 'money/money.dart';
import 'mycourse/Widget/widget_loadScore.dart';
import 'mycourse/Widget/widget_loadreview.dart';
import 'mycourse/mycourse.dart';

class showCousePage extends StatefulWidget {
  showCousePage({super.key, required this.namecourse});
  late String namecourse;
  @override
  State<showCousePage> createState() => _showCousePageState();
}

class _showCousePageState extends State<showCousePage> {
  late BuyCourseService buyCourseService;
  late DayService dayService;
  late CourseService courseService;
  late Future<void> loadDataMethod;
  late ModelAmountclip clipamount;

  List<Course> courses = [];
  List<DayDetail> clip = [];
  late ModelResult moduleResult;
  int amountclip = 0;
  int courseId = 0;
  int cusID = 0;
  int moneycus = 0;
  var buycourse;
  int amountUser = 0;
  final now = DateTime.now();
  double value = 0.0;
  int oldlimit = 0;
  int newlimit = 0;
  bool isvisible = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    courseId = context.read<AppData>().idcourse;
    cusID = context.read<AppData>().uid;
    moneycus = context.read<AppData>().money;
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    dayService = DayService(Dio(), baseUrl: context.read<AppData>().baseurl);

    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: SizedBox(
          height: 60,
          width: 60,
          child: FloatingActionButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Colors.white,
            onPressed: () {
              if (newlimit >= oldlimit) {
                InAppNotification.show(
                  child: NotificationBody(
                    count: 1,
                    message: 'ไม่สามารถซื้อได้เนื่องจากจำนวนคนเต็ม',
                  ),
                  context: context,
                  onTap: () => print('Notification tapped!'),
                  duration: const Duration(milliseconds: 3000),
                );
              } else {
                _buycouse(context);
              }

              // ignore: prefer_const_constructors
            },
            shape: const CircleBorder(),
            child: const Icon(Icons.shopping_cart),
          ),
        ),
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            widget.namecourse,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              loadImgCourse(),
              loadCourse(),
            ],
          ),
        ));
  }

  Future<void> loadData() async {
    try {
      var datacouse = await courseService.course(
          coID: courseId.toString(), cid: '', name: '');
      courses = datacouse.data;
      var dataclip = await dayService.day(
          did: '', coID: courseId.toString(), sequence: '');
      clip = dataclip.data;
      var dataamount = await courseService.amoutclip(coID: courseId.toString());
      clipamount = dataamount.data;
      amountclip = clipamount.amount;
      var dataamountUser = await buyCourseService.amountUserinCourse(
          originalID: courseId.toString());
      amountUser = dataamountUser.data;
      if (moneycus < courses.first.price) {
        log("เงินไม่พอ");
        setState(() {
          isvisible = true;
        });
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadCourse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            oldlimit = courses.first.amount;
            newlimit = amountUser;
            log(courses.first.price.toString());
            return  Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 4),
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(right: 25, top: 15),
                            child: Align(
                              alignment: Alignment.topRight,
                              child: WidgetShowScore(
                                couseID: courses.first.coId.toString(),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15, top: 32, bottom: 5),
                            child: Row(
                              children: [
                                Text(courses.first.name,
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(
                                  width: 10,
                                ),
                                RatingBar.readOnly(
                                  isHalfAllowed: false,
                                  filledIcon: FontAwesomeIcons.bolt,
                                  size: 22,
                                  emptyIcon: FontAwesomeIcons.bolt,
                                  filledColor: Theme.of(context)
                                      .colorScheme
                                      .tertiaryContainer,
                                  emptyColor: const Color.fromARGB(
                                      255, 179, 179, 179),
                                  initialRating:
                                      double.parse(courses.first.level),
                                  maxRating: 3,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          left: 15,
                        ),
                        child: FilledButton.icon(
                            onPressed: () {
                              log("courses.first.coach.cid =" +
                                  courses.first.coach.cid.toString());

                              pushNewScreen(
                                context,
                                screen: ProfileCoachPage(
                                  coachID: courses.first.coach.cid,
                                ),
                                withNavBar: true,
                              );
                            },
                            icon: const Icon(
                              FontAwesomeIcons.solidUser,
                              size: 16,
                            ),
                            label: Text(courses.first.coach.fullName,
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 16))),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: SizedBox(
                            height:
                                MediaQuery.of(context).size.height * 0.1,
                            width: MediaQuery.of(context).size.width * 0.85,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        child: Row(children: [
                                          const Icon(FontAwesomeIcons
                                              .calendarCheck),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 6),
                                            child: Text(
                                                courses.first.days
                                                        .toString() +
                                                    " วัน",
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          )
                                        ]),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37),
                                        child: SizedBox(
                                          child: Row(children: [
                                            const Icon(
                                                FontAwesomeIcons.youtube),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 7, top: 6),
                                              child: Text(
                                                  amountclip.toString() +
                                                      " คลิป",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 8),
                                  child: Stack(
                                    children: [
                                      SizedBox(
                                        child: courses.first.amount >
                                                amountUser
                                            ? Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.only(
                                                            right: 10),
                                                    child: Icon(
                                                        FontAwesomeIcons
                                                            .userPlus),
                                                  ),
                                                  Text(
                                                    courses.first.amount
                                                            .toString() +
                                                        "/" +
                                                        amountUser
                                                            .toString() +
                                                        " คน",
                                                    style: const TextStyle(
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight
                                                                .w600),
                                                  )
                                                ],
                                              )
                                            : courses.first.amount <=
                                                    amountUser
                                                ? Row(
                                                    children: [
                                                      const Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                right: 10),
                                                        child: Icon(
                                                            FontAwesomeIcons
                                                                .userPlus),
                                                      ),
                                                      Text(
                                                        courses.first.amount
                                                                .toString() +
                                                            "/" +
                                                            amountUser
                                                                .toString() +
                                                            " คน",
                                                        style:
                                                            const TextStyle(
                                                                fontSize:
                                                                    16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color: Color
                                                                    .fromARGB(
                                                                  255,
                                                                  157,
                                                                  10,
                                                                  0,
                                                                )),
                                                      )
                                                    ],
                                                  )
                                                : Container(),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37),
                                        child: SizedBox(
                                          child: courses.first.price > 0
                                              ? Row(
                                                  children: [
                                                    const Icon(
                                                        FontAwesomeIcons
                                                            .coins),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets
                                                                  .only(
                                                              left: 5,
                                                              top: 6),
                                                      child: Text(
                                                          courses.first
                                                                  .price
                                                                  .toString() +
                                                              " บาท",
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600)),
                                                    )
                                                  ],
                                                )
                                              : courses.first.price <= 0
                                                  ? const Row(
                                                      children: [
                                                        Icon(
                                                            FontAwesomeIcons
                                                                .coins),
                                                        Padding(
                                                          padding: EdgeInsets
                                                              .only(
                                                                  left: 5,
                                                                  top: 6),
                                                          child: Text(
                                                              " ฟรี",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600)),
                                                        )
                                                      ],
                                                    )
                                                  : Container(),
                                          // Row(children: [
                                          // const Icon(
                                          //     FontAwesomeIcons.coins),

                                          //   )
                                          // ]),
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.37),
                                        child: SizedBox(
                                          child: Row(children: [
                                            const Icon(
                                                FontAwesomeIcons.coins),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 5, top: 6),
                                              child: Text(
                                                  courses.first.price
                                                          .toString() +
                                                      " บาท",
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w600)),
                                            )
                                          ]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            )),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(
                          left: 12,
                        ),
                        child: Text("รายละเอียดคอร์ส",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w600)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, bottom: 12, right: 20),
                        child: Text(courses.first.details,
                            style: Theme.of(context).textTheme.bodyLarge),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: Divider(
                          color: Color.fromARGB(255, 194, 194, 194),
                          indent: 8,
                          endIndent: 8,
                          thickness: 1.5,
                        ),
                      ),
                      WidgetloadeReview(
                        couseID: courseId.toString(),
                      ),
                    ],
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget loadImgCourse() {
    return FutureBuilder(
        future: loadDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Container(
              // alignment: Alignment.center,
              // width: double.infinity,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
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
                              color: Theme.of(context).colorScheme.onPrimary,
                              image: DecorationImage(
                                  image: NetworkImage(courses.first.image),
                                  fit: BoxFit.cover),
                            ),
                          )),
                      //color: Colors.white,
                    ),
                    Container(
                      
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.4,
                      padding: const EdgeInsets.all(5.0),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            const Color.fromARGB(255, 0, 0, 0).withAlpha(0),
                            Color.fromARGB(102, 0, 0, 0),
                            Color.fromARGB(162, 0, 0, 0)
                            // const Color.fromARGB(255, 255, 255, 255)
                            //     .withAlpha(0),
                            // Color.fromARGB(70, 255, 255, 255),
                            // Color.fromARGB(149, 255, 255, 255)
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }

  void _buycouse(BuildContext ctx) {
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Text("กรุณาชำระเงิน",style: Theme.of(context).textTheme.bodyLarge),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.25,
                height: MediaQuery.of(context).size.height * 0.12,
                child: Image.asset(
                  "assets/images/bill.png",
                  fit: BoxFit.fill,
                )),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("คอร์สที่ซื้อ",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(courses.first.name,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(courses.first.price.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 10, bottom: 10),
              child: Divider(
                color: Colors.black,
                indent: 8,
                endIndent: 8,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const Text("ยอดคงเหลือ",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                Text(moneycus.toString(),
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Text("ยอดสุทธิ",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  Text(courses.first.price.toString(),
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, top: 10, bottom: 10),
              child: Visibility(
                visible: isvisible,
                child: InkWell(
                  onTap: () {
                    SmartDialog.dismiss();
                    pushNewScreen(context, screen: const addCoin());
                  },
                  child: Row(
                    children: [
                      const Icon(
                        FontAwesomeIcons.circleExclamation,
                        color: Color.fromARGB(255, 255, 198, 28),
                        size: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Text("ยอดเงินคงเหลือไม่พอ กดเพื่อเติมเงิน",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 15,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                    child: const Text('ยกเลิก',
                        style: TextStyle(
                          fontSize: 16,
                        )),
                  ),
                  FilledButton(
                      onPressed: () async {
                        SmartDialog.dismiss();
                        if (moneycus < courses.first.price) {
                          _close(ctx);
                        } else {
                          setState(() {
                            isvisible = false;
                          });
                          startLoading(context);
                          String cdate2 =
                              DateFormat("yyyy-MM-dd").format(DateTime.now());

                          var proposedDate = "${cdate2}T00:00:00.000Z";
                          //log("Date time3 = $proposedDate");
                          BuyCoursecoIdPost buyCoursecoIdPost =
                              BuyCoursecoIdPost(
                            customerId: cusID,
                            buyDateTime: proposedDate,
                          );
                          log(jsonEncode(buyCoursecoIdPost));
                          log(cusID.toString());
                          buycourse = await buyCourseService.buyCourse(
                              courseId.toString(), buyCoursecoIdPost);
                          moduleResult = buycourse.data;
                          if (moduleResult.result == "1") {
                            SmartDialog.dismiss();
                            stopLoading();
                            // pushNewScreen(
                            //   context,
                            //   screen: const MyCouses(),
                            //   withNavBar: true,
                            // );
                            _correct(ctx);
                          }
                        }
                      },
                      child: const Text("ชำระเงิน",
                          style: TextStyle(
                            fontSize: 16,
                          ))),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  void _close(BuildContext ctx) {
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Image.asset(
                "assets/images/close.png",
                fit: BoxFit.fill,
              )),
          const Text("ซื้อไม่สำเร็จ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
          const Text("ยอดเงินของคุณไม่เพียงพอ กรุณาเติมเงิน",
              style: TextStyle(fontSize: 16)),
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                FilledButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                  child: const Text('ยกเลิก',
                      style: TextStyle(
                        fontSize: 16,
                      )),
                ),
                FilledButton(
                    onPressed: () async {
                      SmartDialog.dismiss();
                      pushNewScreen(context, screen: const addCoin());
                    },
                    child: const Text("เติมเงิน",
                        style: TextStyle(
                          fontSize: 16,
                        ))),
              ],
            ),
          )
        ]),
      );
    });
  }

  void _correct(BuildContext ctx) {
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.27,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              height: MediaQuery.of(context).size.height * 0.12,
              child: Image.asset(
                "assets/images/correct.png",
                fit: BoxFit.fill,
              )),
          const Text("การซื้อสำเร็จ",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),

          const Padding(
            padding: EdgeInsets.only(left: 15, right: 12, top: 12, bottom: 15),
            child: Text(
                "คอร์สที่ซื้อสำเร็จจะอยู่ที่หน้ารายการซื้อของฉัน พร้อมที่จะออกกำลังกายกันแล้วหรือยัง?",
                style: TextStyle(fontSize: 16)),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 12),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceAround,
          //     children: [
          //       FilledButton(
          //         onPressed: () {
          //           SmartDialog.dismiss();
          //         },
          //         child: const Text('ยกเลิก',
          //             style: TextStyle(
          //               fontSize: 16,
          //             )),
          //       ),
          //       FilledButton(
          //           onPressed: () async {
          //             SmartDialog.dismiss();
          //             pushNewScreen(context, screen: const addCoin());
          //           },
          //           child: const Text("เติมเงิน",
          //               style: TextStyle(
          //                 fontSize: 16,
          //               ))),
          //     ],
          //   ),
          // )
        ]),
      );
    });
  }
}
