import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

class GetStatusProvider extends ChangeNotifier {
  List<File> _statusImageFiles = [];
  List<File> _statusVideoFiles = [];
  List<Uint8List> _videoThumbnails = [];

  List<File> get statusImageFiles => _statusImageFiles;
  List<File> get statusVideoFiles => _statusVideoFiles;
  List<Uint8List> get videoThumbnails => _videoThumbnails;

  Future<void> _loadStatusFiles() async {
    Directory? directory = Directory(
        '/storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/.Statuses');
    try {
      if (directory.existsSync()) {
        //fetch all files
        List<FileSystemEntity> allFiles = [];
        allFiles.addAll(directory.listSync());
        if (kDebugMode) {
          print('All Files in directory: ${allFiles.length}');
        }

        List<File> imgFiles = [];
        for (var file in allFiles) {
          if (file is File && file.path.endsWith(".jpg")) {
            imgFiles.add(file);
          }
        }
        _statusImageFiles = imgFiles;
        if (kDebugMode) {
          print('Images Files in directory: ${_statusImageFiles.length}');
        }

        List<File> mp4Files = [];
        for (var file in allFiles) {
          if (file is File && file.path.endsWith(".mp4")) {
            mp4Files.add(file);
          }
        }
        _statusVideoFiles = mp4Files;
        if (kDebugMode) {
          print('Videos Files in directory: ${_statusVideoFiles.length}');
        }
        List<Uint8List> thumbFiles = [];
        for (var file in _statusVideoFiles) {
          final thumbnail = await VideoThumbnail.thumbnailData(
            video: file.path,
            maxWidth: 200,
            quality: 75,
          );
          thumbFiles.add(thumbnail!);
        }
        _videoThumbnails = thumbFiles;

        notifyListeners();
      } else {
        Fluttertoast.showToast(msg: "WhatsApp status folder not found.");
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Error Occured: $e");
    }
  }

  Future<void> getStatus() async {
    Map<Permission, PermissionStatus> statuses =
        await [Permission.storage, Permission.manageExternalStorage].request();
    if (statuses[Permission.storage]!.isGranted &&
        statuses[Permission.manageExternalStorage]!.isGranted) {
      //fetch status
      _loadStatusFiles();
    } else {
      Fluttertoast.showToast(msg: "No permission provided");
    }
  }
}
