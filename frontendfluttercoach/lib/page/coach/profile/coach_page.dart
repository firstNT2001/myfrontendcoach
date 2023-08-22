import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/response/md_Coach_get.dart';
import '../../../service/coach.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textfile_show.dart';
import '../../auth/login.dart';
import '../../user/money/widgethistory/widget_history.dart';
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

  TextEditingController fullName = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController property = TextEditingController();
  TextEditingController qualification = TextEditingController();

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
          child: ListView(
        children: [showCoach()],
      )),
    );
  }

  //LoadData
  Future<void> loadCoachData() async {
    try {
      //Courses
      var datas = await _coachService.coach(
          nameCoach: '',
          cid: context.read<AppData>().cid.toString(),
          email: '');
      coachs = datas.data;
      phone.text = coachs.first.phone;
      email.text = coachs.first.email;
      fullName.text = coachs.first.fullName.toString();
      birthday.text = thaiDate(coachs.first.birthday);
      property.text = coachs.first.property.toString();
      qualification.text = coachs.first.qualification.toString();
      if (coachs.first.gender == "1") {
        gender.text = "หญิง";
        log('เพศใหม่1: ${gender.text}');
      } else {
        gender.text = "ชาย";
      }
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
                Stack(
                  children: [
                    Container(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      height: 170,
                    ),
                    Positioned(
                      //<-- SEE HERE
                      right: 5,
                      top: 10,
                      child: IconButton(
                          onPressed: () {
                            Get.to(() => const LoginPage());
                          },
                          icon: const Icon(
                            FontAwesomeIcons.arrowRightFromBracket,
                            size: 28,
                          )),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 65,
                        ),
                        Center(
                          child: CircleAvatar(
                            minRadius: 55,
                            maxRadius: 75,
                            backgroundImage: NetworkImage(coachs.first.image),
                          ),
                        ),
                        Center(
                            child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text("@ " + coachs.first.username,
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold)),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(top: 8, bottom: 20),
                              child: Text(coachs.first.fullName),
                            ),
                            WidgetTextFieldStringShow(
                              controller: fullName,
                              labelText: 'ชื่อ-นามสกุล',
                            ),
                            WidgetTextFieldStringShow(
                              controller: email,
                              labelText: 'Email',
                            ),
                            WidgetTextFieldStringShow(
                              controller: phone,
                              labelText: 'เบอร์โทรศัพท์',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Expanded(
                                  child: WidgetTextFieldStringShow(
                                    controller: gender,
                                    labelText: 'เพศ',
                                  ),
                                ),
                                Expanded(
                                  child: WidgetTextFieldStringShow(
                                    controller: birthday,
                                    labelText: 'วันเกิด',
                                  ),
                                ),
                              ],
                            ),
                            WidgetTextFieldLines(
                              controller: qualification,
                              labelText: 'วุฒิการศึกษา',
                            ),
                            WidgetTextFieldLines(
                              controller: property,
                              labelText: 'ประวัติส่วนตัว',
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 30, left: 15, right: 15, top: 15),
                              child: SizedBox(
                                width: 400,
                                child: FilledButton(
                                    onPressed: () {
                                      Get.to(() =>
                                              const CoachEidtProfilePage())!
                                          .then((value) {
                                        setState(() {
                                          loadCoachDataMethod = loadCoachData();
                                        });
                                      });
                                    },
                                    child: const Text("แก้ไขข้อมูล")),
                              ),
                            )
                          ],
                        )),
                      ],
                    )
                  ],
                )
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }
}
//if (coachs.first.cid != null)
                //   Padding(
                //     padding: const EdgeInsets.only(left: 25, top: 30),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             CircleAvatar(
                //               minRadius: 35,
                //               maxRadius: 55,
                //               backgroundImage: NetworkImage(coachs.first.image),
                //             ),
                //             Column(
                //               children: [
                //                 Text("@ ${coachs.first.username}"),
                //                 Padding(
                //                   padding: const EdgeInsets.only(left: 30),
                //                   child: Text(coachs.first.fullName),
                //                 ),
                //               ],
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(left: 50),
                //               child: InkWell(
                //                 onTap: () {
                //                   // //1. ส่งตัวแปรแบบconstructure
                //                   Get.to(() =>  const CoachEidtProfilePage());
                //                 },
                //                 child: const Icon(
                //                   Icons.edit_outlined,
                //                   color: Colors.black,
                //                   size: 28,
                //                 ),
                //               ),
                //             ),
                //           ],
                //         ),
                //         Column(
                //           children: [
                //             Padding(
                //               padding: const EdgeInsets.only(top: 20),
                //               child: Row(
                //                 children: [
                //                   const Icon(
                //                     Icons.email,
                //                     color: Colors.green,
                //                     size: 24.0,
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.only(left: 18),
                //                     child: Text(coachs.first.fullName),
                //                   )
                //                 ],
                //               ),
                //             ),
                //             Padding(
                //               padding: const EdgeInsets.only(top: 20),
                //               child: Row(
                //                 children: [
                //                   const Icon(
                //                     Icons.phone,
                //                     color: Colors.green,
                //                     size: 24.0,
                //                   ),
                //                   Padding(
                //                     padding: const EdgeInsets.only(left: 18),
                //                     child: Text(coachs.first.phone),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //           ],
                //         ),
                //         Card(
                //           child: SizedBox(
                //             height: 100,
                //             width: 200,
                //             child: Column(
                //               mainAxisAlignment: MainAxisAlignment.center,
                //               children: [
                //                 const Text("ยอดคงเหลือ"),
                //                 Text(coachs.first.price.toString())
                //               ],
                //             ),
                //           ),
                //         )
                //       ],
                //     ),
                //   )