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
import 'package:provider/provider.dart';

import '../../model/request/auth_password.dart';
import '../../model/response/md_Coach_get.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_Result.dart';
import '../../service/auth.dart';
import '../../service/coach.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import '../../widget/textField/wg_textField_int copy.dart';
import 'login.dart';

class EditPasswordPage extends StatefulWidget {
  const EditPasswordPage({super.key});

  @override
  State<EditPasswordPage> createState() => _EditPasswordPageState();
}

class _EditPasswordPageState extends State<EditPasswordPage> {
  //Service
  late Future<void> loadDataMethod;

  late CoachService _coachService;
  late CustomerService _customerService;

  //Model
  List<Coach> modelCoach = [];
  List<Customer> modelCustomer = [];
 
  late AuthService authService;
  late ModelResult modelResult;

  final otp = TextEditingController();
  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();

  String password = '';

  String textErr = '';

  bool passwordVisible = true;
  bool isVisible = false;
  bool otpVisible = false;
  bool emailVisible = true;
  bool resetPassword = false;
  bool resetPasswordAll = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _coachService = context.read<AppData>().coachService;
    _customerService = context.read<AppData>().customerService;
    authService = context.read<AppData>().authService;

    //loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ลืมรหัสผ่าน",
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
        children: [show()],
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
            setState(
              () {
                _coachService
                    .coach(cid: '', nameCoach: '', email: email.text)
                    .then((coachdata) {
                  var coachDatas = coachdata.data;
                  modelCoach = coachDatas;
                  if (modelCoach.isNotEmpty) {
                    setState(() {});
                    log(modelCoach.length.toString());
                  }
                });

                _customerService
                    .customer(email: email.text, uid: '')
                    .then((cusdata) {
                  var cusDatas = cusdata.data;
                  modelCustomer = cusDatas;
                  if (modelCustomer.isNotEmpty) {
                    setState(() {});
                    log(modelCustomer.length.toString());
                  }
                });
                if (modelCoach.isNotEmpty &&
                    modelCustomer.isNotEmpty) {
                  setState(() {
                    password = modelCoach.first.password;
                    otpVisible = true;
                    emailVisible = false;
                    resetPasswordAll = true;
                  });
                } else if (modelCoach.isNotEmpty) {
                  setState(() {
                    password = modelCoach.first.password;
                    otpVisible = true;
                    emailVisible = false;
                    resetPassword = true;
                  });
                } else if (modelCustomer.isNotEmpty) {
                  setState(() {
                    password = modelCoach.first.password;
                    otpVisible = true;
                    emailVisible = false;
                  });
                } else {
                  setState(() {
                    textErr = 'อีมลไม่ถูกต้อง';
                  });
                }
              },
            );
            // log("modelCoach${modelCoach.length}");
            // log("modelCustomer${modelCustomer.uid}");
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
          setState(() {
            textErr = '';
          });
          if (otp.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูล OTP';
            });
          } else {
            log(email.text + password);
            log(getTotp(email.text + password));
            if (otp.text == getTotp(email.text + password)) {
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

  Widget buttonReset() {
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
            if (resetPassword == true) {
              AuthPassword request = AuthPassword(password: password1.text);
              var response = await authService.passwordCoach(
                  modelCoach.first.cid.toString(), request);
              modelResult = response.data;
            } else {
              AuthPassword request = AuthPassword(password: password1.text);
              var response = await authService.passwordCus(
                  modelCustomer.first.uid.toString(), request);
              modelResult = response.data;
            }

            if (modelResult.result == '0') {
              setState(() {
                textErr = 'บันทึกไม่สำเร็จ';
              });
            } else {
              Get.to(() => const LoginPage());
            }
          }
        },
        child: const Text('ยืนยัน'),
      ),
    );
  }

  Widget buttonResetAll() {
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
            log(modelCoach.first.password);
            // ignore: unused_local_variable
            var response = await authService.passwordCoach(
                modelCoach.first.cid.toString(), request);

            AuthPassword request2 = AuthPassword(password: password1.text);
            log(jsonEncode(request2));
            var response2 = await authService.passwordCus(
                modelCustomer.first.uid.toString(), request2);
            modelResult = response2.data;

            log(modelResult.result);
            log(password1.text);
            if (modelResult.result == '0') {
              setState(() {
                textErr = 'บันทึกไม่สำเร็จ';
              });
            } else {
              Get.to(() => const LoginPage());
            }
          }
        },
        child: const Text('ยืนยันbuttonReset'),
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

  //LoadData
  Future<void> loadData() async {
    try {
      //Courses
      var coachDatas =
          await _coachService.coach(nameCoach: '', cid: '', email: email.text);
      modelCoach = coachDatas.data;

      var cusDatas =
          await _customerService.customer(email: email.text, uid: '');
      modelCustomer = cusDatas.data;
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget show() {
    return Column(
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
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 20, right: 23),
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
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 20, right: 23),
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
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 20, right: 23),
                      child: Text(
                        textErr,
                        style: TextStyle(
                            color: Theme.of(context).colorScheme.error),
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: resetPassword,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: buttonReset(),
                  ),
                ),
                Visibility(
                  visible: resetPasswordAll,
                  child: Padding(
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: buttonResetAll(),
                  ),
                ),
              ],
            ))
      ],
    );
  }

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
