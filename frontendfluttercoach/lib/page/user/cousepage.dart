import 'package:flutter/material.dart';

import '../../model/modelCourse.dart';

class showCousePage extends StatelessWidget {
  final ModelCourse couse;
  const showCousePage({
    Key? key,
    required this.couse,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(couse.name),
      ),
      body: Center(
        child: Column(
          children: [
             Image.network(
              couse.image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Card(
              child: Expanded(child: Text(couse.name)),
            ),
            Card(
              child: Expanded(child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Text(couse.details),
              )),
            ),
          ],
        ),
      ),
    );
  }
}
