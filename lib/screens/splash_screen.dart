

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:task_one_think/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  Widget initialRoute;
  SplashScreen({super.key,required this.initialRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: true,
      duration: const Duration(milliseconds: 4500),
      nextScreen: widget.initialRoute,
      backgroundColor: Colors.white,
      splashScreenBody: Center(
        child: Lottie.asset(
          "assets/animation/splash_animation.json",
          repeat: false,
        ),
      ),
    );
  }
}
