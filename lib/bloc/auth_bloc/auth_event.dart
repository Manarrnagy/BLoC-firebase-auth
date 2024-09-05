part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent {}

class LoginRequest extends AuthEvent{
  String email;
  String password;
  LoginRequest( this.email, this.password);
}

class LogoutRequest extends AuthEvent{}

class SignupRequest extends AuthEvent{}


