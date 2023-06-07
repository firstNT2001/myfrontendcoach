import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_foodID_put.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/wg_textField.dart';
import 'food_page.dart';

class FoodEditCoachPage extends StatefulWidget {
  late int ifid;
  FoodEditCoachPage({super.key, required this.ifid});

  @override
  State<FoodEditCoachPage> createState() => _FoodEditCoachPageState();
}

class _FoodEditCoachPageState extends State<FoodEditCoachPage> {
  late Future<void> _loadData;
  late ListFoodServices _listfoodService;
  List<ModelFoodList> foods = [];
  late ModelResult modelResult;
  var editFood;

  TextEditingController name = TextEditingController();
  String image =
      "https://firebasestorage.googleapis.com/v0/b/logindailyworkout-26860.appspot.com/o/files%2F%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%88%E0%B8%B5%E0%B8%A2%E0%B8%A7%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%A1%E0%B8%B1%E0%B8%99.jpg?alt=media&token=46b22ea3-7e7b-4df2-8b37-fbdc317c1319";
  TextEditingController details = TextEditingController();
  TextEditingController calories = TextEditingController();
  // int ifid = 0;
  @override
  void initState() {
    super.initState();
    _listfoodService = context.read<AppData>().listfoodServices;
    _loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _loadData,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Container();
              //return const Center(child: CircularProgressIndicator());
            }
            return ListView(
              children: [
                WidgetTextFieldString(
                  controller: name,
                  labelText: 'ชื่อ',
                ),
                WidgetTextFieldString(
                  controller: details,
                  labelText: 'details',
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () async {
                        log(widget.ifid.toString());
                        log(context.read<AppData>().cid.toString());
                        ListFoodFoodIdPut request = ListFoodFoodIdPut(
                            name: name.text,
                            image: image,
                            details: details.text,
                            calories: int.parse(calories.text),
                            coachId: context.read<AppData>().cid);
                        log(jsonEncode(request));
                        editFood = await _listfoodService.updateListFoodByFoodID(
                            widget.ifid.toString(), request);
                        modelResult = editFood.data;
                        log(jsonEncode(modelResult.result));
                         if (modelResult.result == "1") {
                          Get.to(() => const FoodCoachPage());
                         }
                      },
                      child: const Text('บันทึก')),
                )
              ],
            );
          }),
    );
  }

  Future<void> loadDataAsync() async {
    try {
      var res = await _listfoodService.listFoods(
          ifid: widget.ifid.toString(), cid: '', name: '');
      foods = res.data;
      name.text = foods.first.name;
      details.text = foods.first.details;
      calories.text = foods.first.calories.toString();
    } catch (err) {
      log('Error: $err');
    }
  }
}
