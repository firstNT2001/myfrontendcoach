import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../../model/response/md_FoodList_get.dart';
import '../../../../../service/listFood.dart';

class FoodSelectTimePage extends StatefulWidget {
   FoodSelectTimePage({super.key, required this.idFood});
  late  List<String> idFood;
  @override
  State<FoodSelectTimePage> createState() => _FoodSelectTimePageState();
}

class _FoodSelectTimePageState extends State<FoodSelectTimePage> {
   // FoodService
  late Future<void> loadListFoodDataMethod;
  late ListFoodServices _listFoodService;
  List<ModelFoodList> listFoods = [];

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          iconTheme: const IconThemeData(
            color: Colors.black, //change your color here
          ),
          title: const Text('เพิ่มเมนูอาหาร'),
          centerTitle: true,
        ),
      body: SafeArea(child: Column(children: [],)),
    );
  }
}