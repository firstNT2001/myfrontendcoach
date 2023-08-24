import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/service/food.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'package:provider/provider.dart';

import '../../../../../../model/request/food_dayID_post.dart';
import '../../../../../../model/response/md_FoodList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/notificationBody.dart';
import '../../../../../../widget/slideAction.dart';

class FoodSelectTimePage extends StatefulWidget {
  const FoodSelectTimePage(
      {super.key,
      required this.did,
      required this.modelFoodList,
      required this.increaseFood,
      required this.isVisible});
  //id Day
  final String did;
  //Food
  final List<ModelFoodList> modelFoodList;
  final List<FoodDayIdPost> increaseFood;

  final bool isVisible;
  @override
  State<FoodSelectTimePage> createState() => _FoodSelectTimePageState();
}

class _FoodSelectTimePageState extends State<FoodSelectTimePage>
    with SingleTickerProviderStateMixin {
  int caloriesSum = 0;
  // FoodService
  late Future<void> loadListFoodDataMethod;
  late FoodServices _foodCourseService;
  late ModelResult modelResult;

  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];

  AnimationController? controller;
  @override
  void initState() {
    super.initState();

    _foodCourseService = context.read<AppData>().foodServices;

    for (var index in widget.modelFoodList) {
      caloriesSum = caloriesSum + index.calories;
    }
    controller = AnimationController(
      vsync: this,
      upperBound: 0.5,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(onWillPop: () async => false, child: scaffold(context));
  }

  Scaffold scaffold(BuildContext contexts) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('เพิ่มมื้ออาหาร'),
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
                            child: button(context)),
                      )
                    ])),
          )
        ],
      )),
    );
  }

  FilledButton button(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          startLoading(context);
          for (var index in widget.increaseFood) {
            log('id :${index.listFoodId}');
            log(jsonEncode(index));
            var response =
                await _foodCourseService.insertFoodByDayID(widget.did, index);
            modelResult = response.data;
          }
          log("result:${modelResult.result}");
          stopLoading();
          log(modelResult.result);
          if (modelResult.result == '1') {
            widget.increaseFood.clear();
            Navigator.popUntil(
                context, ModalRoute.withName('/HomeFoodAndClipPage'));

            // ignore: use_build_context_synchronously
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'เพิ่มเมนูสำเร็จ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 2000),
            );
          } else if(modelResult.result == '-14') {
            // ignore: use_build_context_synchronously
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'มีเมนูอาหารในมื้อนี้แล้ว',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 2000),
            );
          } else {
            // ignore: use_build_context_synchronously
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'เพิ่มเมนูไม่สำเร็จ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 2000),
            );
          }
        },
        child: const Text('บันทึก'));
  }

  showFood() {
    return SlidablePlayer(
      animation: controller,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: widget.modelFoodList.length,
        itemBuilder: (context, index) {
          var foods = widget.modelFoodList[index];
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.2,
            child: Slidable(
              endActionPane:
                  ActionPane(motion: const StretchMotion(), children: [
                SlidableAction(
                  onPressed: (context) {
                    setState(() {
                      widget.modelFoodList
                          .removeWhere((item) => item.ifid == foods.ifid);

                      widget.increaseFood
                          .removeWhere((item) => item.listFoodId == foods.ifid);
                    });
                  },
                  backgroundColor: Theme.of(context).colorScheme.error,
                  icon: Icons.delete,
                  label: 'Delete',
                )
              ]),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: food(foods, context, index),
              ),
            ),
          );
        },
      ),
    );
  }

  Card food(ModelFoodList foods, BuildContext context, int index) {
    return Card(
      elevation: 10,

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
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 5, bottom: 5),
                  child: Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Image border
                      child: SizedBox.fromSize(
                        size: const Size.fromRadius(50), // Image radius
                        child: Image.network(foods.image, fit: BoxFit.cover),
                      ),
                    ),
                  )),
            } else
              Padding(
                padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
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
    );
  }
}
