import 'package:flutter/material.dart';

import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_one_think/utils/app_colors.dart';
import 'package:task_one_think/utils/app_components.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ///---------------------------------Bloc------------------------------------
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) async {
          if (state.authorization == Authorization.success) {
            Navigator.pushNamedAndRemoveUntil(
                context, "home", (Route route) => false);
          } else if (state.authorization == Authorization.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Container(
              ///to add image background to scaffold
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),

              ///--------------------------Widgets------------------------------
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.15,
                      ),
                      Text(
                        "Hello!",
                        style: TextStyle(
                          fontSize: MediaQuery.sizeOf(context).width * 0.25,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Sign in to your account",
                        style: TextStyle(
                            fontSize: MediaQuery.sizeOf(context).width * 0.06,
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        ///------------------FORM-----------------------------
                        margin: const EdgeInsets.symmetric(horizontal: 25),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppComponents.customFormField(
                                  fieldController: emailController,
                                  hint: "Please enter you email",
                                  validatorString: (String val) {
                                    if (!RegExp(
                                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                        .hasMatch(val)) {
                                      return "Please enter your email correctly";
                                    }
                                  },
                                  context: context,
                                  hiddenText: false),
                              AppComponents.customFormField(
                                  fieldController: passwordController,
                                  hint: "Please enter your password",
                                  validatorString: (String val) {
                                    if (val.length < 8) {
                                      return "Passwords must have at least 8 characters";
                                    }
                                  },
                                  context: context,
                                  hiddenText: true),
                              AppComponents.solidButton(
                                  fun: () {
                                    if (formKey.currentState!.validate()) {
                                      BlocProvider.of<AuthBloc>(context).add(
                                          LoginRequest(emailController.text,
                                              passwordController.text));
                                    }
                                  },
                                  widget: const Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  context: context),
                              SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.05,
                              ),
                              AppComponents.solidButton(
                                  fun: () {
                                    Navigator.of(context)
                                        .pushReplacementNamed("signup");
                                  },
                                  widget: const Text(
                                    "Don't have an account? SIGN UP",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ),
                                  color: AppColors.yellow,
                                  heightPercent: 0.05,
                                  widthPercent: 0.8,
                                  context: context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
