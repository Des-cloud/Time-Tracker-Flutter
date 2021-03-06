
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:provider/provider.dart';
import 'package:time_tracker/app/login/emailLoginPage.dart';
import 'package:time_tracker/app/login/loginButton.dart';
import 'package:time_tracker/app/login/sign_in_manager.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/customElevatedButton.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';

class LoginPage extends StatelessWidget {
  LoginPage({Key key, @required this.manager, @required this.isLoading}):super(key: key);
  final SignInManager manager;
  final bool isLoading;

  static Widget create(BuildContext context){
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      create: (_)=>ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        builder: (_, isLoading,__)=>Provider<SignInManager>(
          create: (_)=>SignInManager(auth: auth, isLoading: isLoading),
          child: Consumer<SignInManager>(
              builder: (_, manager, __)=>LoginPage(manager: manager, isLoading: isLoading.value,),
          ),
        ),
      ),
    );
  }

  void _showSignInError (BuildContext context, Exception exception){
    if(exception is FirebaseException && exception.code== "ERROR_ABORTED_BY_USER")
      {return;}
    else{
      showExceptionAlertDialog(
          context, title: "Sign in Failed", exception: exception);
    }
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.loginAnon();
    } on Exception catch (e){
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on Exception catch (e){
      _showSignInError(context, e);
    }
  }

  Future<void> _signInFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    }on Exception catch (e){
      _showSignInError(context, e);
    }
  }

  void _signInWithEmail(BuildContext context){
    Navigator.of(context).push (MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (context)=> EmailSignInPage(),
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
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height:50.0, child: _header()),
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
              onPressed: isLoading? (){}:()=>_signInWithGoogle(context),
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
              onPressed: isLoading?(){}:()=>_signInFacebook(context),
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
              onPressed: isLoading?(){}:()=>_signInWithEmail(context),
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
              onPressed: isLoading?null:()=>_signInAnonymously(context),
              borderRadius: 10.0,
              height: 50.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(){
    print(isLoading);
    if(isLoading){
      return Center(
        child: CircularProgressIndicator(
          value: null,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.indigo),
          strokeWidth: 5.0,
        ),
      );
    }
    return Text(
      "Login",
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35.0,
        fontWeight: FontWeight.w500,
        letterSpacing: 1.5,
      ),
    );
  }
}
