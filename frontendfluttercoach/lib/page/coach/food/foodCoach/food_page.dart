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
import '../../../search/search_clip_coach.dart';
import '../../../search/search_food_coach.dart';
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
          automaticallyImplyLeading: false,
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: TextButton(
              onPressed: () {},
              child: Text(
                'อาหารและคลิป',
                style: Theme.of(context).textTheme.headlineSmall,
              )),
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchFoodCoachPage());
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            color: const Color.fromRGBO(244, 243, 243, 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(() => const SearchFoodCoachPage());
                              },
                              icon: const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "ค้นหารายการอาหาร...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        )),
                  ),
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
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Get.to(() => const SearchClipCoachPage());
                    },
                    child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 45,
                        decoration: BoxDecoration(
                            boxShadow: const <BoxShadow>[
                              BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 5.0,
                                  offset: Offset(0.0, 0.75))
                            ],
                            color: const Color.fromRGBO(244, 243, 243, 1),
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            TextButton.icon(
                              onPressed: () {
                                Get.to(() => const SearchFoodCoachPage());
                              },
                              icon: const Icon(
                                FontAwesomeIcons.magnifyingGlass,
                                color: Colors.black,
                              ),
                              label: const Text(
                                "ค้นหารายการคลิปท่าออกกำลังกาย...",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        )),
                  ),
                ),
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
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisExtent: 300),
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => FoodEditCoachPage(ifid: listfood.ifid));
                    },
                    child: Column(
                      children: [
                        if (listfood.image != '') ...{
                          AspectRatio(
                              aspectRatio: 16 / 13,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  image: DecorationImage(
                                      image: NetworkImage(listfood.image),
                                      fit: BoxFit.cover),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )),
                          //color: Colors.white,
                        } else
                          AspectRatio(
                              aspectRatio: 16 / 13,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xff7c94b6),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: AutoSizeText(
                                  listfood.name,
                                  maxLines: 5,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
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
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,mainAxisExtent: 300,
            ),
            shrinkWrap: true,
            itemCount: clips.length,
            itemBuilder: (context, index) {
              final listClips = clips[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.4,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => ClipEditCoachPage(icpId: listClips.icpId));
                    },
                    child: Column(
                      children: [
                        AspectRatio(
                            aspectRatio: 16 / 13,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff7c94b6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 16, top: 8),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: AutoSizeText(
                                  listClips.name,
                                  maxLines: 5,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                            ),
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
                      child: const Text("ตกลง"))
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
