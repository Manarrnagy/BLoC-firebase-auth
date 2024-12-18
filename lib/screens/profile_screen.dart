import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_one_think/data/user_model.dart';
import 'package:task_one_think/utils/app_colors.dart';
import 'package:task_one_think/utils/app_components.dart';

import '../bloc/user_bloc/user_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  MyUser myUser = MyUser();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserBloc()
        ..add(LoadUserData(FirebaseAuth.instance.currentUser?.uid ?? "")),
      child: BlocListener<UserBloc, UserState>(
        listener: (context, state) {
          ///context.read<UserBloc>().add(UploadUserImage(FirebaseAuth.instance.currentUser?.uid??"", "imageName"));
          if (state.submission == Submission.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error.toString(),
                ),
              ),
            );
          }
          if (state.submission == Submission.success) {
            myUser = state.userData!;
          }
        },
        child: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state.submission == Submission.loading) {
              return Scaffold(
                  body: Center(
                child: CircularProgressIndicator(),
              ));
            }

            return Scaffold(
              body: Column(
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
                        backgroundImage: NetworkImage(state.userData?.image??""),
                      ),
                      AppComponents.solidButton(
                        fun: () {
                          context.read<UserBloc>().add(UploadUserImage(FirebaseAuth.instance.currentUser?.uid??"", "imageName"));
                        },
                        widget: Icon(CupertinoIcons.add, color: Colors.white,),
                        context: context,
                        heightPercent:
                            0.05,
                        widthPercent: 0.1
                          ,
                        color: AppColors.orange
                      ),
                    ],
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.15,
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.profile_circled,
                    ),
                    title: Text("${myUser.firstName} ${myUser.lastName}"),
                    contentPadding: EdgeInsets.only(left: 30),
                  ),
                  ListTile(
                    leading: Icon(
                      CupertinoIcons.mail,
                    ),
                    title: Text("${myUser.email}"),
                    contentPadding: EdgeInsets.only(left: 30),
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
