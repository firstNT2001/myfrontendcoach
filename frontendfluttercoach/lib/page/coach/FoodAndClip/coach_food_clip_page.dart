import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../model/response/md_ClipList_get.dart';
import '../../../model/response/md_FoodList_get.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/listClip.dart';
import '../../../service/listFood.dart';
import '../../../service/provider/appdata.dart';

import '../../../widget/dialogs.dart';
import '../../../widget/image_video.dart';
import '../../../widget/notificationBody.dart';
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
  // ignore: unused_field

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
            foregroundColor: Colors.white,
            children: [
              SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.bowlFood),
                  label: 'เพิ่มเมนู',
                  onTap: () {
                    Get.to(() => const FoodNewCoachPage())?.then((value) {
                      setState(() {
                        loadFoodDataMethod = loadFoodData();
                      });
                    });
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
                    Get.to(() => const ClipNewCoachPage())?.then((value) {
                      setState(() {
                        loadClipDataMethod = loadClipData();
                      });
                    });
                  }),
            ],
          ),
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              showAppBar(context),
              Expanded(
                child: TabBarView(
                  children: [
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        searchFood(context),
                        Expanded(
                          child: RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  loadFoodDataMethod = loadFoodData();
                                  loadClipDataMethod = loadClipData();
                                });
                              },
                              child: showFood()),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        searchClip(context),
                        Expanded(
                          child: RefreshIndicator(
                              onRefresh: () async {
                                setState(() {
                                  loadFoodDataMethod = loadFoodData();
                                  loadClipDataMethod = loadClipData();
                                });
                              },
                              child: showClips()),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          )),
    );
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
                Color.fromARGB(227, 84, 84, 84),
                Color.fromARGB(227, 84, 84, 84),
                Color.fromARGB(227, 84, 84, 84),
              ])),
              height: 150,
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
                child: Padding(
              padding: EdgeInsets.only(left: 15, top: 70),
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

  Padding searchClip(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          pushNewScreen(
            context,
            screen: const SearchClipCoachPage(),
            withNavBar: true,
          ).then((value) {
            log('ponds');
            setState(() {
              loadClipDataMethod = loadClipData();
            });
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 243, 244),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: const SearchClipCoachPage(),
                      withNavBar: true,
                    ).then((value) {
                      log('ponds');
                      setState(() {
                        loadClipDataMethod = loadClipData();
                      });
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.grey,
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
          pushNewScreen(
            context,
            screen: const SearchFoodCoachPage(),
            withNavBar: true,
          ).then((value) {
            log('ponds');
            setState(() {
              loadFoodDataMethod = loadFoodData();
            });
          });
        },
        child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 243, 243, 244),
              borderRadius: BorderRadius.circular(15),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0,
                    offset: Offset(0.0, 0.75))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                TextButton.icon(
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: const SearchFoodCoachPage(),
                      withNavBar: true,
                    ).then((value) {
                      log('ponds');
                      setState(() {
                        loadFoodDataMethod = loadFoodData();
                      });
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.grey,
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
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return gridViewFood();
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
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: InkWell(
            onTap: () {
              Get.to(() => FoodEditCoachPage(ifid: listfood.ifid))!
                  .then((value) {
                setState(() {
                  loadFoodDataMethod = loadFoodData();
                });
              });
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
                            dialogDeleteFood(context, listfood.ifid.toString());
                          },
                          icon: Icon(
                            FontAwesomeIcons.trash,
                            color: Theme.of(context).colorScheme.primary,
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
        );
      },
    );
  }

  //Clips
  FutureBuilder<void> showClips() {
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return gridViewClip();
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
          padding: const EdgeInsets.only(right: 8, left: 8),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: InkWell(
              onTap: () {
                // pushNewScreen(
                //   context,
                //   screen: ClipEditCoachPage(icpId: listClips.icpId),
                //   withNavBar: true,
                // );
                Get.to(() => ClipEditCoachPage(icpId: listClips.icpId))!.then((value) {
                  setState(() {
                        loadClipDataMethod = loadClipData();

                  });
                });
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
                            icon: Icon(
                              FontAwesomeIcons.trash,
                              color: Theme.of(context).colorScheme.primary,
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
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'ต้องการลบเมนูอาหารหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
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
        // ignore: use_build_context_synchronously
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'ลบเมนูอาหารเรียบร้อยแล้ว',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
      },
    );
  }

  void dialogDeleteClip(BuildContext context, String iCpid) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'ต้องการลบคลิปหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _listClipService.deleteListClip(iCpid);
        modelResult = response.data;
        log(modelResult.result);
        setState(() {
          loadClipDataMethod = loadClipData();
        });

        Navigator.of(context, rootNavigator: true).pop();
        // ignore: use_build_context_synchronously
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'ลบคลิปท่าออกกำลังกายเรียบร้อยแล้ว',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
      },
    );
  }
}
