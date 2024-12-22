import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';
import '../utils/app_components.dart';



class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();

  @override
  void dispose() {
    passwordController.dispose();
    emailController.dispose();
    usernameController.dispose();
    super.dispose();
  }

  // image
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is SignupSuccess) {
            Navigator.pushNamedAndRemoveUntil(
                context, "home", (Route route) => false);
          } else if (state is SignupError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
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
                      "Create your new account",
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
                                fieldController: usernameController,
                                hint: "Please enter you username",
                                validatorString: (String val) {
                                  /// REGEX for name
                                },
                                context: context,
                                hiddenText: false),
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
                                        SignupRequest(
                                            "",
                                            usernameController.text,
                                            emailController.text,
                                            passwordController.text));
                                  }
                                },
                                widget: Text(
                                  "Sign up",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                context: context),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
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
