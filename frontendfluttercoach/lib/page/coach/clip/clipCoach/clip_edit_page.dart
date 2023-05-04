import 'package:flutter/material.dart';

class ClipEditCoachPage extends StatefulWidget {
  late int icpId;
   ClipEditCoachPage({super.key,required this.icpId});

  @override
  State<ClipEditCoachPage> createState() => _ClipEditCoachPageState();
}

class _ClipEditCoachPageState extends State<ClipEditCoachPage> {
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