import 'dart:convert';
import 'dart:developer';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../../../../model/request/clip_dayID_post.dart';
import '../../../../../../model/response/md_ClipList_get.dart';
import '../../../../../../model/response/md_Result.dart';
import '../../../../../../service/clip.dart';
import '../../../../../../service/provider/appdata.dart';
import '../../course_food_clip.dart';

class ClipInsertPage extends StatefulWidget {
   const ClipInsertPage({super.key, required this.did, required this.modelClipList, required this.increaseClip,required this.isVisible});
  //id Day
  final  String did;
  //Food
  final  List<ListClip> modelClipList;
  final  List<ClipDayIdPost> increaseClip;

  final bool isVisible;
  @override
  State<ClipInsertPage> createState() => _ClipInsertPageState();
}

class _ClipInsertPageState extends State<ClipInsertPage> {

  // FoodService
  late ClipServices _clipCourseService;
  late ModelResult modelResult;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _clipCourseService = context.read<AppData>().clipServices;
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: const Text('เลือกมื้ออาหาร'),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          Expanded(child: showFood()),
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            decoration:  BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    color: Colors.grey,
                    blurRadius: 5.0, // Soften the shaodw
                    spreadRadius: 1.0,
                    offset: Offset(0.0, 0.0),
                  )
                ],
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15)),
                color: Theme.of(context).colorScheme.primary),
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
                            child: ElevatedButton(
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
                                    Get.to(() => HomeFoodAndClipPage(
                                          did: widget.did,
                                          sequence:
                                              context.read<AppData>().sequence, isVisible: widget.isVisible,
                                        ));
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

  ListView showFood() {
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
                  // if (clips.video != '') ...{
                  //   Padding(
                  //     padding:
                  //         const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                  //     child: Container(
                  //         width: MediaQuery.of(context).size.width * 0.25,
                  //         height: MediaQuery.of(context).size.height,
                  //         decoration: BoxDecoration(
                  //           borderRadius: BorderRadius.circular(26),
                  //           image: DecorationImage(
                  //             image: NetworkImage(clips.image),
                  //           ),
                  //         )),
                  //   ),
                  // } else
                  //   Padding(
                  //     padding:
                  //         const EdgeInsets.only(left: 8, top: 5, bottom: 5),
                  //     child: Container(
                  //         width: MediaQuery.of(context).size.width * 0.25,
                  //         height: MediaQuery.of(context).size.height,
                  //         decoration: BoxDecoration(
                  //             borderRadius: BorderRadius.circular(26),
                  //             color: Colors.black26)),
                  //   ),
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