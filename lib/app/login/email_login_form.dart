
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker/app/login/email_loginFormButton.dart';
import 'package:time_tracker/app/login/email_signin_bloc.dart';
import 'package:time_tracker/app/login/email_signin_model.dart';
import 'package:time_tracker/app/login/validator.dart';
import 'package:time_tracker/services/Authentication.dart';
import 'package:time_tracker/widgets/showExceptionAlertDialog.dart';


class EmailSignInForm extends StatefulWidget with EmailAndPasswordValidator{
  EmailSignInForm({@required this.bloc});
  final EmailSignInBloc bloc;

  static Widget create(BuildContext context){
    final auth= Provider.of<AuthBaseClass>(context, listen: false);
    return Provider<EmailSignInBloc>(
      create: (_)=>EmailSignInBloc(auth: auth),
      child: Consumer(
        builder: (_, bloc, __)=>EmailSignInForm(bloc: bloc),
      ),
      dispose: (_, bloc)=>bloc.dispose(),
    );
  }
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {

  final _emailController= TextEditingController();
  final _emailFocus= FocusNode();

  final _passwordController= TextEditingController();
  final _passwordFocus= FocusNode();


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
    try {
      await widget.bloc.submit();
      Navigator.pop(context);
    }on FirebaseAuthException catch(e){
        showExceptionAlertDialog(context, title: "Sign in Failed", exception: e);
    }
  }

  void _emailEditComplete(EmailSignInModel model){
      final newFocus= widget.emailValidator.isValid(model.email)?_passwordFocus:_emailFocus;
      FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleLoginOrRegister(EmailSignInModel model){
    widget.bloc.updateWith(
        email: "",
        password: "",
        isLoading: false,
        submitted: false,
        type: model.type== LoginOrRegister.login? LoginOrRegister.register: LoginOrRegister.login
    );
    _emailController.clear();
    _passwordController.clear();
  }

  @override
  Widget build(BuildContext context) {

    List<Widget> _buildChildren(EmailSignInModel model){
      final _mainText= model.type == LoginOrRegister.login?"Sign In":"Create an account";
      final _secondaryText= model.type ==LoginOrRegister.login?"Don't have an account? Register":"Have an account? Login here";

      bool enableSubmit= widget.emailValidator.isValid(model.email)&&
        widget.passwordValidator.isValid(model.password) &&
        !model.isLoading;

      return [
        _buildEmailTextField(model),
        SizedBox(
          height: 8.0,
        ),
        _buildPasswordTextField(model),
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
            onPressed: model.isLoading? null: ()=>_toggleLoginOrRegister(model),
            child: Text(_secondaryText,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16.0,
                ),
            ),
        ),
      ];
    }

    return StreamBuilder<EmailSignInModel>(
      stream: widget.bloc.modelStream,
      initialData: EmailSignInModel(),
      builder: (context, snapshot) {
        final EmailSignInModel model= snapshot.data;
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: _buildChildren(model),
          ),
        );
      }
    );
  }

  TextField _buildPasswordTextField(EmailSignInModel model) {
    bool passwordValid= model.submitted && !widget.passwordValidator.isValid(model.password);
    return TextField(
        controller: _passwordController,
        decoration: InputDecoration(
          labelText: "Password",
          enabled: model.isLoading?false: true,
          errorText: passwordValid ? widget.invalidPasswordErrorText: null,
        ),
        obscureText: true,
        textInputAction: TextInputAction.done,
        onEditingComplete: _submit,
        focusNode: _passwordFocus,
        onChanged: (password)=>widget.bloc.updateWith(password: model.password),
      );
  }

  TextField _buildEmailTextField(EmailSignInModel model) {
    bool emailValid= model.submitted && !widget.emailValidator.isValid(model.email);
    return TextField(
        decoration: InputDecoration(
          labelText: "Email",
          hintText: "jdoe@example.com",
          enabled: model.isLoading?false:true,
          errorText: emailValid?widget.invalidEmailErrorText:null,
        ),
        controller: _emailController,
        autocorrect: false,
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.next,
        onEditingComplete: ()=>_emailEditComplete(model),
        focusNode: _emailFocus,
        onChanged: (email)=>widget.bloc.updateWith(email:model.email),
      );
  }

}
