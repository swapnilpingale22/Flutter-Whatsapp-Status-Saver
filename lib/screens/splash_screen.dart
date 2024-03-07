import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp_status_saver/provider/get_status_provider.dart';
import 'package:whatsapp_status_saver/screens/homescreen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigate();
    fetchData();
  }

  void navigate() {
    Future.delayed(
      const Duration(seconds: 4),
      () {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const Homescreen(),
            ),
            (route) => false);
      },
    );
  }

  fetchData() async {
    await Provider.of<GetStatusProvider>(context, listen: false).getStatus();
  }

  final colorizeColors = [
    Colors.purple,
    Colors.blue,
    Colors.yellow,
    Colors.red,
  ];

  final colorizeTextStyle = const TextStyle(
    fontSize: 50.0,
    fontWeight: FontWeight.bold,
    fontFamily: 'Horizon',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/images/SplashAnimation.json'),
            AnimatedTextKit(
              animatedTexts: [
                ColorizeAnimatedText(
                  'WhatsApp \nStatus \nSaver',
                  textStyle: colorizeTextStyle,
                  textAlign: TextAlign.center,
                  colors: colorizeColors,
                ),
              ],
              isRepeatingAnimation: true,
              totalRepeatCount: 4,
            ),
          ],
        ),
      ),
    );
  }
}
