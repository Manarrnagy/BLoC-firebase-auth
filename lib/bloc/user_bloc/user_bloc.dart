import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import '../../data/user_model.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<LoadUserData>(_onLoadUser);
  }

  _onLoadUser(LoadUserData event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(submission: Submission.loading));
      // emit(GetUserDataLoading());
      CollectionReference users =
          FirebaseFirestore.instance.collection('my_users');
      // FutureBuilder<DocumentSnapshot>(
      //   future: users.doc(event.userId).get(),
      //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
      //     if (snapshot.hasError) {
      //       emit(GetUserDataError("Something went wrong"));
      //     }
      //     if (snapshot.hasData && !snapshot.data!.exists) {
      //       emit(GetUserDataError("Document does not exist"));
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       Map<String, dynamic> data =
      //           snapshot.data!.data() as Map<String, dynamic>;
      //       return Text("Hello, ${data['userName']}");
      //     }
      //   },
      // );
      // await users.get().then((value) => value.docs.);

      DocumentSnapshot userDetails = await FirebaseFirestore.instance
          .collection('my_users')
          .doc(event.userId)
          .get();
      if (userDetails.data() != null) {
        MyUser user = MyUser.fromJson(
            userDetails.data() as Map<String, dynamic>, userDetails.id);
        emit(state.copyWith(submission: Submission.success, userData: user));
      } else {
        emit(state.copyWith(
            submission: Submission.error, error: "User Not Found"));
      }
      // emit((GetUserDataSuccess()));
      //
      // ///show loading indicator
      // ///load user data
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //     email: event.email, password: event.password)
      //     .then((value) {
      //   if (value.user != null) {
      //     emit(LoginSuccess());
      //
      //     ///navigate to home
      //   }
      // });
    } on FirebaseException catch (e) {
      emit(state.copyWith(submission: Submission.error, error: e.toString()));

      ///show snack bar with error
    }
  }
}
