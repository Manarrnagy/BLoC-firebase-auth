import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:task_one_think/screens/home_screen.dart';
import 'package:task_one_think/screens/login_screen.dart';
import 'package:task_one_think/screens/sign_up_screen.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: LoginScreen(), ///check internet connection (SPLASH -> CHECK INTERNET (EITHER OFFLINE OR LOGIN) )
      routes: {
        'login':(context)=>LoginScreen(),
        'signup':(context)=>SignupScreen(),
        'home':(context)=>HomeScreen(),

      },
    );
  }
}
