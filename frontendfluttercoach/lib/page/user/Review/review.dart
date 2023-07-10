import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:frontendfluttercoach/page/user/mycourse.Detaildart/mycourse.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:frontendfluttercoach/service/review.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../model/request/insertReview.dart';
import '../../../model/response/md_Result.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late ReviewService reviewService;
  late ModelResult moduleResult;

  int cid = 51;
  int courseId = 301;
  final TextEditingController detail = TextEditingController();
  final TextEditingController weight = TextEditingController();
  double value = 0.0;

  var insert;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<AppData>().cid;
    log(context.read<AppData>().baseurl);
    reviewService =
       context.read<AppData>().reviewService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("ขอแสดงความยินดี"),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.4,
                    child: Image.asset("assets/images/trophy.png")),
                const Text("คุณได้ออกกำลังกายจบคอร์สแล้ว"),
                const Text("บันทึกการเปลี่ยนแปลง"),
                const Text("ระบุน้ำหนักปัจจุบัน"),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: TextFormField(
                        controller: weight,
                        keyboardType: TextInputType.number,
                      )),
                ),
                const Text("ให้คะแนน"),
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
                    valueLabelPadding:
                        const EdgeInsets.symmetric(vertical: 1, horizontal: 8),
                    valueLabelMargin: const EdgeInsets.only(right: 8),
                    starOffColor: const Color(0xffe7e8ea),
                    starColor: Colors.yellow,
                  ),
                ),
                const Text("คะแนนความพึงพอใจ"),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12, top: 25),
                  child: Text("เพิ่มความคิดเห็น"),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.85,
                    child:  TextField(
                      controller: detail,
                        keyboardType: TextInputType.multiline, maxLines: 4)),
                FilledButton(
                    onPressed: () async {
                      print(value.toInt());
                      print(cid);
                     // log("A" + value.toString());
                      //log("B"+rating.toString());
                      InsertReview insertReview = InsertReview(
                          courseId: courseId,
                          details: detail.text,
                          score: value.toInt(),
                          weight: int.parse(weight.text));
                      log(jsonEncode(insertReview));
                      insert = await reviewService.insertreview(
                          cid.toString(), insertReview);
                      moduleResult = insert.data;
                      log(moduleResult.result);
                      // Get.to(() => MyCouses());
                    },
                    child: const Text("ยืนยัน"))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
