import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/model/request/registerCoachDTO.dart';
import 'package:frontendfluttercoach/model/request/registerCusDTO.dart';

//import 'package:frontendfluttercoach/page/home.dart';
import 'package:frontendfluttercoach/service/register.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:json_serializable/type_helper.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import '../../service/provider/appdata.dart';
import '../auth/login.dart';

// class regFB{
//   final String nameFB;
//   final String emailFB;
//   final String image;

//   const regFB(this.nameFB, this.emailFB, this.image);
// }
class RegisterPage extends StatefulWidget {
  // final String nameFB;
  // final String emailFB;
  // final String image;
  const RegisterPage({super.key});
  // const RegisterPage(
  //     {Key? key,
  //     required this.nameFB,
  //     required this.emailFB,
  //     required this.image})
  //     : super(key: key);
  //const RegisterPage(this.nameFB, this.emailFB, this.image);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormFieldState<String>> _passwordFieldKey =
      GlobalKey<FormFieldState<String>>();

  var textControllerFullName = new TextEditingController();
  var textControllerEmail = new TextEditingController();
  var textControllerImg = new TextEditingController();

  late String _username = "";
  late String _password = "";
  late String _email = "";
  late String _fullName = "";
  late String _birthday = "";
  late String _gender = "1";
  late String _phone = "";
  late String _image = "";
  late String _facebookID = "";

  late String _qualification = "";
  late String _property = "";

  late int _length = 0;

  late int _lengthREG = 0;
  late int _weight = 0;
  late int _height = 0;
  late int _price = 0;

  late bool _typeCus = false;
  late bool _typeCoach = false;
  late bool _typeREG = false;
  late bool genderBool = true;

  late int type = 0;
  late int type2 = 0;
  var regCoach;
  var regCus;

  late int uid = 0;
  late int cid = 0;

  late bool _showPasswords = false;

  late double convertHelper = 280;

  late RegisterService registerService;
  late Map<String, dynamic> userFacebook;
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

    userFacebook = context.read<AppData>().userFacebook;

    _length = userFacebook['name'].length;
    if (_length > 0) {
      _email = userFacebook['email'];
      _fullName = userFacebook['name'];
      _image = userFacebook['picture']['data']['url'];
      _facebookID = userFacebook['id'];
    } else {
      _email = "";
      _fullName = "";
      _image =
          "https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png";
      _facebookID = "";
    }

    regFBB();

    final images = NetworkImage(_image);
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
            child: CircleAvatar(
              radius: 70,
              child: ClipOval(
                child: InkWell(
                  onTap: () {},
                  child: Image.network(
                    _image,
                    width: 140,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
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
              controller: textControllerEmail,
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
              controller: textControllerFullName,
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
                    String formattedDate =
                        new DateFormat('yyyy-MM-dd').format(pickedDate);
                    print(formattedDate);
                    setState(() {
                      dateInput.text = formattedDate;
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
                    const Text('ผู้ชาย'),
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
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          this._typeCus = !this._typeCus;
                          this._typeCoach = false;
                          this.type = 0;
                          _displayTextField(this.type);
                        });
                      },
                      child: this._typeCus
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.blue,
                              size: 20,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                              size: 20,
                            ),
                    ),
                    SizedBox(width: 5),
                    Text("Customer"),
                  ],
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          this._typeCoach = !this._typeCoach;
                          this._typeCus = false;
                          this.type = 1;
                          _displayTextField(this.type);
                        });
                      },
                      child: this._typeCoach
                          ? Icon(
                              Icons.radio_button_checked,
                              color: Colors.blue,
                              size: 20,
                            )
                          : Icon(
                              Icons.radio_button_unchecked,
                              color: Colors.grey,
                              size: 20,
                            ),
                    ),
                    SizedBox(width: 5),
                    Text("Coach"),
                  ],
                ),
              ],
            ),
          ),
          Container(
              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
              padding: EdgeInsets.only(left: 20, right: 20),
              child: ElevatedButton(
                  onPressed: () async {
                    // log(_typeCoach.toString());
                    // log(_typeCus.toString());

                    //log(_username.isEmpty);

                    // if(_username.isEmpty ?? true) {
                    // }
                    if (this._typeCoach == true) {
                      if (_qualification.isEmpty == false) {
                        if (_property.isEmpty == false) {
                          log("_qualification: " + this._qualification);
                          log("_property: " + this._property);
                          RegisterCoachDto coachDTO = RegisterCoachDto(
                              username: _username,
                              password: _password,
                              email: _email,
                              fullName: _fullName,
                              birthday: _birthday,
                              gender: _gender,
                              phone: _phone,
                              image: _image,
                              qualification: _qualification,
                              property: _property,
                              facebookId: _facebookID);
                          log(jsonEncode(coachDTO));
                          regCoach =
                              await registerService.regCoachService(coachDTO);
                          log(jsonEncode(regCoach.data.cid));
                          cid = int.parse(jsonEncode(regCoach.data.cid));
                        }
                      } else {}
                    } else if (_typeCus == true) {
                      if (_weight == 0) {
                        if (_height == 0) {

                        }
                      }else{
                        // log("Weight: " + _weight.toString());
                          // log("height: " + _height.toString());
                          // log("price: " + _price.toString());
                          RegisterCusDto cusDTO = RegisterCusDto(
                              username: _username,
                              password: _password,
                              email: _email,
                              fullName: _fullName,
                              birthday: _birthday,
                              gender: _gender,
                              phone: _phone,
                              image: _image,
                              weight: _weight,
                              height: _height,
                              price: _price,
                              facebookId: _facebookID);
                          log(jsonEncode(cusDTO));
                          regCus = await registerService.regCusService(cusDTO);
                          log(jsonEncode(regCus.data.uid));
                          uid = int.parse(jsonEncode(regCus.data.uid));
                      }
                    }

                    if (uid > 0) {
                      log("Register Success");
                      type2 = 1;
                      _displayREG(2);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => LoginPage(),
                      //   ),
                      // );
                    } else if (cid > 0) {
                      log("Register Success");
                      type2 = 1;
                      _displayREG(2);
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (_) => LoginPage(),
                      //   ),
                      // );
                    } else {
                      type2 = 2;
                      _displayREG(2);
                      log("Register Fail");
                      return;
                    }
                  },
                  child: Text('register'))),
        ]));
  }

  void regFBB() {
    textControllerFullName.text = _fullName;
    textControllerEmail.text = _email;
    textControllerImg.text = _image;
  }

  bool validateInput(String? input) {
    return _typeREG = input?.isNotEmpty ?? false;
  }

  void _displayTextField(int types) {
    _weight = 0;
    _height = 0;
    if (type == 0) {
      showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              title: const Text('นํ้าหนัก/ส่วนสูง'),
              content: TextField(
                keyboardType: TextInputType.number,
                cursorColor: Color(0xffF5591F),
                decoration: InputDecoration(
                  labelText: 'Enter Weight',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (String value) {
                  this._weight = int.parse(value);
                  log(this._weight.toString());
                },
              ),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    cursorColor: Color(0xffF5591F),
                    decoration: InputDecoration(
                      labelText: 'Enter Height',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (String value) {
                      this._height = int.parse(value);
                      log(this._height.toString());
                    },
                  ),
                ),
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
              // content: TextField(
              //   keyboardType: TextInputType.number,
              //   cursorColor: Color(0xffF5591F),
              //   decoration: InputDecoration(
              //     labelText: 'Enter Weight',
              //     enabledBorder: InputBorder.none,
              //     focusedBorder: InputBorder.none,
              //   ),
              //   onChanged: (String value) {
              //     this._weight = int.parse(value);
              //     log(this._weight.toString());
              //   },

              // ),
            );
          });
    } else if (type == 1) {
      showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              title: const Text('ข้อมูลโค้ช'),
              content: TextField(
                cursorColor: Color(0xffF5591F),
                decoration: InputDecoration(
                  labelText: 'Enter Qualification',
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
                onChanged: (String value) {
                  this._qualification = value;
                  log(this._qualification);
                },
              ),
              actions: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: TextField(
                    cursorColor: Color(0xffF5591F),
                    decoration: InputDecoration(
                      labelText: 'Enter Property',
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    onChanged: (String value) {
                      this._property = value;
                      log(this._property.toString());
                    },
                  ),
                ),
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
  }

  void _displayREG(int types) {
    
    if (type2 == 1) {
      showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              title: const Text('สมัครสมาชิกสำเร็จ'),
              actions: <Widget>[
              Container(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      //codeDialog = valueText;
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => LoginPage(),
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
    } else if (type2 == 2) {
      showDialog(
          context: context,
          builder: (BuildContext _context) {
            return AlertDialog(
              title: const Text('สมัครสมาชิกไม่สำเร็จ'),
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
  }
}
