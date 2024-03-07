import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';

class ImageViewScreen extends StatelessWidget {
  final int index;
  const ImageViewScreen({
    Key? key,
    required this.index,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final images = Provider.of<GetStatusProvider>(context).statusImageFiles;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        color: Colors.black54,
        padding: const EdgeInsets.all(15),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.file(images[index]),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton(
            shape: const CircleBorder(),
            onPressed: () async {
              await ImageGallerySaver.saveFile(
                images[index].path,
                name: 'Status_Saver_${DateTime.now()}',
              ).then((value) {
                Fluttertoast.showToast(
                  msg: "Photo Saved.",
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
              Share.shareXFiles([XFile(images[index].path)]);
            },
            heroTag: 'share,',
            child: const Icon(Icons.share),
          ),
        ],
      ),
    );
  }
}
