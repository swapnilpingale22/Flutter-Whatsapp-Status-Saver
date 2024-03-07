// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';

class VideoViewScreen extends StatefulWidget {
  final File video;
  const VideoViewScreen({
    Key? key,
    required this.video,
  }) : super(key: key);

  @override
  State<VideoViewScreen> createState() => _VideoViewScreenState();
}

class _VideoViewScreenState extends State<VideoViewScreen> {
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();

    VideoPlayerController controller = VideoPlayerController.file(
      File(widget.video.path),
    );
    controller.initialize().then((_) {
      setState(() {
        double videoHeight = controller.value.size.height;
        double videoWidth = controller.value.size.width;

        _chewieController = ChewieController(
          videoPlayerController: VideoPlayerController.file(
            File(widget.video.path),
          ),
          autoPlay: true,
          looping: true,
          aspectRatio: videoHeight > videoWidth ? 9 / 16 : 16 / 9,
          autoInitialize: true,
          showControlsOnInitialize: false,
          allowFullScreen: false,
          allowPlaybackSpeedChanging: false,
          showOptions: false,
          showControls: false,
          controlsSafeAreaMinimum: const EdgeInsets.only(bottom: 150),
          errorBuilder: (context, errorMessage) {
            return Center(
              child: Text(
                'Error: $errorMessage',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
        );
      });
    });
  }

  @override
  void dispose() {
    if (_chewieController != null) {
      _chewieController!.dispose();
      _chewieController!.pause();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.black54,
      body: SafeArea(
        child: _chewieController != null
            ? Chewie(controller: _chewieController!)
            : Container(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              await ImageGallerySaver.saveFile(
                widget.video.path,
                name: 'Status_Saver_${DateTime.now()}',
              ).then((value) {
                Fluttertoast.showToast(
                  msg: "Video Saved.",
                  backgroundColor: Colors.green,
                );
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(
                  msg: "Some error occured",
                  backgroundColor: Colors.red,
                );
              });
            },
            heroTag: 'download,',
            child: const Icon(Icons.download),
          ),
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () {
              Share.shareXFiles([XFile(widget.video.path)]);
            },
            heroTag: 'share,',
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}
