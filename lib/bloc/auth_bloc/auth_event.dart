part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequest extends AuthEvent{
  String email;
  String password;
 // bool login;
  LoginRequest( this.email, this.password);
}

