import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:string_validator/string_validator.dart';

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
  late   bool isValidw;
  late   bool isValidh;
    bool _isvisibleHW = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text(
              widget.labelText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              controller: widget.controller,
              validator: (value) {
                isValidw = isNumeric(value!); // false
                log(isValidw.toString());
                if (isValidw == true) {
                  log("BB");
                } else {
                  log("FF");
                  setState(() {
                    _isvisibleHW = true;
                    log("PP");
                  });
                }

                return null;
              },
              maxLength:  widget.maxLength,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  counterText: "",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
          // TextField(
          //     keyboardType: TextInputType.number,
          //     controller: widget.controller,
          //     style: Theme.of(context).textTheme.bodyLarge,
          //     maxLength: widget.maxLength,

          //     //inputFormatters: [LengthLimitingTextInputFormatter(widget.maxLength)],
          //     textAlignVertical: TextAlignVertical.center,
          //     textAlign: TextAlign.center,
          //     decoration: InputDecoration(
          //         contentPadding:
          //             EdgeInsets.symmetric(vertical: 9, horizontal: 12),
          //         counterText: "",
          //         filled: true,
          //         fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }
}
