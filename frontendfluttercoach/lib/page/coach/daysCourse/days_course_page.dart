import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../service/provider/dayOfCouseData.dart';

class DaysCoursePage extends StatefulWidget {
  const DaysCoursePage({super.key});

  @override
  State<DaysCoursePage> createState() => _DaysCoursePageState();
}

class _DaysCoursePageState extends State<DaysCoursePage> {
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