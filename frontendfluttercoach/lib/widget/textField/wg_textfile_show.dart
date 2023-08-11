import 'package:flutter/material.dart';

class WidgetTextFieldStringShow extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const WidgetTextFieldStringShow(
      {super.key, required this.controller, required this.labelText});

  @override
  State<WidgetTextFieldStringShow> createState() => _WidgetTextFieldStringShowState();
}

class _WidgetTextFieldStringShowState extends State<WidgetTextFieldStringShow> {
  @override
  Widget build(BuildContext context) {
    return Padding(
       padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text(widget.labelText,style: Theme.of(context).textTheme.bodyLarge,),
          ),
          TextField(
              controller: widget.controller,style: Theme.of(context).textTheme.bodyLarge,
              readOnly: true,
              
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  //labelText: widget.labelText,
                  contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
              border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }
}
