import 'package:flutter/material.dart';

class WidgetTextFieldString extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const WidgetTextFieldString(
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
