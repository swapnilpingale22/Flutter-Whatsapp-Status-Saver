import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/provider/bottom_navbar_provider.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';
import 'package:whatsapp_status_saver/screens/bottom_nav_pages/images.dart';
import 'package:whatsapp_status_saver/screens/bottom_nav_pages/videos.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({Key? key}) : super(key: key);

  @override
  HomescreenState createState() => HomescreenState();
}

class HomescreenState extends State<Homescreen> {
  @override
  void initState() {
    super.initState();
    // fetchData();
  }

  fetchData() async {
    await Provider.of<GetStatusProvider>(context, listen: false).getStatus();
  }

  List<Widget> pages = const [
    Videos(),
    Images(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<BottomNavProvider>(
      builder: (context, nav, child) {
        return RefreshIndicator(
          onRefresh: () {
            return Future.delayed(
              const Duration(milliseconds: 1500),
              () {
                fetchData();
              },
            );
          },
          child: Scaffold(
            appBar: AppBar(title: const Text('WhatsApp Status Saver')),
            body: pages[nav.currentIndex],
            bottomNavigationBar: BottomNavigationBar(
              onTap: (value) {
                nav.changeIndex(value);
              },
              currentIndex: nav.currentIndex,
              items: const [
                BottomNavigationBarItem(
                  icon: Icon(Icons.video_collection_rounded),
                  label: 'Videos',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.photo),
                  label: 'Photos',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
