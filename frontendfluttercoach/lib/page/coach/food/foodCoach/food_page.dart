import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        // floatingActionButton: AnimatedFloatingActionButton(
        //     //Fab list
        //     fabButtons: <Widget>[float1(), float2()],
        //     key : key,
        //     colorStartAnimation: Theme.of(context).colorScheme.primary,
        //     colorEndAnimation: Colors.red,
        //     animatedIconData: AnimatedIcons.menu_close),
        floatingActionButton: SpeedDial(
          animatedIcon: AnimatedIcons.menu_close,
          overlayOpacity: 0.4,
          children: [
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.bowlFood),
                label: 'เพิ่มเมนู',
                onTap: (){
                  Get.to(() => FoodNewCoachPage());
                }),
            SpeedDialChild(
                child: const Icon(FontAwesomeIcons.dumbbell),
                label: 'เพิ่มคลิป',
                onTap: (){

                }),
          ],
        ),
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: TextButton(
              onPressed: () {},
              child: Text(
                'อาหารและคลิป',
                style: Theme.of(context).textTheme.headlineSmall,
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
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(
                FontAwesomeIcons.bowlFood,
              ),
            ),
            Tab(
              icon: Icon(
                FontAwesomeIcons.dumbbell,
              ),
            )
          ]),
          centerTitle: true,
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: ShowFood(),
                  ),
                ),
              ],
            ),
            Column(
              children: [],
            ),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> ShowFood() {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    double padding = 8;
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
                            height: double.infinity,
                          ),
                        } else
                          // Container(),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.pink)),
                        Positioned.fill(
                            bottom: 5,
                            //right: 0,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Container(
                                  width: (width - 16 - (3 * padding)) / 2,
                                  height:
                                      MediaQuery.of(context).size.height * 0.18,
                                  color: Color.fromARGB(100, 22, 44, 33),
                                  //margin: EdgeInsets.all(20),
                                  padding: EdgeInsets.all(40),
                                  child: AutoSizeText(
                                    maxLines: 2,
                                    listfood.name,
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  )),
                            )),
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

  Widget float1() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "btn1",
        tooltip: 'First button',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget float2() {
    return Container(
      child: FloatingActionButton(
        onPressed: null,
        heroTag: "btn2",
        tooltip: 'Second button',
        child: Icon(Icons.add),
      ),
    );
  }
}
