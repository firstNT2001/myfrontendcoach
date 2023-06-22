import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/mycourse.Detaildart/myClipinCourse/widget_loadcilcp.dart';
import 'package:provider/provider.dart';

import '../../../../model/response/clip_get_res.dart';
import '../../../../service/clip.dart';
import '../../../../service/provider/appdata.dart';

class showCilp extends StatefulWidget {
  const showCilp({super.key});

  @override
  State<showCilp> createState() => _showCilpState();
}

class _showCilpState extends State<showCilp> {
  late ClipServices clipServices;
  List<ModelClip> clips = [];
  late Future<void> loadDataMethod;
  int did = 0;
  //video

  late String videoUrl = "";
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  final CustomVideoPlayerSettings _customVideoPlayerSettings =
      const CustomVideoPlayerSettings();
  void initState() {
    // TODO: implement initState
    super.initState();
    did = context.read<AppData>().did;

    clipServices =
        ClipServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  void dispose() {
    _customVideoPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Flex(
      direction: Axis.horizontal,
      children: [
        Expanded(
          child: loadclips(),
        ),
      ],
    ));
  }

  Future<void> loadData() async {
    try {
      var dataclip =
          await clipServices.clips(cpID: '', icpID: '', did: did.toString());
      clips = dataclip.data;
      //log('clips leng: ${clips.first.listClip.video}');
    } catch (err) {
      log('Error: $err');
    }
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
}
