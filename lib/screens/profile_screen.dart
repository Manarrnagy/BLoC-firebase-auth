import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_one_think/main.dart';
import 'package:task_one_think/utils/app_colors.dart';
import 'package:task_one_think/utils/app_components.dart';

import '../bloc/user_bloc/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String fieldUpdated;
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  // bool isLoading = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  // MyUser myUser = MyUser();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(LoadUserData(FirebaseAuth.instance.currentUser?.uid ?? "")),
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          if (state.submission == Submission.error ||
              state.imageUpload == ImageUpload.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error.toString(),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              body: ((state.submission == Submission.loading) ||
                      (state.imageUpload == ImageUpload.loading))
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 100,
                              backgroundImage: (state
                                          .userData?.image?.isNotEmpty ??
                                      false)
                                  ? NetworkImage(state.userData?.image ?? "")
                                  : null,
                            ),
                            AppComponents.solidButton(
                                fun: () {
                                  context.read<UserBloc>().add(UploadUserImage(
                                      FirebaseAuth.instance.currentUser?.uid ??
                                          "",
                                      "imageName"));
                                },
                                widget: const Icon(
                                  CupertinoIcons.add,
                                  color: Colors.white,
                                ),
                                context: context,
                                heightPercent: 0.05,
                                widthPercent: 0.1,
                                color: AppColors.orange),
                          ],
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.15,
                        ),
                        ListTile(
                          leading: const Icon(
                            CupertinoIcons.profile_circled,
                          ),
                          title: Text("${state.userData?.username}"),
                          contentPadding: const EdgeInsets.only(left: 30),
                          trailing: IconButton(
                              onPressed: () {
                                usernameController.text =
                                    state.userData!.username!;
                                fieldUpdated = "username";
                                showModalBottomSheet<void>(
                                  context: context,
                                  builder: (ctx) {
                                    return SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.75,
                                      child: Padding(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Form(
                                          key: formKey,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              //mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Text(
                                                    'Updating your ${fieldUpdated}'),
                                                AppComponents.customFormField(
                                                    fieldController:
                                                        usernameController,
                                                    hint:
                                                        "Please update you ${fieldUpdated}",
                                                    validatorString:
                                                        (String val) {
                                                      /// REGEX for name
                                                    },
                                                    context: context,
                                                    hiddenText: false),
                                                ElevatedButton(
                                                  child: const Text(
                                                      'Save Changes'),
                                                  onPressed: () {
                                                    context
                                                        .read<UserBloc>()
                                                        .add(
                                                          UpdateUserData(
                                                              firebaseUserID,
                                                              "username",
                                                              usernameController
                                                                  .text),
                                                        );
                                                    usernameController.text =
                                                        "";
                                                    // context.read<UserBloc>().add(LoadUserData(firebaseUserID));
                                                    Navigator.pop(ctx);


                                                  },

                                                  ///update id from shared pref
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                );

                                /// context.read<UserBloc>().add(UpdateUserData(firebaseUserID, "username", data))
                              },
                              icon: Icon(Icons.edit)),
                        ),
                        ListTile(
                          leading: const Icon(
                            CupertinoIcons.mail,
                          ),
                          title: Text("${state.userData?.email}"),
                          contentPadding: const EdgeInsets.only(left: 30),
                          trailing: IconButton(
                              onPressed: () {}, icon: Icon(Icons.edit)),
                        ),
                      ],
                    ),
            );
          },
        ),
      ),
    );
  }
}
