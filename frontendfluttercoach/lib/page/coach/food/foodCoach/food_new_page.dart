import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:frontendfluttercoach/page/coach/food/foodCourse/food_page.dart';
import 'package:frontendfluttercoach/page/showDialogWidget.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_coachID_post.dart';

import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../service/provider/coachData.dart';
import 'food_page.dart';

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
  String profile = " ";

  @override
  void initState() {
    super.initState();

    _listfoodService = context.read<AppData>().listfoodServices;
    log(context.read<AppData>().baseurl);
    cid = context.read<AppData>().cid;

    name.text = "ไข่เจียวไร้น้ำมันหมู22";
    details.text =
        "ไข่เจียว ไข่2ฟอง แครอท 30 กรัม กับหัวหอม 10 กรัม ชีส 15 กรัม ผักต้มสุกตามใจชอบ ข้าวกล้อง 200 กรัม";
    calories.text = "260";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: TextButton(
            onPressed: () {},
            child: Text(
              'เพิ่มเมนูอาหาร',
              style: Theme.of(context).textTheme.headlineSmall,
            )),
        leading: IconButton(
          icon: const Icon(
            FontAwesomeIcons.chevronLeft,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [inputImage(context), InputFood()],
        ),
      ),
    );
  }

  Expanded InputFood() {
    return Expanded(
        child: ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 10, right: 10),
          child: TextField(
              controller: name,
              decoration: const InputDecoration(
                labelText: "ชิ่อเมนู",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: TextField(
              keyboardType: TextInputType.multiline,
              controller: details,
              maxLines: null,
              minLines: 1,
              decoration: const InputDecoration(
                labelText: "รายระเอียด",
              )),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 10, right: 10),
          child: TextField(
              controller: calories,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: "Calories",
              )),
        ),
        ElevatedButton(
            onPressed: () async {
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
              if (modelResult.result == "1") {
                // ignore: use_build_context_synchronously
                // showDialogRowsAffected(context, "บันทึกสำเร็จ");
                const ShowDialogWidget();
                Get.to(() => const FoodCoachPage());
              } else {
                // ignore: use_build_context_synchronously
                const ShowDialogWidget();
              }
            },
            child: const Text("บันทึก"))
      ],
    ));
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
    final result = await FilePicker.platform.pickFiles();
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
                      "https://www.finearts.cmu.ac.th/wp-content/uploads/2021/07/blank-profile-picture-973460_1280-1.png"),
                )),
          ),
        Positioned(
            bottom: 70,
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
                    border: Border.all(width: 4, color: Colors.white),
                    color: Colors.amber),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            )),
      ],
    );
  }
}
