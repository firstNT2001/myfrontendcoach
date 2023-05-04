import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/showDialogWidget.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_coachID_post.dart';

import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';

class FoodNewCoachPage extends StatefulWidget {
  const FoodNewCoachPage({super.key});

  @override
  State<FoodNewCoachPage> createState() => _FoodNewCoachPageState();
}

class _FoodNewCoachPageState extends State<FoodNewCoachPage> {
  //Services
  late ListFoodServices _listfoodService;
  late ModelResult modelResult;
  var insertFood;
  //inputServices
  int cid = 0;
  TextEditingController name = TextEditingController();
  String image =
      "https://firebasestorage.googleapis.com/v0/b/logindailyworkout-26860.appspot.com/o/files%2F%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%88%E0%B8%B5%E0%B8%A2%E0%B8%A7%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%A1%E0%B8%B1%E0%B8%99.jpg?alt=media&token=46b22ea3-7e7b-4df2-8b37-fbdc317c1319";
  TextEditingController details = TextEditingController();
  TextEditingController calories = TextEditingController();

  @override
  void initState() {
    super.initState();

    _listfoodService = context.read<AppData>().listfoodServices;
    log(context.read<AppData>().baseurl);
    cid = context.read<CoachData>().cid;

    name.text = "ไข่เจียวไร้น้ำมันหมู22";
    details.text =
        "ไข่เจียว ไข่2ฟอง แครอท 30 กรัม กับหัวหอม 10 กรัม ชีส 15 กรัม ผักต้มสุกตามใจชอบ ข้าวกล้อง 200 กรัม";
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
                    ListFoodCoachIdPost listFoodCoachIdPost =
                        ListFoodCoachIdPost(
                            name: name.text,
                            image: image,
                            details: details.text,
                            calories: int.parse(calories.text));
                    log(jsonEncode(listFoodCoachIdPost));
                    insertFood = await _listfoodService
                        .insertListFoodByCoachID(cid.toString(),listFoodCoachIdPost);
                    modelResult = insertFood.data;
                    log(jsonEncode(modelResult.result));
                    if (modelResult.result == "1") {
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
        if (type == 1) ...{
          Container(),
        },
      ],
    );
  }
}
