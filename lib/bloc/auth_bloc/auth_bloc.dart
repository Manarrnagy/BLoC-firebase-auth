
import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {

    on<LoginRequest>((event, emit) async {
      try {
        emit(LoginLoading());
        ///show loading indicator
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email:event.email , password: event.password)
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

    on<LogoutRequest>((event,emit) async {
      try {
        emit(LogoutLoading());
        ///show loading indicator
        await FirebaseAuth.instance
            .signOut()
            .then((value) {
            emit(LogoutSuccess());
            ///navigate to Login Screen

        });
      } on FirebaseException catch (e) {
        emit(LogoutError(e.toString()));
        ///show snack bar with error
      }
    });
  }
}
