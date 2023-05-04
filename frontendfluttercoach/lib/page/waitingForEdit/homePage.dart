import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/waitingForEdit/picture.dart';
import 'package:frontendfluttercoach/page/waitingForEdit/vdo.dart';

import 'login.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("HomePage"),
        ),
        body: Column(children: <Widget>[
          const SizedBox(height: 24.0),
          Container(
             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return LoginPage();
                }));
              },
              child: Text('LOGIN & Register ')),
          ),
           Container(
             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child:ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PlayVideoPage();
                }));
              },
              child: Text('อัพโหลดวิดีโอ')),
           ),
           Container(
             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return UploadpicturePage();
                }));
              },
              child: Text('อัพโหลดรูปภาพ')),
           ),
          
         
        ]));
  }
}
