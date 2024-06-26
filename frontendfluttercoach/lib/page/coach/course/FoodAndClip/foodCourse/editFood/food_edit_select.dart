import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/request/food_foodID_put.dart';
import '../../../../../../model/response/md_FoodList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../service/food.dart';
import '../../../../../../service/listFood.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/dialogs.dart';
import '../../../../../../widget/notificationBody.dart';

class FoodEditSelectPage extends StatefulWidget {
  const FoodEditSelectPage(
      {super.key,
      required this.fid,
      required this.did,
      required this.sequence,
      required this.time,
      required this.isVisible});
  final String fid;
  final String did;
  final String sequence;
  final String time;
  final bool isVisible;
  @override
  State<FoodEditSelectPage> createState() => _FoodEditSelectPageState();
}

class _FoodEditSelectPageState extends State<FoodEditSelectPage> {
  // FoodService
  late Future<void> loadListFoodDataMethod;
  late ListFoodServices _listfoodService;
  List<ModelFoodList> foods = [];
  late ModelResult modelResult;

  ///FoodCourses
  late FoodServices _foodCourseService;

  @override
  void initState() {
    super.initState();
    _listfoodService = context.read<AppData>().listfoodServices;
    loadListFoodDataMethod = loadListFoodData();

    //FoodCourses
    _foodCourseService = context.read<AppData>().foodServices;
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            //color: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text('เลือกเมนูอาหาร'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: showFood(),
          ),
        ],
      ),
    );
  }

  //LoadData
  Future<void> loadListFoodData() async {
    try {
      // log(widget.did);
      var datas = await _listfoodService.listFoods(
          ifid: '', cid: context.read<AppData>().cid.toString(), name: '');
      foods = datas.data;
      // log(foods.length.toString());
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood() {
    return FutureBuilder(
      future: loadListFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: foods.length,
            itemBuilder: (context, index) {
              final listfood = foods[index];
              return Column(
                children: [
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.2,
                    child: InkWell(
                      onTap: () {
                        //Get.to(() => FoodEditCoachPage(ifid: listfood.ifid));
                        dialog(context, listfood.ifid, listfood.name,
                            listfood.details);
                      },
                      child: Row(
                        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (listfood.image != '') ...{
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height * 0.2,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    listfood.image,
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                          } else
                            Container(
                                width: MediaQuery.of(context).size.width * 0.4,
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                padding: const EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white)),
                          const SizedBox(width: 10),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.5,
                                child: AutoSizeText(
                                  listfood.name,
                                  maxLines: 5,
                                  style:
                                      Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Calories : ${listfood.calories}",
                                style: Theme.of(context).textTheme.titleMedium,
                              )
                            ],
                          ),
                          //const SizedBox(height: 60),
                        ],
                      ),
                    ),
                  ),
                  const Divider(
                    indent: 20,
                    endIndent: 20,
                  ),
                ],
              );
            },
          );
        }
      },
    );
  }

  void dialog(BuildContext context, int ifid, String name, String details) {
    SmartDialog.show(
      alignment: Alignment.bottomCenter,
      builder: (_) {
        return Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height * 0.45,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20), topLeft: Radius.circular(20)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 20),
                      child: Text(name,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, bottom: 10),
                      child: Text("รายละเอียด",
                          style: Theme.of(context).textTheme.titleMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 20, right: 20, bottom: 20),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "   $details",
                          //maxLines: 8,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, right: 20),
                      child: FilledButton(
                          onPressed: () async {
                            log(widget.time);
                            FoodFoodIdPut foodFoodIdPut = FoodFoodIdPut(
                                listFoodId: ifid,
                                time: widget.time,
                                dayOfCouseId: int.parse(widget.did));
                            log(jsonEncode(foodFoodIdPut));
                            var response = await _foodCourseService
                                .updateFoodByFoodID(widget.fid, foodFoodIdPut);
                            modelResult = response.data;
                            log(modelResult.result);
                            if (modelResult.result == '1') {
                              // ignore: use_build_context_synchronously
                              Navigator.pop(context);

                              // ignore: use_build_context_synchronously
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'แก้ไขเมนูสำเร็จ',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 2000),
                              );
                            } else if (modelResult.result == '-14') {
                              // ignore: use_build_context_synchronously
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'มีเมนูอาหารในมื้อนี้แล้ว',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 2000),
                              );
                            } else {
                              // ignore: use_build_context_synchronously
                              InAppNotification.show(
                                child: NotificationBody(
                                  count: 1,
                                  message: 'มีเมนูอาหารในมื้อ ${widget.time == '1' ?'มื้อเช้า' : widget.time == '2' ?'มื้อเที่ยง' : widget.time == '3' ?'มื้อเย็น': ''} แล้ว',
                                ),
                                context: context,
                                onTap: () => print('Notification tapped!'),
                                duration: const Duration(milliseconds: 1500),
                              );
                            }
                          },
                          child: const Text("บันทึก")),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
