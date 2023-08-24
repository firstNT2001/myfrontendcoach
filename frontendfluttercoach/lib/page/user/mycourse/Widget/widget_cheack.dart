import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/request/status_clip.dart';
import '../../../../model/response/clip_get_res.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/clip.dart';
import '../../../../service/course.dart';
import '../../../../service/provider/appdata.dart';

class WidgetCheack extends StatefulWidget {
  WidgetCheack({super.key, required this.dayID});
  late String dayID;
  @override
  State<WidgetCheack> createState() => _WidgetCheackState();
}

class _WidgetCheackState extends State<WidgetCheack> {
  late CourseService courseService;
  late ClipServices clipServices;
  List<ModelClip> clips = [];
  late ModelResult moduleResult;
  late bool FT;
  List<bool> isChecked = [];
  String status = "";
  var update;
  late Future<void> loadDataMethod;
  @override
  void initState() {
    super.initState();
    clipServices =
        ClipServices(Dio(), baseUrl: context.read<AppData>().baseurl);
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return loadcheckbox();
  }

  Future<void> loadData() async {
    try {
      var dataclip =
          await clipServices.clips(cpID: '', icpID: '', did: widget.dayID);
      clips = dataclip.data;
      for (int i = 0; i < clips.length; i++) {
        if (clips[i].status.isNotEmpty) {
          log("A");
          if (clips[i].status == '1') {
            FT = true;
            log("B");
          } else {
            FT = false;
            log("C");
          }
        } else {
          FT = false;
        }
        isChecked.add(FT);
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget loadcheckbox() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return ListView.builder(
                shrinkWrap: true,
                itemCount: clips.length,
                itemBuilder: (context, index) {
                  final listclip = clips[index];
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Checkbox(
                        value: isChecked[index],
                        onChanged: (bool? value) async {
                          setState(() {
                            isChecked[index] = value!;
                          });
                          log(listclip.cpId.toString());
                          String cpID = listclip.cpId.toString();

                          StatusClip updateStatusClip =
                              StatusClip(status: status);
                          log(jsonEncode(updateStatusClip));
                          update = await courseService.updateStatusClip(
                              cpID, updateStatusClip);
                          moduleResult = update.data;
                          log(moduleResult.result);
                        },
                      ),
                      const Text(
                        "ออกกำลังกายแล้ว",
                        style: TextStyle(fontSize: 17.0),
                      ),
                    ],
                  );
                });
          }
        });
  }
}
