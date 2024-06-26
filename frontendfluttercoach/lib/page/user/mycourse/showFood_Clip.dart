import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/service/course.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
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

import '../../../service/request.dart';
import '../../../widget/showCilp.dart';
import 'Widget/widget_loadcilcp.dart';
import 'Widget/widget_showfood.dart';
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

    did = context.read<AppData>().did;
    log("did$did");
    log("indexSeq${widget.indexSeq}");
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
     log("indexSeqtoday${today}");
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
       
          body: Column(
            children: [
              showAppBar(context),
              Expanded(
                child: TabBarView(children: [
                 Column(
                   children: [
                     Visibility(
                         visible: showtoday,
                         child: Expanded(
                           child: loadclipschecktoday(),
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
                   ],
                 ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 15),
                          child: Text(
                            "มื้อเช้า",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Widgetloadfood(
                              did: did,
                              time: '1',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 15),
                          child: Text(
                            "มื้อเที่ยง",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Widgetloadfood(
                              did: did,
                              time: '2',
                            ),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 8, top: 15),
                          child: Text(
                            "มื้อเย็น",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                        ),
                        SizedBox(
                          height: 200,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Widgetloadfood(
                              did: did,
                              time: '3',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ]),
              ),
            ],
          ),
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
                  return Padding(
                    padding:
                        const EdgeInsets.only(left: 10, right: 10, bottom: 8),
                    child: Card(
                      elevation: 5,
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
                  log("ldshowtomorrow$showtomorrow");

                  final listclip = clips[index];
                  videoUrl = listclip.listClip.video;
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                        elevation: 5,
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
                              // WidgetloadCilp(
                              //   urlVideo: videoUrl,
                              //   nameclip: listclip.listClip.name,
                              // ),
                              Text(listclip.listClip.name),
                              WidgetShowCilp(urlVideo: videoUrl,),
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
                              Padding(
                                padding: const EdgeInsets.only(bottom: 15),
                                child: Center(
                                  child: FilledButton(
                                      onPressed: () {
                                        _bindPage(context);
                                      },
                                      child: const Text("คำร้องขอเปลี่ยนท่า")),
                                ),
                              ),
                            ],
                          ),
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
                    log("statusyes$status");
                    isChecked[index] = true;
                  } else {
                    isChecked[index] = false;
                    log("statusyes$status");
                  }
                  return SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    child: Card(
                      elevation: 5,
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
                    borderSide:
                        const BorderSide(width: 2, color: Colors.redAccent),
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
                      pushNewScreen(
                        context,
                        screen: const MyCouses(),
                        withNavBar: true,
                      );
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
      for (var clip in clips) {
        log('ssss ' + clip.status);
        if (clip.status == "0") {
          isChecked.add(false);
        } else {
          isChecked.add(true);
        }
        // isChecked.add(bool.tryParse(clip.status) ?? false);
      }

      var datacourse = await courseService.coursebyCoID(coID.toString());
      courses = datacourse.data;
      //dayincourse = courses.days;
      exdate = DateTime.parse(courses.expirationDate);

      var formatter = DateFormat.yMMMd();
      //หาลิสของวันทั้งหมดที่มี แล้วเรียงวันใหม่
      log("dayincourse= $dayincourse");
      for (int i = 0; i < courses.days; i++) {
        dayex = DateTime(exdate.year, exdate.month, exdate.day - i);
        listindexday.add(dayex);
        listindexday.sort();
        log("iร= ${listindexday[i].day}");
      }
      log("iรf= $listindexday");
      //ลิสที่หาได้มาเช็คว่า วันปัจจุบันและวันหมดอายุอยู่indexไหน
      for (int i = 0; i < listindexday.length; i++) {
        log("i= ${listindexday[i].day}");
        if (today.day == listindexday[i].day) {
          log("today= $today");
          if (i == widget.indexSeq) {
            setState(() {
              showtoday = true;
              log("วันนี้นะจ๊ะ");
              log("วันนี้นะจ๊ะi= $i  widget.indexSeq ${widget.indexSeq}");
            });
          } else if (i > widget.indexSeq) {
            setState(() {
              showyesterday = true;
              log("วันนี้คือเมื่อวาน");
              log("วันนี้คือเมื่อวานi= $i  widget.indexSeq ${widget.indexSeq}");
            });
          } else {
            setState(() {
              showtomorrow = true;
              log("วันพรุ่งนี้นะจ๊ะ");
              log("วันพรุ่งนี้นะจ๊ะi= $i  widget.indexSeq ${widget.indexSeq}");
            });
          }
        } else {
          Container();
        }
      }
      log("showtoday$showtoday");
      log("showtomorrow$showtomorrow");
      log("showyesterdayshowyesterday$showyesterday");
    } catch (err) {
      log('Error: $err');
    }
  }

  Stack showAppBar(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 196, 196, 196),
                blurRadius: 20.0,
                spreadRadius: 1,
                offset: Offset(
                  0,
                  1,
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
                  gradient: LinearGradient(begin: Alignment.topCenter, colors: [
                Color.fromARGB(225, 255, 138, 5),
                Color.fromARGB(226, 255, 154, 22),
                Color.fromARGB(226, 255, 154, 22),
              ])),
              height: 180,
            ),
          ),
        ),
        Row(children: [Padding(
              padding: const EdgeInsets.only(left: 15, top: 35),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.chevronLeft,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
            Center(
                child: Padding(
              padding: const EdgeInsets.only(left: 2, top: 38),
              child: Text("วันที่ ${widget.indexSeq + 1}",
                  style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )),],),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            const Center(
                child: Padding(
              padding: EdgeInsets.only(left: 15, top: 90),
              child: Text("เมนูและคลิป",
                  style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white)),
            )),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 15),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 243, 243, 244),
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: const [
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
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: TabBar(
                            indicatorWeight: 2,
                            indicatorColor:
                                Theme.of(context).colorScheme.primary,
                            labelColor: Theme.of(context)
                                .colorScheme
                                .primary, //<-- selected text color
                            unselectedLabelColor: Theme.of(context)
                                .colorScheme
                                .tertiary, //<-- Unselected text
                            // indicator: BoxDecoration(
                            //     color: Theme.of(context).colorScheme.primary,
                            //     borderRadius: BorderRadius.circular(15)),
                            tabs: const [
                              Tab(
                                icon: Icon(
                                  FontAwesomeIcons.utensils,
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  FontAwesomeIcons.dumbbell,
                                ),
                              )
                            ]),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )
      ],
    );
  }
}
