import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_sign_api/controller.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Firebase Login Register with API',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Controller(),
    );
  }
}
