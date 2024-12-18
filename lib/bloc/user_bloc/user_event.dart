part of 'user_bloc.dart';

@immutable
abstract class UserEvent {
}
class LoadUserData extends UserEvent{
  String userId;
  LoadUserData(this.userId);


}
class UploadUserImage extends UserEvent{
  String imageName;
  String userId;
  UploadUserImage(this.userId,this.imageName);
}