import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/login/email_signin_model.dart';
import 'package:time_tracker/services/Authentication.dart';

class EmailSignInBloc{
  EmailSignInBloc({@required this.auth});
  final AuthBaseClass auth;

  final StreamController<EmailSignInModel> _modelController= StreamController();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel _model= EmailSignInModel();

  void dispose(){
    _modelController.close();
  }

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    try {
      if (_model.type == LoginOrRegister.login) {
        await auth.signInWithEmail(_model.email, _model.password);
      } else {
        await auth.createUserWithEmail(_model.email, _model.password);
      }
    }catch(e){
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void updateWith({String email, String password, LoginOrRegister type, bool isLoading, bool submitted})
  {
    _model.copyWith(
      email: email,
      password: password,
      type: type,
      isLoading: isLoading,
      submitted: submitted
    );
    _modelController.add(_model);
  }

}