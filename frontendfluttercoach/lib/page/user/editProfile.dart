import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/user/profileUser.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:hex/hex.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../model/request/updateCus.dart';
import 'package:base32/base32.dart';
import '../../model/response/md_Customer_get.dart';
import '../../model/response/md_Result.dart';
import '../../service/customer.dart';
import '../../service/provider/appdata.dart';
import '../../widget/PopUp/popUp.dart';
import '../../widget/dialogs.dart';
import '../../widget/dropdown/wg_dropdown_string.dart';
import '../../widget/textField/wg_textField.dart';
import '../../widget/textField/wg_textField_int copy.dart';
import '../../widget/textField/wg_textField_int.dart';
import '../../widget/textField/wg_tx_inputint.dart';
import '../auth/GoogleAuthenticator.dart';
import '../coach/profile/coach_editPassword.dart';
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
  late ModelResult modelResult;
  //late ModelRowsAffected modelRowsAffected;
  late UpdateCustomer cusUpdate;
  late ModelResult moduleResult;
  String GenOTP = "";
  late int uid;
  bool _isvisible = false;
  bool _isvisibleHW = false;
  bool _isvisiblephone = false;
  String tt = '';
  //controller

  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController fullName = TextEditingController();
  TextEditingController birthday = TextEditingController();
  TextEditingController gender = TextEditingController();
  TextEditingController phone = TextEditingController();
  TextEditingController weight = TextEditingController();
  TextEditingController height = TextEditingController();
  int price = 0;
  var update;
  List<String> genders = ['หญิง', 'ชาย'];
  bool isvisible = false;
  String _image = " ";
  String profile = " ";
  String newbirht = '';
  String oldbirht = '';
  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  final _formKey = GlobalKey<FormState>();
  final _formKeyphone = GlobalKey<FormState>();
  RegExp _numeric = RegExp(r'^-?[0-9]+$');
  late   bool isValidw;
  late   bool isValidh;
  late   bool isValidp;
  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    setState(() {
      pickedImg = result.files.first;
      // log(pickedImg.toString());
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
      body: SafeArea(
        child: ListView(children: [
          Column(
            children: [showProfile()],
          ),
        ]),
      ),
    );
  }

  Future<void> loadData() async {
    try {
      var result =
          await customerService.customer(uid: uid.toString(), email: '');
      customer = result.data;
      username.text = customer.first.username;
      fullName.text = customer.first.fullName;
      birthday.text = thaiDate(customer.first.birthday);
      oldbirht = customer.first.birthday;
      gender.text = customer.first.gender;
      phone.text = customer.first.phone;
      email.text = customer.first.email;
      password.text = customer.first.password;
      price = customer.first.price;
      _image = customer.first.image;
      weight.text = customer.first.weight.toString();
      height.text = customer.first.height.toString();
      //gender show
      log('เพศ: ${customer.first.gender}');
      if (customer.first.gender == "1") {
        gender.text = genders[0];
        log('เพศใหม่genders[0]: ${gender.text}');
      } else {
        gender.text = genders[1];
        log('เพศใหม่genders[1]: ${gender.text}');
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  txtfildBirth(final TextEditingController _controller, String txtTop) {
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
          readOnly: true,
          onTap: () {
            log("message");
            CupertinoRoundedDatePicker.show(
              context,
              fontFamily: "Mali",
              textColor: Colors.white,
              era: EraMode.BUDDHIST_YEAR,
              background: Colors.orangeAccent,
              borderRadius: 16,
              minimumYear: DateTime.now().year - 40,
              initialDatePickerMode: CupertinoDatePickerMode.date,
              onDateTimeChanged: (newDateTime) {
                var dateFormat = '${newDateTime.toIso8601String()}Z';
                newbirht = dateFormat.toString();
                String newBirthday = thaiDate(newDateTime.toString());
                setState(() => birthday.text = newBirthday);
              },
            );
          },
          controller: _controller,
          decoration: const InputDecoration(
            suffixIcon: Icon(FontAwesomeIcons.calendarDay,
                color: Color.fromARGB(255, 37, 37, 37)),
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
              padding: const EdgeInsets.all(5.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.chevronLeft,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                          const Center(
                            child: Padding(
                              padding: EdgeInsets.only(top: 5),
                              child: Text(
                                'แก้ไขโปรไฟล์',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(
                              FontAwesomeIcons.key,
                              // color: Colors.red,
                            ),
                            // pushNewScreen(
                            //   context,
                            //   screen: const ProfileUser(),
                            //   withNavBar: true,
                            // );
                            onPressed: () {
                              Get.to(() => GoogleAuthenticatorPage(
                                    email: customer.first.email,
                                    password: customer.first.password,
                                  ));
                            },
                          ),
                        ],
                      ),
                    ),
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
                                      color: const Color.fromARGB(
                                          255, 255, 151, 33)),
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
                                  selectImg();
                                },
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 4, color: Colors.white),
                                      color: const Color.fromARGB(
                                          255, 255, 151, 33)),
                                  child: const Icon(
                                    FontAwesomeIcons.image,
                                    color: Colors.white,
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    WidgetTextFieldString(
                      controller: username,
                      labelText: 'ชื่อผู้ใช้',
                    ),
                    WidgetTextFieldString(
                      controller: email,
                      labelText: 'Email',
                    ),
                    WidgetTextFieldString(
                      controller: fullName,
                      labelText: 'ชื่อ-นามสกุล',
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: (width - 16 - (3 * 30)) / 2,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 10, left: 15),
                            child: WidgetDropdownString(
                                title: "เพศ",
                                selectedValue: gender,
                                listItems: genders),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 15, right: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                 Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 3),
                                  child: Text(
                                    "หมายเลขโทรศัพท์",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: phone,
                                  validator: (value) {
                                          isValidp = isNumeric(value!); // false
                                          log(isValidp.toString());
                                          if (isValidp == true) {
                                            log("BB");
                                          } else {
                                        log("FF");
                                            setState(() {
                                               
                                              _isvisibleHW =true;
                                              log("PP");
                                            });
                                          }
              
                                          return null;
                                        },
                                         maxLength: 3,
                                        textAlignVertical: TextAlignVertical.center,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                            contentPadding: EdgeInsets.symmetric(
                                                vertical: 9, horizontal: 12),
                                            counterText: "",
                                            filled: true,
                                            fillColor: Theme.of(context)
                                                .colorScheme
                                                .background)
                                ),
                              ],
                            )
                            // WidgetTextFieldInt(
                            //   controller: phone,
                            //   labelText: 'เบอร์โทรศัพท์',
                            //   maxLength: 10,
                            // ),
                          ),
                        ),
                      ],
                    ),
                    txtfildBirth(birthday, "วันเกิด"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 15, right: 15),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 3),
                                  child: Text(
                                    "น้ำหนัก (กิโลกรัม)",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: weight,
                                    validator: (value) {
                                      isValidw = isNumeric(value!); // false
                                      log(isValidw.toString());
                                      if (isValidw == true) {
                                        log("BB");
                                      } else {
                                    log("FF");
                                        setState(() {
                                           
                                          _isvisibleHW =true;
                                          log("PP");
                                        });
                                      }
              
                                      return null;
                                    },
                                     maxLength: 3,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            vertical: 9, horizontal: 12),
                                        counterText: "",
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .background)),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 15, right: 15),
                            child: Column(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 5, bottom: 3),
                                  child: Text(
                                    "ส่วนสูง (เซนติเมตร)",
                                    style:
                                        Theme.of(context).textTheme.bodyLarge,
                                  ),
                                ),
                                TextFormField(
                                    keyboardType: TextInputType.number,
                                    controller: height,
                                    validator: (value) {
                                      isValidh = isNumeric(value!); // false
                                      log(isValidh.toString());
                                      if (isValidh == true) {
                                        log("BB");
                                      } else {
                                        log("CC");
                                        setState(() {
                                           
                                          _isvisibleHW =true;
                                          log("DD");
                                        });
                                      }
              
                                      return null;
                                    },
                                     maxLength: 3,
                                    textAlignVertical: TextAlignVertical.center,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 9, horizontal: 12),
                                        counterText: "",
                                        filled: true,
                                        fillColor: Theme.of(context)
                                            .colorScheme
                                            .background)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
                    Visibility(
                      visible: _isvisibleHW,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 20, right: 23),
                            child: Text(
                              "กรุณากรอกข้อความให้ถูกต้อง",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: _isvisiblephone,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 8, left: 20, right: 23),
                            child: Text(
                              "กรุณากรอกเบอร์โทรศัพให้ถูกต้อง",
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.error),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        const Text('เปลี่ยนรหัสผ่าน'),
                        IconButton(
                          icon: const Icon(
                            FontAwesomeIcons.chevronRight,
                          ),
                          onPressed: () {
                            Get.to(() => CoachEditPassword(
                                  password: password.text,
                                  id: context.read<AppData>().cid.toString(),
                                  visible: true,
                                ));
                            // Get.to(() => EditPasswordPage(
                            //       password: _password.text
                            //     ));
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 10),
                      child: SizedBox(
                        width: 350,
                        child: FilledButton(
                            child: Text("บันทึก"),
                            onPressed: () async {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  setState(() {
                                    _isvisibleHW = false;
                                  });
                                });
                              }
                                if (pickedImg != null) await uploadfile();
                                if (pickedImg == null) profile = _image;
                                if (_formKey.currentState!.validate()) {
                                  // If the form is valid, display a snackbar. In the real world,
                                  // you'd often call a server or save the information in a database.
                                  setState(() {
                                    _isvisibleHW = false;
                                    _isvisible = false;
                                  });
                                }
                                if (username.text.isEmpty ||
                                    email.text.isEmpty ||
                                    fullName.text.isEmpty ||
                                    phone.text.isEmpty ||
                                    weight.text.isEmpty ||
                                    gender.text.isEmpty ||
                                    height.text.isEmpty) {
                                  setState(() {
                                    _isvisible = true;
                                    _isvisibleHW = false;
                                  });
                                }
                                if(isValidw==false||isValidh==false||isValidp==false||int.parse(weight.text) < 1 ||
                                    int.parse(height.text) < 1||int.parse(weight.text) > 150 ||
                                    int.parse(height.text) > 200||phone.text.length<10) {
                                  setState(() {
                                    _isvisible = false;
                                    _isvisibleHW = true;
                                  });
                                } else {
                                  startLoading(context);
                                  // var formatter = DateFormat.yMMMd( _birthday.text);
                                  // log("formatter"+formatter.toString());
                                  if (newbirht.isEmpty) {
                                    newbirht = oldbirht;
                                  }
                                  if (gender.text == 'ชาย') {
                                    log("newg3" + gender.text);
                                    tt = '2';
                                    log("newg1=" + tt);
                                  } else {
                                    tt = '1';
                                    log("newg2=" + tt);
                                  }
                                  if (phone.text.length != 10) {
                                    log("Erorphone");
                                  }
              
                                  UpdateCustomer updateCustomer = UpdateCustomer(
                                      username: username.text,
                                      password: password.text,
                                      email: email.text,
                                      fullName: fullName.text,
                                      birthday: newbirht,
                                      gender: tt,
                                      phone: phone.text,
                                      image: profile,
                                      weight: int.parse(weight.text),
                                      height: int.parse(height.text));
                                  log("Update");
                                  log(jsonEncode(updateCustomer));
                                  log("log" + uid.toString());
                                  log(birthday.text);
                                  //log(_image.toString());
                                  update = await customerService.updateCustomer(
                                      uid.toString(), updateCustomer);
                                  moduleResult = update.data;
                                  log(moduleResult.result);
                                  modelResult = update.data;
                                  if (modelResult.result == '0') {
                                    // ignore: use_build_context_synchronously
                                    stopLoading();
                                    warning(context);
                                  } else {
                                     stopLoading();
                                    // ignore: use_build_context_synchronously
                                   // success(context);
                                   
                                   pushNewScreen(
                              context,
                              screen: const ProfileUser(),
                              withNavBar: true,
                            );
              
                                  }
                                }
              
                       
                              
                            }),
                      )
                )],
                ),
              ),
            );
          }
        });
  }

  bool isNumeric(String str) {
    return _numeric.hasMatch(str);
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
