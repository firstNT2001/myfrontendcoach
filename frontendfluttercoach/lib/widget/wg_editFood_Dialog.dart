import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../page/coach/course/FoodAndClip/foodCourse/editFood/food_edit_select.dart';

//มืออาหาร
final selectedValuehand = TextEditingController();
final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];

void dialogFoodEditInCourse(BuildContext context, String image, String name,
    String meal, String fid, String did, String sequence, bool isVisible) {
  if (meal == '1') {
    selectedValuehand.text = 'มื้อเช้า';
  } else if (meal == '2') {
    selectedValuehand.text = 'มื้อเที่ยง';
  } else if (meal == '3') {
    selectedValuehand.text = 'มื้อเย็น';
  }

  SmartDialog.show(builder: (_) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.8,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      //lignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (image != '') ...{
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: AspectRatio(
                  aspectRatio: 13 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      image: DecorationImage(
                          image: NetworkImage(image), fit: BoxFit.cover),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
            ),
          } else
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: AspectRatio(
                  aspectRatio: 13 / 9,
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xff7c94b6),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  )),
            ),
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Text(
              "  $name",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          const SizedBox(
            height: 16,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("มื้ออาหาร", style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(
                width: 10,
              ),
              Text(selectedValuehand.text,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
          Visibility(
            visible: isVisible,
            child: Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0, top: 8),
                  child: FilledButton(
                      onPressed: () {
                        SmartDialog.dismiss();

                        // pushNewScreen(
                        //   context,
                        //   screen: FoodEditSelectPage(
                        //     fid: fid,
                        //     did: did,
                        //     sequence: sequence,
                        //     time: meal,
                        //     isVisible: isVisible,
                        //   ),
                        //   withNavBar: true,
                        // );
                        Get.to(() => FoodEditSelectPage(
                              fid: fid,
                              did: did,
                              sequence: sequence,
                              time: meal,
                              isVisible: isVisible,
                            ));
                      },
                      child: const Text("เปลี่ยนเมนู")),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  });
}
