import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:loading_indicator/loading_indicator.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../model/request/listClip_clipID_put.dart';
import '../../../../model/response/md_ClipList_get.dart';
import '../../../../model/response/md_Result.dart';
import '../../../../service/listClip.dart';
import '../../../../service/provider/appdata.dart';
import '../../../../widget/PopUp/popUp.dart';
import '../../../../widget/showCilp.dart';
import '../../../../widget/textField/wg_textField.dart';
import '../../../../widget/textField/wg_textFieldLines.dart';
import '../../navigationbar.dart';

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
  TextEditingController amountPerSet = TextEditingController();

  //Vdieo
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
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

                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 18, top: 28, left: 20, right: 20),
                  child: WidgetTextFieldString(
                    controller: name,
                    labelText: 'ชื่อ',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 18, left: 20, right: 20),
                  child: WidgetTextFieldString(
                    controller: amountPerSet,
                    labelText: 'จำนวนเซ็ท',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 18, left: 20, right: 20),
                  child: WidgetTextFieldLines(
                    controller: details,
                    labelText: 'รายละเอียดท่าออกกำลังกาย',
                  ),
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
                )
              ],
            );
          } else {
            return Container();
          }
        });
  }

  Column video() {
    return Column(
      children: [
        Stack(
          children: [
            if (pickedFile != null) ...{
              Expanded(
                child: SafeArea(
                  child: CustomVideoPlayer(
                      customVideoPlayerController:
                          _customVideoPlayerController),
                ),
              ),
            } else if (listclips.first.video != '') ...{
              WidgetShowCilp(
                urlVideo: listclips.first.video,
              ),
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
          if (name.text.isEmpty ||
              amountPerSet.text.isEmpty ||
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
                amountPerSet: amountPerSet.text,
                video: pathVdieo,
                details: details.text,
                coachId: context.read<AppData>().cid);
            log(jsonEncode(listClipCoachIdPut));
            var insertClip = await _listClipService.updateListClipByClipID(
                widget.icpId.toString(), listClipCoachIdPut);
            modelResult = insertClip.data;
            log(jsonEncode(modelResult.result));
            stopLoading();
            if (modelResult.result == '0') {
               // ignore: use_build_context_synchronously
              success(context);
              // ignore: use_build_context_synchronously
              Navigator.pushAndRemoveUntil<void>(
                context,
                MaterialPageRoute<void>(
                    builder: (BuildContext context) => const NavbarBottomCoach()),
                ModalRoute.withName('/NavbarBottomCoach'),
              );
             
            } else {
              // ignore: use_build_context_synchronously
              warning(context);
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
      amountPerSet.text = listclips.first.amountPerSet;
    } catch (err) {
      log('Error: $err');
    }
  }

  //Video
  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;
    // ignore: use_build_context_synchronously
    //startLoading(context);
    // setState(() {
    pickedFile = result.files.first;
    log(pickedFile.toString());
    final File fileForFirebase = File(pickedFile!.path!);

    log(pickedFile.toString());
    _videoPlayerController = VideoPlayerController.file(fileForFirebase)
      ..initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _videoPlayerController,
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
