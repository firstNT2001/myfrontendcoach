import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/provider/coachData.dart';

class FoodInsertPage extends StatefulWidget {
  const FoodInsertPage({super.key});

  @override
  State<FoodInsertPage> createState() => _FoodInsertPageState();
}

class _FoodInsertPageState extends State<FoodInsertPage> {
  int cid = 0;

  @override
  void initState() {
    super.initState();
    cid = context.read<CoachData>().cid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Text(cid.toString()),
              ],
            )
          
          )
        ],
      ),
    );
  }
}