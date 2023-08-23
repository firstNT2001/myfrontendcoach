import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/food_get_res.dart';

import 'package:frontendfluttercoach/service/clip.dart';
import 'package:get/get.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:msh_checkbox/msh_checkbox.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/request/food_foodID_put.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../model/response/md_ClipList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';

import '../../../../widget/dialogs.dart';
import '../../../../widget/dropdown/wg_dropdown_string.dart';
import '../../../../widget/image_video.dart';
import '../../../../widget/notificationBody.dart';
import '../../../../widget/showCilp.dart';
import '../../../../widget/wg_editFood_Dialog.dart';
import 'clipCourse/editClip/clip_edit_select.dart';
import 'clipCourse/insertClip/clip_select_page.dart';
import 'foodCourse/insertFood/food_new_page.dart';
import 'package:slide_popup_dialog_null_safety/slide_popup_dialog.dart'
    as slideDialog;

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
  late VideoPlayerController _videoPlayerController;

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

  var yesNo = TextEditingController();

  //Title
  String title = "";

  bool isVisibleQuickAlert = true;

  //มืออาหาร
  final selectedValuehand = TextEditingController();
  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];
  @override
  void dispose() {
    //textEditingController.dispose();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    log(widget.did);
    context.read<AppData>().sequence = widget.sequence;
    _videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(''))
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
    // _customVideoPlayerController = CustomVideoPlayerController(
    //   context: context,
    //   videoPlayerController: _videoPlayerController,
    // );;
    //Food
    _foodService = context.read<AppData>().foodServices;
    loadFoodDataMethod = loadFoodData();

    //Clip
    _clipService = context.read<AppData>().clipServices;
    loadClipDataMethod = loadClipData();

    title = "วันที่ ${widget.sequence}";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          floatingActionButton: SpeedDial(
            backgroundColor: Theme.of(context).colorScheme.primary,
            visible: widget.isVisible,
            animatedIcon: AnimatedIcons.menu_close,
            foregroundColor: Colors.white,
            overlayOpacity: 0.4,
            children: [
              SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.bowlFood),
                  label: 'เพิ่มเมนู',
                  onTap: () {
                    Get.to(() => FoodNewCoursePage(
                          did: widget.did,
                          isVisible: widget.isVisible,
                        ))?.then((value) {
                      setState(() {
                        loadFoodDataMethod = loadFoodData();
                      });
                    });
                  }),
              SpeedDialChild(
                  child: const Icon(FontAwesomeIcons.dumbbell),
                  label: 'เพิ่มคลิป',
                  onTap: () {
                    Get.to(() => ClipSelectPage(
                          did: widget.did,
                          isVisible: widget.isVisible,
                        ))?.then((value) {
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
                    //Clip
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          loadFoodDataMethod = loadFoodData();
                          loadClipDataMethod = loadClipData();
                        });
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          // ignore: prefer_is_empty

                          Expanded(
                            child: showClip(),
                          )
                        ],
                      ),
                    ),
                    //Food
                    RefreshIndicator(
                      onRefresh: () async {
                        setState(() {
                          loadFoodDataMethod = loadFoodData();
                          loadClipDataMethod = loadClipData();
                        });
                      },
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Expanded(
                            child: showFood(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
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
            Padding(
              padding: const EdgeInsets.only(left: 15, top: 30),
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
              padding: const EdgeInsets.only(left: 15, top: 0),
              child: Text("วันที่ ${widget.sequence}",
                  style: const TextStyle(
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

                            tabs: const [
                              Tab(
                                icon: Icon(
                                  FontAwesomeIcons.dumbbell,
                                ),
                              ),
                              Tab(
                                icon: Icon(
                                  FontAwesomeIcons.utensils,
                                ),
                              ),
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
          return Center(child: load(context));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return (widget.isVisible)
                  ? Slidable(
                      endActionPane:
                          ActionPane(motion: const StretchMotion(), children: [
                        SlidableAction(
                          onPressed: (contexts) {
                            dialogDeleteFood(context, listfood.fid.toString());
                            // Navigator.pop(context);
                          },
                          backgroundColor: Theme.of(context).colorScheme.error,
                          icon: Icons.delete,
                          label: 'Delete',
                        )
                      ]),
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
                          child: cardFood(context, listfood)),
                    )
                  : cardFood(context, listfood);
            },
          );
        }
      },
    );
  }

  Column cardFood(BuildContext contexts, ModelFood listfood) {
    return Column(
      children: [
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.17,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (listfood.listFood.image != '') ...{
                Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(60), // Image radius
                          child: Image.network(listfood.listFood.image,
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
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                            size: const Size.fromRadius(60), // Image radius
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xff7c94b6),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            )),
                      ),
                    )),
              const SizedBox(width: 30),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: Text(
                      listfood.listFood.name,
                      maxLines: 5,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 40,
                    decoration: BoxDecoration(
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                              color: Colors.grey,
                              blurRadius: 2.0,
                              offset: Offset(0.0, 0.75))
                        ],
                        color: const Color.fromRGBO(244, 243, 243, 1),
                        borderRadius: BorderRadius.circular(30)),
                    child: (widget.isVisible == true)
                        ? TextButton(
                            onPressed: () {
                              //dialogFoodEditMealInCourse(contexts, listfood);
                              dialogFoodEditMealInCourse(listfood);
                            },
                            child: Text(
                              listfood.time == '1'
                                  ? 'มื้อเช้า'
                                  : listfood.time == '2'
                                      ? 'มื้อเที่ยง'
                                      : listfood.time == '3'
                                          ? 'มื้อเย็น'
                                          : 'มื้อใดก็ได้',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          )
                        : Center(
                            child: Text(
                              listfood.time == '1'
                                  ? 'มื้อเช้า'
                                  : listfood.time == '2'
                                      ? 'มื้อเที่ยง'
                                      : listfood.time == '3'
                                          ? 'มื้อเย็น'
                                          : 'มื้อใดก็ได้',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                  ),
                  if (widget.isVisible == false) ...{const SizedBox(width: 60)},
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        const Divider(
          endIndent: 15,
          indent: 15,
        ),
      ],
    );
  }

  void dialogFoodEditMealInCourse(ModelFood listfood) {
    if (listfood.time == '1') {
      selectedValuehand.text = 'มื้อเช้า';
    } else if (listfood.time == '2') {
      selectedValuehand.text = 'มื้อเที่ยง';
    } else if (listfood.time == '3') {
      selectedValuehand.text = 'มื้อเย็น';
    }

    slideDialog.showSlideDialog(
        context: context,
        backgroundColor: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, bottom: 20),
                child: Text(listfood.listFood.name,
                    style: Theme.of(context).textTheme.titleLarge),
              ),
              Row(
                children: [
                  Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20), // Image border
                        child: SizedBox.fromSize(
                          size: const Size.fromRadius(60), // Image radius
                          child: Image.network(listfood.listFood.image,
                              fit: BoxFit.cover),
                        ),
                      )),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: WidgetDropdownString(
                        title: 'เลือกมืออาหาร',
                        selectedValue: selectedValuehand,
                        listItems: listhand,
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Text(listfood.listFood.details,
                    maxLines: 5, style: Theme.of(context).textTheme.bodyLarge),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: FilledButton(
                        onPressed: () async {
                          FoodFoodIdPut foodFoodIdPut = FoodFoodIdPut(
                            listFoodId: listfood.listFood.ifid,
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
                              listfood.fid.toString(), foodFoodIdPut);
                          modelResult = response.data;
                          log(modelResult.result);

                          Navigator.of(context, rootNavigator: true).pop();

                          if (modelResult.result == '1') {
                            // ignore: use_build_context_synchronously
                            InAppNotification.show(
                              child: NotificationBody(
                                count: 1,
                                message: 'แก้ไขมื้ออาหารสำเร็ส',
                              ),
                              context: context,
                              onTap: () => print('Notification tapped!'),
                              duration: const Duration(milliseconds: 1500),
                            );
                            setState(() {
                              loadFoodDataMethod = loadFoodData();
                            });
                          } else {
                            InAppNotification.show(
                              child: NotificationBody(
                                count: 1,
                                message:
                                    'เป็น ${selectedValuehand.text} อยู่แล้ว',
                              ),
                              context: context,
                              onTap: () => print('Notification tapped!'),
                              duration: const Duration(milliseconds: 1500),
                            );
                          }
                        },
                        child: const Text("บันทึก")),
                  ),
                ],
              )
            ],
          ),
        ));
  }

  //Dialog Delete
  void dialogDeleteFood(BuildContext context, String fid) {
    //target widget
    QuickAlert.show(
      context: context,
      barrierDismissible: isVisibleQuickAlert,
      type: QuickAlertType.confirm,
      text: 'ต้อกการลบเมนูอาหารหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _foodService.deleteFood(fid);
        modelResult = response.data;
        log(modelResult.result);

        setState(() {
          loadFoodDataMethod = loadFoodData();
        });
        Navigator.of(context, rootNavigator: true).pop();
        if (modelResult.result == '1') {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบเมนูอาหารสำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        } else {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบเมนูอาหารไม่สำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
    );
  }

  //Clip
  Widget showClip() {
    return FutureBuilder(
      future: loadClipDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return Column(
            children: [
              GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisExtent: 230,
                ),
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index) {
                  final listClip = clips[index];
                  return SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
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
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              if (listClip.listClip.video != '') ...{
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 5, bottom: 5),
                                  child: AspectRatio(
                                      aspectRatio: 16 / 13,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(26),
                                        ),
                                        child: VideoItem(
                                          video: listClip.listClip.video,
                                        ),
                                      )),
                                )
                              } else
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 5, bottom: 5),
                                  child: AspectRatio(
                                      aspectRatio: 16 / 13,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              255, 207, 208, 209),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      )),
                                ),
                              Visibility(
                                visible: widget.isVisible,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        dialogDeleteClip(
                                            context, listClip.cpId.toString());
                                      },
                                      icon: Icon(
                                        FontAwesomeIcons.trash,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.isVisible == false) ...{
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      MSHCheckbox(
                                        size: 30,
                                        value: listClip.status == '1'
                                            ? true
                                            : listClip.status == '0'
                                                ? false
                                                : false,
                                        colorConfig: MSHColorConfig
                                            .fromCheckedUncheckedDisabled(
                                          checkedColor: Colors.blue,
                                        ),
                                        style: MSHCheckboxStyle.fillFade,
                                        onChanged: (selected) {
                                          setState(() {
                                            //isChecked = selected;
                                          });
                                        },
                                      ),
                                    ])
                              }
                            ],
                          ),
                          Center(
                            child: SizedBox(
                              child: AutoSizeText(
                                listClip.listClip.name,
                                maxLines: 2,
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
                  );
                },
              ),
            ],
          );
        }
      },
    );
  }

  void dialogDeleteClip(BuildContext context, String cpid) {
    //target widget
    QuickAlert.show(
      context: context,
      barrierDismissible: isVisibleQuickAlert,
      type: QuickAlertType.confirm,
      text: 'ต้องการลบคลิปหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        var response = await _clipService.deleteClip(cpid);
        modelResult = response.data;
        log(modelResult.result);
        setState(() {
          loadClipDataMethod = loadClipData();
        });

        Navigator.of(context, rootNavigator: true).pop();
        if (modelResult.result == '1') {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบคลิปท่าออกกำลังกายสำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        } else {
          // ignore: use_build_context_synchronously
          InAppNotification.show(
            child: NotificationBody(
              count: 1,
              message: 'ลบคลิปท่าออกกำลังกายไม่สำเร็จ',
            ),
            context: context,
            onTap: () => print('Notification tapped!'),
            duration: const Duration(milliseconds: 1500),
          );
        }
      },
    );
  }

  void dialogClipEditInCourse(BuildContext context, ListClip listClip,
      String cpID, String did, String sequence, int status, bool isVisible) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        //alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 50, bottom: 0),
                  child: Text("คลิปท่าออกกำลังกาย",
                      style: Theme.of(context).textTheme.headlineSmall),
                ),
              ),
              if (listClip.video != '') ...{
                WidgetShowCilp(
                  urlVideo: listClip.video,
                ),
              } else ...{
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.3,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Theme.of(context).colorScheme.primary)),
                const SizedBox(
                  height: 8,
                ),
              },
              Padding(
                padding: const EdgeInsets.only(
                    top: 20, bottom: 8, right: 20, left: 20),
                child: Text(
                  'ชื่อคลิปxx ${listClip.name}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
                child: Text(
                  'รายละเอียด ${listClip.details}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
                child: Text(
                  'จำนวนเซต ${listClip.amountPerSet.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                //MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 20),
                    child: FilledButton(
                        onPressed: () {
                          SmartDialog.dismiss();
                          Get.to(() => ClipEditSelectPage(
                                cpID: cpID,
                                did: did,
                                sequence: sequence,
                                status: status,
                                isVisible: isVisible,
                              ));
                        },
                        child: const Text('เปลี่ยนคลิป')),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
