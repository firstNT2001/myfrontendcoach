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
import '../../../../widget/wg_textField.dart';


class ClipNewCoachPage extends StatefulWidget {
  const ClipNewCoachPage({super.key});

  @override
  State<ClipNewCoachPage> createState() => _ClipNewCoachPageState();
}

class _ClipNewCoachPageState extends State<ClipNewCoachPage> {
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
  @override
  void initState() {
    super.initState();
    cid = context.read<AppData>().cid.toString();
    name.text = 'ท่าเลกลันจ์';
    amountPerSet.text = '5เซ็ท เซ็ทละ20ครั้ง';
    details.text =
        'ท่านี้ช่วยบริหารต้นขาด้านหน้า ก้น และกล้ามเนื้อแฮมสตริง ทำให้ขาและกันกระชับ กล้ามเนื้อขาเข็งแรง';
    _listClipServices = context.read<AppData>().listClipServices;
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
              'เพิ่มคลิป',
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
            if (pickedFile != null)
              Expanded(
                child: SafeArea(
                  child: CustomVideoPlayer(
                      customVideoPlayerController:
                          _customVideoPlayerController),
                ),
              ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              child: const Text('Select File'),
              onPressed: selectFile,
            ),
            const SizedBox(
              height: 12,
            ),
            const SizedBox(
              height: 20,
            ),
            inputClip(),
          ],
        ),
      ),
    );
  }

  Expanded inputClip() {
    return Expanded(
      child: ListView(
        children: [
          WidgetTextFieldString(
            controller: name,
            labelText: 'ชื่อ',
          ),
          WidgetTextFieldString(
            controller: amountPerSet,
            labelText: 'จำนวนเซ็ท',
          ),
          WidgetTextFieldString(
            controller: details,
            labelText: 'รายละเอียดท่า',
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
                onPressed: () async {
                  log(pathVdieo);
                  ListClipCoachIdPost listClipCoachIdPost = ListClipCoachIdPost(
                      name: name.text,
                      amountPerSet: amountPerSet.text,
                      video: pathVdieo,
                      details: details.text);
                  var insertClip = await _listClipServices
                      .insertListClipByCoachID(cid, listClipCoachIdPost);
                  modelResult = insertClip.data;
                  log(jsonEncode(modelResult.result));
                },
                child: const Text("บันทึก")),
          )
        ],
      ),
    );
  }

  //Video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    startLoading(context);
    // setState(() {
    pickedFile = result.files.first;
    // });
    uploadFile();
  }

  Future uploadFile() async {
    final path = 'videos/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});

    final urlDownload = await snapshot.ref.getDownloadURL();
    pathVdieo = urlDownload;
    print('Download Link: $urlDownload');
    _controller = VideoPlayerController.network('$urlDownload')
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _controller,
        );
      });

    stopLoading();
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
