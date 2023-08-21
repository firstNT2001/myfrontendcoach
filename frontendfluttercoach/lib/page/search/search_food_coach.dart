import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:frontendfluttercoach/service/listFood.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../service/provider/appdata.dart';
import '../../widget/dialogs.dart';
import '../../widget/notificationBody.dart';
import '../coach/FoodAndClip/foodCoach/food_edit_page.dart';

class SearchFoodCoachPage extends StatefulWidget {
  const SearchFoodCoachPage({super.key});

  @override
  State<SearchFoodCoachPage> createState() => _SearchFoodCoachPageState();
}

class _SearchFoodCoachPageState extends State<SearchFoodCoachPage> {
  // FoodService
  late Future<void> loadFoodDataMethod;
  late ListFoodServices _foodService;
  List<ModelFoodList> foods = [];
  late ModelResult modelResult;

  TextEditingController searchName = TextEditingController();
  @override
  void initState() {
    super.initState();
    _foodService = context.read<AppData>().listfoodServices;
    loadFoodDataMethod = loadFoodData();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: SafeArea(
            child: Column(
          children: [
            searchBar(context),
            const SizedBox(height: 20),
            Expanded(
              child: showFood(),
            ),
          ],
        )),
      ),
    );
  }

  //SearchBar
  Padding searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(
              FontAwesomeIcons.chevronLeft,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
                color: const Color.fromRGBO(244, 243, 243, 1),
                borderRadius: BorderRadius.circular(15)),
            child: TextField(
              controller: searchName,
              autofocus: true,
              style: const TextStyle(color: Colors.black),
              onChanged: (value) {
                setState(() {
                  //isVisibles = true;
                  _foodService
                      .listFoods(
                          ifid: '',
                          cid: context.read<AppData>().cid.toString(),
                          name: searchName.text)
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
        ],
      ),
    );
  }

  //LoadData
  Future<void> loadFoodData() async {
    try {
      // log(widget.did);
      var datas = await _foodService.listFoods(
          ifid: '',
          cid: context.read<AppData>().cid.toString(),
          name: searchName.text);
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showFood() {
    return FutureBuilder(
      future: loadFoodDataMethod,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return Center(child: load(context));
        } else {
          return listView();
        }
      },
    );
  }

  ListView listView() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final listfood = foods[index];
        return Slidable(
          endActionPane: ActionPane(motion: const StretchMotion(), children: [
            SlidableAction(
              onPressed: (contexts) {
                dialogDeleteFood(context, listfood.ifid.toString());

                // Navigator.pop(context);
              },
              backgroundColor: Theme.of(context).colorScheme.error,
              icon: Icons.delete,
              label: 'Delete',
            )
          ]),
          child: Column(
            children: [
              SizedBox(
                //height: MediaQuery.of(context).size.height * 0.2,
                width: MediaQuery.of(context).size.width,
                child: InkWell(
                  onTap: () {
                    Get.to(() => FoodEditCoachPage(ifid: listfood.ifid))?.then((value) {
                                    Navigator.pop(context);

                    });
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (listfood.image != '') ...{
                        Padding(
                            padding: const EdgeInsets.only(
                                left: 15, right: 15, top: 5, bottom: 5),
                            child: Center(
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(20), // Image border
                                child: SizedBox.fromSize(
                                  size:
                                      const Size.fromRadius(55), // Image radius
                                  child: Image.network(listfood.image,
                                      fit: BoxFit.cover),
                                ),
                              ),
                            )),
                      } else
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.3,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Colors.pink)),
                        ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              listfood.name,
                              maxLines: 5,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            'แคลอรี่ ${listfood.calories.toString()}',
                            maxLines: 5,
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black38),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10, bottom: 10),
                child: Divider(
                  endIndent: 15,
                  indent: 15,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  //Dialog Delete
  void dialogDeleteFood(BuildContext context, String ifid) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      text: 'ต้องการลบเมนูอาหารหรือไม',
      confirmBtnText: 'ตกลง',
      cancelBtnText: 'ยกเลิก',
      confirmBtnColor: Theme.of(context).colorScheme.primary,
      onConfirmBtnTap: () async {
        startLoading(context);
        var response = await _foodService.deleteListFood(ifid);
        modelResult = response.data;
        log(modelResult.result);
        stopLoading();

        Navigator.of(context, rootNavigator: true).pop();
        log('onConfirmBtnTap');
        InAppNotification.show(
          child: NotificationBody(
            count: 1,
            message: 'ลบเมนูอาหารเรียบร้อยแล้ว',
          ),
          context: context,
          onTap: () => print('Notification tapped!'),
          duration: const Duration(milliseconds: 1500),
        );
        setState(() {
          loadFoodDataMethod = loadFoodData();
        });
      },
    );

  }
}
