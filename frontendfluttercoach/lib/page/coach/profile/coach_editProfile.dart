import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/model/response/md_Result.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import '../../../model/request/registerCoachDTO.dart';
import '../../../model/response/md_Coach_get.dart';
import '../../../service/auth.dart';
import '../../../service/coach.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/dialogs.dart';
import '../../../widget/dropdown/wg_dropdown_string.dart';
import '../../../widget/textField/wg_textField.dart';
import '../../../widget/textField/wg_textFieldLines.dart';
import '../../../widget/textField/wg_textField_int copy.dart';

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

  //selectLevel
  // ignore: non_constant_identifier_names
  final List<String> LevelItems = ['ชาย', 'หญิง'];
  final selectedValue = TextEditingController();

  @override
  void initState() {
    super.initState();
    _coachService = context.read<AppData>().coachService;
    _authService = context.read<AppData>().authService;
    loadCoachDataMethod = loadCoachData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: ListView(
        children: [
          showCoach(),
          Padding(
                  padding:
                      const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                  child: button(),
                ),
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
          if (pickedImg != null) await uploadfile();
          if (pickedImg == null) profile = coachs.first.image;
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
              birthday: coachs.first.birthday,
              property: property.text,
              qualification: qualification.text,
              facebookId: coachs.first.facebookId);
          var result = await _authService.updateCoach(
              // ignore: use_build_context_synchronously
              context.read<AppData>().cid.toString(),
              request);
          modelResult = result.data;
          log(modelResult.result);
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
          nameCoach: '', cid: context.read<AppData>().cid.toString());
      coachs = datas.data;

      fullName.text = coachs.first.fullName;
      name.text = coachs.first.username;
      email.text = coachs.first.email;
      phone.text = coachs.first.phone;
      qualification.text = coachs.first.qualification;
      property.text = coachs.first.property;

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
            return Column(
              //mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(
                      FontAwesomeIcons.chevronLeft,
                    ),
                    onPressed: () {
                      Get.back();
                    },
                  ),
                ),
                Center(
                  child: Text(
                    'Edit Profile',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
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
                            child: Image.network(coachs.first.image,
                                fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8, top: 10, left: 20, right: 20),
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
                        child: WidgetDropdownString(
                          title: 'เพศ',
                          selectedValue: selectedValue,
                          listItems: LevelItems,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  child: WidgetTextFieldString(
                    controller: email,
                    labelText: 'Email',
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
                        child: WidgetTextFieldInt(
                          controller: phone,
                          labelText: 'เบอร์โทร',
                          maxLength: 10,
                        ),
                      ),
                      SizedBox(
                          width: (width - 16 - (3 * 20)) / 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text('เปรียนรหัสผ่าน'),
                              IconButton(
                                icon: const Icon(
                                  FontAwesomeIcons.chevronRight,
                                ),
                                onPressed: () {
                                  //Get.back();
                                },
                              ),
                            ],
                          )),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 8, left: 20, right: 20),
                  child: WidgetTextFieldLines(
                    controller: qualification,
                    labelText: 'วุฒิการศึกษา',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                  child: WidgetTextFieldLines(
                    controller: property,
                    labelText: 'ประวัติส่วนตัว',
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                  child: button(),
                ),
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  //
  //Image
  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles();
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
