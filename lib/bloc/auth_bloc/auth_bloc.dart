import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_one_think/main.dart';

import '../../data/firestore_service.dart';
import '../../data/user_model.dart';

part 'auth_event.dart';

part 'auth_state.dart';
FirestoreService firestoreService = FirestoreService();
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState()) {
    on<LoginRequest>(_onLoginRequest);
    on<LogoutRequest>(_onLogoutRequest);
    on<SignupRequest>(_onSignupRequest);

  }

  //-----------------------------------------LOGIN-----------------------------------------
  _onLoginRequest(LoginRequest event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authorization: Authorization.loading));
        if ( await firestoreService.login(event.email, event.password)) {
          emit(state.copyWith(
              authorization: Authorization.success, userID:firebaseUserID));
        }
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          authorization: Authorization.error, error: e.toString()));
    }
  }

//-----------------------------------------LOGOUT--------------------------------------
  _onLogoutRequest(LogoutRequest event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authorization: Authorization.loading));
      if(await firestoreService.signout()){
        emit(state.copyWith(authorization: Authorization.success, userID: ""));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          authorization: Authorization.error, error: e.toString()));
    }
  }

//--------------------------------------SIGNIN-----------------------------------------
  _onSignupRequest(SignupRequest event, Emitter<AuthState> emit) async {
    try {
      emit(state.copyWith(authorization: Authorization.loading));
      if(await firestoreService.createUser(event.username, event.email, event.password)){

        emit(state.copyWith(
            authorization: Authorization.success,
            userID: firebaseUserID));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(
          authorization: Authorization.error, error: e.toString()));
    }
  }
}
// }//-----------------------------------------LOGIN-----------------------------------------
//     on<LoginRequest>((event, emit) async {
//       try {
//         emit(LoginLoading());
//
//         ///show loading indicator
//         await FirebaseAuth.instance
//             .signInWithEmailAndPassword(
//                 email: event.email, password: event.password)
//             .then((value) async {
//           if (value.user != null) {
//             SharedPreferences pref = await SharedPreferences.getInstance();
//             pref.setString("userID",value.user!.uid);
//             emit(LoginSuccess());
//
//             ///navigate to home
//           }
//         });
//       } on FirebaseException catch (e) {
//         emit(LoginError(e.toString()));
//
//         ///show snack bar with error
//       }
//     });
// //-----------------------------------------LOGOUT--------------------------------------
//     on<LogoutRequest>((event, emit) async {
//       try {
//         emit(LogoutLoading());
//
//         ///show loading indicator
//         await FirebaseAuth.instance.signOut().then((value) async {
//           SharedPreferences pref = await SharedPreferences.getInstance();
//           pref.remove("userID");
//           emit(LogoutSuccess());
//
//           ///navigate to Login Screen
//         });
//       } on FirebaseException catch (e) {
//         emit(LogoutError(e.toString()));
//
//         ///show snack bar with error
//       }
//     });
//
// //--------------------------------------SIGNIN-----------------------------------------
//     on<SignupRequest>(
//       (event, emit) async {
//         UserCredential userCredential;
//         try {
//           emit(SignupLoading());
//
//           ///show loading indicator
//           userCredential =
//               await FirebaseAuth.instance.createUserWithEmailAndPassword(
//             // instantiated earlier on: final _firebaseAuth = FirebaseAuth.instance;
//             email: event.email.trim(),
//             password: event.password.trim(),
//           );
//           if (userCredential.user != null) {
//             MyUser newUser = MyUser(
//                 id: userCredential.user!.uid.toString(),
//                 username: event.username,
//                 email: event.email,
//                 image: "");
//
//             await FirestoreService().addUserWithId(newUser);
//             SharedPreferences pref = await SharedPreferences.getInstance();
//             pref.setString("userID",userCredential.user?.uid??"");
//             emit(SignupSuccess());
//             ///navigate to home
//           }
//         } on FirebaseException catch (e) {
//           emit(SignupError(e.toString()));
//
//           ///show snack bar with error
//         }
//       },
//     );
//   }
// }
