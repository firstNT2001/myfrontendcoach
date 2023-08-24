import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../model/request/listFood_coachID_post.dart';

import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';

import '../../../../widget/notificationBody.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';

class FoodNewCoachPage extends StatefulWidget {
  const FoodNewCoachPage({super.key});

  @override
  State<FoodNewCoachPage> createState() => _FoodNewCoachPageState();
}

class _FoodNewCoachPageState extends State<FoodNewCoachPage> {
  //Services
  late ListFoodServices _listfoodService;
  late ModelResult modelResult;
  var insertFood;
  //inputServices
  int cid = 0;
  TextEditingController name = TextEditingController();
  String image =
      "https://firebasestorage.googleapis.com/v0/b/logindailyworkout-26860.appspot.com/o/files%2F%E0%B9%84%E0%B8%82%E0%B9%88%E0%B9%80%E0%B8%88%E0%B8%B5%E0%B8%A2%E0%B8%A7%E0%B9%84%E0%B8%A3%E0%B9%89%E0%B8%99%E0%B9%89%E0%B8%B3%E0%B8%A1%E0%B8%B1%E0%B8%99.jpg?alt=media&token=46b22ea3-7e7b-4df2-8b37-fbdc317c1319";
  TextEditingController details = TextEditingController();
  TextEditingController calories = TextEditingController();

  //Image
  //selectimg
  PlatformFile? pickedImg;
  UploadTask? uploadTask;
  String profile = "";

  String textErr = '';
  final _formKey = GlobalKey<FormState>();
  bool isValid = true;
  @override
  void initState() {
    super.initState();

    _listfoodService = context.read<AppData>().listfoodServices;
    log(context.read<AppData>().baseurl);
    cid = context.read<AppData>().cid;

    // name.text = "ไข่เจียวไร้น้ำมันหมู22";
    // details.text =
    //     "ไข่เจียว ไข่2ฟอง แครอท 30 กรัม กับหัวหอม 10 กรัม ชีส 15 กรัม ผักต้มสุกตามใจชอบ ข้าวกล้อง 200 กรัม";
    // calories.text = "260";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [inputImage(context), inputFood()],
            ),
          ],
        ),
      ),
    );
  }

  Positioned inputFood() {
    return Positioned(
        child: Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
            child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                    color: Colors.white),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 28,
                    ),
                    WidgetTextFieldString(
                      controller: name,
                      labelText: 'ขื่อเมนู',
                    ),
                    Form(
                        key: _formKey,
                        child:
                            textForimField(context, calories, 'แคลอรี่', 4)),
                    WidgetTextFieldLines(
                      controller: details,
                      labelText: 'วิธีการปรุง',
                    ),
                    Row(
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
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            bottom: 18, left: 20, right: 20),
                        child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: button(context)),
                      ),
                    ),
                  ],
                ))));
  }

  FilledButton button(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          _formKey.currentState!.validate();

          if (name.text.isEmpty ||
              details.text.isEmpty ||
              calories.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (isValid == false) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขให้ถูกต้อง';
            });
          } else if (int.parse(calories.text).isNegative == true) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขมากกว่า 0';
            });
          } else if (pickedImg == null) {
            setState(() {
              textErr = 'กรุณาใส่รูป';
            });
          } else {
            startLoading(context);
            setState(() {
              textErr = '';
            });
            if (pickedImg != null) await uploadfile();
            // if (pickedImg == null) profile = courses.first.image;
            ListFoodCoachIdPost listFoodCoachIdPost = ListFoodCoachIdPost(
                name: name.text,
                image: profile,
                details: details.text,
                calories: int.parse(calories.text));
            log(jsonEncode(listFoodCoachIdPost));
            insertFood = await _listfoodService.insertListFoodByCoachID(
                cid.toString(), listFoodCoachIdPost);
            modelResult = insertFood.data;
            log(jsonEncode(modelResult.result));
            stopLoading();
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'เพิ่มเมนูอาหารสำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
              // ignore: use_build_context_synchronously
              Navigator.pop(context);
            } else {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'เพิ่มเมนูอาหารไม่สำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            }
          }
        },
        child: const Text("บันทึก"));
  }

  Padding textForimField(BuildContext context, TextEditingController controller,
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

  Column showDialogRowsAffected(BuildContext context, int type) {
    return Column(
      children: [
        if (type == 1) ...{
          Container(),
        },
      ],
    );
  }

  //image
  //uploadfile
  Future uploadfile() async {
    final path = 'listfoods/${pickedImg!.name}';
    final file = File(pickedImg!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);
    final snapshot = await uploadTask!.whenComplete(() {});
    final urlDownload = await snapshot.ref.getDownloadURL();
    // print('link img firebase $urlDownload');
    profile = urlDownload;
  }

  Future selectImg() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.image);
    if (result == null) return;

    setState(() {
      pickedImg = result.files.first;
    });
  }

  // Image
  Stack inputImage(BuildContext context) {
    return Stack(
      children: [
        if (pickedImg != null) ...{
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1))
                ],
                // shape: BoxShape.circle,
                image: DecorationImage(
                    image: FileImage(
                      File(pickedImg!.path!),
                    ),
                    fit: BoxFit.cover)),
          ),
        } else
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            decoration: BoxDecoration(
                //borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                      spreadRadius: 2,
                      blurRadius: 10,
                      color: Colors.black.withOpacity(0.1))
                ],
                //shape: BoxShape.circle,
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://i.pinimg.com/564x/29/c2/09/29c20910e6a300754e058c541ac1b3c9.jpg"),
                )),
          ),
        Positioned(
            bottom: 60,
            right: 8,
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
                    //border: Border.all(width: 4, color: Colors.white),
                    color: Theme.of(context).colorScheme.primary),
                child: const Icon(
                  FontAwesomeIcons.image,
                  color: Colors.white,
                ),
              ),
            )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                child: IconButton(
                  icon: const Icon(
                    FontAwesomeIcons.chevronLeft,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
