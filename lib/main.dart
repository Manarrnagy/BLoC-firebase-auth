
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_one_think/screens/home_screen.dart';
import 'package:task_one_think/screens/login_screen.dart';
import 'package:task_one_think/screens/profile_screen.dart';
import 'package:task_one_think/screens/sign_up_screen.dart';
import 'package:task_one_think/screens/splash_screen.dart';
import 'package:task_one_think/utils/app_constants.dart';

import 'bloc/user_bloc/user_bloc.dart';

var firebaseUserID ="";
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SharedPreferences prefs =await SharedPreferences.getInstance();
  firebaseUserID=prefs.getString("userID")??"";
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserBloc>(
          create: (BuildContext context) => UserBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home:SplashScreen(userID: firebaseUserID),
        debugShowCheckedModeBanner: false,

        ///check internet connection (SPLASH -> CHECK INTERNET (EITHER OFFLINE OR LOGIN) )
        routes: {
          'login': (context) => const LoginScreen(),
          'signup': (context) => const SignupScreen(),
          'home': (context) => const HomeScreen(),
          'profile': (context) => const ProfileScreen(),
        },
      ),
    );
  }
}
