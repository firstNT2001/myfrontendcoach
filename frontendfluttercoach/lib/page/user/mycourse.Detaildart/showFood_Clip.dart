import 'dart:convert';
import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:buddhist_datetime_dateformat/buddhist_datetime_dateformat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontendfluttercoach/service/course.dart';
import 'package:intl/intl.dart';
import 'package:video_player/video_player.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../service/clip.dart';
import '../../../model/request/status_clip.dart';
import '../../../model/request/userRequest.dart';
import '../../../model/response/food_get_res.dart';
import '../../../model/response/md_Result.dart';
import '../../../model/response/md_coach_course_get.dart';
import '../../../service/food.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../../service/provider/appdata.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import '../../../service/request.dart';
import 'myClipinCourse/widget_loadcilcp.dart';
import 'mycourse.dart';

class showFood extends StatefulWidget {
  showFood({super.key, required this.indexSeq});
  late int indexSeq;
  @override
  State<showFood> createState() => _showFoodState();
}

class _showFoodState extends State<showFood> {
  List<ModelFood> foods = [];
  late ClipServices clipServices;
  List<ModelClip> clips = [];
  late FoodServices foodService;
  late Future<void> loadDataMethod;
  int did = 0;
  int coID = 0;
  int coachID = 0;
  int uid = 0;
  late String videoUrl = "";
  //updatestatus
  late ModelResult moduleResult;
  String status = "";
  List<bool> isChecked = [];
  late CourseService courseService;
  late Course courses;
  late RequestService requestService;
  var update;
  var insert;
  //date
  int dayincourse = 0;
  late DateTime exdate;
  late DateTime dayex;
  DateTime nows = DateTime.now();
  late DateTime today;
  List<DateTime> listindexday = [];
  //showclip
  bool showtoday = false;
  bool showyesterday = false;
  bool showtomorrow = false;
  //req
  TextEditingController textRequest = TextEditingController();
  void initState() {
    // TODO: implement initState
    super.initState();
    coachID = context.read<AppData>().cid;
    uid = context.read<AppData>().uid;
    log("uid" + uid.toString());
    did = context.read<AppData>().did;
    coID = context.read<AppData>().idcourse;
    requestService =
        RequestService(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    clipServices =
        ClipServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    foodService = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
    today = DateTime(nows.year, nows.month, nows.day);
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(Icons.fastfood_outlined),
                text: "เมนูอาหาร",
              ),
              Tab(
                icon: Icon(Icons.fitness_center_sharp),
                text: "คลิปออกกำลังกาย",
              ),
            ]),
          ),
          body: TabBarView(children: [
            Column(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadfoods(),
                )),
              ],
            ),
            Column(
              children: [
                Visibility(
                    visible: showtoday,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadclipschecktoday(),
                      ),
                    )),
                Visibility(
                    visible: showtomorrow,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadclipschecktomorrow(),
                      ),
                    )),
                Visibility(
                    visible: showyesterday,
                    child: Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: loadclipscheckyesterday(),
                      ),
                    )),
                // Expanded(
                //     child: Padding(
                //       padding: const EdgeInsets.all(8.0),
                //       child: loadclipschecktoday(),
                //     ),
                //   ),
                // (caldate == 0)?Expanded(
                //     child: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: loadclipscheck(),
                // )) : (caldate > 0 )?Expanded(
                //     child: Padding(
                //   padding: const EdgeInsets.all(8.0),
                //   child: loadclipscantcheck(),
                // )) : const Center(child: CircularProgressIndicator())
              ],
            ),
          ]),
        ));
  }

  Widget loadclipschecktoday() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index) {
                  final listclip = clips[index];
                  videoUrl = listclip.listClip.video;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(listclip.listClip.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge)),
                            ),
                            WidgetloadCilp(
                              urlVideo: videoUrl,
                              nameclip: listclip.listClip.name,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.details,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.amountPerSet,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: isChecked[index],
                                  onChanged: (bool? value) async {
                                    setState(() {
                                      isChecked[index] = value!;
                                    });
                                    log(listclip.cpId.toString());
                                    String cpID = listclip.cpId.toString();
                                    if (value == false) {
                                      status = "0";
                                      log("status false");
                                    } else {
                                      status = "1";
                                      log("statustrue");
                                    }
                                    StatusClip updateStatusClip =
                                        StatusClip(status: status);
                                    log(jsonEncode(updateStatusClip));
                                    update =
                                        await courseService.updateStatusClip(
                                            cpID, updateStatusClip);
                                    moduleResult = update.data;
                                    log(moduleResult.result);
                                  },
                                ),
                                const Text(
                                  "ออกกำลังกายแล้ว",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget loadclipschecktomorrow() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index) {
                  log("ldshowtomorrow" + showtomorrow.toString());

                  final listclip = clips[index];
                  videoUrl = listclip.listClip.video;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(listclip.listClip.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge)),
                            ),
                            WidgetloadCilp(
                              urlVideo: videoUrl,
                              nameclip: listclip.listClip.name,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.details,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.amountPerSet,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: isChecked[index],
                                  onChanged: (bool? value) async {},
                                ),
                                const Text(
                                  "ออกกำลังกายแล้ว",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ],
                            ),
                            Center(
                              child: FilledButton(
                                  onPressed: () {
                                    _bindPage(context);
                                  },
                                  child: const Text("คำร้องขอเปลี่ยนท่า")),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget loadclipscheckyesterday() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index) {
                  final listclip = clips[index];
                  videoUrl = listclip.listClip.video;
                  if (listclip.status == "1") {
                    log("statusyes" + status);
                    isChecked[index] = true;
                  } else {
                    isChecked[index] = false;
                    log("statusyes" + status);
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      elevation: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text(listclip.listClip.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge)),
                            ),
                            WidgetloadCilp(
                              urlVideo: videoUrl,
                              nameclip: listclip.listClip.name,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.details,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(listclip.listClip.amountPerSet,
                                  style: Theme.of(context).textTheme.bodyLarge),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Checkbox(
                                  value: isChecked[index],
                                  onChanged: (bool? value) async {},
                                ),
                                const Text(
                                  "ออกกำลังกายแล้ว",
                                  style: TextStyle(fontSize: 17.0),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                });
          }
        });
  }

  Widget loadfoods() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final listfood = foods[index];
                  final GlobalKey<ExpansionTileCardState> cardA =
                      new GlobalKey();
                  return ExpansionTileCard(
                    //baseColor: const Color.fromARGB(255, 212, 212, 212),
                    //expandedColor: const Color.fromARGB(255, 191, 191, 191),
                    key: cardA,
                    leading: SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          listfood.listFood.image,
                        )),
                    title: Text(listfood.listFood.name),
                    subtitle: Text("${listfood.listFood.calories} แคลอรี่",
                        style: Theme.of(context).textTheme.bodyLarge),
                    children: <Widget>[
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                        color: Colors.black,
                        endIndent: 8,
                        indent: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(listfood.listFood.details,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ),
                    ],
                  );
                });
          }
        });
  }

  void _bindPage(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.38,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text("คุณต้องการร้องขอเปลี่ยนท่านี้ใช่หรือไม่",
                  style: Theme.of(context).textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child:
                  Text("สาเหตุ", style: Theme.of(context).textTheme.bodyLarge),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: textRequest,                
                keyboardType: TextInputType.multiline,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "กรุณาใส่ข้อความ",
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 2, color: Colors.redAccent),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        width: 2,
                        color: Theme.of(context)
                            .colorScheme
                            .onPrimary), //<-- SEE HERE
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  FilledButton(
                    onPressed: () {
                      SmartDialog.dismiss();
                    },
                    child: const Text('ยกเลิก'),
                  ),
                  FilledButton(
                    onPressed: () async {
                      UserRequest userRequest = UserRequest(
                          coachId: coachID,
                          clipId: clips.first.cpId,
                          details: textRequest.text);

                      log(jsonEncode(userRequest));
                      insert = await requestService.insertRequest(
                          uid.toString(), userRequest);
                      moduleResult = insert.data;
                      log(moduleResult.result);
                      // context.read<AppData>().did = days.first.did;
                      // context.read<AppData>().idcourse = coID;
                      // log(days.first.did.toString());
                      Get.to(() => MyCouses());
                    },
                    //     widget.coID.toString()
                    child: const Text('ยืนยัน'),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Future<void> loadData() async {
    try {
      var dataclip =
          await clipServices.clips(cpID: '', icpID: '', did: did.toString());
      clips = dataclip.data;
      var datafood = await foodService.foods(
          fid: '', ifid: '', did: did.toString(), name: '');
      foods = datafood.data;

      log('food leng: ${foods.length}');
      for (var index in clips) {
        isChecked.add(false);
      }

      var datacourse = await courseService.coursebyCoID(coID.toString());
      courses = datacourse.data;
      dayincourse = courses.days;
      exdate = DateTime.parse(courses.expirationDate);

      var formatter = DateFormat.yMMMd();
      //หาลิสของวันทั้งหมดที่มี แล้วเรียงวันใหม่
      log("dayincourse= " + dayincourse.toString());
      for (int i = 0; i < dayincourse; i++) {
        dayex = DateTime(exdate.year, exdate.month, exdate.day - i);
        listindexday.add(dayex);
        listindexday.sort();
        log("iร= " + listindexday[i].day.toString());
      }
      log("iรf= " + listindexday.toString());
      //ลิสที่หาได้มาเช็คว่า วันปัจจุบันและวันหมดอายุอยู่indexไหน
      for (int i = 0; i < listindexday.length; i++) {
        log("i= " + listindexday[i].day.toString());
        if (today.day == listindexday[i].day) {
          log("today= " + today.toString());
          if (i == widget.indexSeq) {
            setState(() {
              showtoday = true;
              log("วันนี้นะจ๊ะ");
              log("วันนี้นะจ๊ะi= " +
                  i.toString() +
                  "  widget.indexSeq " +
                  widget.indexSeq.toString());
            });
          } else if (i > widget.indexSeq) {
            setState(() {
              showyesterday = true;
              log("วันนี้คือเมื่อวาน");
              log("วันนี้คือเมื่อวานi= " +
                  i.toString() +
                  "  widget.indexSeq " +
                  widget.indexSeq.toString());
            });
          } else {
            setState(() {
              showtomorrow = true;
              log("วันพรุ่งนี้นะจ๊ะ");
              log("วันพรุ่งนี้นะจ๊ะi= " +
                  i.toString() +
                  "  widget.indexSeq " +
                  widget.indexSeq.toString());
            });
          }
        } else {
          Container();
        }
      }
      log("showtoday" + showtoday.toString());
      log("showtomorrow" + showtomorrow.toString());
      log("showyesterdayshowyesterday" + showyesterday.toString());
    } catch (err) {
      log('Error: $err');
    }
  }
}
