import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

import '../../data/firestore_service.dart';
import '../../data/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
//-----------------------------------------LOGIN-----------------------------------------
    on<LoginRequest>((event, emit) async {
      try {
        emit(LoginLoading());

        ///show loading indicator
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: event.email, password: event.password)
            .then((value) {
          if (value.user != null) {
            emit(LoginSuccess());

            ///navigate to home
          }
        });
      } on FirebaseException catch (e) {
        emit(LoginError(e.toString()));

        ///show snack bar with error
      }
    });
//-----------------------------------------LOGOUT--------------------------------------
    on<LogoutRequest>((event, emit) async {
      try {
        emit(LogoutLoading());

        ///show loading indicator
        await FirebaseAuth.instance.signOut().then((value) {
          emit(LogoutSuccess());

          ///navigate to Login Screen
        });
      } on FirebaseException catch (e) {
        emit(LogoutError(e.toString()));

        ///show snack bar with error
      }
    });

//--------------------------------------SIGNIN-----------------------------------------
    on<SignupRequest>(
      (event, emit) async {
        UserCredential userCredential;
        try {
          emit(SignupLoading());

          ///show loading indicator
          userCredential =
              await FirebaseAuth.instance.createUserWithEmailAndPassword(
            // instantiated earlier on: final _firebaseAuth = FirebaseAuth.instance;
            email: event.email.trim(),
            password: event.password.trim(),
          );
          if (userCredential.user != null) {
            MyUser newUser = MyUser(
                id: userCredential.user!.uid.toString(),
                firstName: event.firstname,
                lastName: event.lastname,
                email: event.email,
                image: "");

            await FirestoreService().addUserWithId(newUser);
            emit(SignupSuccess());

            ///navigate to home
          }
        } on FirebaseException catch (e) {
          emit(SignupError(e.toString()));

          ///show snack bar with error
        }
      },
    );
  }
}
