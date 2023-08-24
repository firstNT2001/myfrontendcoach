import 'dart:developer';

import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../widget/dialogs.dart';

class WidgetloadCilp extends StatefulWidget {
  WidgetloadCilp({super.key, required this.urlVideo, required this.nameclip});
  late String urlVideo;
  late String nameclip;
  @override
  State<WidgetloadCilp> createState() => _WidgetloadCilpState();
}

class _WidgetloadCilpState extends State<WidgetloadCilp> {
  late String videoUrl = widget.urlVideo;
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
     stopLoading();
  }
      @override
  void dispose() {
    _videoPlayerController.pause();
    // ignore: avoid_print
    log('Dispose used');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child:  _videoPlayerController.value.isInitialized
            ? CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController)
            : Center(child: load(context)),
      ),
    );
  }
}
