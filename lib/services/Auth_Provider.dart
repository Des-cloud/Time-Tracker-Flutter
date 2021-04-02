import 'package:flutter/material.dart';
import 'package:time_tracker/services/Authentication.dart';

class AuthProvider extends InheritedWidget{
  AuthProvider({@required this.auth, @required this.child});
  final AuthBaseClass auth;
  final Widget child;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return false;
  }

  static AuthBaseClass of(BuildContext context){
    AuthProvider provider= context.dependOnInheritedWidgetOfExactType<AuthProvider>();
    return provider.auth;
  }
}