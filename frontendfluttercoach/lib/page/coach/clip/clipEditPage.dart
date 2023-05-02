import 'package:flutter/material.dart';

class ClipEditPage extends StatefulWidget {
  late int icpId;
   ClipEditPage({super.key,required this.icpId});

  @override
  State<ClipEditPage> createState() => _ClipEditPageState();
}

class _ClipEditPageState extends State<ClipEditPage> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(100.0),
            child: Text(widget.icpId.toString()),
          ),
        ],
      ),
    );
  }
}