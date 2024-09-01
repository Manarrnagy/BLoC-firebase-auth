import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

part 'user_auth_state.dart';

class UserAuthCubit extends Cubit<UserAuthState> {
  UserAuthCubit() : super(UserAuthInitial());

  //--------------------------------- LOGIN ---------------------------------------
  Future<void> login({
    required String email,
    required String pass,
  }) async {
    try {
      emit(LoginLoading());
      ///show loading indicator
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: pass)
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
  }

//------------------------------SIGN UP-----------------------------------
//   Future<void> signUp({
//     required String email,
//     required String pass,
//     required String username,
//     String? phone,
//   }) async {
//     emit(SignupLoading());
//     ///if validation has no error unfocus focus scope
//     try {
//       FirebaseAuth.instance
//           .createUserWithEmailAndPassword(email: email, password: pass)
//           .then(
//             (value) {
//           if (value.user != null) {
//             emit(SignupSuccess()); ///navigate to home
//           }
//         },
//       );
//     } catch (e) {
//       SignupError(e.toString());
//     }
//   }
// }
}
