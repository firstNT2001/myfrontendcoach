import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../model/request/listClip_clipID_put.dart';
import '../../../model/response/md_ClipList_get.dart';
import '../../../model/response/md_Result.dart';
import '../../../service/listClip.dart';
import '../../../service/provider/appdata.dart';
import '../../../widget/wg_textField.dart';
import '../../user/mycourse.Detaildart/myClipinCourse/widget_loadcilcp.dart';

class ClipEditCoachPage extends StatefulWidget {
  late int icpId;
  ClipEditCoachPage({super.key, required this.icpId});

  @override
  State<ClipEditCoachPage> createState() => _ClipEditCoachPageState();
}

class _ClipEditCoachPageState extends State<ClipEditCoachPage> {
  //Service ListClip
  late ListClipServices _listClipService;
  late Future<void> loadClipDataMethod;
  late List<ModelClipList> listclips = [];

  //Controller Clip
  TextEditingController name = TextEditingController();
  TextEditingController details = TextEditingController();
  TextEditingController amountPerSet = TextEditingController();

  //Vdieo
  PlatformFile? pickedFile;
  UploadTask? uploadTask;
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  String pathVdieo = '';

  bool isVisibles = true;

  //Result update Clips
  late ModelResult modelResult;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //LoadClipService
    _listClipService = context.read<AppData>().listClipServices;
    loadClipDataMethod = loadClipData();
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
            Expanded(
                child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: inputTextClips(),
            )),
          ],
        ),
      ),
    );
  }

  //ShowData
  FutureBuilder<void> inputTextClips() {
    return FutureBuilder(
        future: loadClipDataMethod,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Container();
            //return const Center(child: CircularProgressIndicator());
          }
          return Column(
            children: [
              if (isVisibles == true)
                Expanded(
                  child: Visibility(
                    visible: isVisibles,
                    child: WidgetloadCilp(
                      nameclip: '',
                      urlVideo: listclips.first.video,
                    ),
                  ),
                ),
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
              const SizedBox(height: 18),
              WidgetTextFieldString(
                controller: amountPerSet,
                labelText: 'details',
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      ListClipClipIdPut listClipCoachIdPut =
                          ListClipClipIdPut(
                              name: name.text,
                              amountPerSet: amountPerSet.text,
                              video: pathVdieo,
                              details: details.text, coachId: context.read<AppData>().cid);
                      var insertClip = await _listClipService
                          .updateListClipByClipID(widget.icpId.toString(), listClipCoachIdPut);
                      modelResult = insertClip.data;
                      log(jsonEncode(modelResult.result));
                    },
                    child: const Text('บันทึก')),
              )
            ],
          );
        });
  }

  //loadData
  Future<void> loadClipData() async {
    try {
      var datas = await _listClipService.listClips(
          icpID: widget.icpId.toString(), cid: '', name: '');
      listclips = datas.data;

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

    // setState(() {
    pickedFile = result.files.first;
    // });
    uploadFile();
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

    showVideo(urlDownload);
  }

  VideoPlayerController showVideo(String urlDownload) {
    return _controller = VideoPlayerController.network(urlDownload)
      ..initialize().then((value) {
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
        _customVideoPlayerController = CustomVideoPlayerController(
          context: context,
          videoPlayerController: _controller,
        );
      });
  }

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController.dispose();
  }
}
