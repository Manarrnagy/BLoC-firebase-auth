part of 'user_auth_cubit.dart';

@immutable
abstract class UserAuthState {}

class UserAuthInitial extends UserAuthState {}

// login states
class LoginLoading extends UserAuthInitial {}

class LoginSuccess extends UserAuthInitial {
}

class LoginError extends UserAuthInitial {
  final String error;

  LoginError(this.error);
}

// signup states

class SignupLoading extends UserAuthInitial {}

class SignupSuccess extends UserAuthInitial {}

class SignupError extends UserAuthInitial {
  final String error;

  SignupError(this.error);
}

