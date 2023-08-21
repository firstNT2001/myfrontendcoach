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
import 'package:frontendfluttercoach/widget/dropdown/wg_dropdown_notValue_string.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/request/food_dayID_post.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/PopUp/popUp.dart';
import '../../../../../../widget/dialogs.dart';
import 'food_select_time_page.dart';

class FoodNewCoursePage extends StatefulWidget {
  const FoodNewCoursePage(
      {super.key, required this.did, required this.isVisible});
  final String did;
  final bool isVisible;
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
  late ModelFoodList request;
  String textErr = '';

  @override
  void initState() {
    super.initState();

    _listFoodService = context.read<AppData>().listfoodServices;
    loadListFoodDataMethod = loadListFoodData();
    selectedValuehand.text = 'มื้อเช้า';
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false, child: scaffold(context));
  }

  Scaffold scaffold(BuildContext contexts) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
              color: Colors.black,
            ),
            onPressed: () {
              // Get.to(() => HomeFoodAndClipPage(
              //       did: widget.did,
              //       sequence: context.read<AppData>().sequence,
              //       isVisible: widget.isVisible,
              //     ));
              Get.back();
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
                      // style: const TextStyle(color: Colors.white),
                    ),
                ],
              ),
              badgeStyle: badges.BadgeStyle(
                //shape: badges.BadgeShape.square,
                badgeColor: Theme.of(context).colorScheme.primary,
                borderSide: const BorderSide(color: Colors.white, width: 2),
                elevation: 0,
              ),
              child: IconButton(
                icon: const Icon(
                  FontAwesomeIcons.cartShopping,
                ),
                onPressed: () {
                  if (increaseFood.isNotEmpty) {
                    Get.to(() => FoodSelectTimePage(
                          did: widget.did,
                          modelFoodList: increaseFood,
                          increaseFood: increaseFoodDay,
                          isVisible: widget.isVisible,
                        ));
                    log(increaseFoodDay.length.toString());
                  }
                },
              ),
            )
          ],
          backgroundColor: Colors.white,
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
                    child: showFood(contexts),
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
        // ignore: use_build_context_synchronously
        colorFood.add(context.read<AppData>().colorNotSelect);
      }
      log("image${listFoods[2].image}");
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood(BuildContext contexts) {
    return FutureBuilder(
      future: loadListFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return listViewFood(contexts);
        }
      },
    );
  }

  ListView listViewFood(BuildContext contexts) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listFoods.length,
      itemBuilder: (context, index) {
        final listFood = listFoods[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Card(
              color: colorFood[index],
              elevation: 10,
              child: InkWell(
                onTap: () {
                  if (colorFood[index] != context.read<AppData>().colorSelect) {
                    setState(() {
                      // เพิ่มเมนูอาหารนั้นเมือกกดเลือก
                      request = ModelFoodList(
                          ifid: listFood.ifid,
                          name: listFood.name,
                          image: listFood.image,
                          details: listFood.details,
                          calories: listFood.calories);

                      //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                      // colorFood[index] = Colors.black12;
                    });

                    _dialog(contexts, request, colorFood, index);
                  } else {
                    setState(() {
                      //กลับเป็นสีเดิมเมือเลือกเมนูอาหารซํ้า
                      colorFood[index] = context.read<AppData>().colorNotSelect;

                      //เอาเมนูอาหารที่เลือกออกจาก list model
                      increaseFoodDay.removeWhere(
                          (item) => item.listFoodId == listFood.ifid);

                      increaseFood
                          .removeWhere((item) => item.ifid == listFood.ifid);
                    });
                  }
                },
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (listFood.image != '') ...{
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              listFood.image,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    } else
                      Container(
                          width: MediaQuery.of(context).size.width * 0.4,
                          height: MediaQuery.of(context).size.height * 0.2,
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.white)),
                    const SizedBox(width: 10),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.5,
                          child: AutoSizeText(
                            listFood.name,
                            maxLines: 5,
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Calories : ${listFood.calories}",
                          style: Theme.of(context).textTheme.titleMedium,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _dialog(BuildContext ctx, ModelFoodList listFood, List<Color> colorList,
      int index) {
    //target widget
    SmartDialog.show(builder: (ctx) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 600,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 50, bottom: 10),
                child: Text("เมนูอาหาร",
                    style: Theme.of(context).textTheme.headlineSmall),
              ),
              if (listFood.image != '') ...{
                ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      listFood.image,
                      width: MediaQuery.of(context).size.width * 0.7,
                      height: MediaQuery.of(context).size.height * 0.2,
                      fit: BoxFit.cover,
                    )),
              } else ...{
                Container(
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        color: Colors.black26)),
                const SizedBox(
                  height: 8,
                ),
              },
              Padding(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 8, right: 20, left: 20),
                child: Text(listFood.name,
                    maxLines: 5,
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('รายละเอียด',
                        maxLines: 5,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w600)),
                    Text(
                      '   ${listFood.details}',
                      maxLines: 5,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30, bottom: 8.0),
                    child: SizedBox(
                        //width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                      'แคลอรี่ ${listFood.calories.toString()}',
                      style: Theme.of(context).textTheme.bodyLarge,
                    )),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Expanded(
                  //   child: Padding(
                  //     padding: const EdgeInsets.only(left: 15, right: 15),
                  //     child: WidgetDropdownStringNotValue(
                  //       title: 'เลือกมืออาหาร',
                  //       selectedValue: selectedValuehand,
                  //       ListItems: listhand,
                  //     ),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20, right: 30),
                    child: FilledButton(
                        onPressed: () {
                          // log(selectedValuehand.text);
                          
                          
                          // if (selectedValuehand.text.isEmpty) {
                          //   warningFood(context);
                          // } else {
                           
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
                                            : '1',
                              );
                              increaseFoodDay.add(requestFoodPost);
                              log(jsonEncode(requestFoodPost));
                              selectedValuehand.text = 'มื้อเช้า';
                              //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                              colorList[index] =
                                  context.read<AppData>().colorSelect;
                              selectedValuehand.text = '';
                            });

                            SmartDialog.dismiss();
                          
                        },
                        child: const Text('ยืนยัน')),
                  ),
                ],
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ),
      );
    });
  }
}
