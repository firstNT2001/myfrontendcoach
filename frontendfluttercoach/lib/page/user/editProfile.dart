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
import 'package:otp/otp.dart';

import 'package:provider/provider.dart';
import 'package:retrofit/retrofit.dart';
import 'package:syncfusion_flutter_barcodes/barcodes.dart';
import '../../model/request/updateCus.dart';
import 'package:base32/base32.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_Result.dart';

import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import 'package:dropdown_button2/dropdown_button2.dart';

import '../auth/password.dart';

// ignore: camel_case_types
class editProfileCus extends StatefulWidget {
  //สร้างตัวแปรรับconstructure
  final int uid;

  const editProfileCus({super.key, required this.uid});

  @override
  State<editProfileCus> createState() => _editProfileCusState();
}

class _editProfileCusState extends State<editProfileCus> {
  //call service
  late Future<void> loadDataMethod;
  late CustomerService customerService;
  late HttpResponse<Customer> customer;
  //late ModelRowsAffected modelRowsAffected;
  late UpdateCustomer cusUpdate;
  late ModelResult moduleResult;
  String GenOTP = "";
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
  final List<String> genders = ['ผู้หญิง', 'ผู้ชาย'];
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
      customer = await customerService.customer(uid: widget.uid.toString());

      _uid.text = customer.data.uid.toString();
      _username.text = customer.data.username;
      _fullName.text = customer.data.fullName;
      _birthday.text = customer.data.birthday;
      _gender.text = customer.data.gender;
      _phone.text = customer.data.phone;
      _email.text = customer.data.email;
      _password.text = customer.data.password;
      _facebookID.text = customer.data.facebookId;
      price = customer.data.price;
      _image = customer.data.image;
      _weight.text = customer.data.weight.toString();
      _height.text = customer.data.height.toString();
      log("b1" + _birthday.text);
      log("b2" + customer.data.birthday);
      log("_IMAGE==" + _image);
      //gender show
      if (_gender.text == "1") {
        _gender.text = "ชาย";
      } else {
        _gender.text = "หญิง";
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        txtTop,
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      TextField(
        controller: _controller,
        decoration: InputDecoration(
          border: OutlineInputBorder(),
          hintText: lbText,
        ),
      ),
    ]);
  }

  Widget showProfile() {
    return FutureBuilder(
        future: loadDataMethod,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          } else {
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
                                  fit: BoxFit.cover,
                                  image: NetworkImage(customer.data.image),
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
                                    color: Colors.amber),
                                child: Icon(
                                  Icons.edit,
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
                  txtfild(_username, "ชื่อผู้ใช้", "ชื่อผู้ใช้"),
                  txtfild(_email, "e-mail", "e-mail"),
                  // txtfildn(_password, "รหัสผ่าน", "รหัสผ่าน"),
                  FilledButton(
                      onPressed: () async {
                        GenOTP = getGoogleAuthenticatorUri(
                            "Coaching", _email.text, _password.text);
                        log(GenOTP);
                        if (GenOTP.isNotEmpty) {
                          setState(() {
                            isvisible = true;
                          });
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
                        FilledButton(
                            onPressed: () {
                              setState(() {
                                isvisible = false;
                              });
                            },
                            child: Text("ซ่อน QR Code"))
                      ],
                    ),
                  ),
                  txtfild(_email, "e-mail", "e-mail"),
                  txtfild(_fullName, "ชื่อ-นามสกุล", "ชื่อ-นามสกุล"),
                  buildDropdownGender(),
                  txtfild(_phone, "โทรศัพท์", "โทรศัพท์"),
                  txtfild(_weight, "น้ำหนัก", "น้ำหนัก"),
                  txtfild(_height, "ส่วนสูง", "ส่วนสูง"),
                  Row(
                    children: [
                      const Text('เปรียนรหัสผ่าน'),
                      IconButton(
                        icon: const Icon(
                          FontAwesomeIcons.chevronRight,
                        ),
                        onPressed: () {
                          Get.to(() => EditPasswordPage(
                                password: _password.text,
                              ));
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
                          log("log" + widget.uid.toString());
                          log(_birthday.text);
                          //log(_image.toString());
                          update = await customerService.updateCustomer(
                              widget.uid.toString(), updateCustomer);
                          moduleResult = update.data;
                          log(moduleResult.result);
                          Get.to(() => const ProfileUser());
                        }),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        uploadfile();
                      },
                      child: Text("upload"))
                ],
              ),
            );
          }
        });
  }

  String? selectGender;
  List<DropdownMenuItem<String>> _addDividersAfterGender(List<String> genders) {
    List<DropdownMenuItem<String>> _genders = [];
    for (var gender in genders) {
      _genders.addAll(
        [
          DropdownMenuItem<String>(
            value: gender,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                gender,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          //If it's last item, we will not add Divider after it.
          if (gender != genders.last)
            const DropdownMenuItem<String>(
              enabled: false,
              child: Divider(),
            ),
        ],
      );
    }
    return _genders;
  }

  List<double> _getCustomGenderHeights() {
    List<double> _gendersHeights = [];
    for (var i = 0; i < (genders.length * 2) - 1; i++) {
      if (i.isEven) {
        _gendersHeights.add(40);
      }
      //Dividers indexes will be the odd indexes
      if (i.isOdd) {
        _gendersHeights.add(4);
      }
    }
    return _gendersHeights;
  }

  Widget buildDropdownGender() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'เพศ',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        DropdownButtonHideUnderline(
          child: DropdownButton2(
            isExpanded: true,
            hint: Text(
              _gender.text,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            items: _addDividersAfterGender(genders),
            value: selectGender,
            onChanged: (value) {
              //log("5555"+selectedValue);

              setState(() {
                selectGender = value as String;

                log("va= " + value.toString());
              });
              log(customer.data.gender);
            },
            buttonStyleData: ButtonStyleData(
              //height: 33,
              padding: const EdgeInsets.only(left: 14, right: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(width: 1),
              ),
            ),
            dropdownStyleData: const DropdownStyleData(
              maxHeight: 200,
            ),
            menuItemStyleData: MenuItemStyleData(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              customHeights: _getCustomGenderHeights(),
            ),
          ),
        ),
      ],
    );
  }

  String getGoogleAuthenticatorUri(String appname, String email, String key) {
    List<int> list = utf8.encode(key);
    String hex = HEX.encode(list);
    String secret = base32.encodeHexString(hex);
    log('secret $secret');
    String uri =
        'otpauth://totp/${Uri.encodeComponent('$appname:$email?secret=$secret&issuer=$appname')}';

    return uri;
  }
}
