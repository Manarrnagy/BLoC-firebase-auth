part of 'auth_bloc.dart';

enum Authorization{
  loading,
  error,
  success,
  initial
}
@immutable
 class AuthState extends Equatable{
  final String userID;
  final String error;
  final Authorization authorization;

  const AuthState({
    this.error="",
    this.authorization=Authorization.initial,
    this.userID=""
});
   AuthState copyWith({
     String? userID,
     String? error,
     Authorization? authorization
}){
    return AuthState(
       error: error?? this.error,
        authorization:authorization??this.authorization,
        userID: userID??this.userID
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [error,authorization,userID];
}

// class AuthInitial extends AuthState {}
//
//
// // login states
// class LoginLoading extends AuthInitial {}
//
// class LoginSuccess extends AuthInitial {
//
// }
//
// class LoginError extends AuthInitial {
//   final String error;
//
//   LoginError(this.error);
// }
//
// // logout states
// class LogoutLoading extends AuthInitial {}
//
// class LogoutSuccess extends AuthInitial {
//
// }
//
// class LogoutError extends AuthInitial {
//   final String error;
//
//   LogoutError(this.error);
// }
//
// class SignupLoading extends AuthInitial {}
//
// class SignupSuccess extends AuthInitial {
//
// }
//
// class SignupError extends AuthInitial {
//   final String error;
//
//   SignupError(this.error);
// }
//
