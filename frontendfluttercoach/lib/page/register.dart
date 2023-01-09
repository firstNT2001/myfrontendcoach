import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/DTO/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/DTO/registerCusDTO.dart';
//import 'package:frontendfluttercoach/page/home.dart';
import 'package:frontendfluttercoach/service/register.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import '../service/provider/appdata.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

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
  late bool genderBool = true;

  late int type = 0;
  var regCoach;
  var regCus;

  late int uid = 0;
  late int cid = 0;

  late bool _showPasswords = false;

  late RegisterService registerService;

  int? _selectedChoice;
  final formKey = GlobalKey<FormState>();
  //RegisterCusFromJson profileCus = RegisterCusFromJson();
  //Input date
  TextEditingController dateInput = TextEditingController();
  @override
  void initState() {
    super.initState();
    // 2.1 object ของ service โดยต้องส่ง baseUrl (จาก provider) เข้าไปด้วย
    registerService =
        RegisterService(Dio(), baseUrl: context.read<AppData>().baseurl);
    // 2.2 async method
    // loadDataMethod = loadData();

    dateInput.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("สมัครสมาชิก"),
        ),
        body: ListView(children: <Widget>[
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
              decoration: InputDecoration(
                labelText: 'Enter Username',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (String value) {
                this._username = value;
                log(_username);
              },
            ),
          ),
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
              decoration: InputDecoration(
                labelText: 'Enter Fullname',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (String value) {
                this._fullName = value;
                log(this._fullName);
              },
            ),
          ),
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
                controller: dateInput,
                //editing controller of this TextField
                decoration: InputDecoration(
                  icon: Icon(Icons.calendar_today), //icon of text field
                  labelText: "Enter Date", //label text of field
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                readOnly: true,
                //set it true, so that user will not able to edit text
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(1950),
                      //DateTime.now() - not to allow to choose before today.
                      lastDate: DateTime(2100));

                  if (pickedDate != null) {
                    // this._birthday = pickedDate.toString();
                    // log( this._birthday);
                    String formattedDate =
                        DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(
                        formattedDate); //formatted date output using intl package =>  2021-03-16
                    setState(() {
                      dateInput.text =
                          formattedDate; //set output date to TextField value.
                    });
                  } else {}
                  this._birthday = dateInput.text + "T00:00:00Z";
                  log(this._birthday);
                },
              )),
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
              keyboardType: TextInputType.number,
              cursorColor: Color(0xffF5591F),
              decoration: InputDecoration(
                labelText: 'Enter Phone',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (String value) {
                this._phone = value;
                log(this._phone);
              },
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Text("เลือกเพศผู้ใช้"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio<bool>(
                        value: true,
                        groupValue: this.genderBool,
                        onChanged: (bool? value) {
                          setState(() {
                            this.genderBool = value!;
                            this._gender = "1";
                          });
                        }),
                    const Text('ผู้ชาย')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<bool>(
                        value: false,
                        groupValue: this.genderBool,
                        onChanged: (bool? value) {
                          setState(() {
                            this.genderBool = value!;
                            this._gender = "2";
                          });
                        }),
                    const Text('ผู้หญิง')
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: Text("เลือกประเภทผู้ใช้"),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 20),
            padding: EdgeInsets.only(left: 20, right: 20),
            alignment: Alignment.centerLeft,
            child: Row(
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Radio<bool>(
                        value: true,
                        groupValue: this._type,
                        onChanged: (bool? value) {
                          setState(() {
                            this._type = value!;
                            log(this._type.toString());
                          });
                        }),
                    const Text('Customer')
                  ],
                ),
                Row(
                  children: <Widget>[
                    Radio<bool>(
                        value: false,
                        groupValue: this._type,
                        onChanged: (bool? value) {
                          setState(() {
                            this._type = value!;
                            log(this._type.toString());
                          });
                        }),
                        
                    const Text('Coach')
                  ],
                ),
              ],
            ),
          ),
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
              keyboardType: TextInputType.number,
              cursorColor: Color(0xffF5591F),
              decoration: InputDecoration(
                labelText: 'Enter Phone',
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
              ),
              onChanged: (String value) {
                this._phone = value;
                log(this._phone);
              },
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    this._username = "ppond";
                    this._password = "1234";
                    this._email = "p22sasdqwe@gmail.com";
                    this._fullName = "Pondpond";
                    this._birthday = "2002-03-14T00:00:00Z";
                    this._gender = "2";
                    this._phone = "080122221";
                    this._image = "null";

                    this._qualification = "tttt";
                    this._property = "dkaskodkaso";

                    if (this._type == false) {
                      RegisterCoachDto coachDTO = RegisterCoachDto(
                          username: this._username,
                          password: this._password,
                          email: this._email,
                          fullName: this._fullName,
                          birthday: this._birthday,
                          gender: this._gender,
                          phone: this._phone,
                          image: this._image,
                          qualification: this._qualification,
                          property: this._property);

                      regCoach =
                          await registerService.regCoachService(coachDTO);

                      cid = int.parse(jsonEncode(regCoach.data.cid));
                    }else {
                      RegisterCusDto cusDTO = RegisterCusDto(
                          username: this._username,
                          password: this._password,
                          email: this._email,
                          fullName: this._fullName,
                          birthday: this._birthday,
                          gender: this._gender,
                          phone: this._phone,
                          image: this._image,
                          weight: this._weight,
                          height: this._height,
                          price: this._price);
                      regCus = await registerService.regCusService(cusDTO);
                      uid = int.parse(jsonEncode(regCus.data.uid));
                    }
                    if (uid > 0) {
                      log("Register Success");
                    } else if (cid > 0) {
                      log("Register Success");
                    } else {
                      log("Register Fail");
                      return;
                    }
                  },
                  child: Text('register'))),
        ]));
  }
}
