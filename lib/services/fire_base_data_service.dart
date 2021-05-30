import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_sign_api/models/user_model.dart';

class FirebaseDataService {
  final String? uid;

  FirebaseDataService({this.uid});

  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('users');

  Future createUser(String? name, String? email, String? profile) async {
    return _reference.doc(uid).set({
      'name': name,
      'email': email,
      'profile': profile,
    });
  }

  List<UserModel> _userListFromSnapshot(QuerySnapshot? snapshot) {
    return snapshot!.docs.map((DocumentSnapshot doc) {
      return UserModel(
          doc['name'] ?? '', doc['email'] ?? '', doc['profile'] ?? '');
    }).toList();
  }

  Stream<List<UserModel?>?> get users {
    return _reference.snapshots().map(_userListFromSnapshot);
  }
}
