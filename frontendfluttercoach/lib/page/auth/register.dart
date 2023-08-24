import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/registerCusDTO.dart';
import 'package:frontendfluttercoach/page/auth/login.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';

import '../../model/request/registerCoachDTO.dart';
import '../../model/response/md_Result.dart';
import '../../service/auth.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dropdown/wg_dropdown_notValue_string.dart';
import '../../widget/notificationBody.dart';
import '../../widget/textField/wg_textField.dart';
import '../../widget/textField/wg_textFieldLines.dart';
import '../../widget/textField/wg_textField_int copy.dart';
import '../../widget/textField/wg_textField_password.dart';
import '../user/money/widgethistory/widget_history.dart';

import 'package:crypto/crypto.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.isVisible});
  final bool isVisible;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //Service
  late AuthService _authService;
  late ModelResult modelResult;

  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = " ";

  //Controller
  final fullName = TextEditingController();
  final name = TextEditingController();
  final email = TextEditingController();
  final password1 = TextEditingController();
  final password2 = TextEditingController();
  final phone = TextEditingController();

  final weight = TextEditingController();
  final height = TextEditingController();

  final qualification = TextEditingController();
  final property = TextEditingController();
  final birthday = TextEditingController();

  String textErr = '';
  bool passwordVisible = true;

  String newbirht = '';
  String oldbirht = '';

  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ชาย', 'หญิง'];
  final selectedValue = TextEditingController();
  //FB
  late Map<String, dynamic> userFacebook;
  String facebookID = '';
  // Method to validate the email the take
  // the user email as an input and
  // print the bool value in the console.
  bool validate(String email) {
    bool isvalid = EmailValidator.validate(email);
    return isvalid;
  }

  @override
  void initState() {
    super.initState();
    _authService = context.read<AppData>().authService;
    userFacebook = context.read<AppData>().userFacebook;
    log(userFacebook.isNotEmpty.toString());
    if (userFacebook.isNotEmpty) {
      email.text = userFacebook['email'];
      fullName.text = userFacebook['name'];
      profile = userFacebook['picture']['data']['url'];
      facebookID = userFacebook['id'];
    } else {
      email.text = "";
      fullName.text = "";
      profile = "";
      facebookID = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สมัครสมาชิก",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: ListView(
        children: [
          InputREG(),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Column InputREG() {
    return Column(children: [
      Center(
        child: Stack(
          children: [
            if (pickedImg != null) ...{
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(width: 3, color: Colors.cyan),
                    boxShadow: const [
                      BoxShadow(
                          spreadRadius: 2,
                          blurRadius: 10,
                          color: Color.fromARGB(255, 255, 151, 33))
                    ],
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: FileImage(
                          File(pickedImg!.path!),
                        ),
                        fit: BoxFit.cover)),
              ),
            } else
              Container(
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                    border: Border.all(
                        width: 4,
                        color: const Color.fromARGB(255, 255, 151, 33)),
                    shape: BoxShape.circle,
                    image: const DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                          'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg'),
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
                        border: Border.all(width: 4, color: Colors.white),
                        color: const Color.fromARGB(255, 255, 151, 33)),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ))
          ],
        ),
      ),
      WidgetTextFieldString(
        controller: fullName,
        labelText: 'ชื่อ-นามสกุล',
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: WidgetTextFieldString(
                controller: name,
                labelText: 'ชื่อเรียกในระบบ',
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: WidgetDropdownStringNotValue(
                  title: 'เพศ',
                  selectedValue: selectedValue, ListItems: LevelItems,
                  //listItems: LevelItems,
                ),
              ),
            ),
          ],
        ),
      ),
      WidgetTextFieldInt(
        controller: phone,
        labelText: 'เบอร์โทรศัพท์',
        maxLength: 10,
      ),
      txtfildBirth(birthday, "วันเกิด"),
      const Divider(endIndent: 20, indent: 20),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('อีเมลผู้ใช้ (email)'),
            TextField(
                controller: email,
                //autofocus: true,
                // onChanged: (String value) {
                //   setState(() => chackNameAndPassword = "");
                // },
                textAlignVertical: TextAlignVertical.center,
                // textAlign: TextAlign.center,
                decoration: InputDecoration(
                    prefixIcon: const Icon(FontAwesomeIcons.solidUser),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.background)),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
        child: TextFieldPassword(
          controller: password1,
          title: 'รหัสผ่าน',
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
        child:
            TextFieldPassword(controller: password2, title: 'ยืนยันรหัสผ่าน'),
      ),
      const Divider(endIndent: 20, indent: 20),
      Visibility(
        visible: widget.isVisible,
        child: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: WidgetTextFieldInt(
                  controller: weight,
                  labelText: 'นํ้าหนัก',
                  maxLength: 4,
                ),
              ),
              Expanded(
                child: WidgetTextFieldInt(
                  controller: height,
                  labelText: 'ส่วนสูง',
                  maxLength: 4,
                ),
              ),
            ],
          ),
        ),
      ),
      if (widget.isVisible == false) ...{
        WidgetTextFieldLines(
          controller: qualification,
          labelText: 'วุฒิการศึกษา',
        ),
        WidgetTextFieldLines(
          controller: property,
          labelText: 'ประวัติส่วนตัว',
        ),
      },
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 8, left: 20, right: 23),
            child: Text(
              textErr,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          // height: MediaQuery.of(context).size.height ,
          child: FilledButton(
            //style: style,
            onPressed: () {
              reg(context);
            },
            child: const Text('สมัครสมาชิก'),
          ),
        ),
      ),
    ]);
  }

  void reg(BuildContext context) async {
    setState(() {
      textErr = '';
    });
    startLoading(context);
    if (fullName.text == '' ||
        name.text == '' ||
        selectedValue.text == '' ||
        phone.text == '' ||
        email.text == '' ||
        password1.text == '' ||
        password2.text == '' ||
        birthday.text.isEmpty) {
      setState(() {
        textErr = 'กรุณากรอกข้อมูลให้ครบ';
      });
      stopLoading();
    } else if (phone.text.length != 10) {
      setState(() {
        textErr = 'กรุณากรอกเบอร์โทรศัพท์ให้ถูกต้อง';
      });
      stopLoading();
    } else if (password1.text != password2.text) {
      setState(() {
        textErr = 'รหัสไม่ตรงกัน';
      });
      stopLoading();
    } else if (validate(email.text) == false) {
      setState(() {
        textErr = 'อีมลไม่ถูกต้อง';
      });
      stopLoading();
    } else if (int.parse(phone.text).isNegative == true) {
      setState(() {
        textErr = 'กรุณากรอกตัวเลขมากกว่า 0';
      });
      stopLoading();
    } else {
      String encryptedPassword = encryptPassword(password1.text);
      log(encryptedPassword);
      if (pickedImg != null) await uploadfile();
      if (pickedImg == null) {
        profile =
            'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg';
      }
      if (widget.isVisible == true) {
        if (height.text == '' || weight.text == '') {
          setState(() {
            textErr = 'กรุณาใส่นํ้าหนักหรือส่วนสูง';
          });
          stopLoading();
        } else {
          setState(() {
            textErr = '';
          });
          if (int.parse(height.text).isNegative == true ||
              int.parse(weight.text).isNegative == true) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขมากกว่า 0';
            });
            stopLoading();
          } else {
            RegisterCusDto request = RegisterCusDto(
              fullName: fullName.text,
              username: name.text,
              email: email.text,
              password: encryptedPassword,
              image: profile,
              gender: (selectedValue.text) == 'ชาย'
                  ? '2'
                  : (selectedValue.text == 'หญิง')
                      ? '1'
                      : '1',
              phone: phone.text,
              birthday: newbirht,
              height: int.parse(height.text),
              weight: int.parse(weight.text),
            );
            var result = await _authService.regCus(request);
            modelResult = result.data;
            stopLoading();
            if (modelResult.result == '1') {
              Get.to(() => const LoginPage());
            } else if (modelResult.result == '-14') {
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'มีอีเมลนี้ซํ้าในระบบ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 3000),
              );
            } else {
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'สมัครไม่สำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 3000),
              );
            }
          }
        }
      } else {
        if (property.text != '' || qualification.text != '') {
          RegisterCoachDto request = RegisterCoachDto(
              fullName: fullName.text,
              username: name.text,
              email: email.text,
              password: encryptedPassword,
              image: profile,
              gender: (selectedValue.text) == 'ชาย'
                  ? '2'
                  : (selectedValue.text == 'หญิง')
                      ? '1'
                      : '1',
              phone: phone.text,
              birthday: newbirht,
              property: property.text,
              qualification: qualification.text,
              facebookId: facebookID);
          var result = await _authService.regCoach(request);
          modelResult = result.data;
          stopLoading();
          log('message' + modelResult.result);
          if (modelResult.result == '1') {
            Get.to(() => const LoginPage());
          } else if (modelResult.result == '-14') {
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'มีอีเมลนี้ซํ้าในระบบ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 3000),
            );
          } else {
            InAppNotification.show(
              child: NotificationBody(
                count: 1,
                message: 'สมัครไม่สำเร็จ',
              ),
              context: context,
              onTap: () => print('Notification tapped!'),
              duration: const Duration(milliseconds: 3000),
            );
          }
        } else {
          setState(() {
            textErr = 'กรุณากรอกข้อมูลประวัติส่วนตัวหรือวุฒิการศึกษา';
          });
          stopLoading();
        }
      }
    }
  }

  //Image
  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedImg = result.files.first;
    });
  }

  //uploadfile
  Future uploadfile() async {
    final path = 'files/${pickedImg!.name}';
    final file = File(pickedImg!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('link img firebase $urlDownload');
    profile = urlDownload;
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

  Column TextPassword(TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Password'),
        TextField(
          obscureText: passwordVisible,
          controller: controller,
          onChanged: (value) {
            setState(() {
              textErr = '';
            });
          },
          decoration: InputDecoration(
            border: const UnderlineInputBorder(),
            // hintText: "Password",
            // labelText: "Password",
            //helperText: "Password must contain special character",
            //helperStyle: const TextStyle(color: Colors.green),
            prefixIcon: const Icon(FontAwesomeIcons.lock),

            suffixIcon: IconButton(
              icon: Icon(
                  passwordVisible ? Icons.visibility : Icons.visibility_off),
              onPressed: () {
                setState(
                  () {
                    passwordVisible = !passwordVisible;
                  },
                );
              },
            ),
            // alignLabelWithHint: false,
            // filled: true,
          ),
          keyboardType: TextInputType.visiblePassword,
          // textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  String encryptPassword(String password) {
    final bytes = utf8.encode(password);
    final hash = sha256.convert(bytes);
    return hash.toString();
  }
}
