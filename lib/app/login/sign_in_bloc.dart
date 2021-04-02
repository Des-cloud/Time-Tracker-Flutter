import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/services/Authentication.dart';

class SignInBloc {
  SignInBloc({@required this.auth});
  final AuthBaseClass auth;

  final StreamController<bool> _isLoadingController= StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  void dispose(){
    _isLoadingController.close();
  }

  void _setIsLoading(bool isLoading){
    return _isLoadingController.add(isLoading);
  }

  Future<User> _signIn(Future<User> Function() signInMethod) async{
    try{
      _setIsLoading(true);
      return await signInMethod();
    }catch(e){
      _setIsLoading(false);
      rethrow;
    }
  }

  Future<User> signInWithGoogle() async{
    return await _signIn(auth.signInWithGoogle);
  }
  Future<User> signInWithFacebook() async{
    return await _signIn(auth.signInWithFacebook);
  }
  // Future<User> createUserWithEmail(String email, String password){
  //   return await _signIn(auth.loginAnon);
  // }
  // Future<User> signInWithEmail(String email, String password){
  //   return await _signIn(auth.loginAnon);
  // }
  Future<User> loginAnon() async{
   return await _signIn(auth.loginAnon);
  }
}