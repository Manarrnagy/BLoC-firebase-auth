import "package:flutter/material.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:task_one_think/bloc/dummy_user_bloc/dummy_user_bloc.dart";

import "../data/firestore_service.dart";


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
    return Scaffold(
      appBar: AppBar(leading: InkWell(child: Icon(Icons.logout,),onTap: (){ Navigator.pop(context);},),),
      body: BlocBuilder<DummyUserBloc,DummyUserState>(builder: (context,state){
      if(state is DummyUserLoading ){
        return const Center(child: CircularProgressIndicator());
      }else if(state is DummyUserLoaded){
        final users = state.users;
        return ListView.builder(itemCount: users.length,itemBuilder: (context, i){
       return ListTile(leading:Container(child: Image.network(users[i].image),width: 50,height: 50,),title: Text("${users[i].firstname} ${users[i].lastname}",),
       )  ;
        });
      }else if(state is DummyUserError){
        return Center(child: Text(state.errorMessage));
      }
      else return Container();
      }),
    );
  }
}
