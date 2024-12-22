import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "../bloc/auth_bloc/auth_bloc.dart";

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushReplacementNamed(context, "login");
          }
          if (state is LogoutError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  state.error.toString(),
                ),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(),
              drawer: Drawer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (state is LogoutLoading) CircularProgressIndicator(),

                    ListTile(
                      minVerticalPadding: 50,
                      tileColor: Colors.blue,
                      leading: Icon(
                        CupertinoIcons.profile_circled,
                        size: 30,
                      ),
                      title: Text(
                        "My Profile",
                        style: TextStyle(fontSize: 30),
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, "profile");
                      },
                    ),
                    InkWell(
                      child: Icon(
                        Icons.logout,
                        size: 50,
                      ),
                      onTap: () async {
                        BlocProvider.of<AuthBloc>(context).add(LogoutRequest());
                      },
                    ),
                    // AppComponents.solidButton(
                    //     fun: () {}, widget: widget, context: context)
                  ],
                ),
              ),
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      child: Text(
                        "Welcome to \nhome screen",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
