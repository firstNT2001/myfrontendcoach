import 'package:flutter/material.dart';

class HomePageCoach extends StatefulWidget {
  const HomePageCoach({super.key});

  @override
  State<HomePageCoach> createState() => _HomePageCoachState();
}

class _HomePageCoachState extends State<HomePageCoach> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Colors.red,
        child: Column(
          children: [
            Container(
              //color: Colors.pink,
              padding: const EdgeInsets.only(top: 50),
              child: SizedBox(
                  height: 200,
                  width: double.infinity,
                  
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(80),
                    ),
                    color: Colors.pink,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Text("ss"),
                        ],
                      ),
                    ),
                  )),
            ),
            
          ],
        ),
      ),
    );
  }
}
