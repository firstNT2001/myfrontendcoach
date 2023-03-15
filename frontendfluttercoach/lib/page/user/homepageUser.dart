import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/modelCoach.dart';
import 'package:provider/provider.dart';
import 'package:retrofit/dio.dart';
import 'dart:developer';
import '../../service/coach.dart';
import '../../service/provider/appdata.dart';

class HomePageUser extends StatefulWidget {
  const HomePageUser({super.key});

  @override
  State<HomePageUser> createState() => _HomePageUserState();
}

class _HomePageUserState extends State<HomePageUser> {
  late CoachService coachService;
  HttpResponse<List<Coach>>? coaches;
  TextEditingController myController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    coachService =
        CoachService(Dio(), baseUrl: context.read<AppData>().baseurl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("tesr"),
      ),
      body: Column(
        children: [
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 250,
                      height: 50,
                      child: Expanded(
                          child: TextField(
                        controller: myController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'ค้นหา',
                        ),
                      )),
                    ),
                    ElevatedButton(
                        onPressed: () {
                          if (myController.text.isNotEmpty) {
                            coachService
                                .getNameCoach(myController.text)
                                .then((data) {
                              coaches = data;
                              if (coaches != null) {
                                setState(() {});
                                log(coaches!.data.length.toString());
                              }
                            });
                          }
                        },
                        child: Text("แสดงชื่อโค้ช")),
                  ],
                ),
              ),
            ),
          ),
          (coaches != null)? 
          Expanded( 
                  child: Container(            
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder( 
                        itemCount: coaches!.data.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Text(coaches!.data[index].username),
                                Text(coaches!.data[index].fullName)
                              ],
                            ),
                                  
                          );
                        },
                      ),
                    ),
                  ),
                )
              : Container(color: Colors.amber),
        ],
      ),
    );
  }
}
