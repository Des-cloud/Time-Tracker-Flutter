import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/login/email_sign_in_model.dart';
import 'package:time_tracker/services/Authentication.dart';

class EmailSignInBloc{
  EmailSignInBloc({@required this.auth});
  final AuthBaseClass auth;

  final StreamController<EmailSignInModel> _modelController=
      StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;
  EmailSignInModel model= EmailSignInModel();

  void dispose(){
    _modelController.close();
  }

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    try {
      if (model.type == LoginOrRegister.login) {
        await auth.signInWithEmail(model.email, model.password);
      } else {
        await auth.createUserWithEmail(model.email, model.password);
      }
    }catch(e){
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleLoginOrRegister(){
    final type= model.type== LoginOrRegister.login? LoginOrRegister.register: LoginOrRegister.login;
    updateWith(
        email: "",
        password: "",
        isLoading: false,
        submitted: false,
        type: type,
    );
  }

  void updateWith({String email, String password, LoginOrRegister type, bool isLoading, bool submitted})
  {
    model.copyWith(
      email: email,
      password: password,
      type: type,
      isLoading: isLoading,
      submitted: submitted
    );
    _modelController.add(model);
  }
}