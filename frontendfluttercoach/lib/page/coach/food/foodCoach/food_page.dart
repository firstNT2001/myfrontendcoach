import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/food/foodCoach/food_edit_page.dart';

import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';

import 'food_new_page.dart';

class FoodCoachPage extends StatefulWidget {
  const FoodCoachPage({super.key});

  @override
  State<FoodCoachPage> createState() => _FoodCoachPageState();
}

class _FoodCoachPageState extends State<FoodCoachPage> {
  late ListFoodServices _listfoodService;
  late Future<void> loadDataMethod;
  late List<ModelFoodList> foods = [];

  String cid = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<AppData>().cid.toString();
    _listfoodService = context.read<AppData>().listfoodServices;

    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextButton(
            onPressed: () {},
            child: Text(
              'Food',
              style: Theme.of(context).textTheme.headlineMedium,
            )),
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              FontAwesomeIcons.magnifyingGlass,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 8, right: 8, top: 5, bottom: 5),
                child: ShowFood(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> ShowFood() {
    return FutureBuilder(
      future: loadDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
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
                      // Get.to(() => EditFoodPage(
                      //       fid: listfood.fid.toString(),
                      //       did: widget.did,
                      //       sequence: context.read<AppData>().sequence,
                      //       coID: context.read<AppData>().coID.toString(),
                      //     ));
                    },
                    child: Stack(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (listfood.image != '') ...{
                          Image.network(
                            listfood.image,
                            fit: BoxFit.cover,
                          ),
                        } else
                          // Container(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.pink)),
                        Positioned(
                            top: 0,
                            right: 0,
                            child: AutoSizeText(maxLines: 5, listfood.name)),
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: [
                        //     Column(
                        //       mainAxisAlignment: MainAxisAlignment.center,
                        //       crossAxisAlignment: CrossAxisAlignment.start,
                        //       children: [
                        //         SizedBox(
                        //           width:
                        //               MediaQuery.of(context).size.width * 0.4,
                        //           child: AutoSizeText(
                        //             listfood.name,
                        //             maxLines: 5,
                        //             style:
                        //                 Theme.of(context).textTheme.titleMedium,
                        //           ),
                        //         ),
                        //       ],
                        //     ),
                        //   ],
                        // ),
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

  Future<void> loadData() async {
    try {
      var datas = await _listfoodService.listFoods(
        ifid: '',
        cid: cid,
        name: '',
      );
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }
}
