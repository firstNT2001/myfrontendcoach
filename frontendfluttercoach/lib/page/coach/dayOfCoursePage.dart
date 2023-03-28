import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/provider/dayOfCouseData.dart';

class DayOfCoursePage extends StatefulWidget {
  const DayOfCoursePage({super.key});

  @override
  State<DayOfCoursePage> createState() => _DayOfCoursePageState();
}

class _DayOfCoursePageState extends State<DayOfCoursePage> {
  int did = 0;
  @override
  void initState() {
    super.initState();
    did = context.read<DayOfCourseData>().didDayOfCouse;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(did.toString()),
          ),
        ]),
      ),
    );
  }
}