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
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 3),
          child: Text(labelText,style: Theme.of(context).textTheme.bodyLarge,),
        ),
        TextField(
            controller: controller,style: Theme.of(context).textTheme.bodyLarge,
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            minLines: 1,
            maxLines: 20,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                filled: true,
                fillColor: Theme.of(context).colorScheme.background)),
      ],
    );
  }
}
