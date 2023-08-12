import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../model/response/md_ClipList_get.dart';
import '../../../model/response/md_FoodList_get.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/listClip.dart';
import '../../../service/listFood.dart';
import '../../../service/provider/appdata.dart';

import '../../../widget/image_video.dart';
import 'clipCoach/clip_edit_page.dart';
import 'clipCoach/clip_new_page.dart';
import '../../search/search_clip_coach.dart';
import '../../search/search_food_coach.dart';
import 'foodCoach/food_edit_page.dart';
import 'foodCoach/food_new_page.dart';

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
  late List<ListClip> clips = [];

  String cid = "";
  late ModelResult modelResult;
  bool isDelete = false;
  bool _enabledFood = true;
  // ignore: unused_field
  bool _enabledClip = true;

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
          backgroundColor: Theme.of(context).colorScheme.primary,
          animatedIcon: AnimatedIcons.menu_close,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.bowlFood),
                label: 'เพิ่มเมนู',
                onTap: () {
                  // pushNewScreen(
                  //   context,
                  //   screen: const FoodNewCoachPage(),
                  //   withNavBar: true,
                  // );
                  Get.to(() => const FoodNewCoachPage());
                }),
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.dumbbell),
                label: 'เพิ่มคลิป',
                onTap: () {
                  //  pushNewScreen(
                  //   context,
                  //   screen: const ClipNewCoachPage(),
                  //   withNavBar: true,
                  // );
                  Get.to(() => const ClipNewCoachPage());
                }),
          ],
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          title: Center(
            child: TextButton(
                onPressed: () {},
                child: Text(
                  'อาหารและคลิป',
                  style: Theme.of(context).textTheme.headlineSmall,
                )),
          ),
          bottom: TabBar(
              labelColor: Theme.of(context)
                  .colorScheme
                  .primary, //<-- selected text color
              unselectedLabelColor: Theme.of(context)
                  .colorScheme
                  .primaryContainer, //<-- Unselected text
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
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                (_enabledFood)
                    ? Skeletonizer(enabled: true, child: searchFood(context))
                    : searchFood(context),
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
                const SizedBox(
                  height: 10,
                ),
                (_enabledFood)
                    ? Skeletonizer(enabled: true, child: searchClip(context))
                    : searchClip(context),
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

  Padding searchClip(BuildContext context) {
    return Padding(
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
                    Get.to(() => const SearchClipCoachPage());
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
    );
  }

  Padding searchFood(BuildContext context) {
    return Padding(
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
    );
  }

  //Show
  FutureBuilder<void> showFood() {
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Skeletonizer(
            enabled: _enabledFood,
            child: gridViewFood(),
          );
        } else {
          return Skeletonizer(
            enabled: _enabledFood,
            child: gridViewFood(),
          );
        }
        // return (_enabled == true)
        //     ? Skeletonizer(
        //         enabled: true,
        //         child: gridViewFood(),
        //       )
        //     : gridViewFood();
      },
    );
  }

  gridViewFood() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, mainAxisExtent: 230),
      shrinkWrap: true,
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final listfood = foods[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            //height: MediaQuery.of(context).size.height * 0.4,
            child: InkWell(
              onTap: () {
                // pushNewScreen(
                //   context,
                //   screen: FoodEditCoachPage(ifid: listfood.ifid),
                //   withNavBar: true,
                // );
                Get.to(() =>  FoodEditCoachPage(ifid: listfood.ifid));
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (listfood.image != '') ...{
                        AspectRatio(
                            aspectRatio: 16 / 13,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 207, 208, 209),
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
                                color: const Color.fromARGB(255, 207, 208, 209),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                              color: Color.fromARGB(255, 93, 93, 93),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 8),
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width * 0.35,
                          child: Text(
                            listfood.name,
                            maxLines: 2,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
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

  //Clips
  FutureBuilder<void> showClips() {
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Skeletonizer(
            enabled: _enabledFood,
            child: gridViewClip(),
          );
        } else {
          return Skeletonizer(
            enabled: _enabledFood,
            child: gridViewClip(),
          );
        }

        // return (snapshot.hasData)
        //     ? Skeletonizer(
        //         enabled: true,
        //         child: gridViewClip(),
        //       )
        //     : gridViewClip();
      },
    );
  }

  GridView gridViewClip() {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisExtent: 230,
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
                // pushNewScreen(
                //   context,
                //   screen: ClipEditCoachPage(icpId: listClips.icpId),
                //   withNavBar: true,
                // );
                Get.to(() => ClipEditCoachPage(icpId: listClips.icpId) );
              },
              child: Column(
                children: [
                  Stack(
                    children: [
                      if (listClips.video != '') ...{
                        AspectRatio(
                            aspectRatio: 16 / 13,
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                              ),
                              child: VideoItem(
                                video: listClips.video,
                              ),
                            )),
                      } else
                        AspectRatio(
                            aspectRatio: 16 / 13,
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 207, 208, 209),
                                borderRadius: BorderRadius.circular(20),
                              ),
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
                              color: Color.fromARGB(255, 93, 93, 93),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 16, top: 8),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.35,
                      child: Text(
                        listClips.name,
                        maxLines: 2,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
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
      Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
        setState(() {
          _enabledFood = false;
        });
      });
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadClipData() async {
    try {
      var datas =
          await _listClipService.listClips(icpID: '', cid: cid, name: '');
      clips = datas.data;
      Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
        setState(() {
          _enabledFood = false;
        });
      });
    } catch (err) {
      log('Error: $err');
    }
  }

  //Dialog Delete
  void dialogDeleteFood(BuildContext context, String ifid) {
    //target widget
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _listfoodService.deleteListFood(ifid);
        modelResult = response.data;
        log(modelResult.result);
        setState(() {
          loadFoodDataMethod = loadFoodData();
        });

        Navigator.of(context, rootNavigator: true).pop();
        log('onConfirmBtnTap');
      },
    );
  }

  void dialogDeleteClip(BuildContext context, String iCpid) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'Do you want to delete?',
      confirmBtnText: 'Yes',
      cancelBtnText: 'No',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _listClipService.deleteListClip(iCpid);
        modelResult = response.data;
        log(modelResult.result);
        setState(() {
          loadClipDataMethod = loadClipData();
        });

        Navigator.of(context, rootNavigator: true).pop();
        log('onConfirmBtnTap');
      },
    );
  }
}
