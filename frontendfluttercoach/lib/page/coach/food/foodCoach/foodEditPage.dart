import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../model/DTO/ListFoodPutRequest.dart';
import '../../../../model/ModelFoodList.dart';

import '../../../../model/modelResult.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';

class FoodEditPage extends StatefulWidget {
  late int ifid;
  FoodEditPage({super.key, required this.ifid});

  @override
  State<FoodEditPage> createState() => _FoodEditPageState();
}

class _FoodEditPageState extends State<FoodEditPage> {
  late Future<void> _loadData;
  late ListFoodServices _listfoodService;
  late ModelFoodList foods;
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
      body: Container(
        child: FutureBuilder(
            future: _loadData,
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Container();
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(100.0),
                    child: TextField(controller: name),
                  ),
                  ElevatedButton(
                      onPressed: () async {
                        // ListFoodPutRequest request = ListFoodPutRequest(
                        //     ifid: widget.ifid,
                        //     name: name.text,
                        //     image: image,
                        //     details: details.text,
                        //     calories: int.parse(calories.text));
                        ListFoodPutRequest request = ListFoodPutRequest(
                            ifid: widget.ifid,
                            name: name.text,
                            image: image,
                            details: 'tt',
                            calories: 22);
                        log(jsonEncode(request));    
                        editFood =
                         await _listfoodService.updateListFood(request);
                        modelResult = editFood.data;
                        log(jsonEncode(modelResult.result));
                      },
                      child: const Text('บันทึก'))
                ],
              );
            }),
      ),
    );
  }

  Future<void> loadDataAsync() async {
    try {
      var res = await _listfoodService.listFood(widget.ifid.toString());
      foods = res.data;
      name.text = foods.name;
    } catch (err) {
      log('Error: $err');
    }
  }
}
