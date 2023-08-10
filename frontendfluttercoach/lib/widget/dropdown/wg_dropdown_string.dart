import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';


class WidgetDropdownString extends StatefulWidget {
   const WidgetDropdownString({super.key, required this.title, required this.selectedValue, required this.listItems});
  final String title;
  final TextEditingController  selectedValue;
  final List<String> listItems; 
  @override
  State<WidgetDropdownString> createState() => _WidgetDropdownStringState();
}

class _WidgetDropdownStringState extends State<WidgetDropdownString> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 3),
          child: Text(widget.title,style: Theme.of(context).textTheme.bodyLarge),
        ),
        DropdownLavel(),
      ],
    );
  }
  // ignore: non_constant_identifier_names
  DropdownButtonFormField2<String> DropdownLavel() {
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 2),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint:  Text(
        widget.title,
        style:Theme.of(context).textTheme.bodyLarge,
      ),
      value: widget.selectedValue.text,style: Theme.of(context).textTheme.bodyLarge,
      items: widget.listItems.map((item) => DropdownMenuItem<String>(
            value: item,
            child: Text(
              item,
              style: Theme.of(context).textTheme.bodyLarge
            ),
          )).toList(),
      validator: (value) {
        if (value == null) {
          return 'Please select ${widget.title}.';
        }
        return null;
      },
      onChanged: (value) {
        //Do something when changing the item if you want.
         widget.selectedValue.text = value.toString();
      },
      onSaved: (value) {
        // widget.selectedValue = value.toString();
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