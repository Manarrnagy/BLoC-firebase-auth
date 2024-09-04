import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_one_think/screens/home_screen.dart';
import 'package:task_one_think/screens/login_screen.dart';
import 'package:task_one_think/screens/sign_up_screen.dart';
import 'package:task_one_think/screens/splash_screen.dart';

import 'bloc/dummy_user_bloc/dummy_user_bloc.dart';
import 'data/firestore_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<DummyUserBloc>(
          create: (context) => DummyUserBloc(FirestoreService()),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: SplashScreen(),

        ///check internet connection (SPLASH -> CHECK INTERNET (EITHER OFFLINE OR LOGIN) )
        routes: {
          'login': (context) => LoginScreen(),
          'signup': (context) => SignupScreen(),
          'home': (context) => HomeScreen(),
        },
      ),
    );
  }
}
