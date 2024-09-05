import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_one_think/bloc/auth_bloc/auth_bloc.dart";
import "package:task_one_think/bloc/dummy_user_bloc/dummy_user_bloc.dart";
import "package:task_one_think/utils/app_components.dart";


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    BlocProvider.of<DummyUserBloc>(context).add(LoadUsers());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is LogoutSuccess) {
            Navigator.pushReplacementNamed(context, "login");
          }else if(state is LogoutError){
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error.toString()),
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            if(state is LogoutLoading){
              return AppComponents.loadingIndicator(context: context);
            }
            return Scaffold(
              appBar: AppBar(
                leading: InkWell(
                  child: Icon(
                    Icons.logout,
                  ),
                  onTap: () async {
                   BlocProvider.of<AuthBloc>(context).add(LogoutRequest());
                  },
                ),
              ),
              body:
              BlocBuilder<DummyUserBloc, DummyUserState>(
                  builder: (context, state) {
                    if (state is DummyUserLoaded) {
                      final users = state.users;
                      return ListView.builder(
                          itemCount: users.length,
                          itemBuilder: (context, i) {
                            return ListTile(
                              leading: Container(
                                child: Image.network(users[i].image),
                                width: 50,
                                height: 50,
                              ),
                              title: Text(
                                "${users[i].firstname} ${users[i].lastname}",
                              ),
                            );
                          },);
                    } else if (state is DummyUserError) {
                      return Center(child: Text(state.errorMessage));
                    } else
                      return AppComponents.loadingIndicator(context: context);
                  }),
            );
          },
        ),
      ),
    );
  }
}
