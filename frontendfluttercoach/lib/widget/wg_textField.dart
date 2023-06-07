import 'package:flutter/material.dart';

class WidgetTextFieldString extends StatefulWidget {
  late TextEditingController controller;
  late String labelText;
  WidgetTextFieldString(
      {super.key, required this.controller, required this.labelText});

  @override
  State<WidgetTextFieldString> createState() => _WidgetTextFieldStringState();
}

class _WidgetTextFieldStringState extends State<WidgetTextFieldString> {
  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: widget.controller,
        //autofocus: true,
        // onChanged: (String value) {
        //   setState(() => chackNameAndPassword = "");
        // },
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
            labelText: widget.labelText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.background));
  }
}
