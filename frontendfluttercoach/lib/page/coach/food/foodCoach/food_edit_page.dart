import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:provider/provider.dart';

import '../../../../model/request/listFood_foodID_put.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/wg_textField.dart';
import 'food_page.dart';

class FoodEditCoachPage extends StatefulWidget {
  final int ifid;
  const FoodEditCoachPage({super.key, required this.ifid});

  @override
  State<FoodEditCoachPage> createState() => _FoodEditCoachPageState();
}

class _FoodEditCoachPageState extends State<FoodEditCoachPage> {
  late Future<void> _loadData;
  late ListFoodServices _listfoodService;
  List<ModelFoodList> foods = [];
  late ModelResult modelResult;
  var editFood;

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
    log(widget.ifid.toString());
    _listfoodService = context.read<AppData>().listfoodServices;
    _loadData = loadDataAsync();
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
          children: [
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: inputTextFood(),
            )),
          ],
        ),
      ),
    );
  }

  FutureBuilder<void> inputTextFood() {
    return FutureBuilder(
        future: _loadData,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
            //return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              inputImage(context),
              const SizedBox(height: 20),
              WidgetTextFieldString(
                controller: name,
                labelText: 'ชื่อ',
              ),
              const SizedBox(height: 18),
              WidgetTextFieldString(
                controller: details,
                labelText: 'details',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      log(widget.ifid.toString());
                      log(context.read<AppData>().cid.toString());
                      if (pickedImg != null) await uploadfile();
                      if (pickedImg == null) profile = foods.first.image;
                      ListFoodFoodIdPut request = ListFoodFoodIdPut(
                          name: name.text,
                          image: profile,
                          details: details.text,
                          calories: int.parse(calories.text),
                          coachId: context.read<AppData>().cid);
                      log(jsonEncode(request));
                      editFood = await _listfoodService.updateListFoodByFoodID(
                          widget.ifid.toString(), request);
                      modelResult = editFood.data;
                      log(jsonEncode(modelResult.result));
                      if (modelResult.result == "1") {
                        Get.to(() => const FoodCoachPage());
                      }
                    },
                    child: const Text('บันทึก')),
              )
            ],
          );
        });
  }

  Future<void> loadDataAsync() async {
    try {
      var res = await _listfoodService.listFoods(
          ifid: widget.ifid.toString(), cid: context.read<AppData>().cid.toString(), name: '');
      foods = res.data;
      name.text = foods.first.name;
      details.text = foods.first.details;
      calories.text = foods.first.calories.toString();
    } catch (err) {
      log('Error: $err');
    }
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
        } else ...{
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(foods.first.image),
                )),
          ),
        },
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
