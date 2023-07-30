import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';

class WidgetTextFieldLines extends StatelessWidget {
   const WidgetTextFieldLines(
      {super.key, required this.controller, required this.labelText});

  final TextEditingController controller;
  final String labelText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(labelText),
        TextField(
            controller: controller,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                //labelText: labelText,
                filled: true,
                fillColor: Theme.of(context).colorScheme.background)),
      ],
    );
  }
}
