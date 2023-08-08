import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:get/get.dart';
import 'package:hex/hex.dart';

import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/request/updateCus.dart';
import 'package:base32/base32.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_Result.dart';

import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../../widget/dropdown/wg_dropdown_string.dart';
import 'money/widgethistory/widget_history.dart';

// ignore: camel_case_types
class editProfileCus extends StatefulWidget {
  //สร้างตัวแปรรับconstructure

  const editProfileCus({super.key});

  @override
  State<editProfileCus> createState() => _editProfileCusState();
}

class _editProfileCusState extends State<editProfileCus> {
  //call service
  late Future<void> loadDataMethod;
  late CustomerService customerService;
  List<Customer> customer = [];
  //late ModelRowsAffected modelRowsAffected;
  late UpdateCustomer cusUpdate;
  late ModelResult moduleResult;
  String GenOTP = "";
  late int uid;
  bool _isvisible = false;
  //controller
  TextEditingController _uid = TextEditingController();
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _fullName = TextEditingController();
  TextEditingController _birthday = TextEditingController();
  TextEditingController _gender = TextEditingController();
  TextEditingController _phone = TextEditingController();
  TextEditingController _weight = TextEditingController();
  TextEditingController _height = TextEditingController();
  TextEditingController _facebookID = TextEditingController();
  int price = 0;
  var update;
  List<String> genders = ['หญิง', 'ชาย'];
  bool isvisible = false;
  String _image = " ";
  String profile = " ";

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;

  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImg = result.files.first;
      log(pickedImg.toString());
    });
  }

  //uploadfile
  Future uploadfile() async {
    final path = 'profileUser/${pickedImg!.name}';
    final file = File(pickedImg!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    print('link img firebase $urlDownload');
    profile = urlDownload;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    uid = context.read<AppData>().uid;
    customerService =
        CustomerService(Dio(), baseUrl: context.read<AppData>().baseurl);

    loadDataMethod = loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("แก้ไข"),
      ),
      body: ListView(children: [
        Column(
          children: [showProfile()],
        ),
      ]),
    );
  }

  Future<void> loadData() async {
    try {
      var result =
          await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
      _uid.text = customer.first.uid.toString();
      _username.text = customer.first.username;
      _fullName.text = customer.first.fullName;
      _birthday.text = thaiDate(customer.first.birthday);
      _gender.text = customer.first.gender;
      _phone.text = customer.first.phone;
      _email.text = customer.first.email;
      _password.text = customer.first.password;
      _facebookID.text = customer.first.facebookId;
      price = customer.first.price;
      _image = customer.first.image;
      _weight.text = customer.first.weight.toString();
      _height.text = customer.first.height.toString();
      log("b1" + _password.text);
      log("b2" + customer.first.birthday);
      log("_IMAGE==" + _image);
      //gender show
      log('เพศ: ${customer.first.gender}');
      if (customer.first.gender == "1") {
        _gender.text = genders[0];
        log('เพศใหม่1: ${_gender.text}');
      } else if (customer.first.gender == "2") {
        _gender.text = genders[1];
      } else {
        _gender.text = "ไม่ได้ระบุ";
      }
    } catch (err) {
      log('Error: $err');
    }
  }
  //   Widget genQR(String valueOTP,bool isvisible){
  //   return
  // }

  txtfild(
      final TextEditingController _controller, String lbText, String txtTop) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.only(left: 5, bottom: 3),
          child: Text(
            txtTop,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextField(
          controller: _controller,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 12),
            border: OutlineInputBorder(),
          ),
        ),
      ]),
    );
  }

  Widget showProfile() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
            Size screenSize = MediaQuery.of(context).size;
            double width = (screenSize.width > 550) ? 550 : screenSize.width;
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        if (pickedImg != null)
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border:
                                    Border.all(width: 3, color: Colors.cyan),
                                boxShadow: [
                                  BoxShadow(
                                      spreadRadius: 2,
                                      blurRadius: 10,
                                      color: Colors.black.withOpacity(0.1))
                                ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    image: FileImage(
                                      File(pickedImg!.path!),
                                    ),
                                    fit: BoxFit.cover)),
                          ),
                        if (pickedImg == null)
                          Container(
                            width: 130,
                            height: 130,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    width: 4,
                                    color: Color.fromARGB(255, 255, 151, 33)),
                                // boxShadow: [
                                //   BoxShadow(
                                //       spreadRadius: 2,
                                //       blurRadius: 10,
                                //       color: Colors.black.withOpacity(0.1))
                                // ],
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(customer.first.image),
                                )),
                          ),
                        Positioned(
                            bottom: 0,
                            right: 0,
                            child: InkWell(
                              onTap: () {
                                log("message");
                                selectImg();
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 4, color: Colors.white),
                                    color: Color.fromARGB(255, 255, 151, 33)),
                                child: Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  // CircleAvatar(
                  //   minRadius: 35,
                  //   maxRadius: 55,
                  //   backgroundImage: NetworkImage(customer.data.image),
                  // ),
                  SizedBox(
                    height: 20,
                  ),
                  txtfild(_username, "ชื่อผู้ใช้", "ชื่อผู้ใช้"),
                  txtfild(_email, "e-mail", "e-mail"),
                  // txtfildn(_password, "รหัสผ่าน", "รหัสผ่าน"),
                  txtfild(_fullName, "ชื่อ-นามสกุล", "ชื่อ-นามสกุล"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                       SizedBox(
                        width: (width - 16 - (3 * 30)) / 2,
                        child: WidgetDropdownString(
                          title: "เพศ",
                          selectedValue: _gender,
                          listItems: genders),
                      ),
                      SizedBox(
                        width: (width - 16 - (3 * 30)) / 2,
                        child: txtfild(_birthday, "วันเกิด", "ว/ด/ป"),
                      ),
                      
                      
                    ],
                  ),

                  txtfild(_phone, "โทรศัพท์", "โทรศัพท์"),
                  txtfild(_weight, "น้ำหนัก", "น้ำหนัก"),
                  txtfild(_height, "ส่วนสูง", "ส่วนสูง"),
                  Visibility(
                    visible: _isvisible,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              bottom: 8, left: 20, right: 23),
                          child: Text(
                            "กรุณากรอกข้อความในช่องว่างให้ครบ",
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.error),
                          ),
                        ),
                      ],
                    ),
                  ),
                  FilledButton(
                      onPressed: () async {
                        GenOTP = getGoogleAuthenticatorUriQR("Coaching",
                            _email.text, _email.text + _password.text);
                        log(GenOTP);

                        if (GenOTP.isNotEmpty) {
                          setState(() {
                            isvisible = true;
                          });
                          // _launchUrl( Uri.parse(GenOTP));
                        }
                      },
                      child: Text("สร้างGoogle Authenticator")),
                  Visibility(
                    visible: isvisible,
                    child: Column(
                      children: [
                        Container(
                            height: 200,
                            child: Image.network(
                                'https://www.google.com/chart?chs=200x200&chld=M|0&cht=qr&chl=$GenOTP')),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            FilledButton(
                                onPressed: () {
                                  setState(() {
                                    isvisible = false;
                                  });
                                },
                                child: Text("ซ่อน QR Code")),
                            FilledButton(
                                onPressed: () {
                                  GenOTP = getGoogleAuthenticatorUri(
                                      "Coaching",
                                      _email.text,
                                      _email.text + _password.text);
                                },
                                child: Text("เข้าสู่ Application"))
                          ],
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Text('เปรียนรหัสผ่าน'),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.chevronRight,
                        ),
                        onPressed: () {
                          // Get.to(() => EditPasswordPage(
                          //       password: _password.text
                          //     ));
                        },
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 15, bottom: 15),
                    child: ElevatedButton(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text("บันทึก"),
                        ),
                        onPressed: () async {
                          log("messageIMG=" + _image);
                          //DateTime birthday = new DateFormat("yyyy-MM-dd 'T'HH:mm:ss.SSS'Z'").parse(_birthday.text);
                          if (pickedImg != null) await uploadfile();
                          if (pickedImg == null) profile = _image;

                          if (_username.text.isEmpty ||
                              _email.text.isEmpty ||
                              _fullName.text.isEmpty ||
                              _phone.text.isEmpty ||
                              _weight.text.isEmpty ||
                              _height.text.isEmpty) {
                            setState(() {
                              _isvisible = true;
                            });

                            log('Text Field is empty, Please Fill All Data');
                          } else {
                            // Put your code here, which you want to execute when Text Field is NOT Empty.
                            UpdateCustomer updateCustomer = UpdateCustomer(
                                username: _username.text,
                                password: _password.text,
                                email: _email.text,
                                fullName: _fullName.text,
                                birthday: _birthday.text,
                                gender: _gender.text,
                                phone: _phone.text,
                                image: profile,
                                weight: int.parse(_weight.text),
                                height: int.parse(_height.text));
                            log(jsonEncode(updateCustomer));
                            log("log" + uid.toString());
                            log(_birthday.text);
                            //log(_image.toString());
                            update = await customerService.updateCustomer(
                                uid.toString(), updateCustomer);
                            moduleResult = update.data;
                            log(moduleResult.result);
                            Get.to(() => const ProfileUser());
                          }
                        }),
                  ),
                ],
              ),
            );
          }
        });
  }

  String getGoogleAuthenticatorUri(String appname, String email, String key) {
    List<int> list = utf8.encode(email);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    String url =
        'otpauth://totp/$appname:$email?secret=$secret&issuer=$appname';
    launchUrl(Uri.parse(url));
    return url;
  }

  String getGoogleAuthenticatorUriQR(String appname, String email, String key) {
    List<int> list = utf8.encode(email);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    String uri =
        'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';

    return uri;
  }
}
