import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/request/loginDTO.dart';
import 'package:frontendfluttercoach/model/request/loginFBDTO.dart';
import 'package:frontendfluttercoach/page/waitingForEdit/register.dart';


import 'package:frontendfluttercoach/service/login.dart';

import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// import 'package:frontendfluttercoach/model/customer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';



import 'homePage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();
  // 1. กำหนดตัวแปร
  List<LoginDto> logins = [];
  late Future<void> loadDataMethod;
  late LoginService loginService;

  late String _email = "";
  late String _password = "";
  late int _type = 0;
  late bool _showPasswords = false;

  late String username;
  late String password;
  late String email;
  late String fullName;
  late String birthday;
  late String gender;
  late String phone;
  late String image;

  late String _qualification;
  late String _property;

  late String fbEmail = "";
  late String fbName = "";
  late String fbImg = "null";
  late String fbID = "";

  bool _isLoggedIn = false;
  Map _userObj = {};
  late int uid = 0;
  late int cid = 0;
  late int uidfb = 0;
  late int cidfb = 0;
  var userLoginCus;
  var userLoginCoach;
  var userLoginCusFB;
  var userLoginCoachFB;
  // 2. สร้าง initState เพื่อสร้าง object ของ service
  // และ async method ที่จะใช้กับ FutureBuilder
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    loginService =
        LoginService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    // loadDataMethod = loadData();
  }

  String? _validateName(String? value) {
    if (value?.isEmpty ?? false) {
      return 'Name is required.';
    }
    final RegExp nameExp = RegExp(r'^[A-Za-z ]+$');
    if (!nameExp.hasMatch(value!)) {
      return 'Please enter only alphabetical characters.';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 24.0),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Color(0xffEEEEEE),
                )
              ],
            ),
            alignment: Alignment.center,
            child: TextField(
              cursorColor: Color(0xffF5591F),
              //controller: textControllerEmail,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (String value) {
                this._email = value;
                log(this._email);
              },
            ),
          ),
          const SizedBox(height: 24.0),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 0),
            padding: EdgeInsets.only(left: 20, right: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 10),
                  blurRadius: 50,
                  color: Color(0xffEEEEEE),
                )
              ],
            ),
            alignment: Alignment.center,
            child: TextField(
              cursorColor: Color(0xffF5591F),
              obscureText: !this._showPasswords,
              decoration: InputDecoration(
                labelText: 'Enter Password',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: this._showPasswords ? Colors.blue : Colors.green,
                  ),
                  onPressed: () {
                    setState(() => this._showPasswords = !this._showPasswords);
                  },
                ),
              ),
              onChanged: (String value) {
                this._password = value;
                log(_password);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 0),
            padding: EdgeInsets.only(left: 20, right: 20),
            child: ElevatedButton(
                onPressed: () async {
                  log(this._email);
                  log(this._password);
                  LoginDto dtoUser = LoginDto(
                      email: this._email, password: this._password, type: 1);
                  this._type = 1;
                  // LoginDto dto =
                  //   LoginDto(email:"Tpangpond@gmail.com", password:"15978", type:1);
                  if (this._type == 1) {
                    log(jsonEncode(dtoUser));
                    userLoginCus = await loginService.login(dtoUser);
                    log(jsonEncode(userLoginCus.data.uid));
                    uid = int.parse(jsonEncode(userLoginCus.data.uid));
                  } else if (this._type == 0) {
                    userLoginCoach = await loginService.login(dtoUser);
                    cid = int.parse(jsonEncode(userLoginCus.data.cid));
                  }

                  //  log("===============");

                  log(uid.toString());
                  //log(jsonEncode(userLoginCus.data));
                  if (uid > 0) {
                    log("Login Success");
                    _displayLogin();
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (_) => HomePage(),
                    //   ),
                    // );
                  } else if (cid > 0) {
                    log("Login Success");
                  } else {
                    log("Login Fail");
                    _displayTextField();
                    return;
                  }
                },
                child: Text('Login')),
          ),
          ElevatedButton(
              onPressed: () {
                // Navigator.of(context).push(MaterialPageRoute(
                //   builder: (context) => RegisterPage(
                //     nameFB: nameFB, emailFB: emailFB, image: image
                //   )));
                Map<String, dynamic> userData = {
                  "name": "",
                };
                context.read<AppData>().userFacebook = userData;
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => RegisterPage(),
                  ),
                );
              },
              child: Text('สมัครสมาชิก')),
          ElevatedButton(
            child: Text("Login with Facebook"),
            onPressed: () async {
              final LoginResult result = await FacebookAuth.instance.login();

              if (result.status == LoginStatus.success) {
                final AccessToken accessToken = result.accessToken!;
                log(accessToken.toString());
                final userData = await FacebookAuth.instance.getUserData();
                context.read<AppData>().userFacebook = userData;

                fbID = userData['id'];
                LoginFbDto dtofb = LoginFbDto(facebookId: fbID);

                userLoginCus = await loginService.loginfb(dtofb);
                uidfb = int.parse(jsonEncode(userLoginCus.data.uid));
                cidfb = int.parse(jsonEncode(userLoginCus.data.cid));
                if (cidfb > 0) {
                  // ignore: use_build_context_synchronously
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                } else if (uidfb > 0) {
                  log("uidfb:" + uidfb.toString());
                  // ignore: use_build_context_synchronously
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                } else {
                  // ignore: use_build_context_synchronously
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(),
                    ),
                  );
                }
              } else {
                print(result.status);
                print(result.message);
              }
            },
          ),
          Container(
             margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return HomePage();
                }));
              },
              child: Text('Home')),
          ),
        ],
      ),
    );
  }

  void _displayTextField() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text('Login Fail'),
            actions: <Widget>[
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //codeDialog = valueText;
                      Navigator.pop(context);
                    });
                  },
                  child: Text('OK'),
                ),
              )
            ],
          );
        });
  }

  void _displayLogin() {
    showDialog(
        context: context,
        builder: (BuildContext _context) {
          return AlertDialog(
            title: const Text('Login Succeed'),
            actions: <Widget>[
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //codeDialog = valueText;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => HomePage(),
                        ),
                      );
                    });
                  },
                  child: Text('OK'),
                ),
              )
            ],
          );
        });
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({
    this.fieldKey,
    this.hintText,
    this.labelText,
    this.helperText,
    this.onSaved,
    this.validator,
    this.onFieldSubmitted,
  });

  final Key? fieldKey;
  final String? hintText;
  final String? labelText;
  final String? helperText;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      obscureText: _obscureText,
      maxLength: 20,
      onSaved: widget.onSaved,
      validator: widget.validator,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
        border: const UnderlineInputBorder(),
        filled: true,
        hintText: widget.hintText,
        labelText: widget.labelText,
        helperText: widget.helperText,
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
      ),
    );
  }
}
