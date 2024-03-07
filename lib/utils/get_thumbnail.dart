import 'dart:typed_data';

import 'package:video_thumbnail/video_thumbnail.dart';

// Future<String> getThumbnail(String path) async {
//   final thumbnail = await VideoThumbnail.thumbnailFile(
//     video: path,
//     maxWidth: 128,
//     quality: 25,
//   );
//   return thumbnail!;
// }

Future<Uint8List> getThumbnailUint8List(String path) async {
  final thumbnail = await VideoThumbnail.thumbnailData(
    video: path,
    maxWidth: 200,
    quality: 75,
  );
  return thumbnail!;
}
