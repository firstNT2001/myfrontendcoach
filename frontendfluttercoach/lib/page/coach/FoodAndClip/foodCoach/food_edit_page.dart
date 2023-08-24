import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'package:provider/provider.dart';
import 'package:string_validator/string_validator.dart';

import '../../../../model/request/listFood_foodID_put.dart';

import '../../../../model/response/md_FoodList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listFood.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/dialogs.dart';
import '../../../../widget/notificationBody.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';

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

  String textErr = '';
  final _formKey = GlobalKey<FormState>();
  bool isValid = true;
  @override
  void initState() {
    super.initState();
    log(widget.ifid.toString());
    _listfoodService = context.read<AppData>().listfoodServices;
    _loadData = loadDataAsync();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            children: [
              inputTextFood(),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<void> inputTextFood() {
    return FutureBuilder(
        future: _loadData,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Center(child: load(context));
          }
          return Stack(
            children: [
              inputImage(context),
              Positioned(
                  child: Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 3),
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
                                height: 20,
                              ),
                              WidgetTextFieldString(
                                controller: name,
                                labelText: 'ขื่อเมนู',
                              ),
                              Form(
                                  key: _formKey,
                                  child: textForimField(
                                      context, calories, 'แคลอรี่', 4)),
                              WidgetTextFieldLines(
                                controller: details,
                                labelText: 'วิธีการปรุงเมนูอาหาร',
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error),
                                    ),
                                  ),
                                ],
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 18, left: 15, right: 15),
                                  child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: button(context)),
                                ),
                              ),
                            ],
                          )))),
            ],
          );
        });
  }

  FilledButton button(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          _formKey.currentState!.validate();

          startLoading(context);
          if (name.text.isEmpty ||
              details.text.isEmpty ||
              calories.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
            stopLoading();
          } else if (isValid == false) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขให้ถูกต้อง';
            });
            stopLoading();
          } else if (int.parse(calories.text).isNegative == true) {
            setState(() {
              textErr = 'กรุณากรอกตัวเลขมากกว่า 0';
            });
          } else {
            setState(() {
              textErr = '';
            });
            log(widget.ifid.toString());
            log(context.read<AppData>().cid.toString());
            if (pickedImg != null) await uploadfile();
            if (pickedImg == null) profile = foods.first.image;
            ListFoodFoodIdPut request = ListFoodFoodIdPut(
                name: name.text,
                image: profile,
                details: details.text,
                calories: int.parse(calories.text),
                // ignore: use_build_context_synchronously
                coachId: context.read<AppData>().cid);
            log(jsonEncode(request));
            editFood = await _listfoodService.updateListFoodByFoodID(
                widget.ifid.toString(), request);
            modelResult = editFood.data;
            log(jsonEncode(modelResult.result));
            stopLoading();
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขเมนูอาหารสำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
              Navigator.pop(context);
            } else {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขเมนูอาหารไม่สำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            }
          }
        },
        child: const Text('บันทึก'));
  }

  Future<void> loadDataAsync() async {
    try {
      var res = await _listfoodService.listFoods(
          ifid: widget.ifid.toString(),
          cid: context.read<AppData>().cid.toString(),
          name: '');
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
        } else if (foods.first.image.isEmpty) ...{
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
            ),
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
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(foods.first.image),
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
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
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
}
