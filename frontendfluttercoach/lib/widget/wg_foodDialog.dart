import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:frontendfluttercoach/widget/wg_dropdown_string.dart';

//มืออาหาร
  final selectedValuehand = TextEditingController();
  final List<String> listhand = ['มื้อเช้า', 'มื้อเที่ยง', 'มื้อเย็น'];

void foodDialog(BuildContext context, String image, String name, String meal) {
  
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
      height: MediaQuery.of(context).size.height * 0.6,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).colorScheme.primaryContainer,
      ),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        //crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding:
                const EdgeInsets.only(left: 20, right: 20, top: 50, bottom: 16),
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
          Text(name,style: Theme.of(context).textTheme.bodyMedium,),
          const SizedBox(height: 16,),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 20,bottom: 10),
                child: SizedBox(
                  width: 150,
                  //height: 200,
                  child: WidgetDropdownString(
                      title: 'เลือกมืออาหาร',
                      selectedValue: selectedValuehand,
                      ListItems: listhand,
                    ),
                ),
              ),
            ],
          ),
          Row(
            //mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                  child: Text("เปลี่ยนเมนู")),
              FilledButton(
                  onPressed: () {
                    SmartDialog.dismiss();
                  },
                  child: Text("ตกลง"))
            ],
          ),
        ],
      ),
    );
  });
}
