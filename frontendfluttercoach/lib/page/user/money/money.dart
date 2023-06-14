import 'package:flutter/material.dart';

class addCoin extends StatefulWidget {
  const addCoin({super.key});

  @override
  State<addCoin> createState() => _addCoinState();
}

class _addCoinState extends State<addCoin> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("เติมเงิน"),),
      body: Column(
        children: [
          Text("กรุณาใส่จำนวนเงิน"),
          TextFormField()
          
        ],
      ),
    );}
}