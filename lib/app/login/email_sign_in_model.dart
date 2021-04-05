
import 'package:flutter/foundation.dart';
import 'package:time_tracker/app/login/validator.dart';
import 'package:time_tracker/services/Authentication.dart';

enum LoginOrRegister {login, register}

class EmailSignInModel with EmailAndPasswordValidator, ChangeNotifier{
  EmailSignInModel({
    this.email="",
    this.password="",
    this.type= LoginOrRegister.login,
    this.isLoading=false,
    this.submitted = false,
    @required this.auth
  });

   String email;
   String password;
   LoginOrRegister type;
   bool isLoading;
   bool submitted;
   final AuthBaseClass auth;

  String get submitButtonText {
    return type == LoginOrRegister.login?"Sign In":"Create an account";
  }
  String get loginOrRegisterText{
    return type == LoginOrRegister.login?"Don't have an account? Register":
    "Have an account? Login here";
  }
  bool get canSubmit{
    return emailValidator.isValid(email)&&
        passwordValidator.isValid(password) &&
        !isLoading;
  }
  String get emailErrorText{
    bool emailValid= submitted && !emailValidator.isValid(email);
    return emailValid?invalidEmailErrorText:null;
  }
  String get passwordErrorText{
    bool passwordValid= submitted && !passwordValidator.isValid(password);
    return passwordValid?invalidPasswordErrorText:null;
  }

  Future<void> submit() async{
    updateWith(submitted: true, isLoading: true);
    try{
      if(this.type==LoginOrRegister.login){
        await auth.signInWithEmail(this.email, this.password);
      }else{
        await auth.createUserWithEmail(this.email, this.password);
      }
    }catch(e){
      updateWith(isLoading: false);
      rethrow;
    }
  }

  void toggleLoginOrRegister(){
    final _type= this.type==LoginOrRegister.login?
        LoginOrRegister.register:LoginOrRegister.login;
    updateWith(
      email: "",
      password: "",
      type: _type,
      isLoading: false,
      submitted: false,
    );
  }

  void updateEmail(String email)=> updateWith(email: email);
  void updatePassword(String password)=> updateWith(password: password);

  void updateWith({String email, String password,
    LoginOrRegister type, bool isLoading, bool submitted})
  {
      this.email= email??this.email;
      this.password= password??this.password;
      this.type= type??this.type;
      this.isLoading= isLoading??this.isLoading;
      this.submitted= submitted??this.submitted;
      notifyListeners();
  }
}