import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:local_session_timeout/src/session_timeout_manager.dart';
import 'package:provider/provider.dart';

import '../../model/request/auth_login_post.dart';
import '../../model/response/auth_login_res.dart';
import '../../service/auth.dart';
import '../../service/provider/appdata.dart';
import '../../widget/wg_textField.dart';
import '../coach/home_coach_page.dart';
import '../user/homepageUser.dart';
import '../waitingForEdit/register.dart';

class LoginPage extends StatefulWidget {
  StreamController<SessionState>? sessionStateStream;

  LoginPage({Key? key, this.sessionStateStream}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Service
  late AuthService authService;
  var response;
  late AuthLoginRes authLoginRes;

  //แสดงรหัสผ่าน
  bool showPassword = false;
  String chackNameAndPassword = "";

  //Controller
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String titleErr = '';
  @override
  void initState() {
    super.initState();
    // Test
    email.text = 'paper@gmail.com';
    password.text = '1234';

    authService = context.read<AppData>().authService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Card(
          clipBehavior: Clip.antiAlias,
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.89,
            height: MediaQuery.of(context).size.height * 0.6,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Padding(
                  padding: const EdgeInsets.only(
                      left: 20, right: 20, top: 16, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('เข้าสู่ระบบ',
                          style: Theme.of(context).textTheme.headlineSmall),
                    ],
                  )),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: TextField(
                    controller: email,
                    //autofocus: true,
                    onChanged: (String value) {
                      setState(() => titleErr = '');
                    },
                    textAlignVertical: TextAlignVertical.center,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                        labelText: 'อีเมลผู้ใช้ (email)',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.background)),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 16),
                child: TextField(
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  controller: password,
                  onChanged: (String value) {
                    setState(() => chackNameAndPassword = "");
                    setState(() => titleErr = '');
                  },
                  obscureText: !showPassword,
                  decoration: InputDecoration(
                      labelText: 'รหัสผ่าน (password)',
                      filled: true,
                      fillColor: Theme.of(context).colorScheme.background),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      titleErr,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                      // selectionColor: Theme.of(context).colorScheme.error,
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.rightToBracket,
                          size: 16),
                      onPressed: () async {
                        await login(context);
                      },
                      label: Text(
                        'เข้าสู่ระบบ',
                        style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
              ),
              const Padding(
                  padding: EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  child: Divider()),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
                child: SizedBox(
                  width: double.infinity,
                  height: 45,
                  child: ElevatedButton.icon(
                      icon: const FaIcon(FontAwesomeIcons.facebookF, size: 16),
                      onPressed: () async {
                        // await login(context);
                      },
                      style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(
                              0xff39579A) // Text Color (Foreground color)
                          ),
                      label: const Text(
                        'Login with Facebook',
                        //style: Theme.of(context).textTheme.titleMedium,
                      )),
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                  child: TextButton(
                      onPressed: () {
                        Get.to(const RegisterPage());
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center, 
                        children: [
                          const Text(" Don't have any account? "),
                          Text(
                            " Signup",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          )
                        ],
                      ))),
            ]),
          ),
        ),
      ),
    );
  }

  Future<void> login(context) async {
    AuthLoginPost request =
        AuthLoginPost(email: email.text, password: password.text);
    log(jsonEncode(request));
    response = await authService.login(request);
    authLoginRes = response.data;
    //log(authLoginRes.uid.toString());
    if (authLoginRes.uid > 0 && authLoginRes.cid > 0) {
      log("go");
      _bindPage(context);
      setState(() => titleErr = '');
    } else if (authLoginRes.cid > 0) {
      Get.to(() => const HomePageCoach());
      setState(() => titleErr = '');
    } else if (authLoginRes.uid > 0) {
      Get.to(() => const HomePageUser());
      setState(() => titleErr = '');
    } else {
      log('ไม่พบ');

      setState(() => titleErr = 'กรุณาใส่อีเมล์หรือรหัสผ่านให้ถูกต้อง');
    }
  }

  void _bindPage(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        height: 200,
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 16, bottom: 16),
              child: Text("คุณจะเข้าสู่ระบบเป็นผู้ใช้ประเภทใด"),
            ),
            Row(
              //mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const HomePageCoach());
                  },
                  child: Text('Coach'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Get.to(() => const HomePageUser());
                  },
                  child: Text('User'),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
