import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomeFoodAndClipPage extends StatefulWidget {
   HomeFoodAndClipPage({super.key, required this.did, required this.sequence});
  late String did;
   late String sequence;
  @override
  State<HomeFoodAndClipPage> createState() => _HomeFoodAndClipPageState();
}

class _HomeFoodAndClipPageState extends State<HomeFoodAndClipPage> {
  @override
  Widget build(BuildContext context) {
    
    return  Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        iconTheme: const IconThemeData(
          color: Colors.black, //change your color here
        ),
        title:  Text("Day ${widget.sequence}"),
        centerTitle: true,
      ),
      body: SafeArea(child: Column(children: [Text(widget.did)],)),
    );
  }
}