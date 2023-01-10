import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:video_player/video_player.dart';

/// Stateful widget to fetch and then display video content.
class PlayVideoPage extends StatefulWidget {
  const PlayVideoPage({Key? key}) : super(key: key);

  @override
  _PlayVideoPage createState() => _PlayVideoPage();
}

class _PlayVideoPage extends State<PlayVideoPage> {
  late VideoPlayerController _controller;
  late CustomVideoPlayerController _customVideoPlayerController;
  @override
  void initState() {
    super.initState();
  }

  PlatformFile? pickedFile;
  UploadTask? uploadTask;

  Future selectFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    // setState(() {
    pickedFile = result.files.first;
    // });
  }

  Future uploadFile() async {
    final path = 'videos/${pickedFile!.name}';
    final file = File(pickedFile!.path!);

    final ref = FirebaseStorage.instance.ref().child(path);
    uploadTask = ref.putFile(file);

    final snapshot = await uploadTask!.whenComplete(() => {});

    final urlDownload = await snapshot.ref.getDownloadURL();
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("อัพโหลดวิดีโอ"),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
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
              ElevatedButton(
                child: const Text('Upload File'),
                onPressed: uploadFile,
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
    _customVideoPlayerController.dispose();
  }
}
