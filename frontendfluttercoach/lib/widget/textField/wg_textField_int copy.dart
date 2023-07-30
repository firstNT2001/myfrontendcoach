import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WidgetTextFieldInt extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLength;
  const WidgetTextFieldInt(
      {super.key,
      required this.controller,
      required this.labelText,
      required this.maxLength});

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
            maxLength: widget.maxLength,
            //inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
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
