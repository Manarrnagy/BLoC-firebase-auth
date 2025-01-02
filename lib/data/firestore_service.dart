import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_one_think/bloc/auth_bloc/auth_bloc.dart';
import 'package:task_one_think/data/user_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:task_one_think/main.dart';

class FirestoreService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static SharedPreferences? shared_User;
  static const userCacheKey = '__user_cache_key__';
  final StreamController<MyUser> userStreamController =
      StreamController<MyUser>();
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('my_users');

  FirestoreService._();

  static final instance = FirestoreService._();

  static getInstance() async {
    shared_User ??= await SharedPreferences.getInstance();
    if (instance != null) {
      return instance;
    } else {
      return FirestoreService();
    }
  }

  FirestoreService() {
    init();
  }

  Future init() async {
    try {
      await _firebaseAuth.currentUser?.reload();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-disabled' || e.code == 'user-not-found') {
        ///log user out
        // User is disabled.
        // _controller.add(MainUserData.empty);
        // await Future.wait([
        //   shared_User?.remove(userCacheKey),
        //   shared_User.remove("CacheKey1"),
        //   shared_User.remove("CacheKey2"),
        //   // shared_User.remove(employeeCacheKey),
        //   shared_User.clear(),
        //   // _firebaseAuth.signOut(),
        // ]);
      }
    }
  }
  MyUser get currentUser{
    try {
      String? data = shared_User?.getString(userCacheKey);
      MyUser? user = MyUser.fromJson(
        ///------------------may cause error
          jsonDecode(data ?? "") as Map<String, dynamic>,currentUser.id);
      return user;
    } catch (e) {
      return MyUser.empty();
    }
  }
  @override
  Stream<MyUser?> get user async* {
    if (currentUser.id!= null) {
      try {
        // Emit the initial data immediately
        userStreamController.add(currentUser);

        yield currentUser;

        // Start listening for updates from the database
        _usersCollection.doc(currentUser.id).snapshots().listen((adminDoc) {


          if (!adminDoc.exists) {
            userStreamController.add(MyUser.empty());
            throw FirebaseAuthException(
              code: 'no-admin-privileges',
              message: 'You do not have admin privileges.',
            );
          } else {
           /// saveDataFromFirebase(adminDoc: adminDoc);
          }
        });

        // Yield data from the controllerUser stream
        yield* userStreamController.stream;
      } catch (e) {
        userStreamController.addError(e);
        yield* userStreamController.stream;
      }
    } else {
      yield* userStreamController.stream;
    }
  }

  Future<MyUser> getUsers(String userId) async {
    try {
      DocumentSnapshot userDetails = await _usersCollection.doc(userId).get();
      MyUser user = MyUser.fromJson(
          userDetails.data() as Map<String, dynamic>, userDetails.id);
      return user;
    } catch (e) {
      debugPrint(e.toString());
      return MyUser.empty();
    }
  }

  Future<void> saveDataFromFirebase({
    required DocumentSnapshot<Map<String, dynamic>> adminDoc,
  }) async {
    MyUser user = MyUser.fromJson(adminDoc.data() ??{},currentUser.id);

    shared_User?.setString(userCacheKey, jsonEncode(user));
   userStreamController.add(user);
    /// controllerUser.add(MyUser.empty);
  }
  //-------------------------------------------------------------------------------------

  Future<void> addUserWithId(MyUser user) {
    return _usersCollection
        .doc(user.id.toString()) // <-- Document ID
        .set({
          'username': user.username,
          'email': user.email,
          'image': user.image,
        }) // <-- Your data
        .then((_) => print('Added'))
        .catchError((error) => print('Add failed: $error'));
  }

  //-------------------------------------------------------------------------------------
  Future<bool> login(String email, String password) async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((value) async {
      if (value.user != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        firebaseUserID = value.user!.uid;
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

  Future<bool> createUser(
      String username, String email, String password) async {
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
      firebaseUserID = userCredential.user?.uid ?? "";
      return true;
    }
    return false;
  }

  //-------------------------------------------------------------------------------------

  Future<bool> addProfileImage() async {
    // File? _photo;
    final ImagePicker _picker = ImagePicker();
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // _photo = File(pickedFile.path);
      final fileName = basename(firebaseUserID);
      final destination = 'profile/$fileName.jpg';
      final ref =
          firebase_storage.FirebaseStorage.instance.ref().child(destination);
      TaskSnapshot uploadTask = await ref.putFile(File(pickedFile.path));
      var imageUrl = await uploadTask.ref.getDownloadURL();
      updateFirebaseData(datakey: "image", data: imageUrl);
      return true;
    }
    return false;
  }

  //-------------------------------------------------------------------------------------

  Future<void> uploadUserImage(MyUser user, String imageUrl) {
    return _usersCollection.doc(user.id).update({
      'image': imageUrl,
    });
  }

  Future<void> updateFirebaseData(
      {required String datakey, required String data}) {
    // return _usersCollection.doc(firebaseUserID).update({
    //   datakey: data,
    // });
    /// RECOMMENDED
    return _usersCollection.doc(firebaseUserID).set({
      datakey: data,
    }, SetOptions(merge: true));
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
