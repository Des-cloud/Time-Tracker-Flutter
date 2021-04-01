import 'package:flutter/material.dart';
import 'package:time_tracker/app/login/email_login_form.dart';
import 'package:time_tracker/services/Authentication.dart';

class EmailSignInPage extends StatelessWidget {
  EmailSignInPage({@required this.auth});
  final AuthBaseClass auth;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
              child: EmailSignInForm(auth: auth,),
          ),
        ),
      ),
      backgroundColor: Colors.grey[200],
    );
  }
}