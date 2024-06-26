import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rounded_date_picker/flutter_rounded_date_picker.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:frontendfluttercoach/page/auth/GoogleAuthenticator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_notification/in_app_notification.dart';
import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../model/request/registerCoachDTO.dart';
import '../../../model/response/md_Coach_get.dart';
import '../../../service/auth.dart';
import '../../../service/coach.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/dropdown/wg_dropdown_string.dart';
import '../../../widget/notificationBody.dart';
import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int copy.dart';
import '../../user/money/widgethistory/widget_history.dart';
import 'coach_editPassword.dart';

class CoachEidtProfilePage extends StatefulWidget {
  const CoachEidtProfilePage({super.key});

  @override
  State<CoachEidtProfilePage> createState() => _CoachEidtProfilePageState();
}

class _CoachEidtProfilePageState extends State<CoachEidtProfilePage> {
  // Courses
  late Future<void> loadCoachDataMethod;
  late CoachService _coachService;
  List<Coach> coachs = [];

  ///UpdateCoach
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
  final phone = TextEditingController();
  final qualification = TextEditingController();
  final property = TextEditingController();
  final birthday = TextEditingController();
  final number = TextEditingController();

  String newbirht = '';
  String oldbirht = '';
  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ชาย', 'หญิง'];
  final selectedValue = TextEditingController();
  bool _isvisible = false;

  String textErr = '';
  final _formKey = GlobalKey<FormState>();
  bool isValid = false;
  final bankName = TextEditingController();
  final List<String> listhand = [
    'ธนาคารกรุงเทพ',
    'ธนาคารกรุงไทย',
    'ธนาคารกรุงศรีอยุธยา',
    'ธนาคารกสิกรไทย',
    'ธนาคารทิสโก้',
    'ธนาคารเกียรตินาคินภัทร',
    'ธนาคารซีไอเอ็มบี ไทย',
    'ธนาคารทหารไทยธนชาต',
    'ธนาคารไทยพาณิชย์',
    'ธนาคารยูโอบี',
    'ธนาคารแลนด์ แอนด์ เฮ้าส์',
    'ธนาคารสแตนดาร์ดชาร์เตอร์ด (ไทย)',
    'ธนาคารไอซีบีซี (ไทย)',
    'ธนาคารไทยเครดิต เพื่อรายย่อย',
    'ธนาคารเมกะ สากลพาณิชย์',
    'ธนาคารแห่งประเทศจีน (ไทย)',
    'ธนาคารเจพีมอร์แกน เชส',
    'ธนาคารซิตี้แบงก์ เอ็น.เอ.'
  ];

  @override
  void initState() {
    super.initState();
    _coachService = context.read<AppData>().coachService;
    _authService = context.read<AppData>().authService;
    loadCoachDataMethod = loadCoachData();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold(context);
  }

  Scaffold scaffold(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: ListView(
        children: [
          showCoach(),
        ],
      )),
    );
  }

  Widget button() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      // height: MediaQuery.of(context).size.height ,
      child: FilledButton(
        //style: style,
        onPressed: () async {
          _formKey.currentState!.validate();

          log(int.parse(phone.text).isNegative.toString());
          if (fullName.text.isEmpty ||
              name.text.isEmpty ||
              selectedValue.text.isEmpty ||
              phone.text.isEmpty ||
              email.text.isEmpty ||
              qualification.text.isEmpty ||
              property.text.isEmpty) {
            setState(() {
              _isvisible = true;
              textErr = 'กรุณากรอกข้อความในช่องว่างให้ครบ';
            });
          } else if (isValid == false) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขให้ถูกต้อง';
            });
          } else if (int.parse(phone.text).isNegative == true) {
            setState(() {
              _isvisible = true;
              textErr = 'เบอร์โทรศัพท์มีค่าติดลบ';
            });
          } else {
            setState(() {
              _isvisible = false;
              textErr = '';
            });
            startLoading(context);
            if (pickedImg != null) await uploadfile();
            if (pickedImg == null) profile = coachs.first.image;
            if (newbirht.isEmpty) {
              newbirht = oldbirht;
            }
            RegisterCoachDto request = RegisterCoachDto(
                fullName: fullName.text,
                username: name.text,
                email: email.text,
                password: coachs.first.password,
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
                facebookId: coachs.first.facebookId,
                bankName: bankName.text,
                idCard: number.text);
            log(jsonEncode(request));
            var result = await _authService.updateCoach(
                // ignore: use_build_context_synchronously
                context.read<AppData>().cid.toString(),
                request);
            modelResult = result.data;
            log(modelResult.result);
            stopLoading();
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              //Navigator.pop(context);

              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขสำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            } else if (modelResult.result == '-14') {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'มีอีเมลนี้ซํ้าในระบบ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            } else {
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขไม่สำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            }
            log(modelResult.result);
          }
        },
        child: const Text('บันทึก'),
      ),
    );
  }

  //LoadData
  Future<void> loadCoachData() async {
    try {
      //Courses
      var datas = await _coachService.coach(
          nameCoach: '',
          cid: context.read<AppData>().cid.toString(),
          email: '');
      coachs = datas.data;

      fullName.text = coachs.first.fullName;
      name.text = coachs.first.username;
      email.text = coachs.first.email;
      phone.text = coachs.first.phone;
      qualification.text = coachs.first.qualification;
      property.text = coachs.first.property;
      birthday.text = thaiDate(coachs.first.birthday);
      oldbirht = coachs.first.birthday;
      number.text = coachs.first.idCard;
      bankName.text = coachs.first.bankName;
      if (coachs.first.gender == '2') {
        selectedValue.text = LevelItems[0];
      } else {
        selectedValue.text = LevelItems[1];
      }
    } catch (err) {
      log('Error: $err');
    }
  }

  Widget showCoach() {
    Size screenSize = MediaQuery.of(context).size;
    double width = (screenSize.width > 550) ? 550 : screenSize.width;
    return FutureBuilder(
        future: loadCoachDataMethod, // 3.1 object ของ async method
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
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
                          log(coachs.first.email);
                          Get.to(() => GoogleAuthenticatorPage(
                                    email: coachs.first.email,
                                    password: coachs.first.password,
                                  ))!
                              .then((value) {
                            setState(() {
                              loadCoachDataMethod = loadCoachData();
                            });
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  image(),
                  const SizedBox(
                    height: 10,
                  ),
                  WidgetTextFieldString(
                    controller: name,
                    labelText: 'ชื่อเรียกในระบบ',
                  ),
                  WidgetTextFieldString(
                    controller: email,
                    labelText: 'Email',
                  ),
                  WidgetTextFieldString(
                    controller: fullName,
                    labelText: 'ชื่อ-นามสกุล',
                  ),
                  Form(
                    key: _formKey,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        SizedBox(
                          width: (width - 16 - (3 * 30)) / 2,
                          child: Padding(
                            padding:
                                const EdgeInsets.only(bottom: 10, left: 15),
                            child: WidgetDropdownString(
                              title: 'เพศ',
                              selectedValue: selectedValue,
                              listItems: LevelItems,
                            ),
                          ),
                        ),
                        Expanded(
                          child: textForimField(
                              context, phone, 'เบอร์โทรศัพท์', 10),
                        ),
                      ],
                    ),
                  ),
                  txtfildBirth(birthday, "วันเกิด"),
                  const Divider(endIndent: 20, indent: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15),
                    child: WidgetDropdownString(
                      title: 'ชื่อธนาคาร',
                      selectedValue: bankName,
                      listItems: listhand,
                    ),
                  ),
                  WidgetTextFieldInt(
                    controller: number,
                    labelText: 'เลขบัญชีธนาคาร',
                    maxLength: 10,
                  ),
                  WidgetTextFieldLines(
                    controller: qualification,
                    labelText: 'วุฒิการศึกษา',
                  ),
                  WidgetTextFieldLines(
                    controller: property,
                    labelText: 'ประวัติส่วนตัว',
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
                            textErr,
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
                                password: coachs.first.password,
                                id: context.read<AppData>().cid.toString(),
                                visible: true,
                              ));
                        },
                      ),
                    ],
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: button(),
                  ),
                ],
              ),
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  Center image() {
    return Center(
      child: Stack(
        children: [
          if (pickedImg != null) ...{
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  border: Border.all(width: 3, color: Colors.cyan),
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
          } else
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                  border: Border.all(
                      width: 4, color: const Color.fromARGB(255, 255, 151, 33)),
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(coachs.first.image),
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
                    FontAwesomeIcons.image,
                    color: Colors.white,
                  ),
                ),
              ))
        ],
      ),
    );
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

  //
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

  textForimField(BuildContext context, TextEditingController controller,
      String labelText, int maxLength) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5, bottom: 3),
            child: Text(
              labelText,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          TextFormField(
              keyboardType: TextInputType.number,
              controller: controller,
              validator: (value) {
                isValid = isNumeric(value!); // false
                return null;
              },
              maxLength: maxLength,
              textAlignVertical: TextAlignVertical.center,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 9, horizontal: 12),
                  counterText: "",
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.background)),
        ],
      ),
    );
  }
}
