import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_sign_api/screens/screen.dart';
import 'package:firebase_sign_api/screens/test_logout_screen.dart';
import 'package:flutter/material.dart';

class Controller extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
              body: Center(
                  child: Text('ERROR',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                      ))));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(body: Center(child: CircularProgressIndicator()));
        } else if (snapshot.hasData) {
          return LoggedScreen(title: 'Messages');
        } else {
          return LoginScreen(title: 'Login-Register');
        }
      },
    );
  }
}
