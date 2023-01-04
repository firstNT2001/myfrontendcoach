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

// import 'package:frontendfluttercoach/model/customer.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
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
  
  bool _isLoggedIn = false;
  Map _userObj = {};
  late int uid;
  late int cid;
  var userLoginCus;
  var userLoginCoach;
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
      body : Column(
        children: <Widget>[
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
            
            this._type = 1;
            // LoginDto dto = 
            //   LoginDto(email:"Tpangpond@gmail.com", password:"15978", type:1);
            if(this._type == 1){

              LoginDto dtoCus = 
                LoginDto(email:this._email, password:this._password, type:1);

              userLoginCus = await loginService.loginCus(dtoCus);
              uid = int.parse(jsonEncode(userLoginCus.data.uid));
            }else if(this._type == 0){
              LoginDto dtoCoach = 
                LoginDto(email:this._email, password:this._password, type:0);

              userLoginCoach = await loginService.loginCoach(dtoCoach);
              cid = int.parse(jsonEncode(userLoginCus.data.cid));
            }

          
          //  log("===============");

          
          
          log(uid.toString());
          //log(jsonEncode(userLoginCus.data));
          if (uid > 0) {
            log("Login Success");
          }else if (cid > 0){
            log("Login Success");
          }else{
              log("Login Fail");
              return;
          }
            
          
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
        child: Text('สมัครสมาชิก')
        ),
        ElevatedButton(
          child:Text("Login with Facebook") ,
          onPressed: () async{
            final LoginResult result = await FacebookAuth.instance.login(); // by default we request the email and the public profile
            // or FacebookAuth.i.login()
            if (result.status == LoginStatus.success) {
                // you are logged
                final AccessToken accessToken = result.accessToken!;
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