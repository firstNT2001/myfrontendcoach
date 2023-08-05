import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:local_session_timeout/src/session_timeout_manager.dart';
import 'package:provider/provider.dart';

import '../../model/request/auth_login_post.dart';
import '../../model/response/auth_login_res.dart';
import '../../service/auth.dart';
import '../../service/provider/appdata.dart';

import '../coach/home_coach_page.dart';
import '../user/homepage/homepageUser.dart';
import '../user/navigationbar.dart';
import 'register.dart';

class LoginPage extends StatefulWidget {
  final StreamController<SessionState>? sessionStateStream;

  const LoginPage({Key? key, this.sessionStateStream}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //Service
  late AuthService authService;
  late AuthLoginRes authLoginRes;

  //แสดงรหัสผ่าน
  bool showPassword = false;
  String chackNameAndPassword = "";

  //Controller
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  String titleErr = '';

  //id
  int cid = 0;
  int uid = 0;
  @override
  void initState() {
    super.initState();
    // Test
    email.text = 'sirawitpongpond.la@gmail.com';
    password.text = '1234';

    authService = context.read<AppData>().authService;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // padding: const EdgeInsets.symmetric(vertical: 30),
        width: double.infinity,
        decoration: const BoxDecoration(
            gradient: LinearGradient(begin: Alignment.topCenter, colors: [
          Color.fromARGB(255, 255, 115, 0),
          Color.fromARGB(255, 255, 150, 12),
          Color.fromARGB(255, 255, 165, 31)
        ])),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 80,
          ),
          const Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("เข้าสู่ระบบ",
                    style: TextStyle(color: Colors.white, fontSize: 40)),
                SizedBox(
                  height: 10,
                ),
                Text("ยินดีต้อนรับ",
                    style: TextStyle(color: Colors.white, fontSize: 25)),
              ],
            ),
          ),
          const SizedBox(height: 40),
          //Expanded(child: Container(color: Colors.cyan,))

          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(60),
                      topRight: Radius.circular(60))),
              child: Padding(
                padding: const EdgeInsets.only(top: 50),
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(5),
                    child: Column(children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 20),
                        child: TextField(
                          controller: email,
                          //autofocus: true,
                          onChanged: (String value) {
                            setState(() => titleErr = '');
                          },
                          decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon:
                                  const Icon(FontAwesomeIcons.solidUser),
                              hintText: "อีเมลผู้ใช้ (email)",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 20, right: 20, top: 16),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.center,
                          //textAlign: TextAlign.center,
                          controller: password,
                          obscureText: !showPassword,
                          onChanged: (String value) {
                            setState(() => chackNameAndPassword = "");
                            setState(() => titleErr = '');
                          },
                          decoration: InputDecoration(
                              filled: true, //<-- SEE HERE
                              fillColor: Colors.white,
                              border: InputBorder.none,
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1.5,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .primary), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    width: 1,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .tertiary), //<-- SEE HERE
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              prefixIcon: const Icon(FontAwesomeIcons.lock),
                              hintText: "รหัสผ่าน (password)",
                              hintStyle: const TextStyle(
                                color: Colors.grey,
                              )),
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.only(right: 20, top: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text("ลืมรหัสผ่าน "),
                            Icon(FontAwesomeIcons.solidCircleQuestion)
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 30, bottom: 22),
                        child: SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                              icon: const FaIcon(
                                  FontAwesomeIcons.rightToBracket,
                                  size: 16),
                              onPressed: () async {
                                await login(context);
                              },
                              label: Text(
                                'เข้าสู่ระบบ',
                                style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white),
                              )),
                        ),
                      ),
                      const Padding(
                          padding:
                              EdgeInsets.only(left: 20, right: 20, bottom: 15),
                          child: Divider()),
                      const Text("เข้าสู่ระบบด้วยวิธีอื่น"),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, bottom: 10, top: 20),
                        child: SizedBox(
                          width: double.infinity,
                          height: 45,
                          child: ElevatedButton.icon(
                              icon: const FaIcon(FontAwesomeIcons.facebookF,
                                  size: 16),
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
                      TextButton(
                          onPressed: () {
                            register(context);
                          },
                          child: Text(
                            " สมัครสมาชิก",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.error,
                              decoration: TextDecoration.underline,
                              decorationColor:
                                  Theme.of(context).colorScheme.error,
                            ),
                          ))
                    ]),
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Future<void> login(context) async {
    AuthLoginPost request =
        AuthLoginPost(email: email.text, password: password.text);
    log(jsonEncode(request));
    var response = await authService.login(request);
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
    uid = authLoginRes.uid;
    cid = authLoginRes.cid;
  }

  void _bindPage(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Theme.of(context).colorScheme.primaryContainer,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("Select Type ?",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      Get.to(() => const HomePageCoach());

                      context.read<AppData>().cid = cid;
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset("assets/images/football.png")),
                        Text(
                          'Coach',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const NavbarBottom());
                      context.read<AppData>().uid = uid;
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child:
                                Image.asset("assets/images/single-person.png")),
                        Text(
                          'User',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
  void register(BuildContext ctx) {
    //target widget
    SmartDialog.show(builder: (_) {
      return Container(
        width: MediaQuery.of(context).size.width * 0.8,
        height: MediaQuery.of(context).size.height * 0.4,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 50, bottom: 16),
              child: Text("สมัครสมาชิกเป็นผู้ใช้ใด",
                  style: Theme.of(context).textTheme.headlineSmall),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                //mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                       Get.to(() =>  const RegisterPage(isVisible: false,));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child: Image.asset("assets/images/football.png")),
                        Text(
                          'Coach',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                       Get.to(() =>  const RegisterPage(isVisible: true,));
                    },
                    child: Column(
                      children: [
                        SizedBox(
                            width: 100,
                            height: 100,
                            child:
                                Image.asset("assets/images/single-person.png")),
                        Text(
                          'User',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

}

// body: Stack(
//             children: [
//         Column(
//           children: [
//             Expanded(
//                 child: Container(
//                     decoration: BoxDecoration(
//                         gradient: LinearGradient(
//               colors: [
//                 const Color.fromARGB(242, 255, 177, 31),
//                 const Color.fromARGB(230, 252, 134, 24),
//                 const Color.fromARGB(230, 252, 134, 24),
//                 Theme.of(context).colorScheme.primary,
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             )))),
//             Expanded(child: Container(color: Colors.white))
//           ],
//         ),
//         // ignore: prefer_const_constructors
//         // Padding(
//         //   padding: const EdgeInsets.only(top: 80),
//         //   child: const Positioned.fill(
//         //       child: Align(
//         //     alignment: Alignment.topCenter,
//         //     child: Column(
//         //       children: [
//         //         Text("ยินดีต้อนรับ",
//         //             style: TextStyle(fontSize: 25, color: Colors.white)),
//         //         Padding(
//         //           padding: EdgeInsets.only(top: 30),
//         //           child: Text("DAILY WORKOUT COACHING",
//         //               style: TextStyle(fontSize: 25, color: Colors.white)),
//         //         ),
//         //       ],
//         //     ),
//         //   )),
//         // ),
        
//         Center(
//           child: Container(
//             padding: const EdgeInsets.all(1),
//             margin: const EdgeInsets.all(1),
//             decoration: const BoxDecoration(
//               color: Color(0xFFFFEBDC),
//               borderRadius: BorderRadius.all(Radius.circular(30)),
//               boxShadow: [
//                 BoxShadow(
//                   color: Color.fromARGB(255, 151, 151, 151),
//                   offset: Offset(0, 0),
//                   blurRadius: 7.0,
//                   spreadRadius: 1.0,
//                 )
//               ],
//             ),
//             child: Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(30.0),
//               ),
//               color: const Color(0xFFFFEBDC),
//               clipBehavior: Clip.antiAlias,
//               elevation: 0,
//               child: SizedBox(
//                 width: MediaQuery.of(context).size.width * 0.89,
//                 height: MediaQuery.of(context).size.height * 0.6,
//                 child: Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Padding(
//                           padding: const EdgeInsets.only(
//                               left: 20, right: 20, top: 16, bottom: 20),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Text('เข้าสู่ระบบ',
//                                   style: Theme.of(context)
//                                       .textTheme
//                                       .headlineSmall),
//                             ],
//                           )),
//                       // Padding(
//                       //   padding:
//                       //       const EdgeInsets.only(left: 20, right: 20, top: 16),
//                       //   child: TextField(
//                       //       controller: email,
//                       //       //autofocus: true,
//                       //       onChanged: (String value) {
//                       //         setState(() => titleErr = '');
//                       //       },
//                       //       textAlignVertical: TextAlignVertical.center,
//                       //       textAlign: TextAlign.center,
//                       //       decoration: InputDecoration(
//                       //           labelText: 'อีเมลผู้ใช้ (email)',
//                       //           filled: true,
//                       //           fillColor:
//                       //               Theme.of(context).colorScheme.background)),
//                       // ),


//                       // Padding(
//                       //   padding:
//                       //       const EdgeInsets.only(left: 20, right: 20, top: 16),
//                       //   child: TextField(
//                       //     textAlignVertical: TextAlignVertical.center,
//                       //     textAlign: TextAlign.center,
//                       //     controller: password,
//                       //     onChanged: (String value) {
//                       //       setState(() => chackNameAndPassword = "");
//                       //       setState(() => titleErr = '');
//                       //     },
//                       //     obscureText: !showPassword,
//                       //     decoration: InputDecoration(
//                       //         labelText: 'รหัสผ่าน (password)',
//                       //         filled: true,
//                       //         fillColor:
//                       //             Theme.of(context).colorScheme.background),
//                       //   ),
//                       // ),
//                       Padding(
//                         padding:
//                             const EdgeInsets.only(left: 20, right: 20, top: 2),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           children: [
//                             Text(
//                               titleErr,
//                               style: TextStyle(
//                                   color: Theme.of(context).colorScheme.error),
//                               // selectionColor: Theme.of(context).colorScheme.error,
//                             )
//                           ],
//                         ),
//                       ),


        

//         Positioned(
//           bottom: 200,
//           right: 170,
//           child: Material(
//             type: MaterialType.transparency,
//             child: Ink(
//               decoration: BoxDecoration(
//                 border: Border.all(color: const Color(0xFFFFEBDC), width: 14.0),
//                 //Theme.of(context).colorScheme.primary
//                 color: Theme.of(context).colorScheme.primary,
//                 shape: BoxShape.circle,
//               ),
//               child: InkWell(
//                 //borderRadius: BorderRadius.circular(100.0),
//                 onTap: () async {
//                   await login(context);
//                 },
//                 child: const Padding(
//                   padding: EdgeInsets.all(12.0),
//                   child: Icon(
//                     FontAwesomeIcons.arrowRightLong,
//                     size: 28.0,
//                     color: Colors.black,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ),
        
//         Positioned(
//             bottom: 80,
//             right: 90,
//             child: Column(
//               children: [

//                 Text(
//                   "เข้าสู่ระบบผ่าน facebook",
//                 ),
//                 Padding(
//                     padding:
//                         const EdgeInsets.only(left: 20, right: 20, bottom: 16),
//                     child: TextButton(
//                         onPressed: () {
//                           Get.to(const RegisterPage());
//                         },
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           children: [
//                             const Text(" หากยังไม่มีบัญชี "),
//                             Text(
//                               " สมัครสมาชิก",
//                               style: TextStyle(
//                                   color: Theme.of(context).colorScheme.error),
//                             )
//                           ],
//                         ))),
//               ],
//             )),
        
//         // Positioned(
//         //   bottom: 150,
//         //   right: 170,
//         //   child: Container(width: 50,),
//         //   // child: Padding(
//         //   //                 padding: const EdgeInsets.only(
//         //   //                     left: 20,  top: 100),
//         //   //                 child: SizedBox(
//         //   //                   width: double.infinity,
//         //   //                   height: 45,
//         //   //                   child: ElevatedButton.icon(
//         //   //                       icon: const FaIcon(FontAwesomeIcons.facebookF,
//         //   //                           size: 16),
//         //   //                       onPressed: () async {
//         //   //                         // await login(context);
//         //   //                       },
//         //   //                       style: ElevatedButton.styleFrom(
//         //   //                           foregroundColor: Colors.white,
//         //   //                           backgroundColor: const Color(
//         //   //                               0xff39579A) // Text Color (Foreground color)
//         //   //                           ),
//         //   //                       label: const Text(
//         //   //                         'Login with Facebook',
//         //   //                         //style: Theme.of(context).textTheme.titleMedium,
//         //   //                       )),
//         //   //                 ),
//         //   //               ),
//         // ),
//             ],
//           )
