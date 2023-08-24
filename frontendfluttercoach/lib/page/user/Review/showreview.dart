import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/mycourse/mycourse.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/review.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../model/request/insertReview.dart';
import '../../../model/response/md_Buying_get.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/buy.dart';
import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int.dart';
import '../../../widget/textField/wg_tx_inputint.dart';
import '../homepage/homepageUser.dart';

class ShowReviewweightPage extends StatefulWidget {
  ShowReviewweightPage({super.key, required this.newweightreview});
  late int newweightreview;

  @override
  State<ShowReviewweightPage> createState() => _ShowReviewweightPageState();
}

class _ShowReviewweightPageState extends State<ShowReviewweightPage> {
  late BuyCourseService buyCourseService;
  List<Buying> buys = [];
  late int uid;
  double value = 0.0;
  late Future<void> loadDataMethod;
  int newweight = 0;
  int oldweight = 0;
  int sumweight = 0;
  int bill = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    bill = context.read<AppData>().bill;
    log("bill" + bill.toString());

    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.white,
      //   leading: IconButton(
      //     icon: const Icon(
      //       FontAwesomeIcons.chevronLeft,
      //     ),
      //     onPressed: () {
      //       Navigator.pop(context);
      //     },
      //   ),
      // ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [loadbuy()],
        ),
      ),
    );
  }

  Widget loadbuy() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            oldweight = buys.first.weight;
            newweight = oldweight - widget.newweightreview;
            log("newweight" + newweight.toString());
            return Align(
              alignment: Alignment.center,
              child: (newweight > 0)
                  ? Padding(
                      padding: const EdgeInsets.only(left: 25, right: 25),
                      child: Container(
                        decoration: BoxDecoration(
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
                            color: Color.fromARGB(255, 255, 255, 255),
                            borderRadius: BorderRadius.circular(30)),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 25, bottom: 25),
                          child: Column(
                            children: [
                              Container(
                                color: Colors.white,
                                child: Column(children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.6,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.2,
                                      child: Image.asset(
                                          "assets/images/happy.png")),
                                ]),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: Text(
                                  "ขอแสดงความยินดี",
                                  style: TextStyle(
                                      fontSize: 30,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.only(top: 30),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "น้ำหนักเดิม",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    Text(
                                      "น้ำหนักปัจจุบัน",
                                      style: TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      oldweight.toString() + ' กก.',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color:
                                              Color.fromARGB(255, 170, 40, 31)),
                                    ),
                                    Text(
                                      widget.newweightreview.toString() +
                                          ' กก.',
                                      style: const TextStyle(
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                          color: Color.fromARGB(
                                              255, 104, 211, 77)),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Color.fromARGB(255, 25, 201,
                                          171), // Background color
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
            Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        "กลับสู่หน้าหลัก",
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black),
                                      ),
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : (newweight < 0)
                      ? Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Container(
                            decoration: BoxDecoration(
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
                                color: Color.fromARGB(255, 255, 255, 255),
                                borderRadius: BorderRadius.circular(30)),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(top: 25, bottom: 25),
                              child: Column(
                                children: [
                                  Container(
                                    color: Colors.white,
                                    child: Column(children: [
                                      SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.2,
                                          child: Image.asset(
                                              "assets/images/cry.png")),
                                    ]),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 15),
                                    child: Text(
                                      "พยายามเข้านะ",
                                      style: TextStyle(
                                          fontSize: 30,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 30),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          "น้ำหนักเดิม",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "น้ำหนักปัจจุบัน",
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 15),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(
                                          oldweight.toString() + ' กก.',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Color.fromARGB(
                                                  255, 104, 211, 77)),
                                        ),
                                        Text(
                                          widget.newweightreview.toString() +
                                              ' กก.',
                                          style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: 
                                                  Color.fromARGB(
                                                  255, 170, 40, 31)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Color.fromARGB(255, 25, 201,
                                              171), // Background color
                                        ),
                                        onPressed: () {
                                           Navigator.pop(context);
            Navigator.pop(context);
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "กลับสู่หน้าหลัก",
                                            style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black),
                                          ),
                                        )),
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container(),
            );
          }
        });
  }

  Future<void> loadData() async {
    try {
      var databuy = await buyCourseService.buying(
          uid: '', coID: '', cid: '', bid: bill.toString());
      buys = databuy.data;
      // log("B"+buys.first.weight.toString());
    } catch (err) {
      log('Error: $err');
    }
  }
}
