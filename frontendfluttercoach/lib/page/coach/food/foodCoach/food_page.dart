import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';

import '../../../../model/response/md_ClipList_get.dart';
import '../../../../model/response/md_FoodList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listClip.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';

import '../../../clip/clipCoach/clip_edit_page.dart';
import '../../../clip/clipCoach/clip_new_page.dart';
import 'food_edit_page.dart';
import 'food_new_page.dart';

class FoodCoachPage extends StatefulWidget {
  const FoodCoachPage({super.key});

  @override
  State<FoodCoachPage> createState() => _FoodCoachPageState();
}

class _FoodCoachPageState extends State<FoodCoachPage> {
  //Service ListFood
  late ListFoodServices _listfoodService;
  late Future<void> loadFoodDataMethod;
  late List<ModelFoodList> foods = [];

  //Service ListClip
  late ListClipServices _listClipService;
  late Future<void> loadClipDataMethod;
  late List<ModelClipList> clips = [];

  String cid = "";
  late ModelResult modelResult;
  bool isDelete = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<AppData>().cid.toString();
    //LoadFoodService
    _listfoodService = context.read<AppData>().listfoodServices;
    loadFoodDataMethod = loadFoodData();

    //LoadClipService
    _listClipService = context.read<AppData>().listClipServices;
    loadClipDataMethod = loadClipData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.bowlFood),
                label: 'เพิ่มเมนู',
                onTap: () {
                  Get.to(() => const FoodNewCoachPage());
                }),
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.dumbbell),
                label: 'เพิ่มคลิป',
                onTap: () {
                  Get.to(() => const ClipNewCoachPage());
                }),
          ],
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: TextButton(
              onPressed: () {},
              child: Text(
                'อาหารและคลิป',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlass,
              ),
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
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: showFood(),
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: showClips(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  //Show
  FutureBuilder<void> showFood() {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double padding = 8;
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  //color: Colors.white,
                  elevation: 1000,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => FoodEditCoachPage(ifid: listfood.ifid));
                    },
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (listfood.image != '') ...{
                          Image.network(
                            listfood.image,
                            fit: BoxFit.cover,
                            height: double.infinity,
                          ),
                        } else
                          // Container(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.pink)),
                        Positioned.fill(
                            bottom: 5,
                            //right: 0,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  width: (width - 16 - (3 * padding)) / 2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  color: const Color.fromARGB(100, 22, 44, 33),
                                  //margin: EdgeInsets.all(20),
                                  padding: const EdgeInsets.all(40),
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    listfood.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                dialogDeleteFood(
                                    context, listfood.ifid.toString());
                              },
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                              ),
                            ),
                          ],
                        )
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

  //Clips
  FutureBuilder<void> showClips() {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double padding = 8;
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final listClips = clips[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  //color: Colors.white,
                  elevation: 1000,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ClipEditCoachPage(
                            icpId: listClips.icpId,
                          ));
                    },
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.pink)),
                        Positioned.fill(
                            bottom: 5,
                            //right: 0,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  width: (width - 16 - (3 * padding)) / 2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  color: const Color.fromARGB(100, 22, 44, 33),
                                  //margin: EdgeInsets.all(20),
                                  padding: const EdgeInsets.all(40),
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    listClips.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              onPressed: () {
                                dialogDeleteClip(
                                    context, listClips.icpId.toString());
                              },
                              icon: const Icon(
                                FontAwesomeIcons.trash,
                              ),
                            ),
                          ],
                        )
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

  Future<void> loadFoodData() async {
    try {
      var datas = await _listfoodService.listFoods(
        ifid: '',
        cid: cid,
        name: '',
      );
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadClipData() async {
    try {
      var datas =
          await _listClipService.listClips(icpID: '', cid: cid, name: '');
      clips = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  //Dialog Delete
  void dialogDeleteFood(BuildContext context, String ifid) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("คุณต้องการลบหรือไม",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                      },
                      child: Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () async {
                        var response =
                            await _listfoodService.deleteListFood(ifid);
                        modelResult = response.data;
                        log(modelResult.result);
                        setState(() {
                          loadFoodDataMethod = loadFoodData();
                        });
                        SmartDialog.dismiss();
                      },
                      child: Text("ตกลง"))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  void dialogDeleteClip(BuildContext context, String iCpid) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("คุณต้องการลบหรือไม",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();
                      },
                      child: Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () async {
                        var response =
                            await _listClipService.deleteListClip(iCpid);
                        modelResult = response.data;
                        log(modelResult.result);
                        setState(() {
                          loadClipDataMethod = loadClipData();
                        });
                        SmartDialog.dismiss();
                      },
                      child: Text("ตกลง"))
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}
