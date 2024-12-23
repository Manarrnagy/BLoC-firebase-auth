import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_one_think/data/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:task_one_think/main.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
  FirebaseFirestore.instance.collection('my_users');




  Future<DocumentSnapshot> getUsers(String userId) async {
    DocumentSnapshot userDetails = await _usersCollection.doc(userId).get();
    return userDetails;
  }

  //-------------------------------------------------------------------------------------

  Future<void> addUserWithId(MyUser user) {
    return _usersCollection
        .doc(user.id.toString()) // <-- Document ID
        .set({'username': user.username,
      'email': user.email,
      'image': user.image,}) // <-- Your data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  //-------------------------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
        email: email, password: password)
        .then((value) async {
      if (value.user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("userID", value.user!.uid);
        return true;
      }
    });
    return false;
  }

  //-------------------------------------------------------------------------------------
  Future<bool> signout() async {
    await FirebaseAuth.instance.signOut().then((value) async {
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.remove("userID");
      return true;
    });
    return false;
  }

  //-------------------------------------------------------------------------------------

  Future<bool> createUser(String username,String email, String password) async {
    UserCredential userCredential =
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
    if (userCredential.user != null) {
      MyUser newUser = MyUser(
          id: userCredential.user!.uid.toString(),
          username: username,
          email: email,
          image: "");

      await firestoreService.addUserWithId(newUser);
      SharedPreferences pref = await SharedPreferences.getInstance();
      pref.setString("userID", userCredential.user?.uid ?? "");
      return true;
    }
    return false;
  }
    //-------------------------------------------------------------------------------------

    Future<bool> addProfileImage() async {
      File? _photo;
      final ImagePicker _picker = ImagePicker();
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        final fileName = basename(firebaseUserID);
        final destination = 'profile/$fileName.jpg';
        final ref =
        firebase_storage.FirebaseStorage.instance.ref().child(destination);
        TaskSnapshot uploadTask = await ref.putFile(_photo);
        var imageUrl = await uploadTask.ref.getDownloadURL();
        updateFirebaseData(datakey: "image", data: imageUrl);
        return true;
      }
      return false;
    }

    //-------------------------------------------------------------------------------------

    Future<void> uploadUserImage(MyUser user, String ImageUrl) {
      return _usersCollection.doc(user.id).update({
        'image': ImageUrl,
      });
    }


    Future<void> updateFirebaseData(
        {required String datakey, required String data}) {
      return _usersCollection.doc(firebaseUserID).update({
        datakey: data,
      });
    }
  }
//-------------------------------------------------------------------------------------

// Future<void> deleteTodo(String userId) {
//   return _usersCollection.doc(userId).delete();
// }

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
