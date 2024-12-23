part of 'auth_bloc.dart';

@immutable
abstract class AuthEvent extends Equatable {}

class LoginRequest extends AuthEvent{
  final String email;
  final String password;
  LoginRequest( this.email, this.password);

  @override
  List<Object?> get props => [email,password];
}

class LogoutRequest extends AuthEvent{
  @override
  List<Object?> get props => throw UnimplementedError();
}


class SignupRequest extends AuthEvent{
  final String image;
  final String username;
  final String email;
  final String password;

  SignupRequest( this.image, this.username,this.email, this.password);

  @override
  List<Object?> get props => [image,username,email,password];
}




