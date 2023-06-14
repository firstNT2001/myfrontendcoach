import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../../../../../model/response/md_FoodList_get.dart';
import '../../../../../service/listFood.dart';

class FoodSelectTimePage extends StatefulWidget {
  FoodSelectTimePage(
      {super.key, required this.did, required this.modelFoodList});
  //id Day
  late String did;
  //Food
  late List<ModelFoodList> modelFoodList;

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
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('เลือกมื้ออาหาร'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [showFood()],
      )),
    );
  }

  ListView showFood() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.modelFoodList.length,
      itemBuilder: (context, index) {
        var foods = widget.modelFoodList[index];
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            //color: colorFood[index],
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (foods.image != '') ...{
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
                          height: MediaQuery.of(context).size.height,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(26),
                            image: DecorationImage(
                              image: NetworkImage(foods.image),
                            ),
                          )),
                    ),
                  } else
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                      child: Container(
                          width: MediaQuery.of(context).size.width * 0.25,
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
                          foods.name,
                          maxLines: 5,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.4,
                        child: AutoSizeText(
                          'Calories: ${foods.calories.toString()}',
                          maxLines: 5,
                          style: Theme.of(context).textTheme.bodyLarge,
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
}
