

import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:provider/provider.dart';

import '../../service/course.dart';
import '../../service/provider/appdata.dart';

class ProfileCoachPage extends StatefulWidget {
  const ProfileCoachPage({super.key});

  @override
  State<ProfileCoachPage> createState() => _ProfileCoachPageState();
}

class _ProfileCoachPageState extends State<ProfileCoachPage> {
  late CourseService courseService;
  int cidCoach = 0;
  String qualificationCoach = "";
  String fullnameCoach = "";
  String userNameCoach = " ";
  String propertyC = " ";
 
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cidCoach = context.read<AppData>().cid ;
    fullnameCoach = context.read<AppData>().nameCoach ;
    qualificationCoach = context.read<AppData>().qualification;
    userNameCoach = context.read<AppData>().usercoach;
    propertyC = context.read<AppData>().propertycoach;
    //couse
    courseService =
        CourseService(Dio(), baseUrl: context.read<AppData>().baseurl);
    log("AAAA : "+cidCoach.toString());
    log("BBB : "+qualificationCoach);
    log("CCC : "+fullnameCoach);
    log("DDD : "+ userNameCoach);
    log("EEE : "+ propertyC);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("test"),
        
      ),body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      Text(cidCoach.toString()),
                      Text(userNameCoach),
                      Text(fullnameCoach),
                      Text(qualificationCoach),
                      Text(propertyC),
                                                                
                    ],
                  ),
                ),
              ],
              ),
          ),
          
        ],
      ),
      
    );
  }
}
