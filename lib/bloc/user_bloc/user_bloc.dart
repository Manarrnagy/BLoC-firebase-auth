
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:task_one_think/data/firestore_service.dart';
import 'package:task_one_think/main.dart';

import '../../data/user_model.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<LoadUserData>(_onLoadUser);
    on<UploadUserImage>(_onImageUpload);
    on<UpdateUserData>(_onUpdateUserData);
  }

  _onLoadUser(LoadUserData event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(submission: Submission.loading));
      var userDetails = await firestoreService.getUsers(event.userId);
      if (userDetails != MyUser.empty()) {
        emit(state.copyWith(submission: Submission.success, userData: userDetails));
      } else {
        emit(state.copyWith(
            submission: Submission.error, error: "User Not Found"));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(submission: Submission.error, error: "-*-FirebaseException-*-: ${e.toString()}"));

      ///show snack bar with error
    } catch (e) {
      emit(state.copyWith(submission: Submission.error, error: "-*-Exception-*-: ${e.toString()}"));
    }
  }
  //-------------------------------------_onImageUpload-------------------------------------
  _onImageUpload(UploadUserImage event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(imageUpload: ImageUpload.loading));
      if (await firestoreService.addProfileImage()) {
        emit(state.copyWith(imageUpload: ImageUpload.success));
        add(LoadUserData(event.userId));
      } else {
        emit(state.copyWith(imageUpload: ImageUpload.initial));
      }
    } on FirebaseException catch (e) {
      emit(
        state.copyWith(
          imageUpload: ImageUpload.error,
          error: e.toString(),
        ),
      );
    } catch (e) {
      emit(state.copyWith(imageUpload: ImageUpload.error, error: "-*-Exception-*-: ${e.toString()}"));
    }
  }

  //-------------------------------------_UpdateUserData-------------------------------------
  _onUpdateUserData(UpdateUserData event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(submission: Submission.loading));
      if (event.data.isNotEmpty) {
        await firestoreService.updateFirebaseData(datakey:  event.dataKey, data:event.data);
        emit(state.copyWith(
          submission: Submission.success,
        ));
        // add(LoadUserData(event.userId));
      } else {
        emit(state.copyWith(
            submission: Submission.error, error: "User Not Found"));
      }
    } on FirebaseException catch (e) {
      emit(state.copyWith(submission: Submission.error, error: e.toString()));
    } catch (e) {
      emit(state.copyWith(submission: Submission.error, error: "-*-Exception-*-: ${e.toString()}"));
    }
  }
  //
  // _onLoadUser(LoadUserData event, Emitter<UserState> emit) async {
  //   try {
  //     emit(state.copyWith(submission: Submission.loading));
  //     DocumentSnapshot userDetails = await FirebaseFirestore.instance
  //         .collection('my_users')
  //         .doc(event.userId)
  //         .get();
  //     if (userDetails.data() != null) {
  //       MyUser user = MyUser.fromJson(
  //           userDetails.data() as Map<String, dynamic>, userDetails.id);
  //       emit(state.copyWith(submission: Submission.success, userData: user));
  //     } else {
  //       emit(state.copyWith(
  //           submission: Submission.error, error: "User Not Found"));
  //     }
  //   } on FirebaseException catch (e) {
  //     emit(state.copyWith(submission: Submission.error, error: e.toString()));
  //
  //     ///show snack bar with error
  //   }
  // }

  // }_onImageUpload(UploadUserImage event, Emitter<UserState> emit) async {
  //   File? _photo;
  //   final ImagePicker _picker = ImagePicker();
  //
  //   try {
  //     final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
  //     emit(state.copyWith(imageUpload: ImageUpload.loading));
  //     if (pickedFile != null) {
  //       _photo = File(pickedFile.path);
  //       final fileName = basename(event.userId);
  //       final destination = 'profile/$fileName.jpg';
  //       final ref =
  //           firebase_storage.FirebaseStorage.instance.ref().child(destination);
  //       TaskSnapshot uploadTask = await ref.putFile(_photo);
  //       var imageUrl = await uploadTask.ref.getDownloadURL();
  //       FirebaseFirestore.instance
  //           .collection('my_users')
  //           .doc(event.userId)
  //           .update({
  //         'image': imageUrl,
  //       });
  //       emit(state.copyWith(imageUpload: ImageUpload.success));
  //       add(LoadUserData(event.userId));
  //     } else {
  //       emit(state.copyWith(imageUpload: ImageUpload.initial));
  //     }
  //   } on FirebaseException catch (e) {
  //     emit(state.copyWith(imageUpload: ImageUpload.error, error: e.toString()));
  //
  //     ///show snack bar with error
  //   }
  // }

  // _onUpdateUserData(UpdateUserData event, Emitter<UserState> emit) async {
  //   try {
  //     emit(state.copyWith(submission: Submission.loading));
  //     if (event.data.isNotEmpty) {
  //       // FirestoreService().updateFirebaseData(event.userId, event.dataKey, event.data);
  //       FirebaseFirestore.instance
  //           .collection('my_users')
  //           .doc(event.userId)
  //           .update({
  //         '${event.dataKey}': event.data,
  //       });
  //       emit(state.copyWith(
  //         submission: Submission.success,
  //       ));
  //       add(LoadUserData(event.userId));
  //     } else {
  //       emit(state.copyWith(
  //           submission: Submission.error, error: "User Not Found"));
  //     }
  //   } on FirebaseException catch (e) {
  //     emit(state.copyWith(submission: Submission.error, error: e.toString()));
  //   }
  // }
}
