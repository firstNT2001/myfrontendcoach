import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/service/food.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/request/food_dayID_post.dart';
import '../../../../../../model/response/md_FoodList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../course_food_clip.dart';

class FoodSelectTimePage extends StatefulWidget {
  const FoodSelectTimePage(
      {super.key,
      required this.did,
      required this.modelFoodList,
      required this.increaseFood});
  //id Day
  final String did;
  //Food
  final List<ModelFoodList> modelFoodList;
  final List<FoodDayIdPost> increaseFood;

  @override
  State<FoodSelectTimePage> createState() => _FoodSelectTimePageState();
}

class _FoodSelectTimePageState extends State<FoodSelectTimePage> {
  int caloriesSum = 0;
  // FoodService
  late Future<void> loadListFoodDataMethod;
  late FoodServices _foodCourseService;
  late ModelResult modelResult;
  @override
  void initState() {
    super.initState();

    _foodCourseService = context.read<AppData>().foodServices;

    for (var index in widget.modelFoodList) {
      caloriesSum = caloriesSum + index.calories;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('เลือกมื้ออาหาร'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: showFood()),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0, // Soften the shaodw
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.white),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'แคลอรี่ทั้งหมด',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              caloriesSum.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: ElevatedButton(
                                onPressed: () async {
                                  
                                  for (var index in widget.increaseFood) {
                                    log('id :${index.listFoodId}');
                                    log(jsonEncode(index));
                                    var response = await _foodCourseService
                                        .insertFoodByDayID(widget.did, index);
                                    modelResult = response.data;
                                  }
                                  log("result:${modelResult.result}");
                                  if (modelResult.result == '1') {
                                    widget.increaseFood.clear();
                                    Get.to(() => HomeFoodAndClipPage(
                                          did: widget.did,
                                          sequence:
                                              context.read<AppData>().sequence,
                                        ));
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    CherryToast.warning(
                                      title: const Text('บันทึกไม่สำเร็จ'),
                                      displayTitle: false,
                                      description:
                                          const Text('บันทึกไม่สำเร็จ'),
                                      toastPosition: Position.bottom,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      autoDismiss: true,
                                    ).show(context);
                                  }
                                },
                                child: const Text('บันทึก'))),
                      )
                    ])),
          )
        ],
      )),
    );
  }

  ListView showFood() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.modelFoodList.length,
      itemBuilder: (context, index) {
        var foods = widget.modelFoodList[index];
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            //color: colorFood[index],
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (foods.image != '') ...{
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            image: DecorationImage(
                              image: NetworkImage(foods.image),
                            ),
                          )),
                    ),
                  } else
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
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
                          foods.name,
                          maxLines: 5,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: AutoSizeText(
                          'Calories: ${foods.calories.toString()}',
                          maxLines: 5,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: AutoSizeText(
                          widget.increaseFood[index].time == '1'
                              ? 'มื้อเช้า'
                              : widget.increaseFood[index].time == '2'
                                  ? 'มื้อเที่ยง'
                                  : widget.increaseFood[index].time == '3'
                                      ? 'มื้อเย็น'
                                      : 'มื้อใดก็ได้',
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
}
