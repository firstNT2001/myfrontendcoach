import 'dart:developer';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/request/registerCusDTO.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../model/request/registerCoachDTO.dart';
import '../../model/response/md_Result.dart';
import '../../service/auth.dart';
import '../../service/provider/appdata.dart';
import '../../widget/dropdown/wg_dropdown_notValue_string.dart';
import '../../widget/textField/wg_textField.dart';
import '../../widget/textField/wg_textFieldLines.dart';
import '../../widget/textField/wg_textField_int copy.dart';

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

  String textErr = '';
  bool passwordVisible = true;

  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ชาย', 'หญิง'];
  final selectedValue = TextEditingController();

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
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    return Column(children: [
      if (pickedImg != null) ...{
        Center(
          child: ClipOval(
            child: Material(
              child: InkWell(
                onTap: () {
                  selectImg();
                },
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(60), // Image radius
                  child: Image(
                      image: FileImage(
                        File(pickedImg!.path!),
                      ),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      } else
        Center(
          child: ClipOval(
            child: Material(
              child: InkWell(
                onTap: () {
                  selectImg();
                },
                child: SizedBox.fromSize(
                  size: const Size.fromRadius(60), // Image radius
                  child: Image.network(
                      'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg',
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 10, left: 20, right: 20),
        child: WidgetTextFieldString(
          controller: fullName,
          labelText: 'ชื่อ',
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: (width - 16 - (3 * 20)) / 2,
              child: WidgetTextFieldString(
                controller: name,
                labelText: 'ชื่อเล่น',
              ),
            ),
            SizedBox(
              width: (width - 16 - (3 * 20)) / 2,
              child: WidgetDropdownStringNotValue(
                title: 'เพศ',
                selectedValue: selectedValue, ListItems: LevelItems,
                //listItems: LevelItems,
              ),
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
        child: WidgetTextFieldInt(
          controller: phone,
          labelText: 'เบอร์โทร',
          maxLength: 10,
        ),
      ),
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
        child: TextPassword(
          password1,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
        child: TextPassword(
          password2,
        ),
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
              SizedBox(
                width: (width - 16 - (3 * 20)) / 2,
                child: WidgetTextFieldInt(
                  controller: weight,
                  labelText: 'นํ้าหนัก',
                  maxLength: 4,
                ),
              ),
              SizedBox(
                width: (width - 16 - (3 * 20)) / 2,
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
        Padding(
          padding: const EdgeInsets.only(bottom: 8, left: 20, right: 20),
          child: WidgetTextFieldLines(
            controller: qualification,
            labelText: 'วุฒิการศึกษา',
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
          child: WidgetTextFieldLines(
            controller: property,
            labelText: 'ประวัติส่วนตัว',
          ),
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
      button(),
    ]);
  }

  Widget button() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: MediaQuery.of(context).size.height ,
        child: FilledButton(
          //style: style,
          onPressed: () async {
            
            if (fullName.text == '' ||
                name.text == '' ||
                selectedValue.text == '' ||
                phone.text == '' ||
                email.text == '' ||
                password1.text == '' ||
                password2.text == '') {
              setState(() {
                textErr = 'กรุณากรอกข้อมูลให้ครบ';
              });
            } else if (password1.text != password2.text) {
              setState(() {
                textErr = 'รหัสไม่ตรงกัน';
              });
            } else if (validate(email.text) == false ) {
              setState(() {
                textErr = 'อีมลไม่ถูกต้อง';
              });
            }else {
              if (pickedImg != null) await uploadfile();
              if (pickedImg == null) {
                profile =
                    'https://t3.ftcdn.net/jpg/03/46/83/96/360_F_346839683_6nAPzbhpSkIpb8pmAwufkC7c5eD7wYws.jpg';
              }
              if (widget.isVisible == true) {
                if (height.text != '' || weight.text != '') {
                  RegisterCusDto request = RegisterCusDto(
                    fullName: fullName.text,
                    username: name.text,
                    email: email.text,
                    password: password1.text,
                    image: profile,
                    gender: (selectedValue.text) == 'ชาย'
                        ? '2'
                        : (selectedValue.text == 'หญิง')
                            ? '1'
                            : '1',
                    phone: phone.text,
                    birthday: '2002-02-14T00:00:00Z',
                    height: int.parse(height.text),
                    weight: int.parse(weight.text),
                  );
                  var result = await _authService.regCus(request);
                  modelResult = result.data;
                  log(modelResult.result);
                } else {
                  setState(() {
                    textErr = 'กรุณากรอกข้อมูลให้ครบ';
                  });
                }
              } else {
                if (property.text != '' || qualification.text != '') {
                  RegisterCoachDto request = RegisterCoachDto(
                      fullName: fullName.text,
                      username: name.text,
                      email: email.text,
                      password: password1.text,
                      image: profile,
                      gender: (selectedValue.text) == 'ชาย'
                          ? '2'
                          : (selectedValue.text == 'หญิง')
                              ? '1'
                              : '1',
                      phone: phone.text,
                      birthday: '2002-02-14T00:00:00Z',
                      property: property.text,
                      qualification: qualification.text,
                      facebookId: '');
                  var result = await _authService.regCoach(request);
                  modelResult = result.data;
                  log(modelResult.result);
                } else {
                  setState(() {
                    textErr = 'กรุณากรอกข้อมูลให้ครบ';
                  });
                }
              }
            }
          },
          child: const Text('สมัครสมาชิก'),
        ),
      ),
    );
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
}
