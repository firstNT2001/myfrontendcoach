

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:provider/provider.dart';

import '../../service/provider/appdata.dart';

class ProfileCoachPage extends StatefulWidget {
  const ProfileCoachPage({super.key});

  @override
  State<ProfileCoachPage> createState() => _ProfileCoachPageState();
}

class _ProfileCoachPageState extends State<ProfileCoachPage> {
  int cidCoach = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cidCoach = context.read<AppData>().cid ;
    log("AAAA : "+cidCoach.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
      ),
    );
  }
}
