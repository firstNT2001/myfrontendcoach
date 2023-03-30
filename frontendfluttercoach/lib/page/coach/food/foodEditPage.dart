import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/provider/listFood.dart';

class FoodEditPage extends StatefulWidget {
  const FoodEditPage({super.key});

  @override
  State<FoodEditPage> createState() => _FoodEditPageState();
}

class _FoodEditPageState extends State<FoodEditPage> {
  int ifid = 0;
  int cid = 0;
  @override
  void initState() {
    super.initState();
    ifid = context.read<ListFoodData>().ifid;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(100.0),
              child: Text(ifid.toString()),
            )
          ],
        ),
      ),
    );
  }
}