import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';
import 'package:frontendfluttercoach/model/DTO/loginFBDTO.dart';

import 'package:frontendfluttercoach/page/picture.dart';
import 'package:frontendfluttercoach/page/register.dart';
import 'package:frontendfluttercoach/service/login.dart';
import 'package:frontendfluttercoach/page/vdo.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

// import 'package:frontendfluttercoach/model/customer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:frontendfluttercoach/model/modelCustomer.dart';

import '../model/DTO/registerCoachDTO.dart';
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
          TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.email),
              hintText: 'Your email address',
              labelText: 'E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
            onSaved: (String? value) {
              this._email = value!;
              print('email = $_email');
            },
            //validator: _validateName,
            // onFieldSubmitted: (String value) {
            //   setState(() {
            //     this._email = value;
            //     log(this._email);
            //   });
            // },
          ),
          const SizedBox(height: 24.0),
          PasswordField(
            fieldKey: _passwordFieldKey,
            helperText: 'No more than 8 characters.',
            labelText: 'Password *',
            onSaved: (String? value) {
              this._password = value!;
              print('password = $_password');
            },
          ),
          ElevatedButton(
              onPressed: () async {
                log(this._email);
                log(this._password);

                this._type = 1;
                // LoginDto dto =
                //   LoginDto(email:"Tpangpond@gmail.com", password:"15978", type:1);
                if (this._type == 1) {
                  LoginDto dtoCus = LoginDto(
                      email: this._email, password: this._password, type: 1);

                  userLoginCus = await loginService.loginCus(dtoCus);
                  uid = int.parse(jsonEncode(userLoginCus.data.uid));
                } else if (this._type == 0) {
                  LoginDto dtoCoach = LoginDto(
                      email: this._email, password: this._password, type: 0);

                  userLoginCoach = await loginService.loginCoach(dtoCoach);
                  cid = int.parse(jsonEncode(userLoginCus.data.cid));
                }

                //  log("===============");

                log(uid.toString());
                //log(jsonEncode(userLoginCus.data));
                if (uid > 0) {
                  log("Login Success");
                } else if (cid > 0) {
                  log("Login Success");
                } else {
                  log("Login Fail");
                  return;
                }
              },
              child: Text('Login')),
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
              final LoginResult result = await FacebookAuth.instance
                  .login(); // by default we request the email and the public profile
              // or FacebookAuth.i.login()
              if (result.status == LoginStatus.success) {
                // you are logged
                final AccessToken accessToken = result.accessToken!;
                //log(accessToken.token);
                final userData = await FacebookAuth.instance.getUserData();
                //log(userData['email']);
                //log(userData['name']);
                // fbName = userData['name'];
                // fbEmail = userData['email'];
                // fbImg = userData['picture']['data']['url'];
                context.read<AppData>().userFacebook = userData;
                log(fbImg);

                // RegisterFbdto regFb = RegisterFbdto(
                //    username: nameFB,
                //    email: emailFB,
                //    image: image
                // );
                fbID = userData['id'];
                //fbID = "12";
                //log("fbID: " + fbID);

                LoginFbDto dtofb = LoginFbDto(facebookId: fbID);
              
                
                // if(jsonEncode(userLoginCoachFB.data.cid) == null){
                //   cidfb = 0;
                // }
                

                userLoginCus = await loginService.loginfb(dtofb);
                uidfb = int.parse(jsonEncode(userLoginCus.data.uid));
                cidfb = int.parse(jsonEncode(userLoginCus.data.cid));
                //log(jsonEncode(userLoginCus.data.uid));
                
                if (cidfb > 0) {
                  //log("cid:" + cid.toString());
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                } else if (uidfb > 0) {
                   log("uidfb:" + uidfb.toString());
                   Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => HomePage(),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => RegisterPage(),
                    ),
                  );
                }

                log(username.length.toString());
              } else {
                print(result.status);
                print(result.message);
              }
            },
          ),
        ],
      ),
    );
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
