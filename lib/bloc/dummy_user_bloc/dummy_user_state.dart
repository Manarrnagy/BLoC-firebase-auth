part of 'dummy_user_bloc.dart';

@immutable
abstract class DummyUserState {}

class DummyUserInitial extends DummyUserState {}

class DummyUserLoading extends DummyUserState {}

class DummyUserLoaded extends DummyUserState {
  final List<DummyUser> users;

  DummyUserLoaded(this.users);
}

class DummyUserError extends DummyUserState {
  final String errorMessage;
  DummyUserError(this.errorMessage);
}
