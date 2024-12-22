import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:task_one_think/data/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('my_users');

  // Stream<List<MyUser>> getUsers() {
  //   return _usersCollection.snapshots().map((snapshot) {
  //     return snapshot.docs.map((doc) {
  //       Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
  //       return MyUser(
  //           id: doc.id,
  //           username: data['username'],
  //           email: data['email'],
  //           image: data['image']);
  //     }).toList();
  //   });
  // }
  //


  Future<DocumentSnapshot> getUsers(String userId) async {
    DocumentSnapshot userDetails = await _usersCollection.doc(userId).get();
    return userDetails;
  }
  // }Future<void> addUser(MyUser user) {
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
        .set({'username': user.username,
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


  Future<void> updateFirebaseData(String userID,String datakey, String data) {
    return _usersCollection.doc(userID).update({
      datakey: data,
    });
  }
}

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
