import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/food_get_res.dart';

import 'package:frontendfluttercoach/service/clip.dart';
import 'package:get/get.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';

import '../../../../model/request/food_foodID_put.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../model/response/md_ClipList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';

import '../../../../widget/dropdown/wg_dropdown_string.dart';
import '../../../../widget/wg_editClip_Dialog.dart';
import '../../../../widget/wg_editFood_Dialog.dart';
import '../../../../widget/wg_search_food.dart';
import 'clipCourse/insertClip/clip_select_page.dart';
import 'foodCourse/insertFood/food_new_page.dart';

class HomeFoodAndClipPage extends StatefulWidget {
  const HomeFoodAndClipPage(
      {super.key,
      required this.did,
      required this.sequence,
      required this.isVisible});

  final String did;
  final String sequence;
  final bool isVisible;

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
  late ClipServices _clipService;
  List<ModelClip> clips = [];

  late ModelResult modelResult;

  //onoffShow
  bool onVisibles = true;
  bool offVisibles = false;

  ///SearchBar
  var searchName = TextEditingController();

  //Title
  String title = "";

  //มืออาหาร
  final selectedValuehand = TextEditingController();
  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];
  @override
  void initState() {
    super.initState();
    log(widget.did);
    context.read<AppData>().sequence = widget.sequence;

    //Food
    _foodService = context.read<AppData>().foodServices;
    loadFoodDataMethod = loadFoodData();

    //Clip
    _clipService = context.read<AppData>().clipServices;
    loadClipDataMethod = loadClipData();

    title = "Day ${widget.sequence}";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: SpeedDial(
            visible: widget.isVisible,
            animatedIcon: AnimatedIcons.menu_close,
            overlayOpacity: 0.4,
            children: [
              SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.bowlFood),
                  label: 'เพิ่มเมนู',
                  onTap: () {
                    Get.to(() => FoodNewCoursePage(
                          did: widget.did,
                          isVisible: widget.isVisible,
                        ));
                  }),
              SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.dumbbell),
                  label: 'เพิ่มคลิป',
                  onTap: () {
                    Get.to(() => ClipSelectPage(
                          did: widget.did,
                          isVisible: widget.isVisible,
                        ));
                  }),
            ],
          ),
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            title: Text(
              title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            leading: IconButton(
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
              ),
              onPressed: () {
                Get.back();
              },
            ),
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
                  searchButter(context),
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

  Padding searchButter(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Get.to(() => WidgetSearchFood(
                searchName: searchName,
                did: widget.did,
                sequence: widget.sequence,
                isVisible: widget.isVisible,
              ));
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
                    Get.to(() => WidgetSearchFood(
                          searchName: searchName,
                          did: widget.did,
                          sequence: widget.sequence,
                          isVisible: widget.isVisible,
                        ));
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

  //LoadData
  Future<void> loadFoodData() async {
    try {
      // log(widget.did);
      var datas = await _foodService.foods(
          fid: '', ifid: '', did: widget.did, name: '');
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Future<void> loadClipData() async {
    try {
      log('message');
      log(widget.did);
      var datas =
          await _clipService.clips(cpID: '', icpID: '', did: widget.did);
      clips = datas.data;
      // log(clips.length.toString());
    } catch (err) {
      var e = err as DioError;
      log(e.response!.data.toString());
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
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      dialogFoodEditInCourse(
                          context,
                          listfood.listFood.image,
                          listfood.listFood.name,
                          listfood.time,
                          listfood.fid.toString(),
                          listfood.dayOfCouseId.toString(),
                          widget.sequence,
                          widget.isVisible);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ignore: unnecessary_null_comparison
                        if (listfood.listFood.image != '') ...{
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20), // Image border
                                  child: SizedBox.fromSize(
                                    size: const Size.fromRadius(
                                        48), // Image radius
                                    child: Image.network(
                                        listfood.listFood.image,
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              )),
                        } else
                          Padding(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 5, bottom: 5),
                              child: Center(
                                child: ClipRRect(
                                  borderRadius:
                                      BorderRadius.circular(20), // Image border
                                  child: SizedBox.fromSize(
                                      size: const Size.fromRadius(
                                          48), // Image radius
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xff7c94b6),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      )),
                                ),
                              )),
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
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      boxShadow: const <BoxShadow>[
                                        BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5.0,
                                            offset: Offset(0.0, 0.75))
                                      ],
                                      color: const Color.fromRGBO(
                                          244, 243, 243, 1),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: TextButton(
                                    onPressed: () {
                                      if (widget.isVisible == true) {
                                        dialogFoodEditMealInCourse(
                                            context,
                                            listfood.listFood.ifid,
                                            listfood.listFood.name,
                                            listfood.listFood.image,
                                            listfood.listFood.calories,
                                            listfood.time,
                                            listfood.fid.toString());
                                      }
                                    },
                                    child: Text(
                                      listfood.time == '1'
                                          ? 'มื้อเช้า'
                                          : listfood.time == '2'
                                              ? 'มื้อเที่ยง'
                                              : listfood.time == '3'
                                                  ? 'มื้อเย็น'
                                                  : 'มื้อใดก็ได้',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ),
                                ),
                                if (widget.isVisible == false) ...{
                                  const SizedBox(width: 60)
                                },
                                Visibility(
                                  visible: widget.isVisible,
                                  child: Column(
                                    children: [
                                      const SizedBox(width: 20),
                                      IconButton(
                                        onPressed: () {
                                          dialogDeleteFood(
                                              context, listfood.fid.toString());
                                        },
                                        icon: const Icon(
                                          FontAwesomeIcons.trash,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
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

  void dialogFoodEditMealInCourse(BuildContext context, int ifid, String name,
      String img, int cal, String meal, String fid) {
    if (meal == '1') {
      selectedValuehand.text = 'มื้อเช้า';
    } else if (meal == '2') {
      selectedValuehand.text = 'มื้อเที่ยง';
    } else if (meal == '3') {
      selectedValuehand.text = 'มื้อเย็น';
    }
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.43,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20)),
            color: Colors.white,
          ),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child:
                    Text(name, style: Theme.of(context).textTheme.titleLarge),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(60), // Image radius
                          child: Image.network(img, fit: BoxFit.cover),
                        ),
                      )),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('แคลอรี่ $cal',
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 60,
                        width: 150,
                        child: WidgetDropdownString(
                          title: 'เลือกมืออาหาร',
                          selectedValue: selectedValuehand,
                          listItems: listhand,
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(
                indent: 20,
                endIndent: 20,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: ElevatedButton(
                        onPressed: () async {
                          log(fid.toString());
                          FoodFoodIdPut foodFoodIdPut = FoodFoodIdPut(
                            listFoodId: ifid,
                            time: selectedValuehand.text == 'มื้อเช้า'
                                ? '1'
                                : selectedValuehand.text == 'มื้อเที่ยง'
                                    ? '2'
                                    : selectedValuehand.text == 'มื้อเย็น'
                                        ? '3'
                                        : '',
                            dayOfCouseId: int.parse(widget.did),
                          );
                          log(jsonEncode(foodFoodIdPut));
                          var response = await _foodService.updateFoodByFoodID(
                              fid, foodFoodIdPut);
                          modelResult = response.data;
                          log(modelResult.result);
                          if (modelResult.result == '1') {
                            SmartDialog.dismiss();
                            setState(() {
                              loadFoodDataMethod = loadFoodData();
                            });
                          } else {
                            // ignore: use_build_context_synchronously
                            CherryToast.warning(
                              title: Text(
                                  'เป็น ${selectedValuehand.text} อยู่แล้ว'),
                              displayTitle: false,
                              description: Text(
                                  'เป็น ${selectedValuehand.text} อยู่แล้ว'),
                              toastPosition: Position.bottom,
                              animationDuration:
                                  const Duration(milliseconds: 1000),
                              autoDismiss: true,
                            ).show(context);
                          }
                        },
                        child: const Text("บันทึก")),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  //Dialog Delete
  void dialogDeleteFood(BuildContext context, String fid) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.3,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
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
                      child: const Text("ยกเลิก")),
                  FilledButton(
                      onPressed: () async {
                        var response = await _foodService.deleteFood(fid);
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

  //Clip
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
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      ListClip request = ListClip(
                          icpId: listClip.listClip.icpId,
                          coachId: listClip.listClip.coachId,
                          name: listClip.listClip.name,
                          video: listClip.listClip.video,
                          details: listClip.listClip.details,
                          amountPerSet: listClip.listClip.amountPerSet);
                      log(listClip.cpId.toString());
                      dialogClipEditInCourse(
                          context,
                          request,
                          listClip.cpId.toString(),
                          listClip.dayOfCouseId.toString(),
                          widget.sequence,
                          int.parse(listClip.status),
                          widget.isVisible);
                    },
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        // const SizedBox(
                        //   width: 50,
                        // ),
                        if (widget.isVisible == false) ...{
                          Center(
                            child: MSHCheckbox(
                              size: 30,
                              value: listClip.status == '1'
                                ? true
                                : listClip.status == '0'
                                    ? false
                                        : false,
                              colorConfig:
                                  MSHColorConfig.fromCheckedUncheckedDisabled(
                                checkedColor: Colors.blue,
                              ),
                              style: MSHCheckboxStyle.fillFade,
                              onChanged: (selected) {
                                setState(() {
                                  //isChecked = selected;
                                });
                              },
                            ),
                          )
                        }
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
}
