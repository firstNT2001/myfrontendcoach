import 'dart:convert';
import 'dart:developer';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/food_foodID_put.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/food_get_res.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/wg_dropdownFood_coach.dart';
import '../../../../widget/wg_dropdown_string.dart';
import '../../home_foodAndClip.dart';

class EditFoodPage extends StatefulWidget {
  EditFoodPage(
      {super.key,
      required this.fid,
      required this.did,
      required this.sequence,
      required this.coID});
  late String fid;
  late String did;
  late String sequence;
  late String coID;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  //FoodService
  ///FoodCourses
  late Future<void> loadFoodCoursesDataMethod;
  late FoodServices _foodCourseService;
  List<ModelFood> foodCourses = [];

  ///deleteFood
  late ModelResult modelResult;

  //UpdateFood
  int ifid = 0;
  String time = "";

  ///FoodCoach
  late Future<void> loadFoodCoachDataMethod;
  late ListFoodServices _foodCoachService;
  List<ModelFoodList> foodCoachs = [];

  //selectFood
  final selectedValueFood = TextEditingController();
  int numberFoods = 0;
  List<String> listFoodString = [];

  //มืออาหาร
  final selectedValuehand = TextEditingController();
  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];

  //CoachID
  String cid = '';
  @override
  void initState() {
    cid = context.read<AppData>().cid.toString();
    //FoodCoach
    _foodCoachService = context.read<AppData>().listfoodServices;

    //FoodCourses
    _foodCourseService = context.read<AppData>().foodServices;
    loadFoodCoursesDataMethod = loadFoodData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.white,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.trash,
            ),
            onPressed: () async {
              var response = await _foodCourseService.deleteFood(widget.fid);
              modelResult = response.data;
              if (modelResult.result == '1') {
                // ignore: use_build_context_synchronously
                // CherryToast.success(
                //   title: const Text('ลบสำเร็จ'),
                //   displayTitle: false,
                //   description: const Text('ลบสำเร็จ'),
                //   toastPosition: Position.bottom,
                //   animationDuration: const Duration(milliseconds: 1000),
                //   autoDismiss: true,
                //   actionHandler: () {},
                // ).show(context);
                // Get.back();

                Get.to(() => HomeFoodAndClipPage(
                      did: widget.did,
                      sequence: widget.sequence,
                    ));
              } else {
                // ignore: use_build_context_synchronously
                CherryToast.warning(
                  title: const Text('ลบไม่สำเร็จ'),
                  displayTitle: false,
                  description: const Text('ลบไม่สำเร็จ'),
                  toastPosition: Position.bottom,
                  animationDuration: const Duration(milliseconds: 1000),
                  autoDismiss: true,
                ).show(context);
              }
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('หน้าแก้ไขเมนูอาหาร'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18, top: 8),
            child: showFood(),
          )
        ],
      )),
    );
  }

  //loodDataFoodinCourse
  Future<void> loadFoodData() async {
    try {
      //foodCourse
      var foodCoursedatas = await _foodCourseService.foods(
          fid: widget.fid, ifid: '', did: '', name: '');
      foodCourses = foodCoursedatas.data;
      if (foodCourses.first.time == '1') {
        selectedValuehand.text = 'มื้อเช้า';
      } else if (foodCourses.first.time == '2') {
        selectedValuehand.text = 'มื้อเที่ยง';
      } else if (foodCourses.first.time == '3') {
        selectedValuehand.text = 'มื้อเย็น';
      }

      //foodCoach
      var foodCoachdatas =
          await _foodCoachService.listFoods(ifid: '', cid: cid, name: '');
      foodCoachs = foodCoachdatas.data;

      listFoodString = foodCoachs.map((foodCoachs) => foodCoachs.name).toList();

      for (var ss in listFoodString) {
        log("อาหาร: $ss");
      }
      //loop หาชื่อเมนูอาหารว่าชื่อนั้นอยู่ใน อาเรที่เท่าไหร่ เพื่อไปแสดงใน WidgetDropdownFoodInCoach
      for (var i = 0; i < foodCoachs.length; i++) {
        if (foodCoachs[i].name == foodCourses.first.listFood.name) {
          selectedValueFood.text = foodCoachs[i].name;
          numberFoods = i;
          break;
        }
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data

  Widget showFood() {
    return FutureBuilder(
      future: loadFoodCoursesDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(children: [
            //Text(foodCourses.first.listFood.name),
            Container(
              width: double.infinity,
              height: 200,
              color: Colors.black38,
              child: const Center(child: Text('รูป')),
            ),
            const SizedBox(
              height: 18,
            ),
            WidgetDropdownFoodInCoach(
              selectedValue: selectedValueFood,
              ModelfoodCoachs: listFoodString,
              numberFoods: numberFoods,
            ),
            const SizedBox(
              height: 18,
            ),
            WidgetDropdownString(
              title: 'เลือกมืออาหาร',
              selectedValue: selectedValuehand,
              ListItems: listhand,
            ),
            const SizedBox(
              height: 18,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      log(selectedValueFood.text);

                      log(selectedValuehand.text);
                      if (selectedValuehand.text == 'มื้อเช้า') {
                        time = '1';
                      } else if (selectedValuehand.text == 'มื้อเที่ยง') {
                        time = '2';
                      } else {
                        time = '3';
                      }
                      for (var i = 0; i < foodCoachs.length; i++) {
                        if (foodCoachs[i].name == selectedValueFood.text) {
                          ifid = foodCoachs[i].ifid;

                          break;
                        }
                      }
                      FoodFoodIdPut foodFoodIdPut =
                          FoodFoodIdPut(listFoodId: ifid, time: time);
                      log(jsonEncode(foodFoodIdPut));
                      var response = await _foodCourseService
                          .updateFoodByFoodID(widget.fid, foodFoodIdPut);
                      modelResult = response.data;
                      log(modelResult.result);
                      if (modelResult.result == '1') {
                        // ignore: use_build_context_synchronously
                        // CherryToast.success(
                        //   title: const Text('บันทึกสำเร็จ'),
                        //   displayTitle: false,
                        //   description: const Text('บันทึกสำเร็จ'),
                        //   toastPosition: Position.bottom,
                        //   animationDuration: const Duration(milliseconds: 1000),
                        //   autoDismiss: true,
                        //   actionHandler: () {},
                        // ).show(context);
                        //Navigator.pop(context);
                        Get.to(() => HomeFoodAndClipPage(
                              did: widget.did,
                              sequence: widget.sequence,
                            ));
                      } else {
                        // ignore: use_build_context_synchronously
                        CherryToast.warning(
                          title: const Text('บันทึกไม่สำเร็จ'),
                          displayTitle: false,
                          description: const Text('บันทึกไม่สำเร็จ'),
                          toastPosition: Position.bottom,
                          animationDuration: const Duration(milliseconds: 1000),
                          autoDismiss: true,
                        ).show(context);
                      }
                    },
                    child: const Text('บันทีก')),
              ],
            )
          ]);
        }
      },
    );
  }
}
