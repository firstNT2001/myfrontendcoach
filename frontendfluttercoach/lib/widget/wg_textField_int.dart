import 'package:flutter/material.dart';

class WidgetTextFieldInt extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  const WidgetTextFieldInt(
      {super.key, required this.controller, required this.labelText});

  @override
  State<WidgetTextFieldInt> createState() => _WidgetTextFieldIntState();
}

class _WidgetTextFieldIntState extends State<WidgetTextFieldInt> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.labelText),
        TextField(
          keyboardType: TextInputType.number,
            controller: widget.controller,
            
            textAlignVertical: TextAlignVertical.center,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
                //labelText: widget.labelText,
                filled: true,
                fillColor: Theme.of(context).colorScheme.background)),
      ],
    );
  }
}
