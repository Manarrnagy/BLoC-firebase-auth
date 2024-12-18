import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_one_think/data/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('my_users');

  // Stream<List<DummyUser>> getUsers() {
  //   return _usersCollection.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       return DummyUser(
  //           id: doc.id,
  //           firstname: data['firstname'],
  //           lastname: data['lastname'],
  //           email: data['email'],
  //           image: data['image']);
  //     }).toList();
  //   });
  // }
  //
  // Future<void> addUser(MyUser user) {
  //   return _usersCollection.add({
  //     'firstname': user.firstname,
  //     'lastname': user.lastname,
  //     'email': user.email,
  //     'image': user.image,
  //   });
  // }
  //

  // Future<MyUser> getUserData(String userId){
  //
  // }

  Future<void> addUserWithId(MyUser user) {

    return _usersCollection
        .doc(user.id.toString()) // <-- Document ID
        .set({'firstname': user.firstName, 'lastname': user.lastName,
        'email': user.email,
        'image': user.image,}) // <-- Your data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));

  }

  // Future<String> addProfileImage (String imageName) async{
  //   final ref = firebase_storage.FirebaseStorage.instance.ref().child(imageName);
  //   final imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
  //
  //   final uploadTask = ref.putFile(imageFile as File);
  //   final snapshot = await uploadTask.whenComplete(() => null);
  //   imageUrl = await snapshot.ref.getDownloadURL();
  // }
  //
  // Future<void> deleteTodo(String userId) {
  //   return _usersCollection.doc(userId).delete();
  // }
  Future<void> uploadUserImage(MyUser user, String ImageUrl) {
    return _usersCollection.doc(user.id).update({
      'image': ImageUrl,
    });

  }

//update user


}
