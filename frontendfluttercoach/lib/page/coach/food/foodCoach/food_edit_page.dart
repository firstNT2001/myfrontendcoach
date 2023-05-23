import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_foodID_put.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';

class FoodEditCoachPage extends StatefulWidget {
  late int ifid;
  FoodEditCoachPage({super.key, required this.ifid});

  @override
  State<FoodEditCoachPage> createState() => _FoodEditCoachPageState();
}

class _FoodEditCoachPageState extends State<FoodEditCoachPage> {
  late Future<void> _loadData;
  late ListFoodServices _listfoodService;
  List<ModelFoodList> foods=[];
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
                //return const Center(child: CircularProgressIndicator());
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
                        ListFoodFoodIdPut request = ListFoodFoodIdPut(
                            name: name.text,
                            image: image,
                            details: 'tt',
                            calories: 22, coachId: context.read<CoachData>().cid
                            );
                        log(jsonEncode(request));    
                        editFood =
                         await _listfoodService.updateListFoodByFoodID(widget.ifid.toString(),request);
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
      var res = await _listfoodService.listFoods(ifid: widget.ifid.toString(), cid: '', name: '');
      foods = res.data;
      name.text = foods[0].name;
    } catch (err) {
      log('Error: $err');
    }
  }
}
