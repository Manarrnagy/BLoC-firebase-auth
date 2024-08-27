import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';


abstract class AuthDataSource{
  Future<void> signUp( String email,  String password, String confirmPassword);
  Future<void> logIn( String email,  String password);
}

class AuthRepository implements AuthDataSource {
  // final _firebaseAuth = FirebaseAuth.instance;
  @override
  Future<void> signUp(String email, String password,
      String confirmPassword) async {
    if (password == confirmPassword) {
      try {
        FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email, password: password);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          throw Exception("This password is weak");
        } else if (e.code == 'email-already-in-use') {
          throw Exception(
              "There is an account that already exists with this mail");
        }
      }
      catch (e) {
        throw Exception(e.toString());
      }
    }else{
      ///display error message
    }
  }



  @override
  Future<void> logIn(String email, String password) async {

    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
    }on FirebaseException catch(e){
      throw Exception(e.toString());
    }
  }
}