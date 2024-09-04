import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:task_one_think/data/dummy_user_model.dart';

class FirestoreService {
  final CollectionReference _usersCollection =
      FirebaseFirestore.instance.collection('dummy_users');

  Stream<List<DummyUser>> getUsers() {
    return _usersCollection.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return DummyUser(
            id: doc.id,
            firstname: data['firstname'],
            lastname: data['lastname'],
            email: data['email'],
            image: data['image']);
      }).toList();
    });
  }
  //
  // Future<void> addUser(DummyUser user) {
  //   return _usersCollection.add({
  //     'firstname': user.firstname,
  //     'lastname': user.lastname,
  //     'age': user.age,
  //     'email': user.email,
  //     'image': user.image,
  //
  //   });
  // }
  //
  // Future<void> updateTodo(DummyUser user) {
  //   return _usersCollection.doc(user.id).update({
  //     'firstname': user.firstname,
  //     'lastname': user.lastname,
  //     'age': user.age,
  //     'email': user.email,
  //     'image': user.image,
  //   });
  // }
  //
  // Future<void> deleteTodo(String userId) {
  //   return _usersCollection.doc(userId).delete();
  // }
}
