import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chewie/chewie.dart';
import 'package:video_player/video_player.dart';

class ChewiePlayer extends StatefulWidget {
  static const routeName = '/VideoScreen';
  final File? videoUrl;
  final String? dimension; //1920*1080

  const ChewiePlayer({this.videoUrl, this.dimension,});

  @override
  State<ChewiePlayer> createState() => _ChewiePlayerState();
}

class _ChewiePlayerState extends State<ChewiePlayer> {
  VideoPlayerController? _controller;
  ChewieController? chewieController;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    print('VideoScreen dispose');
    chewieController?.videoPlayerController.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Center(
          child: AspectRatio(
            aspectRatio: _controller!.value.aspectRatio,
            child: Chewie(controller: chewieController!),
          ),
        ),
      ),
    );
  }

  Future<void> initialize() async {
    _controller = VideoPlayerController.file(widget.videoUrl!);
    /// you can also play network and asset video, than declare accordingly example: VideoPlayerController.network( paste your link )
    await _controller!.initialize().then((value) => setState(() {}));
    chewieController = ChewieController(
      videoPlayerController: _controller!,
      autoInitialize: false,
      autoPlay: false,
      allowPlaybackSpeedChanging: true,
      materialProgressColors:
          ChewieProgressColors(playedColor: Colors.blue, handleColor: Colors.blue, bufferedColor: Colors.grey),
      looping: false,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(errorMessage, style: const TextStyle(color: Colors.white)),
          ),
        );
      },
    );
  }
}