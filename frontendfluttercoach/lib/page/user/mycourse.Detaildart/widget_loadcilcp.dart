import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WidgetloadCilp extends StatefulWidget {
  WidgetloadCilp({super.key,required this.urlVideo,required this.nameclip});
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
  }
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      
      child: SafeArea(
        child: CustomVideoPlayer(
          customVideoPlayerController: _customVideoPlayerController
        ),
      ),
    );
  }
}