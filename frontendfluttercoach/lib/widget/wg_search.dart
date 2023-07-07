import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/food_get_res.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';

import '../page/coach/food/foodCourse/edit_food.dart';
import '../service/food.dart';
import '../service/provider/appdata.dart';

class WidgetSearchFood extends StatefulWidget {
  const WidgetSearchFood({super.key, required this.searchName, required this.did});
  final TextEditingController searchName;
  final String did;
  @override
  State<WidgetSearchFood> createState() => _WidgetSearchFoodState();
}

class _WidgetSearchFoodState extends State<WidgetSearchFood> {
  // FoodService
  late Future<void> loadFoodDataMethod;
  late FoodServices _foodService;
  List<ModelFood> foods = [];
  //ShowFood
  bool isVisibles = false;
  @override
  void initState() {
    super.initState();
    _foodService = context.read<AppData>().foodServices;
    loadFoodDataMethod = loadFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          searchBar(context),
          const SizedBox(height: 20),
          Expanded(
            child: Visibility(
              visible: isVisibles,
              child: showFood(),
            ),
          ),
        ],
      )),
    );
  }

  //SearchBar
  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            color: const Color.fromRGBO(244, 243, 243, 1),
            borderRadius: BorderRadius.circular(15)),
        child: TextField(
          controller: widget.searchName,
          autofocus: true,
          style: TextStyle(color: Colors.black),
          onChanged: (value) {
            setState(() {
              isVisibles = true;
              _foodService
                  .foods(
                      fid: '',
                      ifid: '',
                      did: widget.did,
                      name: widget.searchName.text)
                  .then((fooddata) {
                var datafoods = fooddata.data;
                foods = datafoods;
                if (foods.isNotEmpty) {
                  setState(() {});
                  log(foods.length.toString());
                }
              });
            });
          },
          onSubmitted: (value) {},
          decoration: const InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              suffixIcon: Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.black,
              ),
              hintText: "ค้นหา...",
              hintStyle: TextStyle(color: Colors.grey)),
        ),
      ),
    );
  }

  //LoadData
  Future<void> loadFoodData() async {
    try {
      // log(widget.did);
      var datas = await _foodService.foods(
          fid: '', ifid: '', did: widget.did, name: '');
      foods = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood() {
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  //color: Colors.white,
                  elevation: 1000,
                  child: InkWell(
                    onTap: () {
                      Get.to(() => EditFoodPage(
                            fid: listfood.fid.toString(),
                            did: widget.did,
                            sequence: context.read<AppData>().sequence,
                            coID: context.read<AppData>().coID.toString(),
                          ));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (listfood.listFood.image != '') ...{
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.35,
                            height: MediaQuery.of(context).size.height,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Image.network(
                                  listfood.listFood.image,
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        } else
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.pink)),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.4,
                                  child: AutoSizeText(
                                    listfood.listFood.name,
                                    maxLines: 5,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ),
                                Text(
                                  listfood.time == '1'
                                      ? 'มื้อเช้า'
                                      : listfood.time == '2'
                                          ? 'มื้อเที่ยง'
                                          : listfood.time == '3'
                                              ? 'มื้อเย็น'
                                              : 'มื้อใดก็ได้',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 50,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
