import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/food_get_res.dart';
import '../../../../service/food.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/method_dropdownFood_coach.dart';

class EditFoodPage extends StatefulWidget {
  EditFoodPage({super.key, required this.fid});
  late String fid;
  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  //FoodService
  ///FoodCourses
  late Future<void> loadFoodCoursesDataMethod;
  late FoodServices _foodCourseService;
  List<ModelFood> foodCourses = [];

  ///FoodCoach
  late Future<void> loadFoodCoachDataMethod;
  late ListFoodServices _foodCoachService;
  List<ModelFoodList> foodCoachs = [];

  //selectLevel
  // final List<String> LevelItems = ['ง่าย', 'ปานกลาง', 'ยาก'];
  String selectedValue = '';
  int numberFoods = 0;

  //CoachID
  String cid = '';
  @override
  void initState() {
    cid = context.read<AppData>().cid.toString();
    //FoodCoach
    _foodCoachService = context.read<AppData>().listfoodServices;

    //FoodCourses
    _foodCourseService = context.read<AppData>().foodServices;
    loadFoodCoursesDataMethod = loadFoodData();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.trash,
              color: Colors.black,
            ),
            onPressed: () {
              setState(() {});
            },
          )
        ],
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('หน้าแก้ไขเมนูอาหาร'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: ListView(
        children: [showFood()],
      )),
    );
  }

  //loodDataFoodinCourse
  Future<void> loadFoodData() async {
    try {
      //foodCourse
      var foodCoursedatas =
          await _foodCourseService.foods(fid: widget.fid, ifid: '', did: '');
      foodCourses = foodCoursedatas.data;

      //foodCoach
      var foodCoachdatas =
          await _foodCoachService.listFoods(ifid: '', cid: cid, name: '');
      foodCoachs = foodCoachdatas.data;
      
      //loop หาชื่อเมนูอาหารว่าชื่อนั้นอยู่ใน อาเรที่เท่าไหร่ เพื่อไปแสดงใน WidgetDropdownFoodInCoach
      for (var i = 0; i < foodCoachs.length; i++) {
        if (foodCoachs[i].name == foodCourses.first.listFood.name) {
          numberFoods = i;
          break;
        }
      }

    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data

  Widget showFood() {
    return FutureBuilder(
      future: loadFoodCoursesDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Column(children: [
            Text(foodCourses.first.listFood.name),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: WidgetDropdownFoodInCoach(
                selectedValue: selectedValue,
                ModelfoodCoachs: foodCoachs,
                numberFoods: numberFoods,
              ),
            ),
          ]);
        }
      },
    );
  }
}
