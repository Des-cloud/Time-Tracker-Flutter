
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/login/email_loginFormButton.dart';
import 'package:time_tracker/app/login/validator.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';

enum LoginOrRegister {login, register}

class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator{

  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final _emailController= TextEditingController();
  String get _email=> _emailController.text;
  final _emailFocus= FocusNode();

  final _passwordController= TextEditingController();
  String get _password=> _passwordController.text;
  final _passwordFocus= FocusNode();

  LoginOrRegister _type= LoginOrRegister.login;

  bool _submitted= false;
  bool _isLoading= false;

  //Remove widgets correctly
  @override
  void dispose(){
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() async{
    setState(() {
      _submitted= true;
      _isLoading= true;
    });
    try {
      final auth= Provider.of<AuthBaseClass>(context, listen: false);
      if (_type == LoginOrRegister.login) {
        await auth.signInWithEmail(_email, _password);
      } else {
        await auth.createUserWithEmail(_email, _password);
      }
      Navigator.pop(context);
    }on FirebaseAuthException catch(e){
        showExceptionAlertDialog(context, title: "Sign in Failed", exception: e);
    }finally{
      setState(() {
        _isLoading= false;
      });
    }
  }

  void _emailEditComplete(){
      final newFocus= widget.emailValidator.isValid(_email)?_passwordFocus:_emailFocus;
      FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleLoginOrRegister(){
    setState(() {
      _submitted= false;
      _type= _type == LoginOrRegister.login? LoginOrRegister.register: LoginOrRegister.login;
    });
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _buildChildren(){
      final _mainText= _type == LoginOrRegister.login?"Sign In":"Create an account";
      final _secondaryText= _type ==LoginOrRegister.login?"Don't have an account? Register":"Have an account? Login here";

      bool enableSubmit= widget.emailValidator.isValid(_email)&&
        widget.passwordValidator.isValid(_password) &&
        !_isLoading;

      return [
        _buildEmailTextField(),
        SizedBox(
          height: 8.0,
        ),
        _buildPasswordTextField(),
        SizedBox(
          height: 15.0,
        ),
        SizedBox(
          // width: 150.0,
          child: LoginFormButton(
            color: Colors.indigo,
            onPressed: enableSubmit?_submit:null,
            text: _mainText,
            textColor: Colors.white,
            height: 50.0,
            ),
          ),
        TextButton(
            onPressed: _isLoading? null: _toggleLoginOrRegister,
            child: Text(_secondaryText,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
            ),
        ),
      ];
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }

  TextField _buildPasswordTextField() {
    bool passwordValid= _submitted && !widget.passwordValidator.isValid(_password);
    return TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "Password",
          enabled: _isLoading?false: true,
          errorText: passwordValid ? widget.invalidPasswordErrorText: null,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        focusNode: _passwordFocus,
        onChanged: (_password)=>updateState(),
      );
  }

  TextField _buildEmailTextField() {
    bool emailValid= _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "jdoe@example.com",
          enabled: _isLoading?false:true,
          errorText: emailValid?widget.invalidEmailErrorText:null,
        ),
        controller: _emailController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: _emailEditComplete,
        focusNode: _emailFocus,
        onChanged: (_email)=>updateState(),
      );
  }

  updateState() {
    setState(() {});
  }
}
