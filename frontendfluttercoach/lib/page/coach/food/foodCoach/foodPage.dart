import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';
// import '../../../../service/provider/listFood.dart';
import 'foodEditPage.dart';
import 'foodInsertPage.dart';


class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  late ListFoodServices _listfoodService;
  late Future<void> loadDataMethod;
  late List<ModelFoodList> foods = [];

  String cid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<CoachData>().cid.toString();
    _listfoodService =
        context.read<AppData>().listfoodServices;

    loadDataMethod = loadData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Container(
                child: Column(
                  children: [
                    Container(
                    padding: const EdgeInsets.only(top: 50, left: 5, right: 5),
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<CoachData>().cid = int.parse(cid);
                        Get.to(() => const FoodInsertPage());
                      },
                      child: const Text("สร้างรายการอาหาร"),
                    ),
                  ),
                    (foods != null)
                        ? Expanded(
                            child: ListView.builder(
                        itemCount: foods.length,
                        itemBuilder: (context, index) {
                          return Container(
                            padding: const EdgeInsets.only(
                                top: 8, left: 5, right: 5),
                            child: Card(
                                child: ListTile(
                              title: Text(foods[index].name),
                              subtitle: Text("Calories : "+foods[index].calories.toString()),
                              leading: Image.network(foods[index].image),
                              onTap: () {
                                // log(foods[index].ifid.toString());
                                
                                Get.to(() =>  FoodEditPage(ifid: foods[index].ifid,));
                              },
                            )),
                          );
                        },
                      ),
                          )
                        : Container(),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
  Future<void> loadData() async {
    try {
      var datas = await _listfoodService.listFoods(ifid: '', cid: cid, name: '',);
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}