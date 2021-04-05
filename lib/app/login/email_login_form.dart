
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/login/email_loginFormButton.dart';
import 'package:time_tracker/app/login/email_sign_in_model.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';


class EmailSignInForm extends StatefulWidget{
  EmailSignInForm({@required this.model});
  final EmailSignInModel model;

  static Widget create(BuildContext context){
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    return ChangeNotifierProvider<EmailSignInModel>(
      create: (_)=>EmailSignInModel(auth: auth),
      child: Consumer<EmailSignInModel>(
        builder: (_, model, __)=>EmailSignInForm(model: model),
      ),
    );
  }
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController= TextEditingController();
  final FocusNode _emailFocus= FocusNode();
  final TextEditingController _passwordController= TextEditingController();
  final FocusNode _passwordFocus= FocusNode();
  EmailSignInModel get model => widget.model;

  //Remove widgets correctly
  @override
  void dispose(){
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async{
    try {
      await model.submit();
      Navigator.of(context).pop(true);
    }on FirebaseAuthException catch(e){
        showExceptionAlertDialog(context, title: "Sign in Failed", exception: e);
    }
  }

  void _emailEditComplete(){
      final newFocus= model.emailValidator.isValid(model.email)?_passwordFocus:_emailFocus;
      FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleLoginOrRegister(){
    model.toggleLoginOrRegister();
    _emailController.clear();
    _passwordController.clear();
  }

  List<Widget> _buildChildren(){
    return [
      _buildEmailTextField(),
      SizedBox(height: 8.0),
      _buildPasswordTextField(),
      SizedBox(height: 15.0),
      LoginFormButton(
        color: Colors.indigo,
        onPressed: model.canSubmit?_submit:null,
        text: model.submitButtonText,
        textColor: Colors.white,
        height: 50.0,
      ),
      SizedBox(height: 8.0),
      TextButton(
        onPressed: model.isLoading? null: _toggleLoginOrRegister,
        child: Text(model.loginOrRegisterText,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 16.0,
          ),
        ),
      ),
    ];
  }

  TextField _buildPasswordTextField() {
    return TextField(
      controller: _passwordController,
      decoration: InputDecoration(
        labelText: "Password",
        enabled: model.isLoading==false,
        errorText: model.passwordErrorText,
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      focusNode: _passwordFocus,
      onChanged: model.updatePassword,
    );
  }

  TextField _buildEmailTextField() {
    return TextField(
      decoration: InputDecoration(
        labelText: "Email",
        hintText: "jdoe@example.com",
        enabled: model.isLoading==false,
        errorText: model.emailErrorText,
      ),
      controller: _emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditComplete,
      focusNode: _emailFocus,
      onChanged: model.updateEmail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
