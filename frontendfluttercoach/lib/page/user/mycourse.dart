
import 'package:flutter/material.dart';

class MyCouses extends StatefulWidget {
  const MyCouses({super.key});

  @override
  State<MyCouses> createState() => _MyCousesState();
}

class _MyCousesState extends State<MyCouses> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("รายการซื้อของฉัน"),),
    );
  }
}