import 'package:flutter/material.dart';

class editProfileCus extends StatefulWidget {
  const editProfileCus({super.key});

  @override
  State<editProfileCus> createState() => _editProfileCusState();
}

class _editProfileCusState extends State<editProfileCus> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("แก้ไข"),),
    );
  }
}