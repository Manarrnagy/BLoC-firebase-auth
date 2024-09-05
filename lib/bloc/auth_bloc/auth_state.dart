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

// logout states
class LogoutLoading extends AuthInitial {}

class LogoutSuccess extends AuthInitial {
}

class LogoutError extends AuthInitial {
  final String error;

  LogoutError(this.error);
}

