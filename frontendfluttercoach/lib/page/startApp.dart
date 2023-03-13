import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/homepageUser.dart';

import 'coach/Homepagecoach.dart';

class StartApp extends StatelessWidget {
  const StartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: SizedBox(
                height: 150,
                width: 300,
                child: Container(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return HomePageCoach();
                        }));
                      },
                      child: Text('หน้าโค้ช')),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 150,
                width: 300,
              child: Container(
                margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) {
                        return HomePageUser();
                      }));
                    },
                    child: Text('หน้าสมาชิก')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
