import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../../service/provider/appdata.dart';
import 'food_select_time_page.dart';

class FoodNewCoursePage extends StatefulWidget {
  FoodNewCoursePage({super.key, required this.did});
  late String did;
  @override
  State<FoodNewCoursePage> createState() => _FoodNewCoursePageState();
}

class _FoodNewCoursePageState extends State<FoodNewCoursePage> {
  // FoodService
  late Future<void> loadListFoodDataMethod;
  late ListFoodServices _listFoodService;
  List<ModelFoodList> listFoods = [];

  //Color
  List<Color> colorFood = [];

  //ListIncrease
  List<String> idFood = [];

  @override
  void initState() {
    super.initState();
    _listFoodService = context.read<AppData>().listfoodServices;
    loadListFoodDataMethod = loadListFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          actions: [
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.angleRight,
                color: Colors.black,
              ),
              onPressed: () {
                // for (var index in idFood) {
                //   log(index);
                // }
                if(idFood.length > 0) {
                   Get.to(() => FoodSelectTimePage(idFood: idFood));
                }
               
              },
            )
          ],
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text('เพิ่มเมนูอาหาร'),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              const SizedBox(
                height: 10,
              ),
              Expanded(
                child: Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: showFood(),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  //LoadData
  Future<void> loadListFoodData() async {
    try {
      var datas = await _listFoodService.listFoods(
          ifid: '', cid: context.read<AppData>().cid.toString(), name: '');
      listFoods = datas.data;
      // ignore: unused_local_variable
      for (var index in listFoods) {
        colorFood.add(Colors.white);
      }
      log("image${listFoods[2].image}");
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood() {
    return FutureBuilder(
      future: loadListFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: listFoods.length,
            itemBuilder: (context, index) {
              final listFood = listFoods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  color: colorFood[index],
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if (colorFood[index] != Colors.black12) {
                          colorFood[index] = Colors.black12;

                          idFood.add(listFood.ifid.toString());
                        } else {
                          colorFood[index] = Colors.white;
                          idFood.removeWhere(
                              (item) => item == listFood.ifid.toString());
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (listFood.image != '') ...{
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(26),
                                  image: DecorationImage(
                                    image: NetworkImage(listFood.image),
                                  ),
                                )),
                          ),
                        } else
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    color: Colors.black26)),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AutoSizeText(
                                listFood.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 50,
                        )
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
