
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/home/homepage.dart';
import 'package:time_tracker/app/login/login_page.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/services/database.dart';

class LandingPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    return StreamBuilder<User>(
        stream: auth.authStateChanges(),
        builder: (context, snapshot){
          if(snapshot.connectionState == ConnectionState.active){
            final User user= snapshot.data;
            if(user==null){
              return LoginPage.create(context);
            }
            return Provider<Database>(
              create: (_)=> FirestoreDatabase(userID: user.uid),
              child: HomePage()
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
