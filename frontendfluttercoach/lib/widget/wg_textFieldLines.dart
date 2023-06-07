import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class WidgetTextFieldLines extends StatelessWidget {
   WidgetTextFieldLines(
      {super.key, required this.controller, required this.labelText});

  late TextEditingController controller;
  late String labelText;

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        textAlignVertical: TextAlignVertical.center,
        textAlign: TextAlign.center,
        minLines: 1,
        maxLines: 20,
        decoration: InputDecoration(
            border: OutlineInputBorder(),
            labelText: labelText,
            filled: true,
            fillColor: Theme.of(context).colorScheme.background));
  }
}
