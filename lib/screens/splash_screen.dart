

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:task_one_think/screens/home_screen.dart';
import 'package:task_one_think/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {

  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  var initialRoute;
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen(
          (user) async {
        if (user == null) {
          initialRoute = LoginScreen();
        } else {
         initialRoute = HomeScreen();
        }
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: true,
      duration: const Duration(milliseconds: 4500),
      nextScreen: initialRoute,
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
