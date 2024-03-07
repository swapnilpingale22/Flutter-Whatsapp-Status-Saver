import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';
import 'package:whatsapp_status_saver/screens/bottom_nav_pages/image_view_screen.dart';

class Images extends StatefulWidget {
  const Images({Key? key}) : super(key: key);

  @override
  State<Images> createState() => _ImagesState();
}

class _ImagesState extends State<Images> {
  @override
  Widget build(BuildContext context) {
    final images = Provider.of<GetStatusProvider>(context).statusImageFiles;
    return images.isEmpty
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Padding(
            padding: const EdgeInsets.only(left: 20),
            child: GridView.builder(
              itemCount: images.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ImageViewScreen(index: index),
                      ),
                    );
                  },
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 2,
                              offset: Offset(2, 2),
                              color: Colors.black54,
                            )
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.file(
                            images[index],
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: -5,
                        bottom: 15,
                        child: IconButton(
                          icon: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.download_rounded,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
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
                        ),
                      ),
                      Positioned(
                        right: 15,
                        bottom: 15,
                        child: IconButton(
                          icon: const CircleAvatar(
                            radius: 18,
                            backgroundColor: Colors.black54,
                            child: Icon(
                              Icons.share,
                              color: Colors.white,
                              size: 25,
                            ),
                          ),
                          onPressed: () {
                            Share.shareXFiles([XFile(images[index].path)]);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }
}
