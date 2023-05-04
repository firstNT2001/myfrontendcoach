import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/response/md_ClipList_get.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';


import '../../../../service/listClip.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';
import 'clip_edit_page.dart';

class ClipCoachPage extends StatefulWidget {
  const ClipCoachPage({super.key});

  @override
  State<ClipCoachPage> createState() => _ClipCoachPageState();
}

class _ClipCoachPageState extends State<ClipCoachPage> {
  String cid = "";
  late Future<void> loadDataMethod;
  late ListClipServices _listclipService;
  List<ModelClipList> clips = [];
  @override
  void initState() {
    super.initState();
    cid = context.read<CoachData>().cid.toString();
    _listclipService = context.read<AppData>().listClipServices;
    loadDataMethod = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: loadDataMethod, // 3.1 object ของ async method
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  (clips != null)
                      ? Expanded(
                          child: ListView.builder(
                            itemCount: clips.length,
                            itemBuilder: (context, index) {
                              return Container(
                                padding: const EdgeInsets.only(
                                    top: 8, left: 5, right: 5),
                                child: Card(
                                    child: ListTile(
                                  title: Text(clips[index].name),
                                  //subtitle: Text("Calories : "+clips[index]..toString()),
                                  //leading: Image.network(foods[index].image),
                                  onTap: () {
                                    // log(foods[index].ifid.toString());

                                    Get.to(() => ClipEditCoachPage(
                                          icpId: clips[index].icpId,
                                        ));
                                  },
                                )),
                              );
                            },
                          ),
                        )
                      : Container(),
                ],
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Future<void> loadDataAsync() async {
    try {
      var res = await _listclipService.listClips(cid: cid, icpID: '', name: '');
      clips = res.data;

      // name.text = foods.name;
    } catch (err) {
      log('Error: $err');
    }
  }
}
