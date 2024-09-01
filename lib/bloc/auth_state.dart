part of 'auth_bloc.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}


// login states
class LoginLoading extends AuthInitial {}

class LoginSuccess extends AuthInitial {
}

class LoginError extends AuthInitial {
  final String error;

  LoginError(this.error);
}

