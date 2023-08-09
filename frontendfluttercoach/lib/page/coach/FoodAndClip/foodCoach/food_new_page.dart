import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_coachID_post.dart';

import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/PopUp/popUp.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';
import '../../../../widget/textField/wg_textField_int copy.dart';
import '../coach_food_clip_page.dart';

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
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18, top: 28, left: 20, right: 20),
                      child: WidgetTextFieldString(
                        controller: name,
                        labelText: 'ขื่อเมนู',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          bottom: 18, left: 20, right: 20),
                      child: WidgetTextFieldInt(
                        controller: calories,
                        labelText: 'Calories',
                        maxLength: 10,
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            bottom: 18, left: 20, right: 20),
                        child: WidgetTextFieldLines(
                          controller: details,
                          labelText: 'ส่วนผสม',
                        )),
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
                            child: button()),
                      ),
                    ),
                  ],
                ))));
  }

  FilledButton button() {
    return FilledButton(
        onPressed: () async {
          if (name.text.isEmpty ||
              details.text.isEmpty ||
              calories.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (pickedImg == null) {
            setState(() {
              textErr = 'กรุณาใส่รูป';
            });
          } else {
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
             if (modelResult.result == '0') {
              // ignore: use_build_context_synchronously
              warning(context);
            } else {
              // ignore: use_build_context_synchronously
              success(context);
              Get.to(() => const FoodCoachPage());
            }
          }
        },
        child: const Text("บันทึก"));
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
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    //border: Border.all(width: 4, color: Colors.white),
                    color: Colors.white),
                child: const Icon(
                  FontAwesomeIcons.camera,
                  color: Colors.black,
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
