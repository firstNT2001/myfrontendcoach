import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:provider/provider.dart';

import '../../../../service/provider/appdata.dart';

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
            onPressed: () {},
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
          child:  ListView(
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: showFood(),
                  )
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
              final listfood = listFoods[index];
              return SizedBox(
                height: MediaQuery.of(context).size.height * 0.2,
                child: Card(
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      //Get.to(() => EditFoodPage(fid: listfood.fid.toString()));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (listfood.image != null) ...{
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 5, bottom: 5),
                            child: Container(
                                width: MediaQuery.of(context).size.width * 0.3,
                                height: MediaQuery.of(context).size.height,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(26),
                                    color: Colors.pink
                                    // image: DecorationImage(
                                    //   image:
                                    //       NetworkImage(listfood.listFood.image),
                                    // ),
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
                                  image: DecorationImage(
                                    image:
                                        NetworkImage(listfood.image),
                                  ),
                                )),
                          ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              child: AutoSizeText(
                                listfood.name,
                                maxLines: 5,
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                            ),
                           
                          ],
                        ),
                        const SizedBox(
                          width: 50,
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
