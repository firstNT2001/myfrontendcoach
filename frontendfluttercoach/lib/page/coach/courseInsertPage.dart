import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../service/provider/coachData.dart';

class CourseInsertPage extends StatefulWidget {
  const CourseInsertPage({super.key});

  @override
  State<CourseInsertPage> createState() => _CourseInsertPageState();
}

class _CourseInsertPageState extends State<CourseInsertPage> {
  
  int cid = 0;
  String image = "";
  String status = "";
  String expirationDate = "";
  final _name = TextEditingController();
  final _details = TextEditingController();
  final _level = TextEditingController();
  final _amount = TextEditingController();
  final _days = TextEditingController();
  final _price = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cid = context.read<CoachData>().cid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            //Expanded(child: Image.network(imageCourse)),
              Padding(
                padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
                child: Center(child: textField(_name, "ชื่อ")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: textField(_details, "รายละเอียด")),
              ),
              Padding(
                padding: const  EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: textField(_amount, "จำนวนคน")),
              ),
              Padding(
                padding: const  EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: textField(_level, "ความยาก")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: textField(_price, "ราคา")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: Center(child: textField(_days, "จำนวนวัน")),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
                child: ElevatedButton(
                  //style: style,
                  onPressed: ()  {
                    
                  },
                  child: const Text('Enabled'),
                ),
              ),
          ],
        ),
      ),
    );
  }
  TextField textField(
      final TextEditingController _controller, String textLabel) {
    return TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: textLabel,
        ));
  }
}
