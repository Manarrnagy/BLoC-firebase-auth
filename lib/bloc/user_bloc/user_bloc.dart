import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

import '../../data/user_model.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  UserBloc() : super(const UserState()) {
    on<LoadUserData>(_onLoadUser);
    on<UploadUserImage>(_onImageUpload);
  }

  _onLoadUser(LoadUserData event, Emitter<UserState> emit) async {
    try {
      emit(state.copyWith(submission: Submission.loading));
      CollectionReference users =
      FirebaseFirestore.instance.collection('my_users');
      // FutureBuilder<DocumentSnapshot>(
      //   future: users.doc(event.userId).get(),
      //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
      //     if (snapshot.hasError) {
      //       emit(GetUserDataError("Something went wrong"));
      //     }
      //     if (snapshot.hasData && !snapshot.data!.exists) {
      //       emit(GetUserDataError("Document does not exist"));
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.done) {
      //       Map<String, dynamic> data =
      //           snapshot.data!.data() as Map<String, dynamic>;
      //       return Text("Hello, ${data['userName']}");
      //     }
      //   },
      // );
      // await users.get().then((value) => value.docs.);

      DocumentSnapshot userDetails = await FirebaseFirestore.instance
          .collection('my_users')
          .doc(event.userId)
          .get();
      if (userDetails.data() != null) {
        MyUser user = MyUser.fromJson(
            userDetails.data() as Map<String, dynamic>, userDetails.id);
        emit(state.copyWith(submission: Submission.success, userData: user));
      } else {
        emit(state.copyWith(
            submission: Submission.error, error: "User Not Found"));
      }
      // emit((GetUserDataSuccess()));
      //
      // ///show loading indicator
      // ///load user data
      // await FirebaseAuth.instance
      //     .signInWithEmailAndPassword(
      //     email: event.email, password: event.password)
      //     .then((value) {
      //   if (value.user != null) {
      //     emit(LoginSuccess());
      //
      //     ///navigate to home
      //   }
      // });
    } on FirebaseException catch (e) {
      emit(state.copyWith(submission: Submission.error, error: e.toString()));

      ///show snack bar with error
    }
  }
  _onImageUpload(UploadUserImage event, Emitter<UserState> emit)async{
    // try{
    //   emit(state.copyWith(imageUpload: ImageUpload.loading));
    //   final ref = firebase_storage.FirebaseStorage.instance.ref().child(event.userId);
    //
    //   final imageFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    //   // imageFile?.name.split(".").last;
    //   final uploadTask = ref.putFile(imageFile );
    //   final snapshot = await uploadTask.whenComplete(() => null);
    //   var imageUrl = await snapshot.ref.getDownloadURL();
    //   FirebaseFirestore.instance.collection('my_users').doc(event.userId).update({'image': imageUrl,});
    //
    //   emit(state.copyWith(imageUpload: ImageUpload.success));
    //   add(LoadUserData(event.userId));
    // }on FirebaseException catch (e) {
    //   emit(state.copyWith(imageUpload: ImageUpload.error, error: e.toString()));
    //   ///show snack bar with error
    // }
    // firebase_storage.FirebaseStorage storage =
    //     firebase_storage.FirebaseStorage.instance;

    File? _photo;
    final ImagePicker _picker = ImagePicker();

    try{
      emit(state.copyWith(imageUpload: ImageUpload.loading));
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        final fileName = basename(event.userId);
        final destination = 'profile/$fileName.jpg';
        final ref = firebase_storage.FirebaseStorage.instance
            .ref().child(destination);
          TaskSnapshot uploadTask = await ref.putFile(_photo);
          var imageUrl = await uploadTask.ref.getDownloadURL();
          FirebaseFirestore.instance.collection('my_users').doc(event.userId).update({'image': imageUrl,});
        emit(state.copyWith(imageUpload: ImageUpload.success));
        add(LoadUserData(event.userId));
      }
    }
    on FirebaseException catch (e) {
      emit(state.copyWith(imageUpload: ImageUpload.error, error: e.toString()));
      ///show snack bar with error
    }
  }


  // _onLoadImage(LoadUserImage event, Emitter<UserState> emit)async{
  //   try{
  //     emit(state.copyWith(imageUpload: ImageUpload.loading));
  //     CollectionReference users =
  //     FirebaseFirestore.instance.collection('my_users');
  //     // FutureBuilder<DocumentSnapshot>(
  //     //   future: users.doc(event.userId).get(),
  //     //   builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot)  {
  //     //     if (snapshot.hasError) {
  //     //       emit(GetUserDataError("Something went wrong"));
  //     //     }
  //     //     if (snapshot.hasData && !snapshot.data!.exists) {
  //     //       emit(GetUserDataError("Document does not exist"));
  //     //     }
  //     //
  //     //     if (snapshot.connectionState == ConnectionState.done) {
  //     //       Map<String, dynamic> data =
  //     //           snapshot.data!.data() as Map<String, dynamic>;
  //     //       return Text("Hello, ${data['userName']}");
  //     //     }
  //     //   },
  //     // );
  //     // await users.get().then((value) => value.docs.);
  //
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
  //   } on FirebaseException catch (e){
  //
  //   }
  // }
}


