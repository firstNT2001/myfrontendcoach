import 'dart:convert';
import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/course.dart';
import 'package:video_player/video_player.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../service/clip.dart';
import '../../../model/request/status_clip.dart';
import '../../../model/response/food_get_res.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/food.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../../service/provider/appdata.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'myClipinCourse/widget_loadcilcp.dart';
import 'mycourse.dart';

class showFood extends StatefulWidget {
  const showFood({super.key});

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
  String namecourse = "";

  late String videoUrl = "";
  //updatestatus
  late ModelResult moduleResult;
  String status = "";
  List<bool> isChecked = [];
  late CourseService courseService;
  var update;
  //date
  DateTime nows =  DateTime.now();
 String datenow = "";
  void initState() {
    // TODO: implement initState
    super.initState();
    did = context.read<AppData>().did;
    namecourse = context.read<AppData>().namecourse;
    log("did" + did.toString());
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    clipServices =
        ClipServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    foodService = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData(); 
    DateTime date =  DateTime(nows.day, nows.month,nows.year );
    datenow = date.toString();
    log("DATE555:"+datenow);
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
            title: Center(
              child: Text(namecourse),
            ),
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
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: loadclips(),
                )),
              ],
            ),
          ]),
        ));
    // Scaffold(
    //   body: Column(children: [Flexible(child: loadfoods()),
    //   Flexible(
    //       child: Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             ElevatedButton(
    //                 child: const Text('ถอยกลับ'),
    //                 onPressed: () {
    //                   Get.to(() => const MyCouses());
    //                 },
    //                 ),
    //                 ElevatedButton(
    //                 child: const Text('ถัดไป'),
    //                 onPressed: () {
    //                   log("Did := "+did.toString());
    //                   context.read<AppData>().did = did;
    //                   Get.to(() => const showCilp());
    //                 },
    //                ),
    //           ],
    //         ),
    //       ),
    //     )
    //   ]),
    // );
  }

  Widget loadclips() {
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
                                Text(
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
                    // Container(
                    //   alignment: Alignment.topCenter,
                    //   child: AspectRatio(aspectRatio: 16/9,child: Image.network(listfood.listFood.image, fit: BoxFit.cover)),
                    // ),
                    // SizedBox(
                    //     height: 200,
                    //     width: 200,
                    //     child: Image.network(
                    //       listfood.listFood.image,
                    //     )),
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
                  // ExpansionTile(
                  //   title: Row(
                  //     children: [
                  //       SizedBox(
                  //         height: 150,width: 150,
                  //         child: Image.network(listfood.listFood.image)),
                  //       Column(
                  //         children: [
                  //           Text(listfood.listFood.name,
                  //               style: Theme.of(context).textTheme.bodyLarge),

                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  //   subtitle: Text("${listfood.listFood.calories} แคลอรี่",
                  //       style: Theme.of(context).textTheme.bodyLarge),
                  //   children: <Widget>[
                  //     ListTile(title: Text(listfood.listFood.details)),
                  //   ],
                  //   onExpansionChanged: (bool extended){
                  //     setState(() => );
                  //   },
                  // );
                });
          }
        });
  }

  Future<void> loadData() async {
    try {
      var dataclip =
          await clipServices.clips(cpID: '', icpID: '', did: did.toString());
      clips = dataclip.data;
      var datafood =
          await foodService.foods(fid: '', ifid: '', did: did.toString());
      foods = datafood.data;
      log('food leng: ${foods.length}');
      for (var index in clips) {
        isChecked.add(false);
      }
    } catch (err) {
      log('Error: $err');
    }
  }
}
