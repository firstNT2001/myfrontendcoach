import 'dart:convert';
import 'dart:developer';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/widget/textField/wg_textField.dart';
import 'package:get/get.dart';
import 'package:base32/base32.dart';

import 'package:get/get_core/src/get_main.dart';
import 'package:hex/hex.dart';
import 'package:otp/otp.dart';

import '../../widget/textField/wg_textField_int copy.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key, required this.password});
  final String password;

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  final otp = TextEditingController();
  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  bool passwordVisible = true;

  String textErr = '';
  bool isVisible = false;
  bool otpVisible = false;
  bool emailVisible = true;

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
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: button(),
                  ),
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
            getTotp(widget.password);
            // if (otp.text == getTotp(widget.password)) {
            //   setState(() {
            //     otpVisible = false;
            //     isVisible = true;
            //   });
            // }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () {
          if (password1.text.isEmpty || password2.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (password1.text != password2.text) {
            setState(() {
              textErr = 'รหัสไม่ตรงกัน';
            });
          } else {}
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
