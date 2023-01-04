import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/DTO/registerCusDTO.dart';
import 'package:frontendfluttercoach/page/home.dart';
import 'package:frontendfluttercoach/service/register.dart';


class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late String _username;
	late String _password;      
	late String _email;        
	late String _fullName;    
	late String _birthday;     
	late String _gender;       
	late String _phone;       
	late String _image;      

	late String _qualification;
	late String _property; 

  late int _weight;
	late int _height;     
	late int _price;           

  late bool _type = true;

  var regCoach;
  var regCus;

  late int uid;
  late int cid;

  late RegisterService registerService;
  int? _selectedChoice;
  final formKey = GlobalKey<FormState>();
  //RegisterCusFromJson profileCus = RegisterCusFromJson();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("สมัครสมาชิก"),
      ),
      body : Column(
        children: <Widget>[
        const SizedBox(height:  24.0),
          ElevatedButton(
          onPressed: () async{
           if (this._type == true) {
                    RegisterCoachDto coachDTO = 
                      RegisterCoachDto(username: this._username, 
                        password: this._password, email: this._email, fullName: this._fullName, 
                        birthday: this._birthday, gender: this._gender,phone: this._phone, 
                        image: this._image, qualification: this._qualification, property: this._property
                      );

                    regCoach = await registerService.regCoachService(coachDTO);
                    cid = int.parse(jsonEncode(regCoach.data.cid));
                  }else{
                    RegisterCusDto cusDTO = RegisterCusDto(username: this._username, 
                      password: this._password, email: this._email, fullName: this._fullName, 
                      birthday: this._birthday, gender: this._gender,phone: this._phone, 
                      image: this._image, weight: this._weight, height: this._height, price: this._price
                    );
                    regCus = await registerService.regCusService(cusDTO);
                    uid = int.parse(jsonEncode(regCus.data.uid));
                  }    
                  if (uid > 0) {
                    log("Register Success");
                  }else if (cid > 0){
                    log("Register Success");
                  }else{
                    log("Register Fail");
                    return;
                  }
        }, 
        child: Text('register')),
        ]
      )
      // body: Container(
        
      //   child:Padding(
      //     padding: const EdgeInsets.all(20.0),
        
      //   child: Form(
      //     key: formKey,
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[          
      //         // ignore: prefer_const_constructors
      //         Text("ชื่อนามสกุล",style: TextStyle(fontSize: 20)),
      //         TextFormField(),
      //         // ignore: prefer_const_constructors
      //         Text("วันเกิด",style: TextStyle(fontSize: 20)),
      //         TextFormField(),
      //         // ignore: prefer_const_constructors
      //         Text("เบอร์โทรศัพท์",style: TextStyle(fontSize: 20)),
      //         TextFormField(),
      //         // ignore: prefer_const_constructors
      //         Text("username",style: TextStyle(fontSize: 20)),
      //         TextFormField(),
      //         // ignore: prefer_const_constructors
      //         Text("E-mail",style: TextStyle(fontSize: 20)),
      //         TextFormField(
      //           keyboardType: TextInputType.emailAddress,
      //         ),
      //         // ignore: prefer_const_constructors
      //         Text("รหัสผ่าน",style: TextStyle(fontSize: 20)),
      //         TextFormField(
      //           obscureText: true,
      //         ),
      //         // ignore: prefer_const_constructors
      //         Text("เพศ",style: TextStyle(fontSize: 20)),
      //         ListTile(
      //           title: const Text('ชาย'),
      //           leading: Radio(
      //             value: 1, 
      //             groupValue: _selectedChoice, 
      //             onChanged: ( value) {
      //               setState(() {
      //                 _selectedChoice = value;
      //               });
      //             },
      //             ),
      //         ),  
      //         ListTile(
      //           title: const Text('หญิง'),
      //           leading: Radio(
      //             value: 2, 
      //             groupValue: _selectedChoice, 
      //             onChanged: (value) {
      //                setState(() {
      //                 _selectedChoice = value;
      //               });
      //             },
      //             ),
      //         ),
      //         Text("คุณเป็นผู็ใช้ประเภทใด",style: TextStyle(fontSize: 20)),
      //         ListTile(
      //           title: const Text('ผู้ใช้'),
      //           leading: Radio(
      //             value: 3, 
      //             groupValue: _selectedChoice, 
      //             onChanged: ( value) {
      //                setState(() {
      //                 _selectedChoice = value;
      //               });
      //             },
      //             ),
      //         ),  
      //         ListTile(
      //           title: const Text('โค้ช'),
      //           leading: Radio(
      //             value: 4, 
      //             groupValue: _selectedChoice, 
      //             onChanged: ( value) {
      //                setState(() {
      //                 _selectedChoice = value;
      //               });
      //             },
      //             ),
      //         ),
      //         SizedBox(
      //           width: double.infinity,
      //           child: ElevatedButton(
      //           onPressed: ()async{
      //             if (this._type == true) {
      //               RegisterCoachDto coachDTO = 
      //                 RegisterCoachDto(username: this._username, 
      //                   password: this._password, email: this._email, fullName: this._fullName, 
      //                   birthday: this._birthday, gender: this._gender,phone: this._phone, 
      //                   image: this._image, qualification: this._qualification, property: this._property
      //                 );

      //               regCoach = await registerService.regCoachService(coachDTO);
      //               cid = int.parse(jsonEncode(regCoach.data.cid));
      //             }else{
      //               RegisterCusDto cusDTO = RegisterCusDto(username: this._username, 
      //                 password: this._password, email: this._email, fullName: this._fullName, 
      //                 birthday: this._birthday, gender: this._gender,phone: this._phone, 
      //                 image: this._image, weight: this._weight, height: this._height, price: this._price
      //               );
      //               regCus = await registerService.regCusService(cusDTO);
      //               uid = int.parse(jsonEncode(regCus.data.uid));
      //             }    
      //             if (uid > 0) {
      //               log("Register Success");
      //             }else if (cid > 0){
      //               log("Register Success");
      //             }else{
      //               log("Register Fail");
      //               return;
      //             }
      //             // Navigator.push(context, MaterialPageRoute(
      //             //   builder: (context){
      //             //     return HomePage();
                    

      //             //   })
      //               // );
      //           }, 
      //           child: Text('สมัครสมาชิก')),
      //         ),
           
      //       ]
      //       ),
      //     ),
      // ),

      // )
    );
  }
}