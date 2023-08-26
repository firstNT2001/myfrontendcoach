import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:in_app_notification/in_app_notification.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/request/listClip_coachID_post.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listClip.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/dialogs.dart';
import '../../../../widget/notificationBody.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';
import '../../../../widget/textField/wg_textField_int copy.dart';

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
  final amount = TextEditingController();
  final perSet = TextEditingController();

  final details = TextEditingController();

  //Vdieo
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  String pathVdieo = '';

  String textErr = '';
  @override
  void dispose() {
    _controller.pause();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    cid = context.read<AppData>().cid.toString();
    _controller = VideoPlayerController.asset('')
      ..initialize().then((_) {
        setState(() {});
      });
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _controller,
    );
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
                SizedBox(
                  height: 28,
                ),
                WidgetTextFieldString(
                  controller: name,
                  labelText: 'ชื่อ',
                ),
                Row(
                  children: [
                    Expanded(
                      child: WidgetTextFieldInt(
                        controller: perSet,
                        labelText: 'จำนวนเซต',
                        maxLength: 2,
                      ),
                    ),
                    Expanded(
                      child: WidgetTextFieldInt(
                        controller: amount,
                        labelText: 'ต่อครั้ง',
                        maxLength: 5,
                      ),
                    ),
                  ],
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
          Positioned(
            child: SafeArea(
              child: _controller.value.isInitialized
                  ? CustomVideoPlayer(
                      customVideoPlayerController: _customVideoPlayerController)
                  : Center(child: load(context)),
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
                _controller.pause();

                selectFile();
              },
              child: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //border: Border.all(width: 4, color: Colors.white),
                    color: Theme.of(context).colorScheme.primary),
                child: const Icon(
                  FontAwesomeIcons.camera,
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
                    _controller.pause();
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

  FilledButton button() {
    return FilledButton(
        onPressed: () async {
          _controller.pause();


          // for (int i = 0; i < splitted.length; i++) {
          //   log(splitted[i]);
          // }

          log(pathVdieo);
          log('message');
          if (name.text.isEmpty ||
              perSet.text.isEmpty ||
              amount.text.isEmpty ||
              details.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else if (pickedFile == null) {
            setState(() {
              textErr = 'กรุณาเพิ่มวิดิโอ';
            });
          } else {
            setState(() {
              textErr = '';
            });
            startLoading(context);
            if (pickedFile != null) await uploadFile();
            ListClipCoachIdPost listClipCoachIdPost = ListClipCoachIdPost(
                name: name.text,
                amountPerSet: '${perSet.text} เซท ${amount.text} ครั้ง',
                video: pathVdieo,
                details: details.text);
            var insertClip = await _listClipServices.insertListClipByCoachID(
                cid, listClipCoachIdPost);
            modelResult = insertClip.data;
            stopLoading();
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'เพิ่มคลิปท่าออกกำลังกายสำเร็จ',
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
                  message: 'เพิ่มคลิปท่าออกกำลังกายไม่สำเร็จ',
                ),
                context: context,
                onTap: () => print('Notification tapped!'),
                duration: const Duration(milliseconds: 2000),
              );
            }
            log(jsonEncode(modelResult.result));
          }
        },
        child: const Text("บันทึก"));
  }

  //Video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
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
