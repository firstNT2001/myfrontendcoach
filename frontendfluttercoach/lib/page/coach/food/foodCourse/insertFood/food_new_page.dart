import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:badges/badges.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../service/provider/appdata.dart';
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

  @override
  void initState() {
    super.initState();
    _listFoodService = context.read<AppData>().listfoodServices;
    loadListFoodDataMethod = loadListFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            // IconButton(
            //   icon: const Icon(
            //     FontAwesomeIcons.angleRight,
            //     color: Colors.black,
            //   ),
            //   onPressed: () {
            //     if (idFood.length > 0) {
            //       Get.to(() => FoodSelectTimePage(idFood: idFood));
            //     }
            //   },
            // ),

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
                      setState(() {
                        if (colorFood[index] != Colors.black12) {
                           //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                          colorFood[index] = Colors.black12;

                          // เพิ่มเมนูอาหารนั้นเมือกกดเลือก
                          ModelFoodList request = ModelFoodList(
                              ifid: listFood.ifid,
                              name: listFood.name,
                              image: listFood.image,
                              details: listFood.details,
                              calories: listFood.calories);
                          increaseFood.add(request);

                        } else {
                          //กลับเป็นสีเดิมเมือเลือกเมนูอาหารซํ้า
                          colorFood[index] = Colors.white;
                          //เอาเมนูอาหารที่เลือกออกจาก list model
                          increaseFood.removeWhere((item) => item.ifid == listFood.ifid);
                        }
                      });
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
}
