import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/loginDTO.dart';
import 'package:frontendfluttercoach/page/register.dart';
import 'package:frontendfluttercoach/service/login.dart';
import 'package:frontendfluttercoach/service/provider/appdata.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'package:frontendfluttercoach/model/modelCustomer.dart';

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
  late int  _type = 0;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
        
      ),
      body : Column(children: <Widget>[
        const SizedBox(height:  24.0),
       TextFormField(
            decoration: const InputDecoration(
              border: UnderlineInputBorder(),
              filled: true,
              icon: Icon(Icons.email),
              hintText: 'Your email address',
              labelText: 'E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
            // onSaved: (String? value) {
            //   this._email = myController.text.toString();
            //   log(this._email);
            // },
            onFieldSubmitted: (String value) {
              setState(() {
                this._email = value;
                log(this._email);
              });
            },
          ),
        const SizedBox(height:  24.0),
         PasswordField(
            fieldKey: _passwordFieldKey,
            helperText: 'No more than 8 characters.',
            labelText: 'Password *',
            onFieldSubmitted: (String value) {
              setState(() {
                this._password = value;
                log(this._password);
              });
            },
          ),
      
        
        ElevatedButton(
          onPressed: () async{
            log(this._email);
            log(this._password);
            LoginDto dto = 
              LoginDto(email:this._email, password:this._password, type:1);
            // LoginDto dto = 
            //   LoginDto(email:"Tpangpond@gmail.com", password:"15978", type:1);
           var userLogin = await loginService.login(dto);
          //  log("===============");
          //  log(userLogin.data.length.toString());
            if (userLogin.data.length  == 0) {
              log("Login fail");
              return;
            }
            log(jsonEncode(userLogin.data));
        }, 
        child: Text('Login')),
        ElevatedButton(
          onPressed: (){
            Navigator.push(context, MaterialPageRoute(
              builder: (context){
                return RegisterPage();
            })
            );
          }, 
        child: Text('สมัครสมาชิก'))
      ],
      ),);
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