import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/food_get_res.dart';
import 'package:frontendfluttercoach/page/coach/food/foodCourse/edit_food.dart';
import 'package:frontendfluttercoach/page/coach/food/foodCourse/insertFood/food_new_page.dart';
import 'package:frontendfluttercoach/service/clip.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../model/response/clip_get_res.dart';
import '../../service/food.dart';
import '../../service/provider/appdata.dart';
import '../clip/clipCourse/insertClip/clip_select_page.dart';
import 'daysCourse/days_course_page.dart';

class HomeFoodAndClipPage extends StatefulWidget {
  HomeFoodAndClipPage({super.key, required this.did, required this.sequence});

  late String did;
  late String sequence;

  @override
  State<HomeFoodAndClipPage> createState() => _HomeFoodAndClipPageState();
}

class _HomeFoodAndClipPageState extends State<HomeFoodAndClipPage> {
  // FoodService
  late Future<void> loadFoodDataMethod;
  late FoodServices _foodService;
  List<ModelFood> foods = [];

  // ClipService
  late Future<void> loadClipDataMethod;
  late ClipServices _ClipService;
  List<ModelClip> clips = [];

  //onoffShow
  bool onVisibles = true;
  bool offVisibles = false;

  @override
  void initState() {
    super.initState();
    context.read<AppData>().sequence = widget.sequence;

    //Food
    _foodService = context.read<AppData>().foodServices;
    loadFoodDataMethod = loadFoodData();

    //Clip
    _ClipService = context.read<AppData>().clipServices;
    loadClipDataMethod = loadClipData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            // iconTheme: const IconThemeData(
            //   color: Colors.black, //change your color here
            // ),
            title: Text("Day ${widget.sequence}"),
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              ),
              onPressed: () {
                Get.to(() => DaysCoursePage(
                      coID: context.read<AppData>().coID.toString(),
                    ));
              },
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.plus,
                ),
                onPressed: () {
                  _dialog(context);
                },
              )
            ],
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(
                  FontAwesomeIcons.bowlFood,
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.dumbbell,
                ),
              )
            ]),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //Food
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: showFood(),
                    ),
                  ),
                ],
              ),

              //Clip
              Column(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: showClip(),
                    ),
                  )
                ],
              ),
            ],
          )),
    );
  }

  //LoadData
  Future<void> loadFoodData() async {
    try {
      log(widget.did);
      var datas = await _foodService.foods(fid: '', ifid: '', did: widget.did);
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadClipData() async {
    try {
      var datas =
          await _ClipService.clips(cpID: '', icpID: '', did: widget.did);
      clips = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data

  Widget showFood() {
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Card(
                  //color: Colors.white,
                  elevation: 1000,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => EditFoodPage(
                            fid: listfood.fid.toString(),
                            did: widget.did,
                            sequence: widget.sequence,
                            coID: context.read<AppData>().coID.toString(),
                          ));
                    },
                    child: Column(
                      children: [
                        if (listfood.listFood.image != '') ...{
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height * 0.28,
                            child: Image.network(
                              listfood.listFood.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        } else
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(listfood.listFood.image),
                                  ),
                                )),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AutoSizeText(
                                listfood.listFood.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                            Text(
                              listfood.time == '1'
                                  ? 'มื้อเช้า'
                                  : listfood.time == '2'
                                      ? 'มื้อเที่ยง'
                                      : listfood.time == '3'
                                          ? 'มื้อเย็น'
                                          : 'มื้อใดก็ได้',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
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

  Widget showClip() {
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final listClip = clips[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  //color: Colors.white,
                  elevation: 1000,
                  child: InkWell(
                    onTap: () {
                      // Get.to(() => EditFoodPage(fid: listfood.fid.toString()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8, right: 8, top: 5, bottom: 5),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  color: Colors.pink)),
                        ),
                        Center(
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.4,
                            child: AutoSizeText(
                              listClip.listClip.name,
                              maxLines: 5,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                      ],
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

  void _dialog(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.35,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.background,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("รายการเพิ่ม",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => FoodNewCoursePage(did: widget.did));
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 100,
                          height: 50,
                          child: Icon(
                            FontAwesomeIcons.bowlFood,
                            size: 50,
                            //color: Colors.black,
                          ),
                        ),
                        Text(
                          'เพิ่มเมนู',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => ClipSelectPage(did: widget.did));
                    },
                    child: Column(
                      children: [
                        const SizedBox(
                          width: 100,
                          height: 50,
                          child: Icon(
                            FontAwesomeIcons.dumbbell,
                           // color: Colors.white,
                            size: 50,
                          ),
                        ),
                        Text(
                          'เพิ่มคลิป',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
