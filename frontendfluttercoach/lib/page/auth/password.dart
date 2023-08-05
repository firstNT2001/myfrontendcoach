import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/editProfile.dart';
import 'package:frontendfluttercoach/widget/textField/wg_textField.dart';
import 'package:get/get.dart';
import 'package:base32/base32.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:hex/hex.dart';
import 'package:otp/otp.dart';
import 'package:provider/provider.dart';

import '../../model/request/auth_password.dart';
import '../../model/response/md_Result.dart';
import '../../service/auth.dart';
import '../../service/coach.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import '../../widget/textField/wg_textField_int copy.dart';
import '../coach/profile/coach_editProfile.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage(
      {super.key, required this.password, required this.visible});
  final String password;
  final bool visible;
  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  //Service
  late CoachService _coachService;
  late CustomerService _customerService;
  
  late AuthService authService;
  late ModelResult modelResult;

  final otp = TextEditingController();
  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  String password = '';
  bool passwordVisible = true;

  String textErr = '';
  bool isVisible = false;
  bool otpVisible = false;
  bool emailVisible = true;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    authService = context.read<AppData>().authService;
    password = widget.password;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "เปรียนรหัสผ่าน",
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
          Visibility(
              visible: emailVisible,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    child: WidgetTextFieldString(
                      controller: email,
                      labelText: 'Email',
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 20, right: 23),
                        child: Text(
                          textErr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: buttonEmail(),
                  ),
                  const Divider(endIndent: 20, indent: 20),
                ],
              )),
          Visibility(
              visible: otpVisible,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    child: WidgetTextFieldInt(
                      controller: otp,
                      labelText: 'OTP',
                      maxLength: 6,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 20, right: 23),
                        child: Text(
                          textErr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: buttonOTP(),
                  ),
                  const Divider(endIndent: 20, indent: 20),
                ],
              )),
          Visibility(
              visible: isVisible,
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    child: textPassword(
                      password1,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                    child: textPassword(
                      password2,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            bottom: 8, left: 20, right: 23),
                        child: Text(
                          textErr,
                          style: TextStyle(
                              color: Theme.of(context).colorScheme.error),
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: widget.visible,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18, left: 20, right: 20),
                      child: buttonCoach(),
                    ),
                  ),
                  if (widget.visible == false) ...{
                    Visibility(
                      visible: widget.visible,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 18, left: 20, right: 20),
                        child: buttonCus(),
                      ),
                    )
                  }
                ],
              ))
        ],
      )),
    );
  }

  Widget buttonEmail() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () {
          if (email.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูล Email';
            });
          } else if (validate(email.text) == false) {
            setState(() {
              textErr = 'อีมลไม่ถูกต้อง';
            });
          } else {
            setState(() {
              textErr = '';
              emailVisible = false;
              otpVisible = true;
            });
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget buttonOTP() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () {
          if (otp.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูล OTP';
            });
          } else {
            if (otp.text == getTotp(password)) {
              setState(() {
                otpVisible = false;
                isVisible = true;
              });
            } else {
              setState(() {
                textErr = 'OTP ไม่ถูกต้อง';
              });
            }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget buttonCoach() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () async {
          if (password1.text.isEmpty || password2.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (password1.text != password2.text) {
            setState(() {
              textErr = 'รหัสไม่ตรงกัน';
            });
          } else {
            AuthPassword request = AuthPassword(password: password1.text);
            var response = await authService.passwordCoach(
                context.read<AppData>().cid.toString(), request);
            modelResult = response.data;
            if (modelResult.result == '0') {
              setState(() {
                textErr = 'บันทึกไม่สำเร็จ';
              });
            } else {
              Get.to(() => const CoachEidtProfilePage());
            }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget buttonCus() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () async {
          if (password1.text.isEmpty || password2.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (password1.text != password2.text) {
            setState(() {
              textErr = 'รหัสไม่ตรงกัน';
            });
          } else {
            AuthPassword request = AuthPassword(password: password1.text);
            var response = await authService.passwordCus(
                context.read<AppData>().uid.toString(), request);
            modelResult = response.data;
            if (modelResult.result == '0') {
              setState(() {
                textErr = 'บันทึกไม่สำเร็จ';
              });
            } else {
              Get.to(() => editProfileCus(
                    uid: context.read<AppData>().uid,
                  ));
            }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Column textPassword(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        TextField(
          obscureText: passwordVisible,
          controller: controller,
          onChanged: (value) {
            setState(() {
              textErr = '';
            });
          },
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            // hintText: "Password",
            // labelText: "Password",
            //helperText: "Password must contain special character",
            //helperStyle: const TextStyle(color: Colors.green),
            prefixIcon: const Icon(FontAwesomeIcons.lock),

            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
            // alignLabelWithHint: false,
            // filled: true,
          ),
          keyboardType: TextInputType.visiblePassword,
          // textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  // String getGoogleAuthenticatorUri(String appname, String email, String key) {
  //   List<int> list = utf8.encode(key);
  //   String hex = HEX.encode(list);
  //   String secret = base32.encodeHexString(hex);
  //   log('secret $secret');
  //   String uri =
  //       'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';

  //   return uri;
  // }

  String getTotp(String key) {
    List<int> list = utf8.encode(key);
    String hex = HEX.encode(list);

    String secret = base32.encodeHexString(hex);
    String totp = OTP.generateTOTPCodeString(
        secret, DateTime.now().millisecondsSinceEpoch,
        algorithm: Algorithm.SHA1, isGoogle: true);
    return totp;
  }

  // Method to validate the email the take
  // the user email as an input and
  // print the bool value in the console.
  bool validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }
}
