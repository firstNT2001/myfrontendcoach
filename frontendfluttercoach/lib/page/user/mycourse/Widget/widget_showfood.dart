import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'package:provider/provider.dart';

import '../../../../model/response/food_get_res.dart';
=======
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/food_get_res.dart';
import '../../../../model/response/md_FoodList_get.dart';
>>>>>>> feature/12082023-uicourse
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
<<<<<<< HEAD
  List<ModelFood> foodsone = [];
=======
  List<ModelFood> listFoods = [];
>>>>>>> feature/12082023-uicourse
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
<<<<<<< HEAD
      log("widget.did.toString()"+widget.did.toString());
      var datafood = await foodService.foods(
          fid: '', ifid: '', did: widget.did.toString(), name: '');
      foods = datafood.data;
      log("foods"+foods.length.toString());
=======
      log("widget.did.toString()" + widget.did.toString());
      var datafood = await foodService.foods(
          fid: '', ifid: '', did: widget.did.toString(), name: '');
      foods = datafood.data;
      log("foods" + foods.length.toString());
>>>>>>> feature/12082023-uicourse
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
<<<<<<< HEAD
           var foodm=  foods.where((element) => element.time == widget.time).toList();
=======
            var foodm =
                foods.where((element) => element.time == widget.time).toList();
>>>>>>> feature/12082023-uicourse
            return ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: foodm.length,
                itemBuilder: (context, index) {
                  final listbreakfast = foodm[index];
<<<<<<< HEAD
                  log("listbreakfast.time = "+listbreakfast.time);
                  log("(widget.time = "+widget.time);
                  return Container(
                        height: double.infinity,
=======
                  log("listbreakfast.time = " + listbreakfast.time);
                  log("(widget.time = " + widget.time);
                  return Container(
                      height: double.infinity,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            // เพิ่มเมนูอาหารนั้นเมือกกดเลือก
                            ModelFoodList request = ModelFoodList(                            
                                name: listbreakfast.listFood.name,
                                image: listbreakfast.listFood.image,
                                details: listbreakfast.listFood.details,
                                calories: listbreakfast.listFood.calories, ifid: 0);

                            _dialog(context, request, index);
                            //เปลี่ยนสีเมือเลือกเมนู฿อาหาร
                            // colorFood[index] = Colors.black12;
                          });
                        },
>>>>>>> feature/12082023-uicourse
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
<<<<<<< HEAD
                                          "https://images.lifestyleasia.com/wp-content/uploads/sites/3/2023/01/18184706/DfHYF9nVQAAjL_x.jpg",
=======
                                          listbreakfast.listFood.image,
>>>>>>> feature/12082023-uicourse
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
<<<<<<< HEAD
                        ));
              
=======
                        ),
                      ));
>>>>>>> feature/12082023-uicourse
                });
          }
        });
  }
<<<<<<< HEAD
=======

void _dialog(BuildContext ctx, ModelFoodList listFood, int index) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: 550,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 10),
              child: Text("เมนูอาหาร",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (listFood.image != '') ...{
              ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                   foods.first.listFood.image,
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.2,
                    fit: BoxFit.cover,
                  )),
            } else ...{
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Colors.black26)),
              const SizedBox(
                height: 8,
              ),
            },
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 8),
              child: Text(
                'ชื่อเมนู: ${listFood.name}',
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8, right: 20, left: 20),
              child: Text(
                'รายละเอียด: ${listFood.details}',
                maxLines: 5,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30, bottom: 8.0),
                  child: SizedBox(
                      //width: MediaQuery.of(context).size.width * 0.7,
                      child: Text(
                    'Calories: ${listFood.calories.toString()}',
                    style: Theme.of(context).textTheme.bodyLarge,
                  )),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
>>>>>>> feature/12082023-uicourse
}
