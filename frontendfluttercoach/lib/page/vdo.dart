import 'package:flutter/material.dart';

class PlayVdoPage extends StatefulWidget {
  const PlayVdoPage({super.key});

  @override
  State<PlayVdoPage> createState() => _PlayVdoPageState();
}

class _PlayVdoPageState extends State<PlayVdoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("เล่นวิดีโอ"),
      ),
    );
  }
}