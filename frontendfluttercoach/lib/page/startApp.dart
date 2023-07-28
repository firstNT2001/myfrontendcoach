import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/page/user/homepage/homepageUser.dart';
import 'package:frontendfluttercoach/page/auth/login.dart';
import 'package:get/get.dart';


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
                  margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return const LoginPage();
                        }));
                      },
                      child: const Text('หน้าโค้ช')),
                ),
              ),
            ),
          ),
          Center(
            child: SizedBox(
              height: 150,
                width: 300,
              child: Container(
                margin: const EdgeInsets.only(left: 20, right: 20, top: 20),
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: ElevatedButton(
                    onPressed: () {
                      Get.to(()=> const HomePageUser());
                      // Navigator.push(context, MaterialPageRoute(builder: (context) {
                      //   return HomePageUser();
                      // }));
                    },
                    child: const Text('หน้าสมาชิก')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
