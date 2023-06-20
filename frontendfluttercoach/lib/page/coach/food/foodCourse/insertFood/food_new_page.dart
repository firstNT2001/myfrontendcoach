import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../model/request/food_dayID_post.dart';
import '../../../../../service/provider/appdata.dart';
import '../../../../../widget/wg_dropdown_string.dart';
import '../../../home_foodAndClip.dart';
import 'food_select_time_page.dart';

class FoodNewCoursePage extends StatefulWidget {
  FoodNewCoursePage({super.key, required this.did});
  late String did;

  @override
  State<FoodNewCoursePage> createState() => _FoodNewCoursePageState();
}

class _FoodNewCoursePageState extends State<FoodNewCoursePage> {
  // FoodService
  late Future<void> loadListFoodDataMethod;
  late ListFoodServices _listFoodService;
  List<ModelFoodList> listFoods = [];

  //Color
  List<Color> colorFood = [];

  //ListIncrease
  List<ModelFoodList> increaseFood = [];
  List<FoodDayIdPost> increaseFoodDay = [];
  //มืออาหาร
  final selectedValuehand = TextEditingController();
  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];

  @override
  void initState() {
    super.initState();
    selectedValuehand.text = 'มื้อเช้า';
    _listFoodService = context.read<AppData>().listfoodServices;
    loadListFoodDataMethod = loadListFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
            onPressed: () {
              Get.to(() => HomeFoodAndClipPage(
                    did: widget.did,
                    sequence: context.read<AppData>().sequence,
                  ));
            },
          ),
          actions: [
            badges.Badge(
              position: badges.BadgePosition.topEnd(top: -7, end: 5),
              showBadge: true,
              ignorePointer: false,
              badgeAnimation: const BadgeAnimation.slide(
                toAnimate: true,
                animationDuration: Duration(seconds: 0),
              ),
              badgeContent: Row(
                children: [
                  if (increaseFood.isNotEmpty)
                    Text(
                      increaseFood.length.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
              badgeStyle: badges.BadgeStyle(
                //shape: badges.BadgeShape.square,
                badgeColor: Theme.of(context).colorScheme.error,
                borderSide: const BorderSide(color: Colors.white, width: 2),
                elevation: 0,
              ),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.angleRight,
                  color: Colors.black,
                ),
                onPressed: () {
                  if (increaseFood.isNotEmpty) {
                    Get.to(() => FoodSelectTimePage(
                          did: widget.did,
                          modelFoodList: increaseFood,
                          increaseFood: increaseFoodDay,
                        ));
                  }
                },
              ),
            )
          ],
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text('เลือกเมนูอาหาร'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showFood(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  //LoadData
  Future<void> loadListFoodData() async {
    try {
      var datas = await _listFoodService.listFoods(
          ifid: '', cid: context.read<AppData>().cid.toString(), name: '');
      listFoods = datas.data;
      // ignore: unused_local_variable
      for (var index in listFoods) {
        colorFood.add(Colors.white);
      }
      log("image${listFoods[2].image}");
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood() {
    return FutureBuilder(
      future: loadListFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listFoods.length,
            itemBuilder: (context, index) {
              final listFood = listFoods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  color: colorFood[index],
                  child: InkWell(
                    onTap: () {
                      if (colorFood[index] != Colors.black12) {
                        setState(() {
                          // เพิ่มเมนูอาหารนั้นเมือกกดเลือก
                          ModelFoodList request = ModelFoodList(
                              ifid: listFood.ifid,
                              name: listFood.name,
                              image: listFood.image,
                              details: listFood.details,
                              calories: listFood.calories);

                          _dialog(context, request, colorFood, index);
                          //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                          // colorFood[index] = Colors.black12;
                        });
                      } else {
                        setState(() {
                          //กลับเป็นสีเดิมเมือเลือกเมนูอาหารซํ้า
                          colorFood[index] = Colors.white;
                          //เอาเมนูอาหารที่เลือกออกจาก list model
                          increaseFood.removeWhere(
                              (item) => item.ifid == listFood.ifid);
                        });
                      }
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (listFood.image != '') ...{
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  image: DecorationImage(
                                    image: NetworkImage(listFood.image),
                                  ),
                                )),
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
                                    color: Colors.black26)),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AutoSizeText(
                                listFood.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                            const SizedBox(height: 8),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AutoSizeText(
                                'Calories: ${listFood.calories.toString()}',
                                maxLines: 5,
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
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

  void _dialog(BuildContext ctx, ModelFoodList listFood, List<Color> colorList,
      int index) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.75,
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
                  left: 20, right: 20, top: 50, bottom: 0),
              child: Text("เมนูอาหาร",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (listFood.image != '') ...{
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(26),
                    image: DecorationImage(
                      image: NetworkImage(listFood.image),
                    ),
                  )),
            } else ...{
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.black26)),
              const SizedBox(
                height: 8,
              ),
            },
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoSizeText(
                  'ชื่อเมนู: ${listFood.name}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoSizeText(
                  'รายละเอียด: ${listFood.details}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'Calories: ${listFood.calories.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    //height: MediaQuery.of(context).size.height * 0.2,
                    child: WidgetDropdownString(
                      title: 'เลือกมืออาหาร',
                      selectedValue: selectedValuehand,
                      ListItems: listhand,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          increaseFood.add(listFood);

                          FoodDayIdPost requestFoodPost = FoodDayIdPost(
                            listFoodId: listFood.ifid,
                            time: selectedValuehand.text == 'มื้อเช้า'
                                ? '1'
                                : selectedValuehand.text == 'มื้อเที่ยง'
                                    ? '2'
                                    : selectedValuehand.text == 'มื้อเย็น'
                                        ? '3'
                                        : '',
                          );
                          increaseFoodDay.add(requestFoodPost);
                          log(jsonEncode(requestFoodPost));
                          selectedValuehand.text = 'มื้อเช้า';
                          //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                          colorList[index] = Colors.black12;
                        });

                        SmartDialog.dismiss();
                      },
                      child: const Text('ยืนยัน')),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
