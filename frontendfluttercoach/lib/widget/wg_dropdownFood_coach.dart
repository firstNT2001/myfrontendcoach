import 'dart:developer';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:frontendfluttercoach/model/response/md_FoodList_get.dart';

class WidgetDropdownFoodInCoach extends StatefulWidget {
   WidgetDropdownFoodInCoach({super.key, required this.selectedValue, required this.ModelfoodCoachs, required this.numberFoods});
  late TextEditingController selectedValue;
  late int numberFoods;
  late List<String> ModelfoodCoachs;
  @override
  State<WidgetDropdownFoodInCoach> createState() => _WidgetDropdownFoodInCoachState();
}

class _WidgetDropdownFoodInCoachState extends State<WidgetDropdownFoodInCoach> {
  @override
  Widget build(BuildContext context) {
    return DropdownFoodInCoach();
  }
  // ignore: non_constant_identifier_names
  DropdownButtonFormField2<Object> DropdownFoodInCoach() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: const Text(
        'เลือกเมนูอาหาร',
        style: TextStyle(fontSize: 14),
      ),
      value: widget.selectedValue.text,
      items: widget.ModelfoodCoachs
          .map((item) => DropdownMenuItem<String>(
                value: item,
                child: Text(
                  item,
                  style: const TextStyle(
                    fontSize: 14,
                  ),
                ),
              ))
          .toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select Level.';
        }
        return null;
      },
      onChanged: (value) {
        //Do something when changing the item if you want.
        widget.selectedValue.text = value.toString();
        //log(widget.selectedValue.text);
      },
      onSaved: (value) {
        // widget.selectedValue.text = value.toString();
        // log(widget.selectedValue.text);
      },
      buttonStyleData: const ButtonStyleData(
        height: 39,
        padding: EdgeInsets.only(left: 0, right: 5),
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
          color: Colors.black45,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }
}
