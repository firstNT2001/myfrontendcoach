import 'package:flutter/material.dart';

import 'login.dart';

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
     
    );
  }
}