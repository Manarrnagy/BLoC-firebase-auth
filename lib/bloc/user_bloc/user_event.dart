part of 'user_bloc.dart';

@immutable
abstract class UserEvent extends Equatable{
}
class LoadUserData extends UserEvent{
  final String userId;
  LoadUserData(this.userId);

  @override
  List<Object?> get props =>[userId];
}
class UploadUserImage extends UserEvent{
  final String imageName;
  final String userId;
  UploadUserImage(this.userId,this.imageName);

  @override
  List<Object?> get props => [imageName,userId];
}

class UpdateUserData extends UserEvent{
  final String userId;
  final String dataKey;
  final String data;
  UpdateUserData(this.userId,this.dataKey,this.data);
  @override
  List<Object?> get props => [userId,dataKey,data];

}