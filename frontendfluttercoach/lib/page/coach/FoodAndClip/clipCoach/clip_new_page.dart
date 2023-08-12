import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/request/listClip_coachID_post.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listClip.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/PopUp/popUp.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';
import '../coach_food_clip_page.dart';

class ClipNewCoachPage extends StatefulWidget {
  const ClipNewCoachPage({super.key});

  @override
  State<ClipNewCoachPage> createState() => _ClipNewCoachPageState();
}

class _ClipNewCoachPageState extends State<ClipNewCoachPage> {
  // ignore: unused_field
  late ListClipServices _listClipServices;
  late ModelResult modelResult;
  String cid = '';
  //Controller
  final name = TextEditingController();
  final amountPerSet = TextEditingController();
  final details = TextEditingController();

  //Vdieo
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  String pathVdieo = '';

  String textErr = '';

  @override
  void initState() {
    super.initState();
    cid = context.read<AppData>().cid.toString();

    _listClipServices = context.read<AppData>().listClipServices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: ListView(
          children: [
            Stack(
              children: [
                videoPlayer(context),
                textFieldAll(context),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Positioned textFieldAll(BuildContext context) {
    return Positioned(
      child: Padding(
          padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
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
                SizedBox(height: 28,),
                WidgetTextFieldString(
                  controller: name,
                  labelText: 'ชื่อ',
                ),
                WidgetTextFieldString(
                  controller: amountPerSet,
                  labelText: 'จำนวนเซ็ท',
                ),
                WidgetTextFieldLines(
                  controller: details,
                  labelText: 'รายละเอียดท่าออกกำลังกาย',
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(bottom: 8, left: 20, right: 23),
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
                    padding:
                        const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                    child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: button()),
                  ),
                ),
              ],
            ),
          )),
    );
  }

  Stack videoPlayer(BuildContext context) {
    return Stack(
      children: [
        if (pickedFile != null) ...{
          Expanded(
            child: SafeArea(
              child: CustomVideoPlayer(
                  customVideoPlayerController: _customVideoPlayerController),
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
                image: const DecorationImage(
                  fit: BoxFit.cover,
                  image: NetworkImage(
                      "https://i.pinimg.com/564x/41/1c/7d/411c7d94b0eba881182d054d56792d09.jpg"),
                )),
          ),
        Positioned(
            bottom: 60,
            right: 8,
            child: InkWell(
              onTap: () {
                log("message");
                selectFile();
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
                    Get.back();
                  },
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Padding inputClip() {
    return Padding(
        padding: EdgeInsets.only(top: MediaQuery.of(context).size.height / 3),
        child: Container(
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 18, top: 28, left: 20, right: 20),
                child: WidgetTextFieldString(
                  controller: name,
                  labelText: 'ชื่อ',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                child: WidgetTextFieldString(
                  controller: amountPerSet,
                  labelText: 'จำนวนเซ็ท',
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                child: WidgetTextFieldLines(
                  controller: details,
                  labelText: 'รายละเอียดท่าออกกำลังกาย',
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(bottom: 8, left: 20, right: 23),
                    child: Text(
                      textErr,
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ),
                ],
              ),
              Center(
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 18, left: 20, right: 20),
                  child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: button()),
                ),
              ),
            ],
          ),
        ));
  }

  FilledButton button() {
    return FilledButton(
        onPressed: () async {
          log(pathVdieo);
          if (name.text.isEmpty ||
              amountPerSet.text.isEmpty ||
              details.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (pathVdieo.isEmpty) {
            setState(() {
              textErr = 'กรุณาเพิ่มวิดิโอ';
            });
          } else {
            setState(() {
              textErr = '';
            });
            if (pickedFile != null) await uploadFile();
            ListClipCoachIdPost listClipCoachIdPost = ListClipCoachIdPost(
                name: name.text,
                amountPerSet: amountPerSet.text,
                video: pathVdieo,
                details: details.text);
            var insertClip = await _listClipServices.insertListClipByCoachID(
                cid, listClipCoachIdPost);
            modelResult = insertClip.data;
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              success(context);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const FoodCoachPage()),
                ModalRoute.withName('/NavbarBottomCoach'),
              );
            } else {
              // ignore: use_build_context_synchronously
              warning(context);
            }
            log(jsonEncode(modelResult.result));
          }
        },
        child: const Text("บันทึก"));
  }

  //Video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    // ignore: use_build_context_synchronously
    // startLoading(context);
    // setState(() {
    pickedFile = result.files.first;

    final File fileForFirebase = File(pickedFile!.path!);

    log(pickedFile.toString());
    _controller = VideoPlayerController.file(fileForFirebase)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _controller,
        );
      });
  }

  Future uploadFile() async {
    final path = 'videos/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    pathVdieo = urlDownload;
  }

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController.dispose();
  }

  // StartLoading And StopLoading
  Widget loadingIndicator(BuildContext context) => Container(
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: SizedBox(
          width: 120,
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                height: 40,
                child: LoadingIndicator(
                  indicatorType: Indicator.ballTrianglePathColoredFilled,
                  colors: [Theme.of(context).colorScheme.onPrimaryContainer],
                  strokeWidth: 5,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'กำลังประมวลผล',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.onPrimaryContainer),
                ),
              )
            ],
          ),
        ),
      );

  void startLoading(BuildContext context) {
    SmartDialog.showLoading(
      builder: (_) => loadingIndicator(context),
      animationType: SmartAnimationType.fade,
      maskColor: Colors.transparent,
    );
  }

  void stopLoading() {
    SmartDialog.dismiss();
  }
}
