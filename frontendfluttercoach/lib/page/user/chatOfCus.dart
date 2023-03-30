import 'package:flutter/material.dart';

class chatOfCustomer extends StatefulWidget {
  const chatOfCustomer({super.key});

  @override
  State<chatOfCustomer> createState() => _chatOfCustomerState();
}

class _chatOfCustomerState extends State<chatOfCustomer> {
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(title: Text("แชท"),),
    );
  }
}