import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/mycourse.Detaildart/myClipinCourse/showclip.dart';
import 'package:video_player/video_player.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../service/clip.dart';
import '../../../model/response/food_get_res.dart';
import '../../../service/food.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

import '../../../service/provider/appdata.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';

import 'myClipinCourse/widget_loadcilcp.dart';
import 'mycourse.dart';

class showFood extends StatefulWidget {
  const showFood({super.key});

  @override
  State<showFood> createState() => _showFoodState();
}

class _showFoodState extends State<showFood> {
  List<ModelFood> foods = [];
  late ClipServices clipServices;
  List<ModelClip> clips = [];
  late FoodServices foodService;
  late Future<void> loadDataMethod;

  int did = 0;
  String namecourse = "";
  late String videoUrl = "";
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings();
  void initState() {
    // TODO: implement initState
    super.initState();
    did = context.read<AppData>().did;
    namecourse = context.read<AppData>().namecourse;
    log("did"+did.toString());
    clipServices =
        ClipServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    foodService = FoodServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
          bottom: const TabBar(tabs: [
            Tab(
              icon: Icon(Icons.fastfood_outlined),
              text: "เมนูอาหาร",
            ),
            Tab(
              icon: Icon(Icons.fitness_center_sharp),
              text: "คลิปออกกำลังกาย",
            ),
          ]),
          title: Center(child: Text(namecourse),
          ),
        ), body: TabBarView(children: [
          Column(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadfoods(),
              )),
            ],
          ),
          Column(
            children: [
              Expanded(child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: loadclips(),
              )),
            ],
          ),
          
        ]),
       ));
    // Scaffold(
    //   body: Column(children: [Flexible(child: loadfoods()),
    //   Flexible(
    //       child: Align(
    //         alignment: Alignment.bottomCenter,
    //         child: Row(
    //           mainAxisAlignment: MainAxisAlignment.spaceAround,
    //           children: [
    //             ElevatedButton(
    //                 child: const Text('ถอยกลับ'),
    //                 onPressed: () {
    //                   Get.to(() => const MyCouses());
    //                 },
    //                 ),
    //                 ElevatedButton(
    //                 child: const Text('ถัดไป'),
    //                 onPressed: () {
    //                   log("Did := "+did.toString());
    //                   context.read<AppData>().did = did;
    //                   Get.to(() => const showCilp());
    //                 },
    //                ),
    //           ],
    //         ),
    //       ),
    //     )
    //   ]),
    // );
  }
  Widget loadclips() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index)  {
                  final listclip = clips[index];
                  videoUrl = listclip.listClip.video;
                  // _videoPlayerController =
                  //     VideoPlayerController.network(videoUrl)
                  //       ..initialize().then((value) => setState(() {}));

                  // _customVideoPlayerController = CustomVideoPlayerController(
                  //   context: context,
                  //   videoPlayerController: _videoPlayerController,
                  // );
                 // log(_videoPlayerController.dataSource);
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Text(listclip.listClip.name),
                        WidgetloadCilp(urlVideo: videoUrl, nameclip: listclip.listClip.name,),
                        Text(listclip.listClip.details)
                        ],
                    ),
                  );
                });
          }
        });
  }

  Widget loadfoods() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: foods.length,
                itemBuilder: (context, index) {
                  final listfood = foods[index];
                  final GlobalKey<ExpansionTileCardState> cardA =
                      new GlobalKey();
                  return ExpansionTileCard(
                    baseColor: const Color.fromARGB(255, 212, 212, 212),
                    expandedColor: const Color.fromARGB(255, 191, 191, 191),
                    key: cardA,
                   leading:SizedBox(
                        height: 200,
                        width: 200,
                        child: Image.network(
                          listfood.listFood.image,
                        )),
                  // Container(
                  //   alignment: Alignment.topCenter,
                  //   child: AspectRatio(aspectRatio: 16/9,child: Image.network(listfood.listFood.image, fit: BoxFit.cover)),                 
                  // ),
                    // SizedBox(
                    //     height: 200,
                    //     width: 200,
                    //     child: Image.network(
                    //       listfood.listFood.image,
                    //     )),
                    title: Text(listfood.listFood.name),
                    subtitle: Text("${listfood.listFood.calories} แคลอรี่",
                        style: Theme.of(context).textTheme.bodyLarge),
                    children: <Widget>[
                      const Divider(
                        thickness: 1.0,
                        height: 1.0,
                        color: Colors.black,
                        endIndent: 8,
                        indent: 8,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                            vertical: 8.0,
                          ),
                          child: Text(listfood.listFood.details,
                              style: Theme.of(context).textTheme.bodyLarge),
                        ),
                      ),
                    ],
                  );
                  // ExpansionTile(
                  //   title: Row(
                  //     children: [
                  //       SizedBox(
                  //         height: 150,width: 150,
                  //         child: Image.network(listfood.listFood.image)),
                  //       Column(
                  //         children: [
                  //           Text(listfood.listFood.name,
                  //               style: Theme.of(context).textTheme.bodyLarge),

                  //         ],
                  //       ),
                  //     ],
                  //   ),
                  //   subtitle: Text("${listfood.listFood.calories} แคลอรี่",
                  //       style: Theme.of(context).textTheme.bodyLarge),
                  //   children: <Widget>[
                  //     ListTile(title: Text(listfood.listFood.details)),
                  //   ],
                  //   onExpansionChanged: (bool extended){
                  //     setState(() => );
                  //   },
                  // );
                });
          }
        });
  }

  Future<void> loadData() async {
    try {
      var dataclip =
          await clipServices.clips(cpID: '', icpID: '', did: did.toString());
      clips = dataclip.data;
      var datafood =
          await foodService.foods(fid: '', ifid: '', did: did.toString());
      foods = datafood.data;
      log('food leng: ${foods.length}');
    } catch (err) {
      log('Error: $err');
    }
  }
}
