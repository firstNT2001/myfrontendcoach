import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/Review/showreview.dart';
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
import '../mycourse/history.dart';

class ReviewPage extends StatefulWidget {
  ReviewPage({super.key, required this.billID});
  late int billID;

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ReviewService reviewService;
  late BuyCourseService buyCourseService;
  late ModelResult moduleResult;
  List<Buying> buys = [];
  late int uid;
  late int coID;
  final TextEditingController detail = TextEditingController();
  final TextEditingController weight = TextEditingController();
  double value = 0.0;
  bool _isvisible = false;
  bool visiblecolor = false;
  bool visibleText = false;
  bool isValidpw = false;
  late Future<void> loadDataMethod;

  final _formKey = GlobalKey<FormState>();
  var insert;
  bool _isvisibleHW = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    coID = context.read<AppData>().idcourse;
    reviewService = context.read<AppData>().reviewService;
    buyCourseService =
        BuyCourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
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
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("ขอแสดงความยินดี",
                      style: Theme.of(context).textTheme.titleLarge),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text("คุณได้ออกกำลังกายจบคอร์สแล้ว",
                        style: Theme.of(context).textTheme.titleLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 20),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset("assets/images/trophy.png")),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("ให้คะแนนความพึงพอใจ",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: RatingStars(
                      value: value,
                      onValueChanged: (v) {
                        //
                        setState(() {
                          value = v;
                        });
                      },
                      starBuilder: (index, color) => Icon(
                        Icons.star,
                        size: 30,
                        color: color,
                      ),
                      starCount: 5,
                      starSize: 30,
                      valueLabelColor: Color.fromARGB(255, 98, 98, 98),
                      valueLabelTextStyle: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.normal,
                          fontSize: 14.0),
                      valueLabelRadius: 10,
                      maxValue: 5,
                      starSpacing: 2,
                      maxValueVisibility: true,
                      valueLabelVisibility: true,
                      valueLabelPadding: const EdgeInsets.symmetric(
                          vertical: 1, horizontal: 8),
                      valueLabelMargin: const EdgeInsets.only(right: 8),
                      starOffColor: const Color(0xffe7e8ea),
                      starColor: Colors.yellow,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text("บันทึกการเปลี่ยนแปลง",
                        style: Theme.of(context).textTheme.bodyLarge),
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                        bottom: 3,
                        top: 15,
                        left: 35,
                        right: 35,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 5, bottom: 3),
                              child: Text(
                                "น้ำหนัก (กิโลกรัม)",
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            TextFormField(
                                keyboardType: TextInputType.number,
                                controller: weight,
                                validator: (value) {
                                  isValidpw = isNumeric(value!); // false
                                  log(isValidpw.toString());
                                  if (isValidpw == true) {
                                    log("BB");
                                  } else {
                                    log("FF");
                                    setState(() {
                                      _isvisible = true;
                                      log("PP");
                                    });
                                  }

                                  return null;
                                },
                                maxLength: 3,
                                textAlignVertical: TextAlignVertical.center,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 9, horizontal: 12),
                                    counterText: "",
                                    filled: true,
                                    fillColor: Theme.of(context)
                                        .colorScheme
                                        .background)),
                          ],
                        ),
                      )
                      // WidgetInputnum(
                      //   controller: weight,
                      //   labelText: "ระบุน้ำหนักปัจจุบัน(กิโลกรัม)",
                      //   maxLength: 3,
                      // ),
                      ),
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: 3,
                      top: 15,
                      left: 20,
                      right: 20,
                    ),
                    child: WidgetTextFieldLines(
                        controller: detail, labelText: "เพิ่มความคิดเห็น"),
                  ),
                  Visibility(
                    visible: _isvisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10, left: 20, right: 23),
                          child: Text(
                            "กรุณากรอกข้อความให้ครบและถูกต้อง",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error,
                                fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 35, right: 35, top: 15),
                    child: SizedBox(
                      width: 400,
                      child: FilledButton(
                          onPressed: () async {
                            // log("A" + value.toString());
                            //log("B"+rating.toString());
                            if (_formKey.currentState!.validate()) {
                              setState(() {
                                _isvisible = false;
                              });
                            }
                            if (detail.text.isEmpty ||
                                value.toString().isEmpty ||
                                weight.text.isEmpty ||
                                _isvisible == true ||
                                isValidpw == false) {
                              setState(() {
                                _isvisible = true;
                              });
                            } else {
                              setState(() {
                                _isvisible = false;
                              });
                              log("BILL" +  widget.billID.toString().toString());
                              InsertReview insertReview = InsertReview(
                                  customerId: uid,
                                  details: detail.text,
                                  score: value.toInt(),
                                  weight: int.parse(weight.text));
                              log(jsonEncode(insertReview));
                              insert = await reviewService.insertreview(
                                  widget.billID.toString(), insertReview);
                              moduleResult = insert.data;
                              log("Model" + moduleResult.result);
                              if (moduleResult.result == '0') {
                                log("A");
                                // ignore: use_build_context_synchronously
                                stopLoading();
                                warning(context);
                              } else {
                                stopLoading();
                                log("BILL2" +  widget.billID.toString().toString());
                                   pushNewScreen(
                                  context,
                                  screen:  HistoryPage(),
                                  withNavBar: true,
                                );
                                // Get.to(() => ShowReviewweightPage(
                                //       newweightreview: int.parse(weight.text),
                                //       billID: widget.billID.toString(),
                                //     ));
                              }
                            }
                          },
                          child:
                              Text("ยืนยัน", style: TextStyle(fontSize: 16))),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
