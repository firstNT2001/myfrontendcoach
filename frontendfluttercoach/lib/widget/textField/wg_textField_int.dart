import 'package:flutter/material.dart';

class WidgetTextFieldIntnotmax extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const WidgetTextFieldIntnotmax(
      {super.key, required this.controller, required this.labelText});

  @override
  State<WidgetTextFieldIntnotmax> createState() => _WidgetTextFieldIntnotmax();
}

class _WidgetTextFieldIntnotmax extends State<WidgetTextFieldIntnotmax> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.labelText, style: Theme.of(context).textTheme.bodyLarge,),
          TextField(
            keyboardType: TextInputType.number,
              controller: widget.controller, style: Theme.of(context).textTheme.bodyLarge,
              
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  //labelText: widget.labelText,
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }
}
