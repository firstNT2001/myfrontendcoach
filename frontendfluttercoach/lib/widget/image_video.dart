import 'package:flutter/material.dart';
import 'package:frontendfluttercoach/widget/dialogs.dart';

import 'package:video_player/video_player.dart';

class VideoItem extends StatefulWidget {
  const VideoItem({super.key, required this.video});
  final String video;

  @override
  State<VideoItem> createState() => _VideoItemState();
}

class _VideoItemState extends State<VideoItem> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // ignore: deprecated_member_use
    _controller = VideoPlayerController.network(widget.video)
    
      ..initialize().then((_) {
        setState(() {}); //when your thumbnail will show.
      });
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: _controller.value.isInitialized
            ? VideoPlayer(_controller)
            :  Center(child: load(context)));
  }
}
