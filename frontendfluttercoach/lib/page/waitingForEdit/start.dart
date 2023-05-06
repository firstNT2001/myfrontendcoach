import 'package:flutter/material.dart';

import '../auth/login.dart';

class pageStart extends StatefulWidget {
  const pageStart({super.key});

  @override
  State<pageStart> createState() => _pageStartState();
}

class _pageStartState extends State<pageStart> {
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/Bg0.png'
          ),
          fit: BoxFit.cover
          )

      ),
      
      margin: const EdgeInsets.all(5),
      width: double.infinity,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Color.fromARGB(255, 10, 10, 10),
          ),
          child: Text(
            'เริ่มต้น',
            style: TextStyle(
            color: Color.fromARGB(255, 255, 255, 255),
          ),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return LoginPage();
            })
            );
          },
          ),
    );
  }
}