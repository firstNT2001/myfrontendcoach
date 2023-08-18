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
import 'package:provider/provider.dart';

import '../../../model/request/registerCoachDTO.dart';
import '../../../model/response/md_Coach_get.dart';
import '../../../service/auth.dart';
import '../../../service/coach.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/PopUp/popUp.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/dropdown/wg_dropdown_string.dart';
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

  String newbirht = '';
  String oldbirht = '';
  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ชาย', 'หญิง'];
  final selectedValue = TextEditingController();
  bool _isvisible = false;

  String textErr = '';

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
          if (fullName.text.isEmpty ||
              name.text.isEmpty ||
              selectedValue.text.isEmpty ||
              phone.text.isEmpty ||
              email.text.isEmpty ||
              qualification.text.isEmpty ||
              property.text.isEmpty) {
            setState(() {
              _isvisible = true;
            });
          } else {
            if (pickedImg != null) await uploadfile();
            if (pickedImg == null) profile = coachs.first.image;
            if (newbirht.isEmpty) {
              newbirht = oldbirht;
            }
            log("newbirht" + newbirht);
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
                facebookId: coachs.first.facebookId);
            var result = await _authService.updateCoach(
                // ignore: use_build_context_synchronously
                context.read<AppData>().cid.toString(),
                request);
            modelResult = result.data;
            if (modelResult.result == '0') {
              // ignore: use_build_context_synchronously
              warning(context);
            } else {
              // ignore: use_build_context_synchronously
              success(context);
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
                              ));
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
                            title: 'เพศ',
                            selectedValue: selectedValue,
                            listItems: LevelItems,
                          ),
                        ),
                      ),
                      Expanded(
                        child: WidgetTextFieldInt(
                          controller: phone,
                          labelText: 'เบอร์โทรศัพท์',
                          maxLength: 10,
                        ),
                      ),
                    ],
                  ),
                  txtfildBirth(birthday, "วันเกิด"),
                  const Divider(endIndent: 20, indent: 20),
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
                            "กรุณากรอกข้อความในช่องว่างให้ครบ",
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
}
