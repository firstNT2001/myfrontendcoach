import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/listFoodDTO.dart';
import 'package:provider/provider.dart';

import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';

class FoodInsertPage extends StatefulWidget {
  const FoodInsertPage({super.key});

  @override
  State<FoodInsertPage> createState() => _FoodInsertPageState();
}

class _FoodInsertPageState extends State<FoodInsertPage> {
  //Services
  late FoodServices foodServices;
  var insertFood;
  //inputServices
  int cid = 0;
  TextEditingController name = TextEditingController();
  String image = "-";
  TextEditingController details = TextEditingController();
  TextEditingController calories = TextEditingController();

  @override
  void initState() {
    super.initState();

    foodServices = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    log( context.read<AppData>().baseurl);
    cid = context.read<CoachData>().cid;
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
                    ListFoodDto insertFoodDTO = ListFoodDto(
                        cid: cid,
                        name: name.text,
                        image: image,
                        details: details.text,
                        calories: int.parse(calories.text));
                    log(jsonEncode(insertFoodDTO));
                    insertFood =
                        await foodServices.insertListFood(insertFoodDTO);
                    log(jsonEncode(insertFood));
                    //   if (insertFood.data.rowsAffected == "1") {
                    //       // ignore: use_build_context_synchronously
                    //       showDialogRowsAffected(context, "บันทึกสำเร็จ");
                    //     } else {
                    //       // ignore: use_build_context_synchronously
                    //       showDialogRowsAffected(context, "บันทึกไม่สำเร็จ");
                    //     }
                  },
                  child: const Text("บันทึก"))
            ],
          ))
        ],
      ),
    );
  }

  Future<String?> showDialogRowsAffected(BuildContext context, String name) {
    return showDialog<String>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
              title: Text(name),
              actions: <Widget>[
                TextButton(
                    child: const Text('Cancel'),
                    onPressed: () {
                      Navigator.pop(context, 'Cancel');
                    }),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, 'OK');
                  },
                  child: const Text('OK'),
                ),
              ],
            ));
  }
}
