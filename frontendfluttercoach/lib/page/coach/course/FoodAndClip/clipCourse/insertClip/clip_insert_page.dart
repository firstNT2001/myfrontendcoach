import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../../../../../../model/request/clip_dayID_post.dart';
import '../../../../../../model/response/md_ClipList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../service/clip.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../../../../../widget/image_video.dart';
import '../../course_food_clip.dart';

class ClipInsertPage extends StatefulWidget {
  const ClipInsertPage(
      {super.key,
      required this.did,
      required this.modelClipList,
      required this.increaseClip,
      required this.isVisible});
  //id Day
  final String did;
  //Food
  final List<ListClip> modelClipList;
  final List<ClipDayIdPost> increaseClip;

  final bool isVisible;
  @override
  State<ClipInsertPage> createState() => _ClipInsertPageState();
}

class _ClipInsertPageState extends State<ClipInsertPage> {
  // FoodService
  late ClipServices _clipCourseService;
  late ModelResult modelResult;
  bool _enabled = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clipCourseService = context.read<AppData>().clipServices;
    Future.delayed(Duration(seconds: context.read<AppData>().duration), () {
      setState(() {
        _enabled = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return (_enabled == true)
        ? Skeletonizer(
            enabled: true,
            child: scaffold(context),
          )
        : scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('เพิ่มคลิป'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: showClips()),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration: const BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0, // Soften the shaodw
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Colors.white),
            child: SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 18, right: 18, bottom: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'จำนวนคลิปทั้งหมด',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            Text(
                              widget.modelClipList.length.toString(),
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 18, right: 18),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: FilledButton(
                                onPressed: () async {
                                  log(jsonEncode(widget.increaseClip));

                                  //loop insertClip in list
                                  for (var index in widget.increaseClip) {
                                    log('id :${index.listClipId}');
                                    var response = await _clipCourseService
                                        .insertClipByDayID(widget.did, index);
                                    modelResult = response.data;
                                  }
                                  log("result:${modelResult.result}");
                                  if (modelResult.result == '1') {
                                    widget.increaseClip.clear();
                                    // ignore: use_build_context_synchronously
                                    Navigator.pushAndRemoveUntil<void>(
                                      context,
                                      MaterialPageRoute<void>(
                                          builder: (BuildContext context) =>
                                              HomeFoodAndClipPage(
                                                did: widget.did,
                                                sequence: context
                                                    .read<AppData>()
                                                    .sequence,
                                                isVisible: widget.isVisible,
                                              )),
                                      ModalRoute.withName('/DaysCoursePage'),
                                    );
                                  } else {
                                    // ignore: use_build_context_synchronously
                                    CherryToast.warning(
                                      title: const Text('บันทึกไม่สำเร็จ'),
                                      displayTitle: false,
                                      description:
                                          const Text('บันทึกไม่สำเร็จ'),
                                      toastPosition: Position.bottom,
                                      animationDuration:
                                          const Duration(milliseconds: 1000),
                                      autoDismiss: true,
                                    ).show(context);
                                  }
                                },
                                child: const Text('บันทึก'))),
                      )
                    ])),
          )
        ],
      )),
    );
  }

  ListView showClips() {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: widget.modelClipList.length,
      itemBuilder: (context, index) {
        var clips = widget.modelClipList[index];
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Card(
            //color: colorFood[index],
            elevation: 1000,
            child: InkWell(
              onTap: () {
                setState(() {});
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (clips.video != '') ...{
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: AspectRatio(
                          aspectRatio: 16 / 16,
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26),
                            ),
                            child: VideoItem(
                              video: clips.video,
                            ),
                          )),
                    )
                  } else
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 5, bottom: 5),
                      child: AspectRatio(
                          aspectRatio: 16 / 16,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 207, 208, 209),
                              borderRadius: BorderRadius.circular(20),
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
                          clips.name,
                          maxLines: 5,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // SizedBox(
                      //   width: MediaQuery.of(context).size.width * 0.4,
                      //   child: AutoSizeText(
                      //     'Calories: ${clips.calories.toString()}',
                      //     maxLines: 5,
                      //     style: Theme.of(context).textTheme.bodyLarge,
                      //   ),
                      // ),
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
}
