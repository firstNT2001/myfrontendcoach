import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/request/auth_password.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/auth.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/textField/wg_textField_password.dart';
import '../../user/editProfile.dart';
import 'coach_editProfile.dart';

class CoachEditPassword extends StatefulWidget {
  const CoachEditPassword(
      {super.key,
      required this.id,
      required this.password,
      required this.visible});
  final String id;
  final String password;
  final bool visible;
  @override
  State<CoachEditPassword> createState() => _CoachEditPasswordState();
}

class _CoachEditPasswordState extends State<CoachEditPassword> {
  //Service
  // late CoachService _coachService;
  // late CustomerService _customerService;

  late AuthService authService;
  late ModelResult modelResult;

  bool oldPasswordVisible = true;
  bool newPasswordVisible = false;
  final oldPassword = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();
  String textErr = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService = context.read<AppData>().authService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text(
          "เปลี่ยนรหัสผ่าน",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Visibility(
                    visible: oldPasswordVisible,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 20, right: 20),
                          child: TextFieldPassword(
                              controller: oldPassword, title: 'รหัสผ่านเดิม'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 20),
                              child: Text(
                                textErr,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 18, left: 15, right: 15),
                          child: buttonOldPassword(),
                        ),
                        const Divider(endIndent: 20, indent: 20),
                      ],
                    )),
                Visibility(
                    visible: newPasswordVisible,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 20, right: 20),
                          child: TextFieldPassword(
                            controller: password1,
                            title: 'รหัสผ่านใหม่',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 20, right: 20),
                          child: TextFieldPassword(
                              controller: password2,
                              title: 'ยืนยันรหัสผ่านใหม่'),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15, right: 20),
                              child: Text(
                                textErr,
                                style: TextStyle(
                                    color: Theme.of(context).colorScheme.error),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 18, left: 15, right: 15),
                          child: buttonNewPassword(),
                        ),
                        const Divider(endIndent: 20, indent: 20),
                      ],
                    ))
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget buttonOldPassword() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () async {
          setState(() {
            textErr = '';
          });
          if (oldPassword.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลรหัสผ่าน';
            });
          } else if (oldPassword.text != widget.password) {
            setState(() {
              textErr = 'รหัสผ่านไม่ถูกต้อง';
              log('message');
            });
          } else {
            setState(
              () {
                textErr = '';
                newPasswordVisible = true;
                oldPasswordVisible = false;
              },
            );
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget buttonNewPassword() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () async {
          setState(() {
            textErr = '';
          });
          if (password1.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลรหัสผ่านใหม่';
            });
          } else if (password2.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลยืนยันรหัสผ่านใหม่';
            });
          } else if (password1.text != password2.text) {
            setState(() {
              textErr = 'รหัสผ่านไม่ตรงกัน';
            });
          } else {
            if (widget.visible == true) {
              AuthPassword request = AuthPassword(password: password1.text);
              var response =
                  await authService.passwordCoach(widget.id, request);
              modelResult = response.data;
              if (modelResult.result == '1') {
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const CoachEidtProfilePage()),
                  ModalRoute.withName('/NavbarBottomCoach'),
                );
              } else {
                setState(() {
                  textErr = 'บันทึกไม่สำเร็จ';
                });
              }
            } else {
              AuthPassword request = AuthPassword(password: password1.text);
              var response = await authService.passwordCus(widget.id, request);
              modelResult = response.data;
              if (modelResult.result == '1') {
                // ignore: use_build_context_synchronously
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(
                      builder: (BuildContext context) =>
                          const editProfileCus()),
                  ModalRoute.withName('/NavbarBottomCoach'),
                );
              } else {
                setState(() {
                  textErr = 'บันทึกไม่สำเร็จ';
                });
              }
            }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }
}
