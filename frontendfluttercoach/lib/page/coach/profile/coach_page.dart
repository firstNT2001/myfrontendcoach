import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Coach_get.dart';
import '../../../service/coach.dart';
import '../../../service/provider/appdata.dart';
import 'coach_editProfile.dart';

class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage> {
  // Courses
  late Future<void> loadCoachDataMethod;
  late CoachService _coachService;
  List<Coach> coachs = [];

  @override
  void initState() {
    super.initState();
    _coachService = context.read<AppData>().coachService;
    loadCoachDataMethod = loadCoachData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [Expanded(child: showCoach())],
      )),
    );
  }

  //LoadData
  Future<void> loadCoachData() async {
    try {
      //Courses
      var datas = await _coachService.coach(
          nameCoach: '', cid: context.read<AppData>().cid.toString());
      coachs = datas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showCoach() {
    return FutureBuilder(
        future: loadCoachDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ignore: unnecessary_null_comparison
                if (coachs.first.cid != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 25, top: 30),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              minRadius: 35,
                              maxRadius: 55,
                              backgroundImage: NetworkImage(coachs.first.image),
                            ),
                            Column(
                              children: [
                                Text("@ ${coachs.first.username}"),
                                Padding(
                                  padding: const EdgeInsets.only(left: 30),
                                  child: Text(coachs.first.fullName),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 50),
                              child: InkWell(
                                onTap: () {
                                  // //1. ส่งตัวแปรแบบconstructure
                                  Get.to(() =>  const CoachEidtProfilePage());
                                },
                                child: const Icon(
                                  Icons.edit_outlined,
                                  color: Colors.black,
                                  size: 28,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.email,
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(coachs.first.fullName),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.phone,
                                    color: Colors.green,
                                    size: 24.0,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 18),
                                    child: Text(coachs.first.phone),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Card(
                          child: SizedBox(
                            height: 100,
                            width: 200,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("ยอดคงเหลือ"),
                                Text(coachs.first.price.toString())
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  )
              ],
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        });
  }
}
