import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontendfluttercoach/widget/showCilp.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../model/response/md_ClipList_get.dart';
import '../page/coach/course/FoodAndClip/clipCourse/editClip/clip_edit_select.dart';

void dialogClipEditInCourse(BuildContext context, ListClip listClip, String cpID, String did, String sequence, int status, bool isVisible) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.83,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 0),
              child: Text("คลิปท่าออกกำลังกาย",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            if (listClip.video != '') ...{
              WidgetShowCilp(urlVideo: listClip.video),
            } else ...{
              Container(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: MediaQuery.of(context).size.height * 0.3,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(26),
                      color: Theme.of(context).colorScheme.primary)),
              const SizedBox(
                height: 8,
              ),
            },
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: AutoSizeText(
                  'ชื่อคลิป: ${listClip.name}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.75,
                child: AutoSizeText(
                  'รายละเอียด: ${listClip.details}',
                  maxLines: 5,
                  //style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ),
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: Text(
                  'จำนวนเซ็ท: ${listClip.amountPerSet.toString()}',
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              //MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 30),
                  child: ElevatedButton(
                      onPressed: () {
                        Get.to(() =>  ClipEditSelectPage(cpID: cpID, did: did, sequence: sequence, status: status, isVisible: isVisible,));
                      },
                      child: const Text('เปลี่ยนคลิป')),
                ),
              ],
            )
          ],
        ),
      );
    });
  }