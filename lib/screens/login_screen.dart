import 'package:flutter/material.dart';
import 'package:task_one_think/bloc/user_auth_cubit.dart';

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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserAuthCubit(),
      child: Container(
        ///to add image background to scaffold
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.white,
          image: DecorationImage(
            image: AssetImage("assets/images/bg.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                ///---FORM---
                margin: EdgeInsets.symmetric(horizontal: 25),
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
                            print("tapped");
                            if (formKey.currentState!.validate()) {
                              UserAuthCubit().login(email: emailController.text.trim(), pass: passwordController.text);
                              print("###### VALIDATED");
                              //
                              // BlocListener<UserAuthCubit, UserAuthState>(
                              //   listener: (context, state) {
                              //     if (state is LoginError) {
                              //       print("LoginError");
                              //     }
                              //     if (state is LoginSuccess) {
                              //       print("LoginSuccess");
                              //       Navigator.of(context).pushReplacementNamed("home");
                              //     }
                              //     if (state is LoginLoading) {
                              //       print("LoginLoading");
                              //     }
                              //   },
                              // );
                              // BlocBuilder<UserAuthCubit, UserAuthState>(
                              //   builder: (BuildContext context,
                              //       UserAuthState state) {
                              //     if(state is LoginError){
                              //       Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         height: MediaQuery.of(context).size.height,
                              //         color: Colors.red,
                              //       );
                              //     }else if(state is LoginSuccess){
                              //       print("sucesssss");
                              //       return Container(
                              //         width: MediaQuery.of(context).size.width,
                              //         height: MediaQuery.of(context).size.height,
                              //         color: Colors.green,
                              //       );
                              //     }
                              //     return AppComponents.loadingIndicator(context: context);
                              //   },
                              // );
                              BlocConsumer<UserAuthCubit, UserAuthState>(
                                  listener: (context, state) {
                                    print("####");
                                    if (state is LoginSuccess) {
                                      Navigator.pushReplacementNamed(
                                          context, "home");
                                    } else if (state is LoginError) {
                                      print("##############"+state.error.toString());
                                      print("##############");
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            state.error.toString()
                                          ),
                                        ),
                                      );
                                    }
                                  },
                                  builder: (context, state) {
                                    if (state is LoginLoading) {
                                      print("######### LOADINGGG");

                                      return AppComponents.loadingIndicator(
                                          context: context);
                                    } else {
                                      return Container();
                                    }
                                  }
                              );
                            }

                            ///if(state is success ) -> navigate to home
                            ///if(state is error) -> show snack bar
                            ///if (state is loading) -> show circular indicator
                          },
                          widget: Text(
                            "Login",
                            style: TextStyle(color: Colors.white, fontSize: 20),
                          ),
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
  }
}
