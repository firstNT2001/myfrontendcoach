import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/food_get_res.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';

class Widgetloadfood extends StatefulWidget {
  final int did;
  final String time;
  const Widgetloadfood({super.key, required this.did, required this.time});

  @override
  State<Widgetloadfood> createState() => _WidgetloadfoodState();
}

class _WidgetloadfoodState extends State<Widgetloadfood> {
  late FoodServices foodService;
  List<ModelFood> foods = [];
  List<ModelFood> foodsone = [];
  late Future<void> loadDataMethod;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    foodService = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return loadbreakfast();
  }

  Future<void> loadData() async {
    try {
      log("widget.did.toString()"+widget.did.toString());
      var datafood = await foodService.foods(
          fid: '', ifid: '', did: widget.did.toString(), name: '');
      foods = datafood.data;
      log("foods"+foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadbreakfast() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
           var foodm=  foods.where((element) => element.time == widget.time).toList();
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: foodm.length,
                itemBuilder: (context, index) {
                  final listbreakfast = foodm[index];
                  log("listbreakfast.time = "+listbreakfast.time);
                  log("(widget.time = "+widget.time);
                  return Container(
                        height: double.infinity,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 10,
                              ),
                              child: Card(
                                child: Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: const Color.fromARGB(
                                        255, 207, 208, 209),
                                    image: DecorationImage(
                                        image: NetworkImage(
                                          "https://images.lifestyleasia.com/wp-content/uploads/sites/3/2023/01/18184706/DfHYF9nVQAAjL_x.jpg",
                                        ),
                                        fit: BoxFit.cover),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),
                            Text(listbreakfast.listFood.name,
                                style: Theme.of(context).textTheme.bodyLarge)
                          ],
                        ));
              
                });
          }
        });
  }
}
