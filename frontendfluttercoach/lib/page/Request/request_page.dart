import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';

class RequestPage extends StatefulWidget {
  const RequestPage({super.key});

  @override
  State<RequestPage> createState() => _RequestPageState();
}

class _RequestPageState extends State<RequestPage> {
  String cid = "";
  @override
  void initState() {
    // TODO: implement initState
    cid = context.read<AppData>().cid.toString(); //ID Course

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title: const Text("Notification"),
        centerTitle: true,
      ),
      body: SafeArea(
          child: Column(
        children: [
          
        ],
      )),
    );
  }
}
