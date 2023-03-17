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
  List<Coach> coaches = [];
  //List<Coach> coaches = [];
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
          Padding(
            padding: const EdgeInsets.only(top: 35, left: 15),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 250,
                  height: 50,
                  child: TextField(
                    controller: myController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'ค้นหา',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      onPressed: () {
                        if (myController.text.isNotEmpty) {
                          coachService
                              .getNameCoach(myController.text)
                              .then((data) {
                            var datacoach = data.data;
                            coaches = datacoach;
                            if (coaches != null) {
                              setState(() {});
                              log(coaches.length.toString());
                            }
                          });
                        }
                      },
                      child: Text("แสดงชื่อโค้ช")),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(onPressed: () {}, icon: Icon(Icons.tune_rounded)),
            ],
          ),
          (coaches != null)
              ? Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
                        itemCount: coaches.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Column(
                              children: [
                                Text(coaches[index].username),
                                Text(coaches[index].fullName)
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
