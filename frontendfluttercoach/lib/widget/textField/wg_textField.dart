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
              //autofocus: true,
              // onChanged: (String value) {
              //   setState(() => chackNameAndPassword = "");
              // },
              
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
