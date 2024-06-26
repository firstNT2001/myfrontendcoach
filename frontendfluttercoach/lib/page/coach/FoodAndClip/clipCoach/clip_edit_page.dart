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

import '../../../../model/request/listClip_clipID_put.dart';
import '../../../../model/response/md_ClipList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listClip.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/dialogs.dart';
import '../../../../widget/notificationBody.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';
import '../../../../widget/textField/wg_textField_int copy.dart';

class ClipEditCoachPage extends StatefulWidget {
  final int icpId;
  const ClipEditCoachPage({super.key, required this.icpId});

  @override
  State<ClipEditCoachPage> createState() => _ClipEditCoachPageState();
}

class _ClipEditCoachPageState extends State<ClipEditCoachPage> {
  //Service ListClip
  late ListClipServices _listClipService;
  late Future<void> loadClipDataMethod;
  late List<ListClip> listclips = [];

  //Controller Clip
  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  final amount = TextEditingController();
  final perSet = TextEditingController();
  //Vdieo
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late VideoPlayerController _videoSelectPlayerController;
  late CustomVideoPlayerController _customSelectVideoPlayerController;

  String pathVdieo = '';

  bool isVisibles = true;

  //Result update Clips
  late ModelResult modelResult;

  String textErr = '';
  // ignore: unused_field
  // bool _enabled = true;

  @override
  void initState() {
    super.initState();
    log(widget.icpId.toString());

    //LoadClipService
    _listClipService = context.read<AppData>().listClipServices;
    loadClipDataMethod = loadClipData();

    log(pickedFile.toString());
  }

  @override
  void dispose() {
    _videoSelectPlayerController.pause();
    // ignore: avoid_print
    print('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          inputTextClips(),
        ],
      ),
    );
  }

  //ShowData
  FutureBuilder<void> inputTextClips() {
    return FutureBuilder(
        future: loadClipDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: [
                video(),
                const SizedBox(
                  height: 20,
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
                        child: button(context)),
                  ),
                )
              ],
            );
          } else {
            return Center(child: load(context));
          }
        });
  }

  Column video() {
    return Column(
      children: [
        Stack(
          children: [
            if (pickedFile != null) ...{
              Positioned(
                child: CustomVideoPlayer(
                    customVideoPlayerController:
                        _customSelectVideoPlayerController),
              ),
            } else if (listclips.first.video != '') ...{
              _videoSelectPlayerController.value.isInitialized
                  ? Positioned(
                      child: CustomVideoPlayer(
                          customVideoPlayerController:
                              _customSelectVideoPlayerController),
                    )
                  : Center(child: load(context)),
            } else
              Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.3,
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
            Positioned(
                bottom: 60,
                right: 8,
                child: InkWell(
                  onTap: () {
                    log("message");
                    _videoSelectPlayerController.pause();

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
                        // _videoPlayerController.value.isInitialized
                        //     ? _videoPlayerController.pause()
                        //     : log('');

                        // _videoSelectPlayerController.value.isInitialized
                        //     ? _videoSelectPlayerController.pause()
                        //     : log('');
                        // log(_videoPlayerController.value.isInitialized
                        //     .toString());
                        log(_videoSelectPlayerController.value.isInitialized
                            .toString());

                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  FilledButton button(BuildContext context) {
    return FilledButton(
        onPressed: () async {
          _videoSelectPlayerController.pause();

          if (name.text.isEmpty ||
              perSet.text.isEmpty ||
              amount.text.isEmpty ||
              details.text.isEmpty) {
            setState(() {
              textErr = 'กรุณากรอกข้อมูลให้ครบ';
            });
          } else {
            setState(() {
              textErr = '';
            });
            startLoading(context);
            if (pickedFile != null) await uploadFile();
            if (pickedFile == null) pathVdieo = listclips.first.video;
            ListClipClipIdPut listClipCoachIdPut = ListClipClipIdPut(
                name: name.text,
                amountPerSet: '${perSet.text} เซท ${amount.text} ครั้ง',
                video: pathVdieo,
                details: details.text,
                coachId: context.read<AppData>().cid);
            log(jsonEncode(listClipCoachIdPut));
            var insertClip = await _listClipService.updateListClipByClipID(
                widget.icpId.toString(), listClipCoachIdPut);
            modelResult = insertClip.data;
            log(jsonEncode(modelResult.result));
            stopLoading();
            if (modelResult.result == '1') {
              // ignore: use_build_context_synchronously
              InAppNotification.show(
                child: NotificationBody(
                  count: 1,
                  message: 'แก้ไขคลิปท่าออกกำลังกายสำเร็จ',
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
                  message: 'แก้ไขคลิปท่าออกกำลังกายไม่สำเร็จ',
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

  //loadData
  Future<void> loadClipData() async {
    try {
      var datas = await _listClipService.listClips(
          icpID: widget.icpId.toString(), cid: '', name: '');
      listclips = datas.data;

      log(listclips.first.video);
      name.text = listclips.first.name;
      details.text = listclips.first.details;
      String amountPerSet = listclips.first.amountPerSet;

      List<String> words = amountPerSet.split(" ");

      print('${words[0]} ${words[1]} ${words[2]} ${words[3]}');
      perSet.text = words[0];
      amount.text = words[2];

      _videoSelectPlayerController =
          VideoPlayerController.network(listclips.first.video)
            ..initialize().then((value) => setState(() {}));
      _customSelectVideoPlayerController = CustomVideoPlayerController(
        context: context,
        videoPlayerController: _videoSelectPlayerController,
      );
    } catch (err) {
      log('Error: $err');
    }
  }

  //Video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );
    if (result == null) return;
    // ignore: use_build_context_synchronously
    //startLoading(context);
    // setState(() {
    pickedFile = result.files.first;
    log(pickedFile.toString());
    final File fileForFirebase = File(pickedFile!.path!);

    log(pickedFile.toString());
    _videoSelectPlayerController = VideoPlayerController.file(fileForFirebase)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _customSelectVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoSelectPlayerController,
        );
      });
  }

  Future uploadFile() async {
    setState(() {
      isVisibles = false;
    });
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
