import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/food_get_res.dart';
import 'package:provider/provider.dart';

import '../../service/food.dart';
import '../../service/provider/appdata.dart';

class HomeFoodAndClipPage extends StatefulWidget {
  HomeFoodAndClipPage({super.key, required this.did, required this.sequence});
  late String did;
  late String sequence;
  @override
  State<HomeFoodAndClipPage> createState() => _HomeFoodAndClipPageState();
}

class _HomeFoodAndClipPageState extends State<HomeFoodAndClipPage> {
   // FoodService
  late Future<void> loadFoodDataMethod;
  late FoodServices _foodService;
  List<ModelFood> foods = [];

    // ClipService
  late Future<void> loadClipDataMethod;
  late FoodServices _ClipService;
  //List<ModelClip> clips = [];
  
  @override
  void initState() {
    super.initState();
    _foodService = context.read<AppData>().foodServices;
    loadFoodDataMethod = loadFoodData();
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.primaryContainer,
            iconTheme: const IconThemeData(
              color: Colors.black, //change your color here
            ),
            title: Text("Day ${widget.sequence}"),
            bottom: const TabBar(tabs: [
              Tab(
                icon: Icon(
                  FontAwesomeIcons.bowlFood,
                  color: Colors.black,
                ),
              ),
              Tab(
                icon: Icon(
                  FontAwesomeIcons.dumbbell,
                  color: Colors.black,
                ),
              )
            ]),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              //Food
              ListView(
                children: [
                 showFood()
                ],
              ),

              //Clip
              Column(
                children: [
                  Text('Clip'),
                ],
              ),
            ],
          )),
    );
  }
  Future<void> loadFoodData() async {
    try {
      log(widget.did);
      var datas = await _foodService.foods(fid: '', ifid: '', did: widget.did);
      foods = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  //Show Data

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
                  color: Colors.white,
                  child: InkWell(
                    onTap: () {
                      // Get.to(() => CourseEditPage(
                      //       coID: courses[index].coId.toString(),
                      //     ));
                    },
                    child: Row(
                      //crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                          child: Container(
                              width: MediaQuery.of(context).size.width * 0.4,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(26),
                                image: DecorationImage(
                                  image: NetworkImage(listfood.listFood.image),
                                ),
                              )),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              listfood.listFood.name,
                              style: Theme.of(context).textTheme.bodyMedium,
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
