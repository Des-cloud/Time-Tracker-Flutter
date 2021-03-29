
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/app/homePage.dart';
import 'package:time_tracker/app/login/login_page.dart';
import 'package:time_tracker/services/Authentication.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({Key key, @required this.auth}) : super(key: key);
  final AuthBaseClass auth;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final User user= snapshot.data;
            if(user==null){
              return LoginPage(
                auth: auth,
              );
            }
            return HomePage(
              auth: auth,
            );
          }
          return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
    );

  }
}
