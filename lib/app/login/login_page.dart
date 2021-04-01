import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:time_tracker/app/login/emailLoginPage.dart';
import 'package:time_tracker/app/login/loginButton.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/customElevatedButton.dart';

class LoginPage extends StatelessWidget {

  const LoginPage({Key key, @required this.auth}) : super(key: key);
  final AuthBaseClass auth;

  Future<void> _signInAnonymously() async {
    try {
      await auth.loginAnon();
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await auth.signInWithGoogle();
    } catch (e){
      print(e.toString());
    }
  }

  Future<void> _signInFacebook() async {
    try {
      await auth.signInWithFacebook();
    } catch (e){
      print(e.toString());
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.push(context, CupertinoPageRoute(
        fullscreenDialog: false,
        builder: (context)=> EmailSignInPage(auth: auth,),
    ));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracker"),
        centerTitle: true,
        elevation: 2.0,
      ),
      body: _buildBody(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 35.0,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.5,
            ),
          ),
          SizedBox(height: 40.0,),

          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/google-logo.png",),
                Text("Sign in with Google",
                  style: TextStyle(
                    color: Colors.black87,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 50.0, width: 42.0,)
              ],
            ),
            primary: Colors.white,
            onPressed: _signInWithGoogle,
            borderRadius: 10.0,
          ),

          SizedBox(height: 10.0,),

          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset("images/facebook-logo.png",),
                Text("Sign in with Facebook",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 50.0, width: 42.0,)
              ],
            ),
            primary: Color(0xFF334D92),
            onPressed: _signInFacebook,
            borderRadius: 10.0,
          ),

          SizedBox(height: 10.0,),

          CustomElevatedButton(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Image.asset(
                  "images/email-logo.png",
                  height: 40.0,
                  width: 45.0,
                ),
                Text("Sign in with Email",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15.0,
                  ),
                ),
                SizedBox(height: 50.0, width: 42.0,)
              ],
            ),
            primary: Colors.teal[700],
            onPressed: ()=>_signInWithEmail(context),
            borderRadius: 10.0,
          ),

          SizedBox(height: 8.0),

          Text(
            "or",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 14.0,
              fontWeight: FontWeight.w900,
            ),
          ),

          SizedBox(height: 8.0),

          LoginButton(
            text: "Sign in Anonymously",
            textColor: Colors.black87,
            color: Colors.lime[200],
            onPressed: _signInAnonymously,
            borderRadius: 10.0,
            height: 50.0,
          ),
        ],
      ),
    );
  }
}

void _signEmail(){
  //To sign in Email
  print("Email clicked");
}
