import 'package:flutter/material.dart';
import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';
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
    ///---------------------------------Bloc------------------------------------
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LoginSuccess) {
            passwordController.text="";
            emailController.text="";
            Navigator.pushNamed(context, "home");
          } else if (state is LoginError) {
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
              decoration: BoxDecoration(
                color: Colors.white,
                image: DecorationImage(
                  image: AssetImage("assets/images/bg.png"),
                  fit: BoxFit.cover,
                ),
              ),
              ///--------------------------Widgets------------------------------
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
                      ///------------------FORM-----------------------------
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
                                  if (formKey.currentState!.validate()) {
                                    BlocProvider.of<AuthBloc>(context)
                                        .add(LoginRequest(emailController.text,passwordController.text));
                                  }
                                },
                                widget: Text(
                                  "Login",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                context: context),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
