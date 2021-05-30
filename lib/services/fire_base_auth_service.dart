import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_api/services/fire_base_data_service.dart';
import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FireBaseAuthService {
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> registerEmailandPassword(
      String email, String password) async {
    String? error;
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await FirebaseDataService(uid: user!.uid).createUser(
        user.displayName ?? user.email!.split('@')[0],
        user.email.toString(),
        'none',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        error = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        error = 'The account already exists for that email.';
      } else if (e.code == 'invalid-email') {
        error = 'Invalid Email Adress';
      }
    } catch (e) {
      log(e.toString());
    }
    return error ?? '';
  }

  Future<String> signWithEmailandPassword(String email, String password) async {
    String? error;
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      await FirebaseDataService(uid: user!.uid).createUser(
        user.displayName ?? user.email!.split('@')[0],
        user.email.toString(),
        'none',
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        error = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        error = 'Wrong password provided for that user.';
      }
    } catch (e) {
      log(e.toString());
    }
    return error ?? '';
  }

  Future<void> googleSign() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication authentication =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: authentication.idToken,
        accessToken: authentication.accessToken,
      );
      final userCredential = await _auth.signInWithCredential(credential);
      User? user = userCredential.user;
      await FirebaseDataService(uid: user!.uid).createUser(
        user.displayName,
        user.email,
        user.photoURL,
      );
    } catch (e) {
      log(e.toString());
    }
  }

  // Future<void> signInWithFacebook() async {
  //   final LoginResult result = await FacebookAuth.instance.login();
  //   final facebookAuthCredential =
  //       FacebookAuthProvider.credential(result.accessToken.toString());
  //   final userCredential =
  //       await _auth.signInWithCredential(facebookAuthCredential);
  //   User? user = userCredential.user;
  // }
}
