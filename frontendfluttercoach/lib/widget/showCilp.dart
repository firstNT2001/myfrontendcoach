import 'package:appinio_video_player/appinio_video_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'dialogs.dart';

class WidgetShowCilp extends StatefulWidget {
  const WidgetShowCilp({super.key, required this.urlVideo});
  final String urlVideo;
  @override
  State<WidgetShowCilp> createState() => _WidgetShowCilpState();
}

class _WidgetShowCilpState extends State<WidgetShowCilp> {
  late String videoUrl = widget.urlVideo;
  late VideoPlayerController _videoPlayerController;
  late CustomVideoPlayerController _customVideoPlayerController;
  @override
  void initState() {
    super.initState();
    startLoading(context);
    _videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then((value) => setState(() {}));
    _customVideoPlayerController = CustomVideoPlayerController(
      context: context,
      videoPlayerController: _videoPlayerController,
    );
    stopLoading();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: showClip(),
      ),
    );
  }

  Column showClip() {
    return Column(
      children: [
        _videoPlayerController.value.isInitialized
            ? CustomVideoPlayer(
                customVideoPlayerController: _customVideoPlayerController)
            : Center(child: load(context)),
      ],
    );
  }
}
