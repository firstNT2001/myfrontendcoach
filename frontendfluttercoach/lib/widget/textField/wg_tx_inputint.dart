import 'package:flutter/material.dart';

class WidgetInputnum extends StatefulWidget {
  const WidgetInputnum({super.key, required this.controller, required this.labelText, required this.maxLength});
    final TextEditingController controller;
  final String labelText;
  final int maxLength;

  @override
  State<WidgetInputnum> createState() => _WidgetInputnumState();
}

class _WidgetInputnumState extends State<WidgetInputnum> {
    @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text(widget.labelText, style: Theme.of(context).textTheme.bodyLarge,),
          ),
          TextField(
              keyboardType: TextInputType.number,
              controller: widget.controller,
              style: Theme.of(context).textTheme.bodyLarge,
              maxLength: widget.maxLength,
      
              //inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                   counterText: "",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }
  
}