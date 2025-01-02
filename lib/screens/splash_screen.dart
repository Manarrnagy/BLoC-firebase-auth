import 'package:flutter/material.dart';
import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:lottie/lottie.dart';
import 'package:task_one_think/screens/home/home_screen.dart';
import 'package:task_one_think/screens/login_screen.dart';

class SplashScreen extends StatefulWidget {
  final String userID;

  const SplashScreen({super.key, required this.userID});

  //SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen(
      useImmersiveMode: true,
      duration: const Duration(milliseconds: 3000),
      nextScreen: (widget.userID.isEmpty) ? const LoginScreen() : const HomeScreen(),
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
