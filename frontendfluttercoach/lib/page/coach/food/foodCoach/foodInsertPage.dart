import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/showDialogWidget.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../model/DTO/ListFoodPostRequest.dart';
import '../../../../model/modelRowsAffected.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';
import 'foodPage.dart';

class FoodInsertPage extends StatefulWidget {
  const FoodInsertPage({super.key});

  @override
  State<FoodInsertPage> createState() => _FoodInsertPageState();
}

class _FoodInsertPageState extends State<FoodInsertPage> {
  //Services
  late FoodServices foodServices;
  late ModelRowsAffected modelRowsAffected;
  var insertFood;
  //inputServices
  int cid = 0;
  TextEditingController name = TextEditingController();
  String image = "https://firebasestorage.googleapis.com/v0/b/logindailyworkout-26860.appspot.com/o/files%2F%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%88%E0%B8%B5%E0%B8%A2%E0%B8%A7%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%A1%E0%B8%B1%E0%B8%99.jpg?alt=media&token=46b22ea3-7e7b-4df2-8b37-fbdc317c1319";
  TextEditingController details = TextEditingController();
  TextEditingController calories = TextEditingController();

  @override
  void initState() {
    super.initState();

    foodServices = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    log( context.read<AppData>().baseurl);
    cid = context.read<CoachData>().cid;

    name.text = "ไข่เจียวไร้น้ำมันหมู22";
    details.text = "ไข่เจียว ไข่2ฟอง\r\nแครอท 30 กรัม\r\nกับหัวหอม 10 กรัม\r\nชีส 15 กรัม\r\nผักต้มสุกตามใจชอบ\r\nข้าวกล้อง 200 กรัม";
    calories.text = "260";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
              child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                child: TextField(
                    controller: name,
                    decoration: const InputDecoration(
                      labelText: "ชิ่อเมนู",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                    keyboardType: TextInputType.multiline,
                    controller: details,
                    maxLines: null,
                    minLines: 1,
                    decoration: const InputDecoration(
                      labelText: "รายระเอียด",
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
                child: TextField(
                    controller: calories,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Calories",
                    )),
              ),
              ElevatedButton(
                  onPressed: () async {
                    ListFoodPostRequest insertFoodDTO = ListFoodPostRequest(
                        cid: cid,
                        name: name.text,
                        image: image,
                        details: details.text,
                        calories: int.parse(calories.text));
                    log(jsonEncode(insertFoodDTO));
                    insertFood =
                        await foodServices.insertListFood(insertFoodDTO);
                    modelRowsAffected = insertFood.data;
                    log(jsonEncode(modelRowsAffected.rowsAffected));
                      if (modelRowsAffected.rowsAffected == "1") {
                          // ignore: use_build_context_synchronously
                          // showDialogRowsAffected(context, "บันทึกสำเร็จ");
                          const ShowDialogWidget();
                        } else {
                          // ignore: use_build_context_synchronously
                          const ShowDialogWidget();
                        }
                  },
                  child: const Text("บันทึก"))
            ],
          ))
        ],
      ),
    );
  }

  Column showDialogRowsAffected(BuildContext context, int type) {
    return Column(
      children: [
        if(type == 1)...{
          Container(),
        },
      ],
    );
  }
}
