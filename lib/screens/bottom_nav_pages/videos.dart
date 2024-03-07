import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';
import 'package:whatsapp_status_saver/screens/bottom_nav_pages/video_view_screen.dart';

class Videos extends StatefulWidget {
  const Videos({Key? key}) : super(key: key);

  @override
  State<Videos> createState() => _VideosState();
}

class _VideosState extends State<Videos> {
  @override
  Widget build(BuildContext context) {
    final videos = Provider.of<GetStatusProvider>(context).statusVideoFiles;
    final videoThumbnails =
        Provider.of<GetStatusProvider>(context).videoThumbnails;
    return videos.isEmpty
        ? const Center(
            child: CircularProgressIndicator() 
            )
        : Padding(
            padding: const EdgeInsets.only(left: 15),
            child: GridView.builder(
              itemCount: videos.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            VideoViewScreen(video: videos[index]),
                      ),
                    );
                  },
                  child: videoThumbnails.isNotEmpty
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(bottom: 20, right: 20),
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
                                borderRadius: BorderRadius.circular(8),
                                child: Image.memory(
                                  videoThumbnails[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            const Positioned(
                              child: Icon(
                                Icons.play_circle_outline_outlined,
                                color: Colors.white,
                                size: 40,
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
                                    videos[index].path,
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
                                  Share.shareXFiles(
                                      [XFile(videos[index].path)]);
                                },
                              ),
                            ),
                          ],
                        )
                      : Container(
                          margin: const EdgeInsets.only(bottom: 20, right: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                blurRadius: 4,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                                color: Colors.black54,
                              )
                            ],
                          ),
                          child: const Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                );
              },
            ),
          );
  }
}
