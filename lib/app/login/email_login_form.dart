import 'package:flutter/material.dart';
import 'package:time_tracker/app/login/email_loginFormButton.dart';

enum LoginOrRegister {login, register}

class EmailSignInForm extends StatefulWidget {
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  @override
  Widget build(BuildContext context) {

    final _emailController= TextEditingController();
    final _passwordController= TextEditingController();

    LoginOrRegister _type= LoginOrRegister.login;

    void _submit(){

    }

    void _toggleLoginOrRegister(){
      setState(() {
        print("You are a jerk");
        _type= _type == LoginOrRegister.login? LoginOrRegister.register: LoginOrRegister.login;
      });
    }

    List<Widget> _buildChildren(){
      final _mainText= _type == LoginOrRegister.login?"Sign In":"Create an account";
      final _secondaryText= _type ==LoginOrRegister.login?"Don't have an account? Register":"Or Login here";
      return [
        TextField(
          decoration: InputDecoration(
            labelText: "Email",
            hintText: "jdoe@example.com",
          ),
          controller: _emailController,
        ),
        SizedBox(
          height: 8.0,
        ),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: "Password",
          ),
          obscureText: true,
        ),
        SizedBox(
          height: 15.0,
        ),
        SizedBox(
          width: 150.0,
          child: LoginFormButton(
            color: Colors.indigo,
            onPressed: _submit,
            text: _mainText,
            textColor: Colors.white,
            height: 50.0,
            ),
          ),
        TextButton(
            onPressed: _toggleLoginOrRegister,
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
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildChildren(),
      ),
    );
  }
}
