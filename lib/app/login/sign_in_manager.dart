import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/Authentication.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBaseClass auth;
  final ValueNotifier<bool> isLoading;

  Future<User> _signIn(Future<User> Function() signInMethod) async{
    try{
      isLoading.value= true;
      return await signInMethod();
    }catch(e){
      isLoading.value= false;
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async{
    return await _signIn(auth.signInWithGoogle);
  }
  Future<User> signInWithFacebook() async{
    return await _signIn(auth.signInWithFacebook);
  }
  Future<User> loginAnon() async{
   return await _signIn(auth.loginAnon);
  }
}