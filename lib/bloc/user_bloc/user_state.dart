part of 'user_bloc.dart';

enum Submission {
  loading,
  success,
  error,
  initial
}

class UserState extends Equatable{
  final MyUser? userData;
  final String error;
  final Submission submission;

  const UserState({
    this.userData,
    this.error ="",
    this.submission =Submission.initial,
});


  UserState copyWith({
    MyUser? userData,
    String? error,
    Submission? submission,
}){
    return UserState(
    error: error ??this.error,
    userData: userData ?? this.userData,
      submission: submission ?? this.submission,
    );
}

  @override
  List<Object?> get props => [userData,error,submission];



}

// class UserInitial extends UserState {}
//
// class GetUserDataSuccess extends UserInitial{
//   final MyUser useData;
//   GetUserDataSuccess(this.useData);
// }
// class GetUserDataLoading extends UserInitial{}
// class GetUserDataError extends UserInitial{
//   final String error;
//   GetUserDataError(this.error);
// }
