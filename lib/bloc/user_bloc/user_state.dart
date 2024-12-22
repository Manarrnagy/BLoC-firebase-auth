part of 'user_bloc.dart';

enum Submission {
  loading,
  success,
  error,
  initial,
  dataUpdated
}

enum ImageUpload {
  loading,
  success,
  error,
  initial
}


class UserState extends Equatable{
  final MyUser? userData;
  final String error;
  final Submission submission;
  final ImageUpload imageUpload;

  const UserState({
    this.userData,
    this.error ="",
    this.submission =Submission.initial,
    this.imageUpload =ImageUpload.initial,
});


  UserState copyWith({
    MyUser? userData,
    String? error,
    Submission? submission,
    ImageUpload? imageUpload
}){
    return UserState(
    error: error ??this.error,
    userData: userData ?? this.userData,
      submission: submission ?? this.submission,
      imageUpload: imageUpload ?? this.imageUpload,
    );
}

  @override
  List<Object?> get props => [userData,error,submission,imageUpload];



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
