import "package:flutter/material.dart";
import 'package:time_tracker/app/login/landingPage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:time_tracker/services/Authentication.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Time Tracker",
        theme: ThemeData(
          primarySwatch: Colors.indigo,
        ),
      home: LandingPage(auth: Authentication()),
    );
  }
}

